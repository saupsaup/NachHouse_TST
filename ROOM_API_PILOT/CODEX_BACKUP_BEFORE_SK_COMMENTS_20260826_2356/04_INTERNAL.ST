(* Internal state is not exported to TecoApi / PLCComS. *)

VAR_GLOBAL
    ApiInitialized : BOOL;

    ApiConfigShadow : ARRAY[1..40] OF T_ROOM_CONFIG;
    ApiStateShadow  : ARRAY[1..40] OF T_ROOM_STATE;

    ApiConfigDiffHistory : ARRAY[1..8] OF T_API_CONFIG_DIFF;
    ApiStateDiffHistory  : ARRAY[1..8] OF T_API_STATE_DIFF;
    ApiConfigHistoryHead : USINT;
    ApiStateHistoryHead  : USINT;

    ApiLastCommandClientId  : STRING[36];
    ApiLastCommandRequestId : UDINT;
    ApiLastStoredResult     : T_API_COMMAND_RESULT;
END_VAR
