#!/usr/bin/env node
"use strict";

const fs = require("node:fs");
const path = require("node:path");

const file = path.resolve(__dirname, "../WebMaker/pilot_Api_V11.xml");
let xml = fs.readFileSync(file, "latin1");
xml = xml.replace(/\s*<!-- NH_CONNECT_BEGIN -->[\s\S]*?<!-- NH_CONNECT_END -->\s*/g, "\r\n");

let uid = 20000;

function edit(variable, type, writable = false) {
  const current = uid++;
  return [
    `\t\t\t<object caption="" X="0" Y="0" xoff="0" yoff="0" level="0" readonly="${writable ? "false" : "true"}" front="0" back="16777215" strong="false" italic="false" size="8" transparent="true" visneg="false" Uid="${current}">`,
    `\t\t\t\t<edit variable="${variable}" type="${type}" intf="0" timf="" align="left" zero="false" prec="-1" size="10" global="true" border="false" width="1" height="1" tabindex="1" />`,
    "\t\t\t</object>"
  ].join("\r\n");
}

function page(name, ucid, fields) {
  return [
    `\t\t<page caption="NachHouse transport" name="${name}" ajax="true" pause="0" ucid="${ucid}" width="1" height="1">`,
    ...fields,
    "\t\t</page>"
  ].join("\r\n");
}

const pages = [];
pages.push(page("NHMETA.XML", 2026100501, [
  edit("NhApiInfo.State", "UINT"),
  edit("NhApiTX[7]", "DWORD"),
  edit("NhApiTX[8]", "DWORD"),
  edit("NhConnectConnected", "BOOL")
]));

for (let part = 0; part < 4; part += 1) {
  const fields = [];
  for (let index = part * 128; index < (part + 1) * 128; index += 1) {
    fields.push(edit(`NhApiTX[${index}]`, "DWORD"));
  }
  pages.push(page(`NHTX${part}.XML`, 2026100510 + part, fields));
}

const rxFields = [];
for (let index = 0; index < 64; index += 1) rxFields.push(edit(`NhApiRX[${index}]`, "DWORD", true));
rxFields.push(edit("NhApiInfo.OwnerClientId", "UDINT", true));
rxFields.push(edit("NhApiInfo.State", "UINT", true));
pages.push(page("NHRX.XML", 2026100520, rxFields));

const block = `\r\n\t\t<!-- NH_CONNECT_BEGIN -->\r\n${pages.join("\r\n")}\r\n\t\t<!-- NH_CONNECT_END -->\r\n`;
if (!xml.includes("\t</group>")) throw new Error("WebMaker group end not found");
xml = xml.replace("\t</group>", block + "\t</group>");
fs.writeFileSync(file, xml, "latin1");
console.log(`Generated ${pages.length} NachHouse WebMaker transport pages`);

