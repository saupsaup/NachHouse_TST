TYPE
  OSCAT_BASIC_ARRAY1_20x0_1_OF_REAL : ARRAY[1..20, 0..1] OF REAL;
END_TYPE

(* @PATH := '\/Mathematical\/functions' *)
FUNCTION F_LIN : REAL
(*
  this function calculates the linear equation f_lin = a*x + b

  version 1.0 1 sep 2006
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
    A : REAL;
    B : REAL;
  END_VAR

  F_lin := A * X + B;
END_FUNCTION


(* @PATH := '\/Mathematical\/functions' *)
FUNCTION F_LIN2 : REAL
(*
  this function calculates the linear equation f_lin = a*x + b given by two points x1/y1 and x2/y2.

  version 1.0 1 jan 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
    X1: REAL;
    Y1 : REAL;
    X2 : REAL;
    Y2 : REAL;
  END_VAR

  F_LIN2 := (Y2 - Y1) / (X2 - X1) * (X - X1) + Y1;

(* revision history
  hm  1. jan. 2007  rev 1.0
    original release

  hm  17. dec. 2008 rev 1.1
    optimized formula
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/functions' *)
FUNCTION F_POLY : REAL
(*
  this function calculates the polynom C[0] + C[1]*X^1 + C[2]*X^2 * C[3]*X^3 + C[4]*X^4 + C[5]*X^5 + C[6]*X^6 + C[7]*X^7

  version 1.1 18. mar. 2011
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
    C : ARRAY[0..7] OF REAL;
  END_VAR

  F_POLY := ((((((( c[7] * x + c[6] ) * x + c[5] ) * x + c[4] ) * x + c[3] ) * x + c[2] ) * x + c[1] ) * x + c[0] ) ;

(* revision history
  hm    20. may. 2008   rev 1.0
    original version

  hm  18. mar. 2011 rev 1.1
    improved performance
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/functions' *)
FUNCTION F_POWER : REAL
(*
  this function calculates the power equation f_power = a*x^n

  version 1.0 1 sep 2006
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    a : REAL;
    x : REAL;
    n : REAL;
  END_VAR

  F_POWER := a * EXPT(X, N);
END_FUNCTION


(* @PATH := '\/Mathematical\/functions' *)
FUNCTION F_QUAD : REAL
(*
  this function calculates the quadratic equation f_lin = a*x + b

  version 1.1 18. Mar. 2011
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
    A : REAL;
    B : REAL;
    C : REAL;
  END_VAR

  F_QUAD :=  (A * X + B) * X + C;

(* revision history
  hm  1. sep. 2006  rev 1.0
    original version

  hm  18. mar. 2001 rev 1.1
    improved performance
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/functions' *)
FUNCTION FRMP_B : BYTE
(*
  this function calculates a ramp and limits the output to 0 .. 255 without overflow problems

  version 1.0   17. feb. 2011
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    START : BYTE;
    DIR : BOOL;
    TD : TIME;
    TR : TIME;
  END_VAR
  VAR
    tmpw : DWORD;
    tmpb : BYTE;
  END_VAR

  IF TD < TR THEN
    //???FRMP_B := MIN(DWORD_TO_BYTE(SHL(TIME_TO_DWORD(TD), 8) / TIME_TO_DWORD(TR)), SEL(DIR, START, BYTE#255 - START));
    tmpw := SHL(TIME_TO_DWORD(TD), 8);
    tmpw := UDINT_TO_DWORD( DWORD_TO_UDINT(tmpw) /  TIME_TO_UDINT(TR));
    tmpb := MIN( DWORD_TO_BYTE(tmpw), SEL( DIR, START, USINT_TO_BYTE(USINT#255 - BYTE_TO_USINT(START))));
    IF DIR THEN
      FRMP_B := USINT_TO_BYTE( BYTE_TO_USINT(START) + BYTE_TO_USINT(tmpb));
    ELSE
      FRMP_B := USINT_TO_BYTE( BYTE_TO_USINT(START) - BYTE_TO_USINT(tmpb));
    END_IF;
  ELSE
    FRMP_B := SEL(DIR, 0, 255);
  END_IF;

(* revision history
  17. feb. 2011 rev 1.0
    new module
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/functions' *)
FUNCTION_BLOCK FT_AVG
(*
  this function calculates the moving average over n samples from a sequential input
  the input values are shifted into an N deep buffer and the avg of this buffer is diplayed at anytime on the output.
  a rst will load the buffer with the current in value..

  version 1.5 10. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    IN : REAL;
    E : BOOL := TRUE;
    N : INT := 32;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    AVG : REAL;
  END_VAR
  VAR
    buff : DELAY;
    i: INT;
    init : BOOL;
  END_VAR

  (* limit n to a max of 32 because delay can do max 32 cycles *)
  buff.N := LIMIT(0, N, 32);

  IF NOT init OR rst THEN
    FOR i := 1 TO N DO
      buff(in := in);
    END_FOR;
    avg := in;
    init := TRUE;
  ELSIF E THEN
    buff(in := in);
    avg := avg + (in - buff.out ) / INT_TO_REAL(N);
  END_IF;

(* revision history
  hm  7. jan. 2007  rev 1.1
    chaged rst logic to load the buffer with the actual input value instead of 0.
    added en input to allow better control of signal flow
    added init to load the buffer with in at startup to avoid rampup at beginning.
    deleted unused variable cnt.

  hm  14. jun. 2008 rev 1.2
    set default for input en = TRUE and N = 32

  hm  10. oct. 2008 rev 1.3
    improved performance

  hm  18. oct. 2008 rev 1.4
    changed input en to e for compatibility reasons

  hm  10. mar. 2009 rev 1.5
    added type conversion for compatibility reasons
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Mathematical\/functions' *)
FUNCTION_BLOCK FT_MIN_MAX
(*
  this function block stores the min and max value of an input signal.
  when rst is true the mn and mx outputs are set to the in value.
  when a rst is never active the function autoresets to the in value at startup.
  since the input might not be present at first cycle the mn and mx are set during second cycle.

  version 1.0 1 sep 2006
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    in : REAL;
    rst : BOOL;
  END_VAR
  VAR_OUTPUT
    mx : REAL;
    mn : REAL;
  END_VAR
  VAR
    init: BOOL;
  END_VAR

  IF rst OR NOT init THEN
    mn := in;
    mx := in;
    init := TRUE;
  ELSIF in < mn THEN mn := in;
  ELSIF in > mx THEN mx := in;
  END_IF;
END_FUNCTION_BLOCK


(* @PATH := '\/Mathematical\/functions' *)
FUNCTION_BLOCK FT_RMP
(*
  this ramp function follows an input signal with a linear ramp up or down, the up or down speed can be set with KF and KR.
  a K factor of 1 means 1 unit per second on the output. K factors can only be positive and not negative.
  a busy output signals the ramp is running or busy false means the in value is present on the output.
  a rmp input false means the output follows the input dierctly while a rmp = true means the output follows the input with a ramp.
  a updn output signal the directon of the ramp (up or down).

  version 1.4 25 jan 2008
  programmer  oscat
  tested by   oscat
*)
  VAR_INPUT
    Rmp : BOOL := TRUE;
    in : REAL;
    KR : REAL;
    KF : REAL;
  END_VAR
  VAR_OUTPUT
    out : REAL;
    busy : BOOL;
    UD : BOOL;
  END_VAR
  VAR
    tx: TIME;
    last: TIME;
    init: BOOL;
  END_VAR

  (* read system time *)
  tx := DWORD_TO_TIME(T_PLC_MS()) - last;

  IF NOT init THEN
    init := TRUE;
    last := tx;
    tx := t#0s;
    out := in;
  END_IF;
  IF NOT rmp THEN
    out := in;
    busy := FALSE;
  ELSIF out > in THEN
    (* ramp down *)
    out := out - TIME_TO_REAL(tx) * 0.001 * KF;
    out := MAX(in, out);
  ELSIF out < in THEN
    (* ramp up *)
    out := out + TIME_TO_REAL(tx) * 0.001 * KR;
    out := MIN(in, out);
  END_IF;

  (* set busy and dir flags *)
  IF out < in THEN
    busy := TRUE;
    ud := TRUE;
  ELSIF out > in THEN
    busy := TRUE;
    ud := FALSE;
  ELSE
    busy := FALSE;
  END_IF;
  last := last + tx;

(* revision history:
  hm 8.10.2006      rev 1.1
    added ud output

  hm 12. feb 2007   rev 1.2
    added init variable and corrected a possible startup problem

  hm  17. sep 2007  rev 1.3
    replaced time() with t_plc_ms() for compatibility reasons

  hm  25. jan 2008  rev 1.4
    performance improvements
    allow KR and KF to be 0
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Mathematical\/functions' *)
FUNCTION LINEAR_INT : REAL
(*
  LINEAR_INT calculates an output based on a linear interpolation of up to 20 coordinates given in an array
  the input coordinates have to start at the lowest array position and must be sorted ba ascending X values.

  version 1.1 27 dec 2007
  programmer  oscat
  tested by   oscat
*)
  VAR_INPUT
    X : REAL;
    XY : OSCAT_BASIC_ARRAY1_20x0_1_OF_REAL; //ARRAY[1..20, 0..1] OF REAL;
    Pts : INT;
  END_VAR
  VAR
    i : INT;
  END_VAR

  (*make sure n is bound within the array size *)
  pts := MIN(pts,20);

  (* calculate the linear segement interpolation *)
  i := 2;
  (* search for segment and calculate output
    below and above the defined segments we interpolate the last segment *)
  WHILE (i < pts) AND (XY[i,0] < X) DO
    i := i + 1;
  END_WHILE;

  (* calculate the output value on the corresponding segment coordinates *)
  LINEAR_INT := ((XY[i,1] - XY[i-1,1]) * X - XY[i,1] * XY[i-1,0] + XY[i-1,1] * XY[i,0]) / (XY[i,0] - XY[i-1,0]);

(* revision history
  hm  7. oct 2007   rev 1.0
    original version

  hm  27 dec 2007   rev 1.1
    changed code for better performance
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/functions' *)
FUNCTION POLYNOM_INT : REAL
(*
  POLYNOM_INT calculates an output based on a Polynom interpolation of up to 5 coordinates given in an array
  the indut coordinates have to start at the lowest array position and must be sorted ba ascending X values.

  version 1.3 10. mar. 2009
  programmer  oscat
  tested by   oscat
*)
  VAR_INPUT
    X : REAL;
    XY : ARRAY[1..5,0..1] OF REAL;
    Pts : INT;
  END_VAR
  VAR
    I, J : INT;
    stop: INT;
  END_VAR
  VAR_TEMP
    tmp : REAL;
  END_VAR

  (*make sure n is bound within the array size *)
  pts := MIN(pts, 5);

  (* this part is only to calculate the polynom parameters, which are then stores in the Y array
    the array values, it is not needed during runtime, unless the parameters will change during runtime
    the remaining code without this setup code can be used within a function to calculate specific functions
    the content of the arrays is then used as constant values within the function *)

  FOR i := 1 TO pts DO
    stop := i + 1;
      FOR j := pts TO stop BY -1 DO
        XY[j,1] := (XY[j,1] - XY[j-1,1]) / (XY[j,0] - XY[j-i,0]);
    END_FOR;
  END_FOR;


  (* this part is the actual calculation *)
  tmp := 0.0;
  FOR i := pts TO 1 BY -1 DO
         tmp := tmp * (X - XY[i,0]) + XY[i,1];
  END_FOR;
  POLYNOM_INT := tmp;

(* revision history
  hm  8. okt 2007 rev 1.0
    original version

  hm  17. dec 2007  rev 1.1
    init makes no sense for a function

  hm  22. feb 2008  rev 1.2
    improved performance

  hm  10. mar. 2009 rev 1.3
    changed syntax of real constants to 0.0
*)
END_FUNCTION

