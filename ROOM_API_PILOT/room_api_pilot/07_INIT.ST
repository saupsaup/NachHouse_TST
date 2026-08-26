(* Inicializ·cia pri studenom ötarte a deterministickÈ d·ta ROOM_API_PILOT. *)

(* Jednorazovo pripravÌ vöetky verejnÈ aj internÈ objekty pilotu. *)
FUNCTION ApiPilotInit : BOOL
VAR
    i : USINT; (* Index pri inicializ·cii pevn˝ch polÌ a histÛriÌ. *)
END_VAR

(* OpakovanÈ volanie po inicializ·cii uû nijakÈ d·ta nemenÌ. *)
ApiPilotInit := ApiInitialized;
IF ApiInitialized THEN
    RETURN;
END_IF;

(* Najprv sa deterministicky vyËistia snapshoty aj ich tieÚovÈ kÛpie. *)
FOR i := 1 TO C_MAX_ROOMS DO
    ApiClearRoomConfig(ApiConfig.Rooms[i]);
    ApiClearRoomState(ApiState.Rooms[i]);
    ApiClearRoomConfig(ApiConfigShadow[i]);
    ApiClearRoomState(ApiStateShadow[i]);
END_FOR;

(* VyËistenie vöetk˝ch pozÌciÌ oboch kruhov˝ch histÛriÌ diffov. ENG *)
FOR i := 1 TO C_DIFF_HISTORY_DEPTH DO
    ApiClearConfigDiff(ApiConfigDiffHistory[i]);
    ApiClearStateDiff(ApiStateDiffHistory[i]);
END_FOR;

(* ätyri uk·ûkovÈ konfigur·cie; vöetky hodnoty s˙ iba testovacie d·ta. *)
(* Miestnosù 1: ob˝vaËka. *)
ApiConfig.Rooms[1].Used := TRUE;
ApiConfig.Rooms[1].RoomId := 1;
ApiConfig.Rooms[1].Name := 'Obyvacka';
ApiConfig.Rooms[1].ProjectName := '1.01';
ApiConfig.Rooms[1].IconId := 16;
ApiConfig.Rooms[1].SortDefault := 1;

(* Miestnosù 2: kuchyÚa. *)
ApiConfig.Rooms[2].Used := TRUE;
ApiConfig.Rooms[2].RoomId := 2;
ApiConfig.Rooms[2].Name := 'Kuchyna';
ApiConfig.Rooms[2].ProjectName := '1.07';
ApiConfig.Rooms[2].IconId := 16;
ApiConfig.Rooms[2].SortDefault := 2;

(* Miestnosù 3: sp·lÚa. *)
ApiConfig.Rooms[3].Used := TRUE;
ApiConfig.Rooms[3].RoomId := 3;
ApiConfig.Rooms[3].Name := 'Spalna';
ApiConfig.Rooms[3].ProjectName := '1.09';
ApiConfig.Rooms[3].IconId := 16;
ApiConfig.Rooms[3].SortDefault := 3;

(* Miestnosù 4: terasa. *)
ApiConfig.Rooms[4].Used := TRUE;
ApiConfig.Rooms[4].RoomId := 4;
ApiConfig.Rooms[4].Name := 'Terasa';
ApiConfig.Rooms[4].ProjectName := 'E.01';
ApiConfig.Rooms[4].IconId := 19;
ApiConfig.Rooms[4].SortDefault := 4;

(* RuËne zvolenÈ uk·ûkovÈ stavovÈ hodnoty ob˝vaËky. *)
ApiState.Rooms[1].RoomId := 1;
ApiState.Rooms[1].Temperature := 22.5;
ApiState.Rooms[1].Humidity := 45.0;
ApiState.Rooms[1].Presence := TRUE;
ApiState.Rooms[1].DayPhase := API_DAY_PHASE_DAY;
ApiState.Rooms[1].CategoryMask := DWORD#16#00000007;
ApiState.Rooms[1].AlarmLevel := API_ALARM_OK;
ApiState.Rooms[1].Online := TRUE;

(* RuËne zvolenÈ uk·ûkovÈ stavovÈ hodnoty kuchyne. *)
ApiState.Rooms[2].RoomId := 2;
ApiState.Rooms[2].Temperature := 23.0;
ApiState.Rooms[2].Humidity := 48.0;
ApiState.Rooms[2].Presence := FALSE;
ApiState.Rooms[2].DayPhase := API_DAY_PHASE_DUSK;
ApiState.Rooms[2].CategoryMask := DWORD#16#00000003;
ApiState.Rooms[2].AlarmLevel := API_ALARM_WARNING;
ApiState.Rooms[2].Online := TRUE;

(* RuËne zvolenÈ uk·ûkovÈ stavovÈ hodnoty sp·lne. *)
ApiState.Rooms[3].RoomId := 3;
ApiState.Rooms[3].Temperature := 21.8;
ApiState.Rooms[3].Humidity := 42.0;
ApiState.Rooms[3].Presence := TRUE;
ApiState.Rooms[3].DayPhase := API_DAY_PHASE_NIGHT;
ApiState.Rooms[3].CategoryMask := DWORD#16#00000001;
ApiState.Rooms[3].AlarmLevel := API_ALARM_OK;
ApiState.Rooms[3].Online := TRUE;

(* RuËne zvolenÈ uk·ûkovÈ stavovÈ hodnoty terasy. *)
ApiState.Rooms[4].RoomId := 4;
ApiState.Rooms[4].Temperature := 18.4;
ApiState.Rooms[4].Humidity := 58.0;
ApiState.Rooms[4].Presence := FALSE;
ApiState.Rooms[4].DayPhase := API_DAY_PHASE_DAWN;
ApiState.Rooms[4].CategoryMask := DWORD#16#00000004;
ApiState.Rooms[4].AlarmLevel := API_ALARM_ALARM;
ApiState.Rooms[4].Online := FALSE;

(* TieÚovÈ kÛpie sa zos˙ladia so snapshotmi, aby ötart nevytvoril faloön˝ diff. ENG *)
FOR i := 1 TO C_MAX_ROOMS DO
    ApiConfigShadow[i] := ApiConfig.Rooms[i];
    ApiStateShadow[i] := ApiState.Rooms[i];
END_FOR;

(* PoËiatoËnÈ verejnÈ inform·cie a prv˝ pr·zdny v˝sledok prÌkazu. *)
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

(* Pri prvom pripojenÌ musÌ klient naËÌtaù cel˝ konfiguraËn˝ snapshot. ENG *)
ApiClearConfigDiff(ApiConfigDiff);
ApiConfigDiff.Valid := TRUE;
ApiConfigDiff.FromRevision := 0;
ApiConfigDiff.ToRevision := 1;
ApiConfigDiff.FullRequired := TRUE;

(* Pri prvom pripojenÌ musÌ klient naËÌtaù cel˝ stavov˝ snapshot. ENG *)
ApiClearStateDiff(ApiStateDiff);
ApiStateDiff.Valid := TRUE;
ApiStateDiff.FromRevision := 0;
ApiStateDiff.ToRevision := 1;
ApiStateDiff.FullRequired := TRUE;

(* BezpeËn˝ poËiatoËn˝ stav prÌkazovÈho handshake kan·la. ENG *)
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

(* BezpeËn˝ poËiatoËn˝ stav synchronizaËnÈho a testovacieho kan·la. *)
ApiSyncExecute := FALSE;
ApiSyncBusy := FALSE;
ApiSyncFinished := FALSE;
ApiTestStateExecute := FALSE;
ApiTestStateBusy := FALSE;
ApiTestStateFinished := FALSE;

(* Vynulovanie hl·v histÛriÌ a pam‰te poslednÈho prÌkazu. *)
ApiConfigHistoryHead := 0;
ApiStateHistoryHead := 0;
ApiLastCommandClientId := '';
ApiLastCommandRequestId := 0;
ApiLastStoredResult := ApiInfo.LastCommandResult;

(* PrÌznak sa nastavÌ aû po ˙plnom dokonËenÌ celej inicializ·cie. *)
ApiInitialized := TRUE;
ApiPilotInit := TRUE;
END_FUNCTION
