VAR_GLOBAL CONSTANT
  _NH_ZONES {HIDDEN} : USINT := 5;      // Pocet pamätových zón PLC, ktoré model používa. ; Number of PLC memory zones used by this model.
  _NH_RAM {HIDDEN}   : UDINT := 15000; // Velkost pola mRam v bajtoch. ; Size of the mRam byte array.
  _NH_CFG {HIDDEN}   : INT := 2;        // Pocet typov evidovaných v aCfg. ; Number of data types registered in aCfg.
END_VAR

// Nasledujú interné typy, dátové záznamy a dve publikované aplikacné štruktúry. ; The following are internal types, data records, and two published application structures.
TYPE
  // Príznaky štartu a inicializácie programu. ; Program startup and initialization flags.
  NH_SYS {HIDDEN}: STRUCT
    Ini     : INT := 250;    // Hodnota 250 povoluje jednorazové naplnenie testovacích dát. ; Value 250 enables the one-time test-data initialization.
    Restart : BOOL := TRUE;  // Oznacuje, že PLC práve štartuje. ; Indicates that the PLC is starting.
  END_STRUCT;
  // Príklad spolocných identifikacných polí v oboch typoch. ; Example of shared identification fields in both data types.
  NH_CFG_ALL {HIDDEN}: STRUCT
    RoomID     : INT;       // Ukážkové ID miestnosti v spolocnej casti. ; Sample room ID in the shared section.
    CategoryID : INT;       // Ukážkové ID kategórie v spolocnej casti. ; Sample category ID in the shared section.
  END_STRUCT;
  // Metadáta typu: kód, velkost, pocet záznamov a umiestnenie v mRam. ; Metadata for one type: code, size, record count, and location in mRam.
  NH_CFG: STRUCT
    cfg     : STRING[4];                    // Kód typu, velkost záznamu, adresa, offset v mRam a pocet záznamov. ; Type code, record size, address, mRam offset, and record count.
    Siz     : UDINT;
    Ram     : UDINT;
    iRam    : UDINT;
    Rec     : UDINT;
    par     : USINT;                        // Pomocné klasifikacné a referencné metadáta typu. ; Auxiliary type classification and reference metadata.
    cat     : USINT;
    ref     : USINT := 251;
    ver     : USINT;
    tGrp    : USINT;                        // Klasifikacné údaje a velkosti konfiguracnej a spolocnej casti. ; Classification values and configuration/shared-section sizes.
    al      : USINT;
    cx      : UDINT;
    cf      : USINT := SIZEOF(NH_CFG_ALL);
    me      : UDINT;                        // Velkost stavovej casti, údaje HW/I/O a príznaky platnosti. ; State-section size, hardware/I/O data, and validity flags.
    hw      : USINT;
    io      : UDINT;
    Enabled : BOOL;
    ok      : BOOL;
  END_STRUCT;
  // Spolocné položky hlavicky každého záznamu. ; Shared header fields for every record.

  NH_BTN3     {HIDDEN}    : ARRAY[1.. 3] OF BOOL;
  NH_LVL3     {HIDDEN}    : ARRAY[1.. 3] OF USINT;

  NH_REC_ALL {HIDDEN}: STRUCT
    Ok      : BOOL;          // Príznak platnosti záznamu. ; Record-validity flag.
    ref     : BOOL;        
    waiting : BOOL;          // Príznak, že záznam caká na aktualizáciu. ; Record-waiting-for-update flag.
    ID      : INT;           // Identifikátor záznamu. ; Record identifier.
  END_STRUCT;
  // Premenné živého stavu miestnosti uložené v casti mem. ; Live room-state fields stored in the mem section.
  NH_ROOM_MEM: STRUCT
    rec          : NH_REC_ALL;  // Hlavicka záznamu a spolocné identifikacné údaje. ; Record header and shared identification data.
    all          : NH_CFG_ALL;
    Temperature  : REAL;        // Testovacie merania a príznaky stavu miestnosti. ; Test measurements and room-state flags.
    Humidity     : REAL;
    Presence     : BOOL;
    DayPhase     : UINT;
    CategoryMask : DWORD;       // Maska kategórií, úroven alarmu a dalšie príznaky stavu. ; Category mask, alarm level, and additional Boolean state flags.
    AlarmLevel   : USINT;
    Online       : BOOL;
    Twilight     : BOOL;
    grp          : ARRAY[0..7] OF BOOL;
    scan         : NH_BTN3;
    lvl          : NH_LVL3;
  END_STRUCT;
  // Konfiguracná cast miestnosti; testovacie polia pokrývajú rôzne typy IEC. ; Room configuration; test fields cover different IEC data types.
  NH_ROOM_CFG: STRUCT
    Name           : STRING[32];                              // Názov a testovacie celé císla so znamienkom aj bez neho. ; Name and signed/unsigned integer test values.
    _Dint          : DINT;
    _Sint          : SINT;
    _Usint         : USINT;
    _Uint          : UINT;                                    // 16-bitové a desatinné testovacie císla a krátky retazec. ; 16-bit and floating-point test values plus a short string.
    _Real          : REAL;
    _LReal         : LREAL;
    _String        : STRING[30];
    _StringCZSK    : STRING := 'SVKBegin_šctžýáíé_SVKEnd';  // Retazec s diakritikou overuje prevod medzi CP1250 a UTF-8. ; A diacritic-bearing string tests conversion between CP1250 and UTF-8.
    _BYTE          : BYTE;                                    // Bajtové a dátumové/casové testovacie typy. ; Byte-sized and date/time test types.
    _WORD          : WORD;
    _TIME          : TIME;
    _DATE          : DATE;
    _TIME_OF_DAY   : TOD;                                     // Testovacie hodnoty casu dna a dátumového casu. ; Test values for time-of-day and date-time types.
    _DATE_AND_TIME : DT;
  END_STRUCT;
  // Jeden verejný záznam miestnosti spája živý stav a konfiguráciu. ; One public room record combines live state and configuration.
  NH_ROOM : STRUCT
    mem : NH_ROOM_MEM;  // Vnorená štruktúra prevádzkového stavu miestnosti. ; Nested room operating-state structure.
    cfg : NH_ROOM_CFG;  // Vnorená štruktúra konfigurácie miestnosti. ; Nested room-configuration structure.
  END_STRUCT;
  // Živý stav používatela oddelený od jeho konfigurácie. ; Live user state separated from user configuration.
  NH_USERS_MEM: STRUCT
    rec        : NH_REC_ALL;  // Hlavicka, spolocné identifikátory a stav pripojenia. ; Header, shared identifiers, and connection state.
    all        : NH_CFG_ALL;
    Connected  : BOOL;
    LastError  : STRING[80];  // Posledná chyba a casová znacka poslednej aktualizácie. ; Last error and timestamp of the latest update.
    LastUpdate : UDINT;
  END_STRUCT;
  // Konfigurácia používatela vrátane práv, zón, IP adries a dalších polí. ; User configuration including rights, zones, IP addresses, and other fields.
  NH_USERS_CFG: STRUCT
    Name       : STRING[32];                                                                                                              // Meno používatela a predvolby úvodnej obrazovky. ; User name and home-screen preferences.
    LoginHome  : BOOL := TRUE;
    DshSet     : BOOL := FALSE;
    OwnDSH     : BOOL := TRUE;                                                                                                            // Príznaky vlastných obrazoviek a úroven prístupových práv. ; Custom-screen flags and access-right level.
    OwnQCK     : BOOL := TRUE;
    UsrRight   : USINT := 1;
    ZonList    : ARRAY[1..16] OF BOOL := [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];                                                // Príznaky prístupu používatela k šestnástim zónam. ; User access flags for sixteen zones.
    sbj        : USINT := 1;                                                                                                              // Predmet, jazyk a osem oblúbených položiek. ; Subject, language, and eight favorites.
    lng        : USINT;
    fav        : ARRAY[0..7] OF USINT;
    keyPas     : STRING[6];                                                                                                               // Testovací klúc, pocet IP adries a tri adresy. ; Test key, IP-address count, and three addresses.
    IPnbr      : USINT := 1;
    IP         : ARRAY[1..3] OF STRING[15];
    mail       : STRING[50];                                                                                                              // Kontaktný e-mail a testovacie autorizacné tokeny. ; Contact email and test authorization tokens.
    TOKENAPPLE : STRING[90];
    TOKENUNI   : STRING[100];
    gsm        : STRING[15];                                                                                                              // Telefón, vzhlad a osem príznakov správ. ; Phone, appearance, and eight message flags.
    skin       : USINT;
    msg        : ARRAY[0..7] OF BOOL;
    Brw        : ARRAY[0..30] OF USINT := [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];  // Tridsatjeden testovacích hodnôt nastavení prehliadaca. ; Thirty-one test values for browser-related settings.
  END_STRUCT;
  // Jeden verejný záznam používatela spája stav a konfiguráciu. ; One public user record combines state and configuration.
  NH_USER {PUBLIC}: STRUCT
    mem : NH_USERS_MEM;
    cfg : NH_USERS_CFG;
  END_STRUCT;
END_TYPE


VAR_GLOBAL
  mRam: ARRAY[0.._NH_RAM] OF BYTE;
  aSys: NH_SYS;
  aCfg: ARRAY[1.._NH_CFG] OF NH_CFG := [
    (cfg := 'ROOM', Enabled := TRUE, ver := 1, Siz := SIZEOF(NH_ROOM),
     Rec := 10, cx := SIZEOF(NH_ROOM.cfg), me := SIZEOF(NH_ROOM.mem)),
    (cfg := 'USER', Enabled := TRUE, ver := 1, Siz := SIZEOF(NH_USER),
     Rec := 10, cx := SIZEOF(NH_USER.cfg), me := SIZEOF(NH_USER.mem),
     cat := 31, ref := 254)
  ];
  mApi          : ARRAY[0..2048] OF BYTE;
  ROOM {PUBLIC} AT mApi : NH_ROOM;

  xRoom: PTR_TO NH_ROOM;
  xUser: PTR_TO NH_USER;

  yRoom:  ARRAY[1..3] OF NH_ROOM;
  yRoom2: ARRAY[1..3] OF NH_ROOM;

  //USER {PUBLIC} AT mApi : NH_USER;


  // Iba zdroj testovacích dát a exportu typov. Po štarte sa už nepoužívajú. ; Test data and type-export source only. Not used after startup.
//  yRooms: ARRAY[1..10] OF NH_ROOM;
//  yUsers: ARRAY[1..10] OF NH_USER;

  DepRq {PUBLIC_API}: BOOL := FALSE;
  DepRes {PUBLIC_API}: USINT := 0;
  BuildNo {PUBLIC_API}: UDINT := 2026100911;

END_VAR
