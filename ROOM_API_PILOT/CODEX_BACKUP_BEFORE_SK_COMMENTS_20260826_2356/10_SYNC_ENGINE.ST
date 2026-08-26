(* Cache recovery: return one next retained frame or request a full snapshot. *)

FUNCTION ApiProcessSyncRequest : BOOL
VAR
    i           : USINT;
    foundConfig : BOOL;
    foundState  : BOOL;
END_VAR

ApiProcessSyncRequest := FALSE;
IF NOT ApiSyncExecute THEN
    RETURN;
END_IF;

ApiProcessSyncRequest := TRUE;
ApiSyncBusy := TRUE;
ApiSyncFinished := FALSE;

ApiSyncResponse.ClientId := ApiSyncRequest.ClientId;
ApiSyncResponse.RequestId := ApiSyncRequest.RequestId;
ApiSyncResponse.Result := API_RESULT_OK;
ApiSyncResponse.Message := 'Synchronizacia pripravena';

ApiClearConfigDiff(ApiSyncResponse.ConfigDiff);
ApiClearStateDiff(ApiSyncResponse.StateDiff);
foundConfig := FALSE;
foundState := FALSE;

IF (ApiSyncRequest.ClientId = '') OR (ApiSyncRequest.RequestId = 0) THEN
    ApiSyncResponse.Result := API_RESULT_INVALID_ARGUMENT;
    ApiSyncResponse.Message := 'Neplatny ClientId alebo RequestId';
END_IF;

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

IF NOT foundConfig THEN
    ApiSyncResponse.ConfigMode := API_SYNC_FULL_REQUIRED;
    ApiSyncResponse.ConfigDiff.Valid := TRUE;
    ApiSyncResponse.ConfigDiff.FromRevision := ApiSyncRequest.ConfigFromRevision;
    ApiSyncResponse.ConfigDiff.ToRevision := ApiInfo.ConfigRevision;
    ApiSyncResponse.ConfigDiff.FullRequired := TRUE;
END_IF;

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

IF NOT foundState THEN
    ApiSyncResponse.StateMode := API_SYNC_FULL_REQUIRED;
    ApiSyncResponse.StateDiff.Valid := TRUE;
    ApiSyncResponse.StateDiff.FromRevision := ApiSyncRequest.StateFromRevision;
    ApiSyncResponse.StateDiff.ToRevision := ApiInfo.StateRevision;
    ApiSyncResponse.StateDiff.FullRequired := TRUE;
END_IF;

ApiSyncExecute := FALSE;
ApiSyncBusy := FALSE;
ApiSyncFinished := TRUE;
END_FUNCTION
