// NachHouse API PLC pilot V1.
// The public contract uses native PLCComS PUBLIC_API variables only.
// SK: Verejny kontrakt pouziva iba nativne PUBLIC_API premenne PLCComS.

VAR_GLOBAL CONSTANT
   NH_API_PROTOCOL_VERSION       : UINT := 1;            // Binary protocol version. SK: Verzia binarneho protokolu.
   NH_API_MAGIC                  : DWORD := 16#5041484E;  // ASCII NHAP bytes in little-endian order. SK: Bajty ASCII NHAP v little-endian poradi.
   NH_API_HEADER_SIZE            : UINT := 64;           // Fixed header size in bytes. SK: Pevna velkost hlavicky v bajtoch.
   NH_API_TX_WORD_COUNT          : UINT := 512;          // Number of DWORD words in the shared TX buffer. SK: Pocet DWORD slov spolocneho TX buffera.
   NH_API_RX_WORDS_PER_CLIENT    : UINT := 64;           // DWORD words in one client RX segment. SK: Pocet DWORD slov RX segmentu jedneho klienta.
   NH_API_RX_WORD_COUNT          : UINT := 256;          // Four RX segments of 64 DWORD each. SK: Styri RX segmenty po 64 DWORD.
   NH_API_MAX_CLIENTS            : USINT := 4;           // Maximum concurrently registered clients. SK: Najvacsi pocet sucasne registrovanych klientov.
   NH_API_MAX_ROOMS              : USINT := 40;          // Maximum number of pilot rooms. SK: Najvacsi pocet miestnosti pilotu.

   NH_API_CONFIG_RECORD_SIZE     : UINT := 138;          // Wire config record size. SK: Velkost wire config zaznamu.
   NH_API_STATE_RECORD_SIZE      : UINT := 22;           // Wire state record size including Twilight. SK: Velkost wire state zaznamu vratane Twilight.
   NH_API_CONFIG_DIFF_SIZE       : UINT := 143;          // Operation, RoomId and config record. SK: Operacia, RoomId a config zaznam.
   NH_API_STATE_DIFF_SIZE        : UINT := 27;           // Operation, RoomId and state record. SK: Operacia, RoomId a state zaznam.
   NH_API_CONFIG_PER_FRAME       : USINT := 14;          // Maximum config records in one TX frame. SK: Najviac config zaznamov v jednom TX ramci.
   NH_API_STATE_PER_FRAME        : USINT := 40;          // Maximum state records in one TX frame. SK: Najviac state zaznamov v jednom TX ramci.
   NH_API_CONFIG_DIFF_PER_FRAME  : USINT := 13;          // Maximum config changes in one TX frame. SK: Najviac config zmien v jednom TX ramci.
   NH_API_STATE_DIFF_PER_FRAME   : USINT := 40;          // Maximum state changes in one TX frame. SK: Najviac state zmien v jednom TX ramci.

   NH_API_TX_IDLE                : USINT := 0;            // TX buffer may be built. SK: TX buffer sa moze naplnit.
   NH_API_TX_BUILDING            : USINT := 1;            // PLC is building a TX frame. SK: PLC prave pripravuje TX ramec.
   NH_API_TX_READY               : USINT := 2;            // TX frame is stable and waiting for ACK. SK: TX ramec je stabilny a caka na ACK.

   NH_API_CLIENT_FREE            : USINT := 0;            // Client slot is free. SK: Klientsky slot je volny.
   NH_API_CLIENT_ACTIVE          : USINT := 1;            // Client slot has a valid lease. SK: Klientsky slot ma platny lease.

   NH_API_MSG_SNAPSHOT_REQUEST   : UINT := 1;             // RX full snapshot request. SK: RX poziadavka na kompletny snapshot.
   NH_API_MSG_ADD_ROOM           : UINT := 2;             // RX add-room request. SK: RX poziadavka na pridanie miestnosti.
   NH_API_MSG_DELETE_ROOM        : UINT := 3;             // RX delete-room request. SK: RX poziadavka na zmazanie miestnosti.
   NH_API_MSG_COPY_ROOM          : UINT := 4;             // RX copy-room request. SK: RX poziadavka na kopirovanie miestnosti.
   NH_API_MSG_SET_ROOM_CONFIG     : UINT := 5;             // RX room-config update request. SK: RX poziadavka na zmenu configu.
   NH_API_MSG_SET_ROOM_STATE      : UINT := 6;             // RX test room-state update request. SK: RX testovacia poziadavka na zmenu state.
   NH_API_MSG_CONFIG_SNAPSHOT    : UINT := 101;           // TX config snapshot part. SK: TX cast config snapshotu.
   NH_API_MSG_STATE_SNAPSHOT     : UINT := 102;           // TX state snapshot part. SK: TX cast state snapshotu.
   NH_API_MSG_CONFIG_DIFF        : UINT := 103;           // TX config diff. SK: TX config diff.
   NH_API_MSG_STATE_DIFF         : UINT := 104;           // TX state diff. SK: TX state diff.
   NH_API_MSG_SNAPSHOT_DONE      : UINT := 105;           // TX snapshot transaction completion. SK: TX ukoncenie snapshot transakcie.

   NH_API_SCHEMA_NONE            : UINT := 0;             // Message has no data record. SK: Sprava nema datovy zaznam.
   NH_API_SCHEMA_ROOM_CONFIG     : UINT := 1;             // Room configuration schema. SK: Schema konfiguracie miestnosti.
   NH_API_SCHEMA_ROOM_STATE      : UINT := 2;             // Room dynamic-state schema. SK: Schema dynamickeho stavu miestnosti.
   NH_API_SCHEMA_VERSION         : UINT := 1;             // Version of both room schemas. SK: Verzia oboch room schem.

   NH_API_CHANGE_UPSERT          : USINT := 1;            // Insert or complete record update. SK: Pridanie alebo uplna aktualizacia zaznamu.
   NH_API_CHANGE_DELETE          : USINT := 2;            // Record deletion. SK: Odstranenie zaznamu.

   NH_API_RESULT_NONE            : USINT := 0;            // No result is available yet. SK: Vysledok este neexistuje.
   NH_API_RESULT_OK              : USINT := 1;            // Request succeeded. SK: Poziadavka bola uspesna.
   NH_API_RESULT_BUSY            : USINT := 2;            // Another global transaction is active. SK: Ina globalna transakcia este bezi.
   NH_API_RESULT_BAD_FRAME       : USINT := 3;            // Header, size or CRC is invalid. SK: Hlavicka, velkost alebo CRC su neplatne.
   NH_API_RESULT_NOT_FOUND       : USINT := 4;            // Requested room does not exist. SK: Pozadovana miestnost neexistuje.
   NH_API_RESULT_NO_FREE_SLOT    : USINT := 5;            // No room or client slot is free. SK: Nie je volny room alebo client slot.
   NH_API_RESULT_ALREADY_EXISTS  : USINT := 6;            // RoomId already exists. SK: RoomId uz existuje.
   NH_API_RESULT_INVALID         : USINT := 7;            // Request payload is invalid. SK: Obsah poziadavky nie je platny.
   NH_API_RESULT_UNSUPPORTED     : USINT := 8;            // Message type is unsupported. SK: Typ spravy nie je podporovany.

   NH_API_TEST_NONE              : USINT := 0;            // WebMaker performs no action. SK: WebMaker nevykona ziadnu akciu.
   NH_API_TEST_SET_STATE         : USINT := 1;            // WebMaker changes room state. SK: WebMaker zmeni stav miestnosti.
   NH_API_TEST_ADD_ROOM          : USINT := 2;            // WebMaker adds a room. SK: WebMaker prida miestnost.
   NH_API_TEST_DELETE_ROOM       : USINT := 3;            // WebMaker deletes a room. SK: WebMaker zmaze miestnost.
   NH_API_TEST_COPY_ROOM         : USINT := 4;            // WebMaker copies a room. SK: WebMaker skopiruje miestnost.
   NH_API_TEST_SET_CONFIG        : USINT := 5;            // WebMaker changes room config. SK: WebMaker zmeni config miestnosti.
   NH_API_TEST_REQUEST_SNAPSHOT  : USINT := 6;            // WebMaker starts a broadcast snapshot. SK: WebMaker vyvola broadcast snapshot.
END_VAR

TYPE
   NH_ROOM_CONFIG : STRUCT // Static room configuration transferred in snapshots, diffs and commands. SK: Staticka konfiguracia miestnosti prenasana v snapshotoch, diffoch a prikazoch.
      Used           : BOOL;       // TRUE marks an occupied internal slot. SK: TRUE oznacuje obsadeny interny slot.
      RoomId         : UDINT;      // Stable unique room identifier. SK: Stabilny jedinecny identifikator miestnosti.
      Name           : STRING[64]; // UTF-8 room name, up to 64 bytes. SK: UTF-8 nazov miestnosti, najviac 64 bajtov.
      ProjectName    : STRING[64]; // UTF-8 project name, up to 64 bytes. SK: UTF-8 projektovy nazov, najviac 64 bajtov.
      IconId         : UINT;       // Client icon identifier. SK: Identifikator ikony klienta.
      SortDefault    : UINT;       // Default global order. SK: Predvolene globalne poradie.
   END_STRUCT

   NH_ROOM_STATE : STRUCT // Dynamic room state transferred in snapshots, diffs and commands. SK: Dynamicky stav miestnosti prenasany v snapshotoch, diffoch a prikazoch.
      RoomId         : UDINT;      // Stable ID matching the config record. SK: Stabilne ID zodpovedajuce config zaznamu.
      Temperature    : REAL;       // Temperature in degrees Celsius. SK: Teplota v stupnoch Celzia.
      Humidity       : REAL;       // Relative humidity in percent. SK: Relativna vlhkost v percentach.
      Presence       : BOOL;       // Presence flag. SK: Priznak pritomnosti.
      DayPhase       : UINT;       // Day-phase icon identifier. SK: Identifikator ikony dennej fazy.
      CategoryMask   : DWORD;      // Bit mask of active categories. SK: Bitova maska aktivnych kategorii.
      AlarmLevel     : USINT;      // Alarm level from 0 to 2. SK: Uroven alarmu 0 az 2.
      Online         : BOOL;       // Room data availability. SK: Dostupnost dat miestnosti.
      Twilight       : BOOL;       // Twilight state for the existing room browser. SK: Stav osvetlenia pre existujuci room browser.
   END_STRUCT

   NH_API_INFO : STRUCT // Global protocol, revision and shared TX-buffer handshake information. SK: Globalne informacie protokolu, revizii a handshake spolocneho TX buffera.
      ProtocolVersion : UINT;      // Wire protocol version. SK: Verzia wire protokolu.
      MaxRooms       : USINT;      // Number of available room slots. SK: Pocet dostupnych room slotov.
      MaxClients     : USINT;      // Number of client slots. SK: Pocet klientskych slotov.
      TxWordCount    : UINT;       // TX buffer size in DWORD words. SK: Velkost TX buffera v DWORD.
      RxWordsPerClient : UINT;     // One RX segment size in DWORD words. SK: Velkost jedneho RX segmentu v DWORD.
      ConfigRevision : UDINT;      // Current configuration revision. SK: Aktualna revizia konfiguracie.
      StateRevision  : UDINT;      // Current dynamic-state revision. SK: Aktualna revizia dynamickeho stavu.
      TxPublishedRevision : UDINT; // Commit identifier of the stable TX frame. SK: Commit identifikator stabilneho TX ramca.
      TxByteLength   : UINT;       // Number of valid TX frame bytes. SK: Pocet platnych bajtov TX ramca.
      TxState        : USINT;      // TX buffer state NH_API_TX_*. SK: Stav TX buffera NH_API_TX_*.
      TxRequiredAckMask : BYTE;    // Clients required to acknowledge the current frame. SK: Klienti, ktori musia potvrdit aktualny ramec.
      TxAckMask      : BYTE;       // Clients that already acknowledged the frame. SK: Klienti, ktori uz ramec potvrdili.
      ActiveClientMask : BYTE;     // Mask of valid client leases. SK: Maska platnych klientskych leases.
      LastError      : USINT;      // Last global diagnostic error. SK: Posledna globalna diagnosticka chyba.
   END_STRUCT

   NH_API_CLIENT_SLOT : STRUCT // Registration, liveness, RX commit and result state of one API client. SK: Registracia, zivotnost, RX commit a vysledkovy stav jedneho API klienta.
      RequestedClientId : UDINT;   // Random nonzero ID written by a registering client. SK: Nahodne nenulove ID zapisane klientom pri registracii.
      AssignedClientId : UDINT;    // ID accepted by the PLC for this slot. SK: ID potvrdene PLC pre tento slot.
      HeartbeatCounter : UDINT;    // Client periodically increments the liveness counter. SK: Klient periodicky zvysuje pocitadlo zivota.
      AckTxRevision : UDINT;       // Last TX frame whose CRC was verified. SK: Posledny TX ramec s overenym CRC.
      RxPublishedRevision : UDINT; // RX frame commit number written last by the client. SK: Commit cislo RX ramca zapisane klientom ako posledne.
      RxByteLength   : UINT;       // Valid byte count in the client RX segment. SK: Pocet platnych bajtov v klientovom RX segmente.
      State          : USINT;      // Registration state NH_API_CLIENT_*. SK: Stav registracie NH_API_CLIENT_*.
      ResultCode     : USINT;      // Result of the last accepted request. SK: Vysledok poslednej prijatej poziadavky.
      LastRequestId  : UDINT;      // RequestId belonging to ResultCode. SK: RequestId patriaci k ResultCode.
      ResultConfigRevision : UDINT;// Config revision after request execution. SK: Config revizia po vykonani poziadavky.
      ResultStateRevision : UDINT; // State revision after request execution. SK: State revizia po vykonani poziadavky.
   END_STRUCT

   NH_API_TEST_CONTROL : STRUCT // Direct WebMaker test interface used without a binary client. SK: Priame testovacie rozhranie WebMaker pouzivane bez binarneho klienta.
      Execute         : BOOL;       // WebMaker sets TRUE as the final commit step. SK: WebMaker nastavi TRUE ako posledny commit krok.
      Busy            : BOOL;       // PLC is processing the test action. SK: PLC prave spracovava testovaciu akciu.
      Finished        : BOOL;       // PLC completed the last test action. SK: PLC dokoncilo poslednu testovaciu akciu.
      Action          : USINT;      // Requested NH_API_TEST_* action. SK: Pozadovana akcia NH_API_TEST_*.
      ResultCode      : USINT;      // NH_API_RESULT_* outcome. SK: Vysledok NH_API_RESULT_*.
      RoomId          : UDINT;      // Target room ID. SK: Cielove ID miestnosti.
      SourceRoomId    : UDINT;      // Source ID for copying. SK: Zdrojove ID pri kopirovani.
      Name            : STRING[64]; // New name for add, copy or config update. SK: Novy nazov pre add, copy alebo set config.
      ProjectName     : STRING[64]; // New project name. SK: Novy projektovy nazov.
      IconId          : UINT;       // New room icon. SK: Nova ikona miestnosti.
      Temperature     : REAL;       // Test temperature. SK: Testovacia teplota.
      Humidity        : REAL;       // Test humidity. SK: Testovacia vlhkost.
      Presence        : BOOL;       // Test presence. SK: Testovacia pritomnost.
      DayPhase        : UINT;       // Test day phase. SK: Testovacia faza dna.
      CategoryMask    : DWORD;      // Test category mask. SK: Testovacia maska kategorii.
      AlarmLevel      : USINT;      // Test alarm level. SK: Testovacia uroven alarmu.
      Online          : BOOL;       // Test availability. SK: Testovacia dostupnost.
      Twilight        : BOOL;       // Test twilight state. SK: Testovaci twilight stav.
      ConfigRevision  : UDINT;      // Config revision after the action. SK: Config revizia po akcii.
      StateRevision   : UDINT;      // State revision after the action. SK: State revizia po akcii.
   END_STRUCT
END_TYPE

VAR_GLOBAL
   NH_API_CLIENT_TIMEOUT_MS      : UDINT := 500000;       // Time before an inactive client expires. SK: Cas do vyradenia neaktivneho klienta.


   NhApiInfo       {PUBLIC_API} : NH_API_INFO;                         // Global information and TX handshake. SK: Globalne informacie a TX handshake.
   NhApiClients    {PUBLIC_API} : ARRAY[0..3] OF NH_API_CLIENT_SLOT;   // Registry and handshake for four clients. SK: Registry a handshake styroch klientov.
   NhApiTxBuffer   {PUBLIC_API} : ARRAY[0..511] OF DWORD;              // Stable PLC-to-client message buffer. SK: Stabilny buffer sprav PLC smerom ku klientom.
   NhApiRxBuffer   {PUBLIC_API} : ARRAY[0..255] OF DWORD;              // Four separate client-to-PLC RX segments. SK: Styri oddelene klient-to-PLC RX segmenty.
   NhApiTest       {PUBLIC_API} : NH_API_TEST_CONTROL;                 // Direct WebMaker test control without a binary client. SK: Priamy WebMaker testovaci ovladac bez binarneho klienta.

   NhRoomsConfig                   : ARRAY[1..40] OF NH_ROOM_CONFIG;      // Authoritative PLC test configuration. SK: Autoritativna testovacia konfiguracia PLC.
   NhRoomsState                    : ARRAY[1..40] OF NH_ROOM_STATE;       // Authoritative PLC test state. SK: Autoritativny testovaci stav PLC.
END_VAR

VAR_GLOBAL
   NhApiInitialized                : BOOL;                                  // One-time initialization has completed. SK: Jednorazova inicializacia uz prebehla.
   NhConfigShadow                  : ARRAY[1..40] OF NH_ROOM_CONFIG;      // Last captured config used for diffing. SK: Posledny zachyteny config pre diff.
   NhStateShadow                   : ARRAY[1..40] OF NH_ROOM_STATE;       // Last captured state used for diffing. SK: Posledny zachyteny state pre diff.
   NhPendingConfig                 : ARRAY[1..40] OF NH_ROOM_CONFIG;      // Frozen config records of the current diff. SK: Zmrazene config zaznamy aktualneho diffu.
   NhPendingState                  : ARRAY[1..40] OF NH_ROOM_STATE;       // Frozen state records of the current diff. SK: Zmrazene state zaznamy aktualneho diffu.
   NhPendingOperation              : ARRAY[1..40] OF USINT;                 // Operations of the frozen diff. SK: Operacie zmrazeneho diffu.
   NhPendingRoomId                 : ARRAY[1..40] OF UDINT;                 // Room IDs of frozen diff items. SK: RoomId poloziek zmrazeneho diffu.
   NhPendingKind                   : UINT;                                  // Type of the pending config or state diff. SK: Typ rozpracovaneho config alebo state diffu.
   NhPendingCount                  : USINT;                                 // Number of pending diff items. SK: Pocet poloziek rozpracovaneho diffu.
   NhPendingNext                   : USINT;                                 // Index of the first item in the next frame. SK: Index prvej polozky dalsieho ramca.
   NhPendingPart                   : USINT;                                 // Number of the next diff part. SK: Cislo nasledujucej casti diffu.
   NhPendingParts                  : USINT;                                 // Total number of diff parts. SK: Celkovy pocet casti diffu.
   NhPendingFromRevision           : UDINT;                                // Starting domain revision of the diff. SK: Pociatocna domenova revizia diffu.
   NhPendingToRevision             : UDINT;                                // Ending domain revision of the diff. SK: Konecna domenova revizia diffu.

   NhSnapshotActive                : BOOL;                                  // A config-state-done sequence is active. SK: Prebieha sekvencia config-state-done.
   NhSnapshotTargetClientId        : UDINT;                                // Zero means broadcast, otherwise the target client. SK: Nula znamena broadcast, inak cielovy klient.
   NhSnapshotRequestId             : UDINT;                                // RequestId of the full snapshot. SK: RequestId kompletneho snapshotu.
   NhSnapshotStage                 : USINT;                                 // 1 config, 2 state, 3 done. SK: 1 config, 2 state, 3 done.
   NhSnapshotNext                  : USINT;                                 // First record index of the next part. SK: Index prveho zaznamu dalsej casti.
   NhSnapshotPart                  : USINT;                                 // Number of the next snapshot part. SK: Cislo dalsej casti snapshotu.
   NhSnapshotParts                 : USINT;                                 // Number of parts in the current snapshot section. SK: Pocet casti aktualnej snapshot sekcie.
   NhSnapshotConfig                : ARRAY[1..40] OF NH_ROOM_CONFIG;      // Frozen config portion of the snapshot. SK: Zmrazena config cast snapshotu.
   NhSnapshotState                 : ARRAY[1..40] OF NH_ROOM_STATE;       // Frozen state portion of the snapshot. SK: Zmrazena state cast snapshotu.
   NhSnapshotCount                 : USINT;                                 // Number of valid snapshot rooms. SK: Pocet platnych miestnosti snapshotu.

   NhClientLastHeartbeat           : ARRAY[0..3] OF UDINT;                  // Last processed heartbeat values. SK: Posledne spracovane heartbeat hodnoty.
   NhClientLastAck                 : ARRAY[0..3] OF UDINT;                  // Last processed ACK values. SK: Posledne spracovane ACK hodnoty.
   NhClientLastRx                  : ARRAY[0..3] OF UDINT;                  // Last processed RX commit values. SK: Posledne spracovane RX commit hodnoty.
   NhClientLastActivityMs          : ARRAY[0..3] OF UDINT;                  // System time of the last activity. SK: Systemovy cas poslednej aktivity.
END_VAR
