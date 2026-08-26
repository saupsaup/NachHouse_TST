# ROOM_API_PILOT – public symbols and tests

## Numeric enums

Actions: `1 ADD_ROOM`, `2 DELETE_ROOM`, `3 COPY_ROOM`, `4 SET_ROOM_DATA`.

Results: `0 NONE`, `1 OK`, `2 ERROR`, `3 NOT_FOUND`, `4 NO_FREE_SLOT`,
`5 ALREADY_EXISTS`, `6 INVALID_ARGUMENT`, `7 UNSUPPORTED_ACTION`.

Diff operations: `1 UPSERT`, `2 DELETE`.

Sync modes: `0 CURRENT`, `1 DIFF`, `2 FULL_REQUIRED`.

Alarm: `0 OK`, `1 WARNING`, `2 ALARM`.

Day phase values: `140 DAY`, `142 DUSK`, `144 NIGHT`, `146 DAWN`.

Category mask: bit 0 -> asset 104, bit 1 -> asset 105, bit 2 -> asset 89.

## Main public roots

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

The exact case emitted in `TecoApi.pub` is compiler-controlled; the examples use
the uppercase form observed in the existing installation.

## Read snapshot

```json
{"cmd":"get","data":["APIINFO","APICONFIG","APISTATE"]}
```

## Add room 100

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

## Copy room 1 to room 101

Use action `3`, target `ROOMID=101`, source `SOURCEROOMID=1`, then commit with
`APICOMMANDEXECUTE=true`.

## Delete room 100

Use action `2`, `ROOMID=100`, then commit.

## Rename room 1

Use action `4`, `ROOMID=1`, set non-empty `NAME` and the desired
`PROJECTNAME`, then commit.

## Manual test state

Write all `APITESTSTATEREQUEST` fields, then commit in a separate message:

```json
{"cmd":"set","data":{"APITESTSTATEEXECUTE":{"dt":"BOOL","val":true}}}
```

The processor validates temperature `-50..100`, humidity `0..100`, alarm
`0..2`, and day phase `140/142/144/146`. It increments only `StateRevision`.

## Recover one missed diff frame

Set `APISYNCREQUEST.CLIENTID`, `REQUESTID`, `CONFIGFROMREVISION`, and
`STATEFROMREVISION`, then commit:

```json
{"cmd":"set","data":{"APISYNCEXECUTE":{"dt":"BOOL","val":true}}}
```

`APISYNCRESPONSE` returns one next retained frame for each stream. Repeat with
the returned `ToRevision` until mode is `CURRENT`. If mode is `FULL_REQUIRED`,
read the full `APICONFIG` or `APISTATE` snapshot.
