VAR_GLOBAL
	result	 : BOOL;		// result of whole test
  errCnt   : UDINT;   // number of errors
  info     : STRING;  // text information about result of test

  HOLIDAY_CZ :  ARRAY[0..29] OF HOLIDAY_DATA (*OSCAT_BASIC_ARRAY0_29_OF_HOLIDAY_DATA*) :=
                                              [(name := 'Nový Rok', day := 1, month := 1, use := 1),
                                               (name := 'Velký pátek', day := -2, month := 0, use := 1),
                                               (name := 'Velikonoèní pondìlí', day := 1, month := 0, use := 1),
                                               (name := 'Svátek práce', day := 1, month := 5, use := 1),
                                               (name := 'Den vítìzství', day := 8, month := 5, use := 1),
                                               (name := 'Cyril a Metodìj', day := 5, month := 7, use := 1),
                                               (name := 'Jan Hus', day := 6, month := 7, use := 1),
                                               (name := 'Sv. Václav', day := 28, month := 9, use := 1),
                                               (name := 'Den vzniku ÈR', day := 28, month := 10, use := 1),
                                               (name := 'Den boje za svobodu', day := 17, month := 11, use := 1),
                                               (name := 'Štìdrý den', day := 24, month := 12, use := 1),
                                               (name := 'Boží hod', day := 25, month := 12, use := 1),
                                               (name := 'Sv. Štìpán', day := 26, month := 12, use := 1)];
END_VAR

PROGRAM prgMain
  VAR
    b1      : BYTE := 16#A5;
    b2      : BYTE;
    dw1     : DWORD := 16#12A50FEB;
    dw2     : DWORD;
    str1    : STRING := 'peter pan';
    str2    : STRING;
    strBin  : STRING;
    strHex  : STRING;
    Message : MESSAGE_8 := ( S1 := 'Error 1',  S2 := 'Error 2',  S3 := 'Error 3',  S4 := 'Error 4',
                             S5 := 'Error 5',  S6 := 'Error 6',  S7 := 'Error 7',  S8 := 'Error 8');
    buffer  : ARRAY[0..99] OF BYTE := [ 0,0,0,0, 16#41, 16#42, 16#43, 1, 1, 1, 1];
    str     : STRING;
    i       : INT;
    b       : BYTE;
    dw      : DWORD;
    di      : DINT;
    r, rn   : REAL;
    rd, rdw : DWORD;

    Volny_den_check : HOLIDAY;
    Free_Day : BOOL;
  END_VAR

  Volny_den_check ( DATE_IN := GetDate(), FRIDAY := 1, SATURDAY := 1, SUNDAY := 1, HOLIDAYS := void(HOLIDAY_CZ), Y => Free_Day);

  errCnt := 0;

  // 4.Other Functions --------------------------------------------------------
  IF OSCAT_VERSION( FALSE) <> 333 THEN errCnt := errCnt + 1; END_IF;
  IF DWORD_TO_DATE(OSCAT_VERSION( TRUE)) <> D#2012-01-02 THEN errCnt := errCnt + 1; END_IF;

  // Buffer Management
  str := BUFFER_TO_STRING( PT := ADR(buffer), SIZE := sizeof(buffer), START := 4, STOP := 6);
  IF str <> 'ABC' THEN errCnt := errCnt + 1; END_IF;

  // String
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
  
(*
  // List Processing
  str := 'Foxtrot je PLC z produkce Teco a.s. ';
  i := LIST_LEN(SEP := 32, LIST := str);
  IF i <> 7 THEN errCnt := errCnt + 1; END_IF;
*)
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
  
  // Mathematical
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

  // Time&Date
  IF DAY_OF_YEAR1( D#2007-12-31) <> 365 THEN errCnt := errCnt + 1; END_IF;
  IF DAY_OF_YEAR1( D#2008-12-31) <> 366 THEN errCnt := errCnt + 1; END_IF;
  IF MONTH_OF_DATE1( D#2008-12-31) <> 12 THEN errCnt := errCnt + 1; END_IF;
  IF DAY_OF_MONTH1( D#2008-12-31) <> 31 THEN errCnt := errCnt + 1; END_IF;


  // result -------------------------------------------------------------------
  IF errCnt = 0 THEN
    info := 'No problem.'; result := 1;
  ELSE
    info := 'Test failed! Number of errors : ' + UDINT_TO_STRING(errCnt); result := 0;
  END_IF;
END_PROGRAM

