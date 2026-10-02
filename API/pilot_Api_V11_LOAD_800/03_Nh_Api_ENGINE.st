// Single-owner transaction engine, snapshots, diffs and room operations.
// SK: Transakcny automat jedneho vlastnika, snapshoty, diffy a room operacie.

FUNCTION NhApiClearRoom : BOOL
   // Clears configuration and state of one internal room slot. SK: Vynuluje konfiguraciu a stav jedneho interneho room slotu.
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
   // Initializes API buffers, handshake and deterministic pilot data once. SK: Jednorazovo inicializuje API buffery, handshake a deterministicke pilotne data.
   VAR
      Index : USINT; // Initialization index. SK: Inicializacny index.
   END_VAR
   NhApiInitialize := NhApiInitialized;
   IF NhApiInitialized THEN RETURN; END_IF;

   NhApiClearBuffer(Buffer := ADR(NhApiTX), Length := NH_API_TX_BYTE_CAPACITY);
   NhApiClearBuffer(Buffer := ADR(NhApiRX), Length := NH_API_RX_BYTE_CAPACITY);
   FOR Index := 1 TO NH_API_MAX_ROOMS DO
      NhApiClearRoom(Index := Index);
   END_FOR;

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
   END_FOR;

   FOR Index := 1 TO NH_API_MAX_ROOMS DO
      NhConfigShadow[Index] := NhRoomsConfig[Index];
      NhStateShadow[Index] := NhRoomsState[Index];
   END_FOR;

   NhApiInfo.ApiVersion := NH_API_VERSION;
   NhApiInfo.OwnerClientId := 0;
   NhApiInfo.State := NH_API_STATE_IDLE;
   NhActiveOwnerClientId := 0;
   NhExpectedState := NH_API_STATE_IDLE;
   NhTransactionMode := NH_API_MODE_NONE;
   NhTransactionLastMs := NhApiSystemTimeMs();
   NhPublishedFrameId := 0;
   NhCommandResult := NH_API_RESULT_NONE;
   NhResultPending := FALSE;
   NhPendingConfigCount := 0;
   NhPendingStateCount := 0;
   NhSnapshotActive := FALSE;

   NhApiTest.Execute := FALSE;
   NhApiTest.Finished := FALSE;
   NhApiTest.Action := NH_API_TEST_NONE;
   NhApiTest.ResultCode := NH_API_RESULT_NONE;
   NhApiInitialized := TRUE;
   NhApiInitialize := TRUE;
END_FUNCTION

FUNCTION NhApiBeginFrame : BOOL
   // Clears TX and writes the fixed 40-byte frame header. SK: Vycisti TX a zapise pevnu 40-bajtovu hlavicku ramca.
   VAR_INPUT
      MessageType  : UINT;  // NH_API_MSG_* value. SK: Hodnota NH_API_MSG_*.
      SchemaId     : UINT;  // NH_API_SCHEMA_* value. SK: Hodnota NH_API_SCHEMA_*.
      OwnerClientId: UDINT; // Target owner token; zero is broadcast. SK: Cielovy token vlastnika; nula je broadcast.
      RecordCount  : UINT;  // Number of payload records. SK: Pocet zaznamov payloadu.
      RecordSize   : UINT;  // Fixed size of one payload record. SK: Pevna velkost jedneho payload zaznamu.
      PartIndex    : UINT;  // One-based part index. SK: Index casti cislovany od jedna.
      PartCount    : UINT;  // Total parts in this section. SK: Celkovy pocet casti sekcie.
      ResultCode   : USINT; // NH_API_RESULT_* value. SK: Hodnota NH_API_RESULT_*.
   END_VAR
   VAR
      Buffer      : PTR_TO BYTE; // Byte view of NhApiTX. SK: Bajtovy pohlad na NhApiTX.
      PayloadSize : UDINT;       // Calculated payload size. SK: Vypocitana velkost payloadu.
      TotalSize   : UDINT;       // Header plus payload size. SK: Velkost hlavicky a payloadu.
   END_VAR
   Buffer := ADR(NhApiTX);
   NhApiClearBuffer(Buffer := Buffer, Length := NH_API_TX_BYTE_CAPACITY);
   PayloadSize := UINT_TO_UDINT(RecordCount) * UINT_TO_UDINT(RecordSize);
   TotalSize := UINT_TO_UDINT(NH_API_HEADER_SIZE) + PayloadSize;
   IF TotalSize > UINT_TO_UDINT(NH_API_TX_BYTE_CAPACITY) THEN
      NhApiBeginFrame := FALSE;
      RETURN;
   END_IF;
   NhApiWriteU32(Buffer := Buffer, Offset := 0, Value := DWORD_TO_UDINT(NH_API_MAGIC));
   NhApiWriteU16(Buffer := Buffer, Offset := 4, Value := NH_API_VERSION);
   NhApiWriteU16(Buffer := Buffer, Offset := 6, Value := NH_API_HEADER_SIZE);
   NhApiWriteU16(Buffer := Buffer, Offset := 8, Value := MessageType);
   NhApiWriteU16(Buffer := Buffer, Offset := 10, Value := SchemaId);
   NhApiWriteU32(Buffer := Buffer, Offset := 12, Value := OwnerClientId);
   NhApiWriteU16(Buffer := Buffer, Offset := 16, Value := RecordCount);
   NhApiWriteU16(Buffer := Buffer, Offset := 18, Value := RecordSize);
   NhApiWriteByte(Buffer := Buffer, Offset := 20, Value := WORD_TO_BYTE(UINT_TO_WORD(PartIndex)));
   NhApiWriteByte(Buffer := Buffer, Offset := 21, Value := WORD_TO_BYTE(UINT_TO_WORD(PartCount)));
   NhApiWriteByte(Buffer := Buffer, Offset := 22, Value := USINT_TO_BYTE(ResultCode));
   NhApiWriteByte(Buffer := Buffer, Offset := 23, Value := 0);
   NhApiWriteU32(Buffer := Buffer, Offset := 24, Value := PayloadSize);
   NhApiWriteU32(Buffer := Buffer, Offset := 28, Value := TotalSize);
   NhApiWriteU32(Buffer := Buffer, Offset := 32, Value := 0);
   NhApiWriteU32(Buffer := Buffer, Offset := 36, Value := 0);
   NhApiBeginFrame := TRUE;
END_FUNCTION

FUNCTION NhApiPublishFrame : BOOL
   // Adds CRC and publishes TX by changing State only after the buffer is stable. SK: Doplni CRC a publikuje TX zmenou State az po ustaleni buffera.
   VAR_INPUT
      NextState : UINT; // New persistent handshake step. SK: Novy trvaly handshake krok.
   END_VAR
   VAR
      Buffer    : PTR_TO BYTE; // Byte view of NhApiTX. SK: Bajtovy pohlad na NhApiTX.
      TotalSize : UINT;        // Valid frame byte count. SK: Pocet platnych bajtov ramca.
      Crc       : DWORD;       // CRC32 of the frame. SK: CRC32 ramca.
   END_VAR
   Buffer := ADR(NhApiTX);
   TotalSize := UDINT_TO_UINT(NhApiReadU32(Buffer := Buffer, Offset := 28));
   NhPublishedFrameId := NhPublishedFrameId + 1;
   IF NhPublishedFrameId = 0 THEN NhPublishedFrameId := 1; END_IF;
   NhApiWriteU32(Buffer := Buffer, Offset := 32, Value := NhPublishedFrameId);
   Crc := NhApiFrameCrc32(Buffer := Buffer, Length := TotalSize);
   NhApiWriteU32(Buffer := Buffer, Offset := 36, Value := DWORD_TO_UDINT(Crc));
   NhExpectedState := NextState;
   NhTransactionLastMs := NhApiSystemTimeMs();
   NhApiInfo.State := NextState;
   NhApiPublishFrame := TRUE;
END_FUNCTION

FUNCTION NhApiResetTransaction : BOOL
   // Releases the global mailbox and clears internal sequence state. SK: Uvolni globalny mailbox a vycisti interny stav sekvencie.
   NhApiInfo.OwnerClientId := 0;
   NhApiInfo.State := NH_API_STATE_IDLE;
   NhActiveOwnerClientId := 0;
   NhExpectedState := NH_API_STATE_IDLE;
   NhTransactionMode := NH_API_MODE_NONE;
   NhTransactionLastMs := NhApiSystemTimeMs();
   NhCommandResult := NH_API_RESULT_NONE;
   NhResultPending := FALSE;
   NhPendingConfigCount := 0;
   NhPendingStateCount := 0;
   NhSnapshotActive := FALSE;
   NhApiResetTransaction := TRUE;
END_FUNCTION

FUNCTION NhApiApplyAdd : USINT
   // Adds a room to the first free internal slot. SK: Prida miestnost do prveho volneho interneho slotu.
   VAR_INPUT
      Record : NH_ROOM_CONFIG; // New room configuration. SK: Konfiguracia novej miestnosti.
   END_VAR
   VAR
      Slot : USINT; // Free internal room slot. SK: Volny interny room slot.
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
   // Deletes a room by stable RoomId. SK: Zmaze miestnost podla stabilneho RoomId.
   VAR_INPUT
      RoomId : UDINT; // ID of the room to delete. SK: ID mazanej miestnosti.
   END_VAR
   VAR
      Slot : USINT;   // Located internal slot. SK: Najdeny interny slot.
   END_VAR
   Slot := NhApiFindRoom(RoomId := RoomId);
   IF Slot = 0 THEN NhApiApplyDelete := NH_API_RESULT_NOT_FOUND; RETURN; END_IF;
   NhApiClearRoom(Index := Slot);
   NhApiApplyDelete := NH_API_RESULT_OK;
END_FUNCTION

FUNCTION NhApiApplyConfig : USINT
   // Replaces complete configuration of an existing room. SK: Nahradi celu konfiguraciu existujucej miestnosti.
   VAR_INPUT
      Record : NH_ROOM_CONFIG; // Complete new configuration. SK: Uplna nova konfiguracia.
   END_VAR
   VAR
      Slot : USINT;            // Located internal slot. SK: Najdeny interny slot.
   END_VAR
   Slot := NhApiFindRoom(RoomId := Record.RoomId);
   IF Slot = 0 THEN NhApiApplyConfig := NH_API_RESULT_NOT_FOUND; RETURN; END_IF;
   IF LEN(Record.Name) = 0 THEN NhApiApplyConfig := NH_API_RESULT_INVALID; RETURN; END_IF;
   NhRoomsConfig[Slot] := Record;
   NhRoomsConfig[Slot].Used := TRUE;
   NhApiApplyConfig := NH_API_RESULT_OK;
END_FUNCTION

FUNCTION NhApiApplyState : USINT
   // Replaces complete dynamic state of an existing room. SK: Nahradi cely dynamicky stav existujucej miestnosti.
   VAR_INPUT
      Record : NH_ROOM_STATE; // Complete new state. SK: Uplny novy stav.
   END_VAR
   VAR
      Slot : USINT;           // Located internal slot. SK: Najdeny interny slot.
   END_VAR
   Slot := NhApiFindRoom(RoomId := Record.RoomId);
   IF Slot = 0 THEN NhApiApplyState := NH_API_RESULT_NOT_FOUND; RETURN; END_IF;
   IF (Record.Temperature < -50.0) OR (Record.Temperature > 100.0) OR
      (Record.Humidity < 0.0) OR (Record.Humidity > 100.0) OR (Record.AlarmLevel > 2) THEN
      NhApiApplyState := NH_API_RESULT_INVALID;
      RETURN;
   END_IF;
   NhRoomsState[Slot] := Record;
   NhApiApplyState := NH_API_RESULT_OK;
END_FUNCTION

FUNCTION NhApiApplyCopy : USINT
   // Copies an existing room into a new RoomId. SK: Skopiruje existujucu miestnost do noveho RoomId.
   VAR_INPUT
      SourceRoomId : UDINT;         // Source room ID. SK: ID zdrojovej miestnosti.
      Target       : NH_ROOM_CONFIG;// Target ID and optional replacements. SK: Cielove ID a volitelne nahrady.
   END_VAR
   VAR
      SourceSlot : USINT; // Source internal slot. SK: Zdrojovy interny slot.
      TargetSlot : USINT; // Target free slot. SK: Cielovy volny slot.
   END_VAR
   SourceSlot := NhApiFindRoom(RoomId := SourceRoomId);
   IF SourceSlot = 0 THEN NhApiApplyCopy := NH_API_RESULT_NOT_FOUND; RETURN; END_IF;
   IF Target.RoomId = 0 THEN NhApiApplyCopy := NH_API_RESULT_INVALID; RETURN; END_IF;
   IF NhApiFindRoom(RoomId := Target.RoomId) <> 0 THEN NhApiApplyCopy := NH_API_RESULT_ALREADY_EXISTS; RETURN; END_IF;
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

FUNCTION NhApiCaptureConfigChanges : BOOL
   // Freezes all unpublished configuration changes. SK: Zmrazi vsetky nepublikovane zmeny konfiguracie.
   VAR
      Index : USINT; // Scanned room slot. SK: Prehladavany room slot.
   END_VAR
   NhPendingConfigCount := 0;
   FOR Index := 1 TO NH_API_MAX_ROOMS DO
      IF NOT NhApiConfigEqual(A := NhRoomsConfig[Index], B := NhConfigShadow[Index]) THEN
         NhPendingConfigCount := NhPendingConfigCount + 1;
         IF NhRoomsConfig[Index].Used THEN
            NhPendingConfigOperation[NhPendingConfigCount] := NH_API_CHANGE_UPSERT;
            NhPendingConfigRoomId[NhPendingConfigCount] := NhRoomsConfig[Index].RoomId;
         ELSE
            NhPendingConfigOperation[NhPendingConfigCount] := NH_API_CHANGE_DELETE;
            NhPendingConfigRoomId[NhPendingConfigCount] := NhConfigShadow[Index].RoomId;
         END_IF;
         NhPendingConfig[NhPendingConfigCount] := NhRoomsConfig[Index];
         NhConfigShadow[Index] := NhRoomsConfig[Index];
      END_IF;
   END_FOR;
   NhPendingConfigNext := 1;
   NhPendingConfigPart := 1;
   NhPendingConfigParts := 0;
   IF NhPendingConfigCount > 0 THEN
      NhPendingConfigParts := (NhPendingConfigCount + NH_API_CONFIG_DIFF_PER_FRAME - 1) / NH_API_CONFIG_DIFF_PER_FRAME;
   END_IF;
   NhApiCaptureConfigChanges := NhPendingConfigCount > 0;
END_FUNCTION

FUNCTION NhApiCaptureStateChanges : BOOL
   // Freezes all unpublished dynamic-state changes. SK: Zmrazi vsetky nepublikovane zmeny dynamickeho stavu.
   VAR
      Index : USINT; // Scanned room slot. SK: Prehladavany room slot.
   END_VAR
   NhPendingStateCount := 0;
   FOR Index := 1 TO NH_API_MAX_ROOMS DO
      IF NOT NhApiStateEqual(A := NhRoomsState[Index], B := NhStateShadow[Index]) THEN
         NhPendingStateCount := NhPendingStateCount + 1;
         IF NhRoomsConfig[Index].Used THEN
            NhPendingStateOperation[NhPendingStateCount] := NH_API_CHANGE_UPSERT;
            NhPendingStateRoomId[NhPendingStateCount] := NhRoomsState[Index].RoomId;
         ELSE
            NhPendingStateOperation[NhPendingStateCount] := NH_API_CHANGE_DELETE;
            NhPendingStateRoomId[NhPendingStateCount] := NhStateShadow[Index].RoomId;
         END_IF;
         NhPendingState[NhPendingStateCount] := NhRoomsState[Index];
         NhStateShadow[Index] := NhRoomsState[Index];
      END_IF;
   END_FOR;
   NhPendingStateNext := 1;
   NhPendingStatePart := 1;
   NhPendingStateParts := 0;
   IF NhPendingStateCount > 0 THEN
      NhPendingStateParts := (NhPendingStateCount + NH_API_STATE_DIFF_PER_FRAME - 1) / NH_API_STATE_DIFF_PER_FRAME;
   END_IF;
   NhApiCaptureStateChanges := NhPendingStateCount > 0;
END_FUNCTION

FUNCTION NhApiCaptureAllChanges : BOOL
   // Freezes current config and state changes in one PLC cycle. SK: Zmrazi aktualne config a state zmeny v jednom PLC cykle.
   VAR
      ConfigChanged : BOOL; // At least one config changed. SK: Zmenil sa aspon jeden config.
      StateChanged  : BOOL; // At least one state changed. SK: Zmenil sa aspon jeden state.
   END_VAR
   ConfigChanged := NhApiCaptureConfigChanges();
   StateChanged := NhApiCaptureStateChanges();
   NhApiCaptureAllChanges := ConfigChanged OR StateChanged;
END_FUNCTION

FUNCTION NhApiStartSnapshot : BOOL
   // Freezes the authoritative room image for a complete snapshot. SK: Zmrazi autoritativny obraz miestnosti pre kompletny snapshot.
   VAR
      Index : USINT; // Scanned source room slot. SK: Prehladavany zdrojovy room slot.
   END_VAR
   NhSnapshotCount := 0;
   FOR Index := 1 TO NH_API_MAX_ROOMS DO
      IF NhRoomsConfig[Index].Used THEN
         NhSnapshotCount := NhSnapshotCount + 1;
         NhSnapshotConfig[NhSnapshotCount] := NhRoomsConfig[Index];
         NhSnapshotState[NhSnapshotCount] := NhRoomsState[Index];
      END_IF;
      // The frozen snapshot is the new cache baseline; later PLC changes become diffs. SK: Zmrazeny snapshot je novy zaklad cache; neskorsie PLC zmeny sa stanu diffom.
      NhConfigShadow[Index] := NhRoomsConfig[Index];
      NhStateShadow[Index] := NhRoomsState[Index];
   END_FOR;
   NhPendingConfigCount := 0;
   NhPendingStateCount := 0;
   NhSnapshotActive := TRUE;
   NhSnapshotStage := 1;
   NhSnapshotNext := 1;
   NhSnapshotPart := 1;
   NhSnapshotParts := (NhSnapshotCount + NH_API_CONFIG_PER_FRAME - 1) / NH_API_CONFIG_PER_FRAME;
   IF NhSnapshotParts = 0 THEN NhSnapshotParts := 1; END_IF;
   NhApiStartSnapshot := TRUE;
END_FUNCTION

FUNCTION NhApiBuildNextSnapshotFrame : BOOL
   // Builds the next CONFIG, STATE or DONE snapshot frame without publishing State yet. SK: Vytvori dalsi CONFIG, STATE alebo DONE snapshot ramec bez publikovania State.
   VAR
      Buffer : PTR_TO BYTE; // Byte view of NhApiTX. SK: Bajtovy pohlad na NhApiTX.
      Count  : USINT;       // Records in this frame. SK: Pocet zaznamov v tomto ramci.
      Index  : USINT;       // Local record index. SK: Lokalny index zaznamu.
      Source : USINT;       // Frozen snapshot index. SK: Index zmrazeneho snapshotu.
      Offset : UINT;        // Record byte offset. SK: Bajtovy offset zaznamu.
   END_VAR
   NhApiBuildNextSnapshotFrame := FALSE;
   IF NOT NhSnapshotActive THEN RETURN; END_IF;
   Buffer := ADR(NhApiTX);

   IF NhSnapshotStage = 1 THEN
      Count := NH_API_CONFIG_PER_FRAME;
      IF NhSnapshotCount = 0 THEN
         Count := 0;
      ELSIF (NhSnapshotNext + Count - 1) > NhSnapshotCount THEN
         Count := NhSnapshotCount - NhSnapshotNext + 1;
      END_IF;
      NhApiBeginFrame(MessageType := NH_API_MSG_CONFIG_SNAPSHOT, SchemaId := NH_API_SCHEMA_ROOM_CONFIG,
         OwnerClientId := NhActiveOwnerClientId, RecordCount := USINT_TO_UINT(Count),
         RecordSize := NH_API_CONFIG_RECORD_SIZE, PartIndex := USINT_TO_UINT(NhSnapshotPart),
         PartCount := USINT_TO_UINT(NhSnapshotParts), ResultCode := NH_API_RESULT_OK);
      IF Count > 0 THEN
         FOR Index := 0 TO Count - 1 DO
            Source := NhSnapshotNext + Index;
            Offset := NH_API_HEADER_SIZE + USINT_TO_UINT(Index) * NH_API_CONFIG_RECORD_SIZE;
            NhApiWriteConfigRecord(Buffer := Buffer, Offset := Offset, Record := NhSnapshotConfig[Source]);
         END_FOR;
      END_IF;
      NhSnapshotNext := NhSnapshotNext + Count;
      NhSnapshotPart := NhSnapshotPart + 1;
      IF (NhSnapshotCount = 0) OR (NhSnapshotNext > NhSnapshotCount) THEN
         NhSnapshotStage := 2;
         NhSnapshotNext := 1;
         NhSnapshotPart := 1;
         NhSnapshotParts := (NhSnapshotCount + NH_API_STATE_PER_FRAME - 1) / NH_API_STATE_PER_FRAME;
         IF NhSnapshotParts = 0 THEN NhSnapshotParts := 1; END_IF;
      END_IF;
      NhApiBuildNextSnapshotFrame := TRUE;
      RETURN;
   END_IF;

   IF NhSnapshotStage = 2 THEN
      Count := NH_API_STATE_PER_FRAME;
      IF NhSnapshotCount = 0 THEN
         Count := 0;
      ELSIF (NhSnapshotNext + Count - 1) > NhSnapshotCount THEN
         Count := NhSnapshotCount - NhSnapshotNext + 1;
      END_IF;
      NhApiBeginFrame(MessageType := NH_API_MSG_STATE_SNAPSHOT, SchemaId := NH_API_SCHEMA_ROOM_STATE,
         OwnerClientId := NhActiveOwnerClientId, RecordCount := USINT_TO_UINT(Count),
         RecordSize := NH_API_STATE_RECORD_SIZE, PartIndex := USINT_TO_UINT(NhSnapshotPart),
         PartCount := USINT_TO_UINT(NhSnapshotParts), ResultCode := NH_API_RESULT_OK);
      IF Count > 0 THEN
         FOR Index := 0 TO Count - 1 DO
            Source := NhSnapshotNext + Index;
            Offset := NH_API_HEADER_SIZE + USINT_TO_UINT(Index) * NH_API_STATE_RECORD_SIZE;
            NhApiWriteStateRecord(Buffer := Buffer, Offset := Offset, Record := NhSnapshotState[Source]);
         END_FOR;
      END_IF;
      NhSnapshotNext := NhSnapshotNext + Count;
      NhSnapshotPart := NhSnapshotPart + 1;
      IF (NhSnapshotCount = 0) OR (NhSnapshotNext > NhSnapshotCount) THEN
         NhSnapshotStage := 3;
      END_IF;
      NhApiBuildNextSnapshotFrame := TRUE;
      RETURN;
   END_IF;

   IF NhSnapshotStage = 3 THEN
      NhApiBeginFrame(MessageType := NH_API_MSG_SNAPSHOT_DONE, SchemaId := NH_API_SCHEMA_NONE,
         OwnerClientId := NhActiveOwnerClientId, RecordCount := 0, RecordSize := 0,
         PartIndex := 1, PartCount := 1, ResultCode := NH_API_RESULT_OK);
      NhSnapshotStage := 4;
      NhApiBuildNextSnapshotFrame := TRUE;
      RETURN;
   END_IF;

   NhSnapshotActive := FALSE;
END_FUNCTION

FUNCTION NhApiBuildNextDiffFrame : BOOL
   // Builds the next frozen CONFIG or STATE diff frame. SK: Vytvori dalsi zmrazeny CONFIG alebo STATE diff ramec.
   VAR
      Buffer : PTR_TO BYTE; // Byte view of NhApiTX. SK: Bajtovy pohlad na NhApiTX.
      Count  : USINT;       // Changes in this frame. SK: Pocet zmien v tomto ramci.
      Index  : USINT;       // Local change index. SK: Lokalny index zmeny.
      Source : USINT;       // Frozen change index. SK: Index zmrazenej zmeny.
      Offset : UINT;        // Change byte offset. SK: Bajtovy offset zmeny.
   END_VAR
   NhApiBuildNextDiffFrame := FALSE;
   Buffer := ADR(NhApiTX);

   IF NhPendingConfigNext <= NhPendingConfigCount THEN
      Count := NH_API_CONFIG_DIFF_PER_FRAME;
      IF (NhPendingConfigNext + Count - 1) > NhPendingConfigCount THEN
         Count := NhPendingConfigCount - NhPendingConfigNext + 1;
      END_IF;
      NhApiBeginFrame(MessageType := NH_API_MSG_CONFIG_DIFF, SchemaId := NH_API_SCHEMA_ROOM_CONFIG,
         OwnerClientId := NhActiveOwnerClientId, RecordCount := USINT_TO_UINT(Count),
         RecordSize := NH_API_CONFIG_DIFF_SIZE, PartIndex := USINT_TO_UINT(NhPendingConfigPart),
         PartCount := USINT_TO_UINT(NhPendingConfigParts), ResultCode := NhCommandResult);
      FOR Index := 0 TO Count - 1 DO
         Source := NhPendingConfigNext + Index;
         Offset := NH_API_HEADER_SIZE + USINT_TO_UINT(Index) * NH_API_CONFIG_DIFF_SIZE;
         NhApiWriteByte(Buffer := Buffer, Offset := Offset, Value := USINT_TO_BYTE(NhPendingConfigOperation[Source]));
         NhApiWriteU32(Buffer := Buffer, Offset := Offset + 1, Value := NhPendingConfigRoomId[Source]);
         NhApiWriteConfigRecord(Buffer := Buffer, Offset := Offset + 5, Record := NhPendingConfig[Source]);
      END_FOR;
      NhPendingConfigNext := NhPendingConfigNext + Count;
      NhPendingConfigPart := NhPendingConfigPart + 1;
      NhApiBuildNextDiffFrame := TRUE;
      RETURN;
   END_IF;

   IF NhPendingStateNext <= NhPendingStateCount THEN
      Count := NH_API_STATE_DIFF_PER_FRAME;
      IF (NhPendingStateNext + Count - 1) > NhPendingStateCount THEN
         Count := NhPendingStateCount - NhPendingStateNext + 1;
      END_IF;
      NhApiBeginFrame(MessageType := NH_API_MSG_STATE_DIFF, SchemaId := NH_API_SCHEMA_ROOM_STATE,
         OwnerClientId := NhActiveOwnerClientId, RecordCount := USINT_TO_UINT(Count),
         RecordSize := NH_API_STATE_DIFF_SIZE, PartIndex := USINT_TO_UINT(NhPendingStatePart),
         PartCount := USINT_TO_UINT(NhPendingStateParts), ResultCode := NhCommandResult);
      FOR Index := 0 TO Count - 1 DO
         Source := NhPendingStateNext + Index;
         Offset := NH_API_HEADER_SIZE + USINT_TO_UINT(Index) * NH_API_STATE_DIFF_SIZE;
         NhApiWriteByte(Buffer := Buffer, Offset := Offset, Value := USINT_TO_BYTE(NhPendingStateOperation[Source]));
         NhApiWriteU32(Buffer := Buffer, Offset := Offset + 1, Value := NhPendingStateRoomId[Source]);
         NhApiWriteStateRecord(Buffer := Buffer, Offset := Offset + 5, Record := NhPendingState[Source]);
      END_FOR;
      NhPendingStateNext := NhPendingStateNext + Count;
      NhPendingStatePart := NhPendingStatePart + 1;
      NhApiBuildNextDiffFrame := TRUE;
      RETURN;
   END_IF;
END_FUNCTION

FUNCTION NhApiBuildResultFrame : BOOL
   // Builds the final command result frame. SK: Vytvori posledny ramec vysledku prikazu.
   NhApiBuildResultFrame := FALSE;
   IF NOT NhResultPending THEN RETURN; END_IF;
   NhApiBeginFrame(MessageType := NH_API_MSG_RESULT, SchemaId := NH_API_SCHEMA_NONE,
      OwnerClientId := NhActiveOwnerClientId, RecordCount := 0, RecordSize := 0,
      PartIndex := 1, PartCount := 1, ResultCode := NhCommandResult);
   NhResultPending := FALSE;
   NhApiBuildResultFrame := TRUE;
END_FUNCTION

FUNCTION NhApiBuildNextFrame : BOOL
   // Selects and builds the next frame of the active sequence. SK: Vyberie a vytvori dalsi ramec aktivnej sekvencie.
   NhApiBuildNextFrame := FALSE;
   IF (NhTransactionMode = NH_API_MODE_SNAPSHOT) OR (NhTransactionMode = NH_API_MODE_BROADCAST_SNAPSHOT) THEN
      NhApiBuildNextFrame := NhApiBuildNextSnapshotFrame();
      RETURN;
   END_IF;
   IF (NhTransactionMode = NH_API_MODE_COMMAND) OR (NhTransactionMode = NH_API_MODE_BROADCAST_DIFF) THEN
      IF NhApiBuildNextDiffFrame() THEN
         NhApiBuildNextFrame := TRUE;
         RETURN;
      END_IF;
      IF NhTransactionMode = NH_API_MODE_COMMAND THEN
         NhApiBuildNextFrame := NhApiBuildResultFrame();
      END_IF;
   END_IF;
END_FUNCTION

FUNCTION NhApiPublishNextTargetFrame : BOOL
   // Publishes the next targeted frame or releases the transaction after the final ACK. SK: Publikuje dalsi cielovy ramec alebo po poslednom ACK uvolni transakciu.
   VAR
      NextState : UINT; // Next odd PLC-owned handshake step. SK: Dalsi neparny handshake krok vlastneny PLC.
   END_VAR
   NextState := NhExpectedState + 1;
   IF NhApiBuildNextFrame() THEN
      NhApiPublishFrame(NextState := NextState);
      NhApiPublishNextTargetFrame := TRUE;
   ELSE
      NhApiResetTransaction();
      NhApiPublishNextTargetFrame := FALSE;
   END_IF;
END_FUNCTION

FUNCTION NhApiPublishNextBroadcastFrame : BOOL
   // Publishes the next best-effort broadcast frame or returns to IDLE. SK: Publikuje dalsi best-effort broadcast ramec alebo sa vrati do IDLE.
   VAR
      NextState : UINT; // Next odd broadcast commit step. SK: Dalsi neparny broadcast commit krok.
   END_VAR
   IF NhExpectedState = 0 THEN
      NextState := 1;
   ELSE
      NextState := NhExpectedState + 2;
   END_IF;
   IF NhApiBuildNextFrame() THEN
      NhApiPublishFrame(NextState := NextState);
      NhApiPublishNextBroadcastFrame := TRUE;
   ELSE
      NhApiResetTransaction();
      NhApiPublishNextBroadcastFrame := FALSE;
   END_IF;
END_FUNCTION

FUNCTION NhApiProcessRx : BOOL
   // Validates the committed shared RX frame, executes it and publishes the first response frame. SK: Overi potvrdeny spolocny RX ramec, vykona ho a publikuje prvy ramec odpovede.
   VAR
      Buffer       : PTR_TO BYTE; // Byte view of NhApiRX. SK: Bajtovy pohlad na NhApiRX.
      TotalSize    : UINT;        // Declared complete RX size. SK: Deklarovana celkova velkost RX.
      PayloadSize  : UDINT;       // Declared payload size. SK: Deklarovana velkost payloadu.
      MessageType  : UINT;        // RX NH_API_MSG_* value. SK: RX hodnota NH_API_MSG_*.
      ExpectedCrc  : DWORD;       // CRC carried by RX header. SK: CRC ulozene v RX hlavicke.
      ActualCrc    : DWORD;       // CRC calculated by PLC. SK: CRC vypocitane PLC.
      ValidFrame   : BOOL;        // Header, size, owner and CRC are valid. SK: Hlavicka, velkost, vlastnik a CRC su platne.
      ConfigRecord : NH_ROOM_CONFIG; // Decoded config record. SK: Dekodovany config zaznam.
      StateRecord  : NH_ROOM_STATE;  // Decoded state record. SK: Dekodovany state zaznam.
      SourceRoomId : UDINT;       // Source ID of COPY_ROOM. SK: Zdrojove ID COPY_ROOM.
   END_VAR
   Buffer := ADR(NhApiRX);
   NhCommandResult := NH_API_RESULT_BAD_FRAME;
   ValidFrame := FALSE;
   TotalSize := UDINT_TO_UINT(NhApiReadU32(Buffer := Buffer, Offset := 28));
   PayloadSize := NhApiReadU32(Buffer := Buffer, Offset := 24);
   IF (TotalSize >= NH_API_HEADER_SIZE) AND (TotalSize <= NH_API_RX_BYTE_CAPACITY) AND
      (NhApiReadU32(Buffer := Buffer, Offset := 0) = DWORD_TO_UDINT(NH_API_MAGIC)) AND
      (NhApiReadU16(Buffer := Buffer, Offset := 4) = NH_API_VERSION) AND
      (NhApiReadU16(Buffer := Buffer, Offset := 6) = NH_API_HEADER_SIZE) AND
      (NhApiReadU32(Buffer := Buffer, Offset := 12) = NhActiveOwnerClientId) AND
      ((PayloadSize + UINT_TO_UDINT(NH_API_HEADER_SIZE)) = UINT_TO_UDINT(TotalSize)) THEN
      ExpectedCrc := UDINT_TO_DWORD(NhApiReadU32(Buffer := Buffer, Offset := 36));
      ActualCrc := NhApiFrameCrc32(Buffer := Buffer, Length := TotalSize);
      ValidFrame := ExpectedCrc = ActualCrc;
   END_IF;

   IF NOT ValidFrame THEN
      NhTransactionMode := NH_API_MODE_COMMAND;
      NhResultPending := TRUE;
      NhPendingConfigCount := 0;
      NhPendingStateCount := 0;
      NhApiPublishNextTargetFrame();
      NhApiProcessRx := FALSE;
      RETURN;
   END_IF;

   MessageType := NhApiReadU16(Buffer := Buffer, Offset := 8);
   CASE MessageType OF
      NH_API_MSG_SNAPSHOT_REQUEST:
         IF PayloadSize = 0 THEN
            NhCommandResult := NH_API_RESULT_OK;
            NhApiStartSnapshot();
            NhTransactionMode := NH_API_MODE_SNAPSHOT;
            NhApiPublishNextTargetFrame();
            NhApiProcessRx := TRUE;
            RETURN;
         END_IF;

      NH_API_MSG_ADD_ROOM:
         IF PayloadSize = UINT_TO_UDINT(NH_API_CONFIG_RECORD_SIZE) THEN
            NhApiReadConfigRecord(Buffer := Buffer, Offset := NH_API_HEADER_SIZE, Record := ConfigRecord);
            NhCommandResult := NhApiApplyAdd(Record := ConfigRecord);
         END_IF;

      NH_API_MSG_DELETE_ROOM:
         IF PayloadSize = 4 THEN
            NhCommandResult := NhApiApplyDelete(RoomId := NhApiReadU32(Buffer := Buffer, Offset := NH_API_HEADER_SIZE));
         END_IF;

      NH_API_MSG_COPY_ROOM:
         IF PayloadSize = (UINT_TO_UDINT(NH_API_CONFIG_RECORD_SIZE) + 4) THEN
            SourceRoomId := NhApiReadU32(Buffer := Buffer, Offset := NH_API_HEADER_SIZE);
            NhApiReadConfigRecord(Buffer := Buffer, Offset := NH_API_HEADER_SIZE + 4, Record := ConfigRecord);
            NhCommandResult := NhApiApplyCopy(SourceRoomId := SourceRoomId, Target := ConfigRecord);
         END_IF;

      NH_API_MSG_SET_ROOM_CONFIG:
         IF PayloadSize = UINT_TO_UDINT(NH_API_CONFIG_RECORD_SIZE) THEN
            NhApiReadConfigRecord(Buffer := Buffer, Offset := NH_API_HEADER_SIZE, Record := ConfigRecord);
            NhCommandResult := NhApiApplyConfig(Record := ConfigRecord);
         END_IF;

      NH_API_MSG_SET_ROOM_STATE:
         IF PayloadSize = UINT_TO_UDINT(NH_API_STATE_RECORD_SIZE) THEN
            NhApiReadStateRecord(Buffer := Buffer, Offset := NH_API_HEADER_SIZE, Record := StateRecord);
            NhCommandResult := NhApiApplyState(Record := StateRecord);
         END_IF;

      ELSE
         NhCommandResult := NH_API_RESULT_UNSUPPORTED;
   END_CASE;

   NhApiCaptureAllChanges();
   NhResultPending := TRUE;
   NhTransactionMode := NH_API_MODE_COMMAND;
   NhApiPublishNextTargetFrame();
   NhApiProcessRx := NhCommandResult = NH_API_RESULT_OK;
END_FUNCTION

FUNCTION NhApiProcessTest : BOOL
   // Applies one WebMaker/debug test action when the global API is free. SK: Vykona jednu WebMaker/debug testovaciu akciu, ked je globalne API volne.
   VAR
      Slot         : USINT;          // Located room slot. SK: Najdeny room slot.
      ConfigRecord : NH_ROOM_CONFIG; // Constructed config record. SK: Zostaveny config zaznam.
      StateRecord  : NH_ROOM_STATE;  // Constructed state record. SK: Zostaveny state zaznam.
   END_VAR
   NhApiProcessTest := FALSE;
   IF NOT NhApiTest.Execute THEN RETURN; END_IF;
   NhApiTest.Finished := FALSE;
   NhCommandResult := NH_API_RESULT_UNSUPPORTED;

   IF NhApiTest.Action = NH_API_TEST_REQUEST_SNAPSHOT THEN
      NhActiveOwnerClientId := 0;
      NhApiStartSnapshot();
      NhTransactionMode := NH_API_MODE_BROADCAST_SNAPSHOT;
      NhCommandResult := NH_API_RESULT_OK;
      NhApiPublishNextBroadcastFrame();
   ELSIF NhApiTest.Action = NH_API_TEST_DELETE_ROOM THEN
      NhCommandResult := NhApiApplyDelete(RoomId := NhApiTest.RoomId);
   ELSIF NhApiTest.Action = NH_API_TEST_SET_STATE THEN
      Slot := NhApiFindRoom(RoomId := NhApiTest.RoomId);
      IF Slot = 0 THEN
         NhCommandResult := NH_API_RESULT_NOT_FOUND;
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
         NhCommandResult := NhApiApplyState(Record := StateRecord);
      END_IF;
   ELSE
      ConfigRecord.Used := TRUE;
      ConfigRecord.RoomId := NhApiTest.RoomId;
      ConfigRecord.Name := NhApiTest.Name;
      ConfigRecord.ProjectName := NhApiTest.ProjectName;
      ConfigRecord.IconId := NhApiTest.IconId;
      ConfigRecord.SortDefault := 0;
      IF NhApiTest.Action = NH_API_TEST_ADD_ROOM THEN
         NhCommandResult := NhApiApplyAdd(Record := ConfigRecord);
      ELSIF NhApiTest.Action = NH_API_TEST_COPY_ROOM THEN
         NhCommandResult := NhApiApplyCopy(SourceRoomId := NhApiTest.SourceRoomId, Target := ConfigRecord);
      ELSIF NhApiTest.Action = NH_API_TEST_SET_CONFIG THEN
         Slot := NhApiFindRoom(RoomId := NhApiTest.RoomId);
         IF Slot = 0 THEN
            NhCommandResult := NH_API_RESULT_NOT_FOUND;
         ELSE
            ConfigRecord.SortDefault := NhRoomsConfig[Slot].SortDefault;
            NhCommandResult := NhApiApplyConfig(Record := ConfigRecord);
         END_IF;
      END_IF;
   END_IF;

   IF (NhApiTest.Action <> NH_API_TEST_REQUEST_SNAPSHOT) AND NhApiCaptureAllChanges() THEN
      NhActiveOwnerClientId := 0;
      NhTransactionMode := NH_API_MODE_BROADCAST_DIFF;
      NhApiPublishNextBroadcastFrame();
   END_IF;
   NhApiTest.ResultCode := NhCommandResult;
   NhApiTest.Execute := FALSE;
   NhApiTest.Finished := TRUE;
   NhApiProcessTest := TRUE;
END_FUNCTION

FUNCTION NhApiCycle : BOOL
   // Executes one deterministic step of the global handshake every PLC cycle. SK: V kazdom PLC cykle vykona jeden deterministicky krok globalneho handshake.
   VAR
      NowMs      : UDINT; // Current PLC system time. SK: Aktualny systemovy cas PLC.
      ClientStep : UINT;  // State value written by the owner. SK: Hodnota State zapisana vlastnikom.
   END_VAR
   NowMs := NhApiSystemTimeMs();
   NhApiInfo.ApiVersion := NH_API_VERSION;

   // Internal ExpectedState is authoritative; a foreign write of State=0 may not abort an active transaction. SK: Interny ExpectedState je autorita; cudzi zapis State=0 nesmie prerusit aktivnu transakciu.
   IF NhExpectedState = NH_API_STATE_IDLE THEN
      NhExpectedState := NH_API_STATE_IDLE;
      NhActiveOwnerClientId := 0;
      NhApiInfo.State := NH_API_STATE_IDLE;
      IF NhApiInfo.OwnerClientId <> 0 THEN
         // The last OwnerClientId visible in this PLC cycle wins the claim. SK: Claim vyhra posledne OwnerClientId viditelne v tomto PLC cykle.
         NhActiveOwnerClientId := NhApiInfo.OwnerClientId;
         NhApiClearBuffer(Buffer := ADR(NhApiRX), Length := NH_API_RX_BYTE_CAPACITY);
         NhTransactionMode := NH_API_MODE_NONE;
         NhExpectedState := NH_API_STATE_OWNER_READY;
         NhTransactionLastMs := NowMs;
         NhApiInfo.State := NH_API_STATE_OWNER_READY;
         NhApiCycle := TRUE;
         RETURN;
      END_IF;

      IF NhApiTest.Execute THEN
         NhApiProcessTest();
         NhApiCycle := TRUE;
         RETURN;
      END_IF;

      IF NhApiCaptureAllChanges() THEN
         NhActiveOwnerClientId := 0;
         NhCommandResult := NH_API_RESULT_OK;
         NhTransactionMode := NH_API_MODE_BROADCAST_DIFF;
         NhApiPublishNextBroadcastFrame();
      END_IF;
      NhApiCycle := TRUE;
      RETURN;
   END_IF;

   IF NhActiveOwnerClientId <> 0 THEN
      IF (NowMs - NhTransactionLastMs) > NH_API_TRANSACTION_TIMEOUT_MS THEN
         NhApiResetTransaction();
         NhApiCycle := TRUE;
         RETURN;
      END_IF;

      // No other client may replace owner or State while this owner holds the transaction. SK: Ziadny iny klient nesmie pocas transakcie nahradit ownera ani State.
      IF NhApiInfo.OwnerClientId <> NhActiveOwnerClientId THEN
         NhApiInfo.OwnerClientId := NhActiveOwnerClientId;
         NhApiInfo.State := NhExpectedState;
         NhApiCycle := TRUE;
         RETURN;
      END_IF;

      IF NhApiInfo.State <> NhExpectedState THEN
         ClientStep := NhApiInfo.State;
         IF ClientStep = (NhExpectedState + 1) THEN
            NhExpectedState := ClientStep;
            NhTransactionLastMs := NowMs;
            IF ClientStep = NH_API_STATE_RX_READY THEN
               NhApiProcessRx();
            ELSIF (ClientStep MOD 2) = 0 THEN
               NhApiPublishNextTargetFrame();
            ELSE
               NhApiInfo.State := NhExpectedState;
            END_IF;
         ELSE
            NhApiInfo.State := NhExpectedState;
         END_IF;
      END_IF;
      NhApiCycle := TRUE;
      RETURN;
   END_IF;

   // OwnerClientId zero means a best-effort PLC broadcast with no per-client ACK. SK: Nulove OwnerClientId znamena best-effort PLC broadcast bez ACK jednotlivych klientov.
   NhApiInfo.OwnerClientId := 0;
   IF NhApiInfo.State <> NhExpectedState THEN NhApiInfo.State := NhExpectedState; END_IF;
   IF (NowMs - NhTransactionLastMs) >= NH_API_BROADCAST_HOLD_MS THEN
      NhApiPublishNextBroadcastFrame();
   END_IF;
   NhApiCycle := TRUE;
END_FUNCTION
