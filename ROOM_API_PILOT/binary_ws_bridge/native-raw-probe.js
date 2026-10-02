"use strict";
const crypto = require("node:crypto");
const tls = require("node:tls");
const host = process.env.PLC_HOST || "192.168.43.201";
const port = Number(process.env.PLC_WSS_PORT || 5030);
const key = crypto.randomBytes(16).toString("base64");
const request = process.env.ACK_REVISION ? JSON.stringify({ cmd: "set", data: {
  "NHAPICLIENTS[0].ACKTXREVISION": { dt: "UDINT", val: Number(process.env.ACK_REVISION) },
  "NHAPICLIENTS[0].REQUESTEDCLIENTID": { dt: "UDINT", val: 0 }
} }) : JSON.stringify({ cmd: "get", data: ["NHAPITXBUFFER[0]"] });

function maskedText(text) {
  const payload = Buffer.from(text), mask = crypto.randomBytes(4);
  const header = payload.length < 126 ? Buffer.from([0x81, 0x80 | payload.length]) : Buffer.from([0x81, 0xfe, payload.length >> 8, payload.length & 255]);
  const body = Buffer.alloc(payload.length);
  for (let i = 0; i < payload.length; i += 1) body[i] = payload[i] ^ mask[i % 4];
  return Buffer.concat([header, mask, body]);
}

const socket = tls.connect({ host, port, rejectUnauthorized: false }, () => socket.write(
  `GET / HTTP/1.1\r\nHost: ${host}:${port}\r\nUpgrade: websocket\r\nConnection: Upgrade\r\n` +
  `Sec-WebSocket-Key: ${key}\r\nSec-WebSocket-Version: 13\r\nSec-WebSocket-Protocol: raw\r\n\r\n`
));
let handshakeDone = false, received = Buffer.alloc(0);
socket.on("data", chunk => {
  received = Buffer.concat([received, chunk]);
  if (!handshakeDone) {
    const at = received.indexOf("\r\n\r\n"); if (at < 0) return;
    const head = received.subarray(0, at).toString("ascii");
    if (!head.startsWith("HTTP/1.1 101")) throw new Error(head.split("\r\n")[0]);
    console.log("Handshake: 101, subprotocol raw");
    received = received.subarray(at + 4); handshakeDone = true; socket.write(maskedText(request));
  }
  if (received.length >= 2) {
    const opcode = received[0] & 15;
    console.log(`First response opcode: ${opcode} (${opcode === 1 ? "text" : opcode === 2 ? "binary" : "control"})`);
    socket.end();
  }
});
socket.setTimeout(10000, () => { console.error("Probe timeout"); socket.destroy(); process.exitCode = 1; });
socket.on("error", error => { console.error(error.message); process.exitCode = 1; });
