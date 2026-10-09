// Konštanty urèujú rozmery virtuálnej pamäte a poèet typov ; Constants define virtual-memory dimensions and the number of data types.
VAR_GLOBAL CONSTANT
  _NH_ZONES {HIDDEN} : USINT := 5;      // Poèet podporovanıch pamäovıch zón PLC ; Number of PLC memory zones used by this model.
  _NH_RAM {HIDDEN}   : UDINT := 10000;  // Ve¾kos po¾a mRam v bajtoch ; Size of the mRam byte array.
  _NH_CFG {HIDDEN}   : INT := 2;        // Poèet typov registrovanıch v aCfg ; Number of data types registered in aCfg.
END_VAR

// Nasledujú interné typy, dátové záznamy a dve publikované aplikaèné štruktúry ; The following are internal types, data records, and two published application structures.
TYPE
  // Príznaky štartu a inicializácie programu ; Program startup and initialization flags.
  NH_SYS {HIDDEN}: STRUCT
    Ini     : INT := 250;    // Hodnota 250 povo¾uje jednorazové naplnenie testovacích dát ; Value 250 enables the one-time test-data initialization.
    Restart : BOOL := TRUE;  // Oznaèuje, e PLC práve štartuje ; Indicates that the PLC is starting.
  END_STRUCT;
  // Príklad spoloènıch identifikaènıch polí v oboch typoch ; Example of shared identification fields in both data types.
  NH_CFG_ALL {HIDDEN}: STRUCT
    RoomID     : INT := 12;  // Ukákové ID miestnosti v spoloènej èasti ; Sample room ID in the shared section.
    CategoryID : INT := 23;  // Ukákové ID kategórie v spoloènej èasti ; Sample category ID in the shared section.
  END_STRUCT;
  // Metaúdaje jedného typu: kód, ve¾kos, poèet viet a umiestnenie v mRam ; Metadata for one type: code, size, record count, and location in mRam.
  NH_CFG: STRUCT
    cfg     : STRING[4];                    // Kód typu, ve¾kos vety, adresa, offset v mRam a poèet viet ; Type code, record size, address, mRam offset, and record count.
    Siz     : UDINT;
    Ram     : UDINT;
    iRam    : UDINT;
    Rec     : UDINT;
    par     : USINT;                        // Pomocné klasifikaèné a referenèné metadáta typu ; Auxiliary type classification and reference metadata.
    cat     : USINT;
    ref     : USINT := 251;
    ver     : USINT;
    tGrp    : USINT;                        // Klasifikaèné údaje a ve¾kosti konfiguraènej/spoloènej èasti ; Classification values and configuration/shared-section sizes.
    al      : USINT;
    cx      : UDINT;
    cf      : USINT := SIZEOF(NH_CFG_ALL);
    me      : UDINT;                        // Ve¾kos stavovej èasti, HW/I/O údaje a príznaky pouite¾nosti ; State-section size, hardware/I/O data, and validity flags.
    hw      : USINT;
    io      : UDINT;
    Enabled : BOOL;
    ok      : BOOL;
  END_STRUCT;
  // Spoloèné polia hlavièky kadého záznamu ; Shared header fields for every record.
  NH_REC_ALL {HIDDEN}: STRUCT
    Ok : BOOL := TRUE;  // Príznak platnosti záznamu ; Record-validity flag.
    ID : INT;           // Identifikátor záznamu ; Record identifier.
  END_STRUCT;
  // Premenné ivého stavu miestnosti uloené v èasti mem ; Live room-state fields stored in the mem section.
  NH_ROOM_MEM: STRUCT
    rec          : NH_REC_ALL;  // Hlavièka vety a spoloèné identifikaèné údaje ; Record header and shared identification data.
    all          : NH_CFG_ALL;
    Temperature  : REAL;        // Testovacie merania a stavové príznaky miestnosti ; Test measurements and room-state flags.
    Humidity     : REAL;
    Presence     : BOOL;
    DayPhase     : UINT;
    CategoryMask : DWORD;       // Maska kategórií, alarm a ïalšie binárne príznaky stavu ; Category mask, alarm level, and additional Boolean state flags.
    AlarmLevel   : USINT;
    Online       : BOOL;
    Twilight     : BOOL;
  END_STRUCT;
  // Konfiguraèná èas miestnosti ; testovacie polia pokrıvajú rôzne IEC typy ; Room configuration ; test fields cover different IEC data types.
  NH_ROOM_CFG: STRUCT
    Name           : STRING[32];                              // Názov a testovacie celé èísla so znamienkom aj bez neho ; Name and signed/unsigned integer test values.
    _Dint          : DINT;
    _Sint          : SINT;
    _Usint         : USINT;
    _Uint          : UINT;                                    // Testovacie 16-bitové a plávajúce èísla a krátky reazec ; 16-bit and floating-point test values plus a short string.
    _Real          : REAL;
    _LReal         : LREAL;
    _String        : STRING[30];
    _StringCZSK    : STRING := 'SVKBEGIN_+¾šèıáíé_SVKEND';  // Reazec s diakritikou overuje prevod CP1250 na UTF-8 a spä ; A diacritic-bearing string tests conversion between CP1250 and UTF-8.
    _BYTE          : BYTE;                                    // Testovacie bajtové a èasové typy ; Byte-sized and date/time test types.
    _WORD          : WORD;
    _TIME          : TIME;
    _DATE          : DATE;
    _TIME_OF_DAY   : TOD;                                     // Testovacie typy èasu dòa a dátumu s èasom ; Test values for time-of-day and date-time types.
    _DATE_AND_TIME : DT;
  END_STRUCT;
  // Celá verejná veta miestnosti spája ivı stav a konfiguráciu ; One public room record combines live state and configuration.
  NH_ROOM {PUBLIC}: STRUCT
    mem : NH_ROOM_MEM;  // Podštruktúra prevádzkového stavu miestnosti ; Nested room operating-state structure.
    cfg : NH_ROOM_CFG;  // Podštruktúra konfiguraènıch hodnôt miestnosti ; Nested room-configuration structure.
  END_STRUCT;
  // ivı stav pouívate¾a oddelenı od jeho konfigurácie ; Live user state separated from user configuration.
  NH_USERS_MEM: STRUCT
    rec        : NH_REC_ALL;  // Hlavièka, spoloèné identifikátory a stav pripojenia ; Header, shared identifiers, and connection state.
    all        : NH_CFG_ALL;
    Connected  : BOOL;
    LastError  : STRING[80];  // Posledná chyba a èasová znaèka poslednej aktualizácie ; Last error and timestamp of the latest update.
    LastUpdate : UDINT;
  END_STRUCT;
  // Konfigurácia pouívate¾a vrátane práv, zón, IP a ïalších polí ; User configuration including rights, zones, IP addresses, and other fields.
  NH_USERS_CFG: STRUCT
    Name       : STRING[32];                                                                                                              // Meno pouívate¾a a predvo¾by úvodnej obrazovky ; User name and home-screen preferences.
    LoginHome  : BOOL := TRUE;
    DshSet     : BOOL := FALSE;
    OwnDSH     : BOOL := TRUE;                                                                                                            // Príznaky vlastnıch obrazoviek a úroveò oprávnenia ; Custom-screen flags and access-right level.
    OwnQCK     : BOOL := TRUE;
    UsrRight   : USINT := 1;
    ZonList    : ARRAY[1..16] OF BOOL := [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];                                                // Prístup pouívate¾a k šestnástim zónam ; User access flags for sixteen zones.
    sbj        : USINT := 1;                                                                                                              // Predmet, jazyk a osem ob¾úbenıch poloiek ; Subject, language, and eight favorites.
    lng        : USINT;
    fav        : ARRAY[0..7] OF USINT;
    keyPas     : STRING[6];                                                                                                               // Krátky testovací k¾úè, poèet IP adries a tri adresy ; Test key, IP-address count, and three addresses.
    IPnbr      : USINT := 1;
    IP         : ARRAY[1..3] OF STRING[15];
    mail       : STRING[50];                                                                                                              // Kontaktnı e-mail a testovacie autorizaèné tokeny ; Contact email and test authorization tokens.
    TOKENAPPLE : STRING[90];
    TOKENUNI   : STRING[100];
    gsm        : STRING[15];                                                                                                              // Telefón, vzh¾ad a osem príznakov správ ; Phone, appearance, and eight message flags.
    skin       : USINT;
    msg        : ARRAY[0..7] OF BOOL;
    Brw        : ARRAY[0..30] OF USINT := [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];  // Tridsajeden testovacích hodnôt pre prehliadaè ; Thirty-one test values for browser-related settings.
  END_STRUCT;
  // Celá verejná veta pouívate¾a spája stav a konfiguráciu ; One public user record combines state and configuration.
  NH_USER {PUBLIC}: STRUCT
    mem : NH_USERS_MEM;
    cfg : NH_USERS_CFG;
  END_STRUCT;
END_TYPE

VAR_GLOBAL
  mRam : ARRAY[0.._NH_RAM] OF BYTE;        // Spoloènı bajtovı priestor, v ktorom sú uloené všetky vety ; Shared byte-addressable memory containing all records.
  aSys : NH_SYS;                           // Stavové príznaky inicializácie programu ; Program initialization state.
  aCfg : ARRAY[1.._NH_CFG] OF NH_CFG := [  // Tabu¾ka typov: urèuje ich ve¾kosti, poèty viet a rozloenie v mRam ; Type table: defines sizes, record counts, and placement in mRam.
    (cfg := 'ROOM', Enabled := TRUE, ver := 1, Siz := SIZEOF(NH_ROOM),
     Rec := 10, cx := SIZEOF(NH_ROOM.cfg), me := SIZEOF(NH_ROOM.mem)),
    (cfg := 'USER', Enabled := TRUE, ver := 1, Siz := SIZEOF(NH_USER),
     Rec := 10, cx := SIZEOF(NH_USER.cfg), me := SIZEOF(NH_USER.mem),
     cat := 31, ref := 254)
  ];
  xRoom : PTR_TO NH_ROOM;  // Ukazovate¾ na zaèiatok po¾a viet ROOM v mRam ; Pointer to the first ROOM record in mRam.
  xUser : PTR_TO NH_USER;  // Ukazovate¾ na zaèiatok po¾a viet USER v mRam ; Pointer to the first USER record in mRam.

  yRooms : ARRAY[1..10] OF NH_ROOM;  // Iba zdroj testovacích dát ; po skopírovaní do mRam sa ïalej nepouíva. ; Test-data source only ; unused after copying into mRam.
  yUsers : ARRAY[1..10] OF NH_USER;  // Zdroj testovacích viet USER ; po skopírovaní do mRam sa ïalej nepouíva ; Source of USER test records ; unused after copying into mRam.

  DepRq {PUBLIC_API}   : BOOL := FALSE;        // Poiadavka na aktiváciu balíka ; Package-activation request.
  DepRes {PUBLIC_API}  : USINT := 0;           // Vısledkovı kód aktivácie balíka ; Package-activation result code.
  BuildNo {PUBLIC_API} : UDINT := 2026100726;  // Èíslo zostavenia na kontrolu nasadenej verzie ; Build number used to verify the deployed version.

  TxCf {PUBLIC_API}   : USINT := 2;  // Klient nastaví typ a vetu ; TxRq ako posledné spustí export. Nula znamená všetky vety. ; The client sets type and record ; TxRq starts the export last. Zero means all records.
  TxRec {PUBLIC_API}  : UDINT := 0;  // Èíslo exportovanej vety ; nula znamená všetky vety vybraného typu ; Record to export ; zero means all records of the selected type.
  TxRq {PUBLIC_API}   : UDINT := 1;  // Klient zmenou èísla spustí novı export ; A new value starts an export request.
  TxDone {PUBLIC_API} : UDINT := 0;  // Potvrdí èíslo dokonèenej poiadavky na export ; Echoes the completed export request number.
  TxErr {PUBLIC_API}  : USINT := 0;  // Nula znamená úspech ; nenulová hodnota oznaèuje chybu exportu ; Zero means success ; nonzero indicates an export error.

  RxRq    {PUBLIC_API} : UDINT := 0;  // Po prijatí rx.json klient zapíše nové RxRq a tım spustí jeho import. ; After rx.json is received, the client writes a new RxRq to start its import.
  RxDone  {PUBLIC_API} : UDINT := 0;  // Potvrdí èíslo dokonèenej poiadavky na import ; Echoes the completed import request number.
  RxErr   {PUBLIC_API} : USINT := 0;  // Nula znamená úspešnı import ; inak obsahuje kód chyby ; Zero means import succeeded ; otherwise contains an error code.

  rxBuf   {PUBLIC_API} : ARRAY[0..63] OF DWORD;  // Jeden blok klienta má 64 DWORD, teda kapacitu 256 bajtov. ; One client block contains 64 DWORD values, providing 256 bytes of capacity. ; Klient zapíše dáta a metadáta ; RbRq mení a po nich. ; The client writes data and metadata first, then changes RbRq.
  RbOfs   {PUBLIC_API} : UDINT := 0;             // Offset bloku v celom súbore ; Block offset within the complete file.
  RbLen   {PUBLIC_API} : UINT := 0;              // Poèet platnıch bajtov v tomto bloku ; Number of valid bytes in this block.
  RbTotal {PUBLIC_API} : UDINT := 0;             // Celková ve¾kos prijímaného súboru ; Total size of the incoming file.
  RbCrc   {PUBLIC_API} : DWORD := 0;             // Oèakávanı CRC32 súèet celého súboru ; Expected CRC32 checksum of the complete file.
  RbRq    {PUBLIC_API} : UDINT := 0;             // Spúšací èítaè bloku ; klient ho zapisuje a po dátach ; Block trigger counter ; written only after the block data.
  RbAck   {PUBLIC_API} : UDINT := 0;             // Potvrdzuje spracované èíslo bloku ; Acknowledges the processed block number.
  RbWrote {PUBLIC_API} : UDINT := 0;             // Poèet bajtov u uloenıch do rx.json ; Number of bytes already written to rx.json.
  RbReady {PUBLIC_API} : BOOL := FALSE;          // TRUE znamená celı súbor uloenı a CRC overené ; TRUE means the full file is written and its CRC is valid.
  RbErr   {PUBLIC_API} : USINT := 0;             // Vısledok posledného bloku ; nula znamená úspech ; Result of the latest block ; zero means success.
END_VAR
