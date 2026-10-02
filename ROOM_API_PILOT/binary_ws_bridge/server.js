"use strict";

const crypto = require("node:crypto");
const fs = require("node:fs");
const http = require("node:http");
const net = require("node:net");
const path = require("node:path");

const config = {
  webHost: process.env.BRIDGE_HOST || "127.0.0.1",
  webPort: Number(process.env.BRIDGE_PORT || 8765),
  plcHost: process.env.PLC_HOST || "192.168.43.201",
  plcPort: Number(process.env.PLC_PORT || 5010),
  infoAddress: process.env.PLC_INFO_ADDRESS || "NhApiInfo.ProtocolVersion",
  infoLength: 27,
  txAddress: process.env.PLC_TX_ADDRESS || "NhApiTxBuffer[0]",
  txCapacity: Number(process.env.PLC_TX_CAPACITY || 2048),
  pollMs: Number(process.env.PLC_POLL_MS || 250),
  timeoutMs: Number(process.env.PLC_TIMEOUT_MS || 10000),
};

const publicDir = path.join(__dirname, "public");
const clients = new Set();
let lastPublishedRevision = null;
let pollBusy = false;

function readGetMem(address, length) {
  return new Promise((resolve, reject) => {
    const socket = net.createConnection({ host: config.plcHost, port: config.plcPort });
    // PLCComS normalizes symbolic names to uppercase in its response.
    const responseAddress = address.toUpperCase();
    const prefix = Buffer.from(`GETMEM:${responseAddress}[${length}]=`);
    const suffix = Buffer.from(`\r\nGETMEM:${responseAddress}[0]=\r\n`);
    let received = Buffer.alloc(0);
    let done = false;

    const finish = (error, payload) => {
      if (done) return;
      done = true;
      socket.destroy();
      error ? reject(error) : resolve(payload);
    };

    socket.setTimeout(config.timeoutMs);
    socket.setNoDelay(true);
    socket.on("connect", () => socket.write(`GETMEM:${address} ${length}\n`));
    socket.on("data", (chunk) => {
      received = Buffer.concat([received, chunk]);
      if (received.length > length + 512) return finish(new Error("GETMEM response too large"));
      const prefixAt = received.indexOf(prefix);
      if (prefixAt < 0) return;
      const payloadAt = prefixAt + prefix.length;
      const suffixAt = payloadAt + length;
      if (received.length < suffixAt + suffix.length) return;
      if (!received.subarray(suffixAt, suffixAt + suffix.length).equals(suffix)) {
        return finish(new Error("Invalid GETMEM terminator"));
      }
      finish(null, Buffer.from(received.subarray(payloadAt, suffixAt)));
    });
    socket.on("timeout", () => finish(new Error("GETMEM timeout")));
    socket.on("error", (error) => finish(error));
    socket.on("end", () => finish(new Error("PLCComS closed early")));
  });
}

function crc32(frame) {
  let crc = 0xffffffff;
  for (let index = 0; index < frame.length; index += 1) {
    const value = index >= 60 && index < 64 ? 0 : frame[index];
    crc ^= value;
    for (let bit = 0; bit < 8; bit += 1) crc = (crc >>> 1) ^ ((crc & 1) ? 0xedb88320 : 0);
  }
  return (crc ^ 0xffffffff) >>> 0;
}

function validateFrame(frame, expectedRevision, expectedLength) {
  if (frame.length < 64) throw new Error("NHAP frame shorter than 64-byte header");
  if (frame.toString("ascii", 0, 4) !== "NHAP") throw new Error("Invalid NHAP magic");
  if (frame.readUInt16LE(6) !== 64) throw new Error("Invalid NHAP header size");
  if (frame.readUInt32LE(56) !== expectedLength) throw new Error("NHAP TotalSize mismatch");
  if (frame.readUInt32LE(24) !== expectedRevision) throw new Error("TX revision mismatch");
  const storedCrc = frame.readUInt32LE(60);
  const actualCrc = crc32(frame);
  if (storedCrc !== actualCrc) throw new Error(`CRC32 mismatch: ${storedCrc} != ${actualCrc}`);
}

function websocketFrame(opcode, payload = Buffer.alloc(0)) {
  const size = payload.length;
  let header;
  if (size < 126) header = Buffer.from([0x80 | opcode, size]);
  else if (size <= 0xffff) {
    header = Buffer.alloc(4); header[0] = 0x80 | opcode; header[1] = 126; header.writeUInt16BE(size, 2);
  } else {
    header = Buffer.alloc(10); header[0] = 0x80 | opcode; header[1] = 127; header.writeBigUInt64BE(BigInt(size), 2);
  }
  return Buffer.concat([header, payload]);
}

function send(socket, opcode, payload) {
  if (!socket.destroyed && socket.writable) socket.write(websocketFrame(opcode, payload));
}

function broadcastBinary(frame) {
  const packet = websocketFrame(2, frame);
  for (const socket of clients) if (!socket.destroyed && socket.writable) socket.write(packet);
  console.log(`WS binary: ${frame.length} B, revision ${frame.readUInt32LE(24)}, clients ${clients.size}`);
}

async function pollPlc() {
  if (pollBusy || clients.size === 0) return;
  pollBusy = true;
  try {
    const info = await readGetMem(config.infoAddress, config.infoLength);
    const revision = info.readUInt32LE(16);
    const byteLength = info.readUInt16LE(20);
    const txState = info[22];
    if (txState !== 2 || revision === lastPublishedRevision) return;
    if (byteLength < 64 || byteLength > config.txCapacity) throw new Error(`Invalid TxByteLength ${byteLength}`);
    const frame = await readGetMem(config.txAddress, byteLength);
    validateFrame(frame, revision, byteLength);
    broadcastBinary(frame);
    lastPublishedRevision = revision;
  } catch (error) {
    console.error("PLC poll:", error.message);
  } finally {
    pollBusy = false;
  }
}

function acceptWebSocket(request, socket) {
  if (request.url !== "/ws" || request.headers.upgrade?.toLowerCase() !== "websocket") return socket.destroy();
  const key = request.headers["sec-websocket-key"];
  if (!key) return socket.destroy();
  const accept = crypto.createHash("sha1").update(key + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11").digest("base64");
  socket.write("HTTP/1.1 101 Switching Protocols\r\nUpgrade: websocket\r\nConnection: Upgrade\r\n" +
    `Sec-WebSocket-Accept: ${accept}\r\n\r\n`);
  clients.add(socket);
  socket.on("data", (data) => {
    const opcode = data[0] & 0x0f;
    if (opcode === 8) socket.end(websocketFrame(8));
    else if (opcode === 9) send(socket, 10, Buffer.alloc(0));
  });
  const remove = () => clients.delete(socket);
  socket.on("close", remove); socket.on("end", remove); socket.on("error", remove);
  void pollPlc();
}

const server = http.createServer((request, response) => {
  const fileName = request.url === "/" ? "index.html" : request.url === "/native-probe.html" ? "native-probe.html" : null;
  if (!fileName) { response.writeHead(404).end("Not found"); return; }
  fs.readFile(path.join(publicDir, fileName), (error, data) => {
    if (error) { response.writeHead(500).end("Cannot read page"); return; }
    response.writeHead(200, { "Content-Type": "text/html; charset=utf-8", "Cache-Control": "no-store" });
    response.end(data);
  });
});

server.on("upgrade", acceptWebSocket);
const timer = setInterval(pollPlc, config.pollMs); timer.unref();
server.listen(config.webPort, config.webHost, () => {
  console.log(`Binary WS bridge: http://${config.webHost}:${config.webPort}`);
  console.log(`PLC: ${config.plcHost}:${config.plcPort}, info ${config.infoAddress}, TX ${config.txAddress}`);
});

module.exports = { crc32, readGetMem, validateFrame, websocketFrame };
