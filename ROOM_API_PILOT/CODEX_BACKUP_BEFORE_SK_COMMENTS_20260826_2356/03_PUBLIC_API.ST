(*
   All client-visible objects are global and marked PUBLIC_API.
   The client must write request payload fields first and Execute last.
   Snapshot objects ApiConfig and ApiState are read-only by contract.
*)

VAR_GLOBAL
    ApiInfo       {PUBLIC_API} : T_API_INFO;
    ApiConfig     {PUBLIC_API} : T_API_CONFIG;
    ApiState      {PUBLIC_API} : T_API_STATE;

    ApiConfigDiff {PUBLIC_API} : T_API_CONFIG_DIFF;
    ApiStateDiff  {PUBLIC_API} : T_API_STATE_DIFF;

    ApiCommandRoom     {PUBLIC_API} : T_API_COMMAND_ROOM;
    ApiCommandExecute  {PUBLIC_API} : BOOL;
    ApiCommandBusy     {PUBLIC_API} : BOOL;
    ApiCommandFinished {PUBLIC_API} : BOOL;
    ApiCommandResult   {PUBLIC_API} : T_API_COMMAND_RESULT;

    ApiSyncRequest  {PUBLIC_API} : T_API_SYNC_REQUEST;
    ApiSyncExecute  {PUBLIC_API} : BOOL;
    ApiSyncBusy     {PUBLIC_API} : BOOL;
    ApiSyncFinished {PUBLIC_API} : BOOL;
    ApiSyncResponse {PUBLIC_API} : T_API_SYNC_RESPONSE;

    ApiTestStateRequest  {PUBLIC_API} : T_API_TEST_STATE_REQUEST;
    ApiTestStateExecute  {PUBLIC_API} : BOOL;
    ApiTestStateBusy     {PUBLIC_API} : BOOL;
    ApiTestStateFinished {PUBLIC_API} : BOOL;
    ApiTestStateResult   {PUBLIC_API} : T_API_COMMAND_RESULT;
END_VAR
