// Automaticky vygenerovanÈ z api_V12.pux ; neupravovaù ruËne. ; GENERATED from api_V12.pux. Do not edit manually.
VAR_GLOBAL CONSTANT
  SCH_BOOL          : USINT := 16#01;        // KÛd typu BOOL v schÈme ; BOOL type code in the schema
  SCH_SINT          : USINT := 16#02;        // KÛd typu SINT v schÈme ; SINT type code in the schema
  SCH_USINT         : USINT := 16#03;        // KÛd typu USINT v schÈme ; USINT type code in the schema
  SCH_INT           : USINT := 16#04;        // KÛd typu INT v schÈme ; INT type code in the schema
  SCH_UINT          : USINT := 16#05;        // KÛd typu UINT v schÈme ; UINT type code in the schema
  SCH_DINT          : USINT := 16#06;        // KÛd typu DINT v schÈme ; DINT type code in the schema
  SCH_UDINT         : USINT := 16#07;        // KÛd typu UDINT v schÈme ; UDINT type code in the schema
  SCH_BYTE          : USINT := 16#08;        // KÛd typu BYTE v schÈme ; BYTE type code in the schema
  SCH_WORD          : USINT := 16#09;        // KÛd typu WORD v schÈme ; WORD type code in the schema
  SCH_DWORD         : USINT := 16#0A;        // KÛd typu DWORD v schÈme ; DWORD type code in the schema
  SCH_REAL          : USINT := 16#0B;        // KÛd typu REAL v schÈme ; REAL type code in the schema
  SCH_LREAL         : USINT := 16#0C;        // KÛd typu LREAL v schÈme ; LREAL type code in the schema
  SCH_STRING        : USINT := 16#0D;        // KÛd reùazca v schÈme ; String type code in the schema
  SCH_TIME          : USINT := 16#0E;        // KÛd typu TIME v schÈme ; TIME type code in the schema
  SCH_DATE          : USINT := 16#0F;        // KÛd typu DATE v schÈme ; DATE type code in the schema
  SCH_TIME_OF_DAY   : USINT := 16#10;        // KÛd typu TOD v schÈme ; TOD type code in the schema
  SCH_DATE_AND_TIME : USINT := 16#11;        // KÛd typu DT v schÈme ; DT type code in the schema
  SCH_STRUCT        : USINT := 16#12;        // KÛd vnorenej ötrukt˙ry v schÈme ; Nested-structure type code in the schema
  SCH_ARRAY         : USINT := 16#80;        // PrÌznak poæa kombinovan˝ so z·kladn˝m typom ; Array flag combined with the base type
  SCH_BASE          : USINT := 16#7F;        // Maska na zÌskanie z·kladnÈho typu ; Mask used to extract the base type
  SCH_DEF_N         : UINT := 2;             // PoËet definovan˝ch aplikaËn˝ch typov ; Number of application types defined
  SCH_NODE_N        : UINT := 62;            // PoËet uzlov stromu ötrukt˙r ; Number of structure-tree nodes
  SCH_LEAF_N        : UINT := 115;           // PoËet ˙pln˝ch ciest k poloûk·m ; Number of complete field paths
  SCH_PUX_CRC       : DWORD := 16#B72908B3;  // Kontroln˝ s˙Ëet zdrojovÈho PUX ; Checksum of the source PUX
END_VAR

TYPE
  NH_SCH : STRUCT
    Cfg  : USINT;       // PoradovÈ ËÌslo typu v aCfg ; Type index in aCfg
    Code : STRING[4];   // KÛd typu pouûÌvan˝ v JSON ob·lke ; Type code used in the JSON envelope
    Nam  : STRING[16];  // N·zov typu alebo uzla podæa kontextu ; Type or node name, depending on context
    Siz  : UDINT;       // Veækosù jednej celej vety v bajtoch ; Size of one complete record in bytes
    Fst  : UINT;        // Index prvÈho uzla typu ; Index of the first node for this type
    Cnt  : UINT;        // PoËet uzlov typu ; Number of nodes for this type
    LFst : UINT;        // Index prvej ˙plnej cesty poæa ; Index of the first complete field path
    LCnt : UINT;        // PoËet ˙pln˝ch ciest poæa ; Number of complete field paths
  END_STRUCT;
  NH_NODE : STRUCT
    Nam  : STRING[14];  // N·zov typu alebo uzla podæa kontextu ; Type or node name, depending on context
    Tag  : USINT;       // KÛd d·tovÈho typu a prÌpadn˝ prÌznak poæa ; Data-type code and optional array flag
    Ofs  : UINT;        // Offset poloûky od zaËiatku rodiËa ; Field offset from the parent start
    Span : UINT;        // Veækosù poloûky v bajtoch ; Field size in bytes
    Aux  : UINT;        // Doplnkov˝ ˙daj podæa typu uzla ; Auxiliary value interpreted by node type
    Cnt  : UINT;        // PoËet uzlov typu ; Number of nodes for this type
    Lo   : INT;         // Doln· hranica poæa ; Array lower bound
  END_STRUCT;
  NH_LEAF : STRUCT
    Pth    : STRING[18];  // ⁄pln· cesta poæa od koreÚa vety ; Complete field path from the record root
    Tag    : USINT;       // KÛd d·tovÈho typu a prÌpadn˝ prÌznak poæa ; Data-type code and optional array flag
    Ofs    : UINT;        // Offset poloûky od zaËiatku rodiËa ; Field offset from the parent start
    Span   : UINT;        // Veækosù poloûky v bajtoch ; Field size in bytes
    BitPos : SINT;        // PozÌcia BOOL poæa v bajte ; BOOL field bit position within its byte
  END_STRUCT;
END_TYPE

VAR_GLOBAL
  aSch : ARRAY[1..2] OF NH_SCH := [  // Tabuæka rozsahov uzlov a polÌ pre kaûd˝ typ ; Per-type ranges of nodes and fields
    (Cfg := 1, Code := 'ROOM', Nam := 'NH_ROOM', Siz := 216, Fst := 1, Cnt := 31, LFst := 1, LCnt := 27),
    (Cfg := 2, Code := 'USER', Nam := 'NH_USER', Siz := 488, Fst := 32, Cnt := 31, LFst := 28, LCnt := 88)
  ];
  aNode : ARRAY[1..62] OF NH_NODE := [  // Sploöten˝ strom vöetk˝ch uzlov ötrukt˙r ; Flattened tree of all structure nodes
    (Nam := 'mem', Tag := 16#12, Ofs := 0, Span := 24, Aux := 14, Cnt := 0, Lo := 0),
    (Nam := 'rec', Tag := 16#12, Ofs := 0, Span := 3, Aux := 2, Cnt := 0, Lo := 0),
    (Nam := 'Ok', Tag := 16#01, Ofs := 0, Span := 1, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'ID', Tag := 16#04, Ofs := 1, Span := 2, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'all', Tag := 16#12, Ofs := 3, Span := 4, Aux := 2, Cnt := 0, Lo := 0),
    (Nam := 'RoomID', Tag := 16#04, Ofs := 0, Span := 2, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'CategoryID', Tag := 16#04, Ofs := 2, Span := 2, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'Temperature', Tag := 16#0B, Ofs := 7, Span := 4, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'Humidity', Tag := 16#0B, Ofs := 11, Span := 4, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'Presence', Tag := 16#01, Ofs := 15, Span := 1, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'DayPhase', Tag := 16#05, Ofs := 16, Span := 2, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'CategoryMask', Tag := 16#0A, Ofs := 18, Span := 4, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'AlarmLevel', Tag := 16#03, Ofs := 22, Span := 1, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'Online', Tag := 16#01, Ofs := 23, Span := 1, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'Twilight', Tag := 16#01, Ofs := 23, Span := 1, Aux := 1, Cnt := 0, Lo := 0),
    (Nam := 'cfg', Tag := 16#12, Ofs := 24, Span := 192, Aux := 15, Cnt := 0, Lo := 0),
    (Nam := 'Name', Tag := 16#0D, Ofs := 0, Span := 33, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := '_Dint', Tag := 16#06, Ofs := 33, Span := 4, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := '_Sint', Tag := 16#02, Ofs := 37, Span := 1, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := '_Usint', Tag := 16#03, Ofs := 38, Span := 1, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := '_Uint', Tag := 16#05, Ofs := 39, Span := 2, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := '_Real', Tag := 16#0B, Ofs := 41, Span := 4, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := '_LReal', Tag := 16#0C, Ofs := 45, Span := 8, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := '_String', Tag := 16#0D, Ofs := 53, Span := 31, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := '_StringCZSK', Tag := 16#0D, Ofs := 84, Span := 81, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := '_BYTE', Tag := 16#08, Ofs := 165, Span := 1, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := '_WORD', Tag := 16#09, Ofs := 166, Span := 2, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := '_TIME', Tag := 16#0E, Ofs := 168, Span := 4, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := '_DATE', Tag := 16#0F, Ofs := 172, Span := 8, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := '_TIME_OF_DAY', Tag := 16#10, Ofs := 180, Span := 4, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := '_DATE_AND_TIME', Tag := 16#11, Ofs := 184, Span := 8, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'mem', Tag := 16#12, Ofs := 0, Span := 93, Aux := 9, Cnt := 0, Lo := 0),
    (Nam := 'rec', Tag := 16#12, Ofs := 0, Span := 3, Aux := 2, Cnt := 0, Lo := 0),
    (Nam := 'Ok', Tag := 16#01, Ofs := 0, Span := 1, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'ID', Tag := 16#04, Ofs := 1, Span := 2, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'all', Tag := 16#12, Ofs := 3, Span := 4, Aux := 2, Cnt := 0, Lo := 0),
    (Nam := 'RoomID', Tag := 16#04, Ofs := 0, Span := 2, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'CategoryID', Tag := 16#04, Ofs := 2, Span := 2, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'Connected', Tag := 16#01, Ofs := 7, Span := 1, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'LastError', Tag := 16#0D, Ofs := 8, Span := 81, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'LastUpdate', Tag := 16#07, Ofs := 89, Span := 4, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'cfg', Tag := 16#12, Ofs := 93, Span := 395, Aux := 20, Cnt := 0, Lo := 0),
    (Nam := 'Name', Tag := 16#0D, Ofs := 0, Span := 33, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'LoginHome', Tag := 16#01, Ofs := 33, Span := 1, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'DshSet', Tag := 16#01, Ofs := 33, Span := 1, Aux := 1, Cnt := 0, Lo := 0),
    (Nam := 'OwnDSH', Tag := 16#01, Ofs := 33, Span := 1, Aux := 2, Cnt := 0, Lo := 0),
    (Nam := 'OwnQCK', Tag := 16#01, Ofs := 33, Span := 1, Aux := 3, Cnt := 0, Lo := 0),
    (Nam := 'UsrRight', Tag := 16#03, Ofs := 34, Span := 1, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'ZonList', Tag := 16#81, Ofs := 35, Span := 2, Aux := 0, Cnt := 16, Lo := 1),
    (Nam := 'sbj', Tag := 16#03, Ofs := 37, Span := 1, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'lng', Tag := 16#03, Ofs := 38, Span := 1, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'fav', Tag := 16#83, Ofs := 39, Span := 8, Aux := 1, Cnt := 8, Lo := 0),
    (Nam := 'keyPas', Tag := 16#0D, Ofs := 47, Span := 7, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'IPnbr', Tag := 16#03, Ofs := 54, Span := 1, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'IP', Tag := 16#8D, Ofs := 55, Span := 48, Aux := 16, Cnt := 3, Lo := 1),
    (Nam := 'mail', Tag := 16#0D, Ofs := 103, Span := 51, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'TOKENAPPLE', Tag := 16#0D, Ofs := 154, Span := 91, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'TOKENUNI', Tag := 16#0D, Ofs := 245, Span := 101, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'gsm', Tag := 16#0D, Ofs := 346, Span := 16, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'skin', Tag := 16#03, Ofs := 362, Span := 1, Aux := 0, Cnt := 0, Lo := 0),
    (Nam := 'msg', Tag := 16#81, Ofs := 363, Span := 1, Aux := 0, Cnt := 8, Lo := 0),
    (Nam := 'Brw', Tag := 16#83, Ofs := 364, Span := 31, Aux := 1, Cnt := 31, Lo := 0)
  ];
  aLeaf : ARRAY[1..115] OF NH_LEAF := [  // Tabuæka ˙pln˝ch n·zvov koncov˝ch polÌ ; Lookup table of complete leaf-field names
    (Pth := 'mem.rec.Ok', Tag := 16#01, Ofs := 0, Span := 1, BitPos := 0),
    (Pth := 'mem.rec.ID', Tag := 16#04, Ofs := 1, Span := 2, BitPos := -1),
    (Pth := 'mem.all.RoomID', Tag := 16#04, Ofs := 3, Span := 2, BitPos := -1),
    (Pth := 'mem.all.CategoryID', Tag := 16#04, Ofs := 5, Span := 2, BitPos := -1),
    (Pth := 'mem.Temperature', Tag := 16#0B, Ofs := 7, Span := 4, BitPos := -1),
    (Pth := 'mem.Humidity', Tag := 16#0B, Ofs := 11, Span := 4, BitPos := -1),
    (Pth := 'mem.Presence', Tag := 16#01, Ofs := 15, Span := 1, BitPos := 0),
    (Pth := 'mem.DayPhase', Tag := 16#05, Ofs := 16, Span := 2, BitPos := -1),
    (Pth := 'mem.CategoryMask', Tag := 16#0A, Ofs := 18, Span := 4, BitPos := -1),
    (Pth := 'mem.AlarmLevel', Tag := 16#03, Ofs := 22, Span := 1, BitPos := -1),
    (Pth := 'mem.Online', Tag := 16#01, Ofs := 23, Span := 1, BitPos := 0),
    (Pth := 'mem.Twilight', Tag := 16#01, Ofs := 23, Span := 1, BitPos := 1),
    (Pth := 'cfg.Name', Tag := 16#0D, Ofs := 24, Span := 33, BitPos := -1),
    (Pth := 'cfg._Dint', Tag := 16#06, Ofs := 57, Span := 4, BitPos := -1),
    (Pth := 'cfg._Sint', Tag := 16#02, Ofs := 61, Span := 1, BitPos := -1),
    (Pth := 'cfg._Usint', Tag := 16#03, Ofs := 62, Span := 1, BitPos := -1),
    (Pth := 'cfg._Uint', Tag := 16#05, Ofs := 63, Span := 2, BitPos := -1),
    (Pth := 'cfg._Real', Tag := 16#0B, Ofs := 65, Span := 4, BitPos := -1),
    (Pth := 'cfg._LReal', Tag := 16#0C, Ofs := 69, Span := 8, BitPos := -1),
    (Pth := 'cfg._String', Tag := 16#0D, Ofs := 77, Span := 31, BitPos := -1),
    (Pth := 'cfg._StringCZSK', Tag := 16#0D, Ofs := 108, Span := 81, BitPos := -1),
    (Pth := 'cfg._BYTE', Tag := 16#08, Ofs := 189, Span := 1, BitPos := -1),
    (Pth := 'cfg._WORD', Tag := 16#09, Ofs := 190, Span := 2, BitPos := -1),
    (Pth := 'cfg._TIME', Tag := 16#0E, Ofs := 192, Span := 4, BitPos := -1),
    (Pth := 'cfg._DATE', Tag := 16#0F, Ofs := 196, Span := 8, BitPos := -1),
    (Pth := 'cfg._TIME_OF_DAY', Tag := 16#10, Ofs := 204, Span := 4, BitPos := -1),
    (Pth := 'cfg._DATE_AND_TIME', Tag := 16#11, Ofs := 208, Span := 8, BitPos := -1),
    (Pth := 'mem.rec.Ok', Tag := 16#01, Ofs := 0, Span := 1, BitPos := 0),
    (Pth := 'mem.rec.ID', Tag := 16#04, Ofs := 1, Span := 2, BitPos := -1),
    (Pth := 'mem.all.RoomID', Tag := 16#04, Ofs := 3, Span := 2, BitPos := -1),
    (Pth := 'mem.all.CategoryID', Tag := 16#04, Ofs := 5, Span := 2, BitPos := -1),
    (Pth := 'mem.Connected', Tag := 16#01, Ofs := 7, Span := 1, BitPos := 0),
    (Pth := 'mem.LastError', Tag := 16#0D, Ofs := 8, Span := 81, BitPos := -1),
    (Pth := 'mem.LastUpdate', Tag := 16#07, Ofs := 89, Span := 4, BitPos := -1),
    (Pth := 'cfg.Name', Tag := 16#0D, Ofs := 93, Span := 33, BitPos := -1),
    (Pth := 'cfg.LoginHome', Tag := 16#01, Ofs := 126, Span := 1, BitPos := 0),
    (Pth := 'cfg.DshSet', Tag := 16#01, Ofs := 126, Span := 1, BitPos := 1),
    (Pth := 'cfg.OwnDSH', Tag := 16#01, Ofs := 126, Span := 1, BitPos := 2),
    (Pth := 'cfg.OwnQCK', Tag := 16#01, Ofs := 126, Span := 1, BitPos := 3),
    (Pth := 'cfg.UsrRight', Tag := 16#03, Ofs := 127, Span := 1, BitPos := -1),
    (Pth := 'cfg.ZonList[0]', Tag := 16#01, Ofs := 128, Span := 1, BitPos := 0),
    (Pth := 'cfg.ZonList[1]', Tag := 16#01, Ofs := 128, Span := 1, BitPos := 1),
    (Pth := 'cfg.ZonList[2]', Tag := 16#01, Ofs := 128, Span := 1, BitPos := 2),
    (Pth := 'cfg.ZonList[3]', Tag := 16#01, Ofs := 128, Span := 1, BitPos := 3),
    (Pth := 'cfg.ZonList[4]', Tag := 16#01, Ofs := 128, Span := 1, BitPos := 4),
    (Pth := 'cfg.ZonList[5]', Tag := 16#01, Ofs := 128, Span := 1, BitPos := 5),
    (Pth := 'cfg.ZonList[6]', Tag := 16#01, Ofs := 128, Span := 1, BitPos := 6),
    (Pth := 'cfg.ZonList[7]', Tag := 16#01, Ofs := 128, Span := 1, BitPos := 7),
    (Pth := 'cfg.ZonList[8]', Tag := 16#01, Ofs := 129, Span := 1, BitPos := 0),
    (Pth := 'cfg.ZonList[9]', Tag := 16#01, Ofs := 129, Span := 1, BitPos := 1),
    (Pth := 'cfg.ZonList[10]', Tag := 16#01, Ofs := 129, Span := 1, BitPos := 2),
    (Pth := 'cfg.ZonList[11]', Tag := 16#01, Ofs := 129, Span := 1, BitPos := 3),
    (Pth := 'cfg.ZonList[12]', Tag := 16#01, Ofs := 129, Span := 1, BitPos := 4),
    (Pth := 'cfg.ZonList[13]', Tag := 16#01, Ofs := 129, Span := 1, BitPos := 5),
    (Pth := 'cfg.ZonList[14]', Tag := 16#01, Ofs := 129, Span := 1, BitPos := 6),
    (Pth := 'cfg.ZonList[15]', Tag := 16#01, Ofs := 129, Span := 1, BitPos := 7),
    (Pth := 'cfg.sbj', Tag := 16#03, Ofs := 130, Span := 1, BitPos := -1),
    (Pth := 'cfg.lng', Tag := 16#03, Ofs := 131, Span := 1, BitPos := -1),
    (Pth := 'cfg.fav[0]', Tag := 16#03, Ofs := 132, Span := 1, BitPos := -1),
    (Pth := 'cfg.fav[1]', Tag := 16#03, Ofs := 133, Span := 1, BitPos := -1),
    (Pth := 'cfg.fav[2]', Tag := 16#03, Ofs := 134, Span := 1, BitPos := -1),
    (Pth := 'cfg.fav[3]', Tag := 16#03, Ofs := 135, Span := 1, BitPos := -1),
    (Pth := 'cfg.fav[4]', Tag := 16#03, Ofs := 136, Span := 1, BitPos := -1),
    (Pth := 'cfg.fav[5]', Tag := 16#03, Ofs := 137, Span := 1, BitPos := -1),
    (Pth := 'cfg.fav[6]', Tag := 16#03, Ofs := 138, Span := 1, BitPos := -1),
    (Pth := 'cfg.fav[7]', Tag := 16#03, Ofs := 139, Span := 1, BitPos := -1),
    (Pth := 'cfg.keyPas', Tag := 16#0D, Ofs := 140, Span := 7, BitPos := -1),
    (Pth := 'cfg.IPnbr', Tag := 16#03, Ofs := 147, Span := 1, BitPos := -1),
    (Pth := 'cfg.IP[0]', Tag := 16#0D, Ofs := 148, Span := 16, BitPos := -1),
    (Pth := 'cfg.IP[1]', Tag := 16#0D, Ofs := 164, Span := 16, BitPos := -1),
    (Pth := 'cfg.IP[2]', Tag := 16#0D, Ofs := 180, Span := 16, BitPos := -1),
    (Pth := 'cfg.mail', Tag := 16#0D, Ofs := 196, Span := 51, BitPos := -1),
    (Pth := 'cfg.TOKENAPPLE', Tag := 16#0D, Ofs := 247, Span := 91, BitPos := -1),
    (Pth := 'cfg.TOKENUNI', Tag := 16#0D, Ofs := 338, Span := 101, BitPos := -1),
    (Pth := 'cfg.gsm', Tag := 16#0D, Ofs := 439, Span := 16, BitPos := -1),
    (Pth := 'cfg.skin', Tag := 16#03, Ofs := 455, Span := 1, BitPos := -1),
    (Pth := 'cfg.msg[0]', Tag := 16#01, Ofs := 456, Span := 1, BitPos := 0),
    (Pth := 'cfg.msg[1]', Tag := 16#01, Ofs := 456, Span := 1, BitPos := 1),
    (Pth := 'cfg.msg[2]', Tag := 16#01, Ofs := 456, Span := 1, BitPos := 2),
    (Pth := 'cfg.msg[3]', Tag := 16#01, Ofs := 456, Span := 1, BitPos := 3),
    (Pth := 'cfg.msg[4]', Tag := 16#01, Ofs := 456, Span := 1, BitPos := 4),
    (Pth := 'cfg.msg[5]', Tag := 16#01, Ofs := 456, Span := 1, BitPos := 5),
    (Pth := 'cfg.msg[6]', Tag := 16#01, Ofs := 456, Span := 1, BitPos := 6),
    (Pth := 'cfg.msg[7]', Tag := 16#01, Ofs := 456, Span := 1, BitPos := 7),
    (Pth := 'cfg.Brw[0]', Tag := 16#03, Ofs := 457, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[1]', Tag := 16#03, Ofs := 458, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[2]', Tag := 16#03, Ofs := 459, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[3]', Tag := 16#03, Ofs := 460, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[4]', Tag := 16#03, Ofs := 461, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[5]', Tag := 16#03, Ofs := 462, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[6]', Tag := 16#03, Ofs := 463, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[7]', Tag := 16#03, Ofs := 464, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[8]', Tag := 16#03, Ofs := 465, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[9]', Tag := 16#03, Ofs := 466, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[10]', Tag := 16#03, Ofs := 467, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[11]', Tag := 16#03, Ofs := 468, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[12]', Tag := 16#03, Ofs := 469, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[13]', Tag := 16#03, Ofs := 470, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[14]', Tag := 16#03, Ofs := 471, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[15]', Tag := 16#03, Ofs := 472, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[16]', Tag := 16#03, Ofs := 473, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[17]', Tag := 16#03, Ofs := 474, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[18]', Tag := 16#03, Ofs := 475, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[19]', Tag := 16#03, Ofs := 476, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[20]', Tag := 16#03, Ofs := 477, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[21]', Tag := 16#03, Ofs := 478, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[22]', Tag := 16#03, Ofs := 479, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[23]', Tag := 16#03, Ofs := 480, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[24]', Tag := 16#03, Ofs := 481, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[25]', Tag := 16#03, Ofs := 482, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[26]', Tag := 16#03, Ofs := 483, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[27]', Tag := 16#03, Ofs := 484, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[28]', Tag := 16#03, Ofs := 485, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[29]', Tag := 16#03, Ofs := 486, Span := 1, BitPos := -1),
    (Pth := 'cfg.Brw[30]', Tag := 16#03, Ofs := 487, Span := 1, BitPos := -1)
  ];
END_VAR
