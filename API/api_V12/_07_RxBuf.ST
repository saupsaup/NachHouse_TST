// Limity jedného prijímacieho bloku a celého súboru ; Limits for one receive block and the complete file.
VAR_GLOBAL CONSTANT
  RB_BYTES {HIDDEN}    : UINT := 256;     // Maximálny poèet dátovıch bajtov v jednom bloku ; Maximum data bytes in one block.
  RB_FILE_MAX {HIDDEN} : UDINT := 65535;  // Maximálna ve¾kos súboru, ktorı mono zloi ; Maximum size of a file that can be assembled.
END_VAR

VAR_GLOBAL
  RbSeen     : UDINT := 0;            // Posledná poiadavka bloku u prijatá PLC ; Most recent block request already consumed by the PLC.
  RbActive   : BOOL := FALSE;         // TRUE poèas skladania viacerıch blokov jedného súboru ; TRUE while assembling a file from multiple blocks.
  RbTotalW   : UDINT := 0;            // Oèakávaná celková dåka aktuálneho súboru ; Expected total length of the current file.
  RbCrcW     : DWORD := 0;            // Oèakávanı CRC32 súèet aktuálneho súboru ; Expected CRC32 checksum for the current file.
  RbCrcState : DWORD := 16#FFFFFFFF;  // Medzistav vıpoètu CRC32 medzi prijatımi blokmi ; Running CRC32 state across received blocks.
END_VAR

// Jeden krok štandardného CRC32 pre jeden bajt ; polynóm je 0xEDB88320. ; One standard CRC32 step for a byte ; the polynomial is 0xEDB88320.
// Pridá jeden bajt do priebeného vıpoètu CRC32 ; Add one byte to the running CRC32 calculation.
FUNCTION RbCrcByte : DWORD
  VAR_INPUT
    State : DWORD;  // Doterajší priebenı stav CRC ; Previous running CRC state.
    B     : BYTE;   // Bajt, ktorı sa pridáva do CRC ; Byte to add to the CRC.
  END_VAR
  VAR
    C : DWORD;  // Pracovnı 32-bitovı stav CRC ; Working 32-bit CRC value.
    I : USINT;  // Poèet ôsmich bitovıch krokov jedného bajtu ; Counter for the eight bit steps of one byte.
  END_VAR
  C := State XOR BYTE_TO_DWORD(B);
  FOR I := 1 TO 8 DO
    IF (C AND 16#00000001) <> 0 THEN
      C := SHR(C, 1) XOR 16#EDB88320;
    ELSE
      C := SHR(C, 1);
    END_IF;
  END_FOR;
  RbCrcByte := C;
END_FUNCTION

// Kadé nové RbRq spracuje jeden blok ; RbAck potvrdí spracovanie a RbErr vısledok. ; Each new RbRq processes one block ; RbAck acknowledges it and RbErr reports the result.
// RbReady sa nastaví a po kontrole ve¾kosti a CRC celého súboru. ; RbReady is set only after validating the full file size and CRC.
// Pri novej RbRq zapíše jeden blok do rx.json, priebene poèíta CRC a potvrdí vısledok ; On a new RbRq, write one block to rx.json, update CRC, and acknowledge the result.
FUNCTION RbCycle : BOOL
  VAR
    Hnd      : HANDLE;       // Otvorenı súborovı handle pre zápis bloku ; File handle used to write the block.
    Mode     : TF_MODE;      // Reim otvorenia: novı súbor alebo pripojenie ïalšieho bloku ; Open mode: create a file or append the next block.
    N        : UDINT;        // Poèet bajtov, ktoré FileWrite skutoène zapísal ; Number of bytes actually written by FileWrite.
    I        : UINT;         // Index bajtu pri aktualizácii CRC ; Byte index while updating the CRC.
    PB       : PTR_TO BYTE;  // Ukazovate¾ na postupné èítanie bajtov z rxBuf ; Pointer used to read bytes sequentially from rxBuf.
    Closed   : BOOL;         // Vısledok uzatvorenia súboru po zápise ; Result of closing the file after writing.
    FinalCrc : DWORD;        // Dokonèenı CRC32 súèet po spracovaní posledného bajtu ; Final CRC32 value after the last byte.
  END_VAR
  RbCycle := TRUE;
  // Bez nového èísla poiadavky sa blok nespracúva znova ; Do not process a block again without a new request number.
  IF (RbRq = 0) OR (RbRq = RbSeen) THEN RETURN; END_IF;
  RbSeen := RbRq;
  RbErr := 0;

  // Poèas parsovania JSON-u sa ïalší blok odmietne, aby sa súbor nemenil pod parserom ; Reject a new block while JSON parsing is active so the file cannot change underneath the parser.
  IF RxSt <> 0 THEN RbErr := 10;
  ELSIF (RbLen = 0) OR (RbLen > RB_BYTES) THEN RbErr := 1;
  ELSIF (RbTotal = 0) OR (RbTotal > RB_FILE_MAX) THEN RbErr := 2;
  ELSIF RbOfs > RbTotal THEN RbErr := 3;
  ELSIF UINT_TO_UDINT(RbLen) > RbTotal - RbOfs THEN RbErr := 3;
  END_IF;

  // Pokraèuje iba po úspešnıch kontrolách dåky a rozsahu ; Continue only after length and range validation succeeds.
  IF RbErr = 0 THEN
    IF RbOfs = 0 THEN
      RbActive := TRUE;
      RbReady := FALSE;
      RbWrote := 0;
      RbTotalW := RbTotal;
      RbCrcW := RbCrc;
      RbCrcState := 16#FFFFFFFF;
      Mode := F_WRITE;
    ELSE
      Mode := F_APPEND;
      IF NOT RbActive THEN RbErr := 4;
      ELSIF RbOfs <> RbWrote THEN RbErr := 5;
      ELSIF (RbTotal <> RbTotalW) OR (RbCrc <> RbCrcW) THEN RbErr := 6;
      END_IF;
    END_IF;
  END_IF;

  // Pokraèuje iba po úspešnıch kontrolách dåky a rozsahu ; Continue only after length and range validation succeeds.
  IF RbErr = 0 THEN
    Hnd := FileOpen(fileName := RxPath, mode := Mode);  // Otvorí rx.json na prvı zápis alebo doplnenie bloku ; Open rx.json for the first write or for appending a block.
    IF Hnd = INVALID_HANDLE_VALUE THEN
      RbErr := 7;
      RbActive := FALSE;
    ELSE
      N := FileWrite(hFile := Hnd, adrBuf := PTR_TO_UDINT(ADR(rxBuf[0])),
                     size := UINT_TO_UDINT(RbLen));
      Closed := FileClose(hFile := Hnd);
      IF (N <> UINT_TO_UDINT(RbLen)) OR NOT Closed THEN
        RbErr := 8;
        RbActive := FALSE;
      ELSE
        PB := ADR(rxBuf[0]);  // Zaène kontrolnı súèet od prvého bajtu aktuálneho bloku ; Start checksum calculation at the first byte of this block.
        FOR I := 1 TO RbLen DO
          RbCrcState := RbCrcByte(State := RbCrcState, B := PB^);
          PB := UDINT_TO_PTR(PTR_TO_UDINT(PB) + 1);
        END_FOR;
        RbWrote := RbWrote + UINT_TO_UDINT(RbLen);
        // Po prijatí deklarovaného poètu bajtov overí CRC celého súboru ; Once the declared byte count arrives, verify the complete-file CRC.
        IF RbWrote = RbTotalW THEN
          FinalCrc := RbCrcState XOR 16#FFFFFFFF;
          IF FinalCrc = RbCrcW THEN
            RbReady := TRUE;
          ELSE
            RbErr := 9;
          END_IF;
          RbActive := FALSE;
        END_IF;
      END_IF;
    END_IF;
  END_IF;

  RbAck := RbRq;  // Potvrdí spracovanie aj prípadnú chybu tohto bloku ; Acknowledge processing, including any block error.
  RbCycle := RbErr = 0;
END_FUNCTION
