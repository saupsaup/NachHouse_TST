PROGRAM prgMain
VAR
END_VAR

ApiPilotInit();

IF ApiInitialized THEN
    ApiProcessRoomCommand();
    ApiProcessTestState();

    (* Also catches manual edits made from the Mosaic watch window. *)
    ApiCaptureConfigChanges();
    ApiCaptureStateChanges();

    ApiProcessSyncRequest();
END_IF;
END_PROGRAM

