TYPE
  OSCAT_BASIC_ARRAY0_3_OF_esr_data : ARRAY [0..3] OF esr_data;
END_TYPE

(* @PATH := '\/Other' *)
FUNCTION_BLOCK ESR_COLLECT
(*
  ESR_collect collects esr data from up to 8 esr_mon modules and stroes them in an output array.
  the output pos will display the position of the last element in the array. if the array is empty, pos = -1
  when to buffer is read by followon modules. pos has to be reset to -1
  if the array will be full, the buffer will be refilled starting at position 0.

  version 1.4 1. dec. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    ESR_0, ESR_1, ESR_2, ESR_3, ESR_4, ESR_5, ESR_6, ESR_7 : ARRAY [0..3] OF esr_data;
    rst : BOOL;
  END_VAR
  VAR_IN_OUT
    pos : INT;
  END_VAR
  VAR_OUTPUT
    ESR_OUT : ARRAY[0..31] OF esr_data;
  END_VAR
  VAR CONSTANT
    max_in : INT := 3; (* max limit of input array *)
    max_out : INT := 32; (* number of elements in array *)
  END_VAR
  VAR
    cnt : INT := -1;
  END_VAR

  IF rst OR cnt < 0 THEN
    pos := -1;
  ELSE
    FOR cnt := 0 TO max_in DO
    IF esr_0[cnt].typ > 0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_0[cnt]; END_IF;
    IF esr_1[cnt].typ > 0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_1[cnt]; END_IF;
    IF esr_2[cnt].typ > 0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_2[cnt]; END_IF;
    IF esr_3[cnt].typ > 0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_3[cnt]; END_IF;
    IF esr_4[cnt].typ > 0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_4[cnt]; END_IF;
    IF esr_5[cnt].typ > 0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_5[cnt]; END_IF;
    IF esr_6[cnt].typ > 0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_6[cnt]; END_IF;
    IF esr_7[cnt].typ > 0 THEN pos := INC1(pos, max_out); esr_out[pos] := esr_7[cnt]; END_IF;
     END_FOR;
  END_IF;

(* revision history
  hm  26.jan 2007 rev 1.0
    original version

  hm  8. dec 2007 rev 1.1
    added reset input

  ks  27. oct. 2008 rev 1.2
    optimized code for performance

  ks  12. nov. 2009 rev 1.3
    output pos was not pointing to last value

  hm  1. dec. 2009  rev 1.4
    changed pos to be I/O
    reduced output array size to 32 elements
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Other' *)
FUNCTION_BLOCK ESR_MON_B8
(*
  ESR_mon_B8 monitores up to 8 binary inputs and reports changes with time stamd and adress label.
  the module checks 8 inputs for a change and reports all changes with time and adress stamp to the output.
  4 events maximum can be collected at once within the same cycle

  version 1.3 1. dec. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    s0, s1, s2, s3, s4, s5, s6, s7 : BOOL;
    DT_in : DT;
  END_VAR
  VAR_INPUT //???CONSTANT
    a0, a1, a2, a3, a4, a5, a6, a7 : STRING[10];
  END_VAR
  VAR_OUTPUT
    ESR_Flag : BOOL;
  END_VAR
  VAR_IN_OUT
    ESR_Out: OSCAT_BASIC_ARRAY0_3_OF_esr_data; // ARRAY [0..3] OF esr_data;
  END_VAR
  VAR
    x0, x1, x2, x3, x4, x5, x6, x7 : BOOL;
    tx: TIME;
    cnt : INT;
  END_VAR

  (* read system timer *)
  tx := DWORD_TO_TIME(T_PLC_MS());

  ESR_Flag := FALSE;
  esr_out[3].typ := 0;
  esr_out[2].typ := 0;
  esr_out[1].typ := 0;
  esr_out[0].typ := 0;
  cnt := 0;


  (* check if inputs have chaged and fill buffer *)
  IF s0 <> X0 THEN
    esr_out[cnt].typ := USINT_TO_BYTE(10 + BOOL_TO_USINT(s0));
    esr_out[cnt].adress := a0;
    esr_out[cnt].DS := DT_in;
    esr_out[cnt].TS := TX;
    X0 := S0;
    cnt := cnt + 1;
    esr_flag := TRUE;
  END_IF;
  IF s1 <> X1 THEN
    esr_out[cnt].typ := USINT_TO_BYTE(10 + BOOL_TO_USINT(s1));
    esr_out[cnt].adress := a1;
    esr_out[cnt].DS := DT_in;
    esr_out[cnt].TS := TX;
    X1 := S1;
    cnt := cnt + 1;
    esr_flag := TRUE;
  END_IF;
  IF s2 <> X2 THEN
    esr_out[cnt].typ := USINT_TO_BYTE(10 + BOOL_TO_USINT(s2));
    esr_out[cnt].adress := a2;
    esr_out[cnt].DS := DT_in;
    esr_out[cnt].TS := TX;
    X2 := S2;
    cnt := cnt + 1;
    esr_flag := TRUE;
  END_IF;
  IF s3 <> X3 THEN
    esr_out[cnt].typ := USINT_TO_BYTE(10 + BOOL_TO_USINT(s3));
    esr_out[cnt].adress := a3;
    esr_out[cnt].DS := DT_in;
    esr_out[cnt].TS := TX;
    X3 := S3;
    cnt := cnt + 1;
    esr_flag := TRUE;
  END_IF;
  IF s4 <> X4 AND cnt < 4 THEN
    esr_out[cnt].typ := USINT_TO_BYTE(10 + BOOL_TO_USINT(s4));
    esr_out[cnt].adress := a4;
    esr_out[cnt].DS := DT_in;
    esr_out[cnt].TS := TX;
    X4 := S4;
    cnt := cnt + 1;
    esr_flag := TRUE;
  END_IF;
  IF s5 <> X5  AND cnt < 4 THEN
    esr_out[cnt].typ := USINT_TO_BYTE(10 + BOOL_TO_USINT(s5));
    esr_out[cnt].adress := a5;
    esr_out[cnt].DS := DT_in;
    esr_out[cnt].TS := TX;
    X5 := S5;
    cnt := cnt + 1;
    esr_flag := TRUE;
  END_IF;
  IF s6 <> X6  AND cnt < 4 THEN
    esr_out[cnt].typ := USINT_TO_BYTE(10 + BOOL_TO_USINT(s6));
    esr_out[cnt].adress := a6;
    esr_out[cnt].DS := DT_in;
    esr_out[cnt].TS := TX;
    X6 := S6;
    cnt := cnt + 1;
    esr_flag := TRUE;
  END_IF;
  IF s7 <> X7  AND cnt < 4 THEN
    esr_out[cnt].typ := USINT_TO_BYTE(10 + BOOL_TO_USINT(s7));
    esr_out[cnt].adress := a7;
    esr_out[cnt].DS := DT_in;
    esr_out[cnt].TS := TX;
    X7 := S7;
    cnt := cnt + 1;
    esr_flag := TRUE;
  END_IF;

(* revision history
  hm  26. jan 2007  rev 1.0
    original version

  hm  17. sep 2007  rev 1.1
    replaced time() with T_PLC_MS() for compatibility reasons

  hm  22. oct. 2008 rev 1.2
    optimized code

  hm  1.dec. 2009 rev 1.3
    changed esr_out to be I/O
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Other' *)
FUNCTION_BLOCK ESR_MON_R4
(*
  ESR_mon_R4 monitores up to 4 Real inputs and reports changes with time stamd and adress label.
  the module checks 4 inputs for a change of more than the specified sensitivity S and reports all changes with time and adress stamp to the output.

  version 1.4 1. dec. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    R0, R1, R2, R3 : REAL;
    DT_in : DT;
  END_VAR
  VAR_INPUT //???CONSTANT
    a0, a1, a2, a3 : STRING[10];
    s0, s1, s2, s3 : REAL;
  END_VAR
  VAR_OUTPUT
    ESR_Flag : BOOL;
  END_VAR
  VAR_IN_OUT
    ESR_Out: OSCAT_BASIC_ARRAY0_3_OF_esr_data; // ARRAY [0..3] OF esr_data;
  END_VAR
  VAR
    p0, p1, p2, p3 : PTR_TO DWORD;
    x0, x1, x2, x3 : REAL;
    tx: TIME;
    cnt : INT;
  END_VAR

  (* read system timer *)
  tx := DWORD_TO_TIME(T_PLC_MS());
  P0 := ADR(R0);
  P1 := ADR(R1);
  P2 := ADR(R2);
  P3 := ADR(R3);

  ESR_Flag := FALSE;
  esr_out[3].typ := 0;
  esr_out[2].typ := 0;
  esr_out[1].typ := 0;
  esr_out[0].typ := 0;
  cnt := 0;

  (* check if inputs have chaged and fill buffer *)
  IF DIFFER(R0,  X0, S0) THEN
    esr_out[cnt].typ := 20;
    esr_out[cnt].adress := a0;
    esr_out[cnt].DS := DT_in;
    esr_out[cnt].TS := TX;
    esr_out[cnt].data[0] := Byte_of_Dword(P0^,0);
    esr_out[cnt].data[1] := Byte_of_Dword(P0^,1);
    esr_out[cnt].data[2] := Byte_of_Dword(P0^,2);
    esr_out[cnt].data[3] := Byte_of_Dword(P0^,3);
    X0 := R0;
    cnt := cnt + 1;
    esr_flag := TRUE;
  END_IF;
  IF differ(R1,  X1, S1) THEN
    esr_out[cnt].typ := 20;
    esr_out[cnt].adress := a1;
    esr_out[cnt].DS := DT_in;
    esr_out[cnt].TS := TX;
    esr_out[cnt].data[0] := Byte_of_Dword(P1^,0);
    esr_out[cnt].data[1] := Byte_of_Dword(P1^,1);
    esr_out[cnt].data[2] := Byte_of_Dword(P1^,2);
    esr_out[cnt].data[3] := Byte_of_Dword(P1^,3);
    X1 := R1;
    cnt := cnt + 1;
    esr_flag := TRUE;
  END_IF;
  IF differ(R2,  X2, S2) THEN
    esr_out[cnt].typ := 20;
    esr_out[cnt].adress := a2;
    esr_out[cnt].DS := DT_in;
    esr_out[cnt].TS := TX;
    esr_out[cnt].data[0] := Byte_of_Dword(P2^,0);
    esr_out[cnt].data[1] := Byte_of_Dword(P2^,1);
    esr_out[cnt].data[2] := Byte_of_Dword(P2^,2);
    esr_out[cnt].data[3] := Byte_of_Dword(P2^,3);
    X2 := R2;
    cnt := cnt + 1;
    esr_flag := TRUE;
  END_IF;
  IF DIFFER(R3,  X3, S3) THEN
    esr_out[cnt].typ := 20;
    esr_out[cnt].adress := a3;
    esr_out[cnt].DS := DT_in;
    esr_out[cnt].TS := TX;
    esr_out[cnt].data[0] := Byte_of_Dword(P3^,0);
    esr_out[cnt].data[1] := Byte_of_Dword(P3^,1);
    esr_out[cnt].data[2] := Byte_of_Dword(P3^,2);
    esr_out[cnt].data[3] := Byte_of_Dword(P3^,3);
    X3 := R3;
    cnt := cnt + 1;
    esr_flag := TRUE;
  END_IF;

(* revision history
  hm  26. jan 2007  rev 1.0
    original version

  hm  17. sep. 2007   rev 1.1
    replaced time() with T_PLC_MS() for compatibility reasons

  hm  8. dec. 2007    rev 1.2
    corrected an error while esr typ would not be set

  hm  16. mar. 2008   rev 1.3
    deleted wrong conversion real_to_dword

  hm  1. dec 2009   rev 1.4
    changed esr_out to be I/O
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Other' *)
FUNCTION STATUS_TO_ESR : esr_data
(*
  status_to_esr creates esr data from a status byte.

  version 1.0 6 oct 2006
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    status : BYTE;
    adress : STRING[10];
    DT_in : DT;
    TS : TIME;
  END_VAR

  IF status < 100 THEN
    status_to_ESR.typ := 1;
  ELSIF status < 200 THEN
    status_to_ESR.typ := 2;
  ELSE
    status_to_ESR.typ := 3;
  END_IF;
  status_to_ESR.adress:= adress;
  status_to_ESR.DS := DT_in;
  status_to_ESR.TS := TS;
  status_to_ESR.data[0] := status;

END_FUNCTION


(* @PATH := '\/Other' *)
FUNCTION_BLOCK ESR_MON_X8
(*
  ESR_MON_X8 is a status and error collector.
  the module checks 8 status inputs for a change and reports up to 4 input changes with time and adress stamp to the output.
  the mode can be
  1 for error only
  2 for error and status
  3 for error, status and debug
  the adress label of the 8 inputs can be configured individually.

  version 1.2 1. dec. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    s0, s1, s2, s3, s4, s5, s6, s7 : BYTE;
    DT_in : DT;
    Mode : BYTE := 3;
  END_VAR
  VAR_INPUT //???CONSTANT
    a0, a1, a2, a3, a4, a5, a6, a7 : STRING[10];
  END_VAR
  VAR_OUTPUT
    ESR_Flag : BOOL;
  END_VAR
  VAR_IN_OUT
    ESR_Out: OSCAT_BASIC_ARRAY0_3_OF_esr_data; // ARRAY [0..3] OF esr_data;
  END_VAR
  VAR
    x0, x1, x2, x3, x4, x5, x6, x7 : BYTE;
    tx: TIME;
    cnt : INT;
  END_VAR

  (* read system timer *)
  tx := DWORD_TO_TIME(T_PLC_MS());

  ESR_Flag := FALSE;
  esr_out[3].typ := 0;
  esr_out[2].typ := 0;
  esr_out[1].typ := 0;
  esr_out[0].typ := 0;
  cnt := 0;


  (* check if inputs have chaged and fill buffer *)
  IF (s0 <> X0) AND ((s0 < 100) OR ((S0 > 99) AND (S0 < 200) AND (mode >= 2)) OR ((S0 > 199) AND (mode = 3))) THEN
    esr_out[cnt] := status_to_ESR(s0, a0, DT_in, TX);
    X0 := S0;
    cnt := cnt + 1;
    esr_flag := TRUE;
  END_IF;
  IF (s1 <> X1) AND ((s1 < 100) OR ((S1 > 99) AND (S1 < 200) AND (mode >= 2)) OR ((S1 > 199) AND (mode = 3))) THEN
    esr_out[cnt] := status_to_ESR(s1, a1, DT_in, TX);
    X1 := S1;
    cnt := cnt + 1;
    esr_flag := TRUE;
  END_IF;
  IF (s2 <> X2) AND ((s2 < 100) OR ((S2 > 99) AND (S2 < 200) AND (mode >= 2)) OR ((S2 > 199) AND (mode = 3))) THEN
    esr_out[cnt] := status_to_ESR(s2, a2, DT_in, TX);
    X2 := S2;
    cnt := cnt + 1;
    esr_flag := TRUE;
  END_IF;
  IF (s3 <> X3) AND ((s3 < 100) OR ((S3 > 99) AND (S3 < 200) AND (mode >= 2)) OR ((S3 > 199) AND (mode = 3))) THEN
    esr_out[cnt] := status_to_ESR(s3, a3, DT_in, TX);
    X3 := S3;
    cnt := cnt + 1;
    esr_flag := TRUE;
  END_IF;
  IF (cnt < 4) AND (s4 <> X4) AND ((s4 < 100) OR ((S4 > 99) AND (S4 < 200) AND (mode >= 2)) OR ((S4 > 199) AND (mode = 3))) THEN
    esr_out[cnt] := status_to_ESR(s4, a4, DT_in, TX);
    X4 := S4;
    cnt := cnt + 1;
    esr_flag := TRUE;
  END_IF;
  IF (cnt < 4) AND (s5 <> X5) AND ((s5 < 100) OR ((S5 > 99) AND (S5 < 200) AND (mode >= 2)) OR ((S5 > 199) AND (mode = 3))) THEN
    esr_out[cnt] := status_to_ESR(s5, a5, DT_in, TX);
    X5 := S5;
    cnt := cnt + 1;
    esr_flag := TRUE;
  END_IF;
  IF (cnt < 4) AND (s6 <> X6) AND ((s6 < 100) OR ((S6 > 99) AND (S6 < 200) AND (mode >= 2)) OR ((S6 > 199) AND (mode = 3))) THEN
    esr_out[cnt] := status_to_ESR(s6, a6, DT_in, TX);
    X6 := S6;
    cnt := cnt + 1;
    esr_flag := TRUE;
  END_IF;
  IF (cnt < 4) AND (s7 <> X7) AND ((s7 < 100) OR ((S7 > 99) AND (S7 < 200) AND (mode >= 2)) OR ((S7 > 199) AND (mode = 3))) THEN
    esr_out[cnt] := status_to_ESR(s7, a7, DT_in, TX);
    X7 := S7;
    cnt := cnt + 1;
    esr_flag := TRUE;
  END_IF;

(* revision history
  hm  26. jan 2007    rev 1.0
    original version

  hm  17. sep 2007  rev 1.1
    replaced time() with T_PLC_MS() for compatibility reasons

  hm  1. dec. 2009  rev 1.2
    changed esr_out to be I/O
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Other' *)
FUNCTION OSCAT_VERSION : DWORD
(*
  oscat_version returns the version number in dword format
  132 is library version 1.32
  if IN = true, the release date will be returned

  version 1.1 16 dec 2007
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    IN : BOOL;
  END_VAR

  IF in THEN
    OSCAT_VERSION := DATE_TO_DWORD(D#2012-01-02);
  ELSE
    OSCAT_VERSION := 333;
  END_IF;

(* revision history
  hm  6. oct 2006 rev 1.0
    original version

  hm  16. dec 2007  rev 1.1
    added possibility to return date and version depending on IN.
*)
END_FUNCTION

