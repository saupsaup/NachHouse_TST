# ROOM API binary WebSocket bridge

Read-only bridge pre existujúci NachHouse wire format:

```text
browser WebSocket /ws <- binary frame <- bridge <- GETMEM/TCP 5010 <- PLC
```

Bridge nepoužíva JSON ani Base64. Cez GETMEM sleduje `NhApiInfo` a iba pri novej
READY revízii načíta presne `TxByteLength` bajtov z `NhApiTxBuffer`. Pred
odoslaním overí magic `NHAP`, 64-bajtovú hlavičku, TX revision, `TotalSize` a
CRC32 IEEE. PLC ACK mechanizmus nemení; ACK zostáva povinnosťou registrovaného
klienta cez existujúci riadiaci kanál.

Predvolené symbolické začiatky blokov:

- PLC `192.168.43.201:5010`
- `NhApiInfo.ProtocolVersion`, 27 B
- `NhApiTxBuffer[0]`, kapacita 2048 B

Bridge zámerne nepoužíva absolútne `%R...` adresy. PLCComS podporuje symbolický
`GETMEM`, takže zmena pamäťového layoutu po kompilácii neporuší transport, pokiaľ
zostanú stabilné verejné názvy a veľkosti blokov.

Spustenie (Node.js 18+, bez závislostí):

```sh
node server.js
```

Potom otvoriť `http://127.0.0.1:8765`. Nastavenia možno zmeniť premennými
`PLC_HOST`, `PLC_PORT`, `PLC_INFO_ADDRESS`, `PLC_TX_ADDRESS`,
`PLC_TX_CAPACITY`, `BRIDGE_HOST`, `BRIDGE_PORT` a `PLC_POLL_MS`.

`teco-smarthome` subprotokol `raw` ostáva textový JSON kanál (`get`, `set`,
`diff`). Neposkytuje príkaz GETMEM ani natívny binárny payload; preto je bridge
samostatný dátový kanál PLC -> browser.

## Overenie 2026-08-29

- TLS/WSS handshake s `Sec-WebSocket-Protocol: raw` bol prijatý (`101`). Odpoveď
  na JSON `get NHAPITXBUFFER[0]` mala WebSocket opcode `1` (text), nie `2`
  (binary). Overenie sa dá zopakovať cez `npm run probe:native`.
- Reálny tok browser -> `/ws` -> bridge -> GETMEM/TCP 5010 -> PLC vrátil
  `ArrayBuffer` dlhý 1996 B: magic `NHAP`, MessageType `101`, TX revision `1`,
  `TotalSize = 1996` a platný CRC32 `0x79f92424`.
- WebSocket wire overhead serverového binárneho frame-u je pri 1996 B payload-e
  4 B, teda na WS vrstve 2000 B (pred TCP/TLS/IP overheadom).
