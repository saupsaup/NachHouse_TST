(* Cold-start initialization and deterministic pilot data. *)

FUNCTION ApiPilotInit : BOOL
VAR
    i : USINT;
END_VAR

ApiPilotInit := ApiInitialized;
IF ApiInitialized THEN
    RETURN;
END_IF;

FOR i := 1 TO C_MAX_ROOMS DO
    ApiClearRoomConfig(ApiConfig.Rooms[i]);
    ApiClearRoomState(ApiState.Rooms[i]);
    ApiClearRoomConfig(ApiConfigShadow[i]);
    ApiClearRoomState(ApiStateShadow[i]);
END_FOR;

FOR i := 1 TO C_DIFF_HISTORY_DEPTH DO
    ApiClearConfigDiff(ApiConfigDiffHistory[i]);
    ApiClearStateDiff(ApiStateDiffHistory[i]);
END_FOR;

(* Four sample rooms. Values are test data only. *)
ApiConfig.Rooms[1].Used := TRUE;
ApiConfig.Rooms[1].RoomId := 1;
ApiConfig.Rooms[1].Name := 'Obyvacka';
ApiConfig.Rooms[1].ProjectName := '1.01';
ApiConfig.Rooms[1].IconId := 16;
ApiConfig.Rooms[1].SortDefault := 1;

ApiConfig.Rooms[2].Used := TRUE;
ApiConfig.Rooms[2].RoomId := 2;
ApiConfig.Rooms[2].Name := 'Kuchyna';
ApiConfig.Rooms[2].ProjectName := '1.07';
ApiConfig.Rooms[2].IconId := 16;
ApiConfig.Rooms[2].SortDefault := 2;

ApiConfig.Rooms[3].Used := TRUE;
ApiConfig.Rooms[3].RoomId := 3;
ApiConfig.Rooms[3].Name := 'Spalna';
ApiConfig.Rooms[3].ProjectName := '1.09';
ApiConfig.Rooms[3].IconId := 16;
ApiConfig.Rooms[3].SortDefault := 3;

ApiConfig.Rooms[4].Used := TRUE;
ApiConfig.Rooms[4].RoomId := 4;
ApiConfig.Rooms[4].Name := 'Terasa';
ApiConfig.Rooms[4].ProjectName := 'E.01';
ApiConfig.Rooms[4].IconId := 19;
ApiConfig.Rooms[4].SortDefault := 4;

ApiState.Rooms[1].RoomId := 1;
ApiState.Rooms[1].Temperature := 22.5;
ApiState.Rooms[1].Humidity := 45.0;
ApiState.Rooms[1].Presence := TRUE;
ApiState.Rooms[1].DayPhase := API_DAY_PHASE_DAY;
ApiState.Rooms[1].CategoryMask := DWORD#16#00000007;
ApiState.Rooms[1].AlarmLevel := API_ALARM_OK;
ApiState.Rooms[1].Online := TRUE;

ApiState.Rooms[2].RoomId := 2;
ApiState.Rooms[2].Temperature := 23.0;
ApiState.Rooms[2].Humidity := 48.0;
ApiState.Rooms[2].Presence := FALSE;
ApiState.Rooms[2].DayPhase := API_DAY_PHASE_DUSK;
ApiState.Rooms[2].CategoryMask := DWORD#16#00000003;
ApiState.Rooms[2].AlarmLevel := API_ALARM_WARNING;
ApiState.Rooms[2].Online := TRUE;

ApiState.Rooms[3].RoomId := 3;
ApiState.Rooms[3].Temperature := 21.8;
ApiState.Rooms[3].Humidity := 42.0;
ApiState.Rooms[3].Presence := TRUE;
ApiState.Rooms[3].DayPhase := API_DAY_PHASE_NIGHT;
ApiState.Rooms[3].CategoryMask := DWORD#16#00000001;
ApiState.Rooms[3].AlarmLevel := API_ALARM_OK;
ApiState.Rooms[3].Online := TRUE;

ApiState.Rooms[4].RoomId := 4;
ApiState.Rooms[4].Temperature := 18.4;
ApiState.Rooms[4].Humidity := 58.0;
ApiState.Rooms[4].Presence := FALSE;
ApiState.Rooms[4].DayPhase := API_DAY_PHASE_DAWN;
ApiState.Rooms[4].CategoryMask := DWORD#16#00000004;
ApiState.Rooms[4].AlarmLevel := API_ALARM_ALARM;
ApiState.Rooms[4].Online := FALSE;

FOR i := 1 TO C_MAX_ROOMS DO
    ApiConfigShadow[i] := ApiConfig.Rooms[i];
    ApiStateShadow[i] := ApiState.Rooms[i];
END_FOR;

ApiInfo.ApiVersion := C_API_VERSION;
ApiInfo.ConfigRevision := 1;
ApiInfo.StateRevision := 1;
ApiInfo.MaxRooms := C_MAX_ROOMS;
ApiInfo.LastCommandResult.ClientId := '';
ApiInfo.LastCommandResult.RequestId := 0;
ApiInfo.LastCommandResult.Result := API_RESULT_NONE;
ApiInfo.LastCommandResult.Message := 'Ziadny prikaz';
ApiInfo.LastCommandResult.ConfigRevision := 1;
ApiInfo.LastCommandResult.StateRevision := 1;

ApiClearConfigDiff(ApiConfigDiff);
ApiConfigDiff.Valid := TRUE;
ApiConfigDiff.FromRevision := 0;
ApiConfigDiff.ToRevision := 1;
ApiConfigDiff.FullRequired := TRUE;

ApiClearStateDiff(ApiStateDiff);
ApiStateDiff.Valid := TRUE;
ApiStateDiff.FromRevision := 0;
ApiStateDiff.ToRevision := 1;
ApiStateDiff.FullRequired := TRUE;

ApiCommandRoom.ClientId := '';
ApiCommandRoom.RequestId := 0;
ApiCommandRoom.Action := API_ACTION_NONE;
ApiCommandRoom.RoomId := 0;
ApiCommandRoom.SourceRoomId := 0;
ApiCommandRoom.Name := '';
ApiCommandRoom.ProjectName := '';
ApiCommandExecute := FALSE;
ApiCommandBusy := FALSE;
ApiCommandFinished := FALSE;
ApiCommandResult := ApiInfo.LastCommandResult;

ApiSyncExecute := FALSE;
ApiSyncBusy := FALSE;
ApiSyncFinished := FALSE;
ApiTestStateExecute := FALSE;
ApiTestStateBusy := FALSE;
ApiTestStateFinished := FALSE;

ApiConfigHistoryHead := 0;
ApiStateHistoryHead := 0;
ApiLastCommandClientId := '';
ApiLastCommandRequestId := 0;
ApiLastStoredResult := ApiInfo.LastCommandResult;

ApiInitialized := TRUE;
ApiPilotInit := TRUE;
END_FUNCTION
