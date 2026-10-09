// One-shot transport measurement. The records are synthetic because the production mRam is not populated yet.
// Files intentionally remain in //RAM/NACHHOUSE/ for manual inspection after the test.

TYPE
  NH_REC_ALL {PUBLIC}  {HIDDEN}: STRUCT 	// uvodny zaznam pre vsetky DEV alebo struktury, ktore su tabulkou
 	  Ok              : BOOL := TRUE; // platna veta = NOT DELTED
    ID              : INT;					// identifikator zaznamu {Rec Number}
  END_STRUCT;

  NH_CFG_ALL	{PUBLIC}  {HIDDEN}: STRUCT 	// univerzalne CFG pre vsetky DEV
    RoomID          : INT;			    // do ktorej miestnosti patri toto DEV
    CategoryID      : INT;					// domovska kategoria Device
  END_STRUCT;

  NH_JSON_TEST_ROOM  {PUBLIC} : STRUCT    // povodna testovacia struktura
    // povodna testovacia struktura
    RoomId          : UDINT;
    LightLevel      : UINT;
    Temperature10   : INT;
    Online          : BOOL;
   END_STRUCT

  NH_JSON_MEM  {PUBLIC} : STRUCT    // toto zoberiema ako STATE  a bude cele v mRam ako struktura, ktora sa bude posielat do JSON-stat
    rec             : NH_REC_ALL;   // hlavicka - ked sa bude posielat do JSON len stat = mRam
    all             : NH_CFG_ALL;   // premenn, ktore sa pouzivaju casto pri behu programu, ale nemenia sa
    sta             : NH_JSON_TEST_ROOM;   // hlavnme stavove premenne 
   END_STRUCT

  NH_JSON_TEST_ROOM_CFG {PUBLIC} : STRUCT   // konfiguracia ulozena
    rec             : NH_REC_ALL;   // duplicitna hlavicka - ked sa bude posielat do JSON len config
    Name            : STRING[32];  // nazov miestnosti
    // iba pre testivanie  STRUCT <-> JSON (ostatnych elementarnych typov, ktore mozu byt STRUCT -> JSON)
    _Dint           : DINT;				
    _Sint           : SINT;				
    _Usint          : USINT;				
    _Uint           : USINT;				
    _Real           : REAL;
    _LReal          : LREAL;
    _String         : STRING[30];   // prazdny string
    _StringCZSK     : STRING := 'SVKBEGIN_öËæùû˝·ÌÈ_SVKEND';   // string obsahujuci ceske a slovenske znaky
    _BYTE           : BYTE;
    _WORD           : WORD;
    _TIME           : TIME;
    _DATE           : DATE;
    _TIME_OF_DAY    : TOD;
    _DATE_AND_TIME  : DT;
   END_STRUCT


  NH_LIGT {PUBLIC}  : STRUCT    // toto je kompletna premenn v nasom pripade JSON, inak NH_ROOM, NH_BLIND,NH_HEAT ...
    mem             : NH_JSON_MEM;             // co budes v mRam ako STATE (memory) - RAM je pouzita na disku '/RAM/'
    cfg             : NH_JSON_TEST_ROOM_CFG;   // toto bude len na SDC 
   END_STRUCT



(*
   NH_JSON_TEST_ROOM : STRUCT
      RoomId          : UDINT;
      LightLevel      : UINT;
      Temperature10   : INT;
      Online          : BOOL;
   END_STRUCT
*)
END_TYPE

VAR_GLOBAL CONSTANT
  NH_JSON_TEST_RECORDS : UINT := 300;
  // Historical prototype declaration; unused and not valid in VAR_GLOBAL CONSTANT.
  // aNhJSON {PUBLIC} {TRACK_ADR} {OPEN_UP} : NH_LIGHT;
END_VAR

VAR_GLOBAL
   NhJsonTestRooms        : ARRAY[1..300] OF NH_JSON_TEST_ROOM;
   NhJsonTestInitialized  : BOOL := FALSE;
   NhJsonTestState        : USINT := 0;
   NhJsonTestMode         : USINT := 0;
   NhJsonTestIndex        : UINT := 0;
   NhJsonTestHandle       : HANDLE := INVALID_HANDLE_VALUE;
   NhJsonTestWritten      : UDINT := 0;
   NhJsonTestBuildCycles  : UINT := 0;
   NhJsonTestFileName     : STRING[80];
END_VAR

FUNCTION NhJsonTestWrite : BOOL
   VAR_INPUT
      Text : STRING[255];
   END_VAR
   VAR
      Count : UDINT;
   END_VAR
   NhJsonTestWrite := FALSE;
   Count := FileWrite(hFile := NhJsonTestHandle, adrBuf := PTR_TO_UDINT(ADR(Text)), size := UINT_TO_UDINT(LEN(Text)));
   IF Count <> UINT_TO_UDINT(LEN(Text)) THEN RETURN; END_IF;
   NhJsonTestWritten := NhJsonTestWritten + Count;
   NhJsonTestWrite := TRUE;
END_FUNCTION

FUNCTION NhJsonTestWriteRecord : BOOL
   VAR_INPUT
      Index  : UINT;
      Prefix : BOOL;
   END_VAR
   VAR
      Record : PTR_TO NH_JSON_TEST_ROOM;
      Line   : STRING[255];
      Online : STRING[5];
   END_VAR
   NhJsonTestWriteRecord := FALSE;
   Record := ADR(NhJsonTestRooms[Index]);
   IF Record^.Online THEN Online := 'true'; ELSE Online := 'false'; END_IF;
   IF Prefix THEN Line := ','; ELSE Line := ''; END_IF;
   Line := CONCAT(Line, '{"id":', UDINT_TO_STRING(Record^.RoomId), ',"level":', UINT_TO_STRING(Record^.LightLevel), ',"temperature10":', INT_TO_STRING(Record^.Temperature10), ',"online":', Online, '}');
   NhJsonTestWriteRecord := NhJsonTestWrite(Text := Line);
END_FUNCTION

FUNCTION NhJsonTestInitialize : BOOL
   VAR
      Index : UINT;
   END_VAR
   NhJsonTestInitialize := NhJsonTestInitialized;
   IF NhJsonTestInitialized THEN RETURN; END_IF;
   FOR Index := 1 TO NH_JSON_TEST_RECORDS DO
      NhJsonTestRooms[Index].RoomId := UINT_TO_UDINT(Index);
      NhJsonTestRooms[Index].LightLevel := (Index * 7) MOD 101;
      NhJsonTestRooms[Index].Temperature10 := 185 + UINT_TO_INT(Index MOD 65);
      NhJsonTestRooms[Index].Online := (Index MOD 11) <> 0;
   END_FOR;
   NhJsonTestInitialized := TRUE;
   NhJsonTestInitialize := TRUE;
END_FUNCTION

FUNCTION NhJsonTestCycle : BOOL
   VAR
      Index : UINT;
      Header : STRING[255];
      Trailer : STRING[255];
      ModeText : STRING[6];
      Closed : BOOL;
   END_VAR
   NhJsonTestCycle := FALSE;
   NhJsonTestInitialize();
   IF System_S.LAST_CYCLE_TIME_100US > NhJsonTestMaxCycle100us THEN NhJsonTestMaxCycle100us := System_S.LAST_CYCLE_TIME_100US; END_IF;
   CASE NhJsonTestState OF
      0:
         IF (NhJsonTestCommand = 1) OR (NhJsonTestCommand = 2) THEN
            NhJsonTestMode := NhJsonTestCommand; NhJsonTestCommand := 0; NhJsonTestStatus := NhJsonTestMode;
            NhJsonTestBytes := 0; NhJsonTestRecords := 0; NhJsonTestMaxCycle100us := 0; NhJsonTestWritten := 0; NhJsonTestBuildCycles := 0; NhJsonTestState := 1;
         END_IF;
      1:
         IF NhJsonTestMode = 1 THEN NhJsonTestFileName := '//RAM/NACHHOUSE/nh-json-test-stream.json'; ELSE NhJsonTestFileName := '//RAM/NACHHOUSE/nh-json-test-burst.json'; END_IF;
         NhJsonTestHandle := FileOpen(fileName := NhJsonTestFileName, mode := F_WRITE);
         IF NhJsonTestHandle = INVALID_HANDLE_VALUE THEN NhJsonTestStatus := 255; NhJsonTestState := 0; RETURN; END_IF;
         IF NhJsonTestMode = 1 THEN
            ModeText := 'stream';
         ELSE
            ModeText := 'burst';
         END_IF;
         Header := CONCAT('{"protocol":1,"kind":"patch","sequence":', UDINT_TO_STRING(NhTxRevision + 1), ',"baseSequence":', UDINT_TO_STRING(NhTxRevision), ',"mode":"', ModeText, '","groups":[{"type":"ROOMS","schema":"NH_JSON_TEST_ROOM","records":[');
         IF NOT NhJsonTestWrite(Text := Header) THEN NhJsonTestStatus := 255; NhJsonTestState := 4; RETURN; END_IF;
         NhJsonTestIndex := 1; NhJsonTestState := 2;
      2:
         IF NhJsonTestMode = 1 THEN
            IF NOT NhJsonTestWriteRecord(Index := NhJsonTestIndex, Prefix := NhJsonTestIndex > 1) THEN NhJsonTestStatus := 255; NhJsonTestState := 4; RETURN; END_IF;
            NhJsonTestIndex := NhJsonTestIndex + 1; NhJsonTestBuildCycles := NhJsonTestBuildCycles + 1;
         ELSE
            FOR Index := 1 TO NH_JSON_TEST_RECORDS DO
               IF NOT NhJsonTestWriteRecord(Index := Index, Prefix := Index > 1) THEN NhJsonTestStatus := 255; NhJsonTestState := 4; RETURN; END_IF;
            END_FOR;
            NhJsonTestIndex := NH_JSON_TEST_RECORDS + 1; NhJsonTestBuildCycles := 1;
         END_IF;
         IF NhJsonTestIndex > NH_JSON_TEST_RECORDS THEN NhJsonTestState := 3; END_IF;
      3:
         Trailer := CONCAT(']}],"metrics":{"records":', UINT_TO_STRING(NH_JSON_TEST_RECORDS), ',"buildCycles":', UINT_TO_STRING(NhJsonTestBuildCycles), '}}');
         IF NOT NhJsonTestWrite(Text := Trailer) THEN NhJsonTestStatus := 255; NhJsonTestState := 4; RETURN; END_IF;
         Closed := FileClose(hFile := NhJsonTestHandle); NhJsonTestHandle := INVALID_HANDLE_VALUE;
         IF NOT Closed THEN NhJsonTestStatus := 255; NhJsonTestState := 0; RETURN; END_IF;
         NhJsonTestBytes := NhJsonTestWritten; NhJsonTestRecords := NH_JSON_TEST_RECORDS; NhTxRevision := NhTxRevision + 1; NhJsonTestStatus := 3; NhJsonTestState := 0;
      4:
         IF NhJsonTestHandle <> INVALID_HANDLE_VALUE THEN FileClose(hFile := NhJsonTestHandle); NhJsonTestHandle := INVALID_HANDLE_VALUE; END_IF;
         NhJsonTestState := 0;
   END_CASE;
   NhJsonTestCycle := TRUE;
END_FUNCTION
