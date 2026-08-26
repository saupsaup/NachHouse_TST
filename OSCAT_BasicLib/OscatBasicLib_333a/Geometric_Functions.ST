(* @PATH := '\/Mathematical\/Geometry' *)
FUNCTION CIRCLE_A : REAL
(*
  circle_A calculates the Area of a circle segement if ax = 360 the whole circle is calculated

  version 1.2 22. feb 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    rx : REAL;
    ax : REAL;
  END_VAR

  circle_A := Rx * RX * 8.726646E-3 * Ax;

(* revision histroy
  hm  16. oct 2007  rev 1.0
    original version

  hm  4. dec 2007   rev 1.1
    changed code for better performance

  hm  22. feb 2008  rev 1.2
    improved performance
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Geometry' *)
FUNCTION CIRCLE_C : REAL
(*
  circle_C calculates the Circumference of a circle  if ax = 360 the whole circle is calculated

  version 1.1 22 feb 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    Rx : REAL;
    Ax : REAL;
  END_VAR

  circle_C := 1.7453293E-2 * Rx * Ax;

(* revision histroy
  hm  16. oct 2007  rev 1.0
    original version

  hm  22. feb 2008  rev 1.1
    improved performance
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Geometry' *)
FUNCTION CIRCLE_SEG : REAL
(*
  CIRCLE_SEG calculates the Area of a circle segement enclosed between a sectant line and the circumference.

  version 1.0 10. Mar 2010
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    RX : REAL;
    HX : REAL;
  END_VAR
  VAR_TEMP
    tmp : REAL;
  END_VAR

  IF RX > 0.0 THEN
    tmp := 2.0 * ACOS(1.0 - LIMIT(0.0, HX / RX, 2.0));
    tmp := (tmp - SIN(tmp)) *RX * RX / 2.0;
  END_IF;
  CIRCLE_SEG := tmp;

(* revision histroy
  hm  10. mar 2010  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Geometry' *)
FUNCTION CONE_V : REAL
(*
  cone_V calculates the Volume of a cone

  version 1.1 4 dec 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    rx : REAL;
    hx : REAL;
  END_VAR

  cone_V := 1.047197551 * RX * RX * hx;

(* revision histroy
  hm  17. oct 2007  rev 1.0
    original version

  hm  4. dec 2007   rev 1.1
    changed code for better performance

  hm  22. feb 2008  rev 1.2
    changed code for better performance
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Geometry' *)
FUNCTION ELLIPSE_A : REAL
(*
  ellipse_A calculates the Area of an ellipe based on the two radians R1 and R2

  version 1.1 18. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    R1 : REAL;
    R2 : REAL;
  END_VAR

  ELLIPSE_A := math.PI * R1 * R2;

(* revision histroy
  hm  16. oct 2007  rev 1.0
    original version

  hm  18. oct. 2008 rev 1.1
    using math constants
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Geometry' *)
FUNCTION ELLIPSE_C : REAL
(*
  ellipse_C calculates the circumference of an ellipe based on the two radians R1 and R2

  version 1.2 10. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    R1 : REAL;
    R2 : REAL;
  END_VAR

  ELLIPSE_C := math.PI * (3.0 * (R1+R2) - SQRT((3.0 * r1 + R2) * (3.0 * r2 + r1)));

(* revision histroy
  hm  16. oct 2007  rev 1.0
    original version

  hm  18. oct. 2008 rev 1.1
    using math constants

  hm  10. mar. 2009 rev 1.2
    changed syntax of real constants to 0.0
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Geometry' *)
FUNCTION SPHERE_V : REAL
(*
  sphere_V calculates the Volume of a Sphere

  version 1.2 22. feb 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    rx : REAL;
  END_VAR

  sphere_V := 4.188790205 * Rx * RX * RX;

(* revision histroy
  hm  16. oct 2007  rev 1.0
    original version

  hm  4. dec 2007   rev 1.1
    changed code for better performance

  hm  22. feb 2008    rev 1.2
    changed code for better performance
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Geometry' *)
FUNCTION TRIANGLE_A : REAL
(*
  triangle_A calculates the Area of a triangle.
  if any input is 0 it will be neglected and the are will be calculated from eiter:
  two sides and an angle (s1 and S2 and the angle A1) or 3 sides.

  version 1.2 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    S1 : REAL;
    A : REAL;
    S2 : REAL;
    S3 : REAL;
  END_VAR

  IF A = 0.0 THEN
    TRIANGLE_A := SQRT((s1+s2+S3) * (s1+s2-S3) * (S2+S3-S1) * (S3+S1-S2)) * 0.25;
  ELSE
    TRIANGLE_A := S1 * S2 * SIN(RAD(A)) * 0.5;
  END_IF;

(* revision histroy
  hm  16. oct 2007  rev 1.0
    original version

  hm  22. feb 2008  rev 1.1
    improved performance

  hm  10. mar. 2009 rev 1.2
    changed syntax of real constants to 0.0
*)
END_FUNCTION

