(* @PATH := '\/Mathematical' *)
FUNCTION ACOSH : REAL
(*
  this function calculates the arcus cos hyperbolicus

  version 1.3 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  ACOSH := LN(SQRT(X * X - 1.0) + X);

(* revision history
  hm    12 jan 2007 rev 1.0
    original version

  hm    2. dec 2007 rev 1.1
    changed code for better performance

  hm  16. mar. 2007   rev 1.2
    changed sequence of calculations to improve performance

  hm  10. mar. 2009   rev 1.3
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION ACOTH : REAL
(*
  this function calculates the arcus cotangens hyperbolicus

  version 1.2 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  ACOTH := LN((x+1.0)/(x-1.0))*0.5;

(* revision history
  hm    12 jan 2007 rev 1.0
    original version

  hm    5. jan 2008 rev 1.1
    improved code for better performance

  hm  10. mar. 2009   rev 1.2
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION AGDF : REAL
(*
  this function calculates the inverse Gudermannian function.

  version 1.1 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  AGDF := LN((1.0 + SIN(X)) / COS(X));

(* comment
  the current implementation gives sufficient accuracy only up to X = 1.57 or an output > 10.
  is X closer to PI/2 then the function is more and more unreliable
*)
(* revision history
  hm  27. apr. 2008 rev 1.0
    original version

  hm  10. mar. 2009 rev 1.1
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION ASINH : REAL
(*
  this function calculates the arcus sin hyperbolicus

  version 1.3 10. mar 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  ASINH := LN(SQRT(X * X + 1.0)+X);

(* revision history
  hm    12 jan 2007 rev 1.0
    original version

  hm    2. dec 2007 rev 1.1
    changed code for better performance

  hm    16.3. 2007    rev 1.2
    changed sequence of calculations to improve performance

  hm  10. mar. 2009   rev 1.3
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION ATAN2 : REAL
(*
  this function calculates the angle in a coordinate system in rad.

  version 1.2 10. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    Y : REAL;
    X : REAL;
  END_VAR

  IF X > 0.0 THEN
    ATAN2 := ATAN(Y/X);
  ELSIF X < 0.0 THEN
    IF Y >=0.0 THEN
      ATAN2 := ATAN(Y/X) + MATH.PI;
    ELSE
      ATAN2 := ATAN(Y/X) - MATH.PI;
    END_IF;
  ELSIF Y > 0.0 THEN
    ATAN2 := MATH.PI05;
  ELSIF Y < 0.0 THEN
    ATAN2 := -MATH.PI05;
  ELSE
    ATAN2 := 0.0;
  END_IF;

(* revision history
  hm  20.  apr. 2008  rev 1.0
    original version

  hm  18. oct. 2008 rev 1.1
    changed to use math constants

  hm  10. mar. 2009 rev 1.2
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION ATANH : REAL
(*
  this function calculates the arcus tangens hyperbolicus

  version 1.2 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  ATANH := LN((1.0 + x)/(1.0 - x)) * 0.5;

(* revision history
  hm    12 jan 2007 rev 1.0
    original version

  hm    5. jan 2008 rev 1.1
    improved code for better performance

  hm  10. mar. 2009   rev 1.2
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION GAMMA : REAL
(*
  this function calculates the stirling function which is an approximation for the gamma function

  version 1.3 10. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  IF x > 0.0 THEN
    GAMMA := SQRT(math.PI2 / X) * EXPT(math.E_INV * (x + 1.0 / (12.0 * x - 0.1 / X)), X);
  END_IF;

(* the stirling formula is not very accurate for small values of X
  IF X >=0 THEN GAMMA := SQRT(math.PI2 * X) * EXPT(X / math.E, X); END_IF;
*)
(* revision history
  hm  10.12.2007  rev 1.0
    original version

  hm  18. oct. 2008 rev 1.1
    using math constants

  hm  26. oct. 2008 rev 1.2
    using new formula with better accuracy

  hm  10. mar. 2009 rev 1.3
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION BETA : REAL
(*
  this function calculates the beta function for real number > 0.

  version 1.0 26. oct. 2008
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    X : REAL;
    Y : REAL;
  END_VAR

  BETA := GAMMA(X) * GAMMA(Y) / GAMMA(x + y);

(* revision history
  hm  26. oct. 2008 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION BINOM : DINT
(*
  this function calculates the binomialkoefficient (N over k)

  version 1.0 25. oct. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    N : INT;
    K : INT;
  END_VAR
  VAR
    i: INT;
  END_VAR

  IF 2 * K > n THEN
  	k := n - k;
  END_IF;
  IF k > n THEN
  	RETURN;
  ELSIF k = 0 OR k = n THEN
  	BINOM := 1;
  ELSIF k = 1 THEN
  	BINOM := INT_TO_DINT(n);
  ELSE
  	BINOM := INT_TO_DINT(n);
  	n := n + 1;
  	FOR i := 2 TO k DO
  		BINOM := BINOM * (INT_TO_DINT(n) - INT_TO_DINT(i)) / INT_TO_DINT(i);
  	END_FOR;
  END_IF;

(*
  binomialkoeffizient(n, k)
  1  wenn k = 0 return 1
  2  wenn 2k > n
  3      dann führe aus ergebnis \leftarrow binomialkoeffizient(n, n-k)
  4  sonst führe aus ergebnis \leftarrow n
  5          von i \leftarrow 2 bis k
  6              führe aus ergebnis \leftarrow ergebnis \cdot (n + 1 - i)
  7                        ergebnis \leftarrow ergebnis : i
  8  return ergebnis
*)
(* revision history
  hm  25. oct. 2008 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION CAUCHY : REAL
(*
  this function calculates the Cauchy distribution function

  version 1.0 26. oct. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
    T : REAL;
    U : REAL;
  END_VAR
  VAR
    tmp: REAL;
  END_VAR

  tmp := x - t;
  CAUCHY := math.PI_INV * U / (U*U + tmp*tmp);

(* revision hisdtory
  hm  26. oct. 2008 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION CAUCHYCD : REAL
(*
  this function calculates the Cauchy distribution function

  version 1.0 26. oct. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
    T : REAL;
    U : REAL;
  END_VAR

  CAUCHYCD := 0.5 + math.PI_INV * ATAN((X - T) / U);

(* revision hisdtory
  hm  26. oct. 2008 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION CEIL1 : INT
(*
  This is a rounding function which returns the smallest possible integer which is greater or equal to X.
  ceil1(3.14) = 4
  ceil1(-3.14) = -3

  version 1.1 21. mar. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  CEIL1 := REAL_TO_INT(x);
  IF INT_TO_REAL(CEIL1) < X THEN
  	CEIL1 := CEIL1 + 1;
  END_IF;

(* revision history
  hm  7. feb. 2007  rev 1.0
    original version

  hm  21. mar. 2008 rev 1.1
    use REAL_TO_INT instead of trunc for compatibility reasons
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION CEIL2 : DINT
(*
  This is a rounding function which returns the smallest possible integer which is greater or equal to X.
  ceil2(3.14) = 4
  ceil2(-3.14) = -3

  version 1.3 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  CEIL2 := REAL_TO_DINT(X);
  IF DINT_TO_REAL(CEIL2) < X THEN
  	CEIL2 := CEIL2 + 1;
  END_IF;

(* revision history
  hm  21. mar. 2008 rev 1.0
    original version

  hm  4. apr. 2008  rev 1.1
    added type conversion to avoid warnings under codesys 3.0

  hm  30. jun. 2008 rev 1.2
    added type conversion to avoid warnings under codesys 3.0

  hm  10. mar. 2009 rev 1.3
    use correct statement real_to_DINT
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION FLOOR1 : INT
(*
  This is a rounding function which returns the biggest possible integer which is less or equal to X.
  floor1(3.14) = 3
  floor1(-3.14) = -4

  version 1.1 21. mar. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  FLOOR1 := REAL_TO_INT(X);
  IF INT_TO_REAL(FLOOR1) > X THEN
  	FLOOR1 := FLOOR1 - 1;
  END_IF;

(* revision history
  hm    7. feb 2007   rev 1.0
    originlal version

  hm    21. mar. 2008 rev 1.1
    replaced trunc with real_to_int for compatibility reasons
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION FLOOR2 : DINT
(*
  This is a rounding function which returns the biggest possible integer which is less or equal to X.
  floor2(3.14) = 3
  floor2(-3.14) = -4

  version 1.1 4. apr. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  FLOOR2 := REAL_TO_DINT(X);
  IF DINT_TO_REAL(FLOOR2) > X THEN
  	FLOOR2 := FLOOR2 - 1;
  END_IF;

(* revision history
  hm  21. mar. 2008 rev 1.0
    originlal version

  hm  4. apr. 2008  rev 1.1
    added type conversion to avoid warnings under codesys 3.0
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION EXP10 : REAL
(*
  this function calculates the exponent to the basis 10
  exp10(3) = 1000

  version 1.0  2 dec 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  EXP10 := EXP(X * 2.30258509299405);

(* revision history
  hm  2. dec 2007   rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION CMP : BOOL
(*
  this function checks two inputs x and y if they are identical with the first N digits
  example : cmp(3.141516,3.141517,6 is true.

  version 1.1 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X,Y : REAL;
    N : INT;
  END_VAR
  VAR
    tmp : REAL;
  END_VAR

  tmp := ABS(x);
  IF tmp > 0.0 THEN
    tmp := EXP10(INT_TO_REAL(FLOOR1(LOG(tmp))-N+1));
  ELSE
    tmp := EXP10(tmp);
  END_IF;
  CMP := ABS(X - Y) < tmp;

(* revision history
  hm  12. mar. 2008 rev 1.0
    original version

  hm  10. mar. 2009 rev 1.1
    added type conversion for compatibility reasons
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION COSH : REAL
(*
  this function calculates the cos hyperbolicus

  version 1.3 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR
  VAR
    t: REAL;
  END_VAR

  T := EXP(X);
  COSH := (1.0 / T + T) * 0.5;

(* revision histroy
  hm  12.1.2007 rev 1.0
    original version

  hm  1.12.2007 rev 1.1
    changed code to improve performance

  hm  5. jan 2008 rev 1.2
    further performance improvement

  hm  10. mar. 2009 rev 1.3
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION COTH : REAL
(*
  this function calculates the cotangens hyperbolicus

  version 1.4 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  IF X > 20.0 THEN
    COTH :=1.0;
  ELSIF X < -20.0 THEN
    COTH := -1.0;
  ELSE
    COTH := 1.0 + 2.0 / (EXP(X * 2.0) - 1.0);
  END_IF;

(* revision histroy
  hm    12.1.2007 rev 1.0
    original version

  hm  1.12.2007   rev 1.1
    changed code to improve performance

  hm  8. jan 2008 rev 1.2
    further improvement in performance

  hm  10. mar 2008  rev 1.3
    extended range of valid inputs to +/- INV
    changed formula for better accuracy

  hm  10. mar. 2009 rev 1.4
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION D_TRUNC : DINT
(*
  d_trunc truncates a real to a dint 1.5 will be 1 and -1.5 will be -1
  d_trunc is necessary because many systems do not offer a trunc to a dint
  also real_to_dint will not deliver the same result on different systems

  version 1.2 10. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  D_TRUNC := REAL_TO_DINT(X);
  IF X > 0.0 THEN
  	IF DINT_TO_REAL(D_TRUNC) > X THEN D_TRUNC := D_TRUNC - 1; END_IF;
  ELSE
  	IF DINT_TO_REAL(D_TRUNC) < X THEN D_TRUNC := D_TRUNC + 1; END_IF;
  END_IF;

(* for systems that support a dint truncation this routine can be replaced by trunc() *)

(* revision history
  hm  21. mar. 2008 rev 1.0
    original version

  hm  31. oct. 2008 rev 1.1
    optimized performance

  hm  10. mar. 2009 rev 1.2
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION DEC1 : INT
(*
  This is a decrement function which decrements the variable X by 1 and if 0 is reached, it begins with N-1 again.
  _dec1(X,3) will generate 2,1,0,2,...

  version 1.1 27. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : INT;
    N : INT;
  END_VAR

  IF X = 0 THEN
    DEC1 := N - 1;
  ELSE
    DEC1 := X - 1;
  END_IF;

(* this is a very elegant version but 50% slower X := (X - 1 + N) MOD N; *)

(* revision history
  hm  13. oct. 2008 rev 1.0
    original version

  hm  27. oct. 2008 rev 1.1
    added statement to return value for compatibility reasons
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION MODR : REAL
(*
  this is a modulo funtion for real numbers
  modr(5.5,2.5) = 0.5

  version 1.5 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IN : REAL;
    DIVI : REAL;
  END_VAR

  IF divi = 0.0 THEN
    MODR := 0.0;
  ELSE
    MODR := in - DINT_TO_REAL(FLOOR2(in / divi)) * divi;
  END_IF;

(* revision history
  hm  4. aug.2006   rev 1.0

  hm  28. jan.2007  rev 1.1
    modr(x,0) will deliver the result 0

  hm  21. mar 2008  rev 1.2
    use D_trunc for compatibility reasons

  hm  4. apr. 2008  rev 1.3
    added type conversion to avoid warnings under codesys 3.0

  hm  31. oct. 2008 rev 1.4
    changed algorithm to the more common version using floor instead of TRUNC

  hm  10. mar. 2009 rev 1.5
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION DIFFER : BOOL
(*
  this function checks if in1 differs more then x from in2
  the output is true if abs(in1-in2) > X

  version 1.1 16 mar 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    in1 : REAL;
    in2 : REAL;
    X : REAL;
  END_VAR

DIFFER := ABS(in1 - in2) > X;

(* revision history
  hm    8. oct 2006   rev 1.0
    original version

  hm    16. mar 2008  rev 1.1
    improverd code for performance
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION SGN : INT
(*
  sgn returns 0 when X = 0 , -1 when X < 1 and +1 when X > 1

  version 1.1 11. nov. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  IF X > 0.0 THEN
    SGN := 1;
  ELSIF X < 0.0 THEN
    SGN := -1;
  ELSE
    SGN := 0;
  END_IF;

(* revision histroy
  hm  16. oct 2007  rev 1.0
    original version

  hm  11. nov 2007  rev 1.1
    changed type of function from real to int
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION ERF : REAL
(*
  this function calculates the erf (error) function.

  version 1.3 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR
  VAR
    x2 : REAL;
    ax2 : REAL;
  END_VAR

  x2 := X*X;
  ax2 := 0.147 * x2 + 1.0;
  ERF := SQRT(1.0 - EXP(-X2 * ((0.27323954473516 + aX2)/(ax2)))) * INT_TO_REAL(SGN(x));

(* revision history
  hm  7. apr. 2008  rev 1.0
    original version

  hm  30. jun. 2008 rev 1.1
    added type conversions to avoid warnings under codesys 3.0

  hm  25. oct. 2008 rev 1.2
    new code using new algorithm

  hm  10. mar. 2009 rev 1.3
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION ERFC : REAL
(*
  this function calculates the inverse erf (error) function.

  version 1.1 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  ERFC := 1.0 - ERF(X);

(* revision history
  hm  7. apr. 2008  rev 1.0
    original version

  hm  10. mar. 2009 rev 1.1
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION EVEN : BOOL
(*
  this function chacks an input for even  value
  the output is true if the input is even.

  execution time on wago 750 - 841 =  10  us
  version 1.1 1 dec 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    in : DINT;
  END_VAR

  EVEN := NOT in.0;

(* revision history
  hm  1. oct 2006 rev 1.0
    ORIGINAL VERSION

  hm  01.12.2007  rev 1.1
    changed code for improved performance

  hm  21. mar. 2008 rev 1.2
    changed type of input IN from INT to DINT
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION EXPN : REAL
(*
  this function calculates X to the power of N (Y = X^N) whilke N is an integer
  especially on CPU's without a floating point unit this algorythm is about 30 times faster then the IEC standard EXPT() Function

  version 1.2 10. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    X : REAL;
    N : INT;
  END_VAR
  VAR
    sign: BOOL;
  END_VAR

  sign := n.15;
  N := ABS(N);
  IF N.0 THEN EXPN := X; ELSE EXPN := 1.0; END_IF;
  N := WORD_TO_INT(SHR(INT_TO_WORD(N),1));
  WHILE N > 0 DO
     X := X * X;
     IF N.0 THEN EXPN := EXPN * X; END_IF;
     N := WORD_TO_INT(SHR(INT_TO_WORD(N),1));
  END_WHILE;
  IF sign THEN EXPN := 1.0 / EXPN; END_IF;

(* revision history
  hm  4. dec 2007 rev 1.0
    original version

  hm  22. oct. 2008 rev 1.1
    optimized code

  hm  10. mar. 2009 rev 1.2
    removed nested comments
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION FACT : DINT
(*
  this function calculates the factorial of x

  if the input is negative or higher then 12 the output will be -1.

  version 1.5 26. mar. 2011
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : INT;
  END_VAR

  IF X >= 0 AND X <= 12 THEN
    FACT := math.FACTS[X];
  ELSE
    FACT := -1;
  END_IF;

(* working code without array
  IF X > 12 OR X < 0 THEN
    FACT := -1;
  ELSIF X < 7 THEN
    FACT := 1;
    FOR i := 2 TO X DO
      FACT := FACT * i;
    END_FOR;
  ELSE
    FACT := 5040;
    FOR i := 8 TO X DO
      FACT := FACT * i;
    END_FOR;
  END_IF;
*)
(* revision history
  hm 4.3.2007   rev 1.1
    changed a critical error where while loop was indefinite.

  hm  10.12.2007  rev 1.2
    start value for i has changed to 2 for better performance

  hm  10. mar 2008  rev 1.3
    changed output of fact to dint to allow bigger values

  hm  27. oct. 2008 rev 1.4
    optimized code

  hm  26. mar. 2011 rev 1.5
    using array math.facts
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION FIB : DINT
(*
  this function calculates the fibonacci sequence

  version 1.3 26. mar. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : INT;
  END_VAR
  VAR
    t1, t2: DINT;
  END_VAR

  IF X < 0 OR X > 46 THEN
    FIB := -1;
  ELSIF x < 2 THEN
    FIB := INT_TO_DINT(X);
    RETURN;
  ELSE
    (* the fibonacci number is the sum of the two suceeding fibonaci numbers *)
    (* we store the numbers alternatively in t1 and t2 depending on pt *)
    t2 := 1;
    WHILE X > 3 DO
      X := X-2;
      t1 := t1 + t2;
      t2 := t1 + t2;
    END_WHILE;
    IF X > 2 THEN t1 := t1 + t2; END_IF;
    fib := t1 + t2;
  END_IF;

(* alternative code for very big numbers
  IF X < 31 THEN
    fib := 0.4472136 * (expn(1.618034,X) - expn(-0.618034,X));
  ELSE
    fib := 0.4472133 * expn(1.618034,X);
  END_IF;
*)
(* revision history
  hm    27. dec 2007  rev 1.0
    original version

  hm    2. jan 2008 rev 1.1
    deleted unused variable pt

  hm    10. mar 2008  rev 1.2
    changed output to dint instead of real

  hm    26. mar. 2008 rev 1.3
    function now returns -1 for input < 0 or > 46
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION FRACT : REAL
(*
  this function returns the fraction of a real number
  fract(3.14) = 0.14

  version 1.3 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    x : REAL;
  END_VAR

  IF ABS(x) < 2.0E9 THEN
    FRACT := x - DINT_TO_REAL(D_TRUNC(x));
  ELSE
    FRACT := 0.0;
  END_IF;

(* revision history
  hm  4. aug 2006 rev 1.0
    original version

  hm  11. mar 2008  rev 1.1
    added dint_to_real for compatibility reasons
    now returns 0 for number > 2e9
    changed input to x

  hm  21. mar. 2008 rev 1.2
    use D_trunc instead of TRUNC for compatibility reasons

  hm  10. mar. 2009 rev 1.3
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION GAUSS : REAL
(*
  this function calculates the gaussian density function

  version 1.2 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
    U : REAL;
    SI: REAL;
  END_VAR
  VAR
    temp: REAL;
    si_inv: REAL;
  END_VAR

  temp := X - U;
  si_inv := 1.0  / si;
  GAUSS := EXP(Temp * Temp * si_inv * si_inv * - 0.5) * 0.39894228 * si_inv;

(* revision hisdtory
  hm  6. apr. 2008  rev 1.0
    original version

  hm  27. oct. 2008 rev 1.1
    optimized performance

  hm  10. mar. 2009 rev 1.2
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION GAUSSCD : REAL
(*
  this function calculates the gaussian cumulative distribution function

  version 1.1 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
    U : REAL;
    SI: REAL;
  END_VAR

  GAUSSCD := (ERF((X - U) / (SI * 1.414213562)) + 1.0) * 0.5;

(* revision hisdtory
  hm  6. apr. 2008  rev 1.0
    original version

  hm  10. mar. 2009 rev 1.1
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION GCD : INT
(*
  this function calculates the gretaest common divisor of two numbers A and B

  version 1.0 19. jan. 2011
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    A : DINT;
    B : DINT;
  END_VAR
  VAR
    t: DINT;
  END_VAR

  IF A = 0 THEN
  	GCD := DINT_TO_INT(ABS(B));
  ELSIF B = 0 THEN
  	GCD := DINT_TO_INT(ABS(A));
  ELSE
  	A := ABS(A);
  	B := ABS(B);
  	GCD := 1;
  	WHILE NOT(A.0 OR B.0) DO
      A := DWORD_TO_DINT( SHR(DINT_TO_DWORD(A),1));
      B := DWORD_TO_DINT( SHR(DINT_TO_DWORD(B),1));
      GCD := WORD_TO_INT( SHL(INT_TO_WORD(GCD),1));
  	END_WHILE;
  	WHILE A > 0 DO
      IF NOT(A.0) THEN A := DWORD_TO_DINT( SHR(DINT_TO_DWORD(A),1));
      ELSIF NOT(B.0) THEN B := DWORD_TO_DINT( SHR(DINT_TO_DWORD(B),1));
  		ELSE
  			t:= DWORD_TO_DINT( SHR( DINT_TO_DWORD( ABS(A-B)),1));
  			IF A < B THEN B := t; ELSE A := T; END_IF;
  		END_IF;
  	END_WHILE;
  	GCD := GCD * DINT_TO_INT(B);
  END_IF;

(* revision history
  hm  19. jan. 2011 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION GDF : REAL
(*
  this function calculates the Gudermannian function.

  version 1.2 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  IF X = 0.0 THEN
    GDF := 0.0;
  ELSIF X > 15.0 THEN
    GDF := math.PI05;
  ELSIF X < -15.0 THEN
    GDF := -math.PI05;
  ELSE
    GDF := ATAN(EXP(X)) * 2.0 - math.PI05;
  END_IF;

(* revision history
  hm  27. apr. 2008 rev 1.0
    original version

  hm  18. oct. 2008 rev 1.1
    using math constants

  hm  10. mar. 2009 rev 1.2
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION GOLD : REAL
(*
  this function calculates the golden function.

  version 1.1 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  GOLD := (X + SQRT(X*X + 4.0)) * 0.5;

(* revision history
  hm  27. apr. 2008 rev 1.0
    original version

  hm  10. mar. 2009 rev 1.1
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION HYPOT : REAL
(*
  this function calculates the pythagorean function

  version 1.0 21 feb 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : REAL;
    Y : REAL;
  END_VAR

  HYPOT := SQRT(x*x + y*y);

(* revision history
  hm  21. feb 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION INC : INT
(*
  This is a increment function which increments the input X by the value D and compares the result with M.
  if the output exceeds M it will continue to count from 0 again.

  version 1.1 15. jan 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : INT;
    D : INT;
    M : INT;
  END_VAR

  INC := (X + D + M + 1) MOD (M + 1);

(* revision history
  hm  7. feb 2007   REV 1.0
    original version

  hm  15. jan 2008  rev 1.1
    allow for neagtive increment
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION INC1 : INT
(*
  This is a increment function which increments the variable X by 1 and if N is reached, it begins with 0 instead of N again.
  inc1(X,3) will generate 0,1,2,0,1,.....

  version 1.2 23. feb. 2009
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : INT;
    N : INT;
  END_VAR

  IF X >= N - 1 THEN
    INC1 := 0;
  ELSE
    INC1 := X + 1;
  END_IF;

(* revision history
  hm  13. oct. 2008 rev 1.0
    original version

  hm  22. oct. 2008 rev 1.1
    added statement to return value for compatibility reasons

  hm  23. feb. 2009 rev 1.2
    when inc1 is called with X >= N inc will continue with 0
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION INC2 : INT
(*
  This function increments the input X by the value D and compares the result with U.
  if the output exceeds U it will continue to count from L again.

  version 1.0 29. jun. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    X : INT;
    D : INT;
    L : INT;
    U : INT;
  END_VAR
  VAR
    tmp: INT;
  END_VAR

  tmp := U - L + 1;
  INC2 := (X + D - L + tmp) MOD tmp + L;

(* revision history
  hm  29. jun. 2008   REV 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION INV : REAL
(*
  This function calculates the result of 1 / X

  version 1.1 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  IF X <> 0.0 THEN INV := 1.0 / X; END_IF;

(* revision history
  hm  26. oct. 2008 rev 1.0
    original version

  hm  10. mar. 2009 rev 1.1
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION LAMBERT_W : REAL
(*
  this function calculates the lambert_w function.

  version 1.1 10. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    X : REAL;
  END_VAR
  VAR
    w : REAL;
    i : INT;
    we: REAL;
    w1e: REAL;
    last: DWORD;
    ewx: REAL;
  END_VAR

  (* check for valid input and return -1000 if too low *)
  IF x < -0.367879441171442 THEN
    LAMBERT_W := -1000.0;
    RETURN;
  (* return 0 if x = 0 *)
  ELSIF x = 0.0 THEN
    RETURN;
  (* first an estimate is calculated *)
  ELSIF x <= 500.0 THEN
    w := LN(x + 1.0);
    w := 0.665 * (1.0 + 0.0195 * w) * w + 0.04;
  ELSE
    w := LN(x - 4.0) - (1.0 - 1.0/LN(x)) * LN(LN(x));
  END_IF;
  (* use estimate to calculate exact result *)
  FOR i := 0 TO 5 DO
    ewx := EXP(w);
    we := w * ewx - x;
    w1e := (w+1.0) * ewx;
    last := REAL_TO_DWORD(w) AND 16#FFFF_FFFC;
    w := w - (we / (w1e - (w+2.0) * we / (2.0 * w + 2.0)));
    IF (REAL_TO_DWORD(w) AND 16#FFFF_FFFC) = last THEN EXIT; END_IF;
  END_FOR;
  LAMBERT_W := w;

(* revision hisdtory
  hm  26. oct. 2008 rev 1.0
    original version

  hm  10. mar. 2009 rev 1.1
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION LANGEVIN : REAL
(*
  this function calculates the langevin function

  version 1.2 10.mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  IF X = 0.0 THEN
    LANGEVIN := 0.0;
  ELSE
    LANGEVIN := COTH(X) - 1.0 / X;
  END_IF;

(* revision history
  hm  10.12.2007  rev 1.0
    original version

  hm  11. mar 2008  rev 1.1
    changed formula to avoid problems when x = 0

  hm  10. mar. 2009 rev 1.2
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION MAX3 : REAL
(*
  this function returns the highest of 3 real values

  version 1.1 18. mar. 2011
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    in1 : REAL;
    in2 : REAL;
    in3 : REAL;
  END_VAR

  MAX3 := MAX(MAX(IN1,IN2),IN3);

(* revision history
  hm  1.1.2007  rev 1.0
    original release

  hm  18. mar. 2011 rev 1.1
    improve performance
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION MID3 : REAL
(*
  returns the mid value of 3 real inputs.

  version 1.2 18. mar. 2011
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IN1 : REAL;
    IN2 : REAL;
    IN3 : REAL;
  END_VAR

  IF IN1 > IN2 THEN MID3 := IN1; IN1 := IN2; IN2 := MID3; END_IF;
  IF IN2 > IN3 THEN IN2 := IN3; END_IF;
  MID3 := SEL(IN1 > IN2, IN2, IN1);

(*
  hm  1.1.2007  rev 1.1
    rewrote the function for better performance

  hm  18. mar. 2011 rev 1.2
    improve performance
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION MIN3 : REAL
(*
  this function returns the lowest of 3 real values

  version 1.1 18. mar. 2011
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    in1 : REAL;
    in2 : REAL;
    in3 : REAL;
  END_VAR

  MIN3 := MIN(MIN(IN1,IN2),IN3);

(* revision history
  hm  1.1.2007  rev 1.0
    original release

  hm  18. mar. 2011 rev 1.1
    improve performance
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION MUL_ADD : REAL
(*
  this function multiplies an input X with K and adds Offset O to the result.

  version 1.1 11 nov 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
    K : REAL;
    O : REAL;
  END_VAR

  MUL_ADD := X * K + O;

(* revision history
  hm  28. feb 2007
    original version

  hm  11.nov 2007   rev 1.1
    deleted preset values for K and O this makes no sense for a function
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION NEGX : REAL
(*
  This function returns -X

  version 1.0 26. oct. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  NEGX := -X;

(* revision history
  hm  26. oct. 2008 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION RAD : REAL
(*
  this function converts Radiant to degrees

  version 1.2 18. oct. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    DEG : REAL;
  END_VAR

  RAD := MODR(0.0174532925199433 * DEG, math.PI2);

(* revision history
  hm  4. aug 2006   rev 1.0
    original version

  hm  16. oct 2007  rev 1.1
    added modr statement which prohibits rad to become bigger than 2PI

  hm  18. oct 2008  rev 1.2
    using math constants
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION RDM : REAL
(*
  this function calculates a pseudo random number
  to generate the number it reads the sps timer and calculates a random number between 0 and 1:
  in order to use rdm more then once within one sps cycle it need to be called with different seed numbers LAST.

  version 1.9 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    last : REAL;
  END_VAR
  VAR
    tn : DWORD;
    tc : INT;
  END_VAR
  VAR_TEMP
    tmp : UDINT;
  END_VAR

  tn := T_PLC_MS();
  tc := BIT_COUNT(tn);
  tn.31 := tn.2;
  tn.30 := tn.5;
  tn.29 := tn.4;
  tn.28 := tn.1;
  tn.27 := tn.0;
  tn.26 := tn.7;
  tn.25 := tn.6;
  tn.24 := tn.3;
  tn := ROL(tn, INT_TO_UINT( BIT_COUNT(tn))) OR 16#80000001;
  //??? tn := tn MOD 71474513 + INT_TO_DWORD(tc + 77);
  tmp := MOD( DWORD_TO_UDINT(tn), UDINT#71474513);
  tn := UDINT_TO_DWORD( tmp + INT_TO_UDINT(tc) + 77);
  RDM := FRACT(DWORD_TO_REAL(tn) / 10000000.0 * (math.E - LIMIT(0.0,last,1.0)));

(*
  pt := ADR(temp);
  pt^ := (T_PLC_MS() AND 16#007FFFFF) OR 16#3D000000;
  RDM := fract(modR(temp*e+pi1, PI1-last) + modR(temp*PI1+e + last,e-last));
*)

(* revision history
  hm    16. jan 2007    rev 1.0
    original version

  hm    11. nov 2007    rev 1.1
    changed time() into t_plc_ms()

  hm    20. nov 2007    rev 1.2
    changed code of temp calculation to avoid overflow in modr due to resuclt would not fit DINT for high timeer values

  hm    5. jan 2008   rev 1.3
    changed calculation of temp to avoid problem with high values of t_plc_ms

  hm    2. feb 2008   rev 1.4
    changed algorithm to avoind non iec functions and guarantee more randomness

  hm  10. mar. 2008   rev 1.5
    make sure last will be between 0 and 1 to avoid invalid results

  hm  16. mar. 2008   rev 1.6
    added conversion for tc to avoid warnings under codesys 3.0

  hm  18. may. 2008   rev 1.7
    changed constant E to E1

  hm  18. oct. 2008   rev 1.8
    using math constants

  hm  10. mar. 2009   rev 1.9
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION RDM2 : INT
(*
  this function calculates an integer pseudo random number
  the random number will be in the range of low <= rdm2 <= high.

  version 1.1 18. oct. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    last : INT;
    low : INT;
    high : INT;
  END_VAR

  // RDM2 := TRUNC(RDM(FRACT(last * math.PI)) * (high - low + 1)) + low;
  RDM2 := TRUNC( RDM( FRACT( INT_TO_REAL(last) * math.PI)) * INT_TO_REAL((high - low + 1))) + low;

(* revision history
  hm    29. feb 2008    rev 1.0
    original version

  hm    18. oct. 2008   rev 1.1
    using math constants
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION RDMDW : DWORD
(*
  this function calculates a DWORD pseudo random number.

  version 1.2 18. oct. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    last : DWORD;
  END_VAR
  VAR
    RX: REAL;
    M: REAL;
  END_VAR

  M := INT_TO_REAL( BIT_COUNT(last));
  RX := RDM(FRACT(M * math.PI));
  RDMDW := SHL(REAL_TO_DWORD(rx*65535.0),16);
  RX := RDM(FRACT(M * math.E));
  RDMDW := RDMDW OR (REAL_TO_DWORD(rx*65535.0) AND 16#0000FFFF);

(* revision history
  hm    14. mar 2008    rev 1.0
    original version

  hm    18. may. 2008   rev 1.1
    changed constant E to E1

  hm    18. oct. 2008   rev 1.2
    using math constants
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION REAL_TO_FRAC : FRACTION
(*
  this function calculates the closest fraction for a real number

  version 1.1   06. apr. 2011
  programmer  alexander
  tested by   hugo
*)
  VAR_INPUT
    X : REAL;         (* in einen Bruch umzuwandelnder Wert *)
    N : INT;          (* maximale Größe des Nenners *)
  END_VAR
  VAR
    temp : DINT;        (* Merker für Berechnungen *)

    sign: BOOL;         (* Vorzeichen vom Eingangswert *)
    X_gerundet: DINT;     (* Wert von Bruch, auf ganze Zahl gerundet *)
    X_ohne_Nachkomma: REAL;   (* Wert von Bruch, ohne Nachkommastellen *)
    Numerator:       DINT := 1; (* Initialwert Zaehler  *)
    Denominator:     DINT := 0; (* Initialwert Nenner *)
    Numerator_old:   DINT := 0; (* Initialwert Zaehler der letzten Berechnung  *)
    Denominator_old: DINT := 1; (* Initialwert Zaehler der letzten Berechnung   *)
  END_VAR

  IF X < 0.0 THEN
    sign := TRUE;               (* Vorzeichen merken *)
    X := ABS(X);                (* Absolutwert berechnen *)
  END_IF;

  REPEAT
    X_gerundet := REAL_TO_DINT(X);

    (* Zaehler berechnen *)
    temp := numerator * X_gerundet + numerator_old;   (* Zaehler um Vorkammawert erweitern *)
    numerator_old := numerator;             (* Zaehler der letzten Berechnung speichern *)
    numerator := temp;                  (* Zaehler dieser Berechnung speichern *)

    (* Nenner berechnen *)
    temp := denominator * X_gerundet + denominator_old; (* Nenner um Vorkammawert erweitern *)
    denominator_old := denominator;           (* Nenner der letzten Berechnung speichern *)
    denominator := temp;                (* Nenner dieser Berechnung speichern *)

    (* Restwert berechnen *)
    X_ohne_Nachkomma := DINT_TO_REAL(X_gerundet);
    IF X = X_ohne_Nachkomma THEN            (* Bruch geht ohne Rest auf *)
      IF ABS(denominator) <= INT_TO_DINT(N) THEN           (* kein Rundungsfehler *)
        numerator_old := numerator;         (* Numerator_old wird von Funktion zurückgegeben *)
        denominator_old := denominator;     (* Denominator_old wird von Funktion zurückgegeben *)
      END_IF;
      EXIT;                     (* keine weitere Berechnung notwendig *)
    ELSE
      X := 1.0 / (X - X_ohne_Nachkomma);        (* Kehrwert vom Rest -> Neuer Bruch *)
    END_IF;

  UNTIL
    ABS(Denominator) > INT_TO_DINT(N)
  END_REPEAT;

  (* correct sign if X was negative *)
  IF sign THEN
    REAL_TO_FRAC.NUMERATOR := -1 * ABS(DINT_TO_INT(numerator_old));
  ELSE
    REAL_TO_FRAC.NUMERATOR :=  ABS(DINT_TO_INT(numerator_old));
  END_IF;
  REAL_TO_FRAC.DENOMINATOR := ABS(DINT_TO_INT(denominator_old));

(* revision history
  hm    19. jan. 2011 rev 1.0
    original version

  ad    06. apr. 2011 rev 1.1
    optimized code
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION RND : REAL
(*
  this function rounds a real down to n digits total.
  round(3.1415,2) = 3.1

  version 1.2 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
    N : INT;
  END_VAR
  VAR
    M : REAL;
  END_VAR

  IF X = 0.0 THEN
    RND := 0.0;
  ELSE
    M := EXPN(10.0,N - CEIL1(LOG(ABS(X))));
    RND := DINT_TO_REAL(REAL_TO_DINT(X * M)) / M;
  END_IF;

(* revision history
  hm  11. mar 2008  rev 1.0
    original version

  hm  26. oct. 2008 rev 1.1
    code optimization

  hm  10. mar. 2009 rev 1.2
  	real constants updated to new systax using dot																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																											
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
 FUNCTION ROUND1 : REAL
(*
  this function rounds a real down to n digits behind the comma.

  version 1.5 25. oct. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    in : REAL;
    N : INT;
  END_VAR
  VAR
    X: REAL;
  END_VAR

  X := setup.DECADES[LIMIT(0,N,8)];
  ROUND1 := DINT_TO_REAL(REAL_TO_DINT(in * X)) / X;

(* revision history
  hm  1. sep 2006 rev 1.0
    original version

  hm  2. dec 2007 rev 1.1
    changed code for better performance

  hm  8. jan 2008 rev 1.2
    further improvement in performance

  hm 11. mar. 2008  rev 1.3
    corrected an error with negative numbers
    use real_to_dint instead of trunc

  hm  16. mar 2008  rev 1.4
    added type conversion to avoid warning under codesys 3.0

  hm  25. oct. 2008 rev 1.5
    new code using global constants decades
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION SIGMOID : REAL
(*
  this function calculates the sigmoid function

  version 1.2 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  IF X > 20.0 THEN
    SIGMOID := 1.0;
  ELSIF x < -85.0 THEN
    SIGMOID := 0.0;
  ELSE
    SIGMOID := 1.0 / (1.0 + EXP(-X));
  END_IF;

(* revision history
  hm  10.12.2007    rev 1.0
    original version

  hm  11. mar. 2008   rev 1.1
    extended range of valid inputs to +inv / -inv

  hm 10. mar. 2009    rev 1.2
  	real constants updated to new systax using dot																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																											
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION SIGN_I : BOOL
(*
  this function return true if the integer input is negative

  version 1.3 27. oct. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    IN : DINT;
  END_VAR

  SIGN_I := in.31;

(* revision history
  hm 3.3.2007 rev 1.1
    changed method of function for better compatibility to other systems

  hm  1.12.2007 rev 1.2
    changed code to improve performance

  hm  27. oct. 2008 rev 1.3
    changed type of input to dint

*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION SIGN_R : BOOL
(*
  this function return true if the real input is negative

  version 1.4 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    in : REAL;
  END_VAR

  SIGN_R := in < 0.0;

(* revision history
  hm 19.1.2007  rev 1.1
    changed method of function for better compatibility to other systems

  hm  1.12.2007 rev 1.2
    changed code to improve performance

  hm  14. jun. 2008 rev 1.3
    improved performace

  hm 10. mar. 2009  rev 1.4
  	real constants updated to new systax using dot																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																											
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION SINC : REAL
(*
  this function calculates the sinc function.

  version 1.2 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  IF X = 0.0 THEN
    SINC := 1.0;
  ELSE
    SINC := SIN(x) / x;
  END_IF;

(* revision histroy
  hm  11. mar. 2008 rev 1.0
    original version

  hm  1.12.2007 rev 1.1
    changed code to improove performance

  hm 10. mar. 2009  rev 1.2
  	real constants updated to new systax using dot																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																											
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION SINH : REAL
(*
  this function calculates the sin hyperbolicus

  version 1.3 11. mar 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  IF ABS(x) < 2E-3 THEN
    SINH := X;
  ELSE
    SINH := (EXP(x) - EXP(-x)) * 0.5;
  END_IF;

(* revision history
  hm  12.1.2007 rev 1.0
    original version

  hm  1.12.2007 rev 1.1
    changed code to improve performance

  hm  5. jan 2008 rev 1.2
    further performance improvement

  hm  11. mar 2008  rev 1.3
    improved accuracy around 0
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION SQRTN : REAL
(*
  this function calculates the nth root function of X according to the formula sqrtn = x^(1/n).

  version 1.3 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
    N : INT;
  END_VAR

  IF N > 0 THEN
    SQRTN := EXP(LN(x) / INT_TO_REAL(n));
  ELSE
    SQRTN := 0.0;
  END_IF;

(* revision history
  hm    12 jan 2007 rev 1.0
    original version

  hm    2. dec 2007 rev 1.1
    changed code for better performance

  hm    11. mar 2008  rev 1.2
    added result 0 for compatibility reasons

  hm 10. mar. 2009  rev 1.3
  	added type conversions for compatibility reasons																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																									
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION TANC : REAL
(*
  this function calculates the tanc function.

  version 1.1 10. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  IF X = 0.0 THEN
    TANC := 1.0;
  ELSE
    TANC := TAN(x) / x;
  END_IF;

(* revision histroy
  hm  23. oct. 2008 rev 1.0
    original version

  hm 10. mar. 2009  rev 1.1
  	real constants updated to new systax using dot																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																											
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION TANH : REAL
(*
  this function calculates the tangens hyperbolicus

  version 1.3 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR

  IF X > 20.0 THEN
    TANH := 1.0;
  ELSIF X < -20.0 THEN
    TANH := -1.0;
  ELSE
    TANH := 1.0 - 2.0 / (EXP(2.0 * x) + 1.0);
  END_IF;

(* revision hisdtory
  hm    12.1.2007   rev 1.0
    original version

  hm    1.12.2007   rev 1.1
    changed code to improve performance

  hm    10. mar 2008  rev 1.2
    corrected an error in formula
    extended range of valid inputs to +/- INV

  hm 10. mar. 2009  rev 1.3
  	real constants updated to new systax using dot																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																											
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION WINDOW : BOOL
(*
  this checks a signal if the signal is between the upper and lower limit

  version 1.1 22 jan 2007
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    low : REAL;
    in : REAL;
    high : REAL;
  END_VAR

  WINDOW := in < high AND in > low;

(* revision history
  hm  22.1.2007 rev 1.1
    changed the order of inputs to low, in, high
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION WINDOW2 : BOOL
(*
  this checks a signal if the signal is between the upper and lower limit including the two limits

  version 1.0 31 oct 2007
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    LOW : REAL;
    IN : REAL;
    HIGH : REAL;
  END_VAR

  WINDOW2 := IN >= LOW AND IN <= HIGH;

(* revision history
  hm  31.10.2007  rev 1.0
    original version
*)
END_FUNCTION

