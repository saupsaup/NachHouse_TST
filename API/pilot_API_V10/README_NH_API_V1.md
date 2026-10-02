# NachHouse API PLC pilot V1




Cieľ: TECOMAT Foxtrot CP-2000  
Adresa PLC: `192.168.43.201`  
Prenos: `PUBLIC_API` → `TecoApi.pub` → PLCComS → teco-smarthome WSS/raw

Projekt je samostatný PLC pilot. Neobsahuje klienta ani reálne vstupy a výstupy domu.

## Verejné koreňové premenné

- `NhApiInfo` – verzia protokolu, doménové revízie a riadenie TX buffera.
- `NhApiClients[0..3]` – registrácia, heartbeat, ACK, RX commit a výsledok požiadavky.
- `NhApiTxBuffer[0..511]` – jeden stabilný rámec PLC → klienti, spolu 2048 bajtov.
- `NhApiRxBuffer[0..255]` – štyri klientske RX segmenty, každý 64 DWORD/256 bajtov.
- `NhApiTest` – jednoduchý testovací ovládač pre WebMaker bez binárneho klienta.

`NhRoomsConfig` a `NhRoomsState` sú autoritatívne testovacie dáta PLC. Zámerne nie
sú `PUBLIC_API`; klient ich dostáva iba prostredníctvom snapshotov a diffov.

## Životný cyklus TX buffera

```text
IDLE → BUILDING → READY → všetky požadované CRC-overené ACK → IDLE
```

PLC nikdy neprepíše `NhApiTxBuffer`, kým platí `NhApiInfo.TxState = 2`.
Každý aktívny klient zahrnutý v `TxRequiredAckMask` musí zostaviť celý rámec,
overiť CRC a až potom nastaviť `AckTxRevision = TxPublishedRevision`.

Klient bez aktivity sa po 10 sekundách vyradí a prestane blokovať TX buffer.
Heartbeat klient zvyšuje nezávisle od ACK a aplikačných požiadaviek.

## Registrácia klienta

1. Klient nájde slot so `State = 0`.
2. Zapíše náhodné nenulové `RequestedClientId`.
3. PLC ho potvrdí v `AssignedClientId` a nastaví `State = 1`.
4. Klient používa iba svoj RX segment: `slot * 64` až `slot * 64 + 63`.
5. Klient pravidelne zvyšuje `HeartbeatCounter`.

Ak dvaja klienti skúsia rovnaký voľný slot, vlastníkom je iba klient, ktorého ID
sa objaví v `AssignedClientId`. Druhý klient musí vybrať iný voľný slot.

## Sekvencia kompletného snapshotu

```text
ROOM_CONFIG časť 1..N → ROOM_STATE časť 1..N → SNAPSHOT_DONE
```

Každá časť je samostatný TX rámec s vlastným CRC a ACK. Config aj state kópie sa
zmrazia pri prijatí požiadavky. Zmeny vzniknuté počas snapshotu sa preto nestratia;
po jeho dokončení sa odošlú ako ďalšie diff rámce.

## Pevná 64-bajtová hlavička

Všetky celé čísla aj bitový obraz IEC `REAL` sú little-endian.

| Offset | Veľkosť | Pole a význam |
| ---: | ---: | --- |
| 0 | 4 | Magic `NHAP` (`0x5041484E`) |
| 4 | 2 | `ProtocolVersion` |
| 6 | 2 | `HeaderSize = 64` |
| 8 | 2 | `MessageType` |
| 10 | 2 | `SchemaId` |
| 12 | 2 | `SchemaVersion` |
| 14 | 2 | príznaky, zatiaľ rezervované |
| 16 | 4 | zdrojový `ClientId` v RX, v TX nula |
| 20 | 4 | `RequestId` |
| 24 | 4 | revízia rámca/RX commit revízia |
| 28 | 4 | doménová `FromRevision` |
| 32 | 4 | doménová `ToRevision` |
| 36 | 2 | `RecordCount` |
| 38 | 2 | `RecordSize` |
| 40 | 2 | `PartIndex`, číslovanie od 1 |
| 42 | 2 | `PartCount` |
| 44 | 4 | `PayloadSize` |
| 48 | 4 | `TargetClientId`, nula znamená broadcast |
| 52 | 2 | `ResultCode` |
| 54 | 2 | rezervované |
| 56 | 4 | celková veľkosť rámca v bajtoch |
| 60 | 4 | CRC32 IEEE |

CRC32 sa počíta zo všetkých `TotalSize` bajtov. Bajty CRC na offsetoch 60..63 sa
pri výpočte považujú za nuly.

## Typy správ a schémy

RX požiadavky:

- `1 SNAPSHOT`
- `2 ADD_ROOM`
- `3 DELETE_ROOM`
- `4 COPY_ROOM`
- `5 SET_ROOM_CONFIG`
- `6 SET_ROOM_STATE`

TX správy:

- `101 CONFIG_SNAPSHOT`
- `102 STATE_SNAPSHOT`
- `103 CONFIG_DIFF`
- `104 STATE_DIFF`
- `105 SNAPSHOT_DONE`

Schéma `0` znamená správu bez dátového záznamu, `1` je `NH_ROOM_CONFIG` a `2` je
`NH_ROOM_STATE`. Aktuálna verzia oboch schém je `1`.

Config záznam má 138 bajtov. State záznam má 22 bajtov. Textové pole obsahuje
jeden bajt dĺžky a presne 64 bajtov priestoru pre UTF-8. Počiatočné názvy sú
ASCII, teda platná podmnožina UTF-8. Kódovanie textu zapísaného z WebMakeru treba
pred použitím slovenskej diakritiky samostatne overiť.

## Testovanie cez WebMaker

WebMaker najskôr zapíše všetky vstupné polia `NhApiTest` a `Execute := TRUE`
nastaví ako posledný commit krok. PLC následne `Execute` vynuluje a zverejní
`Finished`, `ResultCode`, `ConfigRevision` a `StateRevision`.

Akcie `NhApiTest.Action`:

- `1 SET_STATE`
- `2 ADD_ROOM`
- `3 DELETE_ROOM`
- `4 COPY_ROOM`
- `5 SET_CONFIG`
- `6 REQUEST_SNAPSHOT` – broadcast snapshot

Pri `SET_STATE` treba vyplniť celý stavový záznam. Teplota musí byť v rozsahu
-50..100 °C, vlhkosť 0..100 % a alarm 0..2.

## Preklad a spustenie v Mosaic

1. Zavrieť a znovu otvoriť projekt, aby Mosaic načítal aktuálny make-list.
2. Preložiť projekt pre CP-2000.
3. V exporte projektu povoliť generovanie a prenos `TecoApi.pub`.
4. Preniesť program aj aktuálny `TecoApi.pub` do PLC a prepnúť PLC do RUN.
5. Cez PLCComS `list` alebo WSS `get` overiť všetky verejné koreňové premenné.

Prihlasovacie údaje nie sú uložené v zdrojových súboroch ani v tomto README.


### BEGIN_REQUEST-1: STATUS: DONE — 2026-08-29

1. Usporiadať zdrojové súbory podľa poradia `00...03` a zachovať dohodnuté
   veľké a malé písmená:

   - Mosaic pri vytvorení prázdneho projektu generuje prázdny súbor
     `pilot_API_PLC_V10.st`. Súbor ponechať na budúce použitie a pre správne
     poradie vo VS Code ho premenovať na `00_pilot_API_PLC_V10.st`.
   - Deklarácie, konštanty a typy uložiť v `01_Nh_Api_STRUCT.st`.
   - Pomocné funkcie uložiť v `02_Nh_Api_UTILS.st`.
   - API engine uložiť v `03_Nh_Api_ENGINE.st`.
   - Hlavný program ponechať v `prgMain.ST`.

   Výsledné poradie v `.mak`:

   ```text
   #usefile "00_pilot_API_PLC_V10.st"
   #usefile "01_Nh_Api_STRUCT.st"
   #usefile "02_Nh_Api_UTILS.st"
   #usefile "03_Nh_Api_ENGINE.st"
   #usefile "prgMain.ST"
   ```

2. Všetky bežné komentáre a popisy zapisovať pomocou `//`, nie pomocou
   `(* ... *)`. Blokový komentár tak zostane voľný na dočasné vypnutie časti
   programu.

   - Každý riadok viacriadkového komentára začína `//`.
   - Popis funkcie, funkčného bloku alebo programu je vnútri POU, hneď za jeho
     deklaráciou.
   - Komentár začína anglickým textom a pokračuje slovenským textom za `SK:`.

3. Každý dátový typ `STRUCT` musí mať komentár opisujúci jeho účel a použitie.

#### RESULT

- Názvy zdrojov a ich poradie v `pilot_API_PLC_V10.mak` sú skontrolované a
  zodpovedajú dohode `00...03`, za ktorými nasleduje `prgMain.ST`.
- Všetky komentáre v ST zdrojoch sú prevedené na `//`, anglický text je prvý a
  slovenský text nasleduje za `SK:`.
- Popisy všetkých `FUNCTION` a `PROGRAM` sú premiestnené dovnútra POU pred
  deklarácie premenných.
- Typy `NH_ROOM_CONFIG`, `NH_ROOM_STATE`, `NH_API_INFO`,
  `NH_API_CLIENT_SLOT` a `NH_API_TEST_CONTROL` majú popis celého typu.
- Dodatočne je opravený timeout klienta: pri vyradení PLC vynuluje aj
  `RequestedClientId`, takže sa neaktívny klient v ďalšom cykle automaticky
  nezaregistruje znova.
- Nevykonané: kompilácia a zápis programu do PLC.

### END_REQUEST-1;
