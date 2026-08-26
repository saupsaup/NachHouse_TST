(* Manual, validated test-state writer. No real IO is connected. *)

FUNCTION ApiProcessTestState : BOOL
VAR
    configSlot    : USINT;
    stateSlot     : USINT;
    resultCode    : USINT;
    resultMessage : STRING[80];
END_VAR

ApiProcessTestState := FALSE;
IF NOT ApiTestStateExecute THEN
    RETURN;
END_IF;

ApiProcessTestState := TRUE;
ApiTestStateBusy := TRUE;
ApiTestStateFinished := FALSE;
resultCode := API_RESULT_OK;
resultMessage := 'Testovaci stav nastaveny';

configSlot := ApiFindConfigSlot(ApiTestStateRequest.RoomId);
stateSlot := ApiFindStateSlot(ApiTestStateRequest.RoomId);

IF (ApiTestStateRequest.ClientId = '') OR
   (ApiTestStateRequest.RequestId = 0) THEN
    resultCode := API_RESULT_INVALID_ARGUMENT;
    resultMessage := 'Neplatny ClientId alebo RequestId';
ELSIF (configSlot = 0) OR (stateSlot = 0) THEN
    resultCode := API_RESULT_NOT_FOUND;
    resultMessage := 'Miestnost nenajdena';
ELSIF (ApiTestStateRequest.Temperature < -50.0) OR
      (ApiTestStateRequest.Temperature > 100.0) OR
      (ApiTestStateRequest.Humidity < 0.0) OR
      (ApiTestStateRequest.Humidity > 100.0) OR
      (ApiTestStateRequest.AlarmLevel > API_ALARM_ALARM) OR
      (NOT ApiValidDayPhase(ApiTestStateRequest.DayPhase)) THEN
    resultCode := API_RESULT_INVALID_ARGUMENT;
    resultMessage := 'Neplatna testovacia hodnota';
ELSE
    ApiState.Rooms[stateSlot].Temperature := ApiTestStateRequest.Temperature;
    ApiState.Rooms[stateSlot].Humidity := ApiTestStateRequest.Humidity;
    ApiState.Rooms[stateSlot].Presence := ApiTestStateRequest.Presence;
    ApiState.Rooms[stateSlot].DayPhase := ApiTestStateRequest.DayPhase;
    ApiState.Rooms[stateSlot].CategoryMask := ApiTestStateRequest.CategoryMask;
    ApiState.Rooms[stateSlot].AlarmLevel := ApiTestStateRequest.AlarmLevel;
    ApiState.Rooms[stateSlot].Online := ApiTestStateRequest.Online;
    ApiCaptureStateChanges();
END_IF;

ApiTestStateResult.ClientId := ApiTestStateRequest.ClientId;
ApiTestStateResult.RequestId := ApiTestStateRequest.RequestId;
ApiTestStateResult.Result := resultCode;
ApiTestStateResult.Message := resultMessage;
ApiTestStateResult.ConfigRevision := ApiInfo.ConfigRevision;
ApiTestStateResult.StateRevision := ApiInfo.StateRevision;

ApiTestStateExecute := FALSE;
ApiTestStateBusy := FALSE;
ApiTestStateFinished := TRUE;
END_FUNCTION
