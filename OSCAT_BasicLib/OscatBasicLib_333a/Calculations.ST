(* @PATH := '\/Engineering\/conversion' *)
FUNCTION_BLOCK ASTRO
(*
  this function converts different length units
  any unused input can simply be left open.
  different inputs connected at the same time will be added up.

  version 1.1 11. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    m : REAL;
    AE : REAL;
    PC : REAL;
    LJ : REAL;
  END_VAR
  VAR_OUTPUT
    Ym : REAL;
    YAE : REAL;
    YPC : REAL;
    YLJ : REAL;
  END_VAR

  YAE :=  AE
      + m * 6.6845871535E-012
      + PC * 206265.0
      + LJ * 63240.0;
  Ym := YAE * 149.597870E9;
  YPC := YAE * 4.8481322570E-006;
  YLJ := YAE * 1.5812776724E-005;

(*
  L‰nge Meter m SI-Basiseinheit
  Astronomische Einheit* AE 1 AE = 149,597 870 ∑ E9 m
  Parsec pc 1 pc = 206265 AE = 30,857 ∑ E15 m
  Lichtjahr Lj 1 Lj = 9,460 530 ∑ E15 m = 63240 AE = 0,306 59 pc
  Lngstrˆm L 1 L = Eñl0 m
  typograph. Punkt p 1 p = 0,376 065 mm ï im Druckereigewerbe
  inch** in 1 in = 2,54 ∑ Eñ2 m = 25,4 mm***
  foot ft 1 ft = 0,3048 m = 30,48 cm
  yard yd 1 yd = 0,9144 m
  mile mile 1 mile = 1609,344 m
  Internat. Seemeile sm 1 sm = 1852 m
  Fathom fm 1 fm = 1,829 m ï in der Seeschifffahrt
*)
(* revision history
  hm  27. mar. 2007 rev 1.0
    original version

  hm  11. mar. 2009 rev 1.1
    improved code
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/conversion' *)
FUNCTION BFT_TO_MS : REAL
(*
  this function converts wind speed from beaufort to m/s

  version 1.0 12. jun 2008
  programmer  hugo
  tested by   oscdat
*)
  VAR_INPUT
    BFT : INT;
  END_VAR

  BFT_TO_MS := EXPT( INT_TO_REAL(BFT), 1.5) * 0.836;

(* revision history
  hm  12. 6. 2008   rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Engineering\/conversion' *)
FUNCTION C_TO_F : REAL
(*
  this function converts celsius  to fahrenheit

  version 1.1 11. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    celsius : REAL;
  END_VAR

  C_TO_F := celsius * 1.8 + 32.0;

(* revision history
  hm  4. aug. 2006  rev 1.0
    original version

  hm  11. mar. 2009 rev 1.1
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Engineering\/conversion' *)
FUNCTION C_TO_K : REAL
(*
  this function converts celsius to kelvin

  version 1.1 19. aug 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    Celsius : REAL;
  END_VAR

  C_TO_K := Celsius - phys.T0;

(* revision history
  hm  4. aug 2006 rev 1.0
    original version

  hm  19. aug 2009  rev 1.1
    fixed calculation error
*)
END_FUNCTION


(* @PATH := '\/Engineering\/conversion' *)
FUNCTION DEG_TO_DIR : STRING[3]
(*
  this function converts degrees in compass direction.
  the function supports output in english (L=0) and german (L=1).

  version 1.1 22. oct. 2008
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    DEG : INT;
    N : INT;
    L : INT;
  END_VAR
  VAR
    ly: INT;
    word2 : WORD;
    word8 : WORD;
    tmp : INT;
  END_VAR

  IF L = 0 THEN ly := LANGUAGE.DEFAULT; ELSE ly := MIN(L, LANGUAGE.LMAX); END_IF;
  word2 := 2; word8 := 8;
  tmp := WORD_TO_INT(SHL(word2,INT_TO_UINT(N))) * WORD_TO_INT(SHR(word8,INT_TO_UINT(N)));
  DEG_TO_DIR := LANGUAGE.DIRS[ly, ((WORD_TO_INT(SHL(INT_TO_WORD(DEG),INT_TO_UINT(N-1))) + 45) / 90) MOD tmp];

(*
  DIR := ((SHL(DEG,N-1) + 45) / 90) MOD SHL(INT#2,N);
  explanation :
  DIR is calculated BY the following formula:
  DIR := ((DIR + 45) / 90) MOD 4 if N = 1 digit
  North = 0, East = 1 ....
  DIR := ((DIR + 22,5) / 45) MOD 8 if N = 2 digit
  convert to integer calculation
  DIR := ((DIR*2 + 45) / 90) MOD 8
  N = 0, NE = 1 ....
  ther above formula replaces 2^N with shift for performance
*)
(* revision histroy
  hm  11. jun. 2008 rev 1.0
    original release

  hm  22. oct. 2008 rev 1.1
    changed size of string variables to 30
*)
END_FUNCTION


(* @PATH := '\/Engineering\/conversion' *)
FUNCTION DIR_TO_DEG : INT
(*
  this function converts compass directions to degrees
  it will recognize up to 3 letter directions in english and german writing.

  version 1.1 22. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    DIR : STRING[3];
    L : INT;
  END_VAR
  VAR
    ly: INT;
    i : INT;
  END_VAR

  IF L = 0 THEN ly := LANGUAGE.DEFAULT; ELSE ly := MIN(L, LANGUAGE.LMAX); END_IF;
  FOR i := 0 TO 15 DO
    IF language.DIRS[ly, i] = DIR THEN EXIT; END_IF;
  END_FOR;
  DIR_TO_DEG := WORD_TO_INT(SHR(INT_TO_WORD(i * 45 + 1), 1));

(* revision histroy
  hm  22. oct. 2008 rev 1.1
    original release
*)
END_FUNCTION


(* @PATH := '\/Engineering\/conversion' *)
FUNCTION_BLOCK ENERGY
(*
  this function converts different energy units
  any unused input can simply be left open.
  different inputs connected at the same time will be added up.

  version 1.2 16. jan. 2010
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    J : REAL;
    C : REAL;
    Wh : REAL;
  END_VAR
  VAR_OUTPUT
    YJ : REAL;
    YC : REAL;
    YWh : REAL;
  END_VAR

  YJ := J + Wh * 3600.0 + C * 4.1868;
  YC := YJ * 0.238845896627496;
  YWh := YJ * 2.7777777778E-004;

(*
  Arbeit, Energie, Joule* J 1 J = 1 N ∑ m = 1 W ∑ s = (1/3,6) Eñ6 kW ∑ h = 1 kg ∑ m2/s2
  W‰rmemenge Kilowattstunde kW ∑ h 1 kW ∑ h = 3,6 MJ = 860 kcal
  Elektronvolt eV 1 eV = 160,218 92 Eñ21 J
  Erg erg 1 erg = 1Eñ7 J
  Kalorie calorie 1 calalorie = 4,1868 J = 1,163 Eñ3 W ∑ h
  Therm therm 1 therm = 105,50 ∑ 106 J
*)
(* revision history
  hm  27. mar. 2007 rev 1.0
    original version

  hm  11. mar. 2009 rev 1.1
    improved code

  hm 16. jan 2010 rev 1.2
    avoid the string cal in comments for codesys import bug
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/conversion' *)
FUNCTION F_TO_C : REAL
(*
  this FUNCTION converts fahrenheit TO celsius

  version 1.1 11. mar. 2009
  programmer  hugo
  tested BY   tobias
*)
  VAR_INPUT
    fahrenheit : REAL;
  END_VAR

  F_TO_C := (fahrenheit - 32.0) * 0.5555555555555;

(* revision history
  hm  4. aug 2006 rev 1.0
    original version

  hm  11. mar. 2009 rev 1.1
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Engineering\/conversion' *)
FUNCTION F_TO_OM : REAL
(*
  this function converts frequency to Omega F
  Omega = 2*PI*F

  version 1.1 18. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    F : REAL;
  END_VAR

  F_TO_OM := math.PI2 * F;

(* revision history
  hm  22. jan. 2007 rev 1.0
    original version

  hm  18. oct. 2008 rev 1.1
    unsing math constants
*)
END_FUNCTION


(* @PATH := '\/Engineering\/conversion' *)
FUNCTION F_TO_PT : TIME
(*
  this function converts frequency to periode time

  version 1.1 11. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    F : REAL;
  END_VAR

  F_TO_PT := DWORD_TO_TIME(REAL_TO_DWORD(1.0 / F * 1000.0));


(* revision history
  hm  4. aug. 2006  rev 1.0
    original version

  hm  11. mar. 2009 rev 1.1
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Engineering\/conversion' *)
FUNCTION GEO_TO_DEG : REAL
(*
  this function converts degrees, minutes seconds to decimal degrees.

  version 1.0 22. jan. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    D : INT;
    M : INT;
    SEC : REAL;
  END_VAR

  GEO_TO_DEG := INT_TO_REAL(D) + INT_TO_REAL(M) * 0.016666666666667 + sec * 0.00027777777777778;

(* revision histroy
   hm  22. jan. 2009 rev 1.0
   original release
*)
END_FUNCTION


(* @PATH := '\/Engineering\/conversion' *)
FUNCTION K_TO_C : REAL
(*
  this function converts kelvin to celsius

  version 1.1 19. aug 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    Kelvin : REAL;
  END_VAR

  K_TO_C := Kelvin + phys.T0;

(* revision history
  hm  4. aug 2006 rev 1.0
    original version

  hm  19. aug 2009  rev 1.1
    fixed calculation error
*)
END_FUNCTION


(* @PATH := '\/Engineering\/conversion' *)
FUNCTION KMH_TO_MS : REAL
(*
  this function converts velocities from Kilometers / hour to Meters / Second

  version 1.1 6 jan 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    kmh : REAL;
  END_VAR

  KMH_TO_MS := kmh * 0.2777777777777;

(* revision history
  hm  4. feb 2007   rev 1.0
    original version

  hm  6. jan 2008   rev 1.1
    improved performance
*)
END_FUNCTION


(* @PATH := '\/Engineering\/conversion' *)
FUNCTION_BLOCK LENGTH
(*
  this function converts different length units
  any unused input can simply be left open.
  different inputs connected at the same time will be added up.

  version 1.1 11. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    m : REAL;
    p : REAL;
    in : REAL;
    ft : REAL;
    yd : REAL;
    mile : REAL;
    sm : REAL;
    fm : REAL;
  END_VAR
  VAR_OUTPUT
    Ym : REAL;
    Yp : REAL;
    Yin : REAL;
    Yft : REAL;
    Yyd : REAL;
    Ymile : REAL;
    Ysm : REAL;
    Yfm : REAL;
  END_VAR

  Ym := m
      + p * 0.000376065
      + in * 0.0254
      + ft * 0.3048
      + yd * 0.9144
      + mile * 1609.344
      + sm * 1852.0
      + fm * 1.829;
  Yp := Ym * 2659.11478068951;
  Yin := Ym * 39.37007874016;
  Yft := Ym * 3.28083989501;
  Yyd := Ym * 1.09361329834;
  Ymile := Ym * 0.00062137119;
  Ysm := Ym * 0.00053995680;
  Yfm := Ym * 0.54674685621;

(*
  L‰nge Meter m SI-Basiseinheit
  Astronomische Einheit* AE 1 AE = 149,597 870 ∑ E9 m
  Parsec pc 1 pc = 206265 AE = 30,857 ∑ E15 m
  Lichtjahr Lj 1 Lj = 9,460 530 ∑ E15 m = 63240 AE = 0,306 59 pc
  Lngstrˆm L 1 L = Eñl0 m
  typograph. Punkt p 1 p = 0,376 065 mm ï im Druckereigewerbe
  inch** in 1 in = 2,54 ∑ Eñ2 m = 25,4 mm***
  foot ft 1 ft = 0,3048 m = 30,48 cm
  yard yd 1 yd = 0,9144 m
  mile mile 1 mile = 1609,344 m
  Internat. Seemeile sm 1 sm = 1852 m
  Fathom fm 1 fm = 1,829 m ï in der Seeschifffahrt
*)
(* revision history
  hm  27. mar. 2007 rev 1.0
    original version

  hm  11. mar. 2009 rev 1.1
    improved code
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/conversion' *)
FUNCTION MS_TO_BFT : INT
(*
  this function converts wind speed from M/s to beaufort

  version 1.0 12. jun 2008
  programmer  hugo
  tested by oscdat
*)
  VAR_INPUT
    MS : REAL;
  END_VAR

  MS_TO_BFT := REAL_TO_INT(EXPT(MS * 1.196172, 0.666667));

(* revision history
  hm  12. 6. 2008   rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Engineering\/conversion' *)
FUNCTION MS_TO_KMH : REAL
(*
  this function converts velocities from Meters / Second to Kilometers / hour.

  version 1.0 4 Feb 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    ms : REAL;
  END_VAR

  MS_TO_KMH := ms * 3.6;
END_FUNCTION


(* @PATH := '\/Engineering\/conversion' *)
FUNCTION OM_TO_F : REAL
(*
  this function converts Omega F to frequency
  F = OM / (2*PI)

  version 1.1 18. oct. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    OM : REAL;
  END_VAR

  OM_TO_F := OM / math.PI2;

(* revision history
  hm  22. jan. 2007 rev 1.0
    original version

  hm  18. oct. 2008 rev 1.1
    using math constants
*)
END_FUNCTION


(* @PATH := '\/Engineering\/conversion' *)
FUNCTION_BLOCK PRESSURE
(*
  this function converts different pressure units
  any unused input can simply be left open.
  different inputs connected at the same time will be added up.

  version 1.1 11. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    mws : REAL;
    torr : REAL;
    att : REAL;
    atm : REAL;
    pa : REAL;
    bar : REAL;
  END_VAR
  VAR_OUTPUT
    Ymws : REAL;
    Ytorr : REAL;
    Yatt : REAL;
    Yatm : REAL;
    Ypa : REAL;
    Ybar : REAL;
  END_VAR

  Ybar := bar +
      pa * 1.0E-5 +
      0.980665 * att +
      1.01325 * atm +
      0.001333224 * torr +
      0.0980665 * mws;
  Ymws := ybar * 10.1971621297793;
  Ytorr := ybar * 750.0615050434140;
  Yatt := ybar * 1.0197162129779;
  yatm := ybar * 0.9869232667160;
  Ypa := ybar * 100000.0;

(*
  Druck, Pascal Pa 1 Pa = 1 N/m2 = 1 kg/(s2 ÅE m) . 0,75 ÅE 10.2 mmHg
  mechanische 1 MPa = 1 N/mm2 . fur Festigkeitsangaben
  Spannung Bar bar 1 bar = 105 Pa = 103 mbar = 105 kg/(s2 ÅE m)
  Millimeter- mmHg 1 mmHg = 133,322 Pa = 1,333 22 mbar
  Quecksilbersaule . nur in Heilkunde zulassig
  physik. Atmosphare atm 1 atm = 1,013 25 bar
  techn. Atmosphare at 1 at = 1 kp/cm2 = 0,980665 bar
  Torr Torr 1 Torr = (101325/760) Pa = 1,333224 mbar
  Meter-Wassersaule mWS 1 mWS = 9806,65 Pa = 98,0665 mbar
  psi lbf/in2 1 lbf/in2 = 68,947 57 mbar = 6894,757 Pa
*)
(* revision history
  hm  27. mar. 2007 rev 1.0
    original version

  hm  11. mar. 2009 rev 1.1
    improved code
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/conversion' *)
FUNCTION PT_TO_F : REAL
(*
  this function converts periode time to frequency

  version 1.1 11. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    PT : TIME;
  END_VAR

  PT_TO_F := 1000.0 / DWORD_TO_REAL(TIME_TO_DWORD(PT));

(*  revision history
  hm  4. aug. 2006  rev 1.0
    original version

  hm  11. mar. 2009 rev 1.1
    real constants updated to new systax using dot
*)

END_FUNCTION


(* @PATH := '\/Engineering\/conversion' *)
FUNCTION_BLOCK SPEED
(*
  this function converts different speed units
  any unused input can simply be left open.
  different inputs connected at the same time will be added up.

  version 1.1 11. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    ms : REAL;
    kmh : REAL;
    kn : REAL;
    mh : REAL;
  END_VAR
  VAR_OUTPUT
    Yms : REAL;
    Ykmh : REAL;
    Ykn : REAL;
    Ymh : REAL;
  END_VAR

  Yms := ms +
      kmh * 0.27777777777778 +
      kn * 0.5144444 +
      mh * 0.44704;
  Ykmh := Yms * 3.6;
  Ykn := Yms * 1.94384466037535;
  Ymh := Yms * 2.23693629205440;

(*
  Geschwindigkeit Meter durch Sekunde m/s 1 m/s = 3,6 km/h
  km durch (pro) Stunde, nicht ÑStundenkilometerì verwenden
  Knoten kn 1 kn = 1 sm/h = 0,5144 m/s
*)
(* revision history
  hm  27. mar. 2009 rev 1.0
    original version

  hm  11. mar. 2009 rev 1.1
    improved code
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/conversion' *)
FUNCTION_BLOCK TEMPERATURE
(*
  this function converts different temperature units
  any unused input can simply be left open.
  different inputs connected at the same time will be added up.

  version 1.0 21 feb 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    K : REAL;
    C : REAL := -273.15;
    F : REAL := -459.67;
    Re : REAL := -218.52;
    Ra : REAL;
  END_VAR
  VAR_OUTPUT
    YK : REAL;
    YC : REAL;
    YF : REAL;
    YRe : REAL;
    YRa : REAL;
  END_VAR

  YK := K + (C + 273.15) + (F + 459.67) * 0.555555555555 + (Re * 1.25 + 273.15) + (Ra * 0.555555555555);
  YC := YK -273.15;
  YF := YK * 1.8 - 459.67;
  YRe := (YK - 273.15) * 0.8;
  YRa := YK * 1.8;

(* revision history
  hm  21. feb. 2008 rev 1.0
    original version
*)
END_FUNCTION_BLOCK

