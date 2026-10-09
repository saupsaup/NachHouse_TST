// NachHouse outbound transport pilot for CP-2000.
// The production protocol is binary NHAP; no PLCComS or TecoApi is used here.

VAR_GLOBAL
   NhConnectEnable        {PUBLIC_API} : BOOL := FALSE;
   NhConnectSendTest      {PUBLIC_API} : BOOL := FALSE;
   NhConnectConnected     {PUBLIC_API} : BOOL := FALSE;
   NhConnectReceived      {PUBLIC_API} : BOOL := FALSE;
   NhConnectError         {PUBLIC_API} : BOOL := FALSE;
   NhConnectRxLength      {PUBLIC_API} : UINT := 0;
   NhConnectSentBytes     {PUBLIC_API} : UDINT := 0;
   NhConnectReceivedBytes {PUBLIC_API} : UDINT := 0;
   NhConnectTestCounter   {PUBLIC_API} : UDINT := 0;
   NhConnectFrameCounter  {PUBLIC_API} : UDINT := 0;
   NhConnectCommandCounter {PUBLIC_API} : UDINT := 0;
   NhConnectRejectedCounter {PUBLIC_API} : UDINT := 0;
   NhConnectLastError     {PUBLIC_API} : STRING[80];
   NhConnectUrl           {PUBLIC_API} : STRING[255] := 'ws://192.168.33.113:18080/plc/load-800';
   NhConnectHeader        {PUBLIC_API} : STRING[80] := 'Authorization: Bearer local-test-token$0D$0A';
END_VAR

FUNCTION NhConnectCrc32 : DWORD
   VAR_INPUT
      Buffer : PTR_TO BYTE;
      Length : UINT;
   END_VAR
   VAR
      Crc : DWORD;
      Current : BYTE;
      Index : UINT;
      BitIndex : USINT;
   END_VAR
   Crc := 16#FFFFFFFF;
   IF Length > 0 THEN
      FOR Index := 0 TO Length - 1 DO
         Current := NhApiReadByte(Buffer := Buffer, Offset := Index);
         Crc := Crc XOR BYTE_TO_DWORD(Current);
         FOR BitIndex := 0 TO 7 DO
            IF (Crc AND 16#00000001) <> 0 THEN
               Crc := SHR(Crc, 1) XOR 16#EDB88320;
            ELSE
               Crc := SHR(Crc, 1);
            END_IF;
         END_FOR;
      END_FOR;
   END_IF;
   NhConnectCrc32 := NOT Crc;
END_FUNCTION

FUNCTION_BLOCK fbNhConnectPilot
   VAR_INPUT
      Enable : BOOL;
      SendTest : BOOL;
      ServerUrl : STRING[255];
      OptionalHeader : STRING[80];
   END_VAR
   VAR_OUTPUT
      Connected : BOOL;
      Received : BOOL;
      Error : BOOL;
      RxLength : UINT;
      SentBytes : UDINT;
      ReceivedBytes : UDINT;
      LastError : STRING[80];
   END_VAR
   VAR
      Socket : fbWebSocketClient;
      SendBuffer : ARRAY[1..MAX_LEN_WS_BUFFER] OF USINT;
      ReceiveBuffer : ARRAY[1..MAX_LEN_WS_BUFFER] OF USINT;
      SendEdge : R_TRIG;
      RequestSend : BOOL;
      ReceivePulse : BOOL;
      ReceiveLength : UINT;
      Index : UINT;
      LastPublishedFrameId : UDINT;
      FrameActive : BOOL;
      SendPhase : BOOL;
      FrameLength : UINT;
      FrameChecksum : DWORD;
      ChunkIndex : UINT;
      ChunkCount : UINT;
      ChunkOffset : UINT;
      ChunkLength : UINT;
      SourcePtr : PTR_TO BYTE;
      PendingCommand : ARRAY[0..255] OF BYTE;
      CommandPending : BOOL;
      CommandCommitted : BOOL;
      CommandLength : UINT;
      CommandOwner : UDINT;
      IncomingPayloadLength : UINT;
      IncomingChecksum : DWORD;
   END_VAR

   RequestSend := FALSE;
   SendEdge(CLK := SendTest);

   IF NOT Enable THEN
      FrameActive := FALSE;
      SendPhase := FALSE;
      LastPublishedFrameId := NhPublishedFrameId;
      CommandPending := FALSE;
      CommandCommitted := FALSE;
   END_IF;

   // Commit one received command through the existing V11 owner handshake.
   IF Enable AND CommandPending THEN
      IF NOT CommandCommitted AND (NhApiInfo.State = NH_API_STATE_OWNER_READY) AND
         (NhApiInfo.OwnerClientId = CommandOwner) THEN
         MemcpyPtr(Source := ADR(PendingCommand), Dest := ADR(NhApiRX), Length := UINT_TO_UDINT(CommandLength));
         NhApiInfo.State := NH_API_STATE_RX_READY;
         CommandCommitted := TRUE;
      ELSIF CommandCommitted AND (NhApiInfo.State = NH_API_STATE_IDLE) THEN
         CommandPending := FALSE;
         CommandCommitted := FALSE;
      END_IF;
   END_IF;

   // Capture every new V11 application frame and wrap it in NHAP Connect chunks.
   IF Enable AND Socket.isConnected AND NOT FrameActive AND
      (NhPublishedFrameId <> 0) AND (NhPublishedFrameId <> LastPublishedFrameId) THEN
      FrameLength := UDINT_TO_UINT(NhApiReadU32(Buffer := ADR(NhApiTX), Offset := 28));
      IF (FrameLength >= NH_API_HEADER_SIZE) AND (FrameLength <= NH_API_TX_BYTE_CAPACITY) THEN
         FrameChecksum := NhConnectCrc32(Buffer := ADR(NhApiTX), Length := FrameLength);
         ChunkCount := (FrameLength + 1407) / 1408;
         ChunkIndex := 0;
         FrameActive := TRUE;
         SendPhase := FALSE;
      ELSE
         LastPublishedFrameId := NhPublishedFrameId;
      END_IF;
   END_IF;

   IF Enable AND Socket.isConnected AND FrameActive AND NOT SendPhase THEN
      ChunkOffset := ChunkIndex * 1408;
      ChunkLength := FrameLength - ChunkOffset;
      IF ChunkLength > 1408 THEN ChunkLength := 1408; END_IF;

      NhApiWriteByte(Buffer := ADR(SendBuffer), Offset := 0, Value := 16#4E);
      NhApiWriteByte(Buffer := ADR(SendBuffer), Offset := 1, Value := 16#48);
      NhApiWriteByte(Buffer := ADR(SendBuffer), Offset := 2, Value := 16#41);
      NhApiWriteByte(Buffer := ADR(SendBuffer), Offset := 3, Value := 16#50);
      NhApiWriteByte(Buffer := ADR(SendBuffer), Offset := 4, Value := 1);
      NhApiWriteByte(Buffer := ADR(SendBuffer), Offset := 5, Value := 12); // V11 application frame
      NhApiWriteByte(Buffer := ADR(SendBuffer), Offset := 6, Value := BOOL_TO_BYTE(ChunkCount > 1));
      NhApiWriteByte(Buffer := ADR(SendBuffer), Offset := 7, Value := 32);
      NhApiWriteU32(Buffer := ADR(SendBuffer), Offset := 8, Value := NhPublishedFrameId);
      NhApiWriteU32(Buffer := ADR(SendBuffer), Offset := 12, Value := NhPublishedFrameId);
      NhApiWriteU16(Buffer := ADR(SendBuffer), Offset := 16, Value := ChunkIndex);
      NhApiWriteU16(Buffer := ADR(SendBuffer), Offset := 18, Value := ChunkCount);
      NhApiWriteU16(Buffer := ADR(SendBuffer), Offset := 20, Value := ChunkLength);
      NhApiWriteU16(Buffer := ADR(SendBuffer), Offset := 22, Value := 0);
      NhApiWriteU32(Buffer := ADR(SendBuffer), Offset := 24, Value := UINT_TO_UDINT(FrameLength));
      NhApiWriteU32(Buffer := ADR(SendBuffer), Offset := 28, Value := DWORD_TO_UDINT(FrameChecksum));
      SourcePtr := ADR(NhApiTX) + UINT_TO_UDINT(ChunkOffset);
      MemcpyPtr(Source := SourcePtr, Dest := ADR(SendBuffer[33]), Length := UINT_TO_UDINT(ChunkLength));
      RequestSend := TRUE;
      SendPhase := TRUE;
      NhConnectFrameCounter := NhConnectFrameCounter + 1;
   ELSIF FrameActive AND SendPhase THEN
      SendPhase := FALSE;
      ChunkIndex := ChunkIndex + 1;
      IF ChunkIndex >= ChunkCount THEN
         LastPublishedFrameId := NhPublishedFrameId;
         FrameActive := FALSE;
         // A targeted V11 response is acknowledged only after its last physical chunk was sent.
         IF (NhActiveOwnerClientId <> 0) AND ((NhApiInfo.State MOD 2) = 1) THEN
            NhApiInfo.State := NhApiInfo.State + 1;
         END_IF;
      END_IF;
   END_IF;

   IF Enable AND Socket.isConnected AND NOT FrameActive AND SendEdge.Q THEN
      // Minimal NHAP v1 HEARTBEAT frame. Header is 32 bytes, payload is empty.
      SendBuffer[1] := 16#4E; // N
      SendBuffer[2] := 16#48; // H
      SendBuffer[3] := 16#41; // A
      SendBuffer[4] := 16#50; // P
      SendBuffer[5] := 1;
      SendBuffer[6] := 30;
      SendBuffer[7] := 0;
      SendBuffer[8] := 32;
      NhConnectTestCounter := NhConnectTestCounter + 1;
      MemcpyPtr(Source := ADR(NhConnectTestCounter), Dest := ADR(SendBuffer[9]), Length := 4);
      FOR Index := 13 TO 32 DO
         SendBuffer[Index] := 0;
      END_FOR;
      SendBuffer[19] := 1;
      SendBuffer[20] := 0;
      RequestSend := TRUE;
   END_IF;

   Socket(
      rqConnect := Enable,
      serverUrl := ServerUrl,
      wsOptHeader := OptionalHeader,
      textMode := FALSE,
      pingTime := T#20s,
      rqSend := RequestSend,
      lenSend := SEL(FrameActive, 32, ChunkLength + 32),
      logSizeKB := 0,
      logMode := ONE_TIME_LOG,
      logFileName := 'NH_CONNECT.LOG',
      sendBuf := void(SendBuffer),
      recvBuf := void(ReceiveBuffer),
      isRecv => ReceivePulse,
      lenRecv => ReceiveLength
   );

   Connected := Socket.isConnected;
   Received := ReceivePulse;
   Error := Socket.isError;
   RxLength := ReceiveLength;
   SentBytes := Socket.sumaSend;
   ReceivedBytes := Socket.sumaRecv;
   LastError := Socket.lastErrDesc;

   // Commands are at most 256 bytes, therefore one physical WebSocket frame is sufficient.
   IF Enable AND ReceivePulse AND NOT CommandPending THEN
      IncomingPayloadLength := NhApiReadU16(Buffer := ADR(ReceiveBuffer), Offset := 20);
      IncomingChecksum := UDINT_TO_DWORD(NhApiReadU32(Buffer := ADR(ReceiveBuffer), Offset := 28));
      IF (ReceiveLength >= 72) AND
         (NhApiReadU32(Buffer := ADR(ReceiveBuffer), Offset := 0) = DWORD_TO_UDINT(NH_API_MAGIC)) AND
         (NhApiReadByte(Buffer := ADR(ReceiveBuffer), Offset := 4) = 1) AND
         (NhApiReadByte(Buffer := ADR(ReceiveBuffer), Offset := 5) = 20) AND
         (NhApiReadByte(Buffer := ADR(ReceiveBuffer), Offset := 7) = 32) AND
         (NhApiReadU16(Buffer := ADR(ReceiveBuffer), Offset := 16) = 0) AND
         (NhApiReadU16(Buffer := ADR(ReceiveBuffer), Offset := 18) = 1) AND
         (IncomingPayloadLength >= NH_API_HEADER_SIZE) AND
         (IncomingPayloadLength <= NH_API_RX_BYTE_CAPACITY) AND
         (ReceiveLength = IncomingPayloadLength + 32) AND
         (NhApiReadU32(Buffer := ADR(ReceiveBuffer), Offset := 24) = UINT_TO_UDINT(IncomingPayloadLength)) AND
         (NhConnectCrc32(Buffer := ADR(ReceiveBuffer[33]), Length := IncomingPayloadLength) = IncomingChecksum) THEN
         CommandOwner := NhApiReadU32(Buffer := ADR(ReceiveBuffer[33]), Offset := 12);
         IF (CommandOwner <> 0) AND (NhApiInfo.State = NH_API_STATE_IDLE) THEN
            CommandLength := IncomingPayloadLength;
            MemcpyPtr(Source := ADR(ReceiveBuffer[33]), Dest := ADR(PendingCommand), Length := UINT_TO_UDINT(CommandLength));
            CommandPending := TRUE;
            CommandCommitted := FALSE;
            NhApiInfo.OwnerClientId := CommandOwner;
            NhConnectCommandCounter := NhConnectCommandCounter + 1;
         ELSE
            NhConnectRejectedCounter := NhConnectRejectedCounter + 1;
         END_IF;
      ELSE
         NhConnectRejectedCounter := NhConnectRejectedCounter + 1;
      END_IF;
   END_IF;
END_FUNCTION_BLOCK

