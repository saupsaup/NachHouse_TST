"use strict";

const {performance} = require("node:perf_hooks");
const crypto = require("node:crypto");
const {spawnSync} = require("node:child_process");
const WebSocket = require("/Users/pambm3/NachHouse_APP/ROOMS_BROWSER_V0.5.73/node_modules/ws");

global.WebSocket = WebSocket;
global.performance = performance;
if (!global.crypto) Object.defineProperty(global, "crypto", {value: crypto.webcrypto});
if (!global.CustomEvent) global.CustomEvent = class CustomEvent extends Event {
  constructor(type, init = {}) { super(type); this.detail = init.detail; }
};
require("/Users/pambm3/NachHouse_APP/ROOMS_BROWSER_V0.5.73/nh-api-v11.js");

const host = process.env.NH_PLC_HOST || "192.168.33.200";
const cases = [
  {variable: "NHRXTEST80", requestedLength: 80},
  {variable: "NHRXTEST81", requestedLength: 81},
  {variable: "NHRXTEST82", requestedLength: 82},
  {variable: "NHRXTEST127", requestedLength: 127},
  {variable: "NHRXTEST128", requestedLength: 128},
  {variable: "NHRXTEST129", requestedLength: 129},
  {variable: "NHRXTEST160", requestedLength: 160},
  {variable: "NHRXTEST192", requestedLength: 192},
  {variable: "NHRXTEST224", requestedLength: 224},
  {variable: "NHRXTEST240", requestedLength: 240},
  {variable: "NHRXTEST241", requestedLength: 241},
  {variable: "NHRXTEST242", requestedLength: 242},
  {variable: "NHRXTEST243", requestedLength: 243},
  {variable: "NHRXTEST244", requestedLength: 244},
  {variable: "NHRXTEST245", requestedLength: 245},
  {variable: "NHRXTEST246", requestedLength: 246},
  {variable: "NHRXTEST247", requestedLength: 247},
  {variable: "NHRXTEST248", requestedLength: 248},
  {variable: "NHRXTEST252", requestedLength: 252},
  {variable: "NHRXTEST253", requestedLength: 253},
  {variable: "NHRXTEST254", requestedLength: 254},
  {variable: "NHRXTEST", requestedLength: 254},
  {variable: "NHRXTEST", requestedLength: 255}
];
const delay = ms => new Promise(resolve => setTimeout(resolve, ms));

async function webLogin() {
  const result = spawnSync("security", ["find-generic-password", "-s", `NachHouse PLC ${host} deployment`, "-w"], {encoding: "utf8"});
  if (result.status !== 0 || !result.stdout.trim()) throw new Error("PLC password is not available in Keychain");
  const password = result.stdout.trim();
  let cookie = "";
  async function request(path, options = {}) {
    const response = await fetch(`http://${host}${path}`, {redirect: "manual", headers: {...options.headers, ...(cookie ? {Cookie: cookie} : {})}, ...options});
    const setCookie = response.headers.get("set-cookie");
    if (setCookie) cookie = setCookie.split(";")[0];
    return response;
  }
  await request("/NACHHOUSE/");
  const nonce = cookie.split("=")[1];
  if (!nonce) throw new Error("PLC login nonce is missing");
  const pass = crypto.createHash("sha1").update(nonce + password).digest("hex");
  const response = await request("/SYSWWW/LOGIN.XML", {method: "POST", headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: new URLSearchParams({USER: "a", PASS: pass})});
  if (![200, 302].includes(response.status)) throw new Error(`PLC web login failed: ${response.status}`);
}

function testValue(length) {
  const alphabet = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
  let value = "";
  while (value.length < length) value += alphabet;
  return value.slice(0, length);
}

(async () => {
  await webLogin();
  const Client = global.NhApiV11.Client;
  const client = new Client({url: `wss://${host}:5030/`, websocketOptions: {rejectUnauthorized: false}, gatewayLock: false});
  try {
    await client.connect();
    const names = [...new Set(cases.map(item => item.variable))];
    const initial = await client.get(names);
    const originals = Object.fromEntries(names.map(name => [name, String(initial[name]) ]));
    const results = [];
    try {
      for (const item of cases) {
        const expected = testValue(item.requestedLength);
        client.set([[item.variable, "STRING", expected]]);
        await delay(180);
        const actual = String((await client.get([item.variable]))[item.variable]);
        results.push({
          variable: item.variable,
          requestedLength: item.requestedLength,
          receivedLength: actual.length,
          identical: actual === expected,
          receivedTail: actual.slice(-12)
        });
      }
      console.log(JSON.stringify({measurement: {host, results}}, null, 2));
    } finally {
      for (const name of names) {
        client.set([[name, "STRING", ""]]);
        await delay(180);
      }
      const restored = await client.get(names);
      if (names.some(name => String(restored[name]) !== "")) {
        throw new Error(`Original test values were not restored: ${JSON.stringify(Object.fromEntries(names.map(name => [name, String(restored[name]).length])))}`);
      }
    }
    console.log(JSON.stringify({host, originals: Object.fromEntries(names.map(name => [name, originals[name].length])), results, cleaned: true}, null, 2));
    if (results.some(result => !result.identical)) process.exitCode = 2;
  } finally {
    client.close();
  }
})().catch(error => {
  console.error(error.stack || error.message);
  process.exitCode = 1;
});
