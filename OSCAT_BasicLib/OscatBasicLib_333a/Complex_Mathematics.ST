(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CABS : REAL
(*
  this function the aboslute value of a complex number

  version 1.0 21 feb 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : complex;
  END_VAR

  CABS := HYPOT(x.re, x.im);

(* revision history
  hm  21. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CSQRT : complex
(*
  this function calculates the complex sqare root

  version 1.0 21 feb 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : complex;
  END_VAR
  VAR
    temp : REAL;
  END_VAR

  temp := HYPOT(x.re, x.im);
  CSQRT.re :=  SQRT(0.5 * (temp + x.re));
  CSQRT.im :=  INT_TO_REAL(sgn(x.im)) * SQRT(0.5 * (temp - x.re));

(* revision history
  hm  21. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CLOG : complex
(*
  this function calculates the complex natural (base e) logarithm

  version 1.1 20. apr. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : complex;
  END_VAR

  CLOG.re := LN(HYPOT(X.re, X.im));
  CLOG.im := ATAN2(X.im, X.re);

(* revision history
  hm  21. feb 2008  rev 1.0
    original version

  hm  20. apr. 2008 rev 1.1
    use ATAN2 instead of ATAN
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CACOSH : complex
(*
  this function calculates the hyperbolic arcus cosinus function of a complex number

  version 1.0 21 feb 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : complex;
  END_VAR
  VAR
    Y : complex;
  END_VAR

  y.re := (X.re - X.im)*(X.re + X.im) - 1.0;
  y.im := 2.0 * X.re * X.im;
  y    := CSQRT(y);
  y.re := y.re + x.re;
  y.im := y.im + x.im;
  CACOSH  := CLOG(y);

(* revision history
  hm  21. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CACOS : complex
(*
  this function calculates the arcus cosinus function of a complex number

  version 1.0 21 feb 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : complex;
  END_VAR
  VAR
    Y : complex;
  END_VAR

  y := CACOSH(x);
  CACOS.re := y.im;
  CACOS.im := -y.re;

(* revision history
  hm  21. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CADD : complex
(*
  this function add two complex numbers

  version 1.0 21 feb 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X, Y : complex;
  END_VAR

  CADD.re := x.re + y.re;
  CADD.im := x.im + y.im;

(* revision history
  hm  21. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CARG : REAL
(*
  this function calculates the phase angle (argument) of a complex number

  version 1.1 20. apr. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : complex;
  END_VAR

  CARG := ATAN2(X.im, X.re);

(* revision history
  hm  21. feb. 2008 rev 1.0
    original version

  hm  20. apr. 2008 rev 1.1
    use ATAN2 instead of ATAN
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CASINH : complex
(*
  this function calculates the hyperbolic arcus sinus function of a complex number

  version 1.0 21 feb 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : complex;
  END_VAR
  VAR
    Y : complex;
  END_VAR

  y.re := (X.re - X.im)*(X.re + X.im) + 1.0;
  y.im := 2.0 * X.re * X.im;
  y    := CSQRT(y);
  y.re := y.re + x.re;
  y.im := y.im + x.im;
  CASINH  := CLOG(y);

(* revision history
  hm  21. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CASIN : complex
(*
  this function calculates the arcus sinus function of a complex number

  version 1.0 21 feb 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : complex;
  END_VAR
  VAR
    Y : complex;
  END_VAR

  y.re := -x.im;
  y.im := x.re;
  y := CASINH(y);
  CASIN.re := y.im;
  CASIN.im := -y.re;

(* revision history
  hm  21. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CATAN : complex
(*
  this function calculates the complex arcus tangens

  version 1.0 21 feb 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : complex;
  END_VAR
  VAR
    r2: REAL;
    num, den : REAL;
  END_VAR

  r2 := x.re * x.re;
  den := 1.0 - r2 - x.im * x.im;
  CATAN.re := 0.5 * ATAN(2.0 * x.re / den);
  num := x.im + 1.0;
  num := r2 + num * num;
  den := x.im - 1.0;
  den := r2 + den * den;
  CATAN.im := 0.25 * (LN(num)-LN(den));

(* revision history
  hm  21. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CATANH : complex
(*
  this function calculates the complex arcus hyperbolic tangens

  version 1.0 21 feb 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : complex;
  END_VAR
  VAR
    i2: REAL;
    num, den : REAL;
  END_VAR

  i2 := x.im * x.im;
  num := 1.0 + x.re;
  num := i2 + num * num;
  den := 1.0 - x.re;
  den := i2 + den * den;
  CATANH.re := 0.25 * (LN(num) - LN(den));
  den := 1.0 - x.re * x.re - i2;
  CATANH.im := 0.5 * ATAN(2.0 * x.im / den);

(* revision history
  hm  21. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CCON : complex
(*
  this function calcucates the conjugation of a complex number

  version 1.0 21 feb 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : complex;
  END_VAR

  CCON.re := x.re;
  CCON.im := -x.im;

(* revision history
  hm  21. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CCOSH : complex
(*
  this function calculates the arcus tangens function of a complex number

  version 1.0 21 feb 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : complex;
  END_VAR

  CCOSH.re := cosH(x.re) * COS(x.im);
  CCOSH.im := sinH(x.re) * SIN(x.im);

(* revision history
  hm  21. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CSET : complex
(*
  this function creates a complex number from two real inputs

  version 1.0 21 feb 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    RE : REAL;
    IM : REAL;
  END_VAR

  CSET.re := RE;
  CSET.im := IM;

(* revision history
  hm  21. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CCOS : complex
(*
  this function calculates the cosinus function of a complex number

  version 1.0 21 feb 2008
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    X : complex;
  END_VAR

  CCOS := CCOSH(CSET(-X.im, X.re));

(* revision history
  hm  21. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CDIV : complex
(*
  this function divides two complex numbers

  version 1.0 21 feb 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X, Y : complex;
  END_VAR
  VAR
    Temp : REAL;
  END_VAR

  temp := Y.re * Y.re + Y.im * Y.im;
  CDIV.re := (X.re * Y.re + X.im * Y.im) / temp;
  CDIV.im := (X.im * Y.re - X.re * Y.im) / temp;

(* revision history
  hm  21. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CEXP : complex
(*
  this function calculates the complex exponent

  version 1.0 21 feb 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : complex;
  END_VAR
  VAR
    Temp : REAL;
  END_VAR

  temp := EXP(X.re);
  CEXP.re := temp * COS(X.im);
  CEXP.im := temp * SIN(X.im);

(* revision history
  hm  21. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CINV : complex
(*
  this function calculates the inverse of a complex numbers (1 / X)

  version 1.0 21 feb 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : complex;
  END_VAR
  VAR
    temp : REAL;
  END_VAR

  temp := X.re * X.re + X.im * X.im;
  CINV.re := X.re / temp;
  CINV.im := -X.im / temp;

(* revision history
  hm  21. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CMUL : complex
(*
  this function multiplies two complex numbers

  version 1.0 21 feb 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X, Y : complex;
  END_VAR

  CMUL.re := X.re * Y.re - X.im * Y.im;
  CMUL.im := X.re * Y.im + X.im * Y.re;

(* revision history
  hm  21. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CPOL : complex
(*
  this function creates a complex numbers for the polar form with the inputs L (length) an A for Angle.

  version 1.0 21 feb 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    L : REAL;
    A : REAL;
  END_VAR

  CPOL.re := L * COS(A);
  CPOL.im := L * SIN(A);

(* revision history
  hm  21. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CPOW : complex
(*
  this function calculates the complex power function x to the power of y

  version 1.0 21 feb 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : complex;
    Y : Complex;
  END_VAR

  CPOW := CEXP(CMUL(Y,CLOG(X)));

(* revision history
  hm  21. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CSIN : complex
(*
  this function calculates the sinus function of a complex number

  version 1.0 21 feb 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : complex;
  END_VAR

  CSIN.re := cosH(X.im) * SIN(X.re);
  CSIN.im := sinH(X.im) * COS(X.re);

(* revision history
  hm  21. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CSINH : complex
(*
  this function calculates the sinus function of a complex number

  version 1.0 21 feb 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : complex;
  END_VAR

  CSINH.re := sinH(X.re) * COS(X.im);
  CSINH.im := cosH(X.re) * SIN(X.im);

(* revision history
  hm  21. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CSUB : complex
(*
  this function subtracts two complex numbers

  version 1.0 21 feb 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X, Y : complex;
  END_VAR

  CSUB.re := X.re - Y.re;
  CSUB.im := X.im - Y.im;

(* revision history
  hm  21. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CTAN : complex
(*
  this function calculates the tangens function of a complex number

  version 1.1 10. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    X : complex;
  END_VAR
  VAR
    temp : REAL;
    xi2: REAL;
    xr2: REAL;
  END_VAR

  xi2 := 2.0 * x.im;
  xr2 := 2.0 * x.re;
  temp := 1.0 / (COS(xr2) + COSH( xi2));
  CTAN.re := temp * SIN(xr2);
  CTAN.im := temp * SINH(xi2);

(* revision history
  hm  21. feb 2008  rev 1.0
    original version

  hm  10. mar 2009  rev 1.1
    faster code
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Complex' *)
FUNCTION CTANH : complex
(*
  this function calculates the complex hyperbolictangens

  version 1.1 10. mar. 2009
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : complex;
  END_VAR
  VAR
    temp : REAL;
    xi2: REAL;
    xr2: REAL;
  END_VAR

  xi2 := 2.0 * x.im;
  xr2 := 2.0 * x.re;
  temp := 1.0 / (COSH(xr2) + COS(xi2));
  CTANH.re := temp * SINH(xr2);
  CTANH.im := temp * SIN(xi2);

(* revision history
  hm  21. feb 2008  rev 1.0
    original version

  hm  10. mar. 2009 rev 1.1
    new faster code
*)
END_FUNCTION

