VAR_GLOBAL
	result	 : BOOL;		// result of whole test
  errCnt   : UDINT;   // number of errors
  info     : STRING;  // text information about result of test
END_VAR

PROGRAM prgMain
  VAR
    b1      : BYTE := 16#A5;
    b2      : BYTE;
    dw1     : DWORD := 16#12A50FEB;
    dw2     : DWORD;
    str     : STRING;
    str1    : STRING := 'peter pan';
    str2    : STRING;
    strBin  : STRING;
    strHex  : STRING;
    message : MESSAGE_8 := ( S1 := 'Error 1',  S2 := 'Error 2',  S3 := 'Error 3',  S4 := 'Error 4',
                             S5 := 'Error 5',  S6 := 'Error 6',  S7 := 'Error 7',  S8 := 'Error 8');
    buffer  : ARRAY[0..99] OF BYTE := [ 0,0,0,0, 16#41, 16#42, 16#43, 1, 1, 1, 1];
    v1      : VECTOR_3 := ( X := 1.0,  Y := 4.0,  Z := 8.0);
    jd1     : REAL;
    ar1     : ARRAY[0..5] OF REAL := [0.0,-1.0,-2.0,3.0,4.0,-5.0];
    cx1     : COMPLEX := ( re := 3.0,  im := 4.0);
    rd1     : REAL2;
    r1      : REAL;
    Fifo    : FIFO_16;
    A_trg   : A_TRIG;
    a1      : BOOL;
    Latch   : LTCH;
    GeSin   : GEN_SIN;
    i       : INT;
    b       : BYTE;
    dw      : DWORD;
    di      : DINT;
    r, rn   : REAL;
    rd, rdw : DWORD;
    MsCounter : fbMsCounter;
    dobaVypoctu : REAL;
  END_VAR

  MsCounter(start := 1);
  errCnt := 0;

  // 4.Other Functions --------------------------------------------------------
  IF OSCAT_VERSION( FALSE) <> 333 THEN errCnt := errCnt + 1; END_IF;
  IF DWORD_TO_DATE(OSCAT_VERSION( TRUE)) <> D#2012-01-02 THEN errCnt := errCnt + 1; END_IF;

  // 5.Mathematics ------------------------------------------------------------
  IF CEIL1(  3.14)  <> 4   THEN errCnt := errCnt + 1; END_IF;
  IF CEIL1( -3.14)  <> -3  THEN errCnt := errCnt + 1; END_IF;
  IF CEIL1(  2.0)   <> 2   THEN errCnt := errCnt + 1; END_IF;
  IF D_TRUNC( 1.6)  <> 1   THEN errCnt := errCnt + 1; END_IF;
  IF D_TRUNC( -1.6) <> -1  THEN errCnt := errCnt + 1; END_IF;
  IF FACT( 5)       <> 120 THEN errCnt := errCnt + 1; END_IF;
  IF FLOOR1(  3.14) <> 3   THEN errCnt := errCnt + 1; END_IF;
  IF FLOOR1( -3.14) <> -4  THEN errCnt := errCnt + 1; END_IF;
  IF FLOOR1(  2.0)  <> 2   THEN errCnt := errCnt + 1; END_IF;
  
  IF CMP(3.140, 3.149, 3) <> TRUE  THEN errCnt := errCnt + 1; END_IF;
  IF CMP(0.015, 0.016, 1) <> TRUE  THEN errCnt := errCnt + 1; END_IF;
  IF CMP(3.140, 3.149, 4) <> FALSE THEN errCnt := errCnt + 1; END_IF;
  IF CMP(0.015, 0.016, 2) <> FALSE THEN errCnt := errCnt + 1; END_IF;

  IF BINOM(N := 5, K := 3) <> 10 THEN errCnt := errCnt + 1; END_IF;
  IF CEIL1(3.14) <> 4 OR CEIL1(-3.14) <> -3 THEN errCnt := errCnt + 1; END_IF;
  IF CEIL2(3.14) <> 4 OR CEIL2(-3.14) <> -3 THEN errCnt := errCnt + 1; END_IF;
  IF FLOOR1(3.14) <> 3 OR FLOOR1(-3.14) <> -4 THEN errCnt := errCnt + 1; END_IF;
  IF FLOOR2(3.14) <> 3 OR FLOOR2(-3.14) <> -4 THEN errCnt := errCnt + 1; END_IF;
  IF D_TRUNC( 1.5) <> 1 OR D_TRUNC( -1.5) <> -1 THEN errCnt := errCnt + 1; END_IF;
  r := EXPN( X := 12.5, N := 4);
  IF EXPN( X := 12.5, N := 4) <> 24414.0625 THEN errCnt := errCnt + 1; END_IF;
  IF GCD(A := 50, B := 75) <> 25 THEN errCnt := errCnt + 1; END_IF;
  r := MID3( IN1 := 12.5, IN2 := 25.0, IN3 := 17.5);
  IF MID3( IN1 := 12.5, IN2 := 25.0, IN3 := 17.5) <> 17.5 THEN errCnt := errCnt + 1; END_IF;
  rn := RDM( last := rn);
  IF RDM( last := rn) = rn THEN errCnt := errCnt + 1; END_IF; // random numbers can not be the same
  rd := RDMDW( last := rd);
  IF RDMDW( last := rdw) = rdw THEN errCnt := errCnt + 1; END_IF; // random numbers can not be the same

  // 6.Arrays -----------------------------------------------------------------
  _ARRAY_ABS( pt := ADR( ar1), size := sizeof(ar1));
  FOR i := 0 TO 5 DO
    IF ar1[i] <> INT_TO_REAL(i) THEN errCnt := errCnt + 1; END_IF;
  END_FOR;
  
  // 7.Complex Mathematics ----------------------------------------------------
  IF CABS( cx1) <> 5.0 THEN errCnt := errCnt + 1; END_IF;
  
  // 8.Arithmetics with Double Precision --------------------------------------
  rd1 := R2_SET( 1234567.0);
  rd1 := R2_ADD( rd1, 0.543211);   // ??? why use REAL2 instead LREAL ???

  // 9.Arithmetics Functions
  IF F_LIN( 3.0, 4.0, 5.0) <> 17.0 THEN errCnt := errCnt + 1; END_IF;

  // 10. Geometric Functions --------------------------------------------------
  IF TRIANGLE_A( S1 := 3.0, A := 0.0, S2 := 4.0, S3 := 5.0) <> 6.0 THEN errCnt := errCnt + 1; END_IF;
  IF TRIANGLE_A( S1 := 3.0, A := 90.0, S2 := 4.0, S3 := 0.0) <> 6.0 THEN errCnt := errCnt + 1; END_IF;

  // 11.Vector Mathematics ----------------------------------------------------
  IF V3_ABS( v1) <> 9.0 THEN errCnt := errCnt + 1; END_IF;
  
  // 12.Time & Date -----------------------------------------------------------
  IF JD2000(DT#2000-01-02-12:00:00.0) <> 1.0 THEN errCnt := errCnt + 1; END_IF;
  IF DAY_OF_YEAR( D#2007-12-31) <> 365 THEN errCnt := errCnt + 1; END_IF;
  IF DAY_OF_YEAR( D#2008-12-31) <> 366 THEN errCnt := errCnt + 1; END_IF;
  IF MONTH_OF_DATE( D#2008-12-31) <> 12 THEN errCnt := errCnt + 1; END_IF;
  IF DAY_OF_MONTH( D#2008-12-31) <> 31 THEN errCnt := errCnt + 1; END_IF;

  // 13.String Functions ------------------------------------------------------
  strBin := BYTE_TO_STRB( b1); b2 := BIN_TO_BYTE( strBin);
  IF b1 <> b2 THEN errCnt := errCnt + 1; END_IF;
  strHex := BYTE_TO_STRH( b1); b2 := HEX_TO_BYTE( strHex);
  IF b1 <> b2 THEN errCnt := errCnt + 1; END_IF;
  strBin := DWORD_TO_STRB( dw1 ); dw2 := BIN_TO_DWORD( strBin);
  IF dw1 <> dw2 THEN errCnt := errCnt + 1; END_IF;
  strBin := DWORD_TO_STRH( dw1 ); dw2 := HEX_TO_DWORD( strBin);
  IF dw1 <> dw2 THEN errCnt := errCnt + 1; END_IF;
  str2 := CAPITALIZE( str1);
  IF str2 <> 'Peter Pan' THEN errCnt := errCnt + 1; END_IF;
  IF CHARCODE('euro') <> 128 THEN errCnt := errCnt + 1; END_IF;
  str2 := CHARNAME( 128);
  IF str2 <> 'euro' THEN errCnt := errCnt + 1; END_IF;
  Message( IN2 := 1, M => str2);
  IF str2 <> 'Error 2' THEN errCnt := errCnt + 1; END_IF;
  str := BYTE_TO_STRB( 16#A5);
  IF str <> '10100101' THEN errCnt := errCnt + 1; END_IF;
  str := BYTE_TO_STRH( 16#5A);
  IF str <> '5A' THEN errCnt := errCnt + 1; END_IF;
  str := 'skákal pes pøes oves pøes zelenou louku';
  str := CAPITALIZE( str);
  IF str <> 'Skákal Pes Pøes Oves Pøes Zelenou Louku' THEN errCnt := errCnt + 1; END_IF;
  str := CHR_TO_STRING( 16#61);
  IF str <> 'a' THEN errCnt := errCnt + 1; END_IF;
  str := DWORD_TO_STRB( 2#1100_0101_0011_1111_0000_1011_1101_0011);
  IF str <> '11000101001111110000101111010011' THEN errCnt := errCnt + 1; END_IF;
  str := DWORD_TO_STRH(16#C53F0BD3);
  IF str <> 'C53F0BD3' THEN errCnt := errCnt + 1; END_IF;
  str := UPPERCASE('no nazdar');
  IF str <> 'NO NAZDAR' THEN errCnt := errCnt + 1; END_IF;
  str := LOWERCASE('DOBRY DEN');
  IF str <> 'dobry den' THEN errCnt := errCnt + 1; END_IF;
  str := MIRROR('Autobus');
  IF str <> 'subotuA' THEN errCnt := errCnt + 1; END_IF;
  IF BIN_TO_BYTE( '01111110') <> 16#7E THEN errCnt := errCnt + 1; END_IF;
  IF BIN_TO_DWORD( '01111110 11100111 10100101 00011000') <> 16#7EE7A518 THEN errCnt := errCnt + 1; END_IF;
  IF COUNT_CHAR(str := 'befelemepeseveze', chr := 16#65) <> 8 THEN errCnt := errCnt + 1; END_IF;
  IF COUNT_SUBSTRING(SEARCH := 'tik', STR := 'tik tak tiktak') <> 2 THEN errCnt := errCnt + 1; END_IF;
  IF DEC_TO_BYTE( '125') <> 125 THEN errCnt := errCnt + 1; END_IF;
  IF DEC_TO_DWORD( '12345678') <> 12345678 THEN errCnt := errCnt + 1; END_IF;
  IF DEC_TO_INT( '32767') <> 32767 THEN errCnt := errCnt + 1; END_IF;
  IF DEC_TO_INT( '-32767') <> -32767 THEN errCnt := errCnt + 1; END_IF;
  str := DEL_CHARS(IN := 'befelemepeseveze', CX := 'bflmpsvz');
  IF str <> 'eeeeeeee' THEN errCnt := errCnt + 1; END_IF;
  str := DEL_CHARS(IN := 'befelemepeseveze', CX := 'e');
  IF str <> 'bflmpsvz' THEN errCnt := errCnt + 1; END_IF;
  str := TRIM( 'Tik Tak Tik Tak');
  IF str <> 'TikTakTikTak' THEN errCnt := errCnt + 1; END_IF;
  str := EXEC( '5^2');
  IF str <> '25.000000' THEN errCnt := errCnt + 1; END_IF;
  IF OCT_TO_BYTE(OCT := '176') <> 16#7E THEN errCnt := errCnt + 1; END_IF;
  IF HEX_TO_BYTE(HEX := '7E') <> 16#7E THEN errCnt := errCnt + 1; END_IF;
  IF OCT_TO_DWORD(OCT := '176') <> 16#7E THEN errCnt := errCnt + 1; END_IF;
  IF HEX_TO_DWORD(HEX := '7Ea36D8b') <> 16#7Ea36D8b THEN errCnt := errCnt + 1; END_IF;
  str := REAL_TO_STRF(IN := 125.5, N := 3, D := ',');
  IF str <> '125,500' THEN errCnt := errCnt + 1; END_IF;
  str := TRIM1( 'One  two     three  ');
  IF str <> 'One two three' THEN errCnt := errCnt + 1; END_IF;
  str := TRIME( '     deletes all leading and ending blanks     ');
  IF str <> 'deletes all leading and ending blanks' THEN errCnt := errCnt + 1; END_IF;
  str := CLEAN(IN := 'ahoj svete', CX := 'ahoj');
  IF 'ahoj' <> CLEAN(IN := ' ashvoejte ', CX := 'ahoj') THEN errCnt := errCnt + 1; END_IF;
  
  // 14. Memory Modules -------------------------------------------------------
  Fifo( Din := 16#12345678, E := 1, RD := 0, WD := 1, RST := 0);
  Fifo( Din := 16#87654321, E := 1, RD := 0, WD := 1, RST := 0);
  Fifo( Din := 0,           E := 1, RD := 1, WD := 0, RST := 0);
  IF Fifo.Dout <> 16#12345678 THEN errCnt := errCnt + 1; END_IF;
  Fifo( Din := 0,           E := 1, RD := 1, WD := 0, RST := 0);
  IF Fifo.Dout <> 16#87654321 THEN errCnt := errCnt + 1; END_IF;

  // 15.Pulse Generators ------------------------------------------------------
  IF NOT A_trg.Q THEN r1 := r1 + 1.0; a1 := TRUE; ELSE a1 := FALSE; END_IF;
  A_trg( IN := r1, RES := 0.99);
  IF a1 AND NOT A_trg.Q THEN errCnt := errCnt + 1; END_IF;
  
  // 16.Logic Modules ---------------------------------------------------------
  IF BCDC_TO_INT( 16#59) <> 59 THEN errCnt := errCnt + 1; END_IF;
  IF BIT_COUNT( 16#F000000F) <> 8 THEN errCnt := errCnt + 1; END_IF;
  IF BIT_LOAD_B( IN := 16#01, VAL := 1, POS := 4) <> 16#11 THEN errCnt := errCnt + 1; END_IF;
  IF BIT_LOAD_B2(I := 16#01, D := 1, P := 4, N := 4) <> 16#F1 THEN errCnt := errCnt + 1; END_IF;
  IF NOT CHECK_PARITY(in := 16#AA55AA55, p := 0) THEN errCnt := errCnt + 1; END_IF;
  b := BYTE_TO_GRAY( 16#A5);
  IF GRAY_TO_BYTE( b) <> 16#A5  THEN errCnt := errCnt + 1; END_IF;
  IF PARITY( 16#AA55AA55) <> FALSE THEN errCnt := errCnt + 1; END_IF;
  IF PARITY( 16#AA55AA51) <> TRUE THEN errCnt := errCnt + 1; END_IF;
  IF REFLECT(D := 16#555A_7AD3, L := 16) <> 16#555A_CB5E THEN errCnt := errCnt + 1; END_IF;
  
  // 17.Latches, Flip-Flop and Shift Register ---------------------------------
  Latch( D := 0, L := 0, RST := 1);
  IF Latch.Q THEN errCnt := errCnt + 1; END_IF;
  Latch( D := 0, L := 1, RST := 0);
  IF Latch.Q THEN errCnt := errCnt + 1; END_IF;
  Latch( D := 1, L := 1, RST := 0);
  IF NOT Latch.Q THEN errCnt := errCnt + 1; END_IF;
  Latch( D := 0, L := 0, RST := 0);
  IF NOT Latch.Q THEN errCnt := errCnt + 1; END_IF;
  Latch( D := 0, L := 1, RST := 0);
  IF Latch.Q THEN errCnt := errCnt + 1; END_IF;

  // 18.Signal Generators -----------------------------------------------------
  GeSin( PT := T#10s, AM := 10.0, OS := 5.0, DL := 0.0);
  
  // 19.Signal processing -----------------------------------------------------
  IF (BYTE_TO_RANGE ( 128, 0.0, 100.0) < 50.19) OR (BYTE_TO_RANGE ( 128, 0.0, 100.0) > 50.20) THEN errCnt := errCnt + 1; END_IF;
  
  // 20.Sensors ---------------------------------------------------------------

  // 25.Buffer Management -----------------------------------------------------
  str := BUFFER_TO_STRING( PT := ADR(buffer), SIZE := sizeof(buffer), START := 4, STOP := 6);
  IF str <> 'ABC' THEN errCnt := errCnt + 1; END_IF;

  // 26.List Processing -------------------------------------------------------
  str := 'Foxtrot je PLC z produkce Teco a.s. ';
  i := LIST_LEN(SEP := 32, LIST := str);
  IF i <> 7 THEN errCnt := errCnt + 1; END_IF;

  // result -------------------------------------------------------------------
  IF errCnt = 0 THEN
    info := 'No problem.'; result := 1;
  ELSE
    info := 'Test failed! Number of errors : ' + UDINT_TO_STRING(errCnt); result := 0;
  END_IF;
  MsCounter(start := 0, msTim => dobaVypoctu);

END_PROGRAM

