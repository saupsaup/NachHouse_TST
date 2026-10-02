// State machine, application operations and frame publishing. SK: Stavovy automat, aplikacne operacie a publikovanie ramcov.

FUNCTION NhApiClearRoom : BOOL
   // Clears the configuration and state of one room slot. SK: Vynuluje konfiguraciu a stav jedneho room slotu.
   VAR_INPUT
      Index : USINT; // Internal room slot 1..40. SK: Interny room slot 1..40.
   END_VAR
   NhRoomsConfig[Index].Used := FALSE;
   NhRoomsConfig[Index].RoomId := 0;
   NhRoomsConfig[Index].Name := '';
   NhRoomsConfig[Index].ProjectName := '';
   NhRoomsConfig[Index].IconId := 0;
   NhRoomsConfig[Index].SortDefault := 0;
   NhRoomsState[Index].RoomId := 0;
   NhRoomsState[Index].Temperature := 0.0;
   NhRoomsState[Index].Humidity := 0.0;
   NhRoomsState[Index].Presence := FALSE;
   NhRoomsState[Index].DayPhase := 140;
   NhRoomsState[Index].CategoryMask := 0;
   NhRoomsState[Index].AlarmLevel := 0;
   NhRoomsState[Index].Online := FALSE;
   NhRoomsState[Index].Twilight := FALSE;
   NhApiClearRoom := TRUE;
END_FUNCTION

FUNCTION NhApiInitialize : BOOL
   // Initializes API data, buffers, and state once. SK: Jednorazovo inicializuje data, buffery a stav API.
   VAR
      Index : USINT; // Initialization index. SK: Inicializacny index.
   END_VAR
   NhApiInitialize := NhApiInitialized;
   IF NhApiInitialized THEN
      RETURN;
   END_IF;

   NhApiClearBuffer(Buffer := ADR(NhApiTxBuffer), Length := 2048);
   NhApiClearBuffer(Buffer := ADR(NhApiRxBuffer), Length := 1024);
   FOR Index := 1 TO NH_API_MAX_ROOMS DO
      NhApiClearRoom(Index := Index);
   END_FOR;

   // Thirty deterministic ASCII names are also valid UTF-8. SK: Tridsat deterministickych ASCII nazvov je sucasne platne UTF-8.
   FOR Index := 1 TO 30 DO
      NhRoomsConfig[Index].Used := TRUE;
      NhRoomsConfig[Index].RoomId := USINT_TO_UDINT(Index);
      NhRoomsConfig[Index].ProjectName := 'TEST';
      NhRoomsConfig[Index].IconId := SEL(Index >= 26, 16, 19);
      NhRoomsConfig[Index].SortDefault := USINT_TO_UINT(Index);
      CASE Index OF
         1: NhRoomsConfig[Index].Name := 'Hall 1'; NhRoomsConfig[Index].ProjectName := '1.08';
         2: NhRoomsConfig[Index].Name := 'Kitchen'; NhRoomsConfig[Index].ProjectName := '1.07';
         3: NhRoomsConfig[Index].Name := 'Corridor 1'; NhRoomsConfig[Index].ProjectName := '1.04';
         4: NhRoomsConfig[Index].Name := 'Bathroom 1'; NhRoomsConfig[Index].ProjectName := '1.06';
         5: NhRoomsConfig[Index].Name := 'WC'; NhRoomsConfig[Index].ProjectName := '1.05';
         6: NhRoomsConfig[Index].Name := 'Bedroom'; NhRoomsConfig[Index].ProjectName := '1.09';
         7: NhRoomsConfig[Index].Name := 'Boiler'; NhRoomsConfig[Index].ProjectName := '1.03';
         8: NhRoomsConfig[Index].Name := 'Living room'; NhRoomsConfig[Index].ProjectName := '1.01';
         9: NhRoomsConfig[Index].Name := 'Corridor 1F'; NhRoomsConfig[Index].ProjectName := '1.02';
         10: NhRoomsConfig[Index].Name := 'Room 2.07'; NhRoomsConfig[Index].ProjectName := '2.07';
         11: NhRoomsConfig[Index].Name := 'Kitchen 2F'; NhRoomsConfig[Index].ProjectName := '2.03';
         12: NhRoomsConfig[Index].Name := 'Room 2.06'; NhRoomsConfig[Index].ProjectName := '2.06';
         13: NhRoomsConfig[Index].Name := 'Bathroom 2F'; NhRoomsConfig[Index].ProjectName := '2.05';
         14: NhRoomsConfig[Index].Name := 'Entrance hall'; NhRoomsConfig[Index].ProjectName := '0.01';
         15: NhRoomsConfig[Index].Name := 'Garage'; NhRoomsConfig[Index].ProjectName := '0.02';
         16: NhRoomsConfig[Index].Name := 'Storage'; NhRoomsConfig[Index].ProjectName := '0.03';
         17: NhRoomsConfig[Index].Name := 'Basement corridor'; NhRoomsConfig[Index].ProjectName := '0.04';
         18: NhRoomsConfig[Index].Name := 'Office'; NhRoomsConfig[Index].ProjectName := '1.10';
         19: NhRoomsConfig[Index].Name := 'Wardrobe'; NhRoomsConfig[Index].ProjectName := '1.11';
         20: NhRoomsConfig[Index].Name := 'Fitness'; NhRoomsConfig[Index].ProjectName := '0.06';
         21: NhRoomsConfig[Index].Name := 'Technical'; NhRoomsConfig[Index].ProjectName := '0.07';
         22: NhRoomsConfig[Index].Name := 'Wine room'; NhRoomsConfig[Index].ProjectName := '0.08';
         23: NhRoomsConfig[Index].Name := 'Guest room'; NhRoomsConfig[Index].ProjectName := '2.01';
         24: NhRoomsConfig[Index].Name := 'Children 1'; NhRoomsConfig[Index].ProjectName := '2.02';
         25: NhRoomsConfig[Index].Name := 'Children 2'; NhRoomsConfig[Index].ProjectName := '2.04';
         26: NhRoomsConfig[Index].Name := 'Terrace'; NhRoomsConfig[Index].ProjectName := 'E.01';
         27: NhRoomsConfig[Index].Name := 'Gazebo'; NhRoomsConfig[Index].ProjectName := 'E.02';
         28: NhRoomsConfig[Index].Name := 'Pool'; NhRoomsConfig[Index].ProjectName := 'E.03';
         29: NhRoomsConfig[Index].Name := 'Garden'; NhRoomsConfig[Index].ProjectName := 'E.04';
         30: NhRoomsConfig[Index].Name := 'Sauna'; NhRoomsConfig[Index].ProjectName := '0.09';
      END_CASE;
      NhRoomsState[Index].RoomId := USINT_TO_UDINT(Index);
      NhRoomsState[Index].Temperature := 20.0 + USINT_TO_REAL(Index) * 0.1;
      NhRoomsState[Index].Humidity := 40.0 + USINT_TO_REAL(Index MOD 15);
      NhRoomsState[Index].Presence := (Index MOD 4) = 0;
      CASE Index MOD 4 OF
         0: NhRoomsState[Index].DayPhase := 140;
         1: NhRoomsState[Index].DayPhase := 142;
         2: NhRoomsState[Index].DayPhase := 144;
         3: NhRoomsState[Index].DayPhase := 146;
      END_CASE;
      NhRoomsState[Index].CategoryMask := USINT_TO_DWORD(Index MOD 8);
      NhRoomsState[Index].AlarmLevel := 0;
      NhRoomsState[Index].Online := (Index MOD 3) <> 0;
      NhRoomsState[Index].Twilight := (Index MOD 3) <> 1;
      NhConfigShadow[Index] := NhRoomsConfig[Index];
      NhStateShadow[Index] := NhRoomsState[Index];
   END_FOR;
   FOR Index := 31 TO NH_API_MAX_ROOMS DO
      NhConfigShadow[Index] := NhRoomsConfig[Index];
      NhStateShadow[Index] := NhRoomsState[Index];
   END_FOR;

   NhApiInfo.ProtocolVersion := NH_API_PROTOCOL_VERSION;
   NhApiInfo.MaxRooms := NH_API_MAX_ROOMS;
   NhApiInfo.MaxClients := NH_API_MAX_CLIENTS;
   NhApiInfo.TxWordCount := NH_API_TX_WORD_COUNT;
   NhApiInfo.RxWordsPerClient := NH_API_RX_WORDS_PER_CLIENT;
   NhApiInfo.ConfigRevision := 1;
   NhApiInfo.StateRevision := 1;
   NhApiInfo.TxPublishedRevision := 0;
   NhApiInfo.TxByteLength := 0;
   NhApiInfo.TxState := NH_API_TX_IDLE;
   NhApiInfo.TxRequiredAckMask := 0;
   NhApiInfo.TxAckMask := 0;
   NhApiInfo.ActiveClientMask := 0;
   NhApiInfo.LastError := NH_API_RESULT_NONE;
   FOR Index := 0 TO 3 DO
      NhApiClients[Index].RequestedClientId := 0;
      NhApiClients[Index].AssignedClientId := 0;
      NhApiClients[Index].HeartbeatCounter := 0;
      NhApiClients[Index].AckTxRevision := 0;
      NhApiClients[Index].RxPublishedRevision := 0;
      NhApiClients[Index].RxByteLength := 0;
      NhApiClients[Index].State := NH_API_CLIENT_FREE;
      NhApiClients[Index].ResultCode := NH_API_RESULT_NONE;
      NhApiClients[Index].LastRequestId := 0;
      NhApiClients[Index].ResultConfigRevision := 1;
      NhApiClients[Index].ResultStateRevision := 1;
      NhClientLastActivityMs[Index] := NhApiSystemTimeMs();
   END_FOR;
   NhApiTest.Execute := FALSE;
   NhApiTest.Busy := FALSE;
   NhApiTest.Finished := FALSE;
   NhApiTest.ResultCode := NH_API_RESULT_NONE;
   NhPendingKind := 0;
   NhSnapshotActive := FALSE;
   NhApiInitialized := TRUE;
   NhApiInitialize := TRUE;
END_FUNCTION

FUNCTION NhApiBeginFrame : BOOL
   // Prepares a new TX frame header and clears the TX buffer. SK: Pripravi hlavicku noveho TX ramca a vycisti TX buffer.
   VAR_INPUT
      MessageType : UINT;   // TX message type. SK: Typ TX spravy.
      SchemaId : UINT;      // Record schema identifier. SK: Identifikator record schemy.
      TargetClientId : UDINT;// Zero for broadcast. SK: Nula pre broadcast.
      RequestId : UDINT;    // Original RequestId or zero. SK: Povodny RequestId alebo nula.
      FromRevision : UDINT; // Previous domain revision. SK: Predchadzajuca domenova revizia.
      ToRevision : UDINT;   // New domain revision. SK: Nova domenova revizia.
      RecordCount : UINT;   // Number of records in payload. SK: Pocet zaznamov v payload.
      RecordSize : UINT;    // Fixed size of one record. SK: Pevna velkost jedneho zaznamu.
      PartIndex : UINT;     // One-based part number. SK: Jednotkove cislo casti.
      PartCount : UINT;     // Total number of parts. SK: Celkovy pocet casti.
   END_VAR
   VAR
      Buffer : PTR_TO BYTE; // Byte view of the TX DWORD array. SK: Byte pohlad na TX DWORD pole.
      PayloadSize : UDINT;  // Calculated payload size. SK: Vypocitana velkost payloadu.
      TotalSize : UDINT;    // Header plus payload. SK: Hlavicka plus payload.
      FrameRevision : UDINT;// New frame transport revision. SK: Nova transportna revizia ramca.
   END_VAR
   Buffer := ADR(NhApiTxBuffer);
   NhApiInfo.TxState := NH_API_TX_BUILDING;
   NhApiClearBuffer(Buffer := Buffer, Length := 2048);
   PayloadSize := UINT_TO_UDINT(RecordCount) * UINT_TO_UDINT(RecordSize);
   TotalSize := UINT_TO_UDINT(NH_API_HEADER_SIZE) + PayloadSize;
   FrameRevision := NhApiNextRevision(Current := NhApiInfo.TxPublishedRevision);
   NhApiWriteU32(Buffer := Buffer, Offset := 0, Value := DWORD_TO_UDINT(NH_API_MAGIC));
   NhApiWriteU16(Buffer := Buffer, Offset := 4, Value := NH_API_PROTOCOL_VERSION);
   NhApiWriteU16(Buffer := Buffer, Offset := 6, Value := NH_API_HEADER_SIZE);
   NhApiWriteU16(Buffer := Buffer, Offset := 8, Value := MessageType);
   NhApiWriteU16(Buffer := Buffer, Offset := 10, Value := SchemaId);
   NhApiWriteU16(Buffer := Buffer, Offset := 12, Value := NH_API_SCHEMA_VERSION);
   NhApiWriteU16(Buffer := Buffer, Offset := 14, Value := 0);
   NhApiWriteU32(Buffer := Buffer, Offset := 16, Value := 0);
   NhApiWriteU32(Buffer := Buffer, Offset := 20, Value := RequestId);
   NhApiWriteU32(Buffer := Buffer, Offset := 24, Value := FrameRevision);
   NhApiWriteU32(Buffer := Buffer, Offset := 28, Value := FromRevision);
   NhApiWriteU32(Buffer := Buffer, Offset := 32, Value := ToRevision);
   NhApiWriteU16(Buffer := Buffer, Offset := 36, Value := RecordCount);
   NhApiWriteU16(Buffer := Buffer, Offset := 38, Value := RecordSize);
   NhApiWriteU16(Buffer := Buffer, Offset := 40, Value := PartIndex);
   NhApiWriteU16(Buffer := Buffer, Offset := 42, Value := PartCount);
   NhApiWriteU32(Buffer := Buffer, Offset := 44, Value := PayloadSize);
   NhApiWriteU32(Buffer := Buffer, Offset := 48, Value := TargetClientId);
   NhApiWriteU16(Buffer := Buffer, Offset := 52, Value := USINT_TO_UINT(NH_API_RESULT_OK));
   NhApiWriteU16(Buffer := Buffer, Offset := 54, Value := 0);
   NhApiWriteU32(Buffer := Buffer, Offset := 56, Value := TotalSize);
   NhApiWriteU32(Buffer := Buffer, Offset := 60, Value := 0);
   NhApiInfo.TxByteLength := UDINT_TO_UINT(TotalSize);
   NhApiBeginFrame := TRUE;
END_FUNCTION

FUNCTION NhApiPublishFrame : BOOL
   // Adds CRC and atomically publishes the prepared TX frame. SK: Doplni CRC a atomicky publikuje pripraveny TX ramec.
   VAR
      Buffer : PTR_TO BYTE; // Byte view of the TX DWORD array. SK: Byte pohlad na TX DWORD pole.
      Crc : DWORD;          // CRC32 of the complete valid frame. SK: CRC32 celeho platneho ramca.
   END_VAR
   Buffer := ADR(NhApiTxBuffer);
   Crc := NhApiFrameCrc32(Buffer := Buffer, Length := NhApiInfo.TxByteLength);
   NhApiWriteU32(Buffer := Buffer, Offset := 60, Value := DWORD_TO_UDINT(Crc));
   NhApiInfo.TxPublishedRevision := NhApiReadU32(Buffer := Buffer, Offset := 24);
   NhApiInfo.TxRequiredAckMask := NhApiInfo.ActiveClientMask;
   NhApiInfo.TxAckMask := 0;
   NhApiInfo.TxState := NH_API_TX_READY;
   NhApiPublishFrame := TRUE;
END_FUNCTION

FUNCTION NhApiStartSnapshot : BOOL
   // Freezes current room data and starts the snapshot sequence. SK: Zmrazi aktualne room data a spusti sekvenciu snapshotu.
   VAR_INPUT
      TargetClientId : UDINT; // Zero for a WebMaker broadcast. SK: Nula pre WebMaker broadcast.
      RequestId : UDINT;      // Request identifier. SK: Identifikator poziadavky.
   END_VAR
   VAR
      Index : USINT;          // Source room slot. SK: Zdrojovy room slot.
   END_VAR
   NhApiStartSnapshot := FALSE;
   IF NhSnapshotActive OR (NhPendingKind <> 0) OR (NhApiInfo.TxState <> NH_API_TX_IDLE) THEN
      RETURN;
   END_IF;
   NhSnapshotCount := 0;
   FOR Index := 1 TO NH_API_MAX_ROOMS DO
      IF NhRoomsConfig[Index].Used THEN
         NhSnapshotCount := NhSnapshotCount + 1;
         NhSnapshotConfig[NhSnapshotCount] := NhRoomsConfig[Index];
         NhSnapshotState[NhSnapshotCount] := NhRoomsState[Index];
      END_IF;
   END_FOR;
   NhSnapshotActive := TRUE;
   NhSnapshotTargetClientId := TargetClientId;
   NhSnapshotRequestId := RequestId;
   NhSnapshotStage := 1;
   NhSnapshotNext := 1;
   NhSnapshotPart := 1;
   NhSnapshotParts := (NhSnapshotCount + NH_API_CONFIG_PER_FRAME - 1) / NH_API_CONFIG_PER_FRAME;
   IF NhSnapshotParts = 0 THEN
      NhSnapshotParts := 1;
   END_IF;
   NhApiStartSnapshot := TRUE;
END_FUNCTION

FUNCTION NhApiPublishSnapshotPart : BOOL
   // Builds and publishes one part of the active snapshot. SK: Vytvori a publikuje jednu cast rozpracovaneho snapshotu.
   VAR
      Buffer : PTR_TO BYTE; // Byte view of the TX buffer. SK: Byte pohlad na TX buffer.
      Count : USINT;        // Number of records in this part. SK: Pocet zaznamov tejto casti.
      Index : USINT;        // Local record index. SK: Lokalny index zaznamu.
      Source : USINT;       // Index in the frozen snapshot. SK: Index v zmrazenom snapshote.
      Offset : UINT;        // Record byte offset. SK: Byte offset zaznamu.
   END_VAR
   NhApiPublishSnapshotPart := FALSE;
   IF NOT NhSnapshotActive OR (NhApiInfo.TxState <> NH_API_TX_IDLE) THEN
      RETURN;
   END_IF;
   Buffer := ADR(NhApiTxBuffer);
   IF NhSnapshotStage = 1 THEN
      Count := NH_API_CONFIG_PER_FRAME;
      IF (NhSnapshotNext + Count - 1) > NhSnapshotCount THEN
         Count := NhSnapshotCount - NhSnapshotNext + 1;
      END_IF;
      NhApiBeginFrame(MessageType := NH_API_MSG_CONFIG_SNAPSHOT, SchemaId := NH_API_SCHEMA_ROOM_CONFIG,
         TargetClientId := NhSnapshotTargetClientId, RequestId := NhSnapshotRequestId,
         FromRevision := 0, ToRevision := NhApiInfo.ConfigRevision, RecordCount := USINT_TO_UINT(Count),
         RecordSize := NH_API_CONFIG_RECORD_SIZE, PartIndex := USINT_TO_UINT(NhSnapshotPart),
         PartCount := USINT_TO_UINT(NhSnapshotParts));
      FOR Index := 0 TO Count - 1 DO
         Source := NhSnapshotNext + Index;
         Offset := NH_API_HEADER_SIZE + USINT_TO_UINT(Index) * NH_API_CONFIG_RECORD_SIZE;
         NhApiWriteConfigRecord(Buffer := Buffer, Offset := Offset, Record := NhSnapshotConfig[Source]);
      END_FOR;
      NhSnapshotNext := NhSnapshotNext + Count;
      NhSnapshotPart := NhSnapshotPart + 1;
      IF NhSnapshotNext > NhSnapshotCount THEN
         NhSnapshotStage := 2;
         NhSnapshotNext := 1;
         NhSnapshotPart := 1;
         NhSnapshotParts := (NhSnapshotCount + NH_API_STATE_PER_FRAME - 1) / NH_API_STATE_PER_FRAME;
         IF NhSnapshotParts = 0 THEN NhSnapshotParts := 1; END_IF;
      END_IF;
   ELSIF NhSnapshotStage = 2 THEN
      Count := NH_API_STATE_PER_FRAME;
      IF (NhSnapshotNext + Count - 1) > NhSnapshotCount THEN
         Count := NhSnapshotCount - NhSnapshotNext + 1;
      END_IF;
      NhApiBeginFrame(MessageType := NH_API_MSG_STATE_SNAPSHOT, SchemaId := NH_API_SCHEMA_ROOM_STATE,
         TargetClientId := NhSnapshotTargetClientId, RequestId := NhSnapshotRequestId,
         FromRevision := 0, ToRevision := NhApiInfo.StateRevision, RecordCount := USINT_TO_UINT(Count),
         RecordSize := NH_API_STATE_RECORD_SIZE, PartIndex := USINT_TO_UINT(NhSnapshotPart),
         PartCount := USINT_TO_UINT(NhSnapshotParts));
      FOR Index := 0 TO Count - 1 DO
         Source := NhSnapshotNext + Index;
         Offset := NH_API_HEADER_SIZE + USINT_TO_UINT(Index) * NH_API_STATE_RECORD_SIZE;
         NhApiWriteStateRecord(Buffer := Buffer, Offset := Offset, Record := NhSnapshotState[Source]);
      END_FOR;
      NhSnapshotNext := NhSnapshotNext + Count;
      NhSnapshotPart := NhSnapshotPart + 1;
      IF NhSnapshotNext > NhSnapshotCount THEN
         NhSnapshotStage := 3;
      END_IF;
   ELSIF NhSnapshotStage = 3 THEN
      NhApiBeginFrame(MessageType := NH_API_MSG_SNAPSHOT_DONE, SchemaId := NH_API_SCHEMA_NONE,
         TargetClientId := NhSnapshotTargetClientId, RequestId := NhSnapshotRequestId,
         FromRevision := NhApiInfo.ConfigRevision, ToRevision := NhApiInfo.StateRevision,
         RecordCount := 0, RecordSize := 0, PartIndex := 1, PartCount := 1);
      NhSnapshotStage := 4;
   ELSE
      NhSnapshotActive := FALSE;
      RETURN;
   END_IF;
   NhApiPublishFrame();
   NhApiPublishSnapshotPart := TRUE;
END_FUNCTION

FUNCTION NhApiCaptureConfigDiff : BOOL
   // Captures configuration changes into a frozen pending diff. SK: Zachyti konfiguracne zmeny a zmrazi ich do pending diffu.
   VAR
      Index : USINT; // Room slot. SK: Room slot.
   END_VAR
   NhApiCaptureConfigDiff := FALSE;
   NhPendingCount := 0;
   FOR Index := 1 TO NH_API_MAX_ROOMS DO
      IF NOT NhApiConfigEqual(A := NhRoomsConfig[Index], B := NhConfigShadow[Index]) THEN
         NhPendingCount := NhPendingCount + 1;
         IF NhRoomsConfig[Index].Used THEN
            NhPendingOperation[NhPendingCount] := NH_API_CHANGE_UPSERT;
            NhPendingRoomId[NhPendingCount] := NhRoomsConfig[Index].RoomId;
            NhPendingConfig[NhPendingCount] := NhRoomsConfig[Index];
         ELSE
            NhPendingOperation[NhPendingCount] := NH_API_CHANGE_DELETE;
            NhPendingRoomId[NhPendingCount] := NhConfigShadow[Index].RoomId;
            NhPendingConfig[NhPendingCount] := NhRoomsConfig[Index];
         END_IF;
         NhConfigShadow[Index] := NhRoomsConfig[Index];
      END_IF;
   END_FOR;
   IF NhPendingCount > 0 THEN
      NhPendingKind := NH_API_MSG_CONFIG_DIFF;
      NhPendingFromRevision := NhApiInfo.ConfigRevision;
      NhApiInfo.ConfigRevision := NhApiNextRevision(Current := NhApiInfo.ConfigRevision);
      NhPendingToRevision := NhApiInfo.ConfigRevision;
      NhPendingNext := 1;
      NhPendingPart := 1;
      NhPendingParts := (NhPendingCount + NH_API_CONFIG_DIFF_PER_FRAME - 1) / NH_API_CONFIG_DIFF_PER_FRAME;
      NhApiCaptureConfigDiff := TRUE;
   END_IF;
END_FUNCTION

FUNCTION NhApiCaptureStateDiff : BOOL
   // Captures state changes into a frozen pending diff. SK: Zachyti stavove zmeny a zmrazi ich do pending diffu.
   VAR
      Index : USINT; // Room slot. SK: Room slot.
   END_VAR
   NhApiCaptureStateDiff := FALSE;
   NhPendingCount := 0;
   FOR Index := 1 TO NH_API_MAX_ROOMS DO
      IF NOT NhApiStateEqual(A := NhRoomsState[Index], B := NhStateShadow[Index]) THEN
         NhPendingCount := NhPendingCount + 1;
         IF NhRoomsConfig[Index].Used THEN
            NhPendingOperation[NhPendingCount] := NH_API_CHANGE_UPSERT;
            NhPendingRoomId[NhPendingCount] := NhRoomsState[Index].RoomId;
            NhPendingState[NhPendingCount] := NhRoomsState[Index];
         ELSE
            NhPendingOperation[NhPendingCount] := NH_API_CHANGE_DELETE;
            NhPendingRoomId[NhPendingCount] := NhStateShadow[Index].RoomId;
            NhPendingState[NhPendingCount] := NhRoomsState[Index];
         END_IF;
         NhStateShadow[Index] := NhRoomsState[Index];
      END_IF;
   END_FOR;
   IF NhPendingCount > 0 THEN
      NhPendingKind := NH_API_MSG_STATE_DIFF;
      NhPendingFromRevision := NhApiInfo.StateRevision;
      NhApiInfo.StateRevision := NhApiNextRevision(Current := NhApiInfo.StateRevision);
      NhPendingToRevision := NhApiInfo.StateRevision;
      NhPendingNext := 1;
      NhPendingPart := 1;
      NhPendingParts := (NhPendingCount + NH_API_STATE_DIFF_PER_FRAME - 1) / NH_API_STATE_DIFF_PER_FRAME;
      NhApiCaptureStateDiff := TRUE;
   END_IF;
END_FUNCTION


FUNCTION NhApiPublishPendingDiff : BOOL
   // Builds and publishes one part of the frozen diff. SK: Vytvori a publikuje jednu cast zmrazeneho diffu.
   // The frame contains only one schema and one diff section. SK: Ramec obsahuje iba jednu schemu a jednu diff sekciu.
   VAR
      Buffer : PTR_TO BYTE; // Byte view of the TX buffer. SK: Byte pohlad na TX buffer.
      Count : USINT;        // Number of changes in this part. SK: Pocet zmien tejto casti.
      Index : USINT;        // Local change index. SK: Lokalny index zmeny.
      Source : USINT;       // Frozen change index. SK: Index zmrazenej zmeny.
      Offset : UINT;        // Change byte offset. SK: Byte offset zmeny.
   END_VAR
   NhApiPublishPendingDiff := FALSE;
   IF (NhPendingKind = 0) OR (NhApiInfo.TxState <> NH_API_TX_IDLE) THEN RETURN; END_IF;
   Buffer := ADR(NhApiTxBuffer);
   IF NhPendingKind = NH_API_MSG_CONFIG_DIFF THEN
      Count := NH_API_CONFIG_DIFF_PER_FRAME;
      IF (NhPendingNext + Count - 1) > NhPendingCount THEN Count := NhPendingCount - NhPendingNext + 1; END_IF;
      NhApiBeginFrame(MessageType := NH_API_MSG_CONFIG_DIFF, SchemaId := NH_API_SCHEMA_ROOM_CONFIG,
         TargetClientId := 0, RequestId := 0, FromRevision := NhPendingFromRevision,
         ToRevision := NhPendingToRevision, RecordCount := USINT_TO_UINT(Count),
         RecordSize := NH_API_CONFIG_DIFF_SIZE, PartIndex := USINT_TO_UINT(NhPendingPart),
         PartCount := USINT_TO_UINT(NhPendingParts));
      FOR Index := 0 TO Count - 1 DO
         Source := NhPendingNext + Index;
         Offset := NH_API_HEADER_SIZE + USINT_TO_UINT(Index) * NH_API_CONFIG_DIFF_SIZE;
         NhApiWriteByte(Buffer := Buffer, Offset := Offset, Value := USINT_TO_BYTE(NhPendingOperation[Source]));
         NhApiWriteU32(Buffer := Buffer, Offset := Offset + 1, Value := NhPendingRoomId[Source]);
         NhApiWriteConfigRecord(Buffer := Buffer, Offset := Offset + 5, Record := NhPendingConfig[Source]);
      END_FOR;
   ELSE
      Count := NH_API_STATE_DIFF_PER_FRAME;
      IF (NhPendingNext + Count - 1) > NhPendingCount THEN Count := NhPendingCount - NhPendingNext + 1; END_IF;
      NhApiBeginFrame(MessageType := NH_API_MSG_STATE_DIFF, SchemaId := NH_API_SCHEMA_ROOM_STATE,
         TargetClientId := 0, RequestId := 0, FromRevision := NhPendingFromRevision,
         ToRevision := NhPendingToRevision, RecordCount := USINT_TO_UINT(Count),
         RecordSize := NH_API_STATE_DIFF_SIZE, PartIndex := USINT_TO_UINT(NhPendingPart),
         PartCount := USINT_TO_UINT(NhPendingParts));
      FOR Index := 0 TO Count - 1 DO
         Source := NhPendingNext + Index;
         Offset := NH_API_HEADER_SIZE + USINT_TO_UINT(Index) * NH_API_STATE_DIFF_SIZE;
         NhApiWriteByte(Buffer := Buffer, Offset := Offset, Value := USINT_TO_BYTE(NhPendingOperation[Source]));
         NhApiWriteU32(Buffer := Buffer, Offset := Offset + 1, Value := NhPendingRoomId[Source]);
         NhApiWriteStateRecord(Buffer := Buffer, Offset := Offset + 5, Record := NhPendingState[Source]);
      END_FOR;
   END_IF;
   NhPendingNext := NhPendingNext + Count;
   NhPendingPart := NhPendingPart + 1;
   IF NhPendingNext > NhPendingCount THEN NhPendingKind := 0; END_IF;
   NhApiPublishFrame();
   NhApiPublishPendingDiff := TRUE;
END_FUNCTION

FUNCTION NhApiApplyAdd : USINT
   // Adds a new room to the first free slot. SK: Prida novu miestnost do prveho volneho slotu.
   VAR_INPUT
      Record : NH_ROOM_CONFIG; // New configuration. SK: Nova konfiguracia.
   END_VAR
   VAR
      Slot : USINT;              // Free internal slot. SK: Volny interny slot.
   END_VAR
   IF (Record.RoomId = 0) OR (LEN(Record.Name) = 0) THEN NhApiApplyAdd := NH_API_RESULT_INVALID; RETURN; END_IF;
   IF NhApiFindRoom(RoomId := Record.RoomId) <> 0 THEN NhApiApplyAdd := NH_API_RESULT_ALREADY_EXISTS; RETURN; END_IF;
   Slot := NhApiFindFreeRoom();
   IF Slot = 0 THEN NhApiApplyAdd := NH_API_RESULT_NO_FREE_SLOT; RETURN; END_IF;
   NhRoomsConfig[Slot] := Record;
   NhRoomsConfig[Slot].Used := TRUE;
   IF NhRoomsConfig[Slot].IconId = 0 THEN NhRoomsConfig[Slot].IconId := 16; END_IF;
   IF NhRoomsConfig[Slot].SortDefault = 0 THEN NhRoomsConfig[Slot].SortDefault := USINT_TO_UINT(Slot); END_IF;
   NhRoomsState[Slot].RoomId := Record.RoomId;
   NhRoomsState[Slot].Temperature := 20.0;
   NhRoomsState[Slot].Humidity := 40.0;
   NhRoomsState[Slot].Presence := FALSE;
   NhRoomsState[Slot].DayPhase := 140;
   NhRoomsState[Slot].CategoryMask := 0;
   NhRoomsState[Slot].AlarmLevel := 0;
   NhRoomsState[Slot].Online := TRUE;
   NhRoomsState[Slot].Twilight := FALSE;
   NhApiApplyAdd := NH_API_RESULT_OK;
END_FUNCTION

FUNCTION NhApiApplyDelete : USINT
   // Deletes a room by its stable ID. SK: Odstrani miestnost podla jej stabilneho ID.
   VAR_INPUT
      RoomId : UDINT;             // ID of the room to delete. SK: ID mazanej miestnosti.
   END_VAR
   VAR
      Slot : USINT;               // Located internal slot. SK: Najdeny interny slot.
   END_VAR
   Slot := NhApiFindRoom(RoomId := RoomId);
   IF Slot = 0 THEN NhApiApplyDelete := NH_API_RESULT_NOT_FOUND; RETURN; END_IF;
   NhApiClearRoom(Index := Slot);
   NhApiApplyDelete := NH_API_RESULT_OK;
END_FUNCTION

FUNCTION NhApiApplyConfig : USINT
   // Replaces the configuration of an existing room. SK: Nahradi konfiguraciu existujucej miestnosti.
   VAR_INPUT
      Record : NH_ROOM_CONFIG;  // Complete new configuration. SK: Uplna nova konfiguracia.
   END_VAR
   VAR
      Slot : USINT;               // Located internal slot. SK: Najdeny interny slot.
   END_VAR
   Slot := NhApiFindRoom(RoomId := Record.RoomId);
   IF Slot = 0 THEN NhApiApplyConfig := NH_API_RESULT_NOT_FOUND; RETURN; END_IF;
   IF LEN(Record.Name) = 0 THEN NhApiApplyConfig := NH_API_RESULT_INVALID; RETURN; END_IF;
   NhRoomsConfig[Slot] := Record;
   NhRoomsConfig[Slot].Used := TRUE;
   NhApiApplyConfig := NH_API_RESULT_OK;
END_FUNCTION

FUNCTION NhApiApplyState : USINT
   // Replaces the dynamic state of an existing room. SK: Nahradi dynamicky stav existujucej miestnosti.
   VAR_INPUT
      Record : NH_ROOM_STATE;   // Complete new dynamic state. SK: Uplny novy dynamicky stav.
   END_VAR
   VAR
      Slot : USINT;               // Located internal slot. SK: Najdeny interny slot.
   END_VAR
   Slot := NhApiFindRoom(RoomId := Record.RoomId);
   IF Slot = 0 THEN NhApiApplyState := NH_API_RESULT_NOT_FOUND; RETURN; END_IF;
   IF (Record.Temperature < -50.0) OR (Record.Temperature > 100.0) OR
      (Record.Humidity < 0.0) OR (Record.Humidity > 100.0) OR (Record.AlarmLevel > 2) THEN
      NhApiApplyState := NH_API_RESULT_INVALID; RETURN;
   END_IF;
   NhRoomsState[Slot] := Record;
   NhApiApplyState := NH_API_RESULT_OK;
END_FUNCTION

FUNCTION NhApiApplyCopy : USINT
   // Creates a new room by copying an existing one. SK: Vytvori novu miestnost skopirovanim existujucej.
   VAR_INPUT
      SourceRoomId : UDINT;       // Source room ID. SK: ID zdrojovej miestnosti.
      Target       : NH_ROOM_CONFIG; // Target ID and optional new config fields. SK: Cielove ID a volitelne nove config polia.
   END_VAR
   VAR
      SourceSlot : USINT;         // Source internal slot. SK: Zdrojovy interny slot.
      TargetSlot : USINT;         // Target free slot. SK: Cielovy volny slot.
   END_VAR
   SourceSlot := NhApiFindRoom(RoomId := SourceRoomId);
   IF SourceSlot = 0 THEN NhApiApplyCopy := NH_API_RESULT_NOT_FOUND; RETURN; END_IF;
   IF (Target.RoomId = 0) OR (NhApiFindRoom(RoomId := Target.RoomId) <> 0) THEN NhApiApplyCopy := NH_API_RESULT_ALREADY_EXISTS; RETURN; END_IF;
   TargetSlot := NhApiFindFreeRoom();
   IF TargetSlot = 0 THEN NhApiApplyCopy := NH_API_RESULT_NO_FREE_SLOT; RETURN; END_IF;
   NhRoomsConfig[TargetSlot] := NhRoomsConfig[SourceSlot];
   NhRoomsConfig[TargetSlot].RoomId := Target.RoomId;
   NhRoomsConfig[TargetSlot].SortDefault := USINT_TO_UINT(TargetSlot);
   IF LEN(Target.Name) > 0 THEN NhRoomsConfig[TargetSlot].Name := Target.Name; END_IF;
   IF LEN(Target.ProjectName) > 0 THEN NhRoomsConfig[TargetSlot].ProjectName := Target.ProjectName; END_IF;
   IF Target.IconId > 0 THEN NhRoomsConfig[TargetSlot].IconId := Target.IconId; END_IF;
   NhRoomsState[TargetSlot] := NhRoomsState[SourceSlot];
   NhRoomsState[TargetSlot].RoomId := Target.RoomId;
   NhApiApplyCopy := NH_API_RESULT_OK;
END_FUNCTION

FUNCTION NhApiProcessClients : BOOL
   // Maintains the client registry, timeouts, and TX acknowledgements. SK: Udrzuje registry klientov, timeouty a potvrdenia TX ramca.
   VAR
      Index : USINT;              // Client slot. SK: Klientsky slot.
      NowMs : UDINT;              // System millisecond time. SK: Systemovy milisekundovy cas.
      BitMask : BYTE;             // Bit belonging to the client. SK: Bit prisluchajuci klientovi.
      Activity : BOOL;            // Client changed heartbeat, ACK or RX. SK: Klient zmenil heartbeat, ACK alebo RX.
   END_VAR
   NowMs := NhApiSystemTimeMs();
   NhApiInfo.ActiveClientMask := 0;
   NhApiInfo.TxAckMask := 0;
   FOR Index := 0 TO 3 DO
      BitMask := SHL(BYTE#1, USINT_TO_UINT(Index));
      IF NhApiClients[Index].State = NH_API_CLIENT_FREE THEN
         IF NhApiClients[Index].RequestedClientId <> 0 THEN
            NhApiClients[Index].AssignedClientId := NhApiClients[Index].RequestedClientId;
            NhApiClients[Index].State := NH_API_CLIENT_ACTIVE;
            NhClientLastHeartbeat[Index] := NhApiClients[Index].HeartbeatCounter;
            NhClientLastAck[Index] := NhApiClients[Index].AckTxRevision;
            NhClientLastRx[Index] := NhApiClients[Index].RxPublishedRevision;
            NhClientLastActivityMs[Index] := NowMs;
         END_IF;
      ELSE
         Activity := (NhApiClients[Index].HeartbeatCounter <> NhClientLastHeartbeat[Index]) OR
            (NhApiClients[Index].AckTxRevision <> NhClientLastAck[Index]) OR
            (NhApiClients[Index].RxPublishedRevision <> NhClientLastRx[Index]);
         IF Activity THEN
            NhClientLastHeartbeat[Index] := NhApiClients[Index].HeartbeatCounter;
            NhClientLastAck[Index] := NhApiClients[Index].AckTxRevision;
            NhClientLastActivityMs[Index] := NowMs;
         END_IF;
         IF (NhApiClients[Index].RequestedClientId = 0) OR
            ((NowMs - NhClientLastActivityMs[Index]) > NH_API_CLIENT_TIMEOUT_MS) THEN
            NhApiClients[Index].RequestedClientId := 0;
            NhApiClients[Index].AssignedClientId := 0;
            NhApiClients[Index].State := NH_API_CLIENT_FREE;
            NhApiClients[Index].ResultCode := NH_API_RESULT_NONE;
         END_IF;
      END_IF;
      IF NhApiClients[Index].State = NH_API_CLIENT_ACTIVE THEN
         NhApiInfo.ActiveClientMask := NhApiInfo.ActiveClientMask OR BitMask;
         IF NhApiClients[Index].AckTxRevision = NhApiInfo.TxPublishedRevision THEN
            NhApiInfo.TxAckMask := NhApiInfo.TxAckMask OR BitMask;
         END_IF;
      END_IF;
   END_FOR;
   IF NhApiInfo.TxState = NH_API_TX_READY THEN
      NhApiInfo.TxRequiredAckMask := NhApiInfo.TxRequiredAckMask AND NhApiInfo.ActiveClientMask;
      IF (NhApiInfo.TxAckMask AND NhApiInfo.TxRequiredAckMask) = NhApiInfo.TxRequiredAckMask THEN
         NhApiInfo.TxState := NH_API_TX_IDLE;
         NhApiInfo.TxRequiredAckMask := 0;
      END_IF;
   END_IF;
   NhApiProcessClients := TRUE;
END_FUNCTION

FUNCTION NhApiProcessOneRx : BOOL
   // Validates and processes at most one new client RX request. SK: Overi a spracuje najviac jednu novu klientsku RX poziadavku.
   VAR
      Index : USINT;              // Client slot. SK: Klientsky slot.
      BaseWord : UINT;            // First DWORD of the client RX segment. SK: Prvy DWORD klientovho RX segmentu.
      Buffer : PTR_TO BYTE;       // Byte view of the RX segment. SK: Byte pohlad na RX segment.
      Length : UINT;              // Declared RX frame size. SK: Deklarovana velkost RX ramca.
      MessageType : UINT;         // RX request type. SK: Typ RX poziadavky.
      ClientId : UDINT;           // ClientId from the header. SK: ClientId z hlavicky.
      RequestId : UDINT;          // RequestId from the header. SK: RequestId z hlavicky.
      ExpectedCrc : DWORD;        // CRC written by the client. SK: CRC zapisane klientom.
      ActualCrc : DWORD;          // CRC calculated by the PLC. SK: CRC vypocitane PLC.
      Result : USINT;             // Executed operation result. SK: Vysledok vykonanej operacie.
      ConfigRecord : NH_ROOM_CONFIG; // Decoded config record. SK: Dekodovany config zaznam.
      StateRecord : NH_ROOM_STATE;   // Decoded state record. SK: Dekodovany state zaznam.
      SourceRoomId : UDINT;       // Source ID for copy command. SK: Zdrojove ID prikazu copy.
   END_VAR
   NhApiProcessOneRx := FALSE;
   IF (NhApiInfo.TxState <> NH_API_TX_IDLE) OR NhSnapshotActive OR (NhPendingKind <> 0) THEN RETURN; END_IF;
   FOR Index := 0 TO 3 DO
      IF (NhApiClients[Index].State = NH_API_CLIENT_ACTIVE) AND
         (NhApiClients[Index].RxPublishedRevision <> NhClientLastRx[Index]) THEN
         BaseWord := USINT_TO_UINT(Index) * NH_API_RX_WORDS_PER_CLIENT;
         Buffer := ADR(NhApiRxBuffer[BaseWord]);
         Length := NhApiClients[Index].RxByteLength;
         Result := NH_API_RESULT_BAD_FRAME;
         RequestId := 0;
         IF (Length >= NH_API_HEADER_SIZE) AND (Length <= 256) AND
            (NhApiReadU32(Buffer := Buffer, Offset := 0) = DWORD_TO_UDINT(NH_API_MAGIC)) AND
            (NhApiReadU16(Buffer := Buffer, Offset := 4) = NH_API_PROTOCOL_VERSION) AND
            (NhApiReadU16(Buffer := Buffer, Offset := 6) = NH_API_HEADER_SIZE) AND
            (NhApiReadU32(Buffer := Buffer, Offset := 24) = NhApiClients[Index].RxPublishedRevision) AND
            ((NhApiReadU32(Buffer := Buffer, Offset := 44) + UINT_TO_UDINT(NH_API_HEADER_SIZE)) = UINT_TO_UDINT(Length)) AND
            (NhApiReadU32(Buffer := Buffer, Offset := 56) = UINT_TO_UDINT(Length)) THEN
            ExpectedCrc := UDINT_TO_DWORD(NhApiReadU32(Buffer := Buffer, Offset := 60));
            ActualCrc := NhApiFrameCrc32(Buffer := Buffer, Length := Length);
            ClientId := NhApiReadU32(Buffer := Buffer, Offset := 16);
            RequestId := NhApiReadU32(Buffer := Buffer, Offset := 20);
            MessageType := NhApiReadU16(Buffer := Buffer, Offset := 8);
            IF (ExpectedCrc = ActualCrc) AND (ClientId = NhApiClients[Index].AssignedClientId) AND (RequestId <> 0) THEN
               IF RequestId = NhApiClients[Index].LastRequestId THEN
                  Result := NhApiClients[Index].ResultCode;
               ELSE
                  CASE MessageType OF
                     NH_API_MSG_SNAPSHOT_REQUEST:
                        IF NhApiStartSnapshot(TargetClientId := ClientId, RequestId := RequestId) THEN Result := NH_API_RESULT_OK; ELSE Result := NH_API_RESULT_BUSY; END_IF;
                     NH_API_MSG_ADD_ROOM:
                        NhApiReadConfigRecord(Buffer := Buffer, Offset := NH_API_HEADER_SIZE, Record := ConfigRecord);
                        Result := NhApiApplyAdd(Record := ConfigRecord);
                     NH_API_MSG_DELETE_ROOM:
                        Result := NhApiApplyDelete(RoomId := NhApiReadU32(Buffer := Buffer, Offset := NH_API_HEADER_SIZE));
                     NH_API_MSG_COPY_ROOM:
                        SourceRoomId := NhApiReadU32(Buffer := Buffer, Offset := NH_API_HEADER_SIZE);
                        NhApiReadConfigRecord(Buffer := Buffer, Offset := NH_API_HEADER_SIZE + 4, Record := ConfigRecord);
                        Result := NhApiApplyCopy(SourceRoomId := SourceRoomId, Target := ConfigRecord);
                     NH_API_MSG_SET_ROOM_CONFIG:
                        NhApiReadConfigRecord(Buffer := Buffer, Offset := NH_API_HEADER_SIZE, Record := ConfigRecord);
                        Result := NhApiApplyConfig(Record := ConfigRecord);
                     NH_API_MSG_SET_ROOM_STATE:
                        NhApiReadStateRecord(Buffer := Buffer, Offset := NH_API_HEADER_SIZE, Record := StateRecord);
                        Result := NhApiApplyState(Record := StateRecord);
                     ELSE
                        Result := NH_API_RESULT_UNSUPPORTED;
                  END_CASE;
               END_IF;
            END_IF;
         END_IF;
         NhClientLastRx[Index] := NhApiClients[Index].RxPublishedRevision;
         NhClientLastActivityMs[Index] := NhApiSystemTimeMs();
         NhApiClients[Index].LastRequestId := RequestId;
         NhApiClients[Index].ResultCode := Result;
         NhApiClients[Index].ResultConfigRevision := NhApiInfo.ConfigRevision;
         NhApiClients[Index].ResultStateRevision := NhApiInfo.StateRevision;
         NhApiProcessOneRx := TRUE;
         RETURN;
      END_IF;
   END_FOR;
END_FUNCTION

FUNCTION NhApiProcessTest : BOOL
   // Processes one test action submitted through WebMaker. SK: Spracuje jednu testovaciu akciu zadanu cez WebMaker.
   VAR
      Slot : USINT;               // Located room slot. SK: Najdeny room slot.
      Result : USINT;             // WebMaker action result. SK: Vysledok WebMaker akcie.
      ConfigRecord : NH_ROOM_CONFIG; // Constructed config record. SK: Zostaveny config zaznam.
      StateRecord : NH_ROOM_STATE;   // Constructed state record. SK: Zostaveny state zaznam.
   END_VAR
   NhApiProcessTest := FALSE;
   IF NOT NhApiTest.Execute THEN RETURN; END_IF;
   IF (NhApiInfo.TxState <> NH_API_TX_IDLE) OR NhSnapshotActive OR (NhPendingKind <> 0) THEN
      NhApiTest.Busy := TRUE;
      NhApiTest.Finished := FALSE;
      RETURN;
   END_IF;
   NhApiTest.Busy := TRUE;
   NhApiTest.Finished := FALSE;
   Result := NH_API_RESULT_UNSUPPORTED;
   IF NhApiTest.Action = NH_API_TEST_REQUEST_SNAPSHOT THEN
      IF NhApiStartSnapshot(TargetClientId := 0, RequestId := 0) THEN Result := NH_API_RESULT_OK; ELSE Result := NH_API_RESULT_BUSY; END_IF;
   ELSIF NhApiTest.Action = NH_API_TEST_DELETE_ROOM THEN
      Result := NhApiApplyDelete(RoomId := NhApiTest.RoomId);
   ELSIF NhApiTest.Action = NH_API_TEST_SET_STATE THEN
      Slot := NhApiFindRoom(RoomId := NhApiTest.RoomId);
      IF Slot = 0 THEN
         Result := NH_API_RESULT_NOT_FOUND;
      ELSE
         StateRecord := NhRoomsState[Slot];
         StateRecord.Temperature := NhApiTest.Temperature;
         StateRecord.Humidity := NhApiTest.Humidity;
         StateRecord.Presence := NhApiTest.Presence;
         StateRecord.DayPhase := NhApiTest.DayPhase;
         StateRecord.CategoryMask := NhApiTest.CategoryMask;
         StateRecord.AlarmLevel := NhApiTest.AlarmLevel;
         StateRecord.Online := NhApiTest.Online;
         StateRecord.Twilight := NhApiTest.Twilight;
         Result := NhApiApplyState(Record := StateRecord);
      END_IF;
   ELSE
      ConfigRecord.Used := TRUE;
      ConfigRecord.RoomId := NhApiTest.RoomId;
      ConfigRecord.Name := NhApiTest.Name;
      ConfigRecord.ProjectName := NhApiTest.ProjectName;
      ConfigRecord.IconId := NhApiTest.IconId;
      ConfigRecord.SortDefault := 0;
      IF NhApiTest.Action = NH_API_TEST_ADD_ROOM THEN
         Result := NhApiApplyAdd(Record := ConfigRecord);
      ELSIF NhApiTest.Action = NH_API_TEST_COPY_ROOM THEN
         Result := NhApiApplyCopy(SourceRoomId := NhApiTest.SourceRoomId, Target := ConfigRecord);
      ELSIF NhApiTest.Action = NH_API_TEST_SET_CONFIG THEN
         Slot := NhApiFindRoom(RoomId := NhApiTest.RoomId);
         IF Slot = 0 THEN
            Result := NH_API_RESULT_NOT_FOUND;
         ELSE
            ConfigRecord.SortDefault := NhRoomsConfig[Slot].SortDefault;
            Result := NhApiApplyConfig(Record := ConfigRecord);
         END_IF;
      END_IF;
   END_IF;
   NhApiTest.ResultCode := Result;
   NhApiTest.ConfigRevision := NhApiInfo.ConfigRevision;
   NhApiTest.StateRevision := NhApiInfo.StateRevision;
   NhApiTest.Execute := FALSE;
   NhApiTest.Busy := FALSE;
   NhApiTest.Finished := TRUE;
   NhApiProcessTest := TRUE;
END_FUNCTION

FUNCTION NhApiCycle : BOOL
   // Executes one cycle of the API state machine. SK: Vykona jeden cyklus stavoveho automatu API.
   VAR
      Captured : BOOL;            // A new diff was captured in this cycle. SK: V tomto cykle vznikol novy diff.
   END_VAR
   NhApiProcessClients();
   IF NhApiInfo.TxState = NH_API_TX_IDLE THEN
      IF NhSnapshotActive THEN
         NhApiPublishSnapshotPart();
      ELSIF NhPendingKind <> 0 THEN
         NhApiPublishPendingDiff();
      ELSE
         NhApiProcessOneRx();
         NhApiProcessTest();
         IF NhSnapshotActive THEN
            NhApiPublishSnapshotPart();
         ELSE
            Captured := NhApiCaptureConfigDiff();
            IF NOT Captured THEN Captured := NhApiCaptureStateDiff(); END_IF;
            IF Captured THEN NhApiPublishPendingDiff(); END_IF;
         END_IF;
      END_IF;
   END_IF;
   NhApiCycle := TRUE;
END_FUNCTION
