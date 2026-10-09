VAR_GLOBAL
  RxPath        : STRING[80] := '//RAM/rx.json';  // Zdrojov˝ s˙bor prijatÈho JSON ; Source file containing received JSON
  RxLogPath     : STRING[80] := '//RAM/rx.log';   // S˙bor meranÌ importu ; Import measurement log file
  RxParser      : fbJsonFileParser;               // Parser s˙borovÈho JSON ; File-based JSON parser
  RxInfo        : TJsonInfo;                      // Aktu·lna poloûka vr·ten· parserom ; Current item returned by the parser
  RxTmp         : ARRAY[0.._NH_RAM] OF BYTE;      // Pracovn· kÛpia d·t pred potvrdenÌm do mRam ; Staging copy before committing data to mRam
  RxLeafSeen    : ARRAY[1..SCH_LEAF_N] OF BOOL;   // PrÌznaky uû naËÌtan˝ch povinn˝ch polÌ ; Flags for required fields already read
  RxSt          : USINT := 0;                     // Stavov˝ automat importu ; Import state-machine state
  RxRqSeen      : UDINT := 0;                     // Posledn· poûiadavka uû spracovan· PLC ; Latest request already processed by the PLC
  RxRqW         : UDINT := 0;                     // »Ìslo pr·ve sprac˙vanej poûiadavky ; Request number currently being processed
  RxWorkErr     : USINT := 0;                     // Pracovn˝ kÛd chyby importu ; Working import error code
  RxErrTxt      : STRING[80] := '';               // Textov˝ opis poslednej chyby ; Text description of the latest error
  RxLastName    : STRING[255] := '';              // N·zov poslednej poloûky JSON ; Name of the latest JSON item
  RxCfW         : USINT := 0;                     // Typ vybran˝ pre aktu·lny import ; Type selected for the current import
  RxTypeW       : STRING[4] := '';                // KÛd typu uveden˝ v ob·lke JSON ; Type code supplied in the JSON envelope
  RxFrom        : UDINT := 0;                     // Prv· importovan· veta ; First record to import
  RxTo          : UDINT := 0;                     // Posledn· importovan· veta ; Last record to import
  RxCount       : UDINT := 0;                     // OËak·van˝ poËet importovan˝ch viet ; Expected number of imported records
  RxFileRq      : UDINT := 0;                     // »Ìslo poûiadavky zapÌsanÈ v JSON ; Request number stored in the JSON file
  RxHdrCf       : BOOL := FALSE;                  // PrÌznak naËÌtania typu v ob·lke ; Flag indicating the type was read from the envelope
  RxHdrType     : BOOL := FALSE;                  // PrÌznak naËÌtania kÛdu typu ; Flag indicating the type code was read
  RxHdrFrom     : BOOL := FALSE;                  // PrÌznak naËÌtania zaËiatku rozsahu ; Flag indicating the range start was read
  RxHdrTo       : BOOL := FALSE;                  // PrÌznak naËÌtania konca rozsahu ; Flag indicating the range end was read
  RxHdrCount    : BOOL := FALSE;                  // PrÌznak naËÌtania poËtu viet ; Flag indicating the record count was read
  RxPrepared    : BOOL := FALSE;                  // TRUE po prÌprave pracovnej kÛpie ; TRUE after the staging copy is prepared
  RxHaveRec     : BOOL := FALSE;                  // TRUE, keÔ sa pr·ve sprac˙va veta ; TRUE while a record is being processed
  RxIdx         : UINT := 0;                      // Index aktu·lnej poloûky parsera ; Index of the current parser item
  RxRecCur      : UDINT := 0;                     // »Ìslo pr·ve sprac˙vanej vety ; Number of the record currently being processed
  RxFieldsCur   : UINT := 0;                      // PoËet polÌ naËÌtan˝ch v aktu·lnej vete ; Fields read in the current record
  RxFieldsDone  : UDINT := 0;                     // Celkov˝ poËet ˙speöne naËÌtan˝ch polÌ ; Total number of fields read successfully
  RxRecordsDone : UDINT := 0;                     // Celkov˝ poËet ˙speöne naËÌtan˝ch viet ; Total number of records read successfully
  RxStageBytes  : UDINT := 0;                     // Veækosù pracovnej kÛpie v bajtoch ; Staging-copy size in bytes
  RxMs0         : UDINT := 0;                     // »as zaËiatku importu v milisekund·ch ; Import start time in milliseconds
  RxMs1         : UDINT := 0;                     // »as konca importu v milisekund·ch ; Import end time in milliseconds
  RxDur         : UDINT := 0;                     // Trvanie importu v milisekund·ch ; Import duration in milliseconds
  RxCyc         : UDINT := 0;                     // PoËÌtadlo cyklov PLC ; PLC-cycle counter
  RxCyc0        : UDINT := 0;                     // PoËÌtadlo cyklov pri ötarte importu ; PLC-cycle count at import start
  RxCycN        : UDINT := 0;                     // PoËet cyklov spotrebovan˝ch importom ; Number of cycles used by the import
  RxCommitted   : BOOL := FALSE;
END_VAR

// Po naËÌtanÌ hlaviËky pripravÌ kÛpiu z·znamov v pomocnej pam‰ti. ; Prepare a record copy in staging memory after reading the envelope.
// OverÌ hlaviËku a rozsah a skopÌruje pÙvodnÈ vety do pomocnej pam‰te. ; Validate the header and range, then copy the existing records to staging memory.
// Validuje identitu typu, ËÌslovanie viet a veækosù staging priestoru eöte pred zmenou d·t. ; Validate type identity, record numbering, and staging capacity before changing data.
FUNCTION RxPrepare : BOOL
  VAR
    Copied : UDINT;  // PoËet bajtov skopÌrovan˝ch do pracovnej pam‰te ; Number of bytes copied to staging memory
  END_VAR
  RxPrepare := FALSE;
  IF RxPrepared THEN RxPrepare := TRUE; RETURN; END_IF;
  IF NOT RxHdrCf OR NOT RxHdrType OR NOT RxHdrFrom OR NOT RxHdrTo OR NOT RxHdrCount THEN
    RxWorkErr := 3; RxErrTxt := 'Incomplete header'; RETURN;
  END_IF;
  IF RxFileRq <> RxRqW THEN
    RxWorkErr := 3; RxErrTxt := 'Request number mismatch'; RETURN;
  END_IF;
  IF (RxCfW < 1) OR (RxCfW > UINT_TO_USINT(SCH_DEF_N)) THEN
    RxWorkErr := 3; RxErrTxt := 'Invalid cf'; RETURN;
  END_IF;
  IF RxTypeW <> aSch[RxCfW].Code THEN
    RxWorkErr := 3; RxErrTxt := 'Type does not match cf'; RETURN;
  END_IF;
  IF (RxFrom < 1) OR (RxTo < RxFrom) OR (RxTo > aCfg[RxCfW].Rec) OR
     (RxCount <> RxTo - RxFrom + 1) THEN
    RxWorkErr := 3; RxErrTxt := 'Invalid record range'; RETURN;
  END_IF;
  RxStageBytes := RxCount * aSch[RxCfW].Siz;
  IF (RxStageBytes = 0) OR (RxStageBytes > SIZEOF(RxTmp)) THEN
    RxWorkErr := 3; RxErrTxt := 'Staging buffer too small'; RETURN;
  END_IF;
  Copied := MemCpyPtr(  // VytvorÌ pracovn˙ kÛpiu pÙvodnÈho rozsahu ; ne˙pln˝ alebo chybn˝ JSON tak nemenÌ mRam. ; Create a working copy of the original range so incomplete or invalid JSON cannot alter mRam.
    source := UDINT_TO_PTR(aCfg[RxCfW].Ram + (RxFrom - 1) * aSch[RxCfW].Siz),
    dest := ADR(RxTmp[0]), length := RxStageBytes);
  IF Copied <> RxStageBytes THEN RxWorkErr := 7; RxErrTxt := 'Staging copy failed'; RETURN; END_IF;
  RxPrepared := TRUE;
  RxPrepare := TRUE;
END_FUNCTION

// Prevedie jednu hodnotu JSON na PLC typ a uloûÌ ju do pomocnej pam‰te. ; Convert one JSON value to its PLC type and store it in staging memory.
// Prevedie skal·rnu hodnotu JSON na typ a rozloûenie urËenÈ schÈmou. ; Convert a JSON scalar to the type and layout specified by the schema.
// Kaûd˝ typ sa prevedie oddelene ; BOOL menÌ iba prÌsluön˝ bit a STRING sa konvertuje do CP1250. ; Convert each type explicitly ; BOOL updates one bit and STRING is converted to CP1250.
FUNCTION RxSetValue : BOOL
  VAR_INPUT
    Lf    : UINT;         // Index cieæovÈho poæa v schÈme ; Target leaf-field index in the schema
    Pos   : UDINT;        // Adresa alebo pozÌcia hodnoty v pracovnej pam‰ti ; Address or position of the value in staging memory
    Value : STRING[255];  // Hodnota naËÌtan· z JSON parsera ; Value read from the JSON parser
  END_VAR
  VAR
    Tmp    : STRING[255];   // Pracovn· hodnota poËas typovej konverzie ; Temporary value during type conversion
    N      : UDINT;         // PoËet bajtov skopÌrovan˝ch alebo zapÌsan˝ch ; Number of bytes copied or written
    U      : UINT;          // Medziv˝sledok prevodu na celÈ ËÌslo bez znamienka ; Intermediate unsigned-integer conversion value
    Mask   : UINT;          // Maska pre nastavenie alebo kontrolu bitu ; Mask used to set or check a bit
    I      : SINT;          // Index bajtu alebo prvku poæa ; Byte or array-element index
    BitMax : SINT;          // PoËet platn˝ch bitov poæa BOOL ; Number of valid BOOL-array bits
    PB     : PTR_TO BYTE;   // Ukazovateæ na bajt cieæovej hodnoty ; Pointer to a byte of the target value
    PS     : PTR_TO SINT;   // Ukazovateæ na hodnotu typu SINT ; Pointer to a SINT value
    PU     : PTR_TO USINT;  // Ukazovateæ na hodnotu typu USINT ; Pointer to a USINT value
    PI     : PTR_TO INT;    // Ukazovateæ na hodnotu typu INT ; Pointer to an INT value
    PUI    : PTR_TO UINT;   // Ukazovateæ na hodnotu typu UINT ; Pointer to a UINT value
    PDI    : PTR_TO DINT;   // Ukazovateæ na hodnotu typu DINT ; Pointer to a DINT value
    PUD    : PTR_TO UDINT;  // Ukazovateæ na hodnotu typu UDINT ; Pointer to a UDINT value
    PW     : PTR_TO WORD;   // Ukazovateæ na hodnotu typu WORD ; Pointer to a WORD value
    PDW    : PTR_TO DWORD;  // Ukazovateæ na hodnotu typu DWORD ; Pointer to a DWORD value
    PR     : PTR_TO REAL;   // Ukazovateæ na hodnotu typu REAL ; Pointer to a REAL value
    PLR    : PTR_TO LREAL;  // Ukazovateæ na hodnotu typu LREAL ; Pointer to an LREAL value
    PT     : PTR_TO TIME;   // Ukazovateæ na hodnotu typu TIME ; Pointer to a TIME value
    PDate  : PTR_TO DATE;   // Ukazovateæ na hodnotu typu DATE ; Pointer to a DATE value
    PTod   : PTR_TO TOD;    // Ukazovateæ na hodnotu typu TOD ; Pointer to a TOD value
    PDT    : PTR_TO DT;     // Ukazovateæ na hodnotu typu DT ; Pointer to a DT value
  END_VAR
  RxSetValue := FALSE;
  IF (Lf < 1) OR (Lf > SCH_LEAF_N) OR (Pos = 0) THEN
    RxWorkErr := 6; RxErrTxt := 'Invalid leaf address'; RETURN;
  END_IF;
  Tmp := Value;
  PB := UDINT_TO_PTR(Pos);
  // Konverzia vych·dza z typu poæa v tabuæke schÈmy, nie z odhadu klienta. ; Conversion uses the field type from the schema table, not a client-side guess.
  CASE aLeaf[Lf].Tag OF
    SCH_BOOL:
      IF (Tmp <> 'true') AND (Tmp <> 'false') AND (Tmp <> '1') AND (Tmp <> '0') THEN
        RxWorkErr := 6; RxErrTxt := 'Invalid BOOL'; RETURN;
      END_IF;
      Mask := 1;
      BitMax := aLeaf[Lf].BitPos;
      FOR I := 1 TO BitMax DO Mask := Mask * 2; END_FOR;
      U := BYTE_TO_UINT(PB^);
      IF (Tmp = 'true') OR (Tmp = '1') THEN
        IF (U / Mask) MOD 2 = 0 THEN PB^ := UDINT_TO_BYTE(UINT_TO_UDINT(U + Mask)); END_IF;
      ELSE
        IF (U / Mask) MOD 2 = 1 THEN PB^ := UDINT_TO_BYTE(UINT_TO_UDINT(U - Mask)); END_IF;
      END_IF;
    SCH_SINT: PS := UDINT_TO_PTR(Pos); PS^ := STRING_TO_SINT(Tmp);
    SCH_USINT: PU := UDINT_TO_PTR(Pos); PU^ := STRING_TO_USINT(Tmp);
    SCH_INT: PI := UDINT_TO_PTR(Pos); PI^ := STRING_TO_INT(Tmp);
    SCH_UINT: PUI := UDINT_TO_PTR(Pos); PUI^ := STRING_TO_UINT(Tmp);
    SCH_DINT: PDI := UDINT_TO_PTR(Pos); PDI^ := STRING_TO_DINT(Tmp);
    SCH_UDINT: PUD := UDINT_TO_PTR(Pos); PUD^ := STRING_TO_UDINT(Tmp);
    SCH_BYTE: PB := UDINT_TO_PTR(Pos); PB^ := UDINT_TO_BYTE(STRING_TO_UDINT(Tmp));
    SCH_WORD: PW := UDINT_TO_PTR(Pos); PW^ := UDINT_TO_WORD(STRING_TO_UDINT(Tmp));
    SCH_DWORD: PDW := UDINT_TO_PTR(Pos); PDW^ := UDINT_TO_DWORD(STRING_TO_UDINT(Tmp));
    SCH_REAL: PR := UDINT_TO_PTR(Pos); PR^ := STRING_TO_REAL_EX(Tmp);
    SCH_LREAL: PLR := UDINT_TO_PTR(Pos); PLR^ := STRING_TO_LREAL_EX(Tmp);
    SCH_STRING:
      U := UTF8_TO_CP125x(str := Tmp, codePage := 1250);
      IF UINT_TO_UDINT(U) >= UINT_TO_UDINT(aLeaf[Lf].Span) THEN
        RxWorkErr := 6; RxErrTxt := 'STRING too long'; RETURN;
      END_IF;
      MemsetPtr(dest := PB, val := 0, length := aLeaf[Lf].Span);
      N := MemCpyPtr(source := ADR(Tmp), dest := PB, length := UINT_TO_UDINT(U) + 1);
      IF N <> UINT_TO_UDINT(U) + 1 THEN RxWorkErr := 6; RxErrTxt := 'STRING copy failed'; RETURN; END_IF;
    SCH_TIME: PT := UDINT_TO_PTR(Pos); PT^ := STRING_TO_TIME(Tmp);
    SCH_DATE: PDate := UDINT_TO_PTR(Pos); PDate^ := STRING_TO_DATE(Tmp);
    SCH_TIME_OF_DAY: PTod := UDINT_TO_PTR(Pos); PTod^ := STRING_TO_TOD(Tmp);
    SCH_DATE_AND_TIME: PDT := UDINT_TO_PTR(Pos); PDT^ := STRING_TO_DT(Tmp);
    ELSE RxWorkErr := 6; RxErrTxt := 'Unsupported type'; RETURN;
  END_CASE;
  RxSetValue := TRUE;
END_FUNCTION

// ZapÌöe priebeh, poËty polÌ, chybu a Ëas importu do rx.log. ; Write import progress, field counts, errors, and timing to rx.log.
FUNCTION RxWriteLog : BOOL
  VAR
    Hnd    : HANDLE;        // Handle otvorenÈho s˙boru logu ; Handle of the open log file
    Line   : STRING[255];   // Pripravovan˝ riadok logu ; Log line being prepared
    Closed : BOOL;          // V˝sledok uzatvorenia s˙boru ; Result of closing the file
    Ok     : BOOL := TRUE;  // PrÌznak ˙speönÈho dokonËenia kroku ; Flag indicating the step completed successfully
  END_VAR
  RxWriteLog := FALSE;
  Hnd := FileOpen(fileName := RxLogPath, mode := F_WRITE);
  IF Hnd = INVALID_HANDLE_VALUE THEN RETURN; END_IF;
  Line := CONCAT('api_V12 RX import', TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('file=RAM/rx.json', TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('request=', UDINT_TO_STRING(RxRqW), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('file_rq=', UDINT_TO_STRING(RxFileRq), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('cf=', USINT_TO_STRING(RxCfW), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('type=', RxTypeW, TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('from=', UDINT_TO_STRING(RxFrom), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('to=', UDINT_TO_STRING(RxTo), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('records=', UDINT_TO_STRING(RxCount), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('records_done=', UDINT_TO_STRING(RxRecordsDone), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('fields_done=', UDINT_TO_STRING(RxFieldsDone), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('file_bytes=', UDINT_TO_STRING(RxParser.fileSize), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('processed_bytes=', UDINT_TO_STRING(RxParser.processed), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('last_item=', RxLastName, TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('staged_bytes=', UDINT_TO_STRING(RxStageBytes), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('start_ms=', UDINT_TO_STRING(RxMs0), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('end_ms=', UDINT_TO_STRING(RxMs1), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('duration_ms=', UDINT_TO_STRING(RxDur), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('plc_cycles=', UDINT_TO_STRING(RxCycN), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('committed=', BOOL_TO_STRING(RxCommitted), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  IF RxWorkErr = 0 THEN Line := CONCAT('result=OK', TxCRLF);
  ELSE Line := CONCAT('result=ERROR', TxCRLF);
  END_IF;
  Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('error=', USINT_TO_STRING(RxWorkErr), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('error_text=', RxErrTxt, TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Closed := FileClose(hFile := Hnd);
  RxWriteLog := Ok AND Closed;
END_FUNCTION

// Spracuje jednu poloûku parsera JSON: hlaviËku, ËÌslo vety alebo hodnotu poæa. ; Process one JSON parser item: header, record number, or field value.
// Porovn· n·zvy JSON s presnou cestou schÈmy a odmieta nezn·me alebo duplicitnÈ polia. ; Match JSON names against schema paths and reject unknown or duplicate fields.
FUNCTION RxProcessItem : BOOL
  VAR
    Name     : STRING[255];  // N·zov pr·ve sprac˙vanej poloûky JSON ; Name of the JSON item currently being processed
    Value    : STRING[255];  // Hodnota naËÌtan· z JSON parsera ; Value read from the JSON parser
    Expected : STRING[255];  // OËak·van˝ n·zov nasleduj˙ceho poæa ; Expected name of the next field
    NextIdx  : UINT;         // Index nasleduj˙cej poloûky parsera ; Index of the next parser item
    Lf       : UINT;         // Index cieæovÈho poæa v schÈme ; Target leaf-field index in the schema
    LastLf   : UINT;         // Posledn˝ index poæa v schÈme typu ; Last leaf-field index for the type
    Pos      : UDINT;        // Adresa alebo pozÌcia hodnoty v pracovnej pam‰ti ; Address or position of the value in staging memory
    Found    : BOOL;         // PrÌznak n·jdenia poæa v schÈme ; Flag indicating that the field was found in the schema
  END_VAR
  RxProcessItem := FALSE;
  Name := RxInfo.item.name;
  Value := RxInfo.item.value;
  RxLastName := Name;

  IF Name = 'rq' THEN RxFileRq := STRING_TO_UDINT(Value); RxProcessItem := TRUE; RETURN; END_IF;
  IF Name = 'cf' THEN RxCfW := STRING_TO_USINT(Value); RxHdrCf := TRUE; RxProcessItem := TRUE; RETURN; END_IF;
  IF Name = 'type' THEN RxTypeW := Value; RxHdrType := TRUE; RxProcessItem := TRUE; RETURN; END_IF;
  IF Name = 'from' THEN RxFrom := STRING_TO_UDINT(Value); RxHdrFrom := TRUE; RxProcessItem := TRUE; RETURN; END_IF;
  IF Name = 'to' THEN RxTo := STRING_TO_UDINT(Value); RxHdrTo := TRUE; RxProcessItem := TRUE; RETURN; END_IF;
  IF Name = 'count' THEN RxCount := STRING_TO_UDINT(Value); RxHdrCount := TRUE; RxProcessItem := TRUE; RETURN; END_IF;

  NextIdx := RxIdx;
  IF RxHaveRec THEN NextIdx := RxIdx + 1; END_IF;
  Expected := CONCAT('data[', UINT_TO_STRING(NextIdx), '].rec');
  // ZaËiatok novej vety uzavrie predch·dzaj˙cu a overÌ jej ˙plnosù. ; A new record marker closes the previous record and checks its completeness.
  IF Name = Expected THEN
    IF RxHaveRec THEN
      IF RxFieldsCur <> aSch[RxCfW].LCnt THEN RxWorkErr := 4; RxErrTxt := 'Missing fields in record'; RETURN; END_IF;
      RxRecordsDone := RxRecordsDone + 1;
      RxIdx := NextIdx;
    ELSE
      IF NOT RxPrepare() THEN RETURN; END_IF;
      RxIdx := 0;
    END_IF;
    IF RxIdx >= UDINT_TO_UINT(RxCount) THEN RxWorkErr := 4; RxErrTxt := 'Too many records'; RETURN; END_IF;
    RxRecCur := STRING_TO_UDINT(Value);
    IF RxRecCur <> RxFrom + UINT_TO_UDINT(RxIdx) THEN RxWorkErr := 4; RxErrTxt := 'Record number mismatch'; RETURN; END_IF;
    FOR Lf := 1 TO SCH_LEAF_N DO RxLeafSeen[Lf] := FALSE; END_FOR;
    RxFieldsCur := 0;
    RxHaveRec := TRUE;
    RxProcessItem := TRUE;
    RETURN;
  END_IF;

  IF NOT RxHaveRec OR NOT RxPrepared THEN RxWorkErr := 4; RxErrTxt := 'Data before record header'; RETURN; END_IF;
  LastLf := aSch[RxCfW].LFst + aSch[RxCfW].LCnt - 1;
  // Hæad· presn˙ cestu poæa v rozsahu listov vybranej schÈmy. ; Search for the exact field path within the selected schema's leaf range.
  FOR Lf := aSch[RxCfW].LFst TO LastLf DO
    Expected := CONCAT('data[', UINT_TO_STRING(RxIdx), '].value.', aLeaf[Lf].Pth);
    IF Name = Expected THEN
      Found := TRUE;
      IF RxLeafSeen[Lf] THEN RxWorkErr := 5; RxErrTxt := 'Duplicate field'; RETURN; END_IF;
      Pos := PTR_TO_UDINT(ADR(RxTmp[0])) + (RxRecCur - RxFrom) * aSch[RxCfW].Siz + UINT_TO_UDINT(aLeaf[Lf].Ofs);
      IF Pos + UINT_TO_UDINT(aLeaf[Lf].Span) > PTR_TO_UDINT(ADR(RxTmp[0])) + RxStageBytes THEN
        RxWorkErr := 6; RxErrTxt := 'Field outside staging'; RETURN;
      END_IF;
      IF NOT RxSetValue(Lf := Lf, Pos := Pos, Value := Value) THEN RETURN; END_IF;
      RxLeafSeen[Lf] := TRUE;
      RxFieldsCur := RxFieldsCur + 1;
      RxFieldsDone := RxFieldsDone + 1;
      RxProcessItem := TRUE;
      RETURN;
    END_IF;
  END_FOR;
  IF NOT Found THEN RxWorkErr := 5; RxErrTxt := 'Unknown JSON field'; END_IF;
END_FUNCTION

// Skontroluje ˙plnosù importu a aû potom prenesie pripravenÈ d·ta do mRam. ; Verify import completeness and only then copy staged data into mRam.
// Commit do mRam nastane aû po kontrole poslednej vety a vöetk˝ch povinn˝ch polÌ. ; Commit to mRam occurs only after checking the last record and all required fields.
FUNCTION RxEnd : BOOL
  VAR
    Copied : UDINT;  // PoËet bajtov skopÌrovan˝ch do pracovnej pam‰te ; Number of bytes copied to staging memory
    LogOk  : BOOL;   // V˝sledok z·pisu meracieho logu ; Result of writing the measurement log
  END_VAR
  RxCommitted := FALSE;
  IF RxWorkErr = 0 THEN
    IF NOT RxPrepared OR NOT RxHaveRec OR (RxFieldsCur <> aSch[RxCfW].LCnt) THEN
      RxWorkErr := 4; RxErrTxt := 'Incomplete final record';
    ELSE
      RxRecordsDone := RxRecordsDone + 1;
      IF RxRecordsDone <> RxCount THEN RxWorkErr := 4; RxErrTxt := 'Record count mismatch'; END_IF;
    END_IF;
  END_IF;
  IF RxWorkErr = 0 THEN
    Copied := MemCpyPtr(source := ADR(RxTmp[0]),
      dest := UDINT_TO_PTR(aCfg[RxCfW].Ram + (RxFrom - 1) * aSch[RxCfW].Siz),
      length := RxStageBytes);
    IF Copied <> RxStageBytes THEN RxWorkErr := 7; RxErrTxt := 'mRam commit failed';
    ELSE RxCommitted := TRUE;
    END_IF;
  END_IF;
  RxMs1 := TxClockMs();
  RxDur := RxMs1 - RxMs0;
  RxCycN := RxCyc - RxCyc0 + 1;
  LogOk := RxWriteLog();
  IF (RxWorkErr = 0) AND NOT LogOk THEN RxWorkErr := 8; RxErrTxt := 'rx.log write failed'; END_IF;
  RxErr := RxWorkErr;
  RxDone := RxRqW;
  RxSt := 0;
  RxEnd := RxWorkErr = 0;
END_FUNCTION

// Vynuluje stav jednej poûiadavky importu a spustÌ parser. ; Reset one import request's state and start the parser.
// Vynuluje poËÌtadl· a prÌznaky, aby sa poûiadavky navz·jom nekontaminovali. ; Reset counters and flags so requests cannot contaminate one another.
FUNCTION RxStart : BOOL
  VAR
    Lf : UINT;  // Index cieæovÈho poæa v schÈme ; Target leaf-field index in the schema
  END_VAR
  RxRqW := RxRq;
  RxWorkErr := 0;
  RxErrTxt := '';
  RxLastName := '';
  RxCfW := 0;
  RxTypeW := '';
  RxFrom := 0;
  RxTo := 0;
  RxCount := 0;
  RxFileRq := 0;
  RxHdrCf := FALSE;
  RxHdrType := FALSE;
  RxHdrFrom := FALSE;
  RxHdrTo := FALSE;
  RxHdrCount := FALSE;
  RxPrepared := FALSE;
  RxHaveRec := FALSE;
  RxIdx := 0;
  RxRecCur := 0;
  RxFieldsCur := 0;
  RxFieldsDone := 0;
  RxRecordsDone := 0;
  RxStageBytes := 0;
  RxCommitted := FALSE;
  RxMs0 := TxClockMs();
  RxCyc0 := RxCyc;
  RxErr := 1;
  FOR Lf := 1 TO SCH_LEAF_N DO RxLeafSeen[Lf] := FALSE; END_FOR;
  RxSt := 1;
  RxStart := TRUE;
END_FUNCTION

// Stavov˝ automat parsovania, valid·cie a potvrdenia rx.json. ; State machine for parsing, validating, and acknowledging rx.json.
// Kaûd˝ cyklus posunie parser ; dokonËen· poloûka sa spracuje a EOF uzavrie poûiadavku. ; Advance the parser each cycle ; process completed items and finish the request at EOF.
FUNCTION RxCycle : BOOL
  VAR
    Ok : BOOL;  // PrÌznak ˙speönÈho dokonËenia kroku ; Flag indicating the step completed successfully
  END_VAR
  RxCyc := RxCyc + 1;
  RxCycle := TRUE;
  IF RxSt = 0 THEN
    RxParser(exec := FALSE, fileName := RxPath, JsonInfo := RxInfo);
    IF (RxRq = 0) OR (RxRq = RxRqSeen) THEN RETURN; END_IF;
    RxRqSeen := RxRq;
    // Po blokovom prenose povoæ import aû po zloûenÌ a overenÌ celÈho s˙boru. ; After block transfer, allow import only when the complete file is assembled and validated.
    IF (RbRq <> 0) AND NOT RbReady THEN
      RxErr := 9;
      RxDone := RxRq;
      RETURN;
    END_IF;
    RxCycle := RxStart();
    RETURN;
  END_IF;

  IF RxSt <> 1 THEN RxWorkErr := 1; RxErrTxt := 'Invalid RX state'; RxCycle := RxEnd(); RETURN; END_IF;
  RxParser(exec := TRUE, fileName := RxPath, JsonInfo := RxInfo);
  IF RxParser.done THEN
    IF NOT RxProcessItem() THEN RxCycle := RxEnd(); RETURN; END_IF;
  END_IF;
  IF RxParser.err THEN
    RxWorkErr := 2;
    RxErrTxt := RxParser.errTxt;
    RxCycle := RxEnd();
    RETURN;
  END_IF;
  IF RxParser.eof THEN
    Ok := RxEnd();
    RxCycle := Ok;
  END_IF;
END_FUNCTION
