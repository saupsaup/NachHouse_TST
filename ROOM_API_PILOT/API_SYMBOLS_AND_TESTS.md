# ROOM_API_PILOT – verejné symboly a testy

Stav dokumentu: overené na reálnom PLC dňa 2026-08-27  
Program: `1.0.0.2`  
Target: TECOMAT FOXTROT CP-2000, firmware `v2.6.077 R3`  
Mosaic: PROFI+ 2026.1  
TecoApi: `1.0.2`

## Číselné hodnoty enumov

Actions: `1 ADD_ROOM`, `2 DELETE_ROOM`, `3 COPY_ROOM`, `4 SET_ROOM_DATA`.

Results: `0 NONE`, `1 OK`, `2 ERROR`, `3 NOT_FOUND`, `4 NO_FREE_SLOT`,
`5 ALREADY_EXISTS`, `6 INVALID_ARGUMENT`, `7 UNSUPPORTED_ACTION`.

Diff operations: `1 UPSERT`, `2 DELETE`.

Sync modes: `0 CURRENT`, `1 DIFF`, `2 FULL_REQUIRED`.

Alarm: `0 OK`, `1 WARNING`, `2 ALARM`.

Day phase values: `140 DAY`, `142 DUSK`, `144 NIGHT`, `146 DAWN`.

Category mask: bit 0 -> asset 104, bit 1 -> asset 105, bit 2 -> asset 89.

## Hlavné verejné korene

- `APIINFO`
- `APICONFIG`
- `APISTATE`
- `APICONFIGDIFF`
- `APISTATEDIFF`
- `APICOMMANDROOM`, `APICOMMANDEXECUTE`, `APICOMMANDBUSY`,
  `APICOMMANDFINISHED`, `APICOMMANDRESULT`
- `APISYNCREQUEST`, `APISYNCEXECUTE`, `APISYNCBUSY`, `APISYNCFINISHED`,
  `APISYNCRESPONSE`
- `APITESTSTATEREQUEST`, `APITESTSTATEEXECUTE`, `APITESTSTATEBUSY`,
  `APITESTSTATEFINISHED`, `APITESTSTATERESULT`

Mosaic v aktuálne preloženom `TecoApi.pub` publikuje názvy v tvare
`ApiInfo`, `ApiConfig`, `ApiState`, `ApiCommandRoom` a podobne. HTTP klient musí
použiť presný tvar názvu, ktorý vráti aktuálny `TecoApi.pub`. Veľké názvy
uvedené vyššie sú symbolické IEC názvy v projekte.

## Načítanie snapshotu

```json
{"cmd":"get","data":["APIINFO","APICONFIG","APISTATE"]}
```

## Pridanie miestnosti 100

Write the payload first:

```json
{"cmd":"set","data":{"APICOMMANDROOM.CLIENTID":{"dt":"STRING","val":"pwa-pilot-1"},"APICOMMANDROOM.REQUESTID":{"dt":"UDINT","val":1},"APICOMMANDROOM.ACTION":{"dt":"USINT","val":1},"APICOMMANDROOM.ROOMID":{"dt":"UDINT","val":100},"APICOMMANDROOM.SOURCEROOMID":{"dt":"UDINT","val":0},"APICOMMANDROOM.NAME":{"dt":"STRING","val":"Test room"},"APICOMMANDROOM.PROJECTNAME":{"dt":"STRING","val":"T.01"}}}
```

Commit in a separate write:

```json
{"cmd":"set","data":{"APICOMMANDEXECUTE":{"dt":"BOOL","val":true}}}
```

Then read or observe the automatic diff for `APICOMMANDRESULT`, `APIINFO`,
`APICONFIGDIFF`, and `APISTATEDIFF`.

## Kopírovanie miestnosti 1 do miestnosti 101

Use action `3`, target `ROOMID=101`, source `SOURCEROOMID=1`, then commit with
`APICOMMANDEXECUTE=true`.

## Vymazanie miestnosti 100

Use action `2`, `ROOMID=100`, then commit.

After deletion, the PLC decrements `SortDefault` for every remaining room that
was ordered after the deleted room. The resulting default order is contiguous.

## Premenovanie miestnosti 1

Use action `4`, `ROOMID=1`, set non-empty `NAME` and the desired
`PROJECTNAME`, then commit.

## Ručne nastavený testovací stav

Write all `APITESTSTATEREQUEST` fields, then commit in a separate message:

```json
{"cmd":"set","data":{"APITESTSTATEEXECUTE":{"dt":"BOOL","val":true}}}
```

The processor validates temperature `-50..100`, humidity `0..100`, alarm
`0..2`, and day phase `140/142/144/146`. It increments only `StateRevision`.

## Obnovenie jedného zmeškaného diff rámca

Set `APISYNCREQUEST.CLIENTID`, `REQUESTID`, `CONFIGFROMREVISION`, and
`STATEFROMREVISION`, then commit:

```json
{"cmd":"set","data":{"APISYNCEXECUTE":{"dt":"BOOL","val":true}}}
```

`APISYNCRESPONSE` returns one next retained frame for each stream. Repeat with
the returned `ToRevision` until mode is `CURRENT`. If mode is `FULL_REQUIRED`,
read the full `APICONFIG` or `APISTATE` snapshot.

## Overené pravidlá prenosu CP-2000

Verified on CP-2000 firmware `v2.6.077 R3` with TecoApi `1.0.2`:

- Write each `SetObject` payload field in a separate authenticated HTTP request
  and write the corresponding `Execute` flag last. A multi-parameter
  `SetObject` request returned `401.021` in the tested Digest-auth setup.
- Do not read the complete `ApiSyncResponse` root in one request. It exceeds the
  TecoApi limit of 512 elementary variables and returns `413.004`. Read the
  response header fields, `ApiSyncResponse.ConfigDiff`, and
  `ApiSyncResponse.StateDiff` separately.

## Výsledky živých akceptačných testov

Nasledujúce testy boli vykonané cez HTTP Digest API priamo proti CP-2000:

| Test | Očakávaný výsledok | Výsledok |
| --- | --- | --- |
| Načítanie `ApiInfo`, `ApiConfig` a `ApiState` | 4 vzorové miestnosti | OK |
| Ručná zmena teploty | iba nová `StateRevision` a state diff | OK |
| Synchronizácia `CURRENT` a `DIFF` | správny nasledujúci diff rámec | OK |
| `ADD_ROOM`, opakovaný identický request, `DELETE_ROOM` | pridanie, idempotencia, vymazanie | OK |
| `COPY_ROOM` a následný `DELETE_ROOM` | súvislé `SortDefault` 1..4 | OK |
| `SET_ROOM_DATA` a obnovenie pôvodných údajov | config diff bez zmeny state revízie | OK |
| `ADD_ROOM` s existujúcim `RoomId` | `ALREADY_EXISTS` (5) | OK |
| `DELETE_ROOM` s neexistujúcim `RoomId` | `NOT_FOUND` (3) | OK |
| `SET_ROOM_DATA` s prázdnym názvom | `INVALID_ARGUMENT` (6) | OK |
| Neznáma hodnota `Action` | `UNSUPPORTED_ACTION` (7) | OK |

Po chybových testoch ostali revízie nezmenené: `ConfigRevision=5` a
`StateRevision=3`. Konfigurácia obsahovala iba pôvodné miestnosti 1 až 4 so
súvislým `SortDefault` 1 až 4. Dočasné testovacie miestnosti nezostali v PLC.

## Poznámky pre klienta

- Pri `SetObject` zapisovať každé pole samostatnou autentifikovanou HTTP
  požiadavkou a príslušný príznak `Execute` zapísať ako posledný.
- Pred odoslaním nového príkazu použiť nové `RequestId`. Opakovanie rovnakej
  dvojice `ClientId + RequestId` slúži na idempotentné zopakovanie requestu.
- Po príkaze kontrolovať `ApiCommandResult`, vrátené revízie a následne diff.
- Pri `FULL_REQUIRED` zahodiť lokálnu cache príslušného streamu a načítať
  celý snapshot.
- Pri chybovom výsledku PLC nesmie zvýšiť `ConfigRevision` ani
  `StateRevision`.
