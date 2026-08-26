(*
   Diff engine.
   One PLC transaction creates one revision and one complete diff frame.
   Eight frames are retained. A client asks for one next frame at a time.
*)

FUNCTION ApiCaptureConfigChanges : BOOL
VAR
    i          : USINT;
    count      : USINT;
    oldRev     : UDINT;
    newRev     : UDINT;
    anyChanged : BOOL;
END_VAR

anyChanged := FALSE;
FOR i := 1 TO C_MAX_ROOMS DO
    IF NOT ApiRoomConfigEqual(ApiConfig.Rooms[i], ApiConfigShadow[i]) THEN
        anyChanged := TRUE;
    END_IF;
END_FOR;

ApiCaptureConfigChanges := anyChanged;
IF NOT anyChanged THEN
    RETURN;
END_IF;

ApiClearConfigDiff(ApiConfigDiff);
oldRev := ApiInfo.ConfigRevision;
newRev := ApiNextRevision(oldRev);
ApiConfigDiff.FromRevision := oldRev;
ApiConfigDiff.ToRevision := newRev;
ApiConfigDiff.FullRequired := FALSE;
count := 0;

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

ApiConfigDiff.ChangeCount := count;
ApiConfigDiff.Valid := TRUE;
ApiInfo.ConfigRevision := newRev;

IF ApiConfigHistoryHead >= C_DIFF_HISTORY_DEPTH THEN
    ApiConfigHistoryHead := 1;
ELSE
    ApiConfigHistoryHead := ApiConfigHistoryHead + 1;
END_IF;
ApiConfigDiffHistory[ApiConfigHistoryHead] := ApiConfigDiff;
END_FUNCTION


FUNCTION ApiCaptureStateChanges : BOOL
VAR
    i          : USINT;
    count      : USINT;
    oldRev     : UDINT;
    newRev     : UDINT;
    anyChanged : BOOL;
END_VAR

anyChanged := FALSE;
FOR i := 1 TO C_MAX_ROOMS DO
    IF NOT ApiRoomStateEqual(ApiState.Rooms[i], ApiStateShadow[i]) THEN
        anyChanged := TRUE;
    END_IF;
END_FOR;

ApiCaptureStateChanges := anyChanged;
IF NOT anyChanged THEN
    RETURN;
END_IF;

ApiClearStateDiff(ApiStateDiff);
oldRev := ApiInfo.StateRevision;
newRev := ApiNextRevision(oldRev);
ApiStateDiff.FromRevision := oldRev;
ApiStateDiff.ToRevision := newRev;
ApiStateDiff.FullRequired := FALSE;
count := 0;

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

ApiStateDiff.ChangeCount := count;
ApiStateDiff.Valid := TRUE;
ApiInfo.StateRevision := newRev;

IF ApiStateHistoryHead >= C_DIFF_HISTORY_DEPTH THEN
    ApiStateHistoryHead := 1;
ELSE
    ApiStateHistoryHead := ApiStateHistoryHead + 1;
END_IF;
ApiStateDiffHistory[ApiStateHistoryHead] := ApiStateDiff;
END_FUNCTION
