# ROOM_API_PILOT – Mosaic import bundle

Target: TECOMAT FOXTROT CP-2000  
Mosaic: PROFI+ 2026.1  
Program version: 1.0.0.2

This directory extends the already-created empty Mosaic project in
`~/NachHouse/TST/ROOM_API_PILOT`.

## What is implemented

- 40 room config and state slots.
- `ApiInfo`, full `ApiConfig` and `ApiState` snapshots.
- Config/state revisions and latest public diffs.
- Eight retained in-memory diff frames with explicit sync request/response.
- Atomic ADD, DELETE, COPY and SET command handshake.
- Contiguous `SortDefault` values after `DELETE_ROOM`.
- Latest-command idempotent retry using `ClientId + RequestId`.
- Validated manual state test input.
- Four deterministic sample rooms.
- Global `{PUBLIC_API}` variables for TecoApi / `TecoApi.pub` publishing.

There is no real IO or smart-home control logic.

## Open and compile

1. Close and reopen the Mosaic project group
   `~/NachHouse/TST/ROOM_API_PILOT.mpr` so Mosaic reloads the externally added
   files and updated make list.
2. Check that all numbered ST files appear in the IEC manager in numeric order.
3. Compile the project for CP-2000.
4. In Project Manager / Export files enable generation and transfer of
   `TecoApi.pub` as required by the installed PLCComS / teco-smarthome setup.
5. Transfer the program and current pub file to the PLC, then put the PLC in RUN.
6. Create the native `.PIZ` only from Mosaic using File / Archive after a
   successful compile. This bundle does not pretend to be a Mosaic `.PIZ`.

## Public write rule

`ApiConfig`, `ApiState`, `ApiInfo`, and diff objects are read-only by contract.
Write request payload fields first. Set the corresponding `Execute` BOOL in a
separate final write. The PLC clears Execute and sets `Finished` after the
operation.

See `API_SYMBOLS_AND_TESTS.md` for numeric enums and example PLCComS JSON.
