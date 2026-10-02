// Wire-format helpers have no hidden state. SK: Pomocne funkcie wire formatu su bez skryteho stavu.

FUNCTION NhApiNextRevision : UDINT
   // Returns the next nonzero revision. SK: Vrati nasledujucu nenulovu reviziu.
   VAR_INPUT
      Current : UDINT; // Current revision. SK: Aktualna revizia.
   END_VAR
   NhApiNextRevision := Current + 1;
   IF NhApiNextRevision = 0 THEN
      NhApiNextRevision := 1;
   END_IF;
END_FUNCTION

FUNCTION NhApiSystemTimeMs : UDINT
   // Returns the PLC system time in milliseconds. SK: Vrati systemovy cas PLC v milisekundach.
   VAR_EXTERNAL
      AT %SL52 : DWORD; // Absolute PLC system-time register. SK: Absolutny systemovy register casu PLC.
   END_VAR
   NhApiSystemTimeMs := DWORD_TO_UDINT(%SL52);
END_FUNCTION

FUNCTION NhApiWriteByte : BOOL
   // Writes one byte at the specified buffer offset. SK: Zapise jeden bajt na zadany offset buffera.
   VAR_INPUT
      Buffer : PTR_TO BYTE; // Start of the destination buffer. SK: Zaciatok cieloveho buffera.
      Offset : UINT;        // Zero-based byte offset. SK: Nulovy byte offset.
      Value  : BYTE;        // Value to write. SK: Zapisovana hodnota.
   END_VAR
   VAR
      Position : PTR_TO BYTE; // Pointer advanced to the target byte. SK: Pointer posunuty na cielovy bajt.
   END_VAR
   Position := Buffer + UINT_TO_UDINT(Offset);
   Position^ := Value;
   NhApiWriteByte := TRUE;
END_FUNCTION

FUNCTION NhApiReadByte : BYTE
   // Reads one byte from the specified buffer offset. SK: Precita jeden bajt zo zadaneho offsetu buffera.
   VAR_INPUT
      Buffer : PTR_TO BYTE; // Start of the source buffer. SK: Zaciatok zdrojoveho buffera.
      Offset : UINT;        // Zero-based byte offset. SK: Nulovy byte offset.
   END_VAR
   VAR
      Position : PTR_TO BYTE; // Pointer advanced to the source byte. SK: Pointer posunuty na zdrojovy bajt.
   END_VAR
   Position := Buffer + UINT_TO_UDINT(Offset);
   NhApiReadByte := Position^;
END_FUNCTION

FUNCTION NhApiWriteU16 : BOOL
   // Writes a 16-bit value in little-endian format. SK: Zapise 16-bitovu hodnotu vo formate little-endian.
   VAR_INPUT
      Buffer : PTR_TO BYTE; // Destination byte buffer. SK: Cielovy byte buffer.
      Offset : UINT;        // Zero-based byte offset. SK: Nulovy byte offset.
      Value  : UINT;        // Value written little-endian. SK: Hodnota zapisovana little-endian.
   END_VAR
   NhApiWriteByte(Buffer := Buffer, Offset := Offset, Value := WORD_TO_BYTE(UINT_TO_WORD(Value) AND 16#00FF));
   NhApiWriteByte(Buffer := Buffer, Offset := Offset + 1, Value := WORD_TO_BYTE(SHR(UINT_TO_WORD(Value), 8)));
   NhApiWriteU16 := TRUE;
END_FUNCTION

FUNCTION NhApiWriteU32 : BOOL
   // Writes a 32-bit value in little-endian format. SK: Zapise 32-bitovu hodnotu vo formate little-endian.
   VAR_INPUT
      Buffer : PTR_TO BYTE; // Destination byte buffer. SK: Cielovy byte buffer.
      Offset : UINT;        // Zero-based byte offset. SK: Nulovy byte offset.
      Value  : UDINT;       // Value written little-endian. SK: Hodnota zapisovana little-endian.
   END_VAR
   VAR
      Raw : DWORD;          // Bit image of the value. SK: Bitovy obraz hodnoty.
   END_VAR
   Raw := UDINT_TO_DWORD(Value);
   NhApiWriteByte(Buffer := Buffer, Offset := Offset, Value := DWORD_TO_BYTE(Raw AND 16#000000FF));
   NhApiWriteByte(Buffer := Buffer, Offset := Offset + 1, Value := DWORD_TO_BYTE(SHR(Raw, 8) AND 16#000000FF));
   NhApiWriteByte(Buffer := Buffer, Offset := Offset + 2, Value := DWORD_TO_BYTE(SHR(Raw, 16) AND 16#000000FF));
   NhApiWriteByte(Buffer := Buffer, Offset := Offset + 3, Value := DWORD_TO_BYTE(SHR(Raw, 24) AND 16#000000FF));
   NhApiWriteU32 := TRUE;
END_FUNCTION

FUNCTION NhApiReadU16 : UINT
   // Reads a 16-bit value in little-endian format. SK: Precita 16-bitovu hodnotu vo formate little-endian.
   VAR_INPUT
      Buffer : PTR_TO BYTE; // Source byte buffer. SK: Zdrojovy byte buffer.
      Offset : UINT;        // Zero-based byte offset. SK: Nulovy byte offset.
   END_VAR
   NhApiReadU16 := WORD_TO_UINT(BYTE_TO_WORD(NhApiReadByte(Buffer := Buffer, Offset := Offset)) OR
      SHL(BYTE_TO_WORD(NhApiReadByte(Buffer := Buffer, Offset := Offset + 1)), 8));
END_FUNCTION

FUNCTION NhApiReadU32 : UDINT
   // Reads a 32-bit value in little-endian format. SK: Precita 32-bitovu hodnotu vo formate little-endian.
   VAR_INPUT
      Buffer : PTR_TO BYTE; // Source byte buffer. SK: Zdrojovy byte buffer.
      Offset : UINT;        // Zero-based byte offset. SK: Nulovy byte offset.
   END_VAR
   VAR
      Raw : DWORD;          // Reassembled little-endian value. SK: Zlozena little-endian hodnota.
   END_VAR
   Raw := BYTE_TO_DWORD(NhApiReadByte(Buffer := Buffer, Offset := Offset));
   Raw := Raw OR SHL(BYTE_TO_DWORD(NhApiReadByte(Buffer := Buffer, Offset := Offset + 1)), 8);
   Raw := Raw OR SHL(BYTE_TO_DWORD(NhApiReadByte(Buffer := Buffer, Offset := Offset + 2)), 16);
   Raw := Raw OR SHL(BYTE_TO_DWORD(NhApiReadByte(Buffer := Buffer, Offset := Offset + 3)), 24);
   NhApiReadU32 := DWORD_TO_UDINT(Raw);
END_FUNCTION

FUNCTION NhApiWriteReal : BOOL
   // Writes a REAL using its 32-bit image. SK: Zapise REAL pomocou jeho 32-bitoveho obrazu.
   VAR_INPUT
      Buffer : PTR_TO BYTE; // Destination byte buffer. SK: Cielovy byte buffer.
      Offset : UINT;        // Zero-based byte offset. SK: Nulovy byte offset.
      Value  : REAL;        // IEC REAL written by bit image. SK: IEC REAL zapisany bitovo.
   END_VAR
   VAR
      RawPtr : PTR_TO DWORD;// Pointer to the REAL bit image. SK: Pointer na bitovy obraz REAL.
   END_VAR
   RawPtr := ADR(Value);
   NhApiWriteU32(Buffer := Buffer, Offset := Offset, Value := DWORD_TO_UDINT(RawPtr^));
   NhApiWriteReal := TRUE;
END_FUNCTION

FUNCTION NhApiReadReal : REAL
   // Reads a REAL from its 32-bit image. SK: Precita REAL z jeho 32-bitoveho obrazu.
   VAR_INPUT
      Buffer : PTR_TO BYTE; // Source byte buffer. SK: Zdrojovy byte buffer.
      Offset : UINT;        // Zero-based byte offset. SK: Nulovy byte offset.
   END_VAR
   VAR
      ResultPtr : PTR_TO DWORD; // Pointer to the result bit image. SK: Pointer na bitovy obraz vysledku.
   END_VAR
   ResultPtr := ADR(NhApiReadReal);
   ResultPtr^ := UDINT_TO_DWORD(NhApiReadU32(Buffer := Buffer, Offset := Offset));
END_FUNCTION

FUNCTION NhApiFrameCrc32 : DWORD
   // Calculates CRC32 of the valid API frame. SK: Vypocita CRC32 platnej casti API ramca.
   VAR_INPUT
      Buffer : PTR_TO BYTE; // Start of the complete frame. SK: Zaciatok celeho ramca.
      Length : UINT;        // Header plus payload. SK: Hlavicka plus payload.
   END_VAR
   VAR
      Crc       : DWORD;    // Running CRC32 value. SK: PriebeznA CRC32 hodnota.
      Current   : BYTE;     // Current byte; CRC field is treated as zero. SK: Aktualny bajt; CRC pole sa pocita ako nula.
      Index     : UINT;     // Byte index. SK: Index bajtu.
      BitIndex  : USINT;    // Bit index. SK: Index bitu.
   END_VAR
   Crc := 16#FFFFFFFF;
   IF Length > 0 THEN
      FOR Index := 0 TO Length - 1 DO
         IF (Index >= 60) AND (Index <= 63) THEN
            Current := 0;
         ELSE
            Current := NhApiReadByte(Buffer := Buffer, Offset := Index);
         END_IF;
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
   NhApiFrameCrc32 := NOT Crc;
END_FUNCTION

FUNCTION NhApiClearBuffer : BOOL
   // Clears the specified number of buffer bytes. SK: Vynuluje zadany pocet bajtov buffera.
   VAR_INPUT
      Buffer : PTR_TO BYTE; // Buffer to clear. SK: Buffer urceny na vynulovanie.
      Length : UINT;        // Number of bytes. SK: Pocet bajtov.
   END_VAR
   VAR
      Index : UINT;         // Index of the cleared byte. SK: Index nulovaneho bajtu.
   END_VAR
   IF Length > 0 THEN
      FOR Index := 0 TO Length - 1 DO
         NhApiWriteByte(Buffer := Buffer, Offset := Index, Value := 0);
      END_FOR;
   END_IF;
   NhApiClearBuffer := TRUE;
END_FUNCTION

FUNCTION NhApiConfigEqual : BOOL
   // Compares two room configuration records. SK: Porovna dva konfiguracne zaznamy miestnosti.
   VAR_INPUT
      A : NH_ROOM_CONFIG; // First config record. SK: Prvy config zaznam.
      B : NH_ROOM_CONFIG; // Second config record. SK: Druhy config zaznam.
   END_VAR
   NhApiConfigEqual := (A.Used = B.Used) AND (A.RoomId = B.RoomId) AND (A.Name = B.Name) AND
      (A.ProjectName = B.ProjectName) AND (A.IconId = B.IconId) AND (A.SortDefault = B.SortDefault);
END_FUNCTION

FUNCTION NhApiStateEqual : BOOL
   // Compares two dynamic room-state records. SK: Porovna dva dynamicke stavove zaznamy miestnosti.
   VAR_INPUT
      A : NH_ROOM_STATE;  // First state record. SK: Prvy state zaznam.
      B : NH_ROOM_STATE;  // Second state record. SK: Druhy state zaznam.
   END_VAR
   NhApiStateEqual := (A.RoomId = B.RoomId) AND (A.Temperature = B.Temperature) AND
      (A.Humidity = B.Humidity) AND (A.Presence = B.Presence) AND (A.DayPhase = B.DayPhase) AND
      (A.CategoryMask = B.CategoryMask) AND (A.AlarmLevel = B.AlarmLevel) AND
      (A.Online = B.Online) AND (A.Twilight = B.Twilight);
END_FUNCTION

FUNCTION NhApiFindRoom : USINT
   // Finds a room slot by its stable ID. SK: Najde interny slot miestnosti podla stabilneho ID.
   VAR_INPUT
      RoomId : UDINT;       // Stable ID to find. SK: Hladane stabilne ID.
   END_VAR
   VAR
      Index : USINT;        // Index of the scanned slot. SK: Index prehladavaneho slotu.
   END_VAR
   NhApiFindRoom := 0;
   FOR Index := 1 TO NH_API_MAX_ROOMS DO
      IF NhRoomsConfig[Index].Used AND (NhRoomsConfig[Index].RoomId = RoomId) THEN
         NhApiFindRoom := Index;
         RETURN;
      END_IF;
   END_FOR;
END_FUNCTION

FUNCTION NhApiFindFreeRoom : USINT
   // Finds the first free internal room slot. SK: Najde prvy volny interny slot miestnosti.
   VAR
      Index : USINT;        // Index of the scanned slot. SK: Index prehladavaneho slotu.
   END_VAR
   NhApiFindFreeRoom := 0;
   FOR Index := 1 TO NH_API_MAX_ROOMS DO
      IF NOT NhRoomsConfig[Index].Used THEN
         NhApiFindFreeRoom := Index;
         RETURN;
      END_IF;
   END_FOR;
END_FUNCTION

FUNCTION NhApiWriteText64 : BOOL
   // Writes text into a fixed 65-byte wire field. SK: Zapise text do pevneho 65-bajtoveho wire pola.
   VAR_INPUT
      Buffer : PTR_TO BYTE; // Destination wire buffer. SK: Cielovy wire buffer.
      Offset : UINT;        // Offset of length and 64 text bytes. SK: Offset dlzky a 64 bajtov textu.
      Value  : STRING[64];  // UTF-8 bytes stored in the PLC STRING. SK: UTF-8 bajty ulozene v PLC STRING.
   END_VAR
   VAR
      Source : PTR_TO BYTE; // First PLC STRING byte. SK: Prvy bajt PLC STRING.
      Index  : USINT;       // Text byte index. SK: Index textoveho bajtu.
      Count  : USINT;       // Number of actual bytes. SK: Pocet skutocnych bajtov.
   END_VAR
   Count := INT_TO_USINT(LEN(Value));
   IF Count > 64 THEN
      Count := 64;
   END_IF;
   NhApiWriteByte(Buffer := Buffer, Offset := Offset, Value := USINT_TO_BYTE(Count));
   Source := ADR(Value);
   FOR Index := 0 TO 63 DO
      IF Index < Count THEN
         NhApiWriteByte(Buffer := Buffer, Offset := Offset + 1 + USINT_TO_UINT(Index),
            Value := NhApiReadByte(Buffer := Source, Offset := USINT_TO_UINT(Index)));
      ELSE
         NhApiWriteByte(Buffer := Buffer, Offset := Offset + 1 + USINT_TO_UINT(Index), Value := 0);
      END_IF;
   END_FOR;
   NhApiWriteText64 := TRUE;
END_FUNCTION

FUNCTION NhApiReadText64 : STRING[64]
   // Reads text from a fixed 65-byte wire field. SK: Precita text z pevneho 65-bajtoveho wire pola.
   VAR_INPUT
      Buffer : PTR_TO BYTE; // Source wire buffer. SK: Zdrojovy wire buffer.
      Offset : UINT;        // Offset of length and 64 text bytes. SK: Offset dlzky a 64 bajtov textu.
   END_VAR
   VAR
      Destination : PTR_TO BYTE; // First byte of the result PLC STRING. SK: Prvy bajt vysledneho PLC STRING.
      Index       : USINT;       // Text byte index. SK: Index textoveho bajtu.
      Count       : USINT;       // Declared byte count. SK: Deklarovany pocet bajtov.
   END_VAR
   Count := BYTE_TO_USINT(NhApiReadByte(Buffer := Buffer, Offset := Offset));
   IF Count > 64 THEN
      Count := 64;
   END_IF;
   Destination := ADR(NhApiReadText64);
   FOR Index := 0 TO 63 DO
      IF Index < Count THEN
         NhApiWriteByte(Buffer := Destination, Offset := USINT_TO_UINT(Index),
            Value := NhApiReadByte(Buffer := Buffer, Offset := Offset + 1 + USINT_TO_UINT(Index)));
      ELSE
         NhApiWriteByte(Buffer := Destination, Offset := USINT_TO_UINT(Index), Value := 0);
      END_IF;
   END_FOR;
END_FUNCTION

FUNCTION NhApiWriteConfigRecord : BOOL
   // Serializes a room configuration record. SK: Serializuje konfiguracny zaznam miestnosti.
   VAR_INPUT
      Buffer : PTR_TO BYTE;       // Destination wire buffer. SK: Cielovy wire buffer.
      Offset : UINT;              // Record start offset. SK: Offset zaciatku zaznamu.
      Record : NH_ROOM_CONFIG;  // Config record to serialize. SK: Config zaznam na serializaciu.
   END_VAR
   NhApiWriteU32(Buffer := Buffer, Offset := Offset, Value := Record.RoomId);
   NhApiWriteU16(Buffer := Buffer, Offset := Offset + 4, Value := Record.IconId);
   NhApiWriteU16(Buffer := Buffer, Offset := Offset + 6, Value := Record.SortDefault);
   NhApiWriteText64(Buffer := Buffer, Offset := Offset + 8, Value := Record.Name);
   NhApiWriteText64(Buffer := Buffer, Offset := Offset + 73, Value := Record.ProjectName);
   NhApiWriteConfigRecord := TRUE;
END_FUNCTION

FUNCTION NhApiReadConfigRecord : BOOL
   // Deserializes a room configuration record. SK: Deserializuje konfiguracny zaznam miestnosti.
   VAR_INPUT
      Buffer : PTR_TO BYTE;       // Source wire buffer. SK: Zdrojovy wire buffer.
      Offset : UINT;              // Record start offset. SK: Offset zaciatku zaznamu.
   END_VAR
   VAR_IN_OUT
      Record : NH_ROOM_CONFIG;  // Decoded config record. SK: Dekodovany config zaznam.
   END_VAR
   Record.Used := TRUE;
   Record.RoomId := NhApiReadU32(Buffer := Buffer, Offset := Offset);
   Record.IconId := NhApiReadU16(Buffer := Buffer, Offset := Offset + 4);
   Record.SortDefault := NhApiReadU16(Buffer := Buffer, Offset := Offset + 6);
   Record.Name := NhApiReadText64(Buffer := Buffer, Offset := Offset + 8);
   Record.ProjectName := NhApiReadText64(Buffer := Buffer, Offset := Offset + 73);
   NhApiReadConfigRecord := TRUE;
END_FUNCTION

FUNCTION NhApiWriteStateRecord : BOOL
   // Serializes a dynamic room-state record. SK: Serializuje dynamicky stavovy zaznam miestnosti.
   VAR_INPUT
      Buffer : PTR_TO BYTE;       // Destination wire buffer. SK: Cielovy wire buffer.
      Offset : UINT;              // Record start offset. SK: Offset zaciatku zaznamu.
      Record : NH_ROOM_STATE;   // State record to serialize. SK: State zaznam na serializaciu.
   END_VAR
   NhApiWriteU32(Buffer := Buffer, Offset := Offset, Value := Record.RoomId);
   NhApiWriteReal(Buffer := Buffer, Offset := Offset + 4, Value := Record.Temperature);
   NhApiWriteReal(Buffer := Buffer, Offset := Offset + 8, Value := Record.Humidity);
   NhApiWriteByte(Buffer := Buffer, Offset := Offset + 12, Value := BOOL_TO_BYTE(Record.Presence));
   NhApiWriteU16(Buffer := Buffer, Offset := Offset + 13, Value := Record.DayPhase);
   NhApiWriteU32(Buffer := Buffer, Offset := Offset + 15, Value := DWORD_TO_UDINT(Record.CategoryMask));
   NhApiWriteByte(Buffer := Buffer, Offset := Offset + 19, Value := USINT_TO_BYTE(Record.AlarmLevel));
   NhApiWriteByte(Buffer := Buffer, Offset := Offset + 20, Value := BOOL_TO_BYTE(Record.Online));
   NhApiWriteByte(Buffer := Buffer, Offset := Offset + 21, Value := BOOL_TO_BYTE(Record.Twilight));
   NhApiWriteStateRecord := TRUE;
END_FUNCTION

FUNCTION NhApiReadStateRecord : BOOL
   // Deserializes a dynamic room-state record. SK: Deserializuje dynamicky stavovy zaznam miestnosti.
   VAR_INPUT
      Buffer : PTR_TO BYTE;       // Source wire buffer. SK: Zdrojovy wire buffer.
      Offset : UINT;              // Record start offset. SK: Offset zaciatku zaznamu.
   END_VAR
   VAR_IN_OUT
      Record : NH_ROOM_STATE;   // Decoded state record. SK: Dekodovany state zaznam.
   END_VAR
   Record.RoomId := NhApiReadU32(Buffer := Buffer, Offset := Offset);
   Record.Temperature := NhApiReadReal(Buffer := Buffer, Offset := Offset + 4);
   Record.Humidity := NhApiReadReal(Buffer := Buffer, Offset := Offset + 8);
   Record.Presence := NhApiReadByte(Buffer := Buffer, Offset := Offset + 12) <> 0;
   Record.DayPhase := NhApiReadU16(Buffer := Buffer, Offset := Offset + 13);
   Record.CategoryMask := UDINT_TO_DWORD(NhApiReadU32(Buffer := Buffer, Offset := Offset + 15));
   Record.AlarmLevel := BYTE_TO_USINT(NhApiReadByte(Buffer := Buffer, Offset := Offset + 19));
   Record.Online := NhApiReadByte(Buffer := Buffer, Offset := Offset + 20) <> 0;
   Record.Twilight := NhApiReadByte(Buffer := Buffer, Offset := Offset + 21) <> 0;
   NhApiReadStateRecord := TRUE;
END_FUNCTION
