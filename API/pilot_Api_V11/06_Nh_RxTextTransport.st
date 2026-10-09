// Legacy RX prototype. PLCComS STRING-length capability is verified separately.

VAR_GLOBAL
   NhRxText        {PUBLIC_API} : ARRAY[0..4] OF STRING[80];
   NhRxTextCommit  {PUBLIC_API} : UDINT := 0;
   NhRxTextStatus  {PUBLIC_API} : USINT := 0; // 0 idle/OK, 1 invalid Base64, 2 invalid decoded length.
   NhRxTextBytes   {PUBLIC_API} : UINT := 0;
   NhRxLastCommit               : UDINT := 0;
END_VAR

FUNCTION NhBase64Value : INT
   VAR_INPUT
      Character : BYTE;
   END_VAR
   IF (Character >= 65) AND (Character <= 90) THEN
      NhBase64Value := BYTE_TO_INT(Character) - 65;
   ELSIF (Character >= 97) AND (Character <= 122) THEN
      NhBase64Value := BYTE_TO_INT(Character) - 71;
   ELSIF (Character >= 48) AND (Character <= 57) THEN
      NhBase64Value := BYTE_TO_INT(Character) + 4;
   ELSIF Character = 43 THEN
      NhBase64Value := 62;
   ELSIF Character = 47 THEN
      NhBase64Value := 63;
   ELSIF Character = 61 THEN
      NhBase64Value := -2; // '=' padding
   ELSE
      NhBase64Value := -1;
   END_IF;
END_FUNCTION

FUNCTION NhDecodeBase64Chunk : INT
   VAR_INPUT
      Text       : STRING[80];
      DestOffset : UINT;
   END_VAR
   VAR
      Source     : PTR_TO BYTE;
      Target     : PTR_TO BYTE;
      TextLength : UINT;
      Index      : UINT;
      Written    : UINT;
      V0         : INT;
      V1         : INT;
      V2         : INT;
      V3         : INT;
   END_VAR

   NhDecodeBase64Chunk := -1;
   TextLength := INT_TO_UINT(LEN(Text));
   IF TextLength = 0 THEN NhDecodeBase64Chunk := 0; RETURN; END_IF;
   IF (TextLength MOD 4) <> 0 THEN RETURN; END_IF;
   Source := ADR(Text);
   Target := ADR(NhApiRX) + UINT_TO_UDINT(DestOffset);
   Index := 0;
   Written := 0;

   WHILE Index < TextLength DO
      V0 := NhBase64Value(Character := Source^); Source := Source + 1;
      V1 := NhBase64Value(Character := Source^); Source := Source + 1;
      V2 := NhBase64Value(Character := Source^); Source := Source + 1;
      V3 := NhBase64Value(Character := Source^); Source := Source + 1;
      IF (V0 < 0) OR (V1 < 0) OR (V2 = -1) OR (V3 = -1) THEN RETURN; END_IF;
      IF (DestOffset + Written) >= NH_API_RX_BYTE_CAPACITY THEN RETURN; END_IF;
      Target^ := INT_TO_BYTE((V0 * 4) + (V1 / 16)); Target := Target + 1; Written := Written + 1;
      IF V2 >= 0 THEN
         IF (DestOffset + Written) >= NH_API_RX_BYTE_CAPACITY THEN RETURN; END_IF;
         Target^ := INT_TO_BYTE(((V1 MOD 16) * 16) + (V2 / 4)); Target := Target + 1; Written := Written + 1;
         IF V3 >= 0 THEN
            IF (DestOffset + Written) >= NH_API_RX_BYTE_CAPACITY THEN RETURN; END_IF;
            Target^ := INT_TO_BYTE(((V2 MOD 4) * 64) + V3); Target := Target + 1; Written := Written + 1;
         ELSIF Index + 4 <> TextLength THEN RETURN;
         END_IF;
      ELSIF (V3 <> -2) OR (Index + 4 <> TextLength) THEN RETURN;
      END_IF;
      Index := Index + 4;
   END_WHILE;
   NhDecodeBase64Chunk := UINT_TO_INT(Written);
END_FUNCTION

FUNCTION NhRxTextTransportCycle : BOOL
   VAR
      ChunkIndex : UINT;
      Decoded     : INT;
      Total       : UINT;
      FrameLength : UDINT;
   END_VAR

   NhRxTextTransportCycle := TRUE;
   IF (NhApiInfo.State <> NH_API_STATE_OWNER_READY) OR
      (NhRxTextCommit = 0) OR
      (NhRxTextCommit <> NhApiInfo.OwnerClientId) OR
      (NhRxTextCommit = NhRxLastCommit) THEN RETURN;
   END_IF;

   NhApiClearBuffer(Buffer := ADR(NhApiRX), Length := NH_API_RX_BYTE_CAPACITY);
   Total := 0;
   FOR ChunkIndex := 0 TO 4 DO
      Decoded := NhDecodeBase64Chunk(Text := NhRxText[ChunkIndex], DestOffset := Total);
      IF Decoded < 0 THEN NhRxTextStatus := 1; RETURN; END_IF;
      Total := Total + INT_TO_UINT(Decoded);
   END_FOR;

   IF Total < NH_API_HEADER_SIZE THEN NhRxTextStatus := 2; RETURN; END_IF;
   FrameLength := NhApiReadU32(Buffer := ADR(NhApiRX), Offset := 28);
   IF (FrameLength <> UINT_TO_UDINT(Total)) OR (FrameLength > UINT_TO_UDINT(NH_API_RX_BYTE_CAPACITY)) THEN
      NhRxTextStatus := 2;
      RETURN;
   END_IF;

   NhRxTextBytes := Total;
   NhRxTextStatus := 0;
   NhRxLastCommit := NhRxTextCommit;
   NhApiInfo.State := NH_API_STATE_RX_READY;
END_FUNCTION
