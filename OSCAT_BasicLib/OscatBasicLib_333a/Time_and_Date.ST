TYPE
  OSCAT_BASIC_ARRAY0_29_OF_HOLIDAY_DATA : ARRAY[0..29] OF HOLIDAY_DATA;
  OSCAD_BASIC_ARRAY0_49_OF_HOLIDAY_DATA : ARRAY[0..49] OF HOLIDAY_DATA;
END_TYPE


(* @PATH := '\/Time&Date' *)
FUNCTION YEAR_OF_DATE1 : INT
(*
  returs the year of a date
  the function works for dates from 1970 - 2099

  version 1.4 7. oct. 2008
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    IDATE : DATE;
  END_VAR

  YEAR_OF_DATE1 := UDINT_TO_INT((DATE_TO_UDINT(idate) + 43200) / 31557600 + 1970);

(* revision history
  hm  4. aug 2006   rev 1.0
    original version

  hm  1. okt 2007   rev 1.1
    corrected error in algorithm
    adjustment for S7 compatibility

  hm  23.12.2007    rev 1.2
    changed code for better performance

  hm  7. apr. 2008  rev 1.3
    deleted unused step7 code

  hm  7. oct. 2008  rev 1.4
    renamed function (year) to year_of_date
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION DAY_OF_YEAR1 : INT
(*
  calculates the day of the year

  version 1.4   28. jan. 2011
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    IDATE : DATE;
  END_VAR

  DAY_OF_YEAR1 := UDINT_TO_INT((DATE_TO_UDINT(idate) / UDINT#86400) MOD UDINT#1461);
  IF DAY_OF_YEAR1 > 729 THEN
  	IF DAY_OF_YEAR1 > 1095 THEN DAY_OF_YEAR1 := DAY_OF_YEAR1 - 1095; ELSE DAY_OF_YEAR1 := DAY_OF_YEAR1 - 729; END_IF;
  ELSIF DAY_OF_YEAR1 > 364 THEN
  	DAY_OF_YEAR1 := DAY_OF_YEAR1 - 364;
  ELSE
  	DAY_OF_YEAR1 := DAY_OF_YEAR1 + 1;
  END_IF;

(*
DAY_OF_YEAR1 := DWORD_TO_INT((DATE_TO_DWORD(idate) - DATE_TO_DWORD(YEAR_BEGIN(YEAR_OF_DATE1(idate)))) / 86400) + 1;
*)
(* revivision history
  hm  4. aug. 2007    rev 1.0
    original version

  hm  1. oct. 2007    rev 1.1
    added compatibility to STEP7

  hm  4. jan. 2008    rev 1.2
    changed code for better performance

  hm  7. oct. 2008    rev 1.3
    changed name of function year to year_of_date

  hm  28. jan. 2011 rev 1.4
    improved code
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION LEAP_OF_DATE : BOOL
(*
  leap_of_date is true if current year is a leap year

  version 1.3   28. jan. 2011
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    idate : DATE;
  END_VAR

  LEAP_OF_DATE := SHL(UDINT_TO_DWORD((DATE_TO_UDINT(idate) + 43200) / 31557600), 30) = 16#80000000;

(* change history
  2.10.2006   rev 1.1
  the function now calls leap_year to accomodate further accuracy.
  the function now works for any year from 1970 to 2100

  8. jan 2008   rev 1.2
    improved code for better performance

  28. jan. 2011 rev 1.3
    improved performance
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION MONTH_OF_DATE1 : INT
(*
  returns the current month of the year.

  version 1.3 27. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IDATE : DATE;
  END_VAR

  MONTH_OF_DATE1 := DAY_OF_YEAR1(idate);
  IF MONTH_OF_DATE1 < 32 THEN
  	MONTH_OF_DATE1 := 1;
  ELSIF LEAP_OF_DATE(IDATE) THEN
  	MONTH_OF_DATE1 := (MONTH_OF_DATE1 * 53 + 1668) / 1623;
  ELSE
  	MONTH_OF_DATE1 := (MONTH_OF_DATE1 * 53 + 1700) / 1620;
  END_IF;

(* code for rev 1.2
  MONTH_OF_DATE1 := DAY_OF_YEAR1(IDATE);
  IF LEAP_OF_DATE(IDATE) THEN
    CASE MONTH_OF_DATE1 OF
      1..31   : MONTH_OF_DATE1 := 1;
      32..60  : MONTH_OF_DATE1 := 2;
      61..91  : MONTH_OF_DATE1 := 3;
      92..121 : MONTH_OF_DATE1 := 4;
      122..152: MONTH_OF_DATE1 := 5;
      153..182: MONTH_OF_DATE1 := 6;
      183..213: MONTH_OF_DATE1 := 7;
      214..244: MONTH_OF_DATE1 := 8;
      245..274: MONTH_OF_DATE1 := 9;
      275..305: MONTH_OF_DATE1 := 10;
      306..335: MONTH_OF_DATE1 := 11;
      336..366: MONTH_OF_DATE1 := 12;
    END_CASE;
  ELSE
    CASE MONTH_OF_DATE1 OF
      1..31   : MONTH_OF_DATE1 := 1;
      32..59  : MONTH_OF_DATE1 := 2;
      60..90  : MONTH_OF_DATE1 := 3;
      91..120 : MONTH_OF_DATE1 := 4;
      121..151: MONTH_OF_DATE1 := 5;
      152..181: MONTH_OF_DATE1 := 6;
      182..212: MONTH_OF_DATE1 := 7;
      213..243: MONTH_OF_DATE1 := 8;
      244..273: MONTH_OF_DATE1 := 9;
      274..304: MONTH_OF_DATE1 := 10;
      305..334: MONTH_OF_DATE1 := 11;
      335..365: MONTH_OF_DATE1 := 12;
    END_CASE;
  END_IF;
*)
(* revision history
  hm  1. aug 2006 rev 1.0
    original version

  hm  1. okt 2007 rev 1.1
    replaced old code (string conversion) with mathematics
    the execution time is now multiple times faster.

  hm  7. oct. 2008  rev 1.2
    changed name of function from month to MONTH_OF_DATE1

  hm  27. mar. 2009 rev 1.3
    new improved code
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION SET_DATE : DATE
(*
  creates a date output from year, month and day of month

  version 2.3 29. dec. 2011
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    YEAR : INT;
    MONTH : INT;
    DAY : INT;
  END_VAR
  VAR
    count : INT;
  END_VAR

  IF month > 2 THEN
    count := (month - 1) * 30;
    IF month > 7 THEN count := count + WORD_TO_INT(SHR(INT_TO_WORD(month - 3),1)); ELSE count := count + WORD_TO_INT(SHR(INT_TO_WORD(month - 4),1)); END_IF;
    (* chech for leap year and add one day if true *)
    IF WORD_TO_INT(SHL(INT_TO_WORD(year),14)) = 0 THEN count := count + 1; END_IF;
  ELSE
    count := (month - 1) * 31;
  END_IF;
  SET_DATE := UDINT_TO_DATE((INT_TO_UDINT(count + day - 1) + DWORD_TO_UDINT(SHR( UDINT_TO_DWORD(INT_TO_UDINT(year) * 1461 - 2878169), 2))) * 86400);

(* revision history
  hm  4. aug. 2006  rev 1.0
    original version

  hm  19 sep. 2007  rev 1.1
    use function leap_year to calculate leap year, more exceptions are handled

  hm  1. okt  2007  rev 1.2
    added compatibility to step7

  hm  16.dec 2007   rev 1.3
    changed code to improove performance

  hm  3. jan. 2008  rev 1.4
    further improvements in performance

  hm  16. mar. 2008 rev 1.5
    added type conversions to avoid warnings under codesys 3.0

  hm  7. apr. 2008  rev 1.6
    deleted unused step7 code

  hm  14. oct. 2008 rev 1.7
    optimized code for better performance

  hm  25. oct. 2008 rev 2.0
    new code using setup constants

  hm  16. nov. 2008 rev 2.1
    added typecasts to avoid warnings

  hm  22. jan. 2011 rev 2.2
    improved performance

  hm  29. dec. 2011 rev 2.3
    improved performance
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION EASTER : DATE
(*
  easter calculates the day of easter sunday for a given year.
  most other catholic holidays are calculated in reference to easter sunday.

  version 1.3 7. apr. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    year : INT;
  END_VAR
  VAR
    b,c: INT;
    oday: INT;
  END_VAR

  b := (204 - 11 * (YEAR MOD 19)) MOD 30;
  IF b > 27 THEN b := b - 1; END_IF;
  c := (year + WORD_TO_INT(SHR(INT_TO_WORD(year),2)) + b - 13) MOD 7;
  oday := 28 + b - c;
  IF oday > 33 THEN
    EASTER := SET_DATE(year, 4, oday - 31);
  ELSE
    EASTER := SET_DATE(year, 3, oday);
  END_IF;

(* alternativer algorithmus ueber das pasah fest
  execution time roughly 200us
  Der sog. Passah-Vollmond wird berechnet, in dem das Jahr durch 19 ge-
  teilt wird und der Rest mit der folgenden Tabelle verglichen wird:

      0: Apr 14       5: Apr 18      10: Mrz 25      15: Mrz 30
      1: Apr 03       6: Apr 08      11: Apr 13      16: Apr 17
      2: Mrz 23       7: Mrz 28      12: Apr 02      17: Apr 07
      3: Apr 11       8: Apr 16      13: Mrz 22      18: Mrz 27
      4: Mrz 31       9: Apr 05      14: Apr 10

  Faellt dieses Datum auf einen Sonntag, ist Ostern der naechste Sonntag!

  Beispiel: 1992 MOD 19 = 16, daraus folgt 17.04., der naechste Sonntag
            ist dann der 19. April (Ostersonntag)
*)
(* this algorithm is 180 us
  a := year MOD 19;
  b := year / 100;
  c := year MOD 100;
  d := b / 4;
  e := b MOD 4;
  f := (b + 8) / 25;
  g := (b - f + 1) / 3;
  h := (19 * a + b - d -g + 15) MOD 30;
  i := C / 4;
  k := c MOD 4;
  l := (32 + 2*e + 2*i - h - k) MOD 7;
  m := (a + 11 * h + 22 * l) / 451;
  x := h + l - 7 * m + 114;
  n := X / 31;
  o := x MOD 31 + 1;

  easter := set_Date(year,n,o);
*)
(*
Im Magazin "Nature" vom 20. April 1876 veröffentlichte ein anonymer Autor eine Tabelle mit Regeln zur Berechnung des (Gregorianischen) Ostersonntages des Jahres J. In Formeln ausgedrückt erhält man das Folgende:
  a = J mod 19
  b = int(J / 100)
  c = J mod 100
  d = int(b / 4)
  e = b mod 4
  f = int((b + 8) / 25)
  g = int((b - f + 1) / 3
  h = (19 · a + b - d - g + 15) mod 30
  i = int(c / 4)
  k = c mod 4
  l = (32 + 2 · e + 2 · i - h - k) mod 7
  m = int((a + 11 · h + 22 · l) / 451)
  n = int((h + l - 7 · m + 114) / 31)
  o = (h + l - 7 · m + 114) mod 31

  n ist hierbei die Nummer des Monats, o + 1 die Nummer des Tages auf welchen der Ostersonntag im Jahr J fällt. Dieser Algorithmus kommt ohne Hilfszahlen aus.
*)
(* revision history
  hm  27. dec 2006  rev 1.0
    original version

  hm  15. dec 2007  rev 1.1
    modified code for better performance

  hm  3. feb 2008   rev 1.2
    modified code for better performance

  hm  7. apr. 2008  rev 1.3
    improved performance
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION DAY_OF_WEEK1 : INT
(*
  calculates the weekday of a week according to ISO8601
  monday = 1 ..... sunday = 7

  version 1.4 7. oct. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    IDATE : DATE;
  END_VAR

  //DAY_OF_WEEK1 := DWORD_TO_INT((DATE_TO_DWORD(idate) / 86400 + 3) MOD 7) + 1;
  DAY_OF_WEEK1 := UDINT_TO_INT( MOD ( DATE_TO_UDINT(idate) / 86400 + 3, 7)) + 1;

(* revision history
  hm  21.8.06     rev 1.1
    corrected a miscalculation

  hm  23.12.2007    rev 1.2
    correction for step7

  hm  7. apr. 2008  rev 1.3
    deleted unused step7 code

  hm  7. oct. 2008  rev 1.4
    changed name of function from weekday to day_of_week
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION DAY_OF_MONTH1 : INT
(*
  returns the day OF month for any DATE

  version 2.1 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IDATE : DATE;
  END_VAR
  VAR
    leap: INT;
  END_VAR

  (* calculate the day in the year *)
  DAY_OF_MONTH1 := DAY_OF_YEAR1(idate);
  (* leap will be set to one for a leap year *)
  leap := BOOL_TO_INT(LEAP_OF_DATE(idate));
  (* if leap year deduct one from the days of the year *)
  DAY_OF_MONTH1 := DAY_OF_MONTH1 - leap;
  (* search if we are in month december to march ? *)
  IF DAY_OF_MONTH1 > setup.MTH_OFS[9] THEN
  	IF DAY_OF_MONTH1 > setup.MTH_OFS[11] THEN
  		IF DAY_OF_MONTH1 > setup.mth_ofs[12] THEN
  			DAY_OF_MONTH1 := DAY_OF_MONTH1 - setup.MTH_OFS[12];
  		ELSE
  			DAY_OF_MONTH1 := DAY_OF_MONTH1 - setup.MTH_OFS[11];
  		END_IF;
  	ELSE
  		IF DAY_OF_MONTH1 > setup.mth_ofs[10] THEN
  			DAY_OF_MONTH1 := DAY_OF_MONTH1 - setup.MTH_OFS[10];
  		ELSE
  			DAY_OF_MONTH1 := DAY_OF_MONTH1 - setup.MTH_OFS[9];
  		END_IF;
  	END_IF;
  ELSIF DAY_OF_MONTH1 > setup.MTH_OFS[5] THEN
  	IF DAY_OF_MONTH1 > setup.MTH_OFS[7] THEN
  		IF DAY_OF_MONTH1 > setup.mth_ofs[8] THEN
  			DAY_OF_MONTH1 := DAY_OF_MONTH1 - setup.MTH_OFS[8];
  		ELSE
  			DAY_OF_MONTH1 := DAY_OF_MONTH1 - setup.MTH_OFS[7];
  		END_IF;
  	ELSE
  		IF DAY_OF_MONTH1 > setup.mth_ofs[6] THEN
  			DAY_OF_MONTH1 := DAY_OF_MONTH1 - setup.MTH_OFS[6];
  		ELSE
  			DAY_OF_MONTH1 := DAY_OF_MONTH1 - setup.MTH_OFS[5];
  		END_IF;
  	END_IF;
  ELSIF DAY_OF_MONTH1 > setup.MTH_OFS[3] THEN
  	IF DAY_OF_MONTH1 > setup.MTH_OFS[4] THEN
  		DAY_OF_MONTH1 := DAY_OF_MONTH1 - setup.MTH_OFS[4];
  	ELSE
  		DAY_OF_MONTH1 := DAY_OF_MONTH1 - setup.MTH_OFS[3];
  	END_IF;
  ELSE
  	(* since now we must be in february or january we need to add leap again *)
  	DAY_OF_MONTH1 := DAY_OF_MONTH1 + leap;
  	IF DAY_OF_MONTH1 > setup.MTH_OFS[2] THEN DAY_OF_MONTH1 := DAY_OF_MONTH1 - setup.mth_ofs[2]; END_IF;
  	(* since nothing was true before, day_of_month must already be good *)
  END_IF;

(*
Revision history
  hm 22.1.2007    rev 1.1
    deleted unused variable day_in_year and day_in_year_begin

  hm  1. okt 2007 rev 1.2
    changed code to use day_of_year and leap_of_date
    added compatibility to STEP7

  hm  8. oct 2007 rev 1.3
    deleted unused variable yr

  hm  8. jan 2008 rev 1.4
    improved performance

  hm  25. oct. 2008 rev 2.0
    new code using setup constants

  hm  10. mar. 2009 rev 2.1
    removed nested comments
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION DATE_ADD : DATE
(*
  date_add adds days, weeks, month or years to a date.
  negative inputs are allowed for subtraction.

  version 1.8   22. mar. 2011
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    IDATE : DATE;
    D : INT;
    W : INT;
    M : INT;
    Y : INT;
  END_VAR
  VAR
    mo: INT;
    yr : INT;
    dm: INT;
  END_VAR
  VAR_TEMP
    tmp : DATE;
  END_VAR

  tmp := UDINT_TO_DATE(DATE_TO_UDINT(IDATE) + INT_TO_UDINT(D + W * 7) * UDINT#86400);
  yr := Y + YEAR_OF_DATE1(tmp);
  mo := M + MONTH_OF_DATE1(tmp);
  dm := DAY_OF_MONTH1(tmp);
  WHILE mo > 12 DO
    mo := mo - 12;
    yr := yr + 1;
  END_WHILE;
  WHILE mo < 1 DO
    mo := mo + 12;
    yr := yr - 1;
  END_WHILE;
  DATE_ADD := SET_DATE(yr, mo, dm);

(* revision history
  hm 27.12.2006 rev 1.0
    nrw module

  hm 12.4.2007    rev 1.1
    corrected an error while date would be incorrect when year  = 0

  hm  1.11.2007   rev 1.2
    added int_to_dword stetements to avoid possible overrun with möller ecp4

  hm  22. mar. 2008 rev 1.3
    fixed some bugs when month was negative

  hm  7. oct. 2008  rev 1.4
    changed function year to year_of_date
    changed function month to month_of_date

  hm  29. mar. 2009 rev 1.5
    improved performance

  hm  27. jan. 2011 rev 1.6
    faster code

  hm  2. feb. 2011    rev 1.7
    fixed an error, weeks not calculated

  hm  22. mar. 2011 rev 1.8
    fixed an error in formula
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION_BLOCK HOLIDAY
(*
  holiday calculates if a given day is a holiday and displays the name of the holiday as string as well as a boolean flag to indicate a holiday.
  the holidays are specified in the country setup under global constants.
  a holiday can be of fixed date for example new years day on january 1st.
  a holiday can have a fixed offset from easter sunday as for most church holidays.
  a holiday can be a specific weekday before a fixed date, for example buss und bettag is the last wednesday before nov 23rd.
  with a simple f_use flag any specific holiday can be turned on or off if needed.

  please check the manual for examples of holiday definitions
  version 2.0 18. jans 2011
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    DATE_IN : DATE;
    LANGU : INT;
    FRIDAY : BOOL;
    SATURDAY : BOOL;
    SUNDAY : BOOL;
  END_VAR
  VAR_IN_OUT
    HOLIDAYS : OSCAT_BASIC_ARRAY0_29_OF_HOLIDAY_DATA;  //ARRAY[0..29] OF HOLIDAY_DATA;
  END_VAR
  VAR CONSTANT
    SIZE : INT := 29;
  END_VAR
  VAR_OUTPUT
    Y : BOOL;
    NAME : STRING[30];
  END_VAR
  VAR
    last_active : DATE;
    ostern: DATE;
    i: INT;
    jahr: INT;
    x_date: DATE;
    lx: INT;
    wdx: INT;
  END_VAR

  (* for performance reasons only activate once a day *)
  IF last_active = date_in THEN RETURN; END_IF;
  last_active := DATE_IN;

  (* determine language *)
  IF LANGU = 0 THEN
    lx := language.DEFAULT;
  ELSE
    lx := MIN(language.LMAX, LANGU);
  END_IF;

  (* berechnung von ostern für das aktuelle jahr *)
  jahr := YEAR_OF_DATE1(date_in);
  ostern := EASTER(jahr);
  wdx := DAY_OF_WEEK1(DATE_IN);
  Y := FALSE;

  (* check for holidays *)
  FOR i := 0 TO size DO
    x_date := SET_DATE( jahr, SINT_TO_INT( HOLIDAYS[i].MONTH), SINT_TO_INT( HOLIDAYS[i].DAY));
    IF HOLIDAYS[i].USE = 1 AND HOLIDAYS[i].MONTH > 0 THEN
      (* check for fixed date holiday *)
      IF x_date = date_in THEN
        Y := TRUE;
        NAME := HOLIDAYS[i].NAME;
        RETURN;
      END_IF;
    ELSIF HOLIDAYS[i].USE = 1 AND HOLIDAYS[i].MONTH = 0 THEN
      (* check for holiday in reference to easter *)
      IF DATE_ADD( ostern, SINT_TO_INT( HOLIDAYS[i].DAY),0,0,0) = date_in THEN
        Y := TRUE;
        NAME := HOLIDAYS[i].NAME;
        RETURN;
      END_IF;
    ELSIF HOLIDAYS[i].USE < 0 THEN
      (* check for holiday on a weekday before date *)
      IF INT_TO_BYTE(DAY_OF_WEEK1(date_in)) = SINT_TO_BYTE(ABS( HOLIDAYS[i].USE)) AND BOOL_TO_BYTE(date_in < x_date) AND BOOL_TO_BYTE(date_in >= DATE_ADD(x_date,-7,0,0,0)) THEN
        Y := TRUE;
        NAME := HOLIDAYS[i].NAME;
        RETURN;
      END_IF;
    END_IF;
  END_FOR;

  (* check array if today is weekend *)
  IF NOT Y AND (wdx = 5 AND FRIDAY OR wdx = 6 AND SATURDAY OR wdx = 7 AND SUNDAY) THEN
    Y := TRUE;
    NAME := LANGUAGE.WEEKDAYS[LOCATION.LANGUAGE[lx],wdx];
  ELSE
    NAME := '';
  END_IF;

(*
  Neujahrstag   1. Januar   •   •   •   •   •   •   •   •   •   •   •   •   •   •   •   •
  Heilige Drei Könige   6. Januar   •   •                         •
  Karfreitag  Ostersonntag - 2d   •   •   •   •   •   •   •   •   •   •   •   •   •   •   •   •
  Ostersonntag  siehe Osterdatum        (•)
  Ostermontag   Ostersonntag + 1d   •   •   •   •   •   •   •   •   •   •   •   •   •   •   •   •
  Tag der Arbeit  1. Mai  •   •   •   •   •   •   •   •   •   •   •   •   •   •   •   •
  Christi Himmelfahrt   Ostersonntag + 39d  •   •   •   •   •   •   •   •   •   •   •   •   •   •   •   •
  Pfingstsonntag  Ostersonntag + 49d        (•)
  Pfingstmontag   Ostersonntag + 50d  •   •   •   •   •   •   •   •   •   •   •   •   •   •   •   •
  Fronleichnam  Ostersonntag + 60d  •   •           •       •   •   •   1)      2)
  Augsburger Friedensfest   8. August     (3)
  Mariä Himmelfahrt   15. August    (5)                     •
  Tag der Deutschen Einheit   3. Oktober 6)   •   •   •   •   •   •   •   •   •   •   •   •   •   •   •   •
  Reformationstag   31. Oktober         •         •           •   •     •
  Allerheiligen   1. November   •   •                 •   •   •
  Buß- und Bettag 4)  Mittwoch vor dem 23.11.       7                     •
  1. Weihnachtstag  25. Dezember  •   •   •   •   •   •   •   •   •   •   •   •   •   •   •   •
  2. Weihnachtstag  26. Dezember  •   •   •   •   •   •   •   •   •   •   •   •   •   •   •   •
*)
(* revision history
  hm  27. feb. 2007 rev 1.1
    deleted unused variable init

  hm  31. oct. 2007 rev 1.2
    changed holiday definition from constant to input constant to allow easier changes by user without recompilation of the lib

  hm  24. nov. 2007 rev 1.3
    changes F_use of  Buß_und_Bettag to 0 because this is no official holiday

  hm  7. apr. 2008  rev 1.4
    improved performance

  hm  7. oct. 2008  rev 1.5
    changed code to use setup data from global constants
    changed length of output NAME from 20 to 30
    holiday will now also be indicated on a weekend
    changed function year to year_of_date
    changed function weekday to day_of_week

  hm  21. oct. 2008 rev 1.6
    using location constants

  hm  18. jan 2011  rev 2.0
    using user specified array for holidays
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Time&Date' *)
FUNCTION HOUR_TO_TOD : TOD
(*
  converts an amount of hours in real to time of day TOD.

  version 1.2 24. feb 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IN : REAL;
  END_VAR

  HOUR_TO_TOD := UDINT_TO_TOD(REAL_TO_UDINT(IN * 3600000.));


(* revision history
  hm  4. aug. 2006  rev 1.0
    original version

  hm  14. mar. 2008 rev 1.1
    rounded the input after the last digit

  hm  24. feb. 2009 rev 1.2
    changed input to IN
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION SUN_MIDDAY : TOD
(*
  this FUNCTION calculates the time when the sun stand exactly south of a given location.

  version 1.0 26. jan. 2011
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    LON : REAL;
    UTC : DATE;
  END_VAR
  VAR
    T : REAL;
    OFFSET : REAL;
  END_VAR

  T := INT_TO_REAL(DAY_OF_YEAR1(utc));
  OFFSET := -0.1752 * SIN(0.033430 * T + 0.5474) - 0.1340 * SIN(0.018234 * T - 0.1939);
  SUN_MIDDAY := HOUR_TO_TOD(12.0 - OFFSET - lon * 0.0666666666666);

(* revision history
  hm  26. jan. 2011 rev 1.0
    initial release
*)
END_FUNCTION


(* @PATH := '\/Mathematical' *)
FUNCTION DEG : REAL
(*
  this function converts degrees into Radiant
  execution time on wago 750 - 841 =  10  us

  version 1.2 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    rad : REAL;
  END_VAR

  DEG := MODR(57.29577951308232 * RAD, 360.0);

(* revision history
  hm  4. aug 2006 rev 1.0
    original version

  hm 16. oct 2007 rev 1.1
    added modr statement which prohibits deg to become bigger than 360

  hm  10. mar. 2009 rev 1.2
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION HOUR_TO_TIME : TIME
(*
  converts an amount of hours in real to time

  version 1.2 24. feb. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IN : REAL;
  END_VAR

  HOUR_TO_TIME := UDINT_TO_TIME(REAL_TO_UDINT(IN * 3600000.));

(* revision history
  hm    4. aug 2006 rev 1.0
    original version

  hm  14. mar. 2008 rev 1.1
    rounded the input after the last digit

  hm  24. feb. 2009 rev 1.2
    changed input to IN
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION_BLOCK SUN_TIME
(*
  this FUNCTION block calculates the sun rise, sun set, sun offset at midday sun declination for a given date
  for performance reasons the algorithm has been simplified and is accurate within a few minutes only
  the times are calculated in utc and have to be corrected for the given time zone
  this correction is not done within sun_time because it would be a problem on days where dst is enabled or disabled

  version 1.7 25. jan. 2011
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    LATITUDE : REAL;        (* latitude of geographical position  *)
    LONGITUDE : REAL;       (* longitude of geographical position  *)
    UTC : DATE;           (*  world time  *)
    H : REAL := -0.83333333333; (* heighth above horizon for sunrise *)
  END_VAR
  VAR_OUTPUT
    MIDDAY : TOD;     (*  astrological midday in hours when sun stands at south direction *)
    SUN_RISE : TOD;       (*  sun rise for current day in local time *)
    SUN_SET : TOD;        (*  sun set for current day in local time *)
    SUN_DECLINATION : REAL;   (*  sun declination above horizon at midday in degrees  *)
  END_VAR
  VAR
    dk: REAL;           (* sun declination at midday *)
    delta: TIME;          (* delta from midday for sunrise and sunset  *)
    b: REAL;
  END_VAR

  B := latitude * 0.0174532925199433;
  MIDDAY := SUN_MIDDAY(longitude, utc);
  DK := 0.40954 * SIN(0.0172 * (INT_TO_REAL(DAY_OF_YEAR1(utc)) - 79.35));
  sun_declination := DEG(DK);
  IF sun_declination > 180.0 THEN sun_declination := sun_declination - 360.0; END_IF;
  sun_declination := 90.0 - LATITUDE + sun_declination;
  delta := HOUR_TO_TIME(ACOS((SIN(RAD(H)) - SIN(B) * SIN(DK)) / (COS(B) * COS(DK))) * 3.819718632);
  sun_rise := MIDDAY - delta;
  sun_set := MIDDAY + delta;

(* revision history
  rev 1.1 hm  20.1.2007
    deleted unused variables sun_riseR and sun_setR

  rev 1.2 hm 17.4.2007
    corrected error while sun:midday would not be corrected for longitude.

  rev 1.3 hm  6. jan 2008
    performance improvements

  rev 1.4 hm  17. jan 2008
    calculation is now only performed once a day

  hm  10. mar. 2009 rev 1.5
    improved performance
    calculation will be performed on every call to allow movong installations

  hm  26. jul 2009  rev 1.6
    fixed a problem with wrong midday calculation

  hm  25. jan. 2011 rev 1.7
    using function sun_midday
    corrected angle of sun_declination
    added input H
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Time&Date' *)
FUNCTION REFRACTION : REAL
(*
  REFRACTION calculates the atmospheric refraction in degrees.
  the input angle goes from 0 at the hirizon to 90 at midday.

  version 1.1 7. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    ELEV : REAL;
  END_VAR

  elev := LIMIT(-1.9, elev, 80.0);
  REFRACTION := 0.0174532925199433 / TAN(0.0174532925199433 * (ELEV + 10.3 / (ELEV + 5.11)));

(* revision histroy
  hm  14. jul. 2008 rev 1.0
    original release

  hm  7. mar. 2009  rev 1.1
    using new formula
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION_BLOCK SUN_POS
(*
  this FUNCTION block calculates the sun position for a given date and time.
  the times are calculated in utc and have to be corrected for the given time zone.
  B is the angle from north and HR is the highth in degrees.

  version 2.1 7. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    latitude : REAL;        (* latitude of geographical position  *)
    longitude : REAL;       (* longitude of geographical position  *)
    utc : DT;           (*  world time        *)
  END_VAR
  VAR_OUTPUT
    B: REAL;
    H : REAL;
    HR: REAL;
  END_VAR
  VAR_TEMP
    g: REAL;
    a: REAL;
    d: REAL;
    t1: REAL;
    n: REAL;
    e: REAL;
    c: REAL;
    tau: REAL;
    sin_d: REAL;
    rlat: REAL;
    sin_lat: REAL;
    cos_lat: REAL;
    cos_tau: REAL;
    cos_d: REAL;
  END_VAR

  (* n is the julian date and the number of days since 1.1.2000-12:00 midday *)
  (* be careful for step7 date startes 1.1.1990 instead of 1.1.1970 *)
  (* for step7 this line must change *)
  n := UDINT_TO_REAL(DT_TO_UDINT(UTC) - 946728000) * 0.000011574074074074;
  g :=MODR(6.240040768 + 0.01720197 * n, math.PI2);
  d := MODR(4.89495042 + 0.017202792 * n, math.PI2) + 0.033423055 * SIN(g) + 0.000349066 * SIN(2.0*g);
  e := 0.409087723 - 0.000000006981317008 * n;
  cos_d := COS(d);
  sin_d := SIN(d);
  a := ATAN(COS(e) * sin_d / cos_d);
  IF cos_d < 0.0 THEN a := a + math.PI; END_IF;
  c := ASIN(SIN(e) * sin_d);

  (* also here we must be very careful utc is from 1.1.1970 for step7 the formula must change *)
  tau := RAD(MODR(6.697376 + (n - 0.25) * 0.0657098245037645 + DWORD_TO_REAL(TOD_TO_DWORD(DT_TO_TOD(utc))) * 0.0000002785383333, 24.0) * 15.0 + longitude) - a;
  rlat := RAD(latitude);
  sin_lat := SIN(rlat);
  cos_lat := COS(rlat);
  cos_tau := COS(tau);
  t1 := cos_tau * sin_lat - TAN(c) * cos_lat;
  B := ATAN(SIN(tau) / t1);
  IF t1< 0.0 THEN B := B + math.PI2; ELSE B := B + math.PI; END_IF;
  B := DEG(MODR(B, math.PI2));
  h := DEG(ASIN(COS(C) * cos_tau * cos_lat +SIN(c) * sin_lat));
  IF h > 180.0 THEN h := h - 360.0; END_IF;
  (* consider refraction *)
  HR := h + REFRACTION(h);

(* revision history
  hm  1. feb 2007 rev 1.0
    original version

  hm  6. jan 2008 rev 1.1
    performance improvements

  hm  18. jan 2008  rev 1.2
    further performance improvements
    only calculate once every 10 seconds

  hm  16. mar. 2008 rev 1.3
    added type conversion to avoid warnings under codesys 3.0

  hm  30. jun. 2008 rev 1.4
    added type conversions to avoid warnings under codesys 3.0

  hm  18. oct. 2008 rev 1.5
    using math constants

  hm  17. dec. 2008 rev 1.6
    angles below horizon are displayed in negative degrees

  hm  27. feb. 2009 rev 2.0
    new code with better accuracy

  hm  7. mar. 2009  rev 2.1
    refraction is added after angle normalization
    deleted 10 second lockout
    added output for astronomical heigth h
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Time&Date' *)
FUNCTION SET_DT : DT
(*
  creates a date output from year, month and day of month
  year must be in the form of 4 digits ie 2006 or 1977.

  version 1.5 16 mar 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    year : INT;
    month : INT;
    day : INT;
    hour : INT;
    minute : INT;
    second : INT;
  END_VAR

  SET_DT := UDINT_TO_DT(DATE_TO_UDINT( SET_DATE(YEAR, MONTH, day)) + INT_TO_UDINT(SECOND) + INT_TO_UDINT(MINUTE) * 60 + INT_TO_UDINT(HOUR) * 3600);

(* revision history
  hm  4. aug. 2006    rev 1.0
    original version

  hm    19 sep. 2007  rev 1.1
    use function leap_year to calculate leap year, more exceptions are handled

  hm    1. okt 2007   rev 1.2
    added step7 compatibility
    call function set_date

  hm    8. oct 2007   rev 1.3
    deleted unused variables count and leap

  hm    1. 11 2007    rev 1.4
    converted hour type integer to dword in calculation to avoid overrun on möller ecp4

  hm    16. mar 2008  rev 1.5
    added type conversions to avoid warnings under codesys 3.0
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION DST : BOOL
(*
  this functions returns TRUE IF dst TIME is active
  the FUNCTION calculates automatically for any year betweek 1970 AND 2099
  wheather daylight savings is on OR off
  the summertime calculation is done according to european standards.
  dst will become TRUE AT 01:00 utc in the morning FOR the respective days
  AND it will become FALSE after daylight savings TIME is switched back end OF october at 01:00 utc

  version 1.5 24. jan. 2011
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    UTC : DT;
  END_VAR
  VAR
    yr : INT;
    yr4 : UDINT; //DWORD;
    ltc:  UDINT; //DWORD;
    idate : UDINT; //DWORD;
  END_VAR

  yr := YEAR_OF_DATE1(DT_TO_DATE(UTC));
  ltc := DT_TO_UDINT(UTC);
  idate := DT_TO_UDINT(SET_DT(yr, 3, 31, 1, 0, 0));
  yr4 :=  DWORD_TO_UDINT( SHR( UDINT_TO_DWORD(5 * INT_TO_UDINT(yr)), 2)) + 1;
  DST := (idate - ((yr4 + 3) MOD 7) * 86400 <= ltc) AND (idate + (214 - (yr4) MOD 7) * 86400 > ltc);

(*
  Equation used TO calculate the beginning OF European Summer TIME:
  Sunday (31 - (5*y/4 + 4) mod 7) March at 01.00 UTC
  (valid through 2099, courtesy of Robert H. van Gent, EC).

  European Summer Time ends (clocks go back) at 01.00 UTC on

      * 29 October 2006
      * 28 October 2007
      * 26 October 2008

  Equation used to calculate the end of European Summer Time:
  Sunday (31 - (5*y/4 + 1) mod 7) October at 01.00 UTC
  (validity AND credits as above).
*)
(* revision history
  hm  4. aug 2006 rev 1.0
    original version

  hm  24. okt 2007  rev 1.1
    deleted time_zone_offset input because dst is generally at 01:00 utc and not mesz
    uk starts 01:00 utc and also greece

  hm  1. dec 2007 rev 1.2
    changed code to improve performance

  hm  16. mar. 2008 rev 1.3
    added type conversion to avoid warnings under codesys 3.0
    code improvement for better performance

  hm  7. oct. 2008  rev 1.4
    changed name of function year to year_of_date

  hm  24. jan. 2011 rev 1.5
    improved performance
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION UTC_TO_LTIME : DT
(*
  ltime is a real time clock that uses the system rtc as utc time and calculates and given time zone.
  the utc time is supplied on the input UTC.
  according to the input variable time_zone_offset when the input dst_enable is true,
  the dst on and off times are calculated by a formula for any given year and the time is advanced and reset by one hour
  at 02:00 and 03:00 for the last sunday of march and last sunday of october.
  the code is high performance and the rtc counts every second.
  if more then one time zone is needed by the systen the clock can be started many times by placing more then one function block.

  version 1.9 27. feb. 2009
  programmer  oscat
  tested by   oscat
*)
  VAR_INPUT
    UTC : DT;
    DST_ENABLE : BOOL;
    TIME_ZONE_OFFSET : INT;
  END_VAR
  VAR
    tmp: INT;
  END_VAR

  tmp := TIME_ZONE_OFFSET * 60 + BOOL_TO_INT(DST_ENABLE AND DST(UTC)) * 3600;
  IF tmp < 0 THEN
    tmp := ABS(tmp);
    UTC_TO_LTIME := UDINT_TO_DT(DT_TO_UDINT(UTC) -  INT_TO_UDINT(tmp));
  ELSE
    UTC_TO_LTIME := UDINT_TO_DT(DT_TO_UDINT(UTC) +  INT_TO_UDINT(tmp));
  END_IF;

(* revision history
  hm 2.10.2006  rev 1.1
    corrected an error where dst would be delayed by 0.1second

  hm 17.1.2007  rev 1.2
    added utc input instead of internal sysrtcgettime because this would only work on wago.
    dst_enable would not be checked before dst would be enabled.

  hm 18.3.2007  rev 1.3
    changed code, dst would not work during first cycle.

  hm 24.10.2007 rev 1.4
    changed code because the execution every 100ms can cause major problems if the supplied time was not correct at start.
    use of new dst function

  hm 12. nov 2007 rev 1.5
      changed Type of time_zone_offset from time to int to allow for time zones with negative offset

  hm  8 dec 2007    rev 1.6
    corrected a problem with time_zone_offset

  hm  14. oct. 2008 rev 1.7
    renamed module from LTIME to UTC_TO_LTIME
    changed function weekday to day_of_week
    optimized code for better performance

  hm  20. oct. 2008 rev 1.8
    changes type of input TIME_ZONE_OFFSET from real to int, now is in +/-minutes
    deleted outputs DST_ON and WDAY
    converted to function

  hm  27. feb. 2009 rev 1.9
    added type conversions to avoid warnings under codesys 3.0
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION DAY_OF_DATE1 : DINT
(*
  DAY_OF_DATE1 returns the days since 1.1.1970

  version 1.3 7. apr. 2008
  programmer  oscat
  tested by oscat
*)
  VAR_INPUT
    idate : DATE;
  END_VAR

  DAY_OF_DATE1 := UDINT_TO_DINT(DATE_TO_UDINT(idate) / 86400);

(* revision history
  hm    16.9.2007   rev 1.0
    original version

  hm    1. okt 2007   rev 1.1
    added step7 compatibility

  hm    22. mar. 2008 rev 1.2
    changed output from int to Dint because the total date range is 49710 days

  hm    7. apr. 2008  rev 1.3
    deleted unused step7 code
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION HOUR : INT
(*
  extracts the hour of a Time_of_day

  version 1.1 2 okt 2006
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    itod : TOD;
  END_VAR

  HOUR := UDINT_TO_INT(TOD_TO_UDINT(itod) / 3600000);

(* change history
  hm 4. aug 2006  rev 1.0
    original version

  hm 2.10.2006  rev 1.1
    changed name of input to itod
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION YEAR_BEGIN : DATE
(*
  returs the date of january 1st for the given year
  the function works for dates from 1970 - 2099

  version 1.2 7. Apr. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    y : INT;
  END_VAR

  YEAR_BEGIN := UDINT_TO_DATE(DWORD_TO_UDINT(SHR( UDINT_TO_DWORD(INT_TO_UDINT(y) * 1461 - 2878169),2)) * 86400);

(* revision history
  hm  19. dec 2007  rev 1.0
    original version

  hm  4. jan 2008   rev 1.1
    formula for step7 was incorrect during leap years

  hm  7. apr. 2008  rev 1.2
    deleted unused step7 code
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION LEAP_YEAR : BOOL
(*
  leap_year is true if the tested year is a leap year

  version 1.1 2. oct. 2006
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    yr : INT;
  END_VAR

  LEAP_YEAR := SHL(INT_TO_WORD(yr),14) = 0;

(* this code was used prior to rev 1.1
  IF yr MOD 400 = 0 THEN leap_year := TRUE;
  ELSIF yr MOD 100 = 0 THEN leap_year := FALSE;
  ELSIF yr MOD 4 =0 THEN leap_year := TRUE;
  ELSE leap_year := FALSE;
  END_IF;
*)
(* change history
  hm  2.10.2006   rev 1.1
    the function now works for any year from 1970 up to 2100

  hm  1. oct 2007   rev 1.2
    chaged code for higher performance
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION WORK_WEEK : INT
(*
  calculates the work week for a given date according to iso8601

  version 1.5 25. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    idate : DATE;
  END_VAR
  VAR
    d1 : DATE;
    w1 : INT;
    ds: UDINT; //DWORD;
    yr: INT;
    w31: INT;
    w01: INT;
    wm: INT;
  END_VAR

  (* berechne den 1.1 des jahres von idate. *)
  yr := YEAR_OF_DATE1(idate);
  d1 := YEAR_BEGIN(yr);
  (* wochentag von d1 *)
  w1 := DAY_OF_WEEK1(d1);
  (* offset des montags der eletzten KW des vorjahres *)
  (* wenn der erste tag des jahres größer als donnerstag ist dann beginnt die letzte kw am montag davor *)
  (* wenn der erste tag des jahres ein donnerstag oder kleiner ist beginnt die erste kw 2 montage davor *)
  IF w1 < 5 THEN
    ds := DATE_TO_UDINT(d1) - INT_TO_UDINT(w1+6) * 86400;
  ELSE
    ds := DATE_TO_UDINT(d1) - INT_TO_UDINT(w1-1) * 86400;
  END_IF;

  (* kalenderwoche des eingangsdatums *)
  WORK_WEEK := UDINT_TO_INT((DATE_TO_UDINT(idate) - ds) / 604800);

  (* korrektur wenn work_week = 0 *)
  IF work_week = 0 THEN
  	(* work_week needs to be 53 when 1.jan of the year before is thursday or dec 31. is thursday. *)
  	(* first and last weekday of a year is equal and one more day for a leap_year. *)
  	IF w1 > 1 THEN w31 := w1 - 1; ELSE W31 := 7; END_IF;
  	IF LEAP_YEAR(yr - 1) AND w31 > 1 THEN w01 := W31 - 1; ELSE w1 := 7; END_IF;
  	(* if first or last day of a year is a thursday, the year has 53 weeks *)
  	WORK_WEEK := 52 + BOOL_TO_INT(w31 = 4 OR w01 = 4);
  ELSE
  	(* end of year calculation *)
  	(* calculated the first and last weekday *)
  	IF leap_year(yr) THEN
  		IF w1 < 7 THEN w31 := w1 + 1; ELSE w31 := 1; END_IF;
  	ELSE
  		w31 := w1;
  	END_IF;
  	(* if first or last day is thursday then the year has 53 weeks otherwise only 52 *)
  	wm := 52 + BOOL_TO_INT(w31 = 4 OR w1 = 4);
  	IF WORK_WEEK > wm THEN WORK_WEEK := 1; END_IF;
  END_IF;

(* revision history
  hm  17.1.2007   rev 1.1
    deleted unused variable yday

  hm  19. dec 2007  rev 1.2
    changed code for better performance
    changed code to comply with ISO8601

  hm  16. mar 2008  rev 1.3
    added type conversions to avoid warnings under codesys 3.0

  hm  7. oct. 2008  rev 1.4
    changed function year to year_of_date
    changed function weekday to day_of_week

  hm  25. oct. 2008 rev 1.5
    optimized code for performance
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION_BLOCK CALENDAR_CALC
(*
  calendar_calc liest die weltzeit .UTC aus einer CALENDAR Struktur und berechnet die restlichen Werte der Struktur.
  calendar_calc stellt sicher das die Werte fortlaufend aktualisiert werden und dabei funktionen nur dann aufgerufen werden wenn dies nötig ist.
  calendar_calc will calculate sun position data when SPE = TRUE;

  version 1.6 6. apr. 2011
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    SPE : BOOL;
    H : REAL := -0.83333333333;
  END_VAR
  VAR_IN_OUT
    XCAL : CALENDAR;
    HOLIDAYS : OSCAT_BASIC_ARRAY0_29_OF_HOLIDAY_DATA;  //ARRAY[0..29] OF HOLIDAY_DATA;
  END_VAR
  VAR
    last : DT;
    last_day : DINT;
    holy : HOLIDAY;
    sun : SUN_TIME;
    last_hour: INT;
    utod: TOD;
    pos : SUN_POS;
    plast: DT;
  END_VAR
  VAR_TEMP
    dtemp : DINT;
    tmp : INT;
  END_VAR

  IF xcal.UTC <> last THEN
    (* run once per second *)
    (* update utc last calculated  *)
    last := XCAL.UTC;
    utod := DT_TO_TOD(xcal.UTC);

    (* calculate ltc from utc *)
    XCAL.LDT := UTC_TO_LTIME(XCAL.UTC, XCAL.DST_EN, XCAL.OFFSET);
    XCAL.LDATE := DT_TO_DATE(XCAL.LDT);
    XCAL.LTOD := DT_TO_TOD(XCAL.LDT);
    dtemp := DAY_OF_DATE1(XCAL.LDATE);
    xcal.night := XCAL.LTOD < XCAL.SUN_RISE OR XCAL.LTOD > XCAL.SUN_SET;

    (* run once per hour *)
    tmp := HOUR(xcal.LTOD);
    IF  tmp <> last_hour THEN
      XCAL.DST_ON := DST(XCAL.UTC) AND xcal.DST_EN;
      last_hour := tmp;
    END_IF;

    (* run once per day *)
    IF dtemp <> last_day THEN
      last_day := dtemp;
      (* a new day has started, recalculate daily events *)
      XCAL.YEAR := YEAR_OF_DATE1(XCAL.LDATE);
      XCAL.MONTH := MONTH_OF_DATE1(XCAL.LDATE);
      XCAL.DAY := DAY_OF_MONTH1(XCAL.LDATE);
      XCAL.WEEKDAY := DAY_OF_WEEK1(XCAL.LDATE);
      HOLY(date_in := XCAL.LDATE, LANGU := xcal.LANGUAGE, HOLIDAYS := HOLIDAYS);
      XCAL.HOLIDAY := HOLY.Y;
      XCAL.HOLY_NAME := HOLY.NAME;
      sun(latitude := XCAL.LATITUDE, longitude := xcal.LONGITUDE, utc := DT_TO_DATE(xcal.UTC), H := H);
      XCAL.SUN_RISE := DINT_TO_TOD( TOD_TO_DINT(sun.sun_rise) + INT_TO_DINT(XCAL.OFFSET) * 60000 + SEL(XCAL.DST_ON,DINT#0,3600000));
      XCAL.SUN_SET := DINT_TO_TOD( TOD_TO_DINT(sun.sun_set) + INT_TO_DINT(XCAL.OFFSET) * 60000 + SEL(XCAL.DST_ON,DINT#0,3600000));
      XCAL.SUN_MIDDAY := DINT_TO_TOD( TOD_TO_DINT(sun.MIDDAY) + INT_TO_DINT(XCAL.OFFSET) * 60000 + SEL(XCAL.DST_ON,DINT#0,3600000));
      XCAL.SUN_HEIGTH := sun.sun_declination;
      XCAL.WORK_WEEK := WORK_WEEK(XCAL.LDATE);
    END_IF;

    (* calculate the suns position every 10 seconds when SPE = TRUE *)
  //  IF SPE AND ((xcal.UTC - plast) >= t#25s) THEN
    IF SPE AND (SUB_DT_DT( xcal.UTC, plast) >= t#25s) THEN
      plast := last;
      pos(latitude := xcal.LATITUDE, longitude := xcal.LONGITUDE, utc := xcal.UTC);
      xcal.SUN_HOR := pos.B;
      xcal.SUN_VER := pos.HR;
    END_IF;
  END_IF;

(* revision history
  hm 23. oct. 2008  rev 1.0
    original version

  hm  8. feb. 2009  rev 1.1
    night was calculated wrong
    added sun position data

  hm  10. mar. 2009 rev 1.2
    added work_week, sun_midday, sun_heigth
    sun_position will only be calculated evey 25 seconds
    dst will only become true when dst_en = true

  hm  23. jan 2010  rev 1.3
    sun_rise, sun_set and sun_midday are now calculated in local time

  hm  18. jan. 2011 rev 1.4
    added input holidays to specify local holidays
    changed call for function sun_time

  hm  2. feb. 2011  rev 1.5
    added input H to specify twilight

  hm  6. apr. 2011  rev 1.6
    night was calculated wrong
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Time&Date' *)
FUNCTION DAY_TO_TIME : TIME
(*
  converts an amount of days in real to time
  version 1.1 24. feb. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IN : REAL;
  END_VAR

  DAY_TO_TIME := DWORD_TO_TIME(REAL_TO_DWORD(IN * 86400000.0));

(* revision history
  hm  4. aug. 2006  rev 1.0
    original release

  hm  24. feb. 2009 rev 1.1
    renamed input to IN
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION DAYS_DELTA : DINT
(*
  days_delta calculates the days between two dates. the days are calculated date_2 - date_1.

  version 1.3   25. jan. 2011
  programmer    hugo
  tested by   tobias
*)
  VAR_INPUT
    date_1 : DATE;
    date_2 : DATE;
  END_VAR

  IF DATE_1 > DATE_2 THEN
    DAYS_DELTA := - UDINT_TO_DINT((DATE_TO_UDINT(date_1) - DATE_TO_UDINT(date_2)) / 86400);
  ELSE
    DAYS_DELTA := UDINT_TO_DINT((DATE_TO_UDINT(date_2) - DATE_TO_UDINT(date_1)) / 86400);
  END_IF;

(* revision history
  hm  27. dec 2006  rev 1.0
    original version

  hm  16.9.2007   rev 1.1
    coorected an error in formula and changed algorithm to show positive and negative delta

  hm  22. mar. 2008 rev 1.2
    changed output from int to dint because the total date range is 49710 days

  hm  25. jan. 2011 rev 1.3
    improved performance
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION DAYS_IN_MONTH : INT
(*
  returs the total days of the current month. e.g. 31 for january.
  the function works for dates from 1970 - 2099

  version 1.0 27. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    IDATE : DATE;
  END_VAR

  DAYS_IN_MONTH := DAY_OF_YEAR1(IDATE);
  IF LEAP_OF_DATE(IDATE) THEN
  	CASE DAYS_IN_MONTH OF
  		32..60	:	DAYS_IN_MONTH := 29;
  		92..121 :	DAYS_IN_MONTH := 30;
  		153..182:	DAYS_IN_MONTH := 30;
  		245..274:	DAYS_IN_MONTH := 30;
  		306..335:	DAYS_IN_MONTH := 30;
  	ELSE
  		DAYS_IN_MONTH := 31;
  	END_CASE;
  ELSE
  	CASE DAYS_IN_MONTH OF
  		32..59	:	DAYS_IN_MONTH := 28;
  		91..120 :	DAYS_IN_MONTH := 30;
  		152..181:	DAYS_IN_MONTH := 30;
  		244..273:	DAYS_IN_MONTH := 30;
  		305..334:	DAYS_IN_MONTH := 30;
  	ELSE
  		DAYS_IN_MONTH := 31;
  	END_CASE;
  END_IF;

(* revision history
  hm  27. mar. 2009   rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION DAYS_IN_YEAR : INT
(*
  returs the total days of the year.
  the function retruns 366 for leap years and 365 otherwise.
  the function works for dates from 1970 - 2099

  version 1.0 27. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    IDATE : DATE;
  END_VAR

  IF LEAP_OF_DATE(IDATE) THEN
    DAYS_IN_YEAR := 366;
  ELSE
    DAYS_IN_YEAR := 365;
  END_IF;

(* revision history
  hm  27. mar. 2009   rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION_BLOCK DCF77
(*
  this is a decoder for a DCF77 signal.
  the decoder decodes the DCF77 signal and checks for a valid Date_Time.
  since the dcf77 signal is only secured with a simple parity the decoder waits for two consecutive valid transmissions before it sets the output signals.
  given a valid reception by the receiver the decoder can take up to 3 minutes to start its clocks the first time.
  after a valid signal is detected the error output goes low and dignals a valid dcf signal from the receiver.
  a tp is only valid for one program cycle to allow for external rtc setting.
  after a valid signal is detected two independent internal clocks are started (RTC and RTC1), the seconds  of these clocks are generated by software since the dcf signal is only valid for minutes.
  rtc is always utc ( world time) and rtc1 can be set to any time zone by setting the time_zone_offset and enabling dst for automatic summertime.
  a sync output signals the the rtc and rtc1 are in sync with the dcf77 signal, if the dcf77 signal is lost for more then the sync time the sync output goes low
  but the rtc and rtc1 outputs keep running based on software timing until a valid dcf77 signal is received again and triggers the clock.
  in addition a millisecond output gives further resolutionof the clocks.
  a dst output shows if daylight saving time is enables and the weekday output shows which day of week currently is ( 1= monday ... 7= sunday).

  version 1.10  7. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    REC : BOOL;
    SET : BOOL;
    SDT : DT;
    DSI : BOOL;
  END_VAR
  VAR_INPUT //???CONSTANT
    SYNC_TIMEOUT : TIME := t#2m;
    TIME_OFFSET : INT := 1;
    DST_EN : BOOL := TRUE;
  END_VAR
  VAR_OUTPUT
    TP : BOOL;
    DS : BOOL;
    WDAY : INT;
    ERROR : BOOL := TRUE;
    RTC : DT;
    RTC1 : DT;
    MSEC : INT;
    SYNC : BOOL;
  END_VAR
  VAR
    mez : DT;
    utc : DT;
    state : INT;
    edge: BOOL;
    tx : TIME;
    ty: TIME;
    last : TIME;
    bits : ARRAY[0..58] OF BOOL;
    cnt : INT;
    i : INT;
    old_time : DT;
    minute : INT;
    hour : INT;
    day : INT;
    month : INT;
    year : INT;
    last_sync: TIME;
    t1: TIME;
    tz: TIME;
    init: BOOL;
  END_VAR

  (* if tp was set it should only be active for 1 cycle *)
  TP := FALSE;

  (* read system time *)
  t1 := DWORD_TO_TIME(T_PLC_MS());
  tx := t1 - last;

  IF rec XOR edge THEN
    edge := rec;
    IF NOT rec AND tx > t#1700ms AND tx < t#2000ms THEN
      (* start condition reached *)
      state := 0;
      tp := NOT error;
    ELSIF NOT rec AND tx > t#700ms AND tx < t#1000ms THEN
      (* second switch detected *)
      IF state < 58 THEN state := state +1; ELSE state := 0; END_IF;
    ELSIF rec AND tx  < t#120ms THEN
      (* bit 0 detected  *)
      bits[state] := 0;
    ELSIF rec AND tx > t#120ms AND tx < t#250ms THEN
      (* bit 1 detected *)
      bits[state] := 1;
    ELSE
      (* error condition received signal is not valid *)
      error := TRUE;
      state := 0;
    END_IF;
    last := last + tx;
    IF rec AND state = 58 THEN
      error := FALSE;

      (* decode the bits and check for possible errors *)
      IF bits[0] OR NOT (bits[17] XOR bits[18]) OR NOT bits[20] THEN error := TRUE; END_IF;
      (* decode minute *)
      MINUTE := 0;
      MINUTE.0 := bits[21];
      MINUTE.1 := bits[22];
      MINUTE.2 := bits[23];
      MINUTE.3 := bits[24];
      IF bits[25] THEN MINUTE := MINUTE + 10; END_IF;
      IF bits[26] THEN MINUTE := MINUTE + 20; END_IF;
      IF bits[27] THEN MINUTE := MINUTE + 40; END_IF;
      IF MINUTE > 59 OR (bits[21] XOR bits[22] XOR bits[23] XOR bits[24] XOR bits[25] XOR bits[26] XOR bits[27] XOR bits[28]) THEN error := TRUE; END_IF;

      (* decode hour *)
      HOUR := 0;
      HOUR.0 := bits[29];
      HOUR.1 := bits[30];
      HOUR.2 := bits[31];
      HOUR.3 := bits[32];
      IF bits[33] THEN HOUR := HOUR + 10; END_IF;
      IF bits[34] THEN HOUR := HOUR +20; END_IF;
      IF HOUR > 23 OR (bits[29] XOR bits[30] XOR bits[31] XOR bits[32] XOR bits[33] XOR bits[34] XOR bits[35]) THEN error := TRUE; END_IF;

      (* decode day of month *)
      day := 0;
      day.0 := bits[36];
      day.1 := bits[37];
      day.2 := bits[38];
      day.3 := bits[39];
      IF bits[40] THEN day := day + 10; END_IF;
      IF bits[41] THEN day := day + 20; END_IF;
      IF day > 31 THEN error := TRUE; END_IF;

      (* decode day of week *)
      wday := 0;
      wday.0 := bits[42];
      wday.1 := bits[43];
      wday.2 := bits[44];
      IF wday > 7 OR wday < 1 THEN error := TRUE; END_IF;

      (* decode month *)
      MONTH := 0;
      MONTH.0 := bits[45];
      MONTH.1 := bits[46];
      MONTH.2 := bits[47];
      MONTH.3 := bits[48];
      IF bits[49] THEN MONTH := MONTH +10; END_IF;
      IF MONTH > 12 THEN error := TRUE; END_IF;

      (* decode year *)
      YEAR := 0;
      YEAR.0 := bits[50];
      YEAR.1 := bits[51];
      YEAR.2 := bits[52];
      YEAR.3 := bits[53];
      IF bits[54] THEN YEAR := YEAR + 10; END_IF;
      IF bits[55] THEN YEAR := YEAR + 20; END_IF;
      IF bits[56] THEN YEAR := YEAR + 40; END_IF;
      IF bits[57] THEN YEAR := YEAR + 80; END_IF;

      (* check parity for bits 36 to 58 *)
      cnt := 0;
      FOR i := 36 TO 58 DO IF bits[i] THEN cnt := cnt + 1; END_IF; END_FOR;
      IF NOT EVEN(INT_TO_DINT(cnt)) THEN error := TRUE; END_IF;

      (* time must be valid for two cycles to clear error flag *)
      IF NOT error THEN
        (* set outputs *)
        old_time := mez;
        IF YEAR >= 70 THEN YEAR := YEAR + 1900; ELSE YEAR := YEAR + 2000; END_IF;
        mez := SET_DT(YEAR,MONTH,day,HOUR,MINUTE,0);
        DS := bits[17];
        IF DS THEN
          UTC := UDINT_TO_DT(DT_TO_UDINT(mez) - 7200);
        ELSE
          UTC := UDINT_TO_DT(DT_TO_UDINT(mez) - 3600);
        END_IF;

        (* set trigger signal only if the receiver has received 2 successive minutes *)
        IF mez <> ADD_DT_TIME( old_time, TIME#1m) THEN error := TRUE ; END_IF;
      END_IF;
    END_IF;
  END_IF;

  (* this portion implements a free running clock which is triggered by the dcf77 signal *)
  tz := UDINT_TO_TIME(INT_TO_UDINT(ABS(time_offset))* 3600000);

  (* input sdt is copied to utc at first power up *)
  IF NOT init OR SET THEN
    init := TRUE;
    utc := sdt;
    tp := TRUE;
    DS := DSI;
  END_IF;

  IF tp THEN
    rtc := utc;
    IF DS AND dst_en THEN
      IF time_offset < 0 THEN rtc1 := SUB_DT_TIME( rtc, tz + t#1h); ELSE rtc1 := ADD_DT_TIME( rtc, tz + t#1h); END_IF;
    ELSE
      IF time_offset < 0 THEN rtc1 := SUB_DT_TIME( rtc, tz); ELSE rtc1 := ADD_DT_TIME( rtc, tz); END_IF;
    END_IF;
    sync := TRUE;
    last_sync := last;
    ty := last;
  ELSIF rtc > DWORD_TO_DT(0) AND T1 - ty >= t#1s THEN
    rtc := ADD_DT_TIME( rtc, t#1s);
    rtc1 := ADD_DT_TIME( rtc1, t#1s);
    ty := ty + t#1s;
    sync := ty - last_sync < sync_timeout AND last_sync > DWORD_TO_TIME(0);
    wday := DAY_OF_WEEK1(DT_TO_DATE(rtc1));
    DS := dst_en AND DST(utc);
  END_IF;
  msec := TIME_TO_INT(t1 - ty);

(* decode information
  bits    content
  0     Bitwert immer 0
  1 bis 14  reserviert für Betriebsinformationen (nicht für DCF77-Nutzer bestimmt)
  15      Rufbit für Alarmierung der PTB-Mitarbeiter
        (bis Mai 2003: Bitwert = 0 falls normale Antenne in Verwendung; 1 = Backupantenne)
  16      Bitwert = 1 falls ein Wechsel von MEZ nach MESZ oder umgekehrt bevorsteht; Dauer der Anzeige: 1 Stunde
  17 + 18 gültige Zeit = MEZ, falls Bit 17=0 und Bit 18=1
        gültige Zeit = MESZ, falls Bit 17=1 und Bit 18=0
  19      Bitwert = 1 falls innerhalb den nächsten 59 Minuten eine Schaltsekunde angeordnet ist. Beim Einfügen einer Schaltsekunde wird anstelle der 59. die 60. Sekundenmarke weggelassen und in der 58. erfolgt ausnahmsweise ein Trägerabfall.
  20      Startbit für Zeitinformation (immer 1)
  21 - 27   1, 2, 4, 8, 10, 20, 40 Minuten (bitweise Addition)
  28      Prüfbit (gerade Parität) für die Bits 21-27
  29 - 34   1, 2, 4, 8, 10, 20 Stunden (bitweise Addition)
  35      Prüfbit (gerade Parität) für die Bits 29-34
  36 - 41   Tagesnummer im aktuellen Monat: 1, 2, 4, 8, 10, 20 (bitweise Addition)
  42 - 44   Tagesnummer in der aktuellen Woche: 1, 2, 4 (bitweise Addition)
  45 - 49   Monatsnummer: 1, 2, 4, 8, 10 (bitweise Addition)
  50 - 57   Jahr (zweistellig): 1, 2, 4, 8, 10, 20, 40, 80 (bitweise Addition)
  58      Prüfbit (gerade Parität) füR die Bits 36-57
*)
(* revision history
  hm 2.feb 2007   rev 1.1
    change wday and dst outputs when there is no dcf reception

  hm  26.feb 2007   rev 1.2
    changed statements where t#1h would be substracted from DT.
    under certain conditions the compiler would crash translating this statement

  hm  17. sep 2007  rev 1.3
    replaced time() with T_PLC_MS() for compatibility reasons

  hm  24. oct 2007    rev 1.4
    changed dst calculation because function dst was upgraded no error in DCF77 only a change in DST

  hm  12. nov 2007    rev 1.5
    changed time_offset from time to integer to allow for negative offset time zones

  hm  8. dec 2007   rev 1.6
    corrected an error in time_zone calculation

  hm 23. jan 2008   rev 1.7
    added sdt input which is used to initialize rtc and rtc1 during first cycle.

  hm 16. mar 2008   rev 1.8
    changed output weekday to wday and dst to ds for compatibility reasons

  hm  19. apr. 2008 rev 1.9
    added input dsi to allow to set daylight savings time when SDT is TRUE.
    added asynchronous SET input

  hm  7. oct. 2008  rev 1.10
    changed function weekday to day_of_week
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Time&Date' *)
FUNCTION DT2_TO_SDT : SDT
(*
  converts date and time of day to Structured date time (SDT)

  version 1.0 18. oct 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    DI : DATE;
    TI : TOD;
  END_VAR

  DT2_TO_SDT.YEAR := YEAR_OF_DATE1(di);
  DT2_TO_SDT.MONTH := MONTH_OF_DATE1(di);
  DT2_TO_SDT.DAY := DAY_OF_MONTH1(di);
  DT2_TO_SDT.WEEKDAY := DAY_OF_WEEK1(di);
  DT2_TO_SDT.MS := UDINT_TO_INT(TOD_TO_UDINT(ti) MOD 1000);
  DT2_TO_SDT.SECOND := UDINT_TO_INT((TOD_TO_UDINT(ti) / 1000) MOD 60);
  DT2_TO_SDT.MINUTE := UDINT_TO_INT((TOD_TO_UDINT(ti) / 60000) MOD 60);
  DT2_TO_SDT.HOUR := UDINT_TO_INT(TOD_TO_UDINT(ti) / 3600000);

(* revision history
  hm 18. oct. 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION DT_TO_SDT : SDT
(*
  converts date_time to Structured date time (SDT)

  version 1.0 18. oct 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    DTI : DT;
  END_VAR
  VAR
    tmp : DATE;
    tdt : UDINT; //DWORD;
  END_VAR

  tmp := DT_TO_DATE(dti);
  tdt := DT_TO_UDINT(dti) - DATE_TO_UDINT(tmp);
  DT_TO_SDT.YEAR := YEAR_OF_DATE1(tmp);
  DT_TO_SDT.MONTH := MONTH_OF_DATE1(tmp);
  DT_TO_SDT.DAY := DAY_OF_MONTH1(tmp);
  DT_TO_SDT.WEEKDAY := DAY_OF_WEEK1(tmp);
  DT_TO_SDT.SECOND := UDINT_TO_INT(tdt MOD 60);
  DT_TO_SDT.MINUTE := UDINT_TO_INT((tdt / 60) MOD 60);
  DT_TO_SDT.HOUR := UDINT_TO_INT(tdt / 3600);

(* revision history
  hm 18. oct. 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION_BLOCK EVENTS
(*
  event checks an array with a list of events and displays the event if today is one.

  version 1.0 18. jan. 2010
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    DATE_IN : DATE;
    ENA : BOOL;
  END_VAR
  VAR_OUTPUT
    Y : BOOL;
    NAME : STRING[30];
  END_VAR
  VAR
    i : INT;
    last_active : DATE;
    size :INT := 49;
    day_in: DINT;
    cyr: INT;
    lday: DINT;
    check : HOLIDAY_DATA;
    y_int : BOOL;
    name_int : STRING[30];
  END_VAR
  VAR_IN_OUT
    ELIST : OSCAD_BASIC_ARRAY0_49_OF_HOLIDAY_DATA; // ARRAY[0..49] OF HOLIDAY_DATA;
  END_VAR

  (* for performance reasons only activate once a day *)
  IF last_active <> date_in THEN
    last_active := DATE_IN;
    Y_int := FALSE;
    name_int := '';
    day_in := DAY_OF_DATE1(DATE_IN);
    cyr := YEAR_OF_DATE1(DATE_IN);

    (* search list for events *)
    FOR i := 0 TO size DO
      check := elist[i];
      lday := DAY_OF_DATE1(SET_DATE(cyr,SINT_TO_INT(check.month), SINT_TO_INT(check.day)));
      IF (day_in >= lday) AND (day_in <= lday + SINT_TO_DINT(check.use) - 1) THEN
        y_int := TRUE;
        name_int := check.name;
        EXIT;
      END_IF;
    END_FOR;
  END_IF;

  IF ENA THEN
    Y := y_int;
    NAME := name_int;
  ELSE
    Y := FALSE;
    NAME := '';
  END_IF;

(* revision history
  hm  18. jan. 2011 rev 1.0
    new module
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Time&Date' *)
FUNCTION HOUR_OF_DT1 : INT
(*
  HOUR_OF_DT1 returns the current hour (hour of the day) of a DT variable

  version 1.0 6. jun. 2008
  programmer  oscat
  tested by oscat
*)
  VAR_INPUT
    XDT : DT;
  END_VAR

  HOUR_OF_DT1 := UDINT_TO_INT((DT_TO_UDINT(XDT) MOD 86400) / 3600);

(* revision history
  hm    6.9.2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION JD2000 : REAL
(*
  JULIAN calculates the astronomic julian date from 1.1.2000-12:00.

  version 1.0 15. jul. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    DTI : DT;
  END_VAR

  JD2000 := UDINT_TO_REAL(DT_TO_UDINT(DTI) - 946728000) / 86400.0;

(* revision histroy
  hm  15. jul. 2008 rev 1.0
    original release
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION LEAP_DAY : BOOL
(*
  leap_day is true if the tested day is a leap day (29. of february).

  version 1.2 24. jan. 2011
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    IDATE : DATE;
  END_VAR

  LEAP_DAY := DATE_TO_UDINT(IDATE) MOD 126230400 = 68169600;

(* change history
  hm  15. jun. 2008 rev 1.0
    original version

  hm  7. oct. 2008  rev 1.1
    changed function month to month_of_date

  hm  24. jan. 2011 rev 1.2
    improved performance
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION LTIME_TO_UTC : DT
(*
  LTIME_TO_UTC calculates UTC (World Time) from a local time LTIME. utc is calculated
  by subtracting Time_Zone_Offset from ltime and if dst it true subtracting an additional hour from ltime.

  version 1.7 13. nov. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    LTIME : DT;
    DST : BOOL;
    TIME_ZONE_OFFSET : INT;
  END_VAR
  VAR_TEMP
    tmp : DT;
  END_VAR

  tmp := UDINT_TO_DT(DT_TO_UDINT(LTIME) - INT_TO_UDINT(TIME_ZONE_OFFSET) * 60);
  IF DST THEN tmp := SUB_DT_TIME(tmp, T#1h); END_IF;
  LTIME_TO_UTC := tmp;

(* revision history
  hm 5.7.2007   rev 1.0
    original version

  hm 5.11.2007    rev 1.1
    replaced literal constant with variable because of error in möller ecp4 compiler

  hm  12.nov 2007 rev 1.2
    changed Type of time_zone_offset from time to int to allow for time zones with negative offset

  hm  8. dec 2007 rev 1.3
    corrected a problem with time_zone_offset

  hm  14. oct. 2008 rev 1.4
    changed time_zone_offset from int to real to allow for half hour offset

  hm  20. oct. 2006 rev 1.5
    changed time_zone_offset from Real to INT, now in Minutes

  hm  27. feb. 2009 rev 1.6
    added type conversions to avoid warnings under codesys 3.0

  ks  13. nov. 2009 rev 1.7
    corrected error in formula
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION MINUTE : INT
(*
  extracts the minutes out of TOD truncating the seconds

  version 1.1 2 oct 2006
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    itod : TOD;
  END_VAR

  MINUTE := UDINT_TO_INT(TOD_TO_UDINT(itod) / 60000 - TOD_TO_UDINT(itod) / 3600000 * 60);

(* change history
   2.10.2006 changes name of input to itod
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION MINUTE_OF_DT : INT
(*
  MINUTE_OF_DT returns the current minute (minute of the hour) of a DT variable

  version 1.0 6. jun. 2008
  programmer  oscat
  tested by oscat
*)
  VAR_INPUT
    XDT : DT;
  END_VAR

  MINUTE_OF_DT := UDINT_TO_INT(DT_TO_UDINT(XDT) MOD 3600) / 60;

(* revision history
  hm    6.9.2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION MINUTE_TO_TIME : TIME
(*
  converts an amount of minutes in real to time

  version 1.2 24. feb. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    IN : REAL;
  END_VAR

  MINUTE_TO_TIME := DWORD_TO_TIME(REAL_TO_DWORD(IN * 60000.0));

(* revision history
  hm  4. aug 2006 rev 1.0
    original version

  hm  14. mar 2008  rev 1.1
    rounded the input after the last digit

  hm  24. feb. 2009 rev 1.2
    changed input to IN
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION MONTH_BEGIN : DATE
(*
  returns the date for the first day of the current month in the current year.

  version 1.0 15. jun. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    idate : DATE;
  END_VAR

  MONTH_BEGIN := UDINT_TO_DATE(DATE_TO_UDINT(idate) - INT_TO_UDINT(DAY_OF_MONTH1(idate) - 1) * 86400);

(* revision history
  hm  15. jun. 2008 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION MONTH_END : DATE
(*
  returns the date for the last day of the current month in the current year.

  version 1.1 7. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    IDATE : DATE;
  END_VAR

  MONTH_END := UDINT_TO_DATE(DATE_TO_UDINT(SET_DATE(YEAR_OF_DATE1(idate),MONTH_OF_DATE1(idate)+1,1)) - 86400);

(* revision history
  hm  15. jun. 2008 rev 1.0
    original version

  hm  7. oct. 2008  rev 1.1
    changed function year to year_of_date
    changed function month to month_of_date
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION MUL_TIME : TIME
(*
  multiplies a time by a real number and returns a time

  version 1.1 14 mar 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    t : TIME;
    M : REAL;
  END_VAR

  MUL_TIME := DWORD_TO_TIME(REAL_TO_DWORD(DWORD_TO_REAL(TIME_TO_DWORD(t))*M));

(* revision history
  hm    2. oct 2006 rev 1.0
    original version

  hm    14. mar 2008  rev 1.1
    rounded the result after the last digit
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION PERIOD : BOOL
(*
  PERIOD checks if a given date is between two dates (d1 and d2) d1 is the starting date and d2 the last date for the period.
  the years of the dates are ignored, so the function period cheks for a time period within a year independet of the year.

  version 1.3 22. mar. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    d1 : DATE;
    dx : DATE;
    d2 : DATE;
  END_VAR
  VAR
    day1, day2, dayx : INT;
  END_VAR

  day1 := DAY_OF_YEAR1(d1);
  day2 := DAY_OF_YEAR1(d2);
  dayx := DAY_OF_YEAR1(dx);
  IF NOT LEAP_OF_DATE(dx) AND dayx > 58 THEN dayx := dayx + 1; END_IF;
  IF NOT LEAP_OF_DATE(d1) AND day1 > 58 THEN day1 := day1 + 1; END_IF;
  IF NOT LEAP_OF_DATE(d2) AND day2 > 58 THEN day2 := day2 + 1; END_IF;

  IF day2 < day1 THEN
    (* the period spans over the new year *)
    PERIOD := dayx <= day2 OR dayx >= day1;
  ELSE
    PERIOD := dayx >= day1 AND dayx <= day2;
  END_IF;

(* code before rev 1.2
  yx := year(dx);
  p1 := date_add(d1,0,0,0,yx - year(d1));
  p2 := date_add(d2,0,0,0,yx - year(d2));

  IF p2 >= p1 THEN
    period := dx <= p2  AND dx >= p1;
  ELSE
    period := dx <= p2 OR dx >= p1;
  END_IF;
*)
(* revision history
  hm    19. sep 2007  rev 1.0
    original version

  hm    20. sep 2007  rev 1.1
    corrected a problem with leap year

  hm    4. jan 2008   rev 1.2
    changed code for better performance

  hm    22. mar. 2008 rev 1.3
    function would deliver wrong results when d1, d2 or dx are a leap_year
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION PERIOD2 : BOOL
(*
  PERIOD2 checks if DX is within one of 4 periods and sets the output true if so.

  version 1.0 27. apr. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    DP : ARRAY[0..3,0..1] OF DATE;
    DX : DATE;
  END_VAR

  PERIOD2 :=  (DX >= DP[0,0] AND DX <= DP[0,1]) OR
        (DX >= DP[1,0] AND DX <= DP[1,1]) OR
        (DX >= DP[2,0] AND DX <= DP[2,1]) OR
        (DX >= DP[3,0] AND DX <= DP[3,1]);

(* revision history
  hm    27. apr 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION_BLOCK RTC_MS
(*
  RTC_MS is a real time clock module which can be set to SDT when set is TRUE and the outputs XDT and XT present the DateTime and TOD with a resolution of milliseconds.

  version 1.1 20. feb. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    SET : BOOL;
    SDT : DT;
    SMS : INT;
  END_VAR
  VAR_OUTPUT
    XDT : DT;
    XMS : INT;
  END_VAR
  VAR
    init: BOOL;
    last: UDINT; //DWORD;
    Tx: UDINT; //DWORD;
  END_VAR

  tx := DWORD_TO_UDINT( T_PLC_MS());
  IF set OR NOT init THEN
    (* clock needs to be set when set is true or after power up *)
    init := TRUE;
    xdt := SDT;
    XMS := SMS;
  ELSE
    XMS := XMS + UDINT_TO_INT(tx - last);
    (* check if one second has expired *)
    IF XMS > 999 THEN
      XDT := ADD_DT_TIME( XDT, T#1s);
      XMS := XMS - 1000;
    END_IF;
  END_IF;
  last := tx;

(* revision history
  hm    20. jan. 2008 rev 1.0
    original version

  hm    20. feb. 2008 rev 1.1
    added Millisecond Set input
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Time&Date' *)
FUNCTION_BLOCK RTC_2
(*
  RTC_2 is a real time clock module which runs utc and generates local time from utc.
  daylight savings time can be enabled with den and an additional local time is generated with a delay of ofs in minutes.

  version 1.4 27.   apr. 2011
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    SET : BOOL;
    SDT : DT;
    SMS : INT;
    DEN : BOOL;
    OFS : INT;
  END_VAR
  VAR_OUTPUT
    UDT : DT;
    LDT : DT;
    DSO : BOOL;
    XMS : INT;
  END_VAR
  VAR
    RT : RTC_MS;
  END_VAR

  (* call rtc *)
  RT(SET := SET, SDT := SDT, SMS := SMS);
  UDT := rt.xdt;
  XMS := rt.XMS;

  (* check for daylight savings time and set dso output *)
  DSO := DST(udt) AND DEN;

  (* calculate time offset and set ldt output *)
  LDT := UDINT_TO_DT(DT_TO_UDINT(UDT) + INT_TO_UDINT(ofs + BOOL_TO_INT(DSO)*60) * 60);

(* revision history
  hm    20. jan. 2008 rev 1.0
    original version

  hm    20. feb. 2008 rev 1.1
    added Millisecond Set input

  hm    12. jun. 2008 rev 1.2
    improved performance

  hm    20. jan. 2011 rev 1.3
    changed offset to be in minutes

  hm    27. apr. 2011 rev 1.4
    fixed error with local time calculation
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Time&Date' *)
FUNCTION SDT_TO_DATE : DATE
(*
  converts Structured date time (SDT) to Date Time

  version 1.0 18. oct 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    DTI : SDT;
  END_VAR

  SDT_TO_DATE := SET_DATE(DTI.YEAR, DTI.MONTH, DTI.DAY);

(* revision history
  hm 18. oct. 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION SDT_TO_DT : DT
(*
  converts Structured date time (SDT) to Date Time

  version 1.0 18. oct 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    DTI : SDT;
  END_VAR

  SDT_TO_DT := SET_DT(DTI.YEAR, DTI.MONTH, DTI.DAY, DTI.HOUR, DTI.MINUTE, DTI.SECOND);

(* revision history
  hm 18. oct. 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION SDT_TO_TOD : TOD
(*
  converts Structured date time (SDT) to Date Time

  version 1.1 16. nov. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    DTI : SDT;
  END_VAR

  SDT_TO_TOD := UDINT_TO_TOD(INT_TO_UDINT(DTI.HOUR) * 3600000 + INT_TO_UDINT(DTI.MINUTE) * 60000 + INT_TO_UDINT(DTI.SECOND) * 1000 + INT_TO_UDINT(DTI.MS));

(* revision history
  hm 18. oct. 2008  rev 1.0
    original version

  hm  16. nov. 2008 rev 1.1
    added typecasts to avoid warnings
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION SECOND : REAL
(*
  returns the seconds and milliseconds as real of TOD

  version 1.1 2 oct 2006
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    itod : TOD;
  END_VAR

  SECOND := UDINT_TO_REAL( TOD_TO_UDINT(itod) - TOD_TO_UDINT(itod)/60000 * 60000) / 1000.0;

(* change history
  hm  2. oct. 2006 rev 1.1
    changed name of input to itod
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION SECOND_OF_DT : INT
(*
  SECOND_OF_DT returns the current second (second of minute) of a DT variable

  version 1.0 6. jun. 2008
  programmer  oscat
  tested by oscat
*)
  VAR_INPUT
    XDT : DT;
  END_VAR

  SECOND_OF_DT := UDINT_TO_INT(DT_TO_UDINT(XDT) MOD 60);

(* revision history
  hm    6.9.2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION SECOND_TO_TIME : TIME
(*
  converts an amount of seconds in real to time
  execution TIME on wago 750-841 =  17us

  version 1.2 24. feb. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IN : REAL;
  END_VAR

  SECOND_TO_TIME := DWORD_TO_TIME(REAL_TO_DWORD(IN * 1000.0));

(* revision history
  hm  4. aug. 2006  rev 1.0
    original version

  hm  14. mar. 2008 rev 1.1
    rounded the input after the last digit

  hm  24. feb. 2009 rev 1.2
    changed input to IN
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION SET_TOD : TOD
(*
  creates tod from hour minute and second

  version 1.5 16. mar 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    hour : INT;
    minute : INT;
    second : REAL;
  END_VAR

  SET_TOD := UDINT_TO_TOD( REAL_TO_UDINT(SECOND * 1000.0) + INT_TO_UDINT(MINUTE) * 60000 + INT_TO_UDINT(HOUR) * 3600000);

(* revision history
  hm    4.aug.2006    rev 1.0
    original version

  hm    11. sep 2007  rev 1.1
    changed coding to avoid a compiler warning under twincat.

  hm    1. nov 2007 rev 1.2
    changed coding to avoid possible overrun situation on möller ecp4

  hm    2. Nov  2007  rev 1.3
    changed dword to DINT in calcualtion to avoid warnings with some compilers

  hm    14. mar 2008  rev 1.4
    changed code to avoid rounding problem at last digit of millisecond

  hm    16. mar. 2008 rev 1.5
    added type conversions to avoid warning under codesys 3.0
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION TIMECHECK : BOOL
(*
  this function retruns true if the daytime TD is between start and stop and returns true if so.
  if you want to generate an event to span over midnight, start timemust be later than the stop time.

  version 1.0 19. jul. 2009
  programmer  oscat
  tested by   oscat
*)
  VAR_INPUT
    TD : TOD;
    START : TOD;
    STOP : TOD;
  END_VAR

  IF stop < start THEN
    TIMECHECK := start <= TD OR TD < stop;
  ELSE
    TIMECHECK := start <= TD AND TD < stop;
  END_IF;

(* revision history
  hm 19. jul. 2009  rev 1.0
    original release
*)
END_FUNCTION


(* @PATH := '\/Time&Date' *)
FUNCTION YEAR_END : DATE
(*
  returs the date of december 31st for the given year
  the function works for dates from 1970 - 2099

  version 1.1 24. jan. 2011
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    y : INT;
  END_VAR

  YEAR_END := UDINT_TO_DATE( DWORD_TO_UDINT( SHR( UDINT_TO_DWORD(INT_TO_UDINT(y) * 1461 - 2876712), 2)) * 86400);

(* revision history
  hm  15. jun. 2008 rev 1.0
    original version

  hm  24. jan 2011  rev 1.1
    improved performance
*)
END_FUNCTION




