# Vysvetlenie DIFF prenosu v aktuálnom V11

Tento dokument odpovedá na otázku podľa aktuálne nasadeného projektu V2.2.0.0,
zdrojov klienta a merania priamo na PLC `192.168.33.200`.

## Krátka odpoveď

`NhApiTX[0..511]` je jedno PLC pole s 512 prvkami typu `DWORD`, teda 512
samostatne publikovaných PLC premenných po 32 bitoch. Z pohľadu binárneho
protokolu sú ich štyri bajty za sebou jeden spoločný TX buffer s kapacitou
2048 bajtov. Z pohľadu PLCComS/WSS sú však jednotlivé indexy samostatné
adresovateľné položky, napríklad `NHAPITX[10]`.

Pri reálnom meraní aktuálneho PLC každá zmenená položka `NHAPITX[i]` prišla
ako samostatná textová WebSocket správa s jedným JSON poľom. Zachytený
skutočný príklad:

```json
{"diff":{"NHAPITX[10]":{"dt":"DWORD","val":1}}}
```

Pre hypotetických 66 platných bitov rozložených do troch `DWORD` platí:

```text
NhApiTX[0]  bity  0..31
NhApiTX[1]  bity 32..63
NhApiTX[2]  bity 64..65; zvyšných 30 bitov je nevyužitých alebo nulových
```

Fyzicky teda nejde o tretí 2-bitový prvok, ale o tretí 32-bitový `DWORD`,
z ktorého sú významné iba dva bity. Ak sa zmenia všetky tri `DWORD`, aktuálny
PLCComS/WSS prenos vytvorí tri samostatné JSON/WebSocket správy, nie jeden
spoločný JSON. Ak sa niektorý `DWORD` nezmení, správa preň nevznikne.

## Dôkaz z PLC kódu

Verejná deklarácia je v [01_Nh_Api_STRUCT.st](01_Nh_Api_STRUCT.st):

```pascal
NhApiTX {PUBLIC_API} : ARRAY[0..511] OF DWORD;
```

Zdroj tým deklaruje 512 prvkov `DWORD`; nedeklaruje jednu 2048-bajtovú
verejnú premennú.

`NhApiBeginFrame` v [03_Nh_Api_ENGINE.st](03_Nh_Api_ENGINE.st) od riadku 160
získa ukazovateľ `ADR(NhApiTX)`, vymaže 2048 bajtov a zapisuje hlavičku aj
payload po bajtoch. Preto je `NhApiTX[]` pre V11 binárne súvislé pole.
Funkcia `NhApiPublishFrame` na riadkoch 197–206 doplní `FrameId` a CRC a až
potom nastaví `NhApiInfo.State`. PLC kód JSON nevytvára; transformáciu
verejných premenných na JSON robí PLCComS.

Jeden aplikačný V11 rámec pritom nie je jeden WebSocket rámec. Snapshotový
builder vytvára jeden binárny rámec do `NhApiTX` v
`NhApiBuildNextSnapshotFrame` na riadkoch 426–506. Až následne sa jeho
zmenené `DWORD` prvky distribuujú ako natívne diffy.

## Meranie PLCComS/WSS

Bol vykonaný iba čítací test: klient najprv odoberal všetkých
`NHAPITX[0..511]`, potom cez `NhApiTest.Action=6` vyžiadal broadcast snapshot.
Počas prenášania snapshotu bolo zachytených:

| Vlastnosť | Hodnota |
|---|---:|
| JSON/WebSocket správ obsahujúcich `NHAPITX[...]` | 359 |
| zmenené položky `NHAPITX[...]` | 359 |
| správy s presne 1 položkou | 359 |
| správy s viac než 1 položkou | 0 |

To je priame potvrdenie aktuálneho správania: jedna zmena verejného
`DWORD` prvku = jedna JSON textová WebSocket správa. Číslo 359 nie je počet
prvkov poľa, ale počet prvkov, ktorých hodnota sa pri postupnosti
snapshotových rámcov skutočne zmenila. Pri novom ráme sa časť starých
nenulových slov najprv vymaže na nulu a potom sa zapíšu nové hodnoty, preto
môže mať prenos viac natívnych diffov než má konečný binárny rámec slov.

## Tok v aktuálnej V11 ceste

```text
PLC room dáta
  → NhApiBuildNextSnapshotFrame / NhApiBuildNextDiffFrame
  → bajtový obraz v NhApiTX[0..511]
  → PLCComS WSS: samostatný JSON diff pre každý zmenený NhApiTX[i]
  → WebSocket textová správa
  → NhApiV11.receive() a applyValues()
  → lokálna Uint32Array tx[0..511]
  → frameFromCache(): poskladanie bajtov, FrameId a CRC
  → parseRecords()/parseChanges() a dáta klienta
```

Klientská časť je v
[nh-api-v11.js](/Users/pambm3/NachHouse_APP/ROOMS_BROWSER_V0.5.73/nh-api-v11.js):

- `initialize()` na riadkoch 270–281 číta a tým odoberá `NHAPITX[0..511]`
  v dávkach po 32 položkách;
- `receive()` na riadkoch 217–229 prijíma každý JSON a posúva `message.diff`
  do `applyValues()`;
- `applyValues()` na riadkoch 231–241 rozpozná presne jeden alebo viac kľúčov
  regexom `^NHAPITX\[(\d+)]$` a uloží každý prijatý `DWORD` do `tx[index]`;
- `frameFromCache()` na riadkoch 353–366 z celého lokálneho poľa vytvorí
  bajtový rámec a prijme ho až pri zhodnom `FrameId` a CRC;
- `refreshTxFrame()` na riadkoch 340–350 pri potrebe aktívne dočíta hlavičku
  a všetky platné slová cez `get`, takže klient nezávisí len od tempa diffov.

Preto klient nesmie predpokladať, že `State` a všetky slová TX prídu v jednej
správe ani v správnom poradí. To je aj dôvod priebežných nezhôd CRC počas
skladania poľa; neznamenajú poškodený konečný rámec.

## Význam starého bridge/server.js

[server.js](/Users/pambm3/NachHouse_DEV/TST/ROOM_API_PILOT/binary_ws_bridge/server.js)
nie je v aktuálnej V11 ceste. Je to starší samostatný most cez TCP `GETMEM`,
ktorý očakáva iné mená (`NhApiTxBuffer`) a 64-bajtovú hlavičku. Aktuálne V11
má `NhApiTX` a 40-bajtovú hlavičku.

Ak by bol tento starý most samostatne spustený a kompatibilný s daným
protokolom, jeho `pollPlc()` načíta celý binárny rámec a `broadcastBinary()`
ho pošle klientovi ako jednu binárnu WebSocket správu. To však nie je prenos,
ktorý používa `nh-api-v11.js` v LOAD_800: ten sa pripája priamo na
`wss://PLC:5030/` s protokolom `raw`.

## Oprava interpretácie LOAD_800

Údaj `640/640 diffov` v [LOAD_800_REPORT.md](LOAD_800_REPORT.md) sa nevzťahuje
na `NhApiTX`. Test LOAD_800 používa iné verejné pole:

```pascal
NhLoadDevices {PUBLIC_API} : ARRAY[1..800] OF DWORD;
```

Pozri [01_Nh_Api_STRUCT.st](01_Nh_Api_STRUCT.st), riadok 139. Scéna odchod
zmení prvky 1..640 v [03_Nh_Api_ENGINE.st](03_Nh_Api_ENGINE.st), riadky
742–775. Testovací klient zbiera unikátne indexy `NHLOADDEVICES[i]`, nie
`NHAPITX[i]`; dokazuje to `receive()` v
[load-800-test.cjs](.vscode/load-800-test.cjs), riadky 53–72, a povinná
kontrola 640 unikátnych indexov na riadkoch 149–171.

Presný význam je teda:

> Každý z dvoch vopred pripojených klientov prijal a rozpoznal zmenu všetkých
> 640 unikátnych modelových zariadení.

Keďže meranie PLCComS pre `NHAPITX[i]` ukázalo jednu položku na jednu JSON/WSS
správu, bolo doplnené aj priame meranie samotného `NhLoadDevices`. Jedna
scéna vytvorila 640 JSON/WebSocket správ obsahujúcich celkovo 640 položiek;
všetkých 640 správ obsahovalo presne jednu položku. Teda 640/640 znamená
640 individuálnych natívnych prenosov na klienta, nie jeden 640-položkový
JSON.

Čas 5,18–7,17 s preto nemeria čas vykonania logiky scény: PLC nastavilo 640
hodnôt za menej než 1 ms. Meria postupné doručenie 640 samostatných JSON/WSS
diffov cez PLCComS k pozorovateľovi. Rozptyl vzniká plánovaním PLCComS,
frontou WebSocket spojenia a súbežnými požiadavkami klientov. Pri približne
640 zmenách za 5,18–7,17 s je pozorovaná rýchlosť asi 89–124 individuálnych
hodnotových zmien za sekundu na jedného klienta.
