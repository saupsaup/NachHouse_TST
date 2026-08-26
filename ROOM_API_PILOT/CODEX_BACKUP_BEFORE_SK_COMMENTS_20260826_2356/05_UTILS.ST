(* ROOM_API_PILOT - small deterministic helpers. *)

FUNCTION ApiRoomConfigEqual : BOOL
VAR_INPUT
    A : T_ROOM_CONFIG;
    B : T_ROOM_CONFIG;
END_VAR

ApiRoomConfigEqual :=
    (A.Used = B.Used) AND
    (A.RoomId = B.RoomId) AND
    (A.Name = B.Name) AND
    (A.ProjectName = B.ProjectName) AND
    (A.IconId = B.IconId) AND
    (A.SortDefault = B.SortDefault);
END_FUNCTION


FUNCTION ApiRoomStateEqual : BOOL
VAR_INPUT
    A : T_ROOM_STATE;
    B : T_ROOM_STATE;
END_VAR

ApiRoomStateEqual :=
    (A.RoomId = B.RoomId) AND
    (A.Temperature = B.Temperature) AND
    (A.Humidity = B.Humidity) AND
    (A.Presence = B.Presence) AND
    (A.DayPhase = B.DayPhase) AND
    (A.CategoryMask = B.CategoryMask) AND
    (A.AlarmLevel = B.AlarmLevel) AND
    (A.Online = B.Online);
END_FUNCTION


FUNCTION ApiFindConfigSlot : USINT
VAR_INPUT
    RoomId : UDINT;
END_VAR
VAR
    i : USINT;
END_VAR

ApiFindConfigSlot := 0;
IF RoomId <> 0 THEN
    FOR i := 1 TO C_MAX_ROOMS DO
        IF ApiConfig.Rooms[i].Used AND (ApiConfig.Rooms[i].RoomId = RoomId) THEN
            ApiFindConfigSlot := i;
            RETURN;
        END_IF;
    END_FOR;
END_IF;
END_FUNCTION


FUNCTION ApiFindStateSlot : USINT
VAR_INPUT
    RoomId : UDINT;
END_VAR
VAR
    i : USINT;
END_VAR

ApiFindStateSlot := 0;
IF RoomId <> 0 THEN
    FOR i := 1 TO C_MAX_ROOMS DO
        IF ApiState.Rooms[i].RoomId = RoomId THEN
            ApiFindStateSlot := i;
            RETURN;
        END_IF;
    END_FOR;
END_IF;
END_FUNCTION


FUNCTION ApiFindFreeConfigSlot : USINT
VAR
    i : USINT;
END_VAR

ApiFindFreeConfigSlot := 0;
FOR i := 1 TO C_MAX_ROOMS DO
    IF NOT ApiConfig.Rooms[i].Used THEN
        ApiFindFreeConfigSlot := i;
        RETURN;
    END_IF;
END_FOR;
END_FUNCTION


FUNCTION ApiFindFreeStateSlot : USINT
VAR
    i : USINT;
END_VAR

ApiFindFreeStateSlot := 0;
FOR i := 1 TO C_MAX_ROOMS DO
    IF ApiState.Rooms[i].RoomId = 0 THEN
        ApiFindFreeStateSlot := i;
        RETURN;
    END_IF;
END_FOR;
END_FUNCTION


FUNCTION ApiClearRoomConfig : BOOL
VAR_IN_OUT
    Room : T_ROOM_CONFIG;
END_VAR

Room.Used := FALSE;
Room.RoomId := 0;
Room.Name := '';
Room.ProjectName := '';
Room.IconId := 0;
Room.SortDefault := 0;
ApiClearRoomConfig := TRUE;
END_FUNCTION


FUNCTION ApiClearRoomState : BOOL
VAR_IN_OUT
    Room : T_ROOM_STATE;
END_VAR

Room.RoomId := 0;
Room.Temperature := 0.0;
Room.Humidity := 0.0;
Room.Presence := FALSE;
Room.DayPhase := API_DAY_PHASE_DAY;
Room.CategoryMask := DWORD#16#00000000;
Room.AlarmLevel := API_ALARM_OK;
Room.Online := FALSE;
ApiClearRoomState := TRUE;
END_FUNCTION


FUNCTION ApiClearConfigDiff : BOOL
VAR_IN_OUT
    Diff : T_API_CONFIG_DIFF;
END_VAR
VAR
    i : USINT;
END_VAR

Diff.Valid := FALSE;
Diff.FromRevision := 0;
Diff.ToRevision := 0;
Diff.FullRequired := FALSE;
Diff.ChangeCount := 0;
FOR i := 1 TO C_MAX_ROOMS DO
    Diff.Changes[i].Valid := FALSE;
    Diff.Changes[i].Operation := API_DIFF_NONE;
    Diff.Changes[i].RoomId := 0;
    ApiClearRoomConfig(Diff.Changes[i].Room);
END_FOR;
ApiClearConfigDiff := TRUE;
END_FUNCTION


FUNCTION ApiClearStateDiff : BOOL
VAR_IN_OUT
    Diff : T_API_STATE_DIFF;
END_VAR
VAR
    i : USINT;
END_VAR

Diff.Valid := FALSE;
Diff.FromRevision := 0;
Diff.ToRevision := 0;
Diff.FullRequired := FALSE;
Diff.ChangeCount := 0;
FOR i := 1 TO C_MAX_ROOMS DO
    Diff.Changes[i].Valid := FALSE;
    Diff.Changes[i].Operation := API_DIFF_NONE;
    Diff.Changes[i].RoomId := 0;
    ApiClearRoomState(Diff.Changes[i].Room);
END_FOR;
ApiClearStateDiff := TRUE;
END_FUNCTION


FUNCTION ApiNextRevision : UDINT
VAR_INPUT
    Revision : UDINT;
END_VAR

ApiNextRevision := Revision + 1;
IF ApiNextRevision = 0 THEN
    ApiNextRevision := 1;
END_IF;
END_FUNCTION


FUNCTION ApiValidDayPhase : BOOL
VAR_INPUT
    DayPhase : UINT;
END_VAR

ApiValidDayPhase :=
    (DayPhase = API_DAY_PHASE_DAY) OR
    (DayPhase = API_DAY_PHASE_DUSK) OR
    (DayPhase = API_DAY_PHASE_NIGHT) OR
    (DayPhase = API_DAY_PHASE_DAWN);
END_FUNCTION
