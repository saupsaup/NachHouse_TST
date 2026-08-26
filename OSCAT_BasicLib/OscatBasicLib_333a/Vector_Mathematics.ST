(* @PATH := '\/Mathematical\/Vektormathematik' *)
FUNCTION V3_ABS : REAL
(*
  this function calculates the length of a vectors in a 3 dimensional space

  version 1.0 11 dec 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    A : Vector_3;
  END_VAR

  V3_ABS := SQRT(A.X * A.X + A.Y * A.Y + A.Z * A.Z);

(* revision history
  hm  11 dec 2007 rev 1.0
      original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Vektormathematik' *)
FUNCTION V3_ADD : vector_3
(*
  this function adds two vectors in a 3 dimensional space

  version 1.0 11 dec 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    A : Vector_3;
    B : Vector_3;
  END_VAR

  V3_ADD.X := A.X + B.X;
  V3_ADD.Y := A.Y + B.Y;
  V3_ADD.Z := A.Z + B.Z;

(* revision history
  hm    11 dec 2007 rev 1.0
        original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Vektormathematik' *)
FUNCTION V3_DPRO : REAL
(*
  this function calculates the dot product of two vectors in 3 dimensional space

  version 1.0 11 dec 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    A : Vector_3;
    B : Vector_3;
  END_VAR

  V3_DPRO := A.X * B.X + A.Y * B.Y + A.Z * B.Z;

(* revision history
  hm  11 dec 2007 rev 1.0
      original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Vektormathematik' *)
FUNCTION V3_ANG : REAL
(*
  this function calculates the angle between two vectors in a 3 dimensional space

  version 1.1 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    A : Vector_3;
    B : Vector_3;
  END_VAR
  VAR
    d : REAL;
  END_VAR

  d := V3_ABS(A) * V3_ABS(B);
  IF d > 0.0 THEN
    V3_ANG := ACOS(LIMIT(-1.0, V3_DPRO(A, B) / d,1.0));
  END_IF;

(* revision history
  hm  11. dec. 2007 rev 1.0
    original version

  hm  10. mar. 2009 rev 1.1
    changed syntax of real constants to 0.0
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Vektormathematik' *)
FUNCTION V3_SMUL : vector_3
(*
  this function multiplies a vectors in a 3 dimensional space with a skalar M

  version 1.0 11 dec 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    A : Vector_3;
    M : REAL;
  END_VAR

  V3_SMUL.X := A.X * M;
  V3_SMUL.Y := A.Y * M;
  V3_SMUL.Z := A.Z * M;

(* revision history
  hm    11 dec 2007 rev 1.0
        original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Vektormathematik' *)
FUNCTION V3_NORM : vector_3
(*
  this function generates a vectors with absolute length 1 from a vector A in a 3 dimensional space

  version 1.1 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    A : Vector_3;
  END_VAR
  VAR
    la: REAL;
  END_VAR

  la := V3_ABS(A);
  IF la > 0.0 THEN
    V3_NORM := V3_SMUL(A, 1.0 / la);
  END_IF;

(* revision history
  hm  11 dec 2007 rev 1.0
    original version

  hm  10. mar. 2009 rev 1.1
    changed syntax of real constants to 0.0
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Vektormathematik' *)
FUNCTION V3_NUL : BOOL
(*
  this function checks if a vectors in a null Vector

  version 1.1 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    A : Vector_3;
  END_VAR

  V3_NUL := A.X = 0.0 AND A.Y = 0.0 AND A.Z = 0.0;

(* revision history
  hm  12 dec 2007 rev 1.0
    original version

  hm  10. mar. 2009 rev 1.1
    changed syntax of real constants to 0.0
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Vektormathematik' *)
FUNCTION V3_XPRO : vector_3
(*
  this function adds two vectors in a 3 dimensional space

  version 1.0 11 dec 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    A : Vector_3;
    B : Vector_3;
  END_VAR

  V3_XPRO.X := A.Y * B.Z - A.Z * B.Y;
  V3_XPRO.Y := A.Z * B.X - A.X * B.Z;
  V3_XPRO.Z := A.X * B.Y - A.Y * B.X;

(* revision history
  hm    11 dec 2007 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Vektormathematik' *)
FUNCTION V3_PAR : BOOL
(*
  this function checks if two vectors in a 3 dimensional space are parallel.
  which means the two vectors have the same direction

  version 1.1 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    A : Vector_3;
    B : Vector_3;
  END_VAR

  V3_PAR := V3_ABS(V3_XPRO(A, B)) = 0.0;

(* revision history
  hm  11 dec 2007 rev 1.0
    original version

  hm  10. mar. 2009 rev 1.1
    changed syntax of real constants to 0.0
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Vektormathematik' *)
FUNCTION V3_REV : vector_3
(*
  this function reverses a vector in a 3 dimensional space

  version 1.0 11 dec 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    A : Vector_3;
  END_VAR

  V3_REV.X := -A.X;
  V3_REV.Y := -A.Y;
  V3_REV.Z := -A.Z;

(* revision history
  hm    11 dec 2007 rev 1.0
        original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Vektormathematik' *)
FUNCTION V3_SUB : vector_3
(*
  this function subtracts two vectors in a 3 dimensional space
  V3_SUB = A - B

  version 1.0 11 dec 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    A : Vector_3;
    B : Vector_3;
  END_VAR

  V3_SUB.X := A.X - B.X;
  V3_SUB.Y := A.Y - B.Y;
  V3_SUB.Z := A.Z - B.Z;

(* revision history
  hm    11 dec 2007 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Vektormathematik' *)
FUNCTION V3_XANG : REAL
(*
  this function calculates the angle between the X-axis and a vectors in a 3 dimensional space

  version 1.1 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    A : Vector_3;
  END_VAR
  VAR
    la: REAL;
  END_VAR

  la := V3_ABS(a);
  IF la > 0.0 THEN
    V3_XANG := ACOS(A.X / la);
  END_IF;

(* revision history
  hm  11 dec 2007 rev 1.0
    original version

  hm  10. mar. 2009 rev 1.1
    changed syntax of real constants to 0.0
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Vektormathematik' *)
FUNCTION V3_YANG : REAL
(*
  this function calculates the angle between the Y-axis and a vectors in a 3 dimensional space

  version 1.1 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    A : Vector_3;
  END_VAR
  VAR
    la: REAL;
  END_VAR

  la := V3_ABS(a);
  IF la > 0.0 THEN
    V3_YANG := ACOS(A.Y / la);
  END_IF;

(* revision history
  hm  11 dec 2007 rev 1.0
    original version

  hm  10. mar. 2009 rev 1.1
    changed syntax of real constants to 0.0
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Vektormathematik' *)
FUNCTION V3_ZANG : REAL
(*
  this function calculates the angle between the Z-axis and a vectors in a 3 dimensional space

  version 1.1 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    A : Vector_3;
  END_VAR
  VAR
    la: REAL;
  END_VAR



  la := V3_ABS(a);
  IF la > 0.0 THEN
    V3_ZANG := ACOS(A.Z / la);
  END_IF;

(* revision history
  hm  11 dec 2007 rev 1.0
    original version

  hm  10. mar. 2009 rev 1.1
    changed syntax of real constants to 0.0
*)
END_FUNCTION

