(* Ruènı validovanı zápis testovacieho stavu; nie je pripojené iadne reálne IO. *)

(* Spracuje najviac jednu testovaciu poiadavku po nastavení ApiTestStateExecute. *)
FUNCTION ApiProcessTestState : BOOL
VAR
    configSlot    : USINT;      (* Pozícia konfigurácie cie¾ovej miestnosti. ENG *)
    stateSlot     : USINT;      (* Pozícia stavového záznamu cie¾ovej miestnosti. ENG *)
    resultCode    : USINT;      (* Pracovnı návratovı kód API_RESULT_*. ENG *)
    resultMessage : STRING[80]; (* Pracovnı slovenskı text vısledku. *)
END_VAR

(* Bez spúšacieho príznaku funkcia skonèí bez ved¾ajších úèinkov. *)
ApiProcessTestState := FALSE;
IF NOT ApiTestStateExecute THEN
    RETURN;
END_IF;

(* Prevzatie poiadavky a nastavenie predvoleného úspešného vısledku. *)
ApiProcessTestState := TRUE;
ApiTestStateBusy := TRUE;
ApiTestStateFinished := FALSE;
resultCode := API_RESULT_OK;
resultMessage := 'Testovaci stav nastaveny';

(* Miestnos musí existova súèasne v konfigurácii aj v stavovom snapshote. *)
configSlot := ApiFindConfigSlot(ApiTestStateRequest.RoomId);
stateSlot := ApiFindStateSlot(ApiTestStateRequest.RoomId);

(* Validácia identity poiadavky, existencie miestnosti a povolenıch rozsahov. *)
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
    (* Platné hodnoty sa zapíšu iba do dynamického stavu, nie do konfigurácie. *)
    ApiState.Rooms[stateSlot].Temperature := ApiTestStateRequest.Temperature;
    ApiState.Rooms[stateSlot].Humidity := ApiTestStateRequest.Humidity;
    ApiState.Rooms[stateSlot].Presence := ApiTestStateRequest.Presence;
    ApiState.Rooms[stateSlot].DayPhase := ApiTestStateRequest.DayPhase;
    ApiState.Rooms[stateSlot].CategoryMask := ApiTestStateRequest.CategoryMask;
    ApiState.Rooms[stateSlot].AlarmLevel := ApiTestStateRequest.AlarmLevel;
    ApiState.Rooms[stateSlot].Online := ApiTestStateRequest.Online;
    ApiCaptureStateChanges();
END_IF;

(* Vısledok obsahuje identitu poiadavky a revízie platné po spracovaní. *)
ApiTestStateResult.ClientId := ApiTestStateRequest.ClientId;
ApiTestStateResult.RequestId := ApiTestStateRequest.RequestId;
ApiTestStateResult.Result := resultCode;
ApiTestStateResult.Message := resultMessage;
ApiTestStateResult.ConfigRevision := ApiInfo.ConfigRevision;
ApiTestStateResult.StateRevision := ApiInfo.StateRevision;

(* Ukonèenie testovacieho handshake kanála. ENG *)
ApiTestStateExecute := FALSE;
ApiTestStateBusy := FALSE;
ApiTestStateFinished := TRUE;
END_FUNCTION
