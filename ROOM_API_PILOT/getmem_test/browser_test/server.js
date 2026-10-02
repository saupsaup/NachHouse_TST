"use strict";

const http = require("node:http");
const net = require("node:net");
const fs = require("node:fs");
const path = require("node:path");

const WEB_HOST = "127.0.0.1";
const WEB_PORT = 8765;
const PLC_HOST = "192.168.33.200";
const PLC_PORT = 5010;
const PLC_ADDRESS = "%R1000";
const READ_LENGTH = 1000;
const READ_TIMEOUT_MS = 8000;

const publicDir = path.join(__dirname, "public");
const getMemPrefix = Buffer.from(`GETMEM:${PLC_ADDRESS}[${READ_LENGTH}]=`);
const getMemEnd = Buffer.from(`\r\nGETMEM:${PLC_ADDRESS}[0]=\r\n`);
let readInProgress = false;

function readGetMem() {
  return new Promise((resolve, reject) => {
    const socket = net.createConnection({ host: PLC_HOST, port: PLC_PORT });
    let received = Buffer.alloc(0);
    let finished = false;

    const finish = (error, payload) => {
      if (finished) return;
      finished = true;
      socket.destroy();
      if (error) reject(error);
      else resolve(payload);
    };

    socket.setTimeout(READ_TIMEOUT_MS);
    socket.setNoDelay(true);

    socket.on("connect", () => {
      socket.write(`GETMEM:${PLC_ADDRESS} ${READ_LENGTH}\n`);
    });

    socket.on("data", (chunk) => {
      received = Buffer.concat([received, chunk]);

      if (received.length > READ_LENGTH + 256) {
        finish(new Error("PLCComS response is larger than expected"));
        return;
      }

      const start = received.indexOf(getMemPrefix);
      if (start < 0) return;

      const payloadStart = start + getMemPrefix.length;
      const payloadEnd = payloadStart + READ_LENGTH;
      const responseEnd = payloadEnd + getMemEnd.length;
      if (received.length < responseEnd) return;

      const actualEnd = received.subarray(payloadEnd, responseEnd);
      if (!actualEnd.equals(getMemEnd)) {
        finish(new Error("PLCComS GETMEM terminator is invalid"));
        return;
      }

      finish(null, received.subarray(payloadStart, payloadEnd));
    });

    socket.on("timeout", () => finish(new Error("PLCComS GETMEM timed out")));
    socket.on("error", (error) => finish(error));
    socket.on("end", () => {
      if (!finished) finish(new Error("PLCComS closed the connection early"));
    });
  });
}

function sendFile(response, fileName, contentType) {
  fs.readFile(path.join(publicDir, fileName), (error, data) => {
    if (error) {
      response.writeHead(500, { "Content-Type": "text/plain; charset=utf-8" });
      response.end("Cannot read test page.");
      return;
    }

    response.writeHead(200, {
      "Content-Type": contentType,
      "Content-Length": data.length,
      "Cache-Control": "no-store",
    });
    response.end(data);
  });
}

const server = http.createServer(async (request, response) => {
  if (request.method === "GET" && request.url === "/") {
    sendFile(response, "index.html", "text/html; charset=utf-8");
    return;
  }

  if (request.method === "GET" && request.url === "/api/getmem") {
    if (readInProgress) {
      response.writeHead(429, { "Content-Type": "application/json; charset=utf-8" });
      response.end(JSON.stringify({ error: "GETMEM read already in progress" }));
      return;
    }

    readInProgress = true;
    try {
      const payload = await readGetMem();
      response.writeHead(200, {
        "Content-Type": "application/octet-stream",
        "Content-Length": payload.length,
        "Cache-Control": "no-store",
        "X-GetMem-Address": PLC_ADDRESS,
      });
      response.end(payload);
    } catch (error) {
      console.error("GETMEM failed:", error.message);
      response.writeHead(502, { "Content-Type": "application/json; charset=utf-8" });
      response.end(JSON.stringify({ error: error.message }));
    } finally {
      readInProgress = false;
    }
    return;
  }

  response.writeHead(404, { "Content-Type": "text/plain; charset=utf-8" });
  response.end("Not found.");
});

server.listen(WEB_PORT, WEB_HOST, () => {
  console.log(`GETMEM browser test: http://${WEB_HOST}:${WEB_PORT}`);
  console.log(`Fixed PLC read: GETMEM:${PLC_ADDRESS} ${READ_LENGTH}`);
});
