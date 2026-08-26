TYPE
  OSCAT_BASIC_ARRAY0_15_OF_REAL : ARRAY[0..15] OF REAL;
END_TYPE

(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION AIN : REAL
(*
  Ain converts signals from A/D converters or other digital sources to an internal real value
  the lowest number of bits are extracted from the input word and the sign will be extracted if available separately.
  the output signal is then conditioned to range from low to high values for a 0 to max value on the analog inputs:
  for example a 15bit input (bits := 12) with sign at bit 15 (0..15) will deliver 0.0 (low value at 0) for an input value of 2#0000_0000_0000
  an input value of 2#1111_1111_1111 will deliver 10.0 on the output (high value set to 10).

  version 1.5 16 mar 2008
  programmer  oscat
  tested by   tobias
*)
  VAR_INPUT
    in : DWORD;
  END_VAR
  VAR_INPUT //???CONSTANT
    Bits : BYTE;
    sign : BYTE := 255;
    low : REAL;
    high : REAL := 10.0;
  END_VAR
  VAR CONSTANT
    ff : DWORD := 16#FFFFFFFF;
  END_VAR
  VAR
    temp1 : DWORD;
    temp2 : DWORD;
    sx : BOOL;
  END_VAR

  (* extract the sign bit *)
  IF sign < 32 THEN
    temp1 := SHR(in,BYTE_TO_UINT(sign));
    sx := temp1.0;
  ELSE
    sx := FALSE;
  END_IF;
  temp1 := SHR(ff, BYTE_TO_UINT(bits));
  temp2 := in AND temp1;
  AIN := (high - low) * DWORD_TO_REAL(temp2) / DWORD_TO_REAL(temp1) + low;
  IF sx THEN AIN := -AIN; END_IF;

(* revision history
  hm 18.8.2006  rev 1.1
    fixed an error with low value negative and high value 0.

  hm 19.1.2007  rev 1.2
    fixed an error with sign bit.

  hm  13.9.2007 rev 1.3
    changed code to avoid warning under codesys 2.8.1

  hm  2. dec 2007 rev 1.4
    changed code for better performance

  hm  16. mar 2008  rev 1.5
    added type conversions to avoid warnings under codesys 30
*)
END_FUNCTION


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION_BLOCK AIN1
(*
  Ain1 converts signals from A/D converters or other digital sources to an internal real value.

  version 1.3 10. mar. 2009
  programmer  oscat
  tested by   tobias
*)
  VAR_INPUT
    in : DWORD;
  END_VAR
  VAR_INPUT //???CONSTANT
    sign_bit : INT := 255;
    error_bit : INT := 255;
    error_code_en : BOOL;
    error_code : DWORD;
    overflow_bit : INT := 255;
    overflow_code_en : BOOL;
    overflow_code : DWORD;
    Bit_0 : INT;
    Bit_N : INT := 31;
    out_min : REAL;
    out_max : REAL := 10.0;
    code_min : DWORD;
    code_max : DWORD := 16#FFFFFFFF;
    error_output : REAL;
    overflow_output : REAL := 10.0;
  END_VAR
  VAR_OUTPUT
    out : REAL;
    sign : BOOL;
    error : BOOL;
    overflow : BOOL;
  END_VAR
  VAR
    tB: DWORD;
  END_VAR

  (* extract error bit *)
  error := ((SHR(in,INT_TO_UINT(error_bit)) AND 16#0000_0001) = 1) OR (error_code_en AND error_code = in);
  IF error THEN
    out := error_output;
    RETURN;
  END_IF;

  (* strip off the data input *)
  tb := SHR(SHL(in, 31 - INT_TO_UINT(bit_N)), 31 - INT_TO_UINT(bit_N) + INT_TO_UINT(Bit_0));

  (* extract overflow bit *)
  overflow := ((SHR(in,INT_TO_UINT(overflow_bit)) AND 16#0000_0001) = 1) OR (overflow_code_en AND overflow_code = in) OR ((tb < code_min) OR (tb > code_max));
  IF overflow THEN
    out := overflow_output;
    RETURN;
  END_IF;

  (* extract sign bit *)
  sign := (SHR(in,INT_TO_UINT(sign_bit)) AND 16#0000_0001) = 1;

  (* convert in to out *)
  out := (UDINT_TO_REAL(DWORD_TO_UDINT(tb) - DWORD_TO_UDINT(code_min)) * (out_max - out_min) / UDINT_TO_REAL(DWORD_TO_UDINT(code_max) - DWORD_TO_UDINT(code_min)) + out_min);
  IF sign THEN out := out * -1.0; END_IF;

(* revision history
  hm  23. feb 2008  rev 1.0
    original version

  hm  16. mar 2008  rev 1.1
    added type conversions to avoid warnngs under codesys 30

  hm  22. apr. 2008 rev 1.2
    corrected error in formula when code_min was set
    corrected error when sign bit was used
    optimized code for better performance

  hm  10. mar. 2009 rev 1.3
    real constants updated to new systax using dot
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION AOUT : DWORD
(*
  this module conditions an internal real value for D/A converter.
  Aout converts and internal real value to a word for an D/A converter or other output devices.
  The input value is converted to a n-bit wide output and a sign bit is set separately as specified.
  the outout min value is set for the specified min input value and the max output is set for the max input value.
  an input higher or lower then the max or min value will set the respective max or min value or the output.


  version 1.4 23 feb 2008
  programmer  oscat
  tested by   tobias
*)
  VAR_INPUT
    in : REAL;
  END_VAR
  VAR_INPUT //???CONSTANT
    Bits : BYTE;
    sign : BYTE := 255;
    low : REAL;
    high : REAL := 10.0;
  END_VAR
  VAR CONSTANT
    ff : DWORD := 2#1;
  END_VAR
  VAR
    in2 : REAL;
    sx : BOOL;
  END_VAR

  (* if sign bit is defined *)
  IF sign < 32 THEN
    sx := sign_R(in);
    in2 := ABS(in);
  ELSE
    in2 := in;
  END_IF;

  (* begrenze in auf die zulässigen werte *)
  in2 := LIMIT(low, in2, high);

  (* Berechne den Ausgangswert *)
  AOUT := REAL_TO_DWORD((in2 - low) / (high - low) * UDINT_TO_REAL(DWORD_TO_UDINT( SHL(ff, BYTE_TO_UINT(bits))) -1));
  IF sx THEN AOUT := SHL(ff, BYTE_TO_UINT(sign)) OR AOUT; END_IF;

(*
revision history
  hm 18.1.2007    rev 1.1
    renamed Modul to aout.
    changed Output to 32 Bit max.
    corrected error with sign bit.

  hm  13.9.2007   rev 1.2
    changed code to avoid warning under codesys 2.8.1

  hm  2. dec 2007   rev 1.3
    changed code for better performance

  hm  23. feb 2008  rev 1.4
    changed code for better performance
*)
END_FUNCTION


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION AOUT1 : DWORD
(*
  this module conditions an internal real value for a D/A converter.

  version 1.0 23 feb 2008
  programmer  oscat
  tested by   tobias
*)
  VAR_INPUT
    in : REAL;
  END_VAR
  VAR_INPUT //???CONSTANT
    Bit_0 : INT;
    Bit_N : INT := 31;
    sign : INT := 255;
    low : REAL;
    high : REAL := 10.0;
  END_VAR
  VAR CONSTANT
    ff : DWORD := 2#1;
  END_VAR
  VAR
    sx: BOOL;
    in2 : REAL;
  END_VAR

  (* if sign bit is defined *)
  IF sign < 32 THEN
    sx := SIGN_R(in);
    in2 := ABS(in);
  ELSE
    in2 := in;
  END_IF;

  (* begrenze in auf die zulässigen werte *)
  in2 := LIMIT(low, in2, high);

  (* Berechne den Ausgangswert *)
  AOUT1 := SHL(REAL_TO_DWORD((in2 - low) / (high - low) * UDINT_TO_REAL( DWORD_TO_UDINT( SHL(ff, INT_TO_UINT(bit_n - Bit_0 + 1))) -1)), INT_TO_UINT(Bit_0));
  IF sx THEN AOUT1 := SHL(ff, INT_TO_UINT(sign)) OR AOUT1; END_IF;

(* revision history
  hm  23. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION BYTE_TO_RANGE : REAL
(*
  Byte_to_Range converts a Byte into a real between low and high.

  version 1.0 9. jan 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : BYTE;
    low : REAL;
    high : REAL;
  END_VAR

  BYTE_TO_RANGE := ((high - low) * BYTE_TO_REAL(X)) / 255.0 + low;

(* revision history
  hm  9. jan 2008   rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION_BLOCK DELAY
(*
  this function block delays input values by each programm cycle
  after N+1 cycles the in value has shifted to the out.
  N can be any alue from 0 .. 32
  if n = 0 the input will be present on the output without a delay.
  f N > 32 then the output will be delayed by 32 cycles.
  any high on rst will load the buffer with in.

  version 1.5 23. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    IN : REAL;
    N : INT;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    OUT : REAL;
  END_VAR
  VAR
    buf : ARRAY[0..31] OF REAL;
    i : INT;
    init: BOOL;
    stop: INT;
  END_VAR

  stop := LIMIT(0,N,32) - 1;
  IF rst OR NOT init THEN
    init := TRUE;
    FOR i := 0 TO stop DO buf[i] := in; END_FOR;
    out := in;
    i := 0;
  ELSIF stop < 0 THEN
    out := in;
  ELSE
    out := buf[i];
    buf[i] := in;
    i := INC1(i, N);
  END_IF;

(* revision history
  hm 1.10.2006    rev 1.1
    corrected error in buffer management

  hm 19.1.2007    rev 1.2
    changed reset to load the value of in instead of 0

  hm  27. oct. 2008 rev 1.3
    improved performance

  hm  23. feb.2009  rev 1.4
    corrected an index problem

  hm  23. mar. 2009 rev 1.5
    corrected non standard write to input N
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION_BLOCK DELAY_4
(*
  this function block delays input values by each programm cycle
  after 4 cycles the in value has shifted to the out 4 and will be discarded after the next cycle
  the blocks can be cascaded.

  version 1.1 19 jan 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    in : REAL;
  END_VAR
  VAR_OUTPUT
    out1 : REAL;
    out2 : REAL;
    out3 : REAL;
    out4 : REAL;
  END_VAR
  VAR
    temp: REAL;
  END_VAR

  out4 := out3;
  out3 := out2;
  out2 := out1;
  out1 := temp;
  temp := in;

(* revision history
  hm 19.1.2007  rev 1.1
    added variable temp to add 1 delay  for q1
*)
END_FUNCTION_BLOCK


FUNCTION_BLOCK _RMP_W
(*
  _RMP_B generates a ramp on an external var of type byte
  tr is the total ramp time, E is an enable and dir the direction of the ramp

  version 1.1 20. nov. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    DIR : BOOL;
    E : BOOL := TRUE;
    TR : TIME;
  END_VAR
  VAR_IN_OUT
    RMP : WORD;
  END_VAR
  VAR
    tx, tl : DWORD;
    step : DINT;
    init: BOOL;
    last_dir : BOOL;
  END_VAR

  tx := T_PLC_MS();
  IF E AND init THEN
    (* we need to set tl = tx when direction changes *)
    IF dir XOR last_dir THEN
     tl := tx;
     last_dir := dir;
    END_IF;
    (* check_elapsed time and calculate only if necessary *)
    IF tr > t#0s THEN
      //step := DWORD_TO_DINT( SHL(tx-tl, 16) / TIME_TO_DWORD(TR));
      step := UDINT_TO_DINT( DWORD_TO_UDINT( SHL( UDINT_TO_DWORD( DWORD_TO_UDINT(tx)- DWORD_TO_UDINT(tl)), 16)) / TIME_TO_UDINT(TR));
    ELSE
      step := 65535;
    END_IF;
    IF step > 0 THEN
      (* perform the step on the ramp *)
      tl := tx;
      (* calculate the step response *)
      IF NOT dir THEN step := - step; END_IF;
      rmp := DINT_TO_WORD(LIMIT(0, WORD_TO_DINT(rmp) + step, 65535));
    END_IF;
  ELSE
    tl := tx;
    init := TRUE;
  END_IF;

(* revison history
  hm  22. oct. 2008 rev 1.0
    original version

  hm  20. nov. 2008 rev 1.1
    set default for E to be TRUE
    added init
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal generators' *)
FUNCTION_BLOCK RMP_W
(*
  this ramp generator generates a Word wide ramp with 65535 steps
  the generator has an asynchronous set and reset
  the ramp is controlled by PT which is the total ramp time for a full sweep from 0..65535
  an UD input controlls the direction Up or Down and the E input enables the ramp generation
  a busy output indicates that the ramp is running, busy false means output is stable.
  the outputs low and high will be true when the output has reached its max or min value.

  version 2.0 23. oct. 2008
  programmer  oscat
  tested by oscat
*)
  VAR_INPUT
    SET : BOOL;
    PT : TIME;
    E : BOOL := TRUE;
    UP : BOOL := TRUE;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    out : WORD;
    busy : BOOL;
    high : BOOL;
    low : BOOL;
  END_VAR
  VAR
    rmp : _RMP_W;
  END_VAR

  (* generate ramp *)
  rmp(dir := UP, E := E, TR := PT, rmp := out);

  (* set or reset operation *)
  IF RST THEN
    out := 0;
  ELSIF SET THEN
    out := 65535;
  END_IF;

  (* checks for outputs stable and reset or set busy flag *)
  low := out = 0;
  high := out = 65535;
  busy := NOT (low OR high) AND E;

(* revision history:
  hm 4.10.2006    rev 1.1
    added the busy output which signals that the ramp is running.

  hm 22.1.2007    rev 1.2
    deleted unused variable step

  hm  17.9.2007   rev 1.3
    replaced time() with t_plc_ms() for compatibility reasons

  hm  28. sep 2007  rev 1.4
    added outputs on and off
    busy is now disabled while en is false
    new coding for higher accuracy and performance

  hm  5. oct 2007 rev 1.5
    added statements to allow for PT to be t#0s output jumps to max or min immediately

  hm  2. dec 2007 rev 1.6
    corrected an error in calculation of step response

  hm  25. dec 2007  rev 1.7
    corrected an error while step response was too slow for fast rise times

  hm  16. oct. 2008 rev 1.8
    improved performance

  hm  18. oct. 2008 rev 1.9
    renamed inout EN to E for compatibility reasons

  hm  23. oct. 2008 rev 2.0
    new code using _RMP_W
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION_BLOCK FADE
(*
  FADE is used to crossfade between the inputs IN1 and IN2. The fade_over time is specified with TF.
  When F = TRUE then Y = IN2 after the time TF, and when F = FALSE then Y = IN1.

  version 1.3 24. jan. 2009
  programmer  oscat
  tested by   oscat
*)
  VAR_INPUT
    IN1 : REAL;
    IN2 : REAL;
    F : BOOL;
    TF : TIME;
    rst : BOOL;
  END_VAR
  VAR_OUTPUT
    Y : REAL;
  END_VAR
  VAR
    rmx : RMP_W;
  END_VAR

  rmx(rst := rst AND NOT F, set := rst AND F, pt := TF, up := F);
  Y := (in2 - In1) / 65535.0 * WORD_TO_REAL(rmx.out) + in1;

(* code for rev 1.1
  IF rst THEN
    rmx(set := F, rst := NOT F);
  ELSIF F AND (NOT rmx.high) THEN
    rmx(PT := TF, UP := TRUE, e := TRUE, rst := FALSE, set := FALSE);
  ELSIF (NOT F) AND (NOT rmx.low) THEN
    rmx(PT := TF, UP := FALSE, e := TRUE, rst := FALSE, set := FALSE);
  ELSE
    rmx(e := FALSE, rst := FALSE, set := FALSE);
  END_IF;
  Y := (WORD_TO_REAL(rmx.out) * in1 + WORD_TO_REAL(FF - rmx.out) * IN2) / FF;
*)
(* revision history
  hm  26. dec 2007  rev 1.0
    original version

  hm  18. oct. 2008 rev 1.1
    improved performance
    changed calls for rmp_w because rmp_w has chaged

  hm  17. dec. 2008 rev 1.2
    function of input f was inverted

  hm  24. jan. 2009 rev 1.3
    deleted unused var FF
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION_BLOCK FILTER_DW
(*
  FILTER_DW is an low pass filter with a programmable time T used for DWORD format.

  version 1.1 3. nov. 2008
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    X : DWORD;
    T : TIME;
  END_VAR
  VAR_OUTPUT
    Y : DWORD;
  END_VAR
  VAR
    last : DWORD;
    tx: DWORD;
    init: BOOL;
    Yi : REAL;
  END_VAR

  (* read system time *)
  tx := T_PLC_MS();

  (* startup initialisation *)
  IF NOT init OR T = t#0s THEN
    init := TRUE;
    Yi := DWORD_TO_REAL(X);
  ELSE
    Yi := Yi + (DWORD_TO_REAL(X) - DWORD_TO_REAL(Y)) * (DWORD_TO_REAL(tx)-DWORD_TO_REAL(last)) / TIME_TO_REAL(T);
  END_IF;
  last := tx;
  Y := REAL_TO_DWORD(Yi);

(*
  hm 10. oct. 2008  rev 1.0
    original version

  hm  3. nov. 2008  REV 1.1
    corrected an overflow problem
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION_BLOCK FILTER_I
(*
  FILTER_I is a low pass filter with a programmable time T used for INT format.

  version 1.0 8. nov. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : INT;
    T : TIME;
  END_VAR
  VAR_OUTPUT
    Y : INT;
  END_VAR
  VAR
    Yi : DINT;
    last : DWORD;
    tx: DWORD;
    init: BOOL;
  END_VAR

  (* read system time *)
  tx := T_PLC_MS();

  (* startup initialisation *)
  IF NOT init OR T = t#0s THEN
    init := TRUE;
    Yi := INT_TO_DINT(X) * 1000;
  ELSE
    (* to increase accuracy of the filter we calculate internal Yi wich is Y * 1000 *)
    Yi := Yi + INT_TO_DINT(X - Y) * (DWORD_TO_DINT(tx)-DWORD_TO_DINT(last)) * 1000 / TIME_TO_DINT(T);
  END_IF;
  last := tx;
  Y := DINT_TO_INT(yi / 1000);

(*
  hm 8. nov. 2008 rev 1.0
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION_BLOCK FILTER_MAV_DW
(*
  FILTER_MAV_DW is a moving average filter with programmable length N for DWORD Data.

  version 1.3 23. feb. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    X : DWORD;
    N : UINT;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    Y : DWORD;
  END_VAR
  VAR
    init: BOOL;
    buffer : ARRAY[0..31] OF DWORD;
    i: INT;
  END_VAR
  VAR_TEMP
    tmp: INT;
  END_VAR

  (* limit N to size of buffer *)
  N := MIN(N, 32);

  (* startup initialisation *)
  IF NOT init OR rst OR N = 0 THEN
    init := TRUE;
    tmp := UINT_TO_INT(N)-1;
    FOR i := 0 TO tmp DO
      buffer[i] := X;
    END_FOR;
    Y := X;
  ELSE
    tmp := UINT_TO_INT(N);
    i := INC1(i, tmp);
    Y := UDINT_TO_DWORD( DWORD_TO_UDINT(Y) + (DWORD_TO_UDINT(X) - DWORD_TO_UDINT(buffer[i])) / UINT_TO_UDINT(N));
    buffer[i] := X;
  END_IF;

(*
  hm 13. oct. 2008  rev 1.0
    original version

  hm  27. oct. 2008 rev 1.1
    added typecast to avoid warnings

  hm  24. nov. 2008 rev 1.2
    added typecasts to avoid warnings
    avoid divide by 0 if N = 0

  hm  23. feb. 2009 rev 1.3
    limit N to max array size
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION_BLOCK FILTER_MAV_W
(*
  FILTER_MAV_W is a moving average filter with programmable length N for WORD Data.

  version 1.4 26. MAR. 2011
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    X : WORD;
    N : UINT;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    Y : WORD;
  END_VAR
  VAR
    init: BOOL;
    buffer : ARRAY[1..32] OF WORD;
    i: INT;
    sum : DWORD;
  END_VAR
  VAR_TEMP
    tmp : INT;
  END_VAR

  (* limit N to size of buffer *)
  N := MIN(N, 32);

  (* startup initialisation *)
  IF NOT init OR rst OR N = 0 THEN
    init := TRUE;
    tmp := UINT_TO_INT(N) - 1;
    FOR i := 1 TO tmp DO
      buffer[i] := X;
    END_FOR;
    sum := UDINT_TO_DWORD( WORD_TO_UDINT(Y) * UINT_TO_UDINT(N));
    Y := X;
  ELSE
    tmp := UINT_TO_INT(N);
    i := INC1(i, tmp);
    sum := UDINT_TO_DWORD( DWORD_TO_UDINT(sum) + WORD_TO_UDINT(X) - WORD_TO_UDINT(buffer[i]));
    Y := UDINT_TO_WORD( DWORD_TO_UDINT(sum) / UINT_TO_UDINT(N));
    buffer[i] := X;
  END_IF;

(*
  hm 13. oct. 2008  rev 1.0
    original version

  hm  18. oct. 2008 rev 1.1
    added typecast to avoid warnings

  hm  24. nov. 2008 rev 1.2
    added typecasts to avoid warnings
    avoid devide by 0 if N = 0

  hm  23. feb. 2009 rev 1.3
    limit N to max array size

  hm  26. mar. 2011 rev 1.4
    corrected error in calculation
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION_BLOCK FILTER_W
(*
  FILTER_W is an low pass filter with a programmable time T used for WORD format.

  version 1.2 25. jan. 2011
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : WORD;
    T : TIME;
  END_VAR
  VAR_OUTPUT
    Y : WORD;
  END_VAR
  VAR
    last : DWORD;
    tx: DWORD;
    init: BOOL;
    tmp: DWORD;
  END_VAR

  (* read system time *)
  tx := T_PLC_MS();

  (* startup initialisation *)
  IF NOT init OR T = T#0s THEN
    init := TRUE;
    last := tx;
    Y := X;
  ELSIF Y = X THEN
    last := tx;
  ELSE
    tmp :=  UDINT_TO_DWORD((WORD_TO_UDINT(X) - WORD_TO_UDINT(Y)) * (DWORD_TO_UDINT(tx) - DWORD_TO_UDINT(last)) / TIME_TO_UDINT(T));
    IF tmp <> 0 THEN
      Y := DINT_TO_WORD(WORD_TO_DINT(Y) + DWORD_TO_DINT(tmp));
      last := tx;
    END_IF;
  END_IF;

(*
  hm 10. oct. 2008  rev 1.0
    original version

  hm  3. nov. 2008  rev 1.1
    fixed overflow problem in formula

  hm  25. jan. 2011 rev 1.2
    fixed error in formula
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION_BLOCK FILTER_WAV
(*
  FILTER_WAV is a moving average filter with programmable length N for DWORD Data.

  version 1.2 10. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    X : REAL;
    W : ARRAY[0..15] OF REAL;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    Y : REAL;
  END_VAR
  VAR
    init: BOOL;
    buffer : ARRAY[0..15] OF REAL;
    i: INT;
    n: INT;
  END_VAR

  (* startup initialisation *)
  IF NOT init OR rst THEN
    init := TRUE;
    FOR i := 0 TO 15 DO
      buffer[i] := X;
    END_FOR;
    i := 15;
    Y := X;
  ELSE
    i := INC1(i, 16);
    buffer[i] := X;
  END_IF;

  (* calculate the weighted average *)
  Y := 0.0;
  FOR n := 0 TO 15 DO
    Y := buffer[i] * W[n] + Y;
    i := DEC1(i, 16);
  END_FOR;

(*
  hm  14. oct. 2008 rev 1.0
    original version

  hm  27. oct. 2008 rev 1.1
    changed _DEC and _INC to DEC1 and INC1

  hm  10. mar. 2009 rev 1.2
    real constants updated to new systax using dot
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION MIX : REAL
(*
  MIX is an analog Mixer. The Output is (1-M)*A + M*B.

  version 1.1 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    A, B : REAL;
    M : REAL;
  END_VAR

  MIX := (1.0 - M) * A + M * B;

(* revision history
  hm  19. Nov 2007  rev 1.0
    original version

  hm  10. mar 2009  rev 1.1
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION MUX_R2 : REAL
(*
  MUX_R2 is an analog Multiplexer.
  one of 2 real inputs are selected and put through to out.
  The Adress input A selects between 2 Real inputs IN0 and IN1, A=0 > In0, A=1 > in1.

  version 1.1 16. oct. 2008
  programmer  oscat
  tested by oscat
*)
  VAR_INPUT
    IN0 : REAL;
    IN1 : REAL;
    A : BOOL;
  END_VAR

  MUX_R2 := SEL(A, IN0, IN1);

(* revision history
  hm  19. jan. 2007 rev 1.0
    original version

  hm  16. oct. 2008 rev 1.1
    improved performance
*)
END_FUNCTION


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION MUX_R4 : REAL
(*
  MUX_R4 is an analog Multiplexer.
  one of 4 real inputs are selected and put through to out.
  The Adress input A0 and A1 selects between the 4 Real inputs IN0.. IN1.

  version 1.1 16. oct. 2008
  programmer  oscat
  tested by oscat
*)
  VAR_INPUT
    IN0 : REAL;
    IN1 : REAL;
    IN2 : REAL;
    IN3 : REAL;
    A0 : BOOL;
    A1 : BOOL;
  END_VAR

  IF A1 THEN
    MUX_R4 := SEL(A0, IN2, IN3);
  ELSE
    MUX_R4 := SEL(A0, IN0, IN1);
  END_IF;

(* revision history
  hm  19. jan 2007  rev 1.0
    original version

  hm  16. oct. 2008 rev 1.1
    improved performance
*)
END_FUNCTION


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION OFFSET : REAL
(*
  The Function offset adds offsets to an analog signal depending on digital inputs.
  all selected offsets are added at the same time.
  with the input D a default value instead of the input X can be used.

  version 1.0 12 jan 2007
  programmer  oscat
  tested by oscat
*)
  VAR_INPUT
    X : REAL;
    O1, O2, O3, O4 : BOOL;
    D : BOOL;
  END_VAR
  VAR_INPUT //???CONSTANT
    Offset_1 : REAL;
    Offset_2 : REAL;
    Offset_3 : REAL;
    Offset_4 : REAL;
    default : REAL;
  END_VAR
  VAR_TEMP
    tmp : REAL;
  END_VAR

  IF D THEN tmp := default; ELSE tmp := X; END_IF;
  IF O1 THEN tmp := tmp + offset_1; END_IF;
  IF O2 THEN tmp := tmp + offset_2; END_IF;
  IF O3 THEN tmp := tmp + offset_3; END_IF;
  IF O4 THEN tmp := tmp + offset_4; END_IF;
  OFFSET := tmp;

(* revision history
  hm  12. jan 2007
    original version
*)
END_FUNCTION


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION OFFSET2 : REAL
(*
  The Function offset adds offsets to an analog signal depending on digital inputs.
  one offset can be added at the same time, if more then one input is true, the one with the highest number (o1 .. o4) will be used.
  The input D will select a default value instead of X for input.

  version 1.0 12 jan 2007
  programmer  oscat
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
    O1, O2, O3, O4 : BOOL;
    D : BOOL;
  END_VAR
  VAR_INPUT //???CONSTANT
    Offset_1 : REAL;
    Offset_2 : REAL;
    Offset_3 : REAL;
    Offset_4 : REAL;
    default : REAL;
  END_VAR
  VAR_TEMP
    tmp : REAL;
  END_VAR

  IF D THEN tmp := default; ELSE tmp := X; END_IF;
  IF O4 THEN tmp := tmp + offset_4;
  ELSIF O3 THEN tmp := tmp + offset_3;
  ELSIF O2 THEN tmp := tmp + offset_2;
  ELSIF O1 THEN tmp := tmp + offset_1;
  END_IF;
  OFFSET2 := tmp;

(* revision history
  hm  12. jan 2007
    original version
*)
END_FUNCTION


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION OVERRIDE : REAL
(*
  OVERRIDE deliveres the maximum absolute value of the 3 inputs X1, X2 and X3.
  with the inputs E1, E2 and E3 each of the 3 inputs can be turned on or off.

  version 1.0 4 nov 2007
  programmer  oscat
  tested by tobias
*)
  VAR_INPUT
    X1, X2, X3 : REAL;
    E1 : BOOL;
    E2 : BOOL;
    E3 : BOOL;
  END_VAR
  VAR_TEMP
    tmp : REAL;
  END_VAR

  IF E1 THEN tmp := X1; END_IF;
  IF E2 AND ABS(x2) > ABS(tmp) THEN tmp := X2; END_IF;
  IF E3 AND ABS(x3) > ABS(tmp) THEN tmp := X3; END_IF;
  OVERRIDE := tmp;

(* revision history
  hm  4.11.2007   rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION RANGE_TO_BYTE : BYTE
(*
  Range_to_byte converts a real value between low and high into a byte

  version 1.0 9. jan 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
    low : REAL;
    high : REAL;
  END_VAR
  VAR_TEMP
    tmp : REAL;
  END_VAR

  //???RANGE_TO_BYTE := INT_TO_BYTE( TRUNC((LIMIT(low, X, high) - low) * 255.0 / (high - low)));
  tmp := ((LIMIT(low, X, high) - low) * 255.0) / (high - low);
  RANGE_TO_BYTE := INT_TO_BYTE( TRUNC( tmp));

(* revision history
  hm  9. jan 2008   rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION RANGE_TO_WORD : WORD
(*
  Range_to_word converts a real value between low and high into a byte

  version 1.0 9. jan 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
    low : REAL;
    high : REAL;
  END_VAR
  VAR_TEMP
    tmp : REAL;
  END_VAR

  //???RANGE_TO_WORD := DINT_TO_WORD(TRUNC((LIMIT(low,X,high)-low) * 65535.0 / (high - low)));
  tmp := ((LIMIT(low,X,high)-low) * 65535.0) / (high - low);
  RANGE_TO_WORD := DINT_TO_WORD(TRUNC(tmp));

(* revision history
  hm  9. jan 2008   rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION SCALE : REAL
(*
  Scale is used to translate an input x to output by the formula Y = X*K + O.
  at the same time the output is limited to MN and MX.

  version 1.0 16. may. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
    K : REAL;
    O : REAL;
    MX : REAL;
    MN : REAL;
  END_VAR

  SCALE := LIMIT(MN, X * K + O, MX);


(* revision history
  hm  16. may. 2008   rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION SCALE_B : REAL
(*
  Scale_B is used to translate and scale a byte input x to a real output.

  version 1.1 18. jan. 2011
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : BYTE;
    I_LO : BYTE;
    I_HI : BYTE;
    O_LO : REAL;
    O_HI : REAL;
  END_VAR

  IF I_HI = I_LO THEN
    SCALE_B := O_LO;
  ELSE
    SCALE_B := (O_HI - O_LO) / (BYTE_TO_REAL(I_HI) - BYTE_TO_REAL(I_LO)) * BYTE_TO_REAL(LIMIT(I_LO, X, I_HI));
  END_IF;

(* revision history
  hm  18. may. 2008   rev 1.0
    original version

  hm  18. jan 2011    rev 1.1
    avoid division by 0
*)
END_FUNCTION


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION SCALE_B2 : REAL
(*
  this function block can scale up to two inputs.
  inputs have their min value at 0 and their max value at 255 while the min and max value can be either positive or negative.
  inputs ramp between min and max values for the respective inputs to be between (0..255).
  the summed output is then scaled by an scale input K and a offset O can be added to the output.
  min and max input configurations can be edited in the cfc editor by double clicking the symbol body.

  version 1.4 3. nov. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    in1: BYTE;
    in2: BYTE;
    K : REAL;
    O : REAL;
  END_VAR
  VAR_INPUT //???CONSTANT
    in1_min: REAL;
    in1_max: REAL := 1000.0;
    in2_min: REAL;
    in2_max: REAL := 1000.0;
  END_VAR

  SCALE_B2 :=   (((in1_max - in1_min)* BYTE_TO_REAL(in1) + (in2_max - in2_min)* BYTE_TO_REAL(in2)) * 0.003921569 + in1_min + in2_min) * K + O;


(* revision History
  hm 19.1.2007    rev 1.1
    changed outputs to real to avoid overflow of integer
    added offset for better cascading of scale functions
    changed from FB to function

  hm  6. jan 2008   rev 1.2
    improved performance

  hm  26. oct. 2008 rev 1.3
    code optimization

  hm  3. nov. 2008  rev 1.4
    used wrong factor in formula
*)
END_FUNCTION


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION SCALE_B4 : REAL
(*
  this functiob block can scale up to 4 inputs.
  the inputs have their min value at 0 and their max value at 255 while the min and max value can be either positive or negative.
  the inputs ramp between min and max values for the respective inputs to be between (0..255).
  the summed output is then scaled by an scale input K and a offset O can be added to the output.
  the min and max input configurations can be edited in the cfc editor by double clicking the symbol body.

  version 1.4 3. nov. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    in1: BYTE;
    in2: BYTE;
    in3: BYTE;
    in4: BYTE;
    K : REAL;
    O : REAL;
  END_VAR
  VAR_INPUT //???CONSTANT
    in1_min: REAL;
    in1_max: REAL := 1000.0;
    in2_min: REAL;
    in2_max: REAL := 1000.0;
    in3_min: REAL;
    in3_max: REAL := 1000.0;
    in4_min: REAL;
    in4_max: REAL := 1000.0;
  END_VAR

  SCALE_B4 :=   (((in1_max - in1_min)* BYTE_TO_REAL(in1) +
                  (in2_max - in2_min)* BYTE_TO_REAL(in2) +
                  (in3_max - in3_min)* BYTE_TO_REAL(in3) +
                  (in4_max - in4_min)* BYTE_TO_REAL(in4))* 0.003921569 + in1_min + in2_min + in3_min + in4_min) * K + O;

(* revision History
  hm 19.1.2007    rev 1.1
    changed outputs to real to avoid overflow of integer
    added offset for better cascading of scale functions
    changed from fb to function

  hm  6. jan 2008   rev 1.2
    improved performance

  hm  26. oct. 2008 rev 1.3
    optimized code

  hm  3. nov. 2008  rev 1.4
    used wrong factor in formula
*)
END_FUNCTION


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION SCALE_B8 : REAL
(*
  this functiob block can scale up to 8 inputs.
  the inputs have their min value at 0 and their max value at 255 while the min and max value can be either positive or negative.
  the inputs ramp between min and max values for the respective inputs to be between (0..255).
  the summed output is then scaled by an scale input K and a offset O can be added to the output.
  the min and max input configurations can be edited in the cfc editor by double clicking the symbol body.

  version 1.4 3. nov. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    in1: BYTE;
    in2: BYTE;
    in3: BYTE;
    in4: BYTE;
    in5: BYTE;
    in6: BYTE;
    in7: BYTE;
    in8: BYTE;
    K : REAL;
    O : REAL;
  END_VAR
  VAR_INPUT //???CONSTANT
    in1_min: REAL;
    in1_max: REAL := 1000.0;
    in2_min: REAL;
    in2_max: REAL := 1000.0;
    in3_min: REAL;
    in3_max: REAL := 1000.0;
    in4_min: REAL;
    in4_max: REAL := 1000.0;
    in5_min: REAL;
    in5_max: REAL := 1000.0;
    in6_min: REAL;
    in6_max: REAL := 1000.0;
    in7_min: REAL;
    in7_max: REAL := 1000.0;
    in8_min: REAL;
    in8_max: REAL := 1000.0;
  END_VAR

  SCALE_B8 :=   (((in1_max - in1_min)* BYTE_TO_REAL(in1) +
                  (in2_max - in2_min)* BYTE_TO_REAL(in2) +
                  (in3_max - in3_min)* BYTE_TO_REAL(in3) +
                  (in4_max - in4_min)* BYTE_TO_REAL(in4) +
                  (in5_max - in5_min)* BYTE_TO_REAL(in5) +
                  (in6_max - in6_min)* BYTE_TO_REAL(in6) +
                  (in7_max - in7_min)* BYTE_TO_REAL(in7) +
                  (in8_max - in8_min)* BYTE_TO_REAL(in8)) * 0.003921569 + in1_min + in2_min + in3_min + in4_min + in5_min + in6_min + in7_min + in8_min) * K + O;

(* revision History
  hm  19. jan.2007  rev 1.1
    changed outputs to real to avoid overflow of integer
    added offset for better cascading of scale functions

  hm  6. jan. 2008  rev 1.2
    improved performance

  hm  26. oct. 2008 rev 1.3
    code optimization

  hm  3. nov. 2008  rev 1.4
    used wrong factor in formula
*)
END_FUNCTION


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION SCALE_D : REAL
(*
  Scale_D is used to translate and scale a DWORD input x to a real output.
  the input is limited to I_LO <= X <= I_HI.

  version 1.2 11. jan. 2011
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    X : DWORD;
    I_LO : DWORD;
    I_HI : DWORD;
    O_LO : REAL;
    O_HI : REAL;
  END_VAR

  IF I_HI = I_LO THEN
    SCALE_D := O_LO;
  ELSE
    SCALE_D := (O_HI - O_LO) / (DWORD_TO_REAL(I_HI) - DWORD_TO_REAL(I_LO)) * (DWORD_TO_REAL( LIMIT(I_LO, X, I_HI)) - DWORD_TO_REAL(I_LO)) + O_LO;
  END_IF;

(* revision history
  hm  18. may. 2008 rev 1.0
    original version

  hm  13. nov. 2008 rev 1.1
    corrected formula for negative gradient

  hm  11. jan 2011  rev 1.2
    avoid division by 0
*)
END_FUNCTION


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION SCALE_R : REAL
(*
  Scale_R is used to translate and scale a REAL input x to a real output.
  the input is limited to I_LO <= X <= I_HI.

  version 1.2 11. jan. 2011
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    X : REAL;
    I_LO : REAL;
    I_HI : REAL;
    O_LO : REAL;
    O_HI : REAL;
  END_VAR

  IF I_LO = I_HI THEN
    SCALE_R := O_LO;
  ELSE
    SCALE_R := (O_HI - O_LO) / (I_HI - I_LO) * (LIMIT(I_LO, X, I_HI) - I_LO) + O_LO;
  END_IF;

(* revision history
  hm  18. may. 2008 rev 1.0
    original version

  hm  13. nov. 2008 rev 1.1
    corrected formula for negative gradient

  hm  11. jan 2011  rev 1.2
    avoid division by 0
*)
END_FUNCTION


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION SCALE_X2 : REAL
(*
  this functiob block can scale up to two inputs.
  the input can select between two values with true or false.
  the summed output is then scaled by an scale input K and a offset O can be added to the output.
  the min and max input configurations can be edited in the cfc editor by double clicking the symbol body.

  version 1.1 26. oct. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IN1: BOOL;
    IN2: BOOL;
    K : REAL;
    O : REAL;
  END_VAR
  VAR_INPUT //???CONSTANT
    IN1_MIN: REAL;
    IN1_MAX: REAL := 1000.0;
    IN2_MIN: REAL;
    IN2_MAX: REAL := 1000.0;
  END_VAR

  SCALE_X2 := (SEL(IN1, IN1_MIN, IN1_MAX)+ SEL(IN2, IN2_MIN, IN2_MAX)) * k + o;


(* revision history
  hm  19. jan, 2007 rev 1.0
    original version

  hm  26. oct. 2008 rev 1.1
    code optimized
*)
END_FUNCTION


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION SCALE_X4 : REAL
(*
  this function can scale up to 4 inputs.
  the input can select between two values with true or false.
  the summed output is then scaled by an scale input K and a offset O can be added to the output.
  the min and max input configurations can be edited in the cfc editor by double clicking the symbol body.

  version 1.1 26. oct. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IN1: BOOL;
    IN2: BOOL;
    IN3: BOOL;
    IN4: BOOL;
    K : REAL;
    O : REAL;
  END_VAR
  VAR_INPUT //???CONSTANT
    IN1_MIN: REAL;
    IN1_MAX: REAL := 1000.0;
    IN2_MIN: REAL;
    IN2_MAX: REAL := 1000.0;
    IN3_MIN: REAL;
    IN3_MAX: REAL := 1000.0;
    IN4_MIN: REAL;
    IN4_MAX: REAL := 1000.0;
  END_VAR

  SCALE_X4 := (SEL(IN1,IN1_MIN, IN1_MAX) + SEL(IN2, IN2_MIN, IN2_MAX)+SEL(IN3, IN3_MIN, IN3_MAX)+ SEL(IN4, IN4_MIN, IN4_MAX)) * k + o;

(* revision history
  hm  19. jan. 2008 rev 1.0
    original version

  hm  26. oct. 2008 rev 1.1
    optimized code
*)
END_FUNCTION


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION SCALE_X8 : REAL
(*
  this function can scale up to 4 inputs.
  the input can select between two values with true or false.
  the summed output is then scaled by an scale input K and a offset O can be added to the output.
  the min and max input configurations can be edited in the cfc editor by double clicking the symbol body.

  version 1.2 24. jan. 2009
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    in1: BOOL;
    in2: BOOL;
    in3: BOOL;
    in4: BOOL;
    in5: BOOL;
    in6: BOOL;
    in7: BOOL;
    in8: BOOL;
    K : REAL;
    O : REAL;
  END_VAR
  VAR_INPUT //???CONSTANT
    in1_min: REAL;
    in1_max: REAL := 1000.0;
    in2_min: REAL;
    in2_max: REAL := 1000.0;
    in3_min: REAL;
    in3_max: REAL := 1000.0;
    in4_min: REAL;
    in4_max: REAL := 1000.0;
    in5_min: REAL;
    in5_max: REAL := 1000.0;
    in6_min: REAL;
    in6_max: REAL := 1000.0;
    in7_min: REAL;
    in7_max: REAL := 1000.0;
    in8_min: REAL;
    in8_max: REAL := 1000.0;
  END_VAR

  SCALE_X8 := (SEL(IN1,IN1_MIN, IN1_MAX)+ SEL(IN2,IN2_MIN, IN2_MAX)+SEL(IN3,IN3_MIN, IN3_MAX)+ SEL(IN4,IN4_MIN, IN4_MAX)
              +SEL(IN5,IN5_MIN, IN5_MAX)+ SEL(IN6,IN6_MIN, IN6_MAX)+SEL(IN7,IN7_MIN, IN7_MAX)+ SEL(IN8,IN8_MIN, IN8_MAX)) * k + o;

(* revision history
  hm  19. jan. 2008 rev 1.0
    original version

  hm  26. oct. 2008 rev 1.1
    optimized code

  hm  24. jan. 2008 rev 1.2
    corrected error in formula
*)
END_FUNCTION


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION_BLOCK SEL2_OF_3
(*
  SEL2_OF_3 checks if 3 input Signals are within a distance D from each other and calculates the average of the 3 inputs do not offset more than D from each other.
  If 1 input is more than D greater or smaller than any other input it will be ignored and the average will be calcualted from the remaining 2 Inputs.
  In the case the Output is only calculated from 2 Inputs a Warning Output W will display the Number of the discarded Input. if none of the 3 Inputs are within the allowed Delata D from each other,
  an Error Output E is set True and the last valid Output will remain active until at least 2 Inputs are within a valid Range from each other.

  version 1.1 10. mar. 2009
  programmer  oscat
  tested by   oscat
*)
  VAR_INPUT
    IN1 : REAL;
    IN2 : REAL;
    IN3 : REAL;
    D : REAL;
  END_VAR
  VAR_OUTPUT
    Y : REAL;
    W : INT;
    E : BOOL;
  END_VAR
  VAR
    D12: BOOL;
    D23: BOOL;
    D31: BOOL;
  END_VAR

  D12 := ABS(IN1-IN2) <= D;
  D23 := ABS(IN2-IN3) <= D;
  D31 := ABS(IN3-IN1) <= D;

  IF (D12 AND D23) OR (D12 AND D31) OR (D23 AND D31) THEN
    (* all 3 inputs are valid *)
    Y := (IN1 + IN2 + IN3) * 0.333333333333;
    E := FALSE;
    W := 0;
  ELSIF D12 THEN
    (* only inut 1 and 2 are valid *)
    Y := (In1 + IN2) * 0.5;
    E := FALSE;
    W := 3;
  ELSIF D23 THEN
    (* only inut 2 and 3 are valid *)
    Y := (In2 + IN3) * 0.5;
    E := FALSE;
    W := 1;
  ELSIF D31 THEN
    (* only inut 3 and 1 are valid *)
    Y := (In3 + IN1) * 0.5;
    E := FALSE;
    W := 2;
  ELSE
    (* no calculation possible *)
    E := TRUE;
    W := 4;
  END_IF;

(* revision history
  hm  18. may 2008  rev 1.0
    original version

  hm  10. mar. 2009 rev 1.1
    improved code
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION_BLOCK SEL2_OF_3B
(*
  SEL2_OF_3B is used to connect 3 binary sensors to one signal. the output Q reflects the state of at least two inputs.
  if two or more of the 3 inputs ate TRUE then Q will be TRUE and if two or more of the three inputs are FALSE then Q will be false.
  the main putrpose is the connection of 3 redundant binary sensors.
  The output W will be active when one of the 3 inputs is of different state.
  to avoid flickering while the sensors are switching the output W will become active after a programmed delay of TD.

  version 1.0 19. may. 2008
  programmer  oscat
  tested by   oscat
*)
  VAR_INPUT
    IN1 : BOOL;
    IN2 : BOOL;
    IN3 : BOOL;
    TD : TIME;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
    W : BOOL;
  END_VAR
  VAR
    TDEL : TON;
  END_VAR

  Q := (IN1 AND IN2) OR (IN1 AND IN3) OR (IN2 AND IN3);
  TDEL(IN := (in1 XOR in2) OR (in1 XOR in3) OR (in2 XOR in3), PT := TD);
  W := TDEL.Q;

(* revision history
  hm    19. may 2008  rev 1.0
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION_BLOCK SH
(*
  this sample and hold module samples an input at the rising edge of clk an stores it in out.
  the out stays stable until the next rising clk edge appears.
  a trigger output as active for one cycle when the output was updated.

  version 1.1 16 jan 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    in : REAL;
    CLK : BOOL;
  END_VAR
  VAR_OUTPUT
    out : REAL;
    trig : BOOL;
  END_VAR
  VAR
    edge : BOOL;
  END_VAR

  IF clk AND NOT edge THEN
    out := in;
    trig := TRUE;
  ELSE;
    trig := FALSE;
  END_IF;
  edge := clk;

(* revision history
  hm 16.1.2007  rev 1.1
    added trig output
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION_BLOCK SH_1
(*
  this sample and hold module samples an input every PT seconds.
  after a ample is taken the output Trig will be active for one cycle.

  version 1.2 17 sep 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    in : REAL;
    PT : TIME;
  END_VAR
  VAR_OUTPUT
    out : REAL;
    Trig : BOOL;
  END_VAR
  VAR
    last : TIME;
    tx: TIME;
  END_VAR

  (* read system time *)
  tx := DWORD_TO_TIME(T_PLC_MS());

  IF tx - last >= PT THEN
    last := tx;
    out := in;
    trig := TRUE;
  ELSE
    trig := FALSE;
  END_IF;

(* revision history
  HM  6.1.2007  rev 1.1
    added trig output

  HM  17.9.2007 rev 1.2
    replaced time() with T_PLC_MS() for compatibility reasons
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION_BLOCK SH_2
(*
  this sample and hold module samples an input every PT seconds.
  this sample and hold also does avg and other calculations with the input data.
  an average is calculated over N samples while for this calculation disc samples are discarded,
  disc = 0 all samples are averaged,
  if disc = 1 the lowest value is ignored,
  if disc = 2 the lowest and highest values are ignored,
  and so on.....

  version 1.6 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    in : REAL;
    PT : TIME;
    N : INT := 16;
    disc : INT;
  END_VAR
  VAR_OUTPUT
    out : REAL;
    trig : BOOL;
    avg : REAL;
    high: REAL;
    low: REAL;
  END_VAR
  VAR
    M : INT;
    buf : OSCAT_BASIC_ARRAY0_15_OF_REAL;
    buf2 : OSCAT_BASIC_ARRAY0_15_OF_REAL;
    last : TIME;
    i : INT;
    start: INT;
    temp: REAL;
    stop: INT;
    tx: TIME;
    d2: INT;
  END_VAR

  (* read system time *)
  tx := DWORD_TO_TIME(T_PLC_MS());
  d2 := WORD_TO_INT( SHR( INT_TO_WORD(disc),1));

  IF tx - last >= PT THEN
    last := tx;
    trig := TRUE;

    (* limit M to 0..16 *)
    M := LIMIT(1,N,16);

    (* edge detected lets take the sample *)
    FOR i := M - 1 TO 1 BY -1 DO buf2[i] := buf2[i-1]; END_FOR;
    buf2[0] := in;
    out := in;
    buf := buf2;

    (* sort the ARRAY lowest value AT 0 *)
    FOR start := 0 TO M - 2 DO
      FOR i := start+1 TO M - 1 DO
        IF buf[start] > buf[i] THEN
          temp := buf[start];
          buf[start] := buf[i];
          buf[i] := temp;
        END_IF;
      END_FOR;
    END_FOR;

    (* any calculation with the samples is here *)
    stop := M - 1 - d2;
    start := d2;
    IF NOT even( INT_TO_DINT(disc)) THEN start := start + 1; END_IF;
    avg := 0.0;
    FOR i := start TO stop DO avg := avg + buf[i]; END_FOR;
    avg := avg / INT_TO_REAL(stop - start +1);
    low := buf[start];
    high := buf[stop];
  ELSE
    Trig := FALSE;
  END_IF;

(* revision history
  hm 20. jan. 2007  rev 1.1
    added input N to specify the amout of samples for average and high low calculations
    added trig output

  hm 10. sep. 2007  rev 1.2
    an error would be generated if N was set to 0, now n is forced to1 if set to 0.
    index was out of array.

  hm  17. sep. 2007 rev 1.3
    replaced time() with t_plc_ms() for compatibility reasons

  hm  6. jan. 2008  rev 1.4
    improved performance

  hm  14. jun. 2008 rev 1.5
    set default for input N = 16

  hm  10. mar. 2009 rev 1.6
    added type conversion for compatibility reasons
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION_BLOCK SH_T
(*
  this sample and hold module samples an input while en is high.
  during the high time of en the output follows in.
  the out stays stable until the en goes high again.

  version 1.1 18. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    IN : REAL;
    E : BOOL;
  END_VAR
  VAR_OUTPUT
    OUT : REAL;
  END_VAR

  IF E THEN out := in; END_IF;

(* revision history
  hm  1. sep. 2006  rev 1.0
    original version

  hm  18. oct. 2008 rev 1.1
    changed input en to e for compatibility reasons
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION STAIR : REAL
(*
  the function stair converts an anlog input signal to a staircase like output.
  D is the step width for the output signal.
  if D = 0 then the output follows the input without a chage.

  version 1.4 10. mar. 2009
  programmer  oscat
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
    D : REAL;
  END_VAR

  IF D > 0.0 THEN
    STAIR := DINT_TO_REAL(REAL_TO_DINT(X / D)) * D;
  ELSE
    STAIR := X;
  END_IF;

(* revision history
  hm  28 jan 2007   rev 1.0
    original version

  hm  27 dec 2007   rev 1.1
    changed code for better performance

  hm  6. jan 2008   rev 1.2
    further performance improvement

  hm  26. oct. 2008   rev 1.3
    optimized code

  hm  10. mar. 2009 rev 1.4
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION_BLOCK STAIR2
(*
  the function stair2 converts an anlog input signal to a staircase like output.
  D is the step width for the output signal. the output will use D as a hysteresis for a stairchange.
  if D = 0 then the output follows the input without a chage.

  version 1.4 10. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    X : REAL;
    D : REAL;
  END_VAR
  VAR_OUTPUT
    Y: REAL;
  END_VAR

  IF D > 0.0 THEN
    IF X >= Y + D OR X <= Y - D THEN Y := FLOOR(X/D) * D; END_IF;
  ELSE
    Y := X;
  END_IF;

(* revision history
  hm  28 jan 2007   rev 1.0
    original version

  hm  27. dec 2007  rev 1.1
    changed code for better performance

  hm  30. jun. 2008 rev 1.2
    added type conversions to avoid warnings under codesys 3.0

  ks  26. oct. 2008 rev 1.3
    improved code

  hm  10. mar. 2009 rev 1.4
    real constants updated to new systax using dot
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION_BLOCK TREND
(*
  trend analyses the trend of a input signal.
  The Output Q is True if the input X is >= last_X and is false if the input X is <= last_X
  in addition to the trend the output TU will be high for one cycle to signal a rising of the input value X
  and  TD will signal a decreasing value on the input X.
  in case of a change the output D will show the delta of the input to the last input value.

  version 1.0 21. aug. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    X : REAL;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
    TU : BOOL;
    TD : BOOL;
    D : REAL;
  END_VAR
  VAR
    last_X: REAL;
  END_VAR

  TU := X > last_X;
  TD := X < last_X;
  Q := TU OR TD;
  D := X - LAST_X;

  last_X := X;

(* revision history
  hm  21. aug. 2009 rev 1.0
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION_BLOCK TREND_DW
(*
  trend_DW analyses the trend of a input signal.
  The Output Q is True if the input X is >= last_X and is false if the input X is <= last_X
  in addition to the trend the output TU will be high for one cycle to signal a rising of the input value X
  and  TD will signal a decreasing value on the input X.
  in case of a change the output D will show the delta of the input to the last input value.

  version 1.2 14. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    X : DWORD;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
    TU : BOOL;
    TD : BOOL;
    D : DWORD;
  END_VAR
  VAR
    last_X: DWORD;
  END_VAR

  IF X > last_X THEN
    TU := TRUE;
    TD := FALSE;
    D := UDINT_TO_DWORD( DWORD_TO_UDINT(X) - DWORD_TO_UDINT(last_X));
    Q := TRUE;
  ELSIF X < last_X THEN
    TD := TRUE;
    TU := FALSE;
    D := UDINT_TO_DWORD( DWORD_TO_UDINT(last_X) - DWORD_TO_UDINT(X));
    Q := FALSE;
  ELSE
    TU := FALSE;
    TD := FALSE;
    D := 0;
  END_IF;
  last_X := X;

(* revision history
  hm  21. nov. 2008 rev 1.0
    original version

  hm  20. feb. 2009 rev 1.1
    added outputs TU, TD and D

  hm  14. mar. 2009 rev 1.2
    removed double assignments
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal processing' *)
FUNCTION WORD_TO_RANGE : REAL
(*
  Word_to_Range converts a Byte into a real between low and high.

  version 1.1 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : WORD;
    low : REAL;
    high : REAL;
  END_VAR

  WORD_TO_RANGE := (high - low) * WORD_TO_REAL(X) * 0.00001525902189669640 + low;

(* revision history
  hm  9. jan 2008 rev 1.0
    original version

  hm  10. mar. 2009 rev 1.1
    improved code
*)
END_FUNCTION

