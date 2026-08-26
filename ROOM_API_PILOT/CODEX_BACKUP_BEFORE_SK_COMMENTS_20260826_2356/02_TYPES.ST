(* ROOM_API_PILOT - logical API and transport types. *)

TYPE T_API_COMMAND_RESULT :
STRUCT
    ClientId       : STRING[36];
    RequestId      : UDINT;
    Result         : USINT;
    Message        : STRING[80];
    ConfigRevision : UDINT;
    StateRevision  : UDINT;
END_STRUCT
END_TYPE

TYPE T_API_INFO :
STRUCT
    ApiVersion        : STRING[32];
    ConfigRevision    : UDINT;
    StateRevision     : UDINT;
    MaxRooms          : USINT;
    LastCommandResult : T_API_COMMAND_RESULT;
END_STRUCT
END_TYPE

TYPE T_ROOM_CONFIG :
STRUCT
    Used        : BOOL;
    RoomId      : UDINT;
    Name        : STRING[64];
    ProjectName : STRING[64];
    IconId      : UINT;
    SortDefault : UINT;
END_STRUCT
END_TYPE

TYPE T_API_CONFIG :
STRUCT
    Rooms : ARRAY[1..40] OF T_ROOM_CONFIG;
END_STRUCT
END_TYPE

TYPE T_ROOM_STATE :
STRUCT
    RoomId       : UDINT;
    Temperature  : REAL;
    Humidity     : REAL;
    Presence     : BOOL;
    DayPhase     : UINT;
    CategoryMask : DWORD;
    AlarmLevel   : USINT;
    Online       : BOOL;
END_STRUCT
END_TYPE

TYPE T_API_STATE :
STRUCT
    Rooms : ARRAY[1..40] OF T_ROOM_STATE;
END_STRUCT
END_TYPE

TYPE T_API_COMMAND_ROOM :
STRUCT
    ClientId     : STRING[36];
    RequestId    : UDINT;
    Action       : USINT;
    RoomId       : UDINT;
    SourceRoomId : UDINT;
    Name         : STRING[64];
    ProjectName  : STRING[64];
END_STRUCT
END_TYPE

TYPE T_API_CONFIG_CHANGE :
STRUCT
    Valid     : BOOL;
    Operation : USINT;
    RoomId    : UDINT;
    Room      : T_ROOM_CONFIG;
END_STRUCT
END_TYPE

TYPE T_API_STATE_CHANGE :
STRUCT
    Valid     : BOOL;
    Operation : USINT;
    RoomId    : UDINT;
    Room      : T_ROOM_STATE;
END_STRUCT
END_TYPE

TYPE T_API_CONFIG_DIFF :
STRUCT
    Valid        : BOOL;
    FromRevision : UDINT;
    ToRevision   : UDINT;
    FullRequired : BOOL;
    ChangeCount  : USINT;
    Changes      : ARRAY[1..40] OF T_API_CONFIG_CHANGE;
END_STRUCT
END_TYPE

TYPE T_API_STATE_DIFF :
STRUCT
    Valid        : BOOL;
    FromRevision : UDINT;
    ToRevision   : UDINT;
    FullRequired : BOOL;
    ChangeCount  : USINT;
    Changes      : ARRAY[1..40] OF T_API_STATE_CHANGE;
END_STRUCT
END_TYPE

(* Transport handshake used to retrieve one retained diff frame. *)
TYPE T_API_SYNC_REQUEST :
STRUCT
    ClientId           : STRING[36];
    RequestId          : UDINT;
    ConfigFromRevision : UDINT;
    StateFromRevision  : UDINT;
END_STRUCT
END_TYPE

TYPE T_API_SYNC_RESPONSE :
STRUCT
    ClientId   : STRING[36];
    RequestId  : UDINT;
    Result     : USINT;
    Message    : STRING[80];
    ConfigMode : USINT;
    StateMode  : USINT;
    ConfigDiff : T_API_CONFIG_DIFF;
    StateDiff  : T_API_STATE_DIFF;
END_STRUCT
END_TYPE

(* Manual test input. It is deliberately separate from ApiCommand.Room. *)
TYPE T_API_TEST_STATE_REQUEST :
STRUCT
    ClientId     : STRING[36];
    RequestId    : UDINT;
    RoomId       : UDINT;
    Temperature  : REAL;
    Humidity     : REAL;
    Presence     : BOOL;
    DayPhase     : UINT;
    CategoryMask : DWORD;
    AlarmLevel   : USINT;
    Online       : BOOL;
END_STRUCT
END_TYPE
