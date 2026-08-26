(* @PATH := '\/Mathematical\/Double Precision' *)
FUNCTION R2_ABS : REAL2
(*
  R2_abs returns the absulute value of a double precision real.

  version 1.1 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL2;
  END_VAR

  IF X.RX >= 0.0 THEN
    R2_ABS.RX := X.RX;
    R2_ABS.R1 := X.R1;
  ELSE
    R2_ABS.RX := -X.RX;
    R2_ABS.R1 := -X.R1;
  END_IF;

(* revision history
  hm  21. mar. 2008 rev 1.0
    original version

  hm  10. mar. 2009 rev 1.1
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Double Precision' *)
FUNCTION R2_ADD : REAL2
(*
  R2_add adds a real to a double real which extends the accuracy of a real to twice as many digits

  version 1.0 20. mar. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    X : Real2;
    Y : REAL;
  END_VAR
  VAR
    temp: REAL;
  END_VAR

  temp := X.RX;
  R2_ADD.RX := Y + X.R1 + X.RX;
  R2_ADD.R1 := temp - R2_ADD.RX + Y + X.R1;

(* revision history
  hm    20.3.2008 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Double Precision' *)
FUNCTION R2_ADD2 : REAL2
(*
  R2_add2 adds a double precision real to a double precision real which extends the accuracy of a real to twice as many digits

  version 1.0 20. mar. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : Real2;
    Y : REAL2;
  END_VAR

  R2_ADD2.R1 := X.R1 + Y.R1;
  R2_ADD2.RX := X.RX + Y.RX;

(* revision history
  hm    20.3.2008 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Double Precision' *)
FUNCTION R2_MUL : REAL2
(*
  R2_mul multiplies a real with a double real which extends the accuracy of a real to twice as many digits

  version 1.0 20. mar. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL2;
    Y : REAL;
  END_VAR

  R2_MUL.RX := X.RX * Y;
  R2_MUL.R1 := X.R1 * Y;

(* revision history
  hm    20.3.2008 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Double Precision' *)
FUNCTION R2_SET : REAL2
(*
  R2_set sets a double precision real to a single real value.

  version 1.1 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  R2_SET.RX := X;
  R2_SET.R1 := 0.0;

(* revision history
  hm  2. jun. 2008  rev 1.0
    original version

  hm  10. mar. 2009 rev 1.1
    real constants updated to new systax using dot
*)
END_FUNCTION

