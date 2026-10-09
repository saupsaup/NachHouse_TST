VAR_GLOBAL
  TxPath    : STRING[80] := '//RAM/tx.json';     // Cie¾ový súbor exportovaného JSON ; Destination file for exported JSON
  TxLogPath : STRING[80] := '//RAM/tx.log';      // Súbor meraní exportu ; Export measurement log file
  TxCRLF    : STRING[2] := '$0D$0A';             // Koniec riadka používaný v súbore ; Line ending used in the file
  TxH       : HANDLE := INVALID_HANDLE_VALUE;    // Handle otvoreného exportného súboru ; Handle of the open export file
  TxSeen    : UDINT := 0;                        // Posledná požiadavka už spracovaná PLC ; Latest request already processed by the PLC
  TxWorkErr : USINT := 0;                        // Pracovný kód chyby exportu ; Working export error code
  TxBytes   : UDINT := 0;                        // Poèet bajtov zapísaných do súboru ; Number of bytes written to the file
  TxHex     : STRING[16] := '0123456789ABCDEF';  // Tabu¾ka èíslic na zápis hexadecimálnych hodnôt ; Digit table for hexadecimal output
  TxSt      : USINT := 0;                        // Stavový automat exportu ; Export state-machine state
  TxCfW     : USINT := 0;                        // Typ vybraný pre aktuálny export ; Type selected for the current export
  TxFrom    : UDINT := 0;                        // Prvé èíslo exportovanej vety ; First record number to export
  TxTo      : UDINT := 0;                        // Posledné èíslo exportovanej vety ; Last record number to export
  TxNow     : UDINT := 0;                        // Èíslo vety spracúvanej teraz ; Record number currently being processed
  TxRqW     : UDINT := 0;                        // Èíslo požiadavky aktuálneho exportu ; Request number for the current export
  TxMode    : USINT := 0;                        // Režim výberu viet ; Record-selection mode ; 1=one, 2=range, 3=all
  TxMs0     : UDINT := 0;                        // Èas zaèiatku exportu v milisekundách ; Export start time in milliseconds
  TxMs1     : UDINT := 0;                        // Èas konca exportu v milisekundách ; Export end time in milliseconds
  TxDur     : UDINT := 0;                        // Trvanie exportu v milisekundách ; Export duration in milliseconds
  TxCyc     : UDINT := 0;                        // Poèítadlo cyklov PLC ; PLC-cycle counter
  TxCyc0    : UDINT := 0;                        // Poèítadlo cyklov pri štarte exportu ; PLC-cycle count at export start
  TxCycN    : UDINT := 0;                        // Poèet cyklov spotrebovaných exportom ; Number of cycles used by the export
  TxDoneN   : UDINT := 0;                        // Poèet dokonèených viet ; Number of completed records
END_VAR

// Zapíše ¾ubovo¾ný úsek pamäte do otvoreného JSON súboru a kontroluje poèet bajtov. ; Write a raw memory span to the open JSON file and verify the byte count.
FUNCTION TxWriteRaw : BOOL
  VAR_INPUT
    Pos : UDINT;  // Zaèiatoèná adresa alebo offset zapisovaných dát ; Start address or offset of the data being written
    Siz : UDINT;  // Poèet bajtov zapisovaného úseku ; Number of bytes in the section being written
  END_VAR
  VAR
    N : UDINT;  // Poèet bajtov skutoène zapísaných funkciou ; Number of bytes actually written by the function
  END_VAR
  TxWriteRaw := FALSE;
  IF Siz = 0 THEN TxWriteRaw := TRUE; RETURN; END_IF;
  N := FileWrite(hFile := TxH, adrBuf := Pos, size := Siz);
  TxBytes := TxBytes + N;
  IF N <> Siz THEN TxWorkErr := 3; RETURN; END_IF;
  TxWriteRaw := TRUE;
END_FUNCTION

// Zapíše textový reazec do exportného súboru. ; Write a text string to the export file.
FUNCTION TxWrite : BOOL
  VAR_INPUT
    Text : STRING[255];  // Textový obsah zapisovaný do JSON ; Text content being written to JSON
  END_VAR
  TxWrite := TxWriteRaw(Pos := PTR_TO_UDINT(ADR(Text)), Siz := INT_TO_UDINT(LEN(Text)));
END_FUNCTION

// Zapíše text medzi úvodzovky JSON. ; Write text enclosed in JSON quotes.
FUNCTION TxWriteQuoted : BOOL
  VAR_INPUT
    Text : STRING[255];  // Textový obsah zapisovaný do JSON ; Text content being written to JSON
  END_VAR
  TxWriteQuoted := FALSE;
  IF NOT TxWrite(Text := '"') THEN RETURN; END_IF;
  IF NOT TxWrite(Text := Text) THEN RETURN; END_IF;
  IF NOT TxWrite(Text := '"') THEN RETURN; END_IF;
  TxWriteQuoted := TRUE;
END_FUNCTION

// Prevedie reazec PLC z CP1250 na UTF-8 a escapuje riadiace znaky JSON. ; Convert the PLC string from CP1250 to UTF-8 and escape JSON control characters.
// Prevedie PLC reazec na korektný UTF-8 reazec JSON. ; Convert a PLC string into valid UTF-8 JSON text.
// Skopíruje pevný úsek PLC STRING, prevedie CP1250 na UTF-8 a zaène JSON reazec. ; Copy a fixed PLC STRING span, convert CP1250 to UTF-8, and open a JSON string.
FUNCTION TxWriteString : BOOL
  VAR_INPUT
    Pos  : UDINT;  // Zaèiatoèná adresa alebo offset zapisovaných dát ; Start address or offset of the data being written
    Span : UINT;   // Ve¾kos hodnoty pod¾a schémy ; Value size from the schema
  END_VAR
  VAR
    Cp  : STRING[255];  // Poèet bajtov v PLC reazci ; Number of bytes in the PLC string
    Utf : STRING[255];  // Reazec po prevode do UTF-8 ; String after conversion to UTF-8
    Src : PTR_TO BYTE;  // Ukazovate¾ na zdrojové bajty ; Pointer to the source bytes
    P   : PTR_TO BYTE;  // Pracovný ukazovate¾ na hodnotu ; Working pointer to the value
    H   : PTR_TO BYTE;  // Hexadecimálna èíslica ; Hexadecimal digit
    Q   : PTR_TO BYTE;  // Pracovný znak pri escapovaní JSON ; Working character during JSON escaping
    B   : BYTE;         // Pracovný bajt hodnoty ; Working value byte
    N   : UDINT;        // Poèet bajtov skutoène zapísaných funkciou ; Number of bytes actually written by the function
    I   : UINT;         // Index opakovania alebo po¾a ; Loop or array index
    J   : UINT;         // Druhý index vnoreného prechodu ; Secondary index for nested traversal
  END_VAR
  TxWriteString := FALSE;
  IF (Span = 0) OR (Span > SIZEOF(Cp)) THEN TxWorkErr := 7; RETURN; END_IF;
  Cp := '';
  Utf := '';
  Src := UDINT_TO_PTR(Pos);
  N := MemCpyPtr(source := Src, dest := ADR(Cp), length := UINT_TO_UDINT(Span));
  IF N <> UINT_TO_UDINT(Span) THEN TxWorkErr := 7; RETURN; END_IF;
  N := CP1250_TO_UTF8(cp1250 := Cp, utf8 := Utf, maxLen := 255);
  IF (Cp <> '') AND (N = 0) THEN TxWorkErr := 7; RETURN; END_IF;
  IF NOT TxWrite(Text := '"') THEN RETURN; END_IF;
  P := ADR(Utf);
  H := ADR(TxHex);
  // Každý UTF-8 bajt zapíše priamo alebo ho escapuje pod¾a pravidiel JSON. ; Write each UTF-8 byte directly or escape it according to JSON rules.
  FOR I := 1 TO INT_TO_UINT(LEN(Utf)) DO
    B := P^;
    CASE B OF
      8:  IF NOT TxWrite(Text := '\b') THEN RETURN; END_IF;
      9:  IF NOT TxWrite(Text := '\t') THEN RETURN; END_IF;
      10: IF NOT TxWrite(Text := '\n') THEN RETURN; END_IF;
      12: IF NOT TxWrite(Text := '\f') THEN RETURN; END_IF;
      13: IF NOT TxWrite(Text := '\r') THEN RETURN; END_IF;
      34: IF NOT TxWrite(Text := '\"') THEN RETURN; END_IF;
      92: IF NOT TxWrite(Text := '\\') THEN RETURN; END_IF;
      ELSE
        IF B < 32 THEN
          IF NOT TxWrite(Text := '\u00') THEN RETURN; END_IF;
          Q := H;
          J := 0;
          WHILE J < BYTE_TO_UINT(B) / 16 DO Q := Q + 1; J := J + 1; END_WHILE;
          IF NOT TxWriteRaw(Pos := PTR_TO_UDINT(Q), Siz := 1) THEN RETURN; END_IF;
          Q := H;
          J := 0;
          WHILE J < BYTE_TO_UINT(B) MOD 16 DO Q := Q + 1; J := J + 1; END_WHILE;
          IF NOT TxWriteRaw(Pos := PTR_TO_UDINT(Q), Siz := 1) THEN RETURN; END_IF;
        ELSE
          IF NOT TxWriteRaw(Pos := PTR_TO_UDINT(P), Siz := 1) THEN RETURN; END_IF;
        END_IF;
    END_CASE;
    P := P + 1;
  END_FOR;
  IF NOT TxWrite(Text := '"') THEN RETURN; END_IF;
  TxWriteString := TRUE;
END_FUNCTION

// Naèíta jednu hodnotu pod¾a typu v schéme a zapíše ju do JSON. ; Read one value according to its schema type and write it to JSON.
// Schéma dodá typ a adresu ; nižšie sa hodnota preèíta cez ukazovate¾ správneho typu. ; The schema supplies type and address ; the value is read through a correctly typed pointer.
FUNCTION TxWriteValue : BOOL
  VAR_INPUT
    Parent : UDINT;  // Adresa rodièovskej štruktúry v mRam ; Address of the parent structure in mRam
    Nd     : UINT;   // Index uzla aktuálnej položky schémy ; Schema-node index of the current field
    El     : INT;    // Index prvku po¾a ; Array element index
  END_VAR
  VAR
    ValAdr : UDINT;         // Adresa hodnoty v mRam ; Address of the value in mRam
    Tag    : USINT;         // Základný typ hodnoty ; Base type of the value
    BitPos : SINT;          // Pozícia BOOL v bajte ; BOOL bit position within its byte
    Mask   : UINT;          // Maska na vyèítanie jedného BOOL bitu ; Mask used to read one BOOL bit
    I      : SINT;          // Index opakovania alebo po¾a ; Loop or array index
    Text   : STRING[255];   // Textový obsah zapisovaný do JSON ; Text content being written to JSON
    PB     : PTR_TO BYTE;
    PS     : PTR_TO SINT;
    PU     : PTR_TO USINT;
    PI     : PTR_TO INT;
    PUI    : PTR_TO UINT;
    PDI    : PTR_TO DINT;
    PUD    : PTR_TO UDINT;
    PW     : PTR_TO WORD;
    PDW    : PTR_TO DWORD;
    PR     : PTR_TO REAL;
    PLR    : PTR_TO LREAL;
    PT     : PTR_TO TIME;
    PDate  : PTR_TO DATE;
    PTod   : PTR_TO TOD;
    PDT    : PTR_TO DT;
  END_VAR
  TxWriteValue := FALSE;
  ValAdr := SchAdr(Parent := Parent, Nd := Nd, El := El);
  IF ValAdr = 0 THEN TxWorkErr := 6; RETURN; END_IF;
  Tag := aNode[Nd].Tag MOD SCH_ARRAY;

  // Vyberie prevod pod¾a IEC dátového typu položky. ; Select conversion according to the field's IEC data type.
  CASE Tag OF
    SCH_BOOL:
      PB := UDINT_TO_PTR(ValAdr);
      BitPos := SchBit(Nd := Nd, El := El);
      IF BitPos < 0 THEN TxWorkErr := 6; RETURN; END_IF;
      Mask := 1;
      FOR I := 1 TO BitPos DO Mask := Mask * 2; END_FOR;
      IF (BYTE_TO_UINT(PB^) / Mask) MOD 2 = 1 THEN Text := 'true'; ELSE Text := 'false'; END_IF;
    SCH_SINT: PS := UDINT_TO_PTR(ValAdr); Text := SINT_TO_STRING(PS^);
    SCH_USINT: PU := UDINT_TO_PTR(ValAdr); Text := USINT_TO_STRING(PU^);
    SCH_INT: PI := UDINT_TO_PTR(ValAdr); Text := INT_TO_STRING(PI^);
    SCH_UINT: PUI := UDINT_TO_PTR(ValAdr); Text := UINT_TO_STRING(PUI^);
    SCH_DINT: PDI := UDINT_TO_PTR(ValAdr); Text := DINT_TO_STRING(PDI^);
    SCH_UDINT: PUD := UDINT_TO_PTR(ValAdr); Text := UDINT_TO_STRING(PUD^);
    SCH_BYTE: PB := UDINT_TO_PTR(ValAdr); Text := UDINT_TO_STRING(BYTE_TO_UDINT(PB^));
    SCH_WORD: PW := UDINT_TO_PTR(ValAdr); Text := UDINT_TO_STRING(WORD_TO_UDINT(PW^));
    SCH_DWORD: PDW := UDINT_TO_PTR(ValAdr); Text := UDINT_TO_STRING(DWORD_TO_UDINT(PDW^));
    SCH_REAL: PR := UDINT_TO_PTR(ValAdr); Text := REAL_TO_STRING(PR^);
    SCH_LREAL: PLR := UDINT_TO_PTR(ValAdr); Text := LREAL_TO_STRING(PLR^);
    SCH_STRING:
      TxWriteValue := TxWriteString(Pos := ValAdr, Span := aNode[Nd].Span);
      RETURN;
    SCH_TIME: PT := UDINT_TO_PTR(ValAdr); Text := TIME_TO_STRING(PT^);
    SCH_DATE: PDate := UDINT_TO_PTR(ValAdr); Text := DATE_TO_STRING(PDate^);
    SCH_TIME_OF_DAY: PTod := UDINT_TO_PTR(ValAdr); Text := TOD_TO_STRING(PTod^);
    SCH_DATE_AND_TIME: PDT := UDINT_TO_PTR(ValAdr); Text := DT_TO_STRING(PDT^);
    ELSE TxWorkErr := 6; RETURN;
  END_CASE;

  IF (Tag = SCH_TIME) OR (Tag = SCH_DATE) OR (Tag = SCH_TIME_OF_DAY) OR (Tag = SCH_DATE_AND_TIME) THEN
    TxWriteValue := TxWriteQuoted(Text := Text);
  ELSE
    TxWriteValue := TxWrite(Text := Text);
  END_IF;
END_FUNCTION

// Preèíta PLC systémové hodiny v milisekundách pre meranie exportu. ; Read the PLC millisecond clock for export timing.
FUNCTION TxClockMs : UDINT
  VAR_EXTERNAL
    AT %SL52 : DWORD;
  END_VAR
  TxClockMs := DWORD_TO_UDINT(%SL52);
END_FUNCTION

// Zapíše jeden riadok do meracieho logu exportu. ; Write one line to the export measurement log.
FUNCTION TxLogPut : BOOL
  VAR_INPUT
    Hnd  : HANDLE;
    Text : STRING[255];  // Textový obsah zapisovaný do JSON ; Text content being written to JSON
  END_VAR
  VAR
    N : UDINT;  // Poèet bajtov skutoène zapísaných funkciou ; Number of bytes actually written by the function
  END_VAR
  N := FileWrite(hFile := Hnd, adrBuf := PTR_TO_UDINT(ADR(Text)), size := INT_TO_UDINT(LEN(Text)));
  TxLogPut := N = INT_TO_UDINT(LEN(Text));
END_FUNCTION

// Zapíše parametre, výsledok a namerané trvanie exportu do tx.log. ; Write export parameters, result, and timing to tx.log.
FUNCTION TxWriteLog : BOOL
  VAR
    Hnd    : HANDLE;
    Line   : STRING[255];
    Closed : BOOL;          // Príznak úspešného uzatvorenia súboru ; Flag indicating the file closed successfully
    Ok     : BOOL := TRUE;  // Príznak úspešného zápisu ; Flag indicating a successful write
  END_VAR
  TxWriteLog := FALSE;
  Hnd := FileOpen(fileName := TxLogPath, mode := F_WRITE);
  IF Hnd = INVALID_HANDLE_VALUE THEN RETURN; END_IF;

  Line := CONCAT('api_V12 TX export', TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('file=RAM/tx.json', TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('rq=', UDINT_TO_STRING(TxRqW), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('cf=', USINT_TO_STRING(TxCfW), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  IF (TxCfW >= 1) AND (TxCfW <= UINT_TO_USINT(SCH_DEF_N)) THEN
    Line := CONCAT('type=', aSch[TxCfW].Code, TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  END_IF;
  IF TxMode = 3 THEN Line := CONCAT('mode=all', TxCRLF);
  ELSIF TxMode = 2 THEN Line := CONCAT('mode=range', TxCRLF);
  ELSE Line := CONCAT('mode=one', TxCRLF);
  END_IF;
  Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('from=', UDINT_TO_STRING(TxFrom), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('to=', UDINT_TO_STRING(TxTo), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  IF TxTo >= TxFrom THEN Line := CONCAT('records=', UDINT_TO_STRING(TxTo - TxFrom + 1), TxCRLF);
  ELSE Line := CONCAT('records=0', TxCRLF);
  END_IF;
  Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('records_done=', UDINT_TO_STRING(TxDoneN), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  IF (TxCfW >= 1) AND (TxCfW <= UINT_TO_USINT(SCH_DEF_N)) THEN
    Line := CONCAT('record_bytes=', UDINT_TO_STRING(aSch[TxCfW].Siz), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
    Line := CONCAT('schema_nodes=', UINT_TO_STRING(aSch[TxCfW].Cnt), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  END_IF;
  Line := CONCAT('json_bytes=', UDINT_TO_STRING(TxBytes), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('start_ms=', UDINT_TO_STRING(TxMs0), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('end_ms=', UDINT_TO_STRING(TxMs1), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('duration_ms=', UDINT_TO_STRING(TxDur), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('plc_cycles=', UDINT_TO_STRING(TxCycN), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  IF TxWorkErr = 0 THEN Line := CONCAT('result=OK', TxCRLF);
  ELSE Line := CONCAT('result=ERROR', TxCRLF);
  END_IF;
  Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);
  Line := CONCAT('error=', USINT_TO_STRING(TxWorkErr), TxCRLF); Ok := Ok AND TxLogPut(Hnd := Hnd, Text := Line);

  Closed := FileClose(hFile := Hnd);
  TxWriteLog := Ok AND Closed;
END_FUNCTION

// Prejde uzly jednej vety pod¾a schémy a vytvorí jej vnorený JSON objekt. ; Traverse one record's schema nodes and produce its nested JSON object.
// Zásobníky Kind/Base/StartNd/EndNd riadia iteratívny prechod vnorenými objektmi a po¾ami STRUCT. ; Kind/Base/StartNd/EndNd stacks drive iterative traversal of nested STRUCT objects and arrays.
FUNCTION TxWriteRecord : BOOL
  VAR_INPUT
    Cf  : USINT;  // Index typu vybraného pre operáciu ; Index of the type selected for the operation
    Rec : UDINT;  // Èíslo spracúvanej vety ; Number of the record being processed
  END_VAR
  VAR
    Root    : UDINT;                  // Adresa koreòa vybranej vety ; Root address of the selected record
    Nd      : UINT;                   // Index uzla aktuálnej položky schémy ; Schema-node index of the current field
    NextNd  : UINT;                   // Index nasledujúceho uzla schémy ; Index of the next schema node
    Tag     : USINT;                  // Základný typ hodnoty ; Base type of the value
    D       : INT;                    // Håbka zásobníka vnorených objektov ; Nested-object stack depth
    ElNow   : INT;
    ElLast  : INT;
    Head    : STRING[40];             // Názov JSON po¾a vrátane dvojbodky ; JSON field name including its colon
    Done    : BOOL;                   // Príznak dokonèenia aktuálnej vety ; Flag indicating the current record is complete
    Kind    : ARRAY[0..15] OF USINT;  // Typ rámca v zásobníku prechodu ; Frame kind in the traversal stack ; 1=object, 2=array-of-struct controller
    Base    : ARRAY[0..15] OF UDINT;  // Základná adresa rámca v mRam ; Base address of the frame in mRam
    First   : ARRAY[0..15] OF BOOL;   // Prvý uzol aktuálneho objektu ; First node of the current object
    StartNd : ARRAY[0..15] OF UINT;   // Prvý uzol potomkov aktuálneho objektu ; First child node of the current object
    EndNd   : ARRAY[0..15] OF UINT;   // Koniec rozsahu uzlov aktuálneho objektu ; End of the current object's node range
    AfterNd : ARRAY[0..15] OF UINT;   // Prvý uzol nasledujúci po objekte ; First node after the object
    ArrNd   : ARRAY[0..15] OF UINT;   // Uzol po¾a spracúvaný daným rámcom ; Array node processed by this frame
    ArrEl   : ARRAY[0..15] OF INT;    // Aktuálny IEC index prvku po¾a ; Current IEC array element index
    ArrLast : ARRAY[0..15] OF INT;    // Posledný IEC index prvku po¾a ; Last IEC array element index
  END_VAR

  TxWriteRecord := FALSE;
  Root := SchRoot(Cf := Cf, Rec := Rec);
  IF Root = 0 THEN TxWorkErr := 1; RETURN; END_IF;
  IF NOT TxWrite(Text := '{') THEN RETURN; END_IF;

  D := 0;
  Kind[0] := 1;
  Base[0] := Root;
  First[0] := TRUE;
  StartNd[0] := aSch[Cf].Fst;
  EndNd[0] := aSch[Cf].Fst + aSch[Cf].Cnt;
  Nd := StartNd[0];

  // Pokraèuje, kým sa neuzavrie koreòový objekt alebo nevznikne chyba. ; Continue until the root object closes or an error occurs.
  WHILE NOT Done AND (TxWorkErr = 0) DO
    // Kontrola chráni stavový automat pred neplatným typom rámca zásobníka. ; Guard the state machine against an invalid stack-frame kind.
    IF Kind[D] <> 1 THEN TxWorkErr := 8;
    ELSIF Nd >= EndNd[D] THEN
      IF NOT TxWrite(Text := '}') THEN RETURN; END_IF;
      IF D = 0 THEN
        Done := TRUE;
      ELSE
        NextNd := AfterNd[D];
        D := D - 1;
        IF Kind[D] = 2 THEN
          IF ArrEl[D] < ArrLast[D] THEN
            ArrEl[D] := ArrEl[D] + 1;
            IF NOT TxWrite(Text := ',{') THEN RETURN; END_IF;
            IF D >= 15 THEN TxWorkErr := 5; RETURN; END_IF;
            D := D + 1;
            Kind[D] := 1;
            Base[D] := SchAdr(Parent := Base[D - 1], Nd := ArrNd[D - 1], El := ArrEl[D - 1]);
            First[D] := TRUE;
            StartNd[D] := StartNd[D - 1];
            EndNd[D] := EndNd[D - 1];
            AfterNd[D] := EndNd[D];
            Nd := StartNd[D];
          ELSE
            IF NOT TxWrite(Text := ']') THEN RETURN; END_IF;
            NextNd := AfterNd[D];
            D := D - 1;
            Nd := NextNd;
          END_IF;
        ELSE
          Nd := NextNd;
        END_IF;
      END_IF;
    ELSE
      IF NOT First[D] THEN IF NOT TxWrite(Text := ',') THEN RETURN; END_IF; END_IF;
      Head := CONCAT('"', aNode[Nd].Nam, '":');
      IF NOT TxWrite(Text := Head) THEN RETURN; END_IF;
      First[D] := FALSE;
      Tag := aNode[Nd].Tag MOD SCH_ARRAY;

      // Vnorený objekt alebo pole štruktúr sa spracuje rekurzívne simulovaným zásobníkom. ; Nested objects and STRUCT arrays are traversed with an explicit stack.
      IF Tag = SCH_STRUCT THEN
        NextNd := Nd + 1 + aNode[Nd].Aux;
        IF aNode[Nd].Tag >= SCH_ARRAY THEN
          IF (aNode[Nd].Cnt = 0) OR (D > 13) THEN TxWorkErr := 5; RETURN; END_IF;
          IF NOT TxWrite(Text := '[{') THEN RETURN; END_IF;
          D := D + 1;
          Kind[D] := 2;
          Base[D] := Base[D - 1];
          StartNd[D] := Nd + 1;
          EndNd[D] := NextNd;
          AfterNd[D] := NextNd;
          ArrNd[D] := Nd;
          ArrEl[D] := aNode[Nd].Lo;
          ArrLast[D] := aNode[Nd].Lo + UINT_TO_INT(aNode[Nd].Cnt) - 1;
          D := D + 1;
          Kind[D] := 1;
          Base[D] := SchAdr(Parent := Base[D - 1], Nd := ArrNd[D - 1], El := ArrEl[D - 1]);
          First[D] := TRUE;
          StartNd[D] := StartNd[D - 1];
          EndNd[D] := EndNd[D - 1];
          AfterNd[D] := EndNd[D];
          Nd := StartNd[D];
        ELSE
          IF D >= 15 THEN TxWorkErr := 5; RETURN; END_IF;
          IF NOT TxWrite(Text := '{') THEN RETURN; END_IF;
          D := D + 1;
          Kind[D] := 1;
          Base[D] := SchAdr(Parent := Base[D - 1], Nd := Nd, El := 0);
          First[D] := TRUE;
          StartNd[D] := Nd + 1;
          EndNd[D] := NextNd;
          AfterNd[D] := NextNd;
          Nd := StartNd[D];
        END_IF;
      ELSE
        IF aNode[Nd].Tag >= SCH_ARRAY THEN
          IF NOT TxWrite(Text := '[') THEN RETURN; END_IF;
          ElNow := aNode[Nd].Lo;
          ElLast := aNode[Nd].Lo + UINT_TO_INT(aNode[Nd].Cnt) - 1;
          WHILE (ElNow <= ElLast) AND (TxWorkErr = 0) DO
            IF ElNow > aNode[Nd].Lo THEN IF NOT TxWrite(Text := ',') THEN RETURN; END_IF; END_IF;
            IF NOT TxWriteValue(Parent := Base[D], Nd := Nd, El := ElNow) THEN RETURN; END_IF;
            ElNow := ElNow + 1;
          END_WHILE;
          IF NOT TxWrite(Text := ']') THEN RETURN; END_IF;
        ELSE
          IF NOT TxWriteValue(Parent := Base[D], Nd := Nd, El := 0) THEN RETURN; END_IF;
        END_IF;
        Nd := Nd + 1;
      END_IF;
    END_IF;
  END_WHILE;

  IF NOT Done AND (TxWorkErr = 0) THEN TxWorkErr := 8; END_IF;
  TxWriteRecord := Done AND (TxWorkErr = 0);
END_FUNCTION

// Uzatvorí export, zapíše log a potvrdí požiadavku klientovi. ; Close the export, write its log, and acknowledge the client request.
FUNCTION TxEnd : BOOL
  VAR
    Closed : BOOL := TRUE;  // Príznak úspešného uzatvorenia súboru ; Flag indicating the file closed successfully
    LogOk  : BOOL;          // Výsledok zápisu meracieho logu ; Result of writing the measurement log
  END_VAR
  IF TxH <> INVALID_HANDLE_VALUE THEN Closed := FileClose(hFile := TxH); END_IF;
  TxH := INVALID_HANDLE_VALUE;
  IF (TxWorkErr = 0) AND NOT Closed THEN TxWorkErr := 4; END_IF;
  TxMs1 := TxClockMs();
  TxDur := TxMs1 - TxMs0;
  TxCycN := TxCyc - TxCyc0 + 1;
  LogOk := TxWriteLog();
  IF (TxWorkErr = 0) AND NOT LogOk THEN TxWorkErr := 9; END_IF;
  TxErr := TxWorkErr;
  TxDone := TxRqW;
  TxSt := 0;
  TxEnd := TxWorkErr = 0;
END_FUNCTION

// Overí požiadavku, otvorí tx.json a zapíše hlavièku JSON obálky. ; Validate the request, open tx.json, and write the JSON envelope header.
// Overí požiadavku a pripraví export jednej alebo všetkých viet daného typu. ; Validate the request and prepare an export of one or all records of the selected type.
FUNCTION TxStart : BOOL
  VAR_INPUT
    Cf  : USINT;  // Index typu vybraného pre operáciu ; Index of the type selected for the operation
    Rec : UDINT;  // Èíslo spracúvanej vety ; Number of the record being processed
    Rq  : UDINT;  // Èíslo požiadavky klienta ; Client request number
  END_VAR
  VAR
    Ok : BOOL;  // Príznak úspešného zápisu ; Flag indicating a successful write
  END_VAR
  TxStart := FALSE;
  TxCfW := Cf;
  TxRqW := Rq;
  TxFrom := 0;
  TxTo := 0;
  TxNow := 0;
  TxMode := 0;
  TxDoneN := 0;
  TxBytes := 0;
  TxWorkErr := 0;
  TxMs0 := TxClockMs();
  TxCyc0 := TxCyc;
  TxErr := 1;

  IF NOT SchInit() OR (Cf < 1) OR (Cf > UINT_TO_USINT(SCH_DEF_N)) THEN
    TxWorkErr := 1; Ok := TxEnd(); RETURN;
  END_IF;
  // Nula vyberá všetky vety typu ; inak sa exportuje zadané èíslo. ; Zero selects all records of the type ; otherwise export the requested record.
  IF Rec = 0 THEN
    TxMode := 3;
    TxFrom := 1;
    TxTo := aCfg[Cf].Rec;
  ELSE
    TxMode := 1;
    TxFrom := Rec;
    TxTo := Rec;
  END_IF;
  TxNow := TxFrom;
  IF (TxFrom < 1) OR (TxTo < TxFrom) OR (TxTo > aCfg[Cf].Rec) OR
     (SchRoot(Cf := Cf, Rec := TxFrom) = 0) OR (SchRoot(Cf := Cf, Rec := TxTo) = 0) THEN
    TxWorkErr := 1; Ok := TxEnd(); RETURN;
  END_IF;

  TxH := FileOpen(fileName := TxPath, mode := F_WRITE);
  IF TxH = INVALID_HANDLE_VALUE THEN TxWorkErr := 2; Ok := TxEnd(); RETURN; END_IF;

  // Zapíše hlavièku obálky s identifikátorom požiadavky a neskôr doplní rozsah i dáta. ; Write the request envelope header, then append range metadata and data.
  IF NOT TxWrite(Text := '{"rq":') THEN Ok := TxEnd(); RETURN; END_IF;
  IF NOT TxWrite(Text := UDINT_TO_STRING(Rq)) THEN Ok := TxEnd(); RETURN; END_IF;
  IF NOT TxWrite(Text := ',"cf":') THEN Ok := TxEnd(); RETURN; END_IF;
  IF NOT TxWrite(Text := USINT_TO_STRING(Cf)) THEN Ok := TxEnd(); RETURN; END_IF;
  IF NOT TxWrite(Text := ',"type":"') THEN Ok := TxEnd(); RETURN; END_IF;
  IF NOT TxWrite(Text := aSch[Cf].Code) THEN Ok := TxEnd(); RETURN; END_IF;
  IF NOT TxWrite(Text := '","from":') THEN Ok := TxEnd(); RETURN; END_IF;
  IF NOT TxWrite(Text := UDINT_TO_STRING(TxFrom)) THEN Ok := TxEnd(); RETURN; END_IF;
  IF NOT TxWrite(Text := ',"to":') THEN Ok := TxEnd(); RETURN; END_IF;
  IF NOT TxWrite(Text := UDINT_TO_STRING(TxTo)) THEN Ok := TxEnd(); RETURN; END_IF;
  IF NOT TxWrite(Text := ',"count":') THEN Ok := TxEnd(); RETURN; END_IF;
  IF NOT TxWrite(Text := UDINT_TO_STRING(TxTo - TxFrom + 1)) THEN Ok := TxEnd(); RETURN; END_IF;
  IF NOT TxWrite(Text := ',"data":[') THEN Ok := TxEnd(); RETURN; END_IF;
  TxSt := 1;
  TxStart := TRUE;
END_FUNCTION

// Stavový automat exportu ; na cyklus PLC spracuje najviac jednu vetu. ; Export state machine ; processes at most one record per PLC cycle.
// Nové TxRq založí export ; ïalšie cykly postupne dopíšu záznamy. ; A new TxRq starts an export ; subsequent cycles append records.
FUNCTION TxCycle : BOOL
  VAR
    Ok : BOOL;  // Príznak úspešného zápisu ; Flag indicating a successful write
  END_VAR
  TxCyc := TxCyc + 1;
  TxCycle := TRUE;

  // V neèinnom stave èaká na nové èíslo požiadavky. ; While idle, wait for a new request number.
  IF TxSt = 0 THEN
    IF (TxRq = 0) OR (TxRq = TxSeen) THEN RETURN; END_IF;
    TxSeen := TxRq;
    TxCycle := TxStart(Cf := TxCf, Rec := TxRec, Rq := TxRq);
    RETURN;
  END_IF;

  IF TxSt <> 1 THEN TxWorkErr := 8; TxCycle := TxEnd(); RETURN; END_IF;
  // Ochrana pred prekroèením koncového èísla vybraného rozsahu. ; Guard against passing the selected range's final record.
  IF TxNow > TxTo THEN TxWorkErr := 8; TxCycle := TxEnd(); RETURN; END_IF;

  IF TxNow > TxFrom THEN IF NOT TxWrite(Text := ',') THEN TxCycle := TxEnd(); RETURN; END_IF; END_IF;
  IF NOT TxWrite(Text := '{"rec":') THEN TxCycle := TxEnd(); RETURN; END_IF;
  IF NOT TxWrite(Text := UDINT_TO_STRING(TxNow)) THEN TxCycle := TxEnd(); RETURN; END_IF;
  IF NOT TxWrite(Text := ',"value":') THEN TxCycle := TxEnd(); RETURN; END_IF;
  IF NOT TxWriteRecord(Cf := TxCfW, Rec := TxNow) THEN TxCycle := TxEnd(); RETURN; END_IF;
  IF NOT TxWrite(Text := '}') THEN TxCycle := TxEnd(); RETURN; END_IF;
  TxDoneN := TxDoneN + 1;
  TxNow := TxNow + 1;

  IF TxNow > TxTo THEN
    IF NOT TxWrite(Text := ']}') THEN TxCycle := TxEnd(); RETURN; END_IF;
    Ok := TxEnd();
    TxCycle := Ok;
  END_IF;
END_FUNCTION
