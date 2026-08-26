
VAR_GLOBAL CONSTANT
	STRING_LENGTH : INT := 250;
	LIST_LENGTH : INT := 250;
END_VAR

(* revision history
  hm 3. mar. 2007
  	extended accuracy of pi2
  	renamed T0 to Tk for better compatibility with other libraries
  	renamed C t0 c0 for better compatibility

  hm	2. may. 2007
  	added RU universal gas constant

  hm	1. oct. 2007
  	added setup parameter STEP7

  hm 31. oct. 2007
  	added PN

  hm	6. mar. 2008
  	added setup Parameter EXTENDED_ASCII

  hm	28. Mar. 2008
  	added setup parameter STRING_LENGTH

  hm	7. apr. 2008
  	Deleted unused setup parameter Step7

  hm	19. apr. 2008
  	added setup parameter NETWORK_BUFFER_SIZE

  hm	27. apr. 2008
  	added PI05 and PI025

  hm	18. may. 2008
  	added charname lists
  	renamed E to E1

  hm	30. jun. 2008
  	reduced size of string constants to 253 to avoid problems with target aixia DCUF

  hm	21. sep. 2008
  	added section language setup
  	added section location setup

  hm	20. oct. 2008
  	changed to structured constants

  hm	16. nov. 2008
  	moved structured constants to global vars for compatibility reasons

  hm	13. nov. 2009
  	added network_buffer_short_size
  	renamed network_buffer_long_size
  	changed string length to 250

  hm	20. jan. 2011
  	removed network buffers
  	added list_length
*)

TYPE CONSTANTS_SETUP :
  STRUCT
    (* setup Parameters *)
    EXTENDED_ASCII : BOOL := TRUE;                  (* extends the ASCII character set to special characters eg ÄÖÜ *)
    CHARNAMES : ARRAY[1..4] OF STRING[253] := [     (* stores Unicode character names *)
      ';"&quot;&&amp;<&lt;>&gt;€&euro; &nbsp;?&iexcl;?&cent;L&pound;¤&curren;A&yen;¦&brvbar;§&sect;¨&uml;©&copy;S&ordf;«&laquo;¬&not;­&shy;®&reg;Z&macr;°&deg;±&plusmn;?&sup2;l&sup3;´&acute;µ&micro;¶&para;·&middot;¸&cedil;a&sup1;s&ordm;»&raquo;L&frac14;U&Ucirc;',
      ';l&frac34;z&iquest;R&Agrave;Á&Aacute;Â&Acirc;A&Atilde;Ä&Auml;L&Aring;C&AElig;Ç&Ccedil;C&Egrave;É&Eacute;E&Ecirc;Ë&Euml;E&Igrave;Í&Iacute;Î&Icirc;D&Iuml;Ð&ETH;N&Ntilde;N&Ograve;Ó&Oacute;Ô&Ocirc;O&Otilde;Ö&Ouml;×&times;R&Oslash;U&Ugrave;Ú&Uacute;?&frac12;',
      ';Ü&Uuml;Ý&Yacute;T&THORN;ß&szlig;r&agrave;á&aacute;â&acirc;a&atilde;ä&auml;l&aring;c&aelig;ç&ccedil;c&egrave;é&eacute;e&ecirc;ë&euml;e&igrave;í&iacute;î&icirc;d&iuml;d&eth;n&ntilde;n&ograve;ó&oacute;ô&ocirc;o&otilde;ö&ouml;÷&divide;r&oslash;u&ugrave;',
      ';ú&uacute;u&ucirc;ü&uuml;ý&yacute;t&thorn;?&yuml;'];
    MTH_OFS : ARRAY[1..12] OF INT := [0,31,59,90,120,151,181,212,243,273,304,334];
    DECADES : ARRAY[0..8] OF REAL := [1.0,10.0,100.0,1000.0,10000.0,10000.0,100000.0,1000000.0,10000000.0];
  END_STRUCT;
END_TYPE

(* revision history
  hm  24.10.2008  rev 1.0
    original version
*)

TYPE CONSTANTS_MATH :
  STRUCT
    PI : REAL :=  3.14159265358979323846; //???3.14159265358979323846264338327950288;    (* Kreiszahl PI *)
    PI2 : REAL :=   6.28318530717958647692;//???6.28318530717958647692528676655900576;  (* PI * 2 *)
    PI4 : REAL :=  12.56637061435917295385;//???12.56637061435917295385057353311801152;  (* PI * 4 *)
    PI05 : REAL :=  1.5707963267949;              (* PI / 2 *)
    PI025 : REAL := 0.785398163397448;              (* PI / 4 *)
    PI_INV : REAL := 0.318309886183791;           (* 1 / PI *)
    E : REAL :=   2.71828182845904523536;//???2.71828182845904523536028747135266249;    (* Euler constant e *)
    E_INV : REAL := 0.367879441171442;              (* 1 / e *)
    SQ2 : REAL := 1.4142135623731;              (* Root of 2 *)
    FACTS : ARRAY[0..12] OF DINT := [1,1,2,6,24,120,720,5040,40320,362880,3628800,39916800,479001600]; (* Faculties 0-12 *)
  END_STRUCT;
END_TYPE

(* revision history
  hm  26.10.2008  rev 1.0
    original version

  hm  26. mar. 2011 rev 1.1
    added array facts
*)

TYPE FRACTION :
  STRUCT
    NUMERATOR : INT;     (* Numerator of the fraction *)
    DENOMINATOR : INT;   (* Denominator of the fraction *)
  END_STRUCT;
END_TYPE

TYPE REAL2 :
  STRUCT
    R1 : REAL;  (* small value *)
    RX : REAL;  (* big value *)
  END_STRUCT;
END_TYPE

(* revision history
  hm  18. oct. 2008
    original version
*)

TYPE SDT :             (* defnes a structured time-date format *)
  STRUCT
    YEAR : INT;
    MONTH : INT;
    DAY : INT;
    WEEKDAY : INT;
    HOUR : INT;
    MINUTE : INT;
    SECOND : INT;
    MS : INT;
  END_STRUCT;
END_TYPE

(* revision history
  hm  18. oct. 2008
    original version
*)

TYPE TIMER_EVENT :
  STRUCT
    TYP : BYTE;            (* Event Type *)
    CHANNEL : BYTE;        (* Channel *)
    DAY : BYTE;            (* Day or days *)
    START : TOD;           (* Start time *)
    DURATION : TIME;       (* Duration *)
    LAND : BYTE;           (* Logical AND *)
    LOR : BYTE;            (* Logical OR *)
    LAST : DT;             (* last activity of the event *)
  END_STRUCT;
END_TYPE

(* revision history
hm  18. oct. 2008 rev 1.0
  original version

hm  26. jan. 2011 rev 1.1
  changed type of last to be DT
*)

TYPE CALENDAR :
  STRUCT
    UTC : DT;            (* world time UTC *)
    LDT : DT;            (* local time *)
    LDATE : DATE;        (* local date *)
    LTOD : TOD;          (* local time of day *)
    YEAR : INT;          (* year of LDATE *)
    MONTH : INT;         (* month of LDATE *)
    DAY : INT;           (* day of LDATE *)
    WEEKDAY : INT;       (* weekday of LDATE *)
    OFFSET : INT;        (* Time Zone Offset for Local time in minutes *)
    DST_EN : BOOL;       (* daylight savings time enable *)
    DST_ON : BOOL;       (* true when daylight savings time os on *)
    NAME : STRING[5];    (* name of time zone *)
    LANGUAGE : INT;      (* location number pls see location setup *)
    LONGITUDE : REAL;    (* longitude of current location *)
    LATITUDE : REAL;     (* latitude of current location *)
    SUN_RISE : TOD;      (* sun_rise for current location *)
    SUN_SET : TOD;       (* sun_set for current location *)
    SUN_MIDDAY : TOD;    (* worldtime when sun stands at south position *)
    SUN_HEIGTH : REAL ;  (* suns heigth at midday, south position *)
    SUN_HOR : REAL;      (* sun angle horizontal 0 = north in degrees *)
    SUN_VER : REAL;      (* sun angle vertical above horizon in degrees *)
    NIGHT : BOOL;        (* true between sun_set and sun_rise *)
    HOLIDAY : BOOL;      (* true when holiday *)
    HOLY_NAME : STRING[30]; (* name of holiday *)
    WORK_WEEK : INT;      (* current work week *)
  END_STRUCT;
END_TYPE

(* revision history
  hm  21. nov. 2008 rev 1.0
    original version

  hm  8. feb. 2009  rev 1.1
    added sun position data

  hm  10. mar. 2009 rev 1.2
    added work_week, sun_midday, sun_heigth

  hm  23. jan 2010  rev 1.3
    sun_rise, sun_set and sun_midday are now calculated in local time
*)

TYPE ESR_DATA :                 (* ESR_DATA is used for Error and Status Reporting modules *)
  STRUCT
    TYP : BYTE;                 (* Data Type *)
    ADRESS : STRING[10];        (* Adress designation *)
    DS : DT;                    (* Date / time stamp *)
    TS : TIME;                  (* Timestamp in milliseconds *)
    DATA : ARRAY[0..7] OF BYTE; (* Data packet *)
  END_STRUCT;
END_TYPE

(* revision history
  hm  18. oct. 2008
    original version
*)

TYPE HOLIDAY_DATA :
  STRUCT
    NAME : STRING[30];      (* Name of the holiday *)
    DAY : SINT;             (* Day of public holiday *)
    MONTH : SINT;           (* Month of the holy day *)
    USE : SINT;             (* activates the holyday (0=off, 1=on) *)
  END_STRUCT;
END_TYPE

(* revision history
  hm  18. oct. 2008
    original version
*)
(* if month = 0 then F_day is the offset in days from easter
   used :0 = NOT used, 1 = used, -1..-7 menas the weekday before the specified DATE example -3 means wednesday before 23.11
*)
(* samples for Holiday data

  HOLIDAY_DE : ARRAY[0..29] OF HOLIDAY_DATA := (name := 'Neujahr', day := 1, month := 1, use := 1),
    (name := 'Heilig Drei Könige', day := 6, month := 1, use := 1),
    (name := 'Karfreitag', day := -2, month := 0, use := 1),
    (name := 'Ostersonntag', day := 0, month := 0, use := 1),
    (name := 'Ostermontag', day := 1, month := 0, use := 1),
    (name := 'Tag der Arbeit', day := 1, month := 5, use := 1),
    (name := 'Christi Himmelfahrt', day := 39, month := 0, use := 1),
    (name := 'Pfingstsonntag', day := 49, month := 0, use := 1),
    (name := 'Pfingstmontag', day := 50, month := 0, use := 1),
    (name := 'Fronleichnam', day := 60, month := 0, use := 1),
    (name := 'Augsburger Friedensfest', day := 8, month := 8, use := 0),
    (name := 'Maria Himmelfahrt', day := 15, month := 8, use := 1),
    (name := 'Tag der Deutschen Einheit', day := 3, month := 10, use := 1),
    (name := 'Reformationstag', day := 31, month := 10, use := 0),
    (name := 'Allerheiligen', day := 1, month := 11, use := 1),
    (name := 'Buss und Bettag', day := 23, month := 11, use := 0),
    (name := '1. Weihnachtstag', day := 25, month := 12, use := 1),
    (name := '2. Weihnachtstag', day := 26, month := 12, use := 1);

  HOLIDAY_AT : ARRAY[0..29] OF HOLIDAY_DATA := (name := 'Neujahr', day := 1, month := 1, use := 1),
    (name := 'Heilig Drei Könige', day := 6, month := 1, use := 1),
    (name := 'Karfreitag', day := -2, month := 0, use := 1),
    (name := 'Ostersonntag', day := 0, month := 0, use := 1),
    (name := 'Ostermontag', day := 1, month := 0, use := 1),
    (name := '', day := 1, month := 5, use := 0),
    (name := 'Christi Himmelfahrt', day := 39, month := 0, use := 1),
    (name := 'Pfingstsonntag', day := 49, month := 0, use := 1),
    (name := 'Pfingstmontag', day := 50, month := 0, use := 1),
    (name := 'Fronleichnam', day := 60, month := 0, use := 1),
    (name := '', day := 8, month := 8, use := 0),
    (name := 'Maria Himmelfahrt', day := 15, month := 8, use := 1),
    (name := '', day := 3, month := 10, use := 0),
    (name := '', day := 31, month := 10, use := 0),
    (name := 'Allerheiligen', day := 1, month := 11, use := 1),
    (name := 'Maria Empfängnis', day := 8, month := 12, use := 1),
    (name := '1. Weihnachtstag', day := 25, month := 12, use := 1),
    (name := '2. Weihnachtstag', day := 26, month := 12, use := 1);

  HOLIDAY_FR : ARRAY[0..29] OF HOLIDAY_DATA := (name := 'Nouvel an', day := 1, month := 1, use := 1),
    (name := 'St Valentin', day := 14, month := 2, use := 0),
    (name := 'Vendredi Saint (alsace)', day := -2, month := 0, use := 0),
    (name := 'Dimanche de pâques', day := 0, month := 0, use := 1),
    (name := 'Lundi de pâques', day := 1, month := 0, use := 1),
    (name := 'Jeudi de Ascension', day := 39, month := 0, use := 1),
    (name := 'dimanche de Pentecôte ', day := 49, month := 0, use := 1),
    (name := 'jeudi de la Trinité', day := 60, month := 0, use := 0),
    (name := 'Fete du travail', day := 1, month := 5, use := 1),
    (name := 'Victoire 1945 ', day := 8, month := 5, use := 1),
    (name := 'Prise de La bastille', day := 14, month := 7, use := 1),
    (name := '15 Aout 1944', day := 15, month := 8, use := 1),
    (name := 'Halloween', day := 31, month := 10, use := 0),
    (name := 'Armistice 1918', day := 11, month := 11, use := 1),
    (name := 'Noël', day := 25, month := 12, use := 1),
    (name := 'Saint Étienne (alsace)', day := 26, month := 12, use := 0),
    (name := 'Fete de la musique', day := 21, month := 6, use := 0);

  HOLIDAY_BED : ARRAY[0..29] OF HOLIDAY_DATA := (name := 'Neujahr', day := 1, month := 1, use := 1),
    (name := 'Ostersonntag', day := 0, month := 0, use := 1),
    (name := 'Ostermontag', day := 1, month := 0, use := 1),
    (name := 'Tag der Arbeit', day := 1, month := 5, use := 1),
    (name := 'Christi Himmelfahrt', day := 39, month := 0, use := 1),
    (name := 'Pfingsten', day := 49, month := 0, use := 1),
    (name := 'Pfingstmontag', day := 50, month := 0, use := 1),
    (name := 'Nationalfeiertag', day := 21, month := 7, use := 1),
    (name := 'Mariä Himmelfahrt', day := 15, month := 8, use := 1),
    (name := 'Allerheiligen', day := 1, month := 11, use := 1),
    (name := 'Feiertag DG', day := 15, month := 11, use := 1),
    (name := 'Heiligabend', day := 24, month := 12, use := 1),
    (name := '1. Weihnachtstag', day := 25, month := 12, use := 1),
    (name := '2. Weihnachtstag', day := 26, month := 12, use := 1),
    (name := 'Silvester', day := 31, month := 12, use := 1);

  HOLIDAY_ITD : ARRAY[0..29] OF HOLIDAY_DATA := (name := 'Neujahr', day := 1, month := 1, use := 1),
    (name := 'Heilig Drei Könige', day := 6, month := 1, use := 1),
    (name := 'Ostersonntag', day := 0, month := 0, use := 1),
    (name := 'Ostermontag', day := 1, month := 0, use := 1),
    (name := 'Tag der Befeiung Italiens', day := 25, month := 4, use := 1),
    (name := 'Tag der Arbeit', day := 1, month := 5, use := 1),
    (name := 'Pfingsten', day := 49, month := 0, use := 1),
    (name := 'Pfingstmontag', day := 50, month := 0, use := 1),
    (name := 'Tag der Republik Italien', day := 2, month := 6, use := 1),
    (name := 'Mariä Himmelfahrt', day := 15, month := 8, use := 1),
    (name := 'Allerheiligen', day := 1, month := 11, use := 1),
    (name := 'Mariä Empfängnis', day := 8, month := 12, use := 1),
    (name := 'Heiligabend', day := 24, month := 12, use := 0),
    (name := '1. Weihnachtstag', day := 25, month := 12, use := 1),
    (name := '2. Stephanstag', day := 26, month := 12, use := 1);
*)

TYPE COMPLEX :   (* structure can present complex numbers *)
  STRUCT
    re : REAL;   (*Real part of a complex number*)
    im : REAL;   (*Imaginary part of a complex number*)
  END_STRUCT;
END_TYPE

(* revision history
  hm  18. oct. 2008
    original version
*)

TYPE VECTOR_3 :   (* stores the three vectors of a three-dimensional vector space *)
  STRUCT
    X : REAL;
    Y : REAL;
    Z : REAL;
  END_STRUCT;
END_TYPE

(* revision history
  hm  18. oct. 2008
    original version
*)

TYPE CONSTANTS_LANGUAGE :
  STRUCT
    (* Language Setup *)
    DEFAULT : INT := 1; (* 1=english, 2=german 3=french *)
    LMAX    : INT := 3; (* specifes how many languages are available *)
    WEEKDAYS : ARRAY[1..3, 1..7] OF STRING[10] := [
                            'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
                            'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag', 'Sonntag',
                            'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
    WEEKDAYS2 : ARRAY[1..3, 1..7] OF STRING[2] := [
                            'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su',
                            'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So',
                            'Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa', 'Di'];
    MONTHS : ARRAY[1..3, 1..12] OF STRING[10] := [
                            'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December',
                            'Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember',
                            'Janvier', 'Février', 'mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Aout', 'Septembre', 'Octobre', 'Novembre', 'Decembre'];
    MONTHS3 : ARRAY[1..3, 1..12] OF STRING[3] := [
                            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
                            'Jan', 'Feb', 'Mrz', 'Apr', 'Mai', 'Jun', 'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez',
                            'Jan', 'Fev', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aou', 'Sep', 'Oct', 'Nov', 'Dec'];
    DIRS : ARRAY[1..3,0..15] OF STRING[3] := [
                            'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW',
                            'N', 'NNO', 'NO', 'ONO', 'O', 'OSO', 'SO', 'SSO', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW',
                            'N', 'NNO', 'NO', 'ONO', 'O', 'OSO', 'SO', 'SSO', 'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'];
  END_STRUCT;
END_TYPE

(* revision history
  hm  19. oct. 2008 rev 1.0
    original version

  hm  22. oct. 2008 rev 1.1
    added directions DIRS

  hm  23. dec. 2008 rev 1.2
    added french language
*)

TYPE CONSTANTS_LOCATION :
  STRUCT
    (* location setup *)
    DEFAULT : INT := 1;                                (* 1=germany, 2=austria 3=france 4=belgium-german 5= italien-Südtirol *)
    LMAX : INT := 5;                                   (* indicates how many places are defned *)
    LANGUAGE : ARRAY[1..5] OF INT := [ 2, 2, 3, 2, 2]; (* language spoken in the location *)
  END_STRUCT;
END_TYPE

(* revision history
  hm  20. oct. 2008 rev 1.0
    original version

  hm  23. dec. 2008 rev 1.1
    added french holidays

  hm  18. jan 2011  rev 1.2
    added spoken language
    deleted holidays from structure for more flexibility
*)

TYPE CONSTANTS_PHYS :
  STRUCT
    C : REAL := 299792458.0;        (* Lichtgeschwindigkeit in m/s *)
    E : REAL := 1.60217653E-19;     (* elementarladung in Colomb = A * s *)
    G : REAL := 9.80665;            (* Erdbeschleunigung in m / s? *)
    T0 : REAL := -273.15;           (* absoluter Nullpunkt in °C *)
    RU : REAL := 8.314472;          (* Universelle Gaskonstante in J / (mol · K) *)
    PN : REAL := 101325.0;          (* NormalDruck in Pa *)
  END_STRUCT;
END_TYPE

(* revision history
  hm  18.10.2008  rev 1.0
    original version

  hm  13. mar. 2009 rev 1.1
    real constants updated to new systax using dot
*)

VAR_GLOBAL
  MATH     : CONSTANTS_MATH;
  PHYS     : CONSTANTS_PHYS;
  LANGUAGE : CONSTANTS_LANGUAGE;
  SETUP    : CONSTANTS_SETUP;
  LOCATION : CONSTANTS_LOCATION;
END_VAR

