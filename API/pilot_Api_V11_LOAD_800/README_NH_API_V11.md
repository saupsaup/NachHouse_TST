# NachHouse API V11 – PLC pilot

## 1. Ciel

Pilot overuje jednoduchy binarny prenos nad standardnym `PUBLIC_API` a natívnym PLCComS `SET/GET/diff`.

Testovany Foxtrot 2: `192.168.43.201`.

- jeden spolocny prijimaci buffer `NhApiRX`,
- jeden spolocny vysielaci buffer `NhApiTX`,
- naraz prebieha iba jedna cielena transakcia,
- PLC je autorita: klient prijima aktualny stav bez porovnavania datovych revision,
- cely ramec kontroluje CRC32,
- kazdy publikovany TX ramec ma novy transportny `FrameId`,
- cache klienta sa po pripojeni a pri otvoreni obrazovky obnovi snapshotom,
- spontanny PLC diff je rychla best-effort aktualizacia; snapshot je spolahliva synchronizacia.

V11 nema zoznam klientov, privatne RX sloty, frontu poziadaviek, ACK masky ani `ConfigRevision`/`StateRevision`.

## 2. Verejne PLC premenne

| Premenna | Smer | Vyznam |
|---|---|---|
| `NhApiInfo.ApiVersion` | PLC → klient | Verzia binarneho kontraktu. Klient musi podporovat hodnotu `11`. |
| `NhApiInfo.State` | obojsmerne | Trvaly krok globalneho handshake; `0` znamena volno. |
| `NhApiInfo.OwnerClientId` | obojsmerne | Novy nenulovy token jednej transakcie. Nie je to trvaly ucet klienta. |
| `NhApiRX[0..63]` | klient → PLC | Jeden spolocny RX ramec, maximalne 256 bajtov. |
| `NhApiTX[0..511]` | PLC → klienti | Jeden spolocny TX ramec, maximalne 2048 bajtov. |
| `NhApiTest` | WebMaker/debug → PLC | Pomocne rozhranie na rucne vyvolanie PLC zmien pocas pilotu. |

`NhRoomsConfig[]` a `NhRoomsState[]` su autoritativne interne PLC data; nie su `PUBLIC_API`.

## 3. Jedna poziadavka klienta

```text
klient                                  PLC
  |                                      |
  | vidi State=0                         |
  | SET OwnerClientId=novy_token ------> |
  |                                      | prijme posledny token
  | <--------------- State=1, Owner=token|
  | zapise cely NhApiRX                  |
  | SET State=2 ako posledny ----------> | overi owner, hlavicku, velkost a CRC
  |                                      | vykona poziadavku, naplni NhApiTX
  | <--------------------------- State=3 | prvy stabilny TX ramec
  | sklada natívne diffy, az kym CRC sedi|
  | SET State=4 ------------------------> | ACK ramca
  | <--------------------------- State=5 | pripadny dalsi TX ramec
  | SET State=6 ------------------------> | ACK
  |                 ...                  |
  | <------ State=0, OwnerClientId=0 ---- | po ACK posledneho ramca uvolni API
```

Pravidla:

1. Klient zapisuje `OwnerClientId` iba ked vidi `State=0`.
2. Claim je uspesny iba ked PLC vrati `State=1` a rovnaky token.
3. Pri subehu vyhra posledny token, ktory PLC vidi v danom cykle. Ostatni klienti pockaju na dalsie `State=0`.
4. Klient zapisuje `State=2` az po kompletnom zapise RX.
5. PLC publikuje TX iba nepárnym stavom `3, 5, 7, ...`.
6. Vlastnik potvrdi ramec nasledujucim párnym stavom `4, 6, 8, ...`, ale az ked sedi CRC, `FrameId` je novy a ramec spracoval.
7. State nie je impulz na jeden PLC cyklus. Hodnota ostava stabilna az do dalsieho platneho kroku.
8. Po 30 sekundach bez platneho kroku PLC transakciu zrusi a vrati `State=0`.

## 4. PLC zmena bez poziadavky klienta

Ak sa pri `State=0` zmenia autoritativne room data, PLC zmrazi zmeny a publikuje CONFIG/STATE diff s `OwnerClientId=0`.

- ramce maju nepárne `State=1, 3, 5, ...`,
- klient ich moze overit CRC a aplikovat do cache,
- klient neposiela ACK,
- PLC drzi kazdy ramec minimalne 500 ms,
- prenos je best effort; klient, ktory ho nestihne alebo sa pripoji neskor, si vyziada snapshot.

Pri realnom teste PLCComS posielal zmenene prvky `NhApiTX[i]` ako samostatne WebSocket diff spravy a `State` mohol prist skor nez zvysok buffera. Klient preto nesmie predpokladat poradie ani zoskupenie diffov; sklada lokalny obraz, overi novy `FrameId` a az potom CRC.

Broadcast pocas svojho trvania blokuje novu cielenu transakciu, pretoze `State>0`.

## 5. Binarny ramec

Oba buffery su `ARRAY OF DWORD`, ale protokol ich interpretuje ako little-endian bajty. Dovodom nie je PLC datovy typ, ale presny bitovy obraz bez konverzie na desatinny `LREAL/DREAL` text v PLCComS.

### Pevna hlavicka – 40 bajtov

| Offset | Typ | Pole |
|---:|---|---|
| 0 | `U32` | Magic `NHAP` = `16#5041484E` |
| 4 | `U16` | `ApiVersion` |
| 6 | `U16` | `HeaderSize` = 40 |
| 8 | `U16` | `MessageType` |
| 10 | `U16` | `SchemaId` |
| 12 | `U32` | `OwnerClientId`; nula znamena broadcast |
| 16 | `U16` | `RecordCount` |
| 18 | `U16` | `RecordSize` |
| 20 | `U8` | `PartIndex`, od 1 |
| 21 | `U8` | `PartCount` aktualnej sekcie |
| 22 | `U8` | `ResultCode` |
| 23 | `U8` | rezervovane, zatial 0 |
| 24 | `U32` | `PayloadSize` v bajtoch |
| 28 | `U32` | `FrameSize` = hlavicka + payload |
| 32 | `U32` | `FrameId`; zvysi sa pri kazdom publikovanom TX ramci |
| 36 | `U32` | CRC32 celeho platneho ramca; pri vypocte su tieto 4 bajty nulove |

Klient ignoruje zvysok pola za `FrameSize`.

`FrameId` je transportny commit identifikator, nie verzia room dat. Klient si pamata posledny prijaty `FrameId` a po zmene `State` neprijme starsi TX obraz ani vtedy, ked ma stale platne CRC. Toto je nutne, pretoze PLCComS moze poslat `State` skor nez vsetky zmenene prvky `NhApiTX[]`.

### Room config – 138 bajtov

`RoomId U32`, `IconId U16`, `SortDefault U16`, potom `Name` a `ProjectName`; kazdy text ma jeden bajt dlzky a 64 bajtov obsahu.

### Room state – 22 bajtov

`RoomId U32`, `Temperature REAL32`, `Humidity REAL32`, `Presence U8`, `DayPhase U16`, `CategoryMask U32`, `AlarmLevel U8`, `Online U8`, `Twilight U8`.

CONFIG/STATE diff zaznam zacina `Operation U8` a `RoomId U32`; za nimi je cely config alebo state zaznam. Operacia `1` znamena vlozit/nahradit a `2` zmazat.

## 6. Spravy

### RX: klient → PLC

| Kod | Sprava | Payload |
|---:|---|---|
| 1 | `SNAPSHOT_REQUEST` | bez payloadu |
| 2 | `ADD_ROOM` | jeden config zaznam |
| 3 | `DELETE_ROOM` | `RoomId U32` |
| 4 | `COPY_ROOM` | `SourceRoomId U32` + cielovy config zaznam |
| 5 | `SET_ROOM_CONFIG` | jeden uplny config zaznam |
| 6 | `SET_ROOM_STATE` | jeden uplny state zaznam |

### TX: PLC → klienti

| Kod | Sprava | Vyznam |
|---:|---|---|
| 101 | `CONFIG_SNAPSHOT` | jedna cast config snapshotu |
| 102 | `STATE_SNAPSHOT` | jedna cast state snapshotu |
| 103 | `CONFIG_DIFF` | uplne config zaznamy, ktore sa zmenili |
| 104 | `STATE_DIFF` | uplne state zaznamy, ktore sa zmenili |
| 105 | `SNAPSHOT_DONE` | snapshot je kompletny |
| 106 | `RESULT` | posledny vysledok prikazu |

Snapshot ide vzdy po sekciach: vsetky CONFIG casti, potom vsetky STATE casti a nakoniec `SNAPSHOT_DONE`.

## 7. Klientsky model

1. Okamzite zobrazi lokalnu cache.
2. Na pozadi vyziada snapshot potrebny pre aktualnu obrazovku; pilot zatial posiela kompletne rooms.
3. Snapshot nahradi cache autoritativnymi PLC datami.
4. Neskorsie platne broadcast diffy priebezne upravuju cache.
5. Po reconnecte alebo pri pochybnosti klient znovu vyziada snapshot.

Datove revision sa zamerne nepouzivaju. `ApiVersion` hovori iba to, ci klient rozumie formatu protokolu.

## 8. Rucny test vo WebMaker/debug

Test sa spusta iba ked je `State=0`:

1. vyplnit polia `NhApiTest`,
2. nastavit `Action`,
3. ako posledne nastavit `Execute=TRUE`,
4. PLC nastavi `Finished=TRUE`, zapise `ResultCode` a `Execute=FALSE`.

Ak test zmeni data, PLC vytvori broadcast diff. Ak je `Action=6`, vytvori testovaci broadcast snapshot.

## 9. Subory projektu

| Subor | Obsah |
|---|---|
| `00_pilot_Api_V11.st` | rezervovany prazdny zdroj vytvoreny pre poradie vo VS Code |
| `01_Nh_Api_STRUCT.st` | konstanty, datove typy a globalne premenne |
| `02_Nh_Api_UTILS.st` | little-endian serializacia, CRC a porovnania |
| `03_Nh_Api_ENGINE.st` | data, snapshot, diff, prikazy a stavovy automat |
| `prgMain.ST` | volanie API v kazdom PLC cykle |

## 10. Testovaci postup

Po kompilacii a nahrati do Foxtrotu 2 sa otestuje realny retazec:

1. kontrola `ApiVersion=11`, `State=0`, `OwnerClientId=0`,
2. klientsky snapshot cez `NhApiRX`,
3. skladanie viacerych natívnych PLCComS diffov do platneho CRC ramca,
4. ACK vsetkych CONFIG, STATE a DONE ramcov,
5. `SET_ROOM_STATE` z klienta do PLC a spatny TX diff/result,
6. zmena `NhApiTest` v PLC a prijatie broadcast diffu klientom,
7. timeout nedokoncenej transakcie.

## 11. Vysledok realneho overenia

Dna 30. 8. 2026 presiel finalny E2E test na Foxtrote 2 `192.168.43.201`:

- cieleny viacramcovy snapshot CONFIG + STATE + DONE,
- skladanie `NhApiTX[]` iba z natívnych WebSocket diffov,
- kontrola noveho `FrameId`, CRC a nasledny ACK kazdeho ramca,
- SET room state/config vratane obnovy povodnych hodnot,
- ADD, COPY a DELETE vratane zmazania docasnych zaznamov,
- vysledky NOT_FOUND, UNSUPPORTED a BAD_FRAME pri chybnom CRC,
- ochrana aktivneho ownera pred cudzim zapisom,
- dva po sebe iduce PLC broadcast diffy vratane obnovy hodnot,
- timeout necinneho ownera `29,97 s`,
- finalny snapshot: 30 rooms, povodna Room 7 a `State=0`, `OwnerClientId=0`.

Klient pocas testu prijal 1907 natívnych diff sprav. Pred dokoncenim ramcov zaznamenal 1122 priebeznych CRC nezhod; je to ocakavany dokaz, ze prvky buffera prichadzaju postupne a ACK smie nasledovat az po novom `FrameId` a platnom CRC.

## MY.1 Moje poznamky
- ked klient bude chciet bieco poslat do RX maj by si vyziadat aktualny stav .State -ale kedze DIFF vzdy posle zmenu kde je aj .State, tak klient berie co m posledne - je to ok ? 

- hlavicka by mala mat strukturu v Mosaic - bude peevna, ale moj prvy navrh 40 B nemusi byt atomove, tu su poznamky
 | 4 | `U16` | `ApiVersion` | - to uz mama v NhApiInfo
| 6 | `U16` | `HeaderSize` = 40  -| - neviem ci je nutne
| 8 | `U16` | `MessageType` | - ok
| 10 | `U16` | `SchemaId` | - ok 
| 12 | `U32` | `OwnerClientId`; nula znamena broadcast | - je v NhApiInfo
| 16 | `U16` | `RecordCount` | - ok
| 18 | `U16` | `RecordSize` | - ok
| 20 | `U8` | `PartIndex`, od 1 | - netreba
| 21 | `U8` | `PartCount` aktualnej sekcie | - vypustil by som, ale neviem posudit
| 22 | `U8` | `ResultCode` | - - vypustil by som, ale neviem posudit 
| 23 | `U8` | rezervovane, zatial 0 | - vypustil by som, ale neviem posudit
| 24 | `U32` | `PayloadSize` v bajtoch | - neviem ci trreba
| 28 | `U32` | `FrameSize` = hlavicka + payload | - vypustil by som, ale neviem posudit
| 32 | `U32` | `FrameId`; zvysi sa pri kazdom publikovanom TX ramci | - netreba
| 36 | `U32` | CRC32 celeho platneho ramca; pri vypocte su tieto 4 bajty nulove |
