(*
   Mechanizmus vıpoètu rozdielov (diff engine). ENG
   Jedna PLC transakcia vytvorí jednu novú revíziu a jeden úplnı rámec zmien.
   Uchováva sa osem rámcov; klient si vyiada vdy práve jeden nasledujúci rámec.
*)

(* Zachytí všetky konfiguraèné zmeny od poslednej tieòovej kópie. *)
FUNCTION ApiCaptureConfigChanges : BOOL
VAR
    i          : USINT; (* Index pri prechode všetkıch konfiguraènıch pozícií. *)
    count      : USINT; (* Poèet zmien zapísanıch do aktuálneho rámca. ENG *)
    oldRev     : UDINT; (* Revízia konfigurácie pred zachytením zmien. ENG *)
    newRev     : UDINT; (* Nová revízia konfigurácie po zachytení zmien. ENG *)
    anyChanged : BOOL;  (* Pomocnı príznak, e sa zmenila aspoò jedna pozícia. ENG *)
END_VAR

(* Prvı prechod iba zisuje, èi treba vytvori novú revíziu. *)
anyChanged := FALSE;
FOR i := 1 TO C_MAX_ROOMS DO
    IF NOT ApiRoomConfigEqual(ApiConfig.Rooms[i], ApiConfigShadow[i]) THEN
        anyChanged := TRUE;
    END_IF;
END_FOR;

ApiCaptureConfigChanges := anyChanged;
(* Bez zmeny sa revízia ani história neposúvajú. *)
IF NOT anyChanged THEN
    RETURN;
END_IF;

(* Pripraví hlavièku nového konfiguraèného rámca. *)
ApiClearConfigDiff(ApiConfigDiff);
oldRev := ApiInfo.ConfigRevision;
newRev := ApiNextRevision(oldRev);
ApiConfigDiff.FromRevision := oldRev;
ApiConfigDiff.ToRevision := newRev;
ApiConfigDiff.FullRequired := FALSE;
count := 0;

(* Druhı prechod vytvorí kompaktnı zoznam UPSERT/DELETE zmien. ENG *)
FOR i := 1 TO C_MAX_ROOMS DO
    IF NOT ApiRoomConfigEqual(ApiConfig.Rooms[i], ApiConfigShadow[i]) THEN
        count := count + 1;
        ApiConfigDiff.Changes[count].Valid := TRUE;

        IF ApiConfig.Rooms[i].Used THEN
            ApiConfigDiff.Changes[count].Operation := API_DIFF_UPSERT;
            ApiConfigDiff.Changes[count].RoomId := ApiConfig.Rooms[i].RoomId;
            ApiConfigDiff.Changes[count].Room := ApiConfig.Rooms[i];
        ELSE
            ApiConfigDiff.Changes[count].Operation := API_DIFF_DELETE;
            ApiConfigDiff.Changes[count].RoomId := ApiConfigShadow[i].RoomId;
            ApiClearRoomConfig(ApiConfigDiff.Changes[count].Room);
        END_IF;
    END_IF;

    ApiConfigShadow[i] := ApiConfig.Rooms[i];
END_FOR;

(* Zverejnenie rámca a revízie sa vykoná a po naplnení všetkıch poloiek. *)
ApiConfigDiff.ChangeCount := count;
ApiConfigDiff.Valid := TRUE;
ApiInfo.ConfigRevision := newRev;

(* Uloenie hotového rámca do osemprvkovej kruhovej histórie. *)
IF ApiConfigHistoryHead >= C_DIFF_HISTORY_DEPTH THEN
    ApiConfigHistoryHead := 1;
ELSE
    ApiConfigHistoryHead := ApiConfigHistoryHead + 1;
END_IF;
ApiConfigDiffHistory[ApiConfigHistoryHead] := ApiConfigDiff;
END_FUNCTION


(* Zachytí všetky stavové zmeny od poslednej tieòovej kópie. *)
FUNCTION ApiCaptureStateChanges : BOOL
VAR
    i          : USINT; (* Index pri prechode všetkıch stavovıch pozícií. *)
    count      : USINT; (* Poèet zmien zapísanıch do aktuálneho rámca. ENG *)
    oldRev     : UDINT; (* Revízia stavu pred zachytením zmien. ENG *)
    newRev     : UDINT; (* Nová revízia stavu po zachytení zmien. ENG *)
    anyChanged : BOOL;  (* Pomocnı príznak, e sa zmenila aspoò jedna pozícia. ENG *)
END_VAR

(* Prvı prechod iba zisuje, èi treba vytvori novú revíziu. *)
anyChanged := FALSE;
FOR i := 1 TO C_MAX_ROOMS DO
    IF NOT ApiRoomStateEqual(ApiState.Rooms[i], ApiStateShadow[i]) THEN
        anyChanged := TRUE;
    END_IF;
END_FOR;

ApiCaptureStateChanges := anyChanged;
(* Bez zmeny sa revízia ani história neposúvajú. *)
IF NOT anyChanged THEN
    RETURN;
END_IF;

(* Pripraví hlavièku nového stavového rámca. *)
ApiClearStateDiff(ApiStateDiff);
oldRev := ApiInfo.StateRevision;
newRev := ApiNextRevision(oldRev);
ApiStateDiff.FromRevision := oldRev;
ApiStateDiff.ToRevision := newRev;
ApiStateDiff.FullRequired := FALSE;
count := 0;

(* Druhı prechod vytvorí kompaktnı zoznam UPSERT/DELETE zmien. ENG *)
FOR i := 1 TO C_MAX_ROOMS DO
    IF NOT ApiRoomStateEqual(ApiState.Rooms[i], ApiStateShadow[i]) THEN
        count := count + 1;
        ApiStateDiff.Changes[count].Valid := TRUE;

        IF ApiState.Rooms[i].RoomId <> 0 THEN
            ApiStateDiff.Changes[count].Operation := API_DIFF_UPSERT;
            ApiStateDiff.Changes[count].RoomId := ApiState.Rooms[i].RoomId;
            ApiStateDiff.Changes[count].Room := ApiState.Rooms[i];
        ELSE
            ApiStateDiff.Changes[count].Operation := API_DIFF_DELETE;
            ApiStateDiff.Changes[count].RoomId := ApiStateShadow[i].RoomId;
            ApiClearRoomState(ApiStateDiff.Changes[count].Room);
        END_IF;
    END_IF;

    ApiStateShadow[i] := ApiState.Rooms[i];
END_FOR;

(* Zverejnenie rámca a revízie sa vykoná a po naplnení všetkıch poloiek. *)
ApiStateDiff.ChangeCount := count;
ApiStateDiff.Valid := TRUE;
ApiInfo.StateRevision := newRev;

(* Uloenie hotového rámca do osemprvkovej kruhovej histórie. *)
IF ApiStateHistoryHead >= C_DIFF_HISTORY_DEPTH THEN
    ApiStateHistoryHead := 1;
ELSE
    ApiStateHistoryHead := ApiStateHistoryHead + 1;
END_IF;
ApiStateDiffHistory[ApiStateHistoryHead] := ApiStateDiff;
END_FUNCTION
