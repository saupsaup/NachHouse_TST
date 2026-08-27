(* Spracovanie prÌkazov ADD / DELETE / COPY / SET pre miestnosti. ENG *)

(* Spracuje najviac jeden prÌkaz, iba ak klient nastavil ApiCommandExecute. *)
FUNCTION ApiProcessRoomCommand : BOOL
VAR
    i             : USINT;     (* Index pri prechode poæom miestnostÌ. *)
    configSlot    : USINT;     (* N·jden· alebo voæn· pozÌcia cieæovej konfigur·cie. ENG *)
    stateSlot     : USINT;     (* N·jden· alebo voæn· pozÌcia cieæovÈho stavu. ENG *)
    sourceCfgSlot : USINT;     (* PozÌcia zdrojovej konfigur·cie pri kopÌrovanÌ. ENG *)
    sourceStSlot  : USINT;     (* PozÌcia zdrojovÈho stavu pri kopÌrovanÌ. ENG *)
    maxSort       : UINT;      (* Najvyööie pouûitÈ predvolenÈ poradie pri prid·vanÌ. ENG *)
    sourceSort    : UINT;      (* PredvolenÈ poradie zdroja pri vkladanÌ jeho kÛpie. ENG *)
    resultCode    : USINT;     (* Pracovn˝ n·vratov˝ kÛd API_RESULT_*. ENG *)
    resultMessage : STRING[80]; (* Pracovn˝ slovensk˝ text v˝sledku. *)
    executeChange : BOOL;      (* TRUE iba vtedy, keÔ sa snapshot skutoËne zmenil. ENG *)
END_VAR

(* Bez sp˙öùacieho prÌznaku funkcia okamûite skonËÌ bez vedæajöÌch ˙Ëinkov. *)
ApiProcessRoomCommand := FALSE;
IF NOT ApiCommandExecute THEN
    RETURN;
END_IF;

(* ZaËiatok dvojf·zovÈho handshake: prÌkaz je prevzat˝ na spracovanie. ENG *)
ApiProcessRoomCommand := TRUE;
ApiCommandBusy := TRUE;
ApiCommandFinished := FALSE;

(* PresnÈ zopakovanie poslednÈho ClientId + RequestId je idempotentnÈ. ENG *)
IF (ApiCommandRoom.ClientId = ApiLastCommandClientId) AND
   (ApiCommandRoom.RequestId = ApiLastCommandRequestId) AND
   (ApiCommandRoom.RequestId <> 0) THEN

    ApiCommandResult := ApiLastStoredResult;
    ApiInfo.LastCommandResult := ApiLastStoredResult;

ELSE
    (* PredvolenÈ hodnoty pre nov˝, eöte nespracovan˝ prÌkaz. *)
    resultCode := API_RESULT_OK;
    resultMessage := 'OK';
    executeChange := FALSE;

    (* SpoloËn· kontrola povinn˝ch identifik·torov transportu. *)
    IF (ApiCommandRoom.ClientId = '') OR (ApiCommandRoom.RequestId = 0) THEN
        resultCode := API_RESULT_INVALID_ARGUMENT;
        resultMessage := 'Neplatny ClientId alebo RequestId';
    ELSE
        (* Rozdelenie spracovania podæa verejnÈho ËÌselnÈho kÛdu Action. ENG *)
        CASE ApiCommandRoom.Action OF

            API_ACTION_ADD_ROOM:
                (* ADD: overÌ cieæ, n·jde voænÈ sloty a vytvorÌ konfigur·ciu aj stav. ENG *)
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
                        (* Nov· miestnosù sa zaradÌ za najvyööie existuj˙ce SortDefault. ENG *)
                        maxSort := 0;
                        FOR i := 1 TO C_MAX_ROOMS DO
                            IF ApiConfig.Rooms[i].Used AND
                               (ApiConfig.Rooms[i].SortDefault > maxSort) THEN
                                maxSort := ApiConfig.Rooms[i].SortDefault;
                            END_IF;
                        END_FOR;

                        (* Vytvorenie cieæovej konfigur·cie z ˙dajov klienta a predvolenej ikony. *)
                        ApiClearRoomConfig(ApiConfig.Rooms[configSlot]);
                        ApiConfig.Rooms[configSlot].Used := TRUE;
                        ApiConfig.Rooms[configSlot].RoomId := ApiCommandRoom.RoomId;
                        ApiConfig.Rooms[configSlot].Name := ApiCommandRoom.Name;
                        ApiConfig.Rooms[configSlot].ProjectName := ApiCommandRoom.ProjectName;
                        ApiConfig.Rooms[configSlot].IconId := API_DEFAULT_ICON_ID;
                        ApiConfig.Rooms[configSlot].SortDefault := maxSort + 1;

                        (* Vytvorenie samostatnÈho stavovÈho z·znamu s testovacÌmi hodnotami. *)
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
                (* DELETE: konfigur·cia aj stav musia existovaù, potom sa oba sloty vyËistia. ENG *)
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
                (* COPY: najprv sa overÌ zdroj aj jedineËnosù cieæovÈho RoomId. ENG *)
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
                        (* Pre kÛpiu sa uvoænÌ poradie hneÔ za zdrojovou miestnosùou. *)
                        sourceSort := ApiConfig.Rooms[sourceCfgSlot].SortDefault;
                        FOR i := 1 TO C_MAX_ROOMS DO
                            IF ApiConfig.Rooms[i].Used AND
                               (ApiConfig.Rooms[i].SortDefault > sourceSort) THEN
                                ApiConfig.Rooms[i].SortDefault :=
                                    ApiConfig.Rooms[i].SortDefault + 1;
                            END_IF;
                        END_FOR;

                        (* Konfigur·cia sa kopÌruje cel·; klient mÙûe voliteæne prepÌsaù n·zvy. *)
                        ApiConfig.Rooms[configSlot] := ApiConfig.Rooms[sourceCfgSlot];
                        ApiConfig.Rooms[configSlot].RoomId := ApiCommandRoom.RoomId;
                        ApiConfig.Rooms[configSlot].SortDefault := sourceSort + 1;
                        IF ApiCommandRoom.Name <> '' THEN
                            ApiConfig.Rooms[configSlot].Name := ApiCommandRoom.Name;
                        END_IF;
                        IF ApiCommandRoom.ProjectName <> '' THEN
                            ApiConfig.Rooms[configSlot].ProjectName := ApiCommandRoom.ProjectName;
                        END_IF;

                        (* Pilot kopÌruje aj ruËne nastaven˝ stav, ale priradÌ novÈ RoomId. ENG *)
                        ApiState.Rooms[stateSlot] := ApiState.Rooms[sourceStSlot];
                        ApiState.Rooms[stateSlot].RoomId := ApiCommandRoom.RoomId;

                        executeChange := TRUE;
                        resultMessage := 'Miestnost skopirovana';
                    END_IF;
                END_IF;

            API_ACTION_SET_ROOM_DATA:
                (* SET: v pilote menÌ iba hlavn˝ a doplnkov˝ n·zov miestnosti. ENG *)
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
                (* Nezn·my ËÌseln˝ kÛd Action sa odmietne bez zmeny d·t. ENG *)
                resultCode := API_RESULT_UNSUPPORTED_ACTION;
                resultMessage := 'Nepodporovana akcia';
        END_CASE;
    END_IF;

    (* ⁄speön· d·tov· zmena vytvorÌ novÈ revÌzie a prÌsluönÈ diff r·mce. ENG *)
    IF executeChange AND (resultCode = API_RESULT_OK) THEN
        ApiCaptureConfigChanges();
        ApiCaptureStateChanges();
    END_IF;

    (* V˝sledok nesie identitu poûiadavky aj revÌzie platnÈ po jej spracovanÌ. *)
    ApiCommandResult.ClientId := ApiCommandRoom.ClientId;
    ApiCommandResult.RequestId := ApiCommandRoom.RequestId;
    ApiCommandResult.Result := resultCode;
    ApiCommandResult.Message := resultMessage;
    ApiCommandResult.ConfigRevision := ApiInfo.ConfigRevision;
    ApiCommandResult.StateRevision := ApiInfo.StateRevision;

    (* Uloûenie v˝sledku pre ApiInfo a idempotentnÈ opakovanie poslednej poûiadavky. *)
    ApiInfo.LastCommandResult := ApiCommandResult;
    ApiLastCommandClientId := ApiCommandRoom.ClientId;
    ApiLastCommandRequestId := ApiCommandRoom.RequestId;
    ApiLastStoredResult := ApiCommandResult;
END_IF;

(* UkonËenie handshake: PLC zruöÌ Execute, uvoænÌ Busy a nastavÌ Finished. ENG *)
ApiCommandExecute := FALSE;
ApiCommandBusy := FALSE;
ApiCommandFinished := TRUE;
END_FUNCTION
