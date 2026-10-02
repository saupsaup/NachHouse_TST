VAR_GLOBAL
    ApiConfig {PUBLIC_API}  : T_API_CONFIG;
    ApiState   {PUBLIC_API} : T_API_STATE;
    ApiCommand  {PUBLIC_API} : T_API_COMMAND;
END_VAR

// new test var
VAR_GLOBAL
    TestWrite     {PUBLIC_API} : BOOL ;
//    MyTestApiVar1 {PUBLIC_API} : ARRAY[0..4] of STRING[255] ;
END_VAR
