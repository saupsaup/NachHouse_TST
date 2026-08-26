(* Obnova cache: vr·ti jeden ÔalöÌ uchovan˝ r·mec alebo vyûiada cel˝ snapshot. ENG *)

(* PripravÌ odpoveÔ na jednu synchronizaËn˙ poûiadavku klienta. *)
FUNCTION ApiProcessSyncRequest : BOOL
VAR
    i           : USINT; (* Index pri prehæad·vanÌ kruhov˝ch histÛriÌ diffov. *)
    foundConfig : BOOL;  (* TRUE po n·jdenÌ platnej odpovede pre konfigur·ciu. ENG *)
    foundState  : BOOL;  (* TRUE po n·jdenÌ platnej odpovede pre stav. ENG *)
END_VAR

(* Bez sp˙öùacieho prÌznaku funkcia skonËÌ bez vedæajöÌch ˙Ëinkov. *)
ApiProcessSyncRequest := FALSE;
IF NOT ApiSyncExecute THEN
    RETURN;
END_IF;

(* Prevzatie synchronizaËnej poûiadavky na spracovanie. *)
ApiProcessSyncRequest := TRUE;
ApiSyncBusy := TRUE;
ApiSyncFinished := FALSE;

(* Identita odpovede sa vûdy kopÌruje z aktu·lnej poûiadavky klienta. *)
ApiSyncResponse.ClientId := ApiSyncRequest.ClientId;
ApiSyncResponse.RequestId := ApiSyncRequest.RequestId;
ApiSyncResponse.Result := API_RESULT_OK;
ApiSyncResponse.Message := 'Synchronizacia pripravena';

(* Pred hæadanÌm sa vyËistia oba v˝stupnÈ r·mce a pomocnÈ prÌznaky. *)
ApiClearConfigDiff(ApiSyncResponse.ConfigDiff);
ApiClearStateDiff(ApiSyncResponse.StateDiff);
foundConfig := FALSE;
foundState := FALSE;

(* Neplatn· identita sa ozn·mi v Result; reûimy diffov sa napriek tomu urËia deterministicky. ENG *)
IF (ApiSyncRequest.ClientId = '') OR (ApiSyncRequest.RequestId = 0) THEN
    ApiSyncResponse.Result := API_RESULT_INVALID_ARGUMENT;
    ApiSyncResponse.Message := 'Neplatny ClientId alebo RequestId';
END_IF;

(* KonfiguraËn· vetva: CURRENT, jeden nadv‰zuj˙ci DIFF alebo FULL_REQUIRED. ENG *)
IF ApiSyncRequest.ConfigFromRevision = ApiInfo.ConfigRevision THEN
    ApiSyncResponse.ConfigMode := API_SYNC_CURRENT;
    ApiSyncResponse.ConfigDiff.Valid := TRUE;
    ApiSyncResponse.ConfigDiff.FromRevision := ApiInfo.ConfigRevision;
    ApiSyncResponse.ConfigDiff.ToRevision := ApiInfo.ConfigRevision;
    foundConfig := TRUE;
ELSE
    FOR i := 1 TO C_DIFF_HISTORY_DEPTH DO
        IF ApiConfigDiffHistory[i].Valid AND
           (ApiConfigDiffHistory[i].FromRevision =
            ApiSyncRequest.ConfigFromRevision) THEN
            ApiSyncResponse.ConfigDiff := ApiConfigDiffHistory[i];
            ApiSyncResponse.ConfigMode := API_SYNC_DIFF;
            foundConfig := TRUE;
            EXIT;
        END_IF;
    END_FOR;
END_IF;

(* Ak poûadovan· revÌzia uû nie je v histÛrii, klient musÌ naËÌtaù cel˝ snapshot. *)
IF NOT foundConfig THEN
    ApiSyncResponse.ConfigMode := API_SYNC_FULL_REQUIRED;
    ApiSyncResponse.ConfigDiff.Valid := TRUE;
    ApiSyncResponse.ConfigDiff.FromRevision := ApiSyncRequest.ConfigFromRevision;
    ApiSyncResponse.ConfigDiff.ToRevision := ApiInfo.ConfigRevision;
    ApiSyncResponse.ConfigDiff.FullRequired := TRUE;
END_IF;

(* Stavov· vetva: CURRENT, jeden nadv‰zuj˙ci DIFF alebo FULL_REQUIRED. ENG *)
IF ApiSyncRequest.StateFromRevision = ApiInfo.StateRevision THEN
    ApiSyncResponse.StateMode := API_SYNC_CURRENT;
    ApiSyncResponse.StateDiff.Valid := TRUE;
    ApiSyncResponse.StateDiff.FromRevision := ApiInfo.StateRevision;
    ApiSyncResponse.StateDiff.ToRevision := ApiInfo.StateRevision;
    foundState := TRUE;
ELSE
    FOR i := 1 TO C_DIFF_HISTORY_DEPTH DO
        IF ApiStateDiffHistory[i].Valid AND
           (ApiStateDiffHistory[i].FromRevision =
            ApiSyncRequest.StateFromRevision) THEN
            ApiSyncResponse.StateDiff := ApiStateDiffHistory[i];
            ApiSyncResponse.StateMode := API_SYNC_DIFF;
            foundState := TRUE;
            EXIT;
        END_IF;
    END_FOR;
END_IF;

(* Ak poûadovan· stavov· revÌzia nie je v histÛrii, klient naËÌta cel˝ snapshot. *)
IF NOT foundState THEN
    ApiSyncResponse.StateMode := API_SYNC_FULL_REQUIRED;
    ApiSyncResponse.StateDiff.Valid := TRUE;
    ApiSyncResponse.StateDiff.FromRevision := ApiSyncRequest.StateFromRevision;
    ApiSyncResponse.StateDiff.ToRevision := ApiInfo.StateRevision;
    ApiSyncResponse.StateDiff.FullRequired := TRUE;
END_IF;

(* UkonËenie synchronizaËnÈho handshake kan·la. ENG *)
ApiSyncExecute := FALSE;
ApiSyncBusy := FALSE;
ApiSyncFinished := TRUE;
END_FUNCTION
