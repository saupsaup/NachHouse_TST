TYPE T_ROOM_CONFIG :
STRUCT
    Id              : USINT;
    Name            : STRING[32];
    ShortName       : STRING[12];
    FloorId         : USINT;
    SortOrder       : USINT;
    Icon            : STRING[24];
    Enabled         : BOOL;

    ShowTemperature : BOOL;
    ShowHumidity    : BOOL;
    ShowLights      : BOOL;
    ShowBlinds      : BOOL;
    ShowHeating     : BOOL;

    Image           : STRING[32];   // napr. livingroom.jpg
END_STRUCT
END_TYPE

TYPE T_ROOM_STATE :
STRUCT
    Temperature     : REAL;
    Humidity        : REAL;
    LightLevel      : UINT;

    LightsCount     : USINT;
    LightsOnCount   : USINT;
    LightsOn        : BOOL;

    BlindsCount     : USINT;
    BlindsMoving    : BOOL;
    BlindsPosition  : USINT;    // 0..100

    HeatingActive   : BOOL;
    CoolingActive   : BOOL;
    Setpoint        : REAL;

    AlarmActive     : BOOL;
    WarningActive   : BOOL;
    Occupied        : BOOL;

    ChangeCounter   : UDINT;
END_STRUCT
END_TYPE
(*
TYPE T_ROOM_CONFIG :
STRUCT
    Id          : USINT;
    Name        : STRING[32];
    ShortName   : STRING[12];
    FloorId     : USINT;
    SortOrder   : USINT;
    Icon        : STRING[24];
    Enabled     : BOOL;
END_STRUCT
END_TYPE

TYPE T_ROOM_STATE :
STRUCT
    Temperature     : REAL;
    Humidity        : REAL;
    LightLevel      : UINT;

    LightsCount     : USINT;
    LightsOnCount   : USINT;
    LightsOn        : BOOL;

    BlindsCount     : USINT;
    BlindsMoving    : BOOL;

    HeatingActive   : BOOL;
    CoolingActive   : BOOL;

    AlarmActive     : BOOL;
    WarningActive   : BOOL;
    Occupied        : BOOL;

    ChangeCounter   : UDINT;
END_STRUCT
END_TYPE
*)

TYPE T_API_CONFIG :
STRUCT
    Version         : UDINT;
    RoomCount       : USINT;
    Rooms           : ARRAY[1..8]   OF T_ROOM_CONFIG;
//    Lights          : ARRAY[1..300] OF T_LIGHT_CONFIG;
//    Blindss         : ARRAY[1..80]  OF T_BLIND_CONFIG;
//   ......
//   .....
END_STRUCT
END_TYPE

TYPE T_API_STATE :
STRUCT
    Version         : UDINT;
    Online          : BOOL;
    Counter         : UDINT;
    Rooms           : ARRAY[1..8] OF T_ROOM_STATE;
END_STRUCT
END_TYPE

TYPE T_API_COMMAND_REQUEST :
STRUCT
    RequestId       : UDINT;
    RoomId          : USINT;
    DeviceId        : UINT;
    Command         : USINT;

    ValueBool       : BOOL;
    ValueInt        : DINT;
    ValueReal       : REAL;

    Execute         : BOOL;
END_STRUCT
END_TYPE

TYPE T_API_COMMAND_RESULT :
STRUCT
    RequestId       : UDINT;
    ResultCode      : INT;
    Finished        : BOOL;
END_STRUCT
END_TYPE

TYPE T_API_COMMAND :
STRUCT
    Request         : T_API_COMMAND_REQUEST;
    Result          : T_API_COMMAND_RESULT;
END_STRUCT
END_TYPE
