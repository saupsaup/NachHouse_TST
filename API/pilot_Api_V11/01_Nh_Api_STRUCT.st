// NachHouse API V11: one shared RX mailbox, one shared TX buffer and one transaction owner.
// SK: NachHouse API V11: jeden spolocny RX mailbox, jeden TX buffer a jeden vlastnik transakcie.

VAR_GLOBAL CONSTANT
   NH_API_VERSION                 : UINT := 11;           // Public binary API format version. SK: Verzia verejneho binarneho API formatu.
   NH_API_MAGIC                   : DWORD := 16#5041484E; // ASCII NHAP in little-endian byte order. SK: ASCII NHAP v little-endian poradi bajtov.
   NH_API_HEADER_SIZE             : UINT := 40;           // Fixed frame header size in bytes. SK: Pevna velkost hlavicky ramca v bajtoch.
   NH_API_TX_WORD_COUNT           : UINT := 512;          // Shared TX capacity in DWORD words. SK: Kapacita spolocneho TX pola v DWORD.
   NH_API_RX_WORD_COUNT           : UINT := 64;           // Shared RX capacity in DWORD words. SK: Kapacita spolocneho RX pola v DWORD.
   NH_API_TX_BYTE_CAPACITY        : UINT := 2048;         // Shared TX capacity in bytes. SK: Kapacita spolocneho TX pola v bajtoch.
   NH_API_RX_BYTE_CAPACITY        : UINT := 256;          // Shared RX capacity in bytes. SK: Kapacita spolocneho RX pola v bajtoch.
   NH_API_MAX_ROOMS               : UINT := 40;           // Maximum number of pilot room records. SK: Najvacsi pocet room zaznamov pilotu.
   NH_LOAD_DEVICE_COUNT           : UINT := 800;          // Number of compact smart-home model devices. SK: Pocet kompaktnych modelovych smart-home zariadeni.
   NH_API_TRANSACTION_TIMEOUT_MS  : UDINT := 30000;       // Maximum owner inactivity time. SK: Maximalny cas necinnosti vlastnika.
   NH_API_BROADCAST_HOLD_MS       : UDINT := 500;         // Minimum time one best-effort broadcast frame stays stable. SK: Minimalny cas stability jedneho broadcast ramca.

   NH_API_CONFIG_RECORD_SIZE      : UINT := 138;          // Wire size of one room config record. SK: Wire velkost jedneho room config zaznamu.
   NH_API_STATE_RECORD_SIZE       : UINT := 22;           // Wire size of one room state record. SK: Wire velkost jedneho room state zaznamu.
   NH_API_CONFIG_DIFF_SIZE        : UINT := 143;          // Operation, RoomId and config record. SK: Operacia, RoomId a config zaznam.
   NH_API_STATE_DIFF_SIZE         : UINT := 27;           // Operation, RoomId and state record. SK: Operacia, RoomId a state zaznam.
   NH_API_CONFIG_PER_FRAME        : USINT := 14;           // Config records fitting into one TX frame. SK: Config zaznamy, ktore sa zmestia do jedneho TX ramca.
   NH_API_STATE_PER_FRAME         : USINT := 40;           // State records fitting into one TX frame. SK: State zaznamy, ktore sa zmestia do jedneho TX ramca.
   NH_API_CONFIG_DIFF_PER_FRAME   : USINT := 14;           // Config changes fitting into one TX frame. SK: Config zmeny, ktore sa zmestia do jedneho TX ramca.
   NH_API_STATE_DIFF_PER_FRAME    : USINT := 40;           // State changes fitting into one TX frame. SK: State zmeny, ktore sa zmestia do jedneho TX ramca.

   NH_API_STATE_IDLE              : UINT := 0;             // No transaction owns the API. SK: API nevlastni ziadna transakcia.
   NH_API_STATE_OWNER_READY       : UINT := 1;             // PLC accepted OwnerClientId; owner may write RX. SK: PLC prijalo OwnerClientId; vlastnik moze zapisat RX.
   NH_API_STATE_RX_READY          : UINT := 2;             // Owner completed RX and committed it. SK: Vlastnik dokoncil RX a potvrdil ho.

   NH_API_MODE_NONE               : USINT := 0;            // No frame sequence is active. SK: Nie je aktivna ziadna sekvencia ramcov.
   NH_API_MODE_SNAPSHOT           : USINT := 1;            // Targeted snapshot sequence. SK: Cielena snapshot sekvencia.
   NH_API_MODE_COMMAND            : USINT := 2;            // Targeted command response sequence. SK: Cielena sekvencia odpovede na prikaz.
   NH_API_MODE_BROADCAST_DIFF     : USINT := 3;            // Best-effort PLC-originated diff. SK: Best-effort diff vyvolany PLC.
   NH_API_MODE_BROADCAST_SNAPSHOT : USINT := 4;            // Best-effort test snapshot without an owner. SK: Best-effort test snapshot bez vlastnika.

   NH_API_MSG_SNAPSHOT_REQUEST    : UINT := 1;             // RX request for current room snapshot. SK: RX poziadavka na aktualny room snapshot.
   NH_API_MSG_ADD_ROOM            : UINT := 2;             // RX request to add a room. SK: RX poziadavka na pridanie miestnosti.
   NH_API_MSG_DELETE_ROOM         : UINT := 3;             // RX request to delete a room. SK: RX poziadavka na zmazanie miestnosti.
   NH_API_MSG_COPY_ROOM           : UINT := 4;             // RX request to copy a room. SK: RX poziadavka na kopirovanie miestnosti.
   NH_API_MSG_SET_ROOM_CONFIG     : UINT := 5;             // RX request to replace room config. SK: RX poziadavka na nahradenie room configu.
   NH_API_MSG_SET_ROOM_STATE      : UINT := 6;             // RX request to replace room state. SK: RX poziadavka na nahradenie room state.
   NH_API_MSG_CONFIG_SNAPSHOT     : UINT := 101;           // TX config snapshot part. SK: TX cast config snapshotu.
   NH_API_MSG_STATE_SNAPSHOT      : UINT := 102;           // TX state snapshot part. SK: TX cast state snapshotu.
   NH_API_MSG_CONFIG_DIFF         : UINT := 103;           // TX config changes. SK: TX zmeny configu.
   NH_API_MSG_STATE_DIFF          : UINT := 104;           // TX state changes. SK: TX zmeny state.
   NH_API_MSG_SNAPSHOT_DONE       : UINT := 105;           // TX final snapshot frame. SK: TX posledny ramec snapshotu.
   NH_API_MSG_RESULT              : UINT := 106;           // TX final command result. SK: TX konecny vysledok prikazu.

   NH_API_SCHEMA_NONE             : UINT := 0;             // Frame has no structured record. SK: Ramec nema strukturovany zaznam.
   NH_API_SCHEMA_ROOM_CONFIG      : UINT := 1;             // NH_ROOM_CONFIG wire schema. SK: Wire schema NH_ROOM_CONFIG.
   NH_API_SCHEMA_ROOM_STATE       : UINT := 2;             // NH_ROOM_STATE wire schema. SK: Wire schema NH_ROOM_STATE.

   NH_API_CHANGE_UPSERT           : USINT := 1;            // Add or complete record replacement. SK: Pridanie alebo uplne nahradenie zaznamu.
   NH_API_CHANGE_DELETE           : USINT := 2;            // Record deletion. SK: Zmazanie zaznamu.

   NH_API_RESULT_NONE             : USINT := 0;            // No result is available. SK: Vysledok nie je k dispozicii.
   NH_API_RESULT_OK               : USINT := 1;            // Request completed successfully. SK: Poziadavka bola uspesna.
   NH_API_RESULT_BUSY             : USINT := 2;            // API is owned by another transaction. SK: API vlastni ina transakcia.
   NH_API_RESULT_BAD_FRAME        : USINT := 3;            // Header, size, owner or CRC is invalid. SK: Hlavicka, velkost, vlastnik alebo CRC su neplatne.
   NH_API_RESULT_NOT_FOUND        : USINT := 4;            // Requested room does not exist. SK: Pozadovana miestnost neexistuje.
   NH_API_RESULT_NO_FREE_SLOT     : USINT := 5;            // No internal room slot is free. SK: Nie je volny interny room slot.
   NH_API_RESULT_ALREADY_EXISTS   : USINT := 6;            // Target RoomId already exists. SK: Cielove RoomId uz existuje.
   NH_API_RESULT_INVALID          : USINT := 7;            // Request payload is invalid. SK: Payload poziadavky nie je platny.
   NH_API_RESULT_UNSUPPORTED      : USINT := 8;            // Message type is unsupported. SK: Typ spravy nie je podporovany.
   NH_API_RESULT_TIMEOUT          : USINT := 9;            // Owner did not complete the handshake. SK: Vlastnik nedokoncil handshake.

   NH_API_TEST_NONE               : USINT := 0;            // Test interface performs no action. SK: Testovacie rozhranie nevykona akciu.
   NH_API_TEST_SET_STATE          : USINT := 1;            // Test interface changes room state. SK: Testovacie rozhranie zmeni room state.
   NH_API_TEST_ADD_ROOM           : USINT := 2;            // Test interface adds a room. SK: Testovacie rozhranie prida miestnost.
   NH_API_TEST_DELETE_ROOM        : USINT := 3;            // Test interface deletes a room. SK: Testovacie rozhranie zmaze miestnost.
   NH_API_TEST_COPY_ROOM          : USINT := 4;            // Test interface copies a room. SK: Testovacie rozhranie skopiruje miestnost.
   NH_API_TEST_SET_CONFIG         : USINT := 5;            // Test interface changes room config. SK: Testovacie rozhranie zmeni room config.
   NH_API_TEST_REQUEST_SNAPSHOT   : USINT := 6;            // Test interface publishes a broadcast snapshot. SK: Testovacie rozhranie publikuje broadcast snapshot.
   NH_API_TEST_AWAY               : USINT := 7;            // Test interface applies the LOAD_800 departure scene. SK: Testovacie rozhranie vykona modelovu scenu odchod LOAD_800.
END_VAR

TYPE
   NH_ROOM_CONFIG : STRUCT // Static room configuration used by snapshots, diffs and commands. SK: Staticka konfiguracia miestnosti pouzita v snapshotoch, diffoch a prikazoch.
      Used           : BOOL;       // TRUE marks an occupied internal slot. SK: TRUE oznacuje obsadeny interny slot.
      RoomId         : UDINT;      // Stable room identifier. SK: Stabilny identifikator miestnosti.
      Name           : STRING[64]; // UTF-8 room name, at most 64 bytes. SK: UTF-8 nazov miestnosti, najviac 64 bajtov.
      ProjectName    : STRING[64]; // UTF-8 project name, at most 64 bytes. SK: UTF-8 projektovy nazov, najviac 64 bajtov.
      IconId         : UINT;       // Client icon identifier. SK: Identifikator ikony klienta.
      SortDefault    : UINT;       // Default room order. SK: Predvolene poradie miestnosti.
   END_STRUCT

   NH_ROOM_STATE : STRUCT // Dynamic room state used by snapshots, diffs and commands. SK: Dynamicky stav miestnosti pouzity v snapshotoch, diffoch a prikazoch.
      RoomId         : UDINT;      // Stable ID matching the config record. SK: Stabilne ID zodpovedajuce config zaznamu.
      Temperature    : REAL;       // Temperature in degrees Celsius. SK: Teplota v stupnoch Celzia.
      Humidity       : REAL;       // Relative humidity in percent. SK: Relativna vlhkost v percentach.
      Presence       : BOOL;       // Presence flag. SK: Priznak pritomnosti.
      DayPhase       : UINT;       // Day-phase icon identifier. SK: Identifikator ikony fazy dna.
      CategoryMask   : DWORD;      // Bit mask of active categories. SK: Bitova maska aktivnych kategorii.
      AlarmLevel     : USINT;      // Alarm level from 0 to 2. SK: Uroven alarmu od 0 do 2.
      Online         : BOOL;       // Room data availability. SK: Dostupnost dat miestnosti.
      Twilight       : BOOL;       // Twilight state used by room browser. SK: Stav osvetlenia pouzity room browserom.
   END_STRUCT

   NH_API_INFO : STRUCT // Minimal global owner and handshake state. SK: Minimalny globalny stav vlastnika a handshake.
      ApiVersion      : UINT;      // Binary API contract version. SK: Verzia binarneho API kontraktu.
      State           : UINT;      // Zero is free; nonzero is the current handshake step. SK: Nula je volno; nenulova hodnota je aktualny handshake krok.
      OwnerClientId   : UDINT;     // Fresh nonzero owner token of the current transaction. SK: Novy nenulovy token vlastnika aktualnej transakcie.
   END_STRUCT

   NH_API_TEST_CONTROL : STRUCT // Direct WebMaker/debug interface for PLC-originated test changes. SK: Priame WebMaker/debug rozhranie pre testovacie zmeny vyvolane PLC.
      Execute         : BOOL;       // Set TRUE last to execute the prepared action. SK: Nastavit TRUE ako posledne pre vykonanie pripravenej akcie.
      Finished        : BOOL;       // TRUE after the test action was accepted. SK: TRUE po prijati testovacej akcie.
      Action          : USINT;      // Requested NH_API_TEST_* action. SK: Pozadovana akcia NH_API_TEST_*.
      ResultCode      : USINT;      // NH_API_RESULT_* outcome. SK: Vysledok NH_API_RESULT_*.
      RoomId          : UDINT;      // Target room ID. SK: Cielove ID miestnosti.
      SourceRoomId    : UDINT;      // Source ID for copy. SK: Zdrojove ID pri kopirovani.
      Name            : STRING[64]; // New room name. SK: Novy nazov miestnosti.
      ProjectName     : STRING[64]; // New project name. SK: Novy projektovy nazov.
      IconId          : UINT;       // New icon identifier. SK: Novy identifikator ikony.
      Temperature     : REAL;       // Test temperature. SK: Testovacia teplota.
      Humidity        : REAL;       // Test humidity. SK: Testovacia vlhkost.
      Presence        : BOOL;       // Test presence. SK: Testovacia pritomnost.
      DayPhase        : UINT;       // Test day phase. SK: Testovacia faza dna.
      CategoryMask    : DWORD;      // Test category mask. SK: Testovacia maska kategorii.
      AlarmLevel      : USINT;      // Test alarm level. SK: Testovacia uroven alarmu.
      Online          : BOOL;       // Test availability. SK: Testovacia dostupnost.
      Twilight        : BOOL;       // Test twilight state. SK: Testovaci twilight stav.
   END_STRUCT

   NH_LOAD_TEST_STATUS : STRUCT // Observable LOAD_800 test status. SK: Pozorovatelny stav testu LOAD_800.
      DepartureActive : BOOL;  // TRUE while the model is in departure mode. SK: TRUE pocas modeloveho rezimu odchod.
      LastChangedCount: UINT;  // Device records changed by the last scene. SK: Pocet zaznamov zmenenych poslednou scenou.
      LastApplyMs     : UDINT; // PLC time spent applying the scene. SK: Cas PLC potrebny na vykonanie sceny.
      Sequence        : UDINT; // Increments after every completed model scene. SK: Zvysi sa po kazdej dokoncenej modelovej scene.
   END_STRUCT
END_TYPE

VAR_GLOBAL
   NhApiInfo       {PUBLIC_API} : NH_API_INFO;                // Minimal global transaction control. SK: Minimalne globalne riadenie transakcie.
   NhApiTX         {PUBLIC_API} : ARRAY[0..511] OF DWORD;     // Stable PLC-to-clients frame. SK: Stabilny ramec PLC smerom ku klientom.
   NhApiRX         {PUBLIC_API} : ARRAY[0..63] OF DWORD;      // Shared owner-to-PLC request frame. SK: Spolocny ramec poziadavky vlastnika smerom do PLC.
   NhApiTest       {PUBLIC_API} : NH_API_TEST_CONTROL;        // Direct PLC-originated test control. SK: Priame riadenie testov vyvolanych PLC.
   NhLoadTest      {PUBLIC_API} : NH_LOAD_TEST_STATUS;        // LOAD_800 status and measurements. SK: Stav a merania LOAD_800.
   NhLoadDevices   {PUBLIC_API} : ARRAY[1..800] OF DWORD;     // Compact model state: high byte kind, low bits value. SK: Kompaktny modelovy stav: horny bajt typ, dolne bity hodnota.

   NhRoomsConfig                : ARRAY[1..40] OF NH_ROOM_CONFIG; // Authoritative PLC room configuration. SK: Autoritativna PLC konfiguracia miestnosti.
   NhRoomsState                 : ARRAY[1..40] OF NH_ROOM_STATE;  // Authoritative PLC room state. SK: Autoritativny PLC stav miestnosti.
END_VAR

VAR_GLOBAL
   NhApiInitialized             : BOOL;                         // One-time initialization completed. SK: Jednorazova inicializacia dokoncena.
   NhActiveOwnerClientId        : UDINT;                        // Owner token captured by PLC. SK: Token vlastnika zachyteny PLC.
   NhExpectedState              : UINT;                         // State value currently owned by PLC. SK: Hodnota State aktualne vlastnena PLC.
   NhTransactionMode           : USINT;                        // Active NH_API_MODE_*. SK: Aktivny NH_API_MODE_*.
   NhTransactionLastMs         : UDINT;                        // Time of the last accepted handshake step. SK: Cas posledneho prijateho handshake kroku.
   NhPublishedFrameId          : UDINT;                        // Monotonic identity of every published TX frame. SK: Monotonny identifikator kazdeho publikovaneho TX ramca.
   NhCommandResult             : USINT;                        // Result sent in the final command frame. SK: Vysledok poslany v poslednom prikazovom ramci.
   NhResultPending             : BOOL;                         // Final command result still has to be sent. SK: Konecny vysledok prikazu este treba odoslat.

   NhConfigShadow              : ARRAY[1..40] OF NH_ROOM_CONFIG; // Last published config image. SK: Posledny publikovany obraz konfiguracie.
   NhStateShadow               : ARRAY[1..40] OF NH_ROOM_STATE;  // Last published state image. SK: Posledny publikovany obraz stavu.

   NhPendingConfig             : ARRAY[1..40] OF NH_ROOM_CONFIG; // Frozen config diff records. SK: Zmrazene zaznamy config diffu.
   NhPendingConfigOperation    : ARRAY[1..40] OF USINT;          // Operations of config diff records. SK: Operacie zaznamov config diffu.
   NhPendingConfigRoomId       : ARRAY[1..40] OF UDINT;          // Stable IDs of config changes. SK: Stabilne ID config zmien.
   NhPendingConfigCount        : USINT;                          // Number of frozen config changes. SK: Pocet zmrazenych config zmien.
   NhPendingConfigNext         : USINT;                          // First config change in the next frame. SK: Prva config zmena v dalsom ramci.
   NhPendingConfigPart         : USINT;                          // Next config diff part index. SK: Index dalsej casti config diffu.
   NhPendingConfigParts        : USINT;                          // Total config diff part count. SK: Celkovy pocet casti config diffu.

   NhPendingState              : ARRAY[1..40] OF NH_ROOM_STATE;  // Frozen state diff records. SK: Zmrazene zaznamy state diffu.
   NhPendingStateOperation     : ARRAY[1..40] OF USINT;          // Operations of state diff records. SK: Operacie zaznamov state diffu.
   NhPendingStateRoomId        : ARRAY[1..40] OF UDINT;          // Stable IDs of state changes. SK: Stabilne ID state zmien.
   NhPendingStateCount         : USINT;                          // Number of frozen state changes. SK: Pocet zmrazenych state zmien.
   NhPendingStateNext          : USINT;                          // First state change in the next frame. SK: Prva state zmena v dalsom ramci.
   NhPendingStatePart          : USINT;                          // Next state diff part index. SK: Index dalsej casti state diffu.
   NhPendingStateParts         : USINT;                          // Total state diff part count. SK: Celkovy pocet casti state diffu.

   NhSnapshotActive            : BOOL;                           // Frozen snapshot sequence is active. SK: Zmrazena snapshot sekvencia je aktivna.
   NhSnapshotStage             : USINT;                          // 1 config, 2 state, 3 done. SK: 1 config, 2 state, 3 done.
   NhSnapshotNext              : USINT;                          // First snapshot record in the next frame. SK: Prvy snapshot zaznam v dalsom ramci.
   NhSnapshotPart              : USINT;                          // Next snapshot part index. SK: Index dalsej casti snapshotu.
   NhSnapshotParts             : USINT;                          // Part count of the current snapshot section. SK: Pocet casti aktualnej sekcie.
   NhSnapshotCount             : USINT;                          // Number of valid frozen rooms. SK: Pocet platnych miestnosti.
   NhSnapshotConfig            : ARRAY[1..40] OF NH_ROOM_CONFIG; // Frozen config snapshot. SK: Zmrazeny obraz konfiguracie.
   NhSnapshotState             : ARRAY[1..40] OF NH_ROOM_STATE;  // Frozen state snapshot. SK: Zmrazeny obraz stavu.
END_VAR
