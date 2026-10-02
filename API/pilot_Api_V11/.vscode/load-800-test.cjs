"use strict";

const path = require("node:path");
const {performance} = require("node:perf_hooks");
const W = require(process.env.NH_WS_MODULE || "/Users/pambm3/NachHouse_APP/ROOMS_BROWSER_V0.5.73/node_modules/ws");

const host = process.env.NH_PLC_HOST || "192.168.33.200";
const url = `wss://${host}:5030/`;
const DEVICE_COUNT = 800;
const CHANGED_COUNT = 640;
const delay = ms => new Promise(resolve => setTimeout(resolve, ms));
const percentile = (values, p) => {
  const sorted = [...values].sort((a, b) => a - b);
  return sorted[Math.max(0, Math.ceil(sorted.length * p) - 1)] || 0;
};

function normalValue(index) {
  if (index <= 300) return 0x01000064;
  if (index <= 420) return 0x02000064;
  if (index <= 520) return 0x030000d2;
  if (index <= 600) return 0x040000dc;
  if (index <= 640) return 0x05000001;
  return (0x06000000 | (index % 256)) >>> 0;
}

function awayValue(index) {
  if (index <= 300) return 0x01000000;
  if (index <= 420) return 0x02000000;
  if (index <= 520) return 0x030000aa;
  if (index <= 600) return 0x040000b4;
  if (index <= 640) return 0x05000000;
  return normalValue(index);
}

class PlcClient {
  constructor(name) {
    this.name = name;
    this.values = new Map();
    this.pending = [];
    this.capture = null;
  }

  async connect() {
    this.ws = new W(url, "raw", {rejectUnauthorized: false});
    await new Promise((resolve, reject) => {
      const timer = setTimeout(() => reject(new Error(`${this.name}: connect timeout`)), 10000);
      this.ws.once("open", () => { clearTimeout(timer); resolve(); });
      this.ws.once("error", reject);
    });
    this.ws.on("message", bytes => this.receive(bytes));
  }

  receive(bytes) {
    let message;
    try { message = JSON.parse(bytes.toString()); } catch { return; }
    for (const field of ["get", "diff"]) {
      if (!message[field]) continue;
      for (const [name, item] of Object.entries(message[field])) {
        const value = item && Object.prototype.hasOwnProperty.call(item, "val") ? item.val : item;
        this.values.set(name, value);
        const match = /^NHLOADDEVICES\[(\d+)]$/.exec(name);
        if (field === "diff" && match && this.capture) {
          const now = performance.now();
          if (!this.capture.first) this.capture.first = now;
          this.capture.last = now;
          this.capture.indices.add(Number(match[1]));
          this.capture.messages += 1;
        }
      }
      if (field === "get") this.resolveGets(message.get);
    }
  }

  resolveGets(values) {
    for (const request of [...this.pending]) {
      if (!request.names.every(name => Object.prototype.hasOwnProperty.call(values, name))) continue;
      clearTimeout(request.timer);
      this.pending = this.pending.filter(item => item !== request);
      request.resolve(Object.fromEntries(request.names.map(name => [name, values[name].val])));
    }
  }

  get(names, timeout = 10000) {
    return new Promise((resolve, reject) => {
      const request = {names, resolve, reject};
      request.timer = setTimeout(() => {
        this.pending = this.pending.filter(item => item !== request);
        reject(new Error(`${this.name}: GET timeout ${names[0]}`));
      }, timeout);
      this.pending.push(request);
      this.ws.send(JSON.stringify({cmd: "get", data: names}));
    });
  }

  set(data) { this.ws.send(JSON.stringify({cmd: "set", data})); }

  async subscribeDevices() {
    for (let start = 1; start <= DEVICE_COUNT; start += 40) {
      const names = Array.from({length: Math.min(40, DEVICE_COUNT - start + 1)}, (_, i) => `NHLOADDEVICES[${start + i}]`);
      await this.get(names);
    }
    await this.get(["NHLOADTEST.SEQUENCE", "NHLOADTEST.DEPARTUREACTIVE", "NHLOADTEST.LASTCHANGEDCOUNT", "NHLOADTEST.LASTAPPLYMS", "NHAPIINFO.STATE", "NHAPIINFO.OWNERCLIENTID"]);
  }

  startCapture(started) { this.capture = {started, first: 0, last: 0, indices: new Set(), messages: 0}; }
  stopCapture() { const value = this.capture; this.capture = null; return value; }
  close() { if (this.ws) this.ws.close(); }
}

async function readSequence(client) {
  const data = await client.get(["NHLOADTEST.SEQUENCE"]);
  return Number(data["NHLOADTEST.SEQUENCE"]);
}

async function triggerScene(client, away) {
  const sequence = await readSequence(client);
  const started = performance.now();
  client.set({
    "NHAPITEST.PRESENCE": {dt: "BOOL", val: away},
    "NHAPITEST.ACTION": {dt: "USINT", val: 7}
  });
  await delay(80);
  client.set({"NHAPITEST.EXECUTE": {dt: "BOOL", val: true}});
  const deadline = performance.now() + 15000;
  while (performance.now() < deadline) {
    const state = await client.get(["NHLOADTEST.SEQUENCE", "NHLOADTEST.DEPARTUREACTIVE", "NHLOADTEST.LASTCHANGEDCOUNT", "NHLOADTEST.LASTAPPLYMS", "NHAPIINFO.STATE", "NHAPIINFO.OWNERCLIENTID"]);
    if (Number(state["NHLOADTEST.SEQUENCE"]) > sequence && Boolean(state["NHLOADTEST.DEPARTUREACTIVE"]) === away) {
      return {started, completed: performance.now(), plcApplyMs: Number(state["NHLOADTEST.LASTAPPLYMS"]), changed: Number(state["NHLOADTEST.LASTCHANGEDCOUNT"])};
    }
    await delay(50);
  }
  throw new Error(`scene ${away ? "away" : "restore"} timeout`);
}

async function verifyDevices(client, away) {
  let wrong = 0;
  for (let start = 1; start <= DEVICE_COUNT; start += 40) {
    const names = Array.from({length: Math.min(40, DEVICE_COUNT - start + 1)}, (_, i) => `NHLOADDEVICES[${start + i}]`);
    const values = await client.get(names);
    for (let i = 0; i < names.length; i += 1) {
      const index = start + i;
      const expected = away ? awayValue(index) : normalValue(index);
      if ((Number(values[names[i]]) >>> 0) !== expected) wrong += 1;
    }
  }
  if (wrong) throw new Error(`${wrong} device values differ from ${away ? "away" : "normal"} model`);
}

async function heavyScenario(controller, observer, joinDelayMs) {
  await verifyDevices(controller, false);
  const started = performance.now();
  controller.startCapture(started); observer.startCapture(started);
  const scenePromise = triggerScene(controller, true);
  console.log(`MESSAGE: zamykam... sent to 5 logical clients; 2 connect after ${joinDelayMs} ms`);
  await delay(joinDelayMs);
  const lateA = new PlcClient(`late-A-${joinDelayMs}`), lateB = new PlcClient(`late-B-${joinDelayMs}`);
  await Promise.all([lateA.connect(), lateB.connect()]);
  await Promise.all([lateA.subscribeDevices(), lateB.subscribeDevices()]);
  const scene = await scenePromise;
  await verifyDevices(controller, true);
  await verifyDevices(lateA, true); await verifyDevices(lateB, true);
  await delay(350);
  const captures = [controller.stopCapture(), observer.stopCapture()];
  if (captures.some(item => item.indices.size !== CHANGED_COUNT)) throw new Error(`incomplete away diff: ${captures.map(item => item.indices.size).join(",")}`);
  const restoreStarted = performance.now();
  controller.startCapture(restoreStarted); observer.startCapture(restoreStarted);
  const restore = await triggerScene(controller, false);
  await verifyDevices(controller, false);
  await delay(350);
  const restoreCaptures = [controller.stopCapture(), observer.stopCapture()];
  if (restoreCaptures.some(item => item.indices.size !== CHANGED_COUNT)) throw new Error(`incomplete restore diff: ${restoreCaptures.map(item => item.indices.size).join(",")}`);
  lateA.close(); lateB.close();
  return {
    joinDelayMs,
    commandMs: scene.completed - scene.started,
    plcApplyMs: scene.plcApplyMs,
    changed: scene.changed,
    observerUnique: captures.map(item => item.indices.size),
    firstDiffMs: captures.map(item => item.first ? item.first - item.started : null),
    lastDiffMs: captures.map(item => item.last ? item.last - item.started : null),
    restoreMs: restore.completed - restore.started,
    restoreUnique: restoreCaptures.map(item => item.indices.size)
  };
}

function installBrowserClient() {
  global.WebSocket = W;
  global.performance = performance;
  if (!global.crypto) Object.defineProperty(global, "crypto", {value: require("node:crypto").webcrypto});
  if (!global.CustomEvent) global.CustomEvent = class CustomEvent extends Event { constructor(type, init = {}) { super(type); this.detail = init.detail; } };
  require(path.resolve("/Users/pambm3/NachHouse_APP/ROOMS_BROWSER_V0.5.73/nh-api-v11.js"));
  return global.NhApiV11.Client;
}

async function normalScenario() {
  const ApiClient = installBrowserClient();
  const clients = Array.from({length: 9}, () => new ApiClient({url, websocketOptions: {rejectUnauthorized: false}, activeFrameReads: true}));
  try {
    await Promise.all(clients.map(async client => { await client.connect(); await client.initialize(); }));
    const rooms = await clients[0].snapshot();
    const originals = rooms.slice(0, 5).map(room => ({...room}));
    const changed = originals.map((room, index) => ({...room, twilight: !room.twilight, temperature: room.temperature + (index + 1) * 0.1}));
    const started = performance.now();
    const results = await Promise.allSettled(changed.map((state, index) => {
      const one = performance.now();
      return clients[index].setRoomState(state).then(() => performance.now() - one);
    }));
    const elapsed = performance.now() - started;
    const failures = results.filter(item => item.status === "rejected");
    if (failures.length) throw new Error(`normal traffic failures: ${failures.map(item => item.reason?.message).join(" | ")}`);
    const latencies = results.map(item => item.value);
    const restore = await Promise.allSettled(originals.map((state, index) => clients[index].setRoomState(state)));
    const restoreFailures = restore.filter(item => item.status === "rejected");
    if (restoreFailures.length) throw new Error(`normal restore failures: ${restoreFailures.map(item => item.reason?.message).join(" | ")}`);
    const finalRooms = await clients[8].snapshot();
    for (const original of originals) {
      const actual = finalRooms.find(room => room.roomId === original.roomId);
      if (!actual || actual.temperature !== original.temperature || actual.twilight !== original.twilight) throw new Error(`Room ${original.roomId} not restored`);
    }
    return {clients: 9, active: 5, passive: 4, elapsedMs: elapsed, latenciesMs: latencies, p95Ms: percentile(latencies, 0.95), p99Ms: percentile(latencies, 0.99)};
  } finally { clients.forEach(client => client.close()); }
}

async function main() {
  const controller = new PlcClient("controller"), observer = new PlcClient("observer");
  const heavy = [];
  try {
    await Promise.all([controller.connect(), observer.connect()]);
    await Promise.all([controller.subscribeDevices(), observer.subscribeDevices()]);
    for (const joinDelay of [0, 100, 500]) heavy.push(await heavyScenario(controller, observer, joinDelay));
    const normal = await normalScenario();
    await verifyDevices(controller, false);
    const final = await controller.get(["NHAPIINFO.STATE", "NHAPIINFO.OWNERCLIENTID", "NHLOADTEST.DEPARTUREACTIVE"]);
    if (Number(final["NHAPIINFO.STATE"]) !== 0 || Number(final["NHAPIINFO.OWNERCLIENTID"]) !== 0 || final["NHLOADTEST.DEPARTUREACTIVE"] !== false) throw new Error("unsafe final PLC state");
    console.log("LOAD_800_RESULT=" + JSON.stringify({ok: true, host, heavy, normal, final}, null, 2));
  } catch (error) {
    try { await triggerScene(controller, false); await verifyDevices(controller, false); } catch (restoreError) { console.error("EMERGENCY RESTORE FAILED:", restoreError.message); }
    throw error;
  } finally { controller.close(); observer.close(); }
}

main().catch(error => { console.error("LOAD_800 FAILED:", error.stack || error.message); process.exitCode = 1; });
