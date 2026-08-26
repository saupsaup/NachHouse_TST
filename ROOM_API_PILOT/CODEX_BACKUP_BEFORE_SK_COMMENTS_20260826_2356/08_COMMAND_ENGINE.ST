(* ADD / DELETE / COPY / SET command processor. *)

FUNCTION ApiProcessRoomCommand : BOOL
VAR
    i             : USINT;
    configSlot    : USINT;
    stateSlot     : USINT;
    sourceCfgSlot : USINT;
    sourceStSlot  : USINT;
    maxSort       : UINT;
    sourceSort    : UINT;
    resultCode    : USINT;
    resultMessage : STRING[80];
    executeChange : BOOL;
END_VAR

ApiProcessRoomCommand := FALSE;
IF NOT ApiCommandExecute THEN
    RETURN;
END_IF;

ApiProcessRoomCommand := TRUE;
ApiCommandBusy := TRUE;
ApiCommandFinished := FALSE;

(* Exact retry of the latest command is idempotent. *)
IF (ApiCommandRoom.ClientId = ApiLastCommandClientId) AND
   (ApiCommandRoom.RequestId = ApiLastCommandRequestId) AND
   (ApiCommandRoom.RequestId <> 0) THEN

    ApiCommandResult := ApiLastStoredResult;
    ApiInfo.LastCommandResult := ApiLastStoredResult;

ELSE
    resultCode := API_RESULT_OK;
    resultMessage := 'OK';
    executeChange := FALSE;

    IF (ApiCommandRoom.ClientId = '') OR (ApiCommandRoom.RequestId = 0) THEN
        resultCode := API_RESULT_INVALID_ARGUMENT;
        resultMessage := 'Neplatny ClientId alebo RequestId';
    ELSE
        CASE ApiCommandRoom.Action OF

            API_ACTION_ADD_ROOM:
                IF (ApiCommandRoom.RoomId = 0) OR (ApiCommandRoom.Name = '') THEN
                    resultCode := API_RESULT_INVALID_ARGUMENT;
                    resultMessage := 'Neplatne ID alebo nazov';
                ELSIF ApiFindConfigSlot(ApiCommandRoom.RoomId) <> 0 THEN
                    resultCode := API_RESULT_ALREADY_EXISTS;
                    resultMessage := 'RoomId uz existuje';
                ELSE
                    configSlot := ApiFindFreeConfigSlot();
                    stateSlot := ApiFindFreeStateSlot();
                    IF (configSlot = 0) OR (stateSlot = 0) THEN
                        resultCode := API_RESULT_NO_FREE_SLOT;
                        resultMessage := 'Nie je volny slot';
                    ELSE
                        maxSort := 0;
                        FOR i := 1 TO C_MAX_ROOMS DO
                            IF ApiConfig.Rooms[i].Used AND
                               (ApiConfig.Rooms[i].SortDefault > maxSort) THEN
                                maxSort := ApiConfig.Rooms[i].SortDefault;
                            END_IF;
                        END_FOR;

                        ApiClearRoomConfig(ApiConfig.Rooms[configSlot]);
                        ApiConfig.Rooms[configSlot].Used := TRUE;
                        ApiConfig.Rooms[configSlot].RoomId := ApiCommandRoom.RoomId;
                        ApiConfig.Rooms[configSlot].Name := ApiCommandRoom.Name;
                        ApiConfig.Rooms[configSlot].ProjectName := ApiCommandRoom.ProjectName;
                        ApiConfig.Rooms[configSlot].IconId := API_DEFAULT_ICON_ID;
                        ApiConfig.Rooms[configSlot].SortDefault := maxSort + 1;

                        ApiClearRoomState(ApiState.Rooms[stateSlot]);
                        ApiState.Rooms[stateSlot].RoomId := ApiCommandRoom.RoomId;
                        ApiState.Rooms[stateSlot].Temperature := API_DEFAULT_TEMPERATURE;
                        ApiState.Rooms[stateSlot].Humidity := API_DEFAULT_HUMIDITY;
                        ApiState.Rooms[stateSlot].Presence := FALSE;
                        ApiState.Rooms[stateSlot].DayPhase := API_DAY_PHASE_DAY;
                        ApiState.Rooms[stateSlot].CategoryMask := DWORD#16#00000000;
                        ApiState.Rooms[stateSlot].AlarmLevel := API_ALARM_OK;
                        ApiState.Rooms[stateSlot].Online := TRUE;

                        executeChange := TRUE;
                        resultMessage := 'Miestnost pridana';
                    END_IF;
                END_IF;

            API_ACTION_DELETE_ROOM:
                configSlot := ApiFindConfigSlot(ApiCommandRoom.RoomId);
                stateSlot := ApiFindStateSlot(ApiCommandRoom.RoomId);
                IF (configSlot = 0) OR (stateSlot = 0) THEN
                    resultCode := API_RESULT_NOT_FOUND;
                    resultMessage := 'Miestnost nenajdena';
                ELSE
                    ApiClearRoomConfig(ApiConfig.Rooms[configSlot]);
                    ApiClearRoomState(ApiState.Rooms[stateSlot]);
                    executeChange := TRUE;
                    resultMessage := 'Miestnost zmazana';
                END_IF;

            API_ACTION_COPY_ROOM:
                sourceCfgSlot := ApiFindConfigSlot(ApiCommandRoom.SourceRoomId);
                sourceStSlot := ApiFindStateSlot(ApiCommandRoom.SourceRoomId);
                IF (ApiCommandRoom.RoomId = 0) OR
                   (ApiCommandRoom.RoomId = ApiCommandRoom.SourceRoomId) THEN
                    resultCode := API_RESULT_INVALID_ARGUMENT;
                    resultMessage := 'Neplatne cielove RoomId';
                ELSIF (sourceCfgSlot = 0) OR (sourceStSlot = 0) THEN
                    resultCode := API_RESULT_NOT_FOUND;
                    resultMessage := 'Zdrojova miestnost nenajdena';
                ELSIF ApiFindConfigSlot(ApiCommandRoom.RoomId) <> 0 THEN
                    resultCode := API_RESULT_ALREADY_EXISTS;
                    resultMessage := 'Cielove RoomId uz existuje';
                ELSE
                    configSlot := ApiFindFreeConfigSlot();
                    stateSlot := ApiFindFreeStateSlot();
                    IF (configSlot = 0) OR (stateSlot = 0) THEN
                        resultCode := API_RESULT_NO_FREE_SLOT;
                        resultMessage := 'Nie je volny slot';
                    ELSE
                        sourceSort := ApiConfig.Rooms[sourceCfgSlot].SortDefault;
                        FOR i := 1 TO C_MAX_ROOMS DO
                            IF ApiConfig.Rooms[i].Used AND
                               (ApiConfig.Rooms[i].SortDefault > sourceSort) THEN
                                ApiConfig.Rooms[i].SortDefault :=
                                    ApiConfig.Rooms[i].SortDefault + 1;
                            END_IF;
                        END_FOR;

                        ApiConfig.Rooms[configSlot] := ApiConfig.Rooms[sourceCfgSlot];
                        ApiConfig.Rooms[configSlot].RoomId := ApiCommandRoom.RoomId;
                        ApiConfig.Rooms[configSlot].SortDefault := sourceSort + 1;
                        IF ApiCommandRoom.Name <> '' THEN
                            ApiConfig.Rooms[configSlot].Name := ApiCommandRoom.Name;
                        END_IF;
                        IF ApiCommandRoom.ProjectName <> '' THEN
                            ApiConfig.Rooms[configSlot].ProjectName := ApiCommandRoom.ProjectName;
                        END_IF;

                        ApiState.Rooms[stateSlot] := ApiState.Rooms[sourceStSlot];
                        ApiState.Rooms[stateSlot].RoomId := ApiCommandRoom.RoomId;

                        executeChange := TRUE;
                        resultMessage := 'Miestnost skopirovana';
                    END_IF;
                END_IF;

            API_ACTION_SET_ROOM_DATA:
                configSlot := ApiFindConfigSlot(ApiCommandRoom.RoomId);
                IF configSlot = 0 THEN
                    resultCode := API_RESULT_NOT_FOUND;
                    resultMessage := 'Miestnost nenajdena';
                ELSIF ApiCommandRoom.Name = '' THEN
                    resultCode := API_RESULT_INVALID_ARGUMENT;
                    resultMessage := 'Nazov nesmie byt prazdny';
                ELSE
                    ApiConfig.Rooms[configSlot].Name := ApiCommandRoom.Name;
                    ApiConfig.Rooms[configSlot].ProjectName := ApiCommandRoom.ProjectName;
                    executeChange := TRUE;
                    resultMessage := 'Udaje miestnosti nastavene';
                END_IF;

            ELSE
                resultCode := API_RESULT_UNSUPPORTED_ACTION;
                resultMessage := 'Nepodporovana akcia';
        END_CASE;
    END_IF;

    IF executeChange AND (resultCode = API_RESULT_OK) THEN
        ApiCaptureConfigChanges();
        ApiCaptureStateChanges();
    END_IF;

    ApiCommandResult.ClientId := ApiCommandRoom.ClientId;
    ApiCommandResult.RequestId := ApiCommandRoom.RequestId;
    ApiCommandResult.Result := resultCode;
    ApiCommandResult.Message := resultMessage;
    ApiCommandResult.ConfigRevision := ApiInfo.ConfigRevision;
    ApiCommandResult.StateRevision := ApiInfo.StateRevision;

    ApiInfo.LastCommandResult := ApiCommandResult;
    ApiLastCommandClientId := ApiCommandRoom.ClientId;
    ApiLastCommandRequestId := ApiCommandRoom.RequestId;
    ApiLastStoredResult := ApiCommandResult;
END_IF;

ApiCommandExecute := FALSE;
ApiCommandBusy := FALSE;
ApiCommandFinished := TRUE;
END_FUNCTION
