TYPE
   OSCAT_BASIC_ARRAY1_255_OF_BYTE : ARRAY[1..255] OF BYTE;
END_TYPE


(* @PATH := '\/String' *)
FUNCTION BIN_TO_BYTE : BYTE
(*
  BINARY_TO_byte converts a binary string into a byte.

  version 1.2 26. jul 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    BIN : STRING[12];
  END_VAR
  VAR
    pt : PTR_TO BYTE;
    i: INT;
    X: BYTE;
    stop: INT;
  END_VAR

  pt := ADR(bin);
  stop := LEN(bin);
  BIN_TO_BYTE := 0;
  FOR I := 1 TO stop DO
    x := pt^;
    (* calculate the value of the digit *)
    IF X = 48 THEN
      BIN_TO_BYTE := SHL(BIN_TO_BYTE,1);
    ELSIF X = 49 THEN
      BIN_TO_BYTE := SHL(BIN_TO_BYTE,1) OR 1;
    END_IF;
    pt := pt + 1;
  END_FOR;

(* revision history
  hm  18. jun. 2008 rev 1.0
    original release

  hm  20. sep. 2008 rev 1.1
    changed length of input string from 20 to 12

  hm  26. jul. 2009 rev 1.2
    optimized code
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION BIN_TO_DWORD : DWORD
(*
  BINARY_TO_DWORD converts a binary string into a dword.

  version 1.2 26. jul. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    BIN : STRING[40];
  END_VAR
  VAR
    pt : PTR_TO BYTE;
    i: INT;
    X: BYTE;
    stop: INT;
  END_VAR

  pt := ADR(bin);
  stop := LEN(bin);
  BIN_TO_DWORD := 0;
  FOR I := 1 TO stop DO
    x := pt^;
    (* calculate the value of the digit *)
    IF X = 48 THEN
      BIN_TO_DWORD := SHL(BIN_TO_DWORD,1);
    ELSIF X = 49 THEN
      BIN_TO_DWORD := SHL(BIN_TO_DWORD,1) OR 1;
    END_IF;
    pt := pt + 1;
  END_FOR;

(* revision history
  hm  18. jun. 2008 rev 1.0
    original release

  hm  20. sep. 2008 rev 1.1
    changed length of input dtring from 20 to 40

  hm  26. jul 2009  rev 1.2
    optimized code
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION BYTE_TO_STRB : STRING[8]
(*
  BYTE_TO_STRINGB converts a Byte to a String of Bits represented by '0' and '1' s.
  The lowest order bit will be on the right and the high order bit on the left.

  version 1.3 20. jun. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    IN : BYTE;
  END_VAR
  VAR
    i: INT;
    pt : PTR_TO BYTE;
  END_VAR

  (* pointer für die ausgabe ermitteln *)
  pt := ADR(BYTE_TO_STRB);

  (* die 8 ausgabecharacter ermitteln und schreiben *)
  FOR i := 1 TO 8 DO
    pt^ := BOOL_TO_BYTE(in.7) OR 48; // pt^ := BOOL_TO_BYTE(in.7) + 48;
    in := SHL(in,1);
    pt := pt + 1;
  END_FOR;

  (* der ausgabestring muss noch mit 0 abgeschlossen werden *)
  pt^ := 0;

  (* code before rev 1.1
  FOR i := 1 TO 8 DO
    IF in.0 = 0 THEN temp := CONCAT('0', temp); ELSE temp := CONCAT('1', temp); END_IF;
    in := SHR(in, 1);
  END_FOR;
  BYTE_TO_STRB := temp;
  *)

(* revision history
  hm    9.6.2007  rev 1.0
    original version

  hm  15. dec 2007  rev 1.1
    inprooved code for higher performance

  hm  29. mar. 2008 rev 1.2
    changed STRING to STRING(8)

  hm  20. jun. 2008 rev 1.3
    performance improvement
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION BYTE_TO_STRH : STRING[2]
(*
  BYTE_TO_STRINGH converts a Byte to a String of Hexadecimal represented by '0' .. '9' and 'A' .. 'F'.
  The lowest order Character will be on the right and the high order Character on the left.

  version 1.3 29 mar. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IN : BYTE;
  END_VAR
  VAR
    temp : USINT; //BYTE;
    PT : PTR_TO USINT; //BYTE;
  END_VAR

  (* read pointer to output string *)
  PT := ADR(BYTE_TO_STRH);
  (* calculate high order hex value *)
  temp := BYTE_TO_USINT( SHR(in,4));
  (* convert value to hex character *)
  IF temp <= 9 THEN temp := temp + 48; ELSE temp := temp + 55; END_IF;
  (* write friat character to output string *)
  PT^ := temp;
  (* calculate low order hex value *)
  temp := BYTE_TO_USINT(in AND 2#00001111);
  IF temp <= 9 THEN temp := temp + 48; ELSE temp := temp + 55; END_IF;
  (* increment pointer and wirte low order character *)
  pt := pt + 1;
  pt^ := temp;
  (* set pointer at the end of the output string and close the string with 0 *)
  pt := pt + 1;
  pt^:= 0;

  (* code before rev 1.2
  FOR i := 1 TO 2 DO
    X := in AND 2#1111;
    IF X <= 9 THEN X := X + 48; ELSE X := X + 55; END_IF;
    Cx := CHR(X);
    temp := CONCAT(Cx, temp);
    in := SHR(in,4);
  END_FOR;
  BYTE_TO_STRH := temp;
  *)

(* revision history
  hm  9.6.2007    rev 1.0
    original version

  hm  11.9.2007   rev 1.1
    changed coding for compatibility with twincat, under twincat concat cannot have a function as argument.

  hm  15 dec 2007   REV 1.2
    changed code for higher performance

  hm  29. mar. 2008 rev 1.3
    changed STRING to STRING(2)
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION CAPITALIZE : STRING[STRING_LENGTH]
(*
  capitalize returns str with all first letters after a blank or beginning of the string are converted to uppercase.

  version 1.2 20. jun. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
  END_VAR
  VAR
    PT : PTR_TO BYTE;
    pos : INT;
    L : INT;
    first : BOOL := TRUE;
  END_VAR

  PT := ADR(CAPITALIZE);
  CAPITALIZE := str;
  L := LEN(str);
  FOR pos := 1 TO l DO
    IF first THEN pt^ := TO_UPPER(pt^); END_IF;
    (* remember in first if the next char needs to capitalized *)
    first := pt^= 32;
    PT := pt + 1;
  END_FOR;

(* revision history
  hm    4. mar 2008 rev 1.0
    original release

  hm  29. mar. 2008 rev 1.1
    changed STRING to STRING[STRING_LENGTH]

  hm  20. jun. 2008 rev 1.2
    improved performance
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION CODE : BYTE
(*
  code extracts the code of a character at position POS of a string STR.

  version 1.1 29. mar. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    STR : STRING[STRING_LENGTH];
    POS : INT;
  END_VAR
  VAR
    PT : PTR_TO BYTE;
  END_VAR

  IF pos < 1 OR pos > LEN(str) THEN
    CODE := 0;
    RETURN;
  ELSE
    PT := ADR(STR) + INT_TO_UDINT(pos - 1);
    CODE := pt^;
  END_IF;

(* revision history
  hm  9. mar. 2008  rev 1.0
    original version

  hm  29. mar. 2008 rev 1.1
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION CHARCODE : BYTE
(*
  CHARCODE converts a HTML Character NAME INTO ITS code
  'äuml' is convterted to ä
  'euro' is converted to €

  version 1.2   24. oct. 2008
  programmer    hugo
  tested by   hugo
*)
  VAR_INPUT
    STR : STRING[10];
  END_VAR
  VAR
    found: STRING[1];
    search : STRING[10];
    pos: INT;
    i: INT;
  END_VAR

  IF LEN(str) = 1 THEN
    CHARCODE := CODE(STR, 1);
  ELSIF str <> '' THEN
    (* construct search string *)
    search := CONCAT('&', str);
    search := CONCAT(search, ';');
    WHILE pos = 0 AND (i < 4) DO
      i := i + 1;
      pos := FIND(setup.CHARNAMES[i], search);
    END_WHILE;
    found := MID(setup.CHARNAMES[i], 1, pos - 1);
    CHARCODE := CODE(found, 1);
  END_IF;

(* revision history
  hm  13. may. 2008 rev 1.0
    original version

  hm  19. oct. 2008 rev 1.1
    changed setup constants

  hm  24. oct. 2008 rev 1.2
    optimized code
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION CHR_TO_STRING : STRING[2]
(*
  CHR creates a character from a byte input and stuffs it in a one character length string.

  version 1.3 17. dec. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    C : BYTE;
  END_VAR
  VAR
    PT : PTR_TO BYTE;
  END_VAR

  PT := ADR(CHR_TO_STRING);
  PT^ := C;
  pt := pt + 1;
  pt^ := 0;

(* revision history
  hm  16 jan 2007   rev 1.0
    original version

  hm  4. feb. 2008  rev 1.1
    return string would not be terminated properly

  hm  29. mar. 2008 rev 1.2
    changed STRING to STRING(1)

  hm  17. dec. 2008 rev 1.3
    changed name of function from chr to chr_to_string
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION CHARNAME : STRING[10]
(*
  CHARNAME converts a Character code into its HTML character name
  ä is convterted to 'äuml'
  € is converted to 'euro'
  the character itself is returned if no name is available for the character

  version 1.4   17. dec. 2008
  programmer    hugo
  tested by   oscat
*)
  VAR_INPUT
    C : BYTE;
  END_VAR
  VAR
    pos: INT;
    i : INT;
  END_VAR

  IF C <> 0 THEN
    (* construct search string from code followed by $ sign, also clear charname string*)
    CHARNAME := CHR_TO_STRING(C);
    CHARNAME := CONCAT(CHARNAME,'&');
    CHARNAME := CONCAT(';', CHARNAME);
    WHILE pos = 0 AND (i < 4) DO
      i := i + 1;
      pos := FIND(setup.CHARNAMES[i], CHARNAME);
    END_WHILE;
    IF pos > 0 THEN
      CHARNAME := MID(setup.CHARNAMES[i], 10, pos + 3);
      (* search for end of name and truncate *)
      pos := FIND(CHARNAME, ';');
      CHARNAME := LEFT(CHARNAME,pos - 1);
    ELSE
      CHARNAME := CHR_TO_STRING(C);
    END_IF;
  ELSE
    CHARNAME := '';
  END_IF;

(* revision history
  hm  13. may. 2008 rev 1.0
    original version

  hm  16. jun. 2008 rev 1.1
    changed nested call of concat for better compatibility

  hm  19. oct. 2008 rev 1.2
    changes setup constants

  hm  24. oct. 2008 rev 1.3
    new code for high performance

  hm  17. dec. 2008 rev 1.4
    changed function chr to chr_to_string
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION CLEAN : STRING[STRING_LENGTH]
(*
  Clean deletes all characters from a string except the ones specified in CX.

  version 1.0 18. jun. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    IN : STRING[STRING_LENGTH];
    CX : STRING[80];
  END_VAR
  VAR
    pos: INT := 1;
    stop: INT;
  END_VAR
  VAR_TEMP
     tmpCLEAN : STRING[STRING_LENGTH];
     tmp : STRING[80];
  END_VAR

  (* copy input string *)
  tmpCLEAN := IN;
  stop := LEN(in);
  WHILE pos <= stop DO
    tmp := MID( tmpCLEAN, 1, pos);
    IF FIND(cx, tmp) > 0 THEN
      (* charcter found skip to next one *)
      pos := pos + 1;
    ELSE
      (* wrong chracter needs to be deleted *)
      tmpCLEAN := DELETE(tmpCLEAN, 1, pos);
      stop := stop - 1; (* the string is one character shorter now *)
    END_IF;
  END_WHILE;
  CLEAN := tmpCLEAN;

(* revision history
  hm    18. jun. 2008 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION COUNT_CHAR : INT
(*
  COUNT_CHAR counts how often a character CHAR occurs within a string STR.

  version 1.1 29. mar. 2008
  programmer    kurt
  tested by   hugo
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
    chr : BYTE;
  END_VAR
  VAR
    l: INT;
    pt : PTR_TO BYTE;
    pos: INT;
  END_VAR

  PT := ADR(str);
  l := LEN(str);
  COUNT_CHAR := 0;
  FOR pos := 1 TO l DO
    IF pt^ = CHR THEN COUNT_CHAR := COUNT_CHAR + 1; END_IF;
      PT := PT + 1;
  END_FOR;

(* revision history
  hm  29. feb 2008  rev 1.0
    original version

  hm  29. mar. 2008 rev 1.1
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION COUNT_SUBSTRING : INT
(*
  count_substring returns the number of occurences of a substring in a string

  version 1.0 20. jan. 2011
  programmed  kurt
  tested by   tobias
*)
  VAR_INPUT
     SEARCH : STRING;
     STR : STRING;
  END_VAR
  VAR
     pos : INT;
     size : INT;
  END_VAR

  COUNT_SUBSTRING := 0;
  size := LEN(SEARCH);
  REPEAT
     pos := FIND(STR,SEARCH);
     IF pos > 0 THEN
        STR := REPLACE(STR, '', size,pos);
        COUNT_SUBSTRING := COUNT_SUBSTRING + 1;
     END_IF;
  UNTIL pos = 0
  END_REPEAT;

(* revision history
  ks  20. jan. 2011 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION DEC_TO_BYTE : BYTE
(*
  DEC_TO_byte converts a decimal string into a byte.

  version 1.1 30. sep 2008
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    DEC : STRING[10];
  END_VAR
  VAR
    pt : PTR_TO USINT; //BYTE;
    i: INT;
    X: USINT; //BYTE;
    stop: INT;
  END_VAR
  VAR_TEMP
    tmp : USINT;
  END_VAR

  pt := ADR(dec);
  stop := LEN(DEC);
  FOR I := 1 TO stop DO
    (* read the first character and subtract 48 to get value in decimal 0 = 48 *)
    x := pt^;
    (* calculate the value of the digit *)
    IF X > 47 AND x < 58 THEN
      tmp := tmp * 10 + X - 48;
    END_IF;
    pt := pt + 1;
  END_FOR;
  DEC_TO_BYTE := USINT_TO_BYTE(tmp);

(* revision history
  hm  20. jun. 2008 rev 1.0
    original release

  hm  30. sep.2008  rev 1.1
    changed length of input string from 20 to 10
    corrected an error where decoding of characters 8 and 9 would fail
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION DEC_TO_DWORD : DWORD
(*
  DEC_TO_DWORD converts a decimal string into a DWORD.

  version 1.1 30. sep. 2008
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    DEC : STRING[20];
  END_VAR
  VAR
    pt : PTR_TO USINT; //BYTE;
    i: INT;
    X: USINT; //BYTE;
    stop: INT;
  END_VAR
  VAR_TEMP
    tmp : UDINT;
  END_VAR

  pt := ADR(dec);
  stop := LEN(dec);
  FOR I := 1 TO stop DO
    (* read the first character and subtract 48 to get value in decimal 0 = 48 *)
    x := pt^;
    (* calculate the value of the digit *)
    IF X > 47 AND x < 58 THEN
      tmp := tmp * 10 + USINT_TO_UDINT(X) - 48;
    END_IF;
    pt := pt + 1;
  END_FOR;
  DEC_TO_DWORD := UDINT_TO_DWORD(tmp);

(* revision history
  hm  20. jun. 2008 rev 1.0
    original release

  hm  30. sep. 2008 rev 1.1
    corrected an error where decoding of characters 8 and 9 would fail
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION DEC_TO_INT : INT
(*
  DEC_TO_INT converts a decimal string into an Integer.

  version 1.1 30. sep. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    DEC : STRING[10];
  END_VAR
  VAR
    pt : PTR_TO USINT; //BYTE;
    i: INT;
    X: USINT; //BYTE;
    sign: BOOL;
    stop: INT;
  END_VAR
  VAR_TEMP
    tmp : INT;
  END_VAR

  pt := ADR(dec);
  stop := LEN(dec);
  FOR I := 1 TO stop DO
    (* read the first character and subtract 48 to get value in decimal 0 = 48 *)
    x := pt^;
    (* calculate the value of the digit *)
    IF X > 47 AND x < 58 THEN
      tmp := tmp * 10 + USINT_TO_INT(X) - 48;
    ELSIF X = 45 AND tmp = 0 THEN
      sign := TRUE;
    END_IF;
    pt := pt + 1;
  END_FOR;
  IF sign THEN tmp := -tmp; END_IF;
  DEC_TO_INT := tmp;

(* revision history
  hm  20. jun. 2008 rev 1.0
    original release

  hm  30. sep. 2008 rev 1.1
    changed length of input string from 20 to 10
    corrected an error where decoding of characters 8 and 9 would fail
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION DEL_CHARS : STRING[STRING_LENGTH]
(*
  del_chars deletes all characters from a string which are specified in CX.

  version 1.0 18. jun. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    IN : STRING[STRING_LENGTH];
    CX : STRING[80];
  END_VAR
  VAR
    pos: INT := 1;
    stop: INT;
  END_VAR
  VAR_TEMP
    tmp : STRING[2];
  END_VAR

  (* copy input string *)
  DEL_CHARS := IN;
  stop := LEN(in);
  WHILE pos <= stop DO
    tmp := MID(DEL_CHARS, 1, pos);
    IF FIND(cx, tmp) > 0 THEN
      (* wrong chracter needs to be deleted *)
      DEL_CHARS := DELETE(DEL_CHARS, 1, pos);
      stop := stop - 1; (* the string is one character shorter now *)
    ELSE
      (* character not found skip to next one *)
      pos := pos + 1;
    END_IF;
  END_WHILE;

(* revision history
  hm    18. jun. 2008 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION MONTH_TO_STRING : STRING[10]
(*
  MONTH_TO_STRING converts an Integer 1..12 into a String with the Names of the corresponding Month.
  the decoding is according to the language setup in global vars

  version 1.1 19. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    MTH : INT;
    LANG : INT;
    LX : INT;
  END_VAR
  VAR
    ly : INT;
  END_VAR

  IF LANG = 0 THEN Ly := LANGUAGE.DEFAULT; ELSE ly := MIN(LANG, language.LMAX); END_IF;
  IF MTH < 1 OR MTH > 12 THEN
    RETURN;
  ELSIF LX = 0 THEN
    MONTH_TO_STRING := language.MONTHS[ly, MTH];
  ELSIF Lx = 3 THEN
    MONTH_TO_STRING := language.MONTHS3[ly, MTH];
  END_IF;

(* revisison history
  hm  21. sep. 2008 rev 1.0
    original version

  hm  19. oct. 2008 rev 1.1
    changed language setup constants
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION WEEKDAY_TO_STRING : STRING[10]
(*
  WEEKDAY_TO_STRING converts an Integer 1..7 into a String with the Names of the corresponding weekday.
  the decoding is according to the language setup in global vars

  version 1.1 19. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    WDAY : INT;
    LANG : INT;
    LX : INT;
  END_VAR
  VAR
    ly : INT;
  END_VAR

  IF LANG = 0 THEN ly := LANGUAGE.DEFAULT; ELSE ly := MIN(LANG, LANGUAGE.LMAX); END_IF;
  IF wday < 1 OR wday > 7 THEN
    RETURN;
  ELSIF LX = 0 THEN
    WEEKDAY_TO_STRING := language.WEEKDAYS[ly, WDAY];
  ELSIF Lx = 2 THEN
    WEEKDAY_TO_STRING := language.WEEKDAYS2[ly, WDAY];
  END_IF;

(* revisison history
  hm  21. sep. 2008 rev 1.0
    original version

  hm  19. oct. 2008 rev 1.1
    changed language setup constants
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION DT_TO_STRF : STRING
(*
  DT_TO_STRF converts a DATETIME input to a formatted string

  version 1.1 19. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    DTI : DT;
    MS : INT;
    FMT : STRING;
    LANG : INT;
  END_VAR
  VAR CONSTANT
    FILL : STRING[1] := '0';
    BLANK : STRING[1] := ' ';
  END_VAR
  VAR
    ly : INT;
    dx: DATE;
    fs: STRING[10];
    td: TOD;
    tmp : INT;
    pos : INT;
    f : INT;
  END_VAR
  VAR_TEMP
    out : STRING;
  END_VAR
  IF LANG < 1 THEN ly := language.DEFAULT; ELSE ly := MIN(language.LMAX, LANG); END_IF;

  (* decode date and time information *)
  dx := DT_TO_DATE(DTI);
  td := DT_TO_TOD(DTI);

  (* parse the format string *)
  out := FMT;
  pos := FIND(out, '#');
  WHILE pos > 0 DO
    (* retrieve format identifier *)
    f := BYTE_TO_INT( CODE(out, pos + 1));
    (* generate the return string according to the format character *)
    fs := '';
    CASE f OF
      65 : (* letter A retunrs the year in 4 digits *)
        fs := INT_TO_STRING(YEAR_OF_DATE1(dx));
      66 : (* letter B returns the year in exactly 2 digits *)
        fs := RIGHT(INT_TO_STRING(YEAR_OF_DATE1(dx)),2);
      67 : (* letter C returns the month with 1 or 2 digits *)
        fs := INT_TO_STRING(MONTH_OF_DATE1(dx));
      68 : (* letter D returns the month with exactly 2 digits *)
        fs := INT_TO_STRING(MONTH_OF_DATE1(dx));
        IF LEN(fs) < 2 THEN fs := CONCAT('0', fs); END_IF;
      69 : (* letter E returns the month with 3 characters *)
        fs := MONTH_TO_STRING(MONTH_OF_DATE1(dx), ly, 3);
      70 : (* letter F returns the month with all characters *)
        fs := MONTH_TO_STRING(MONTH_OF_DATE1(dx), ly, 0);
      71 : (* letter G returns the day with up to 2 digits *)
        fs := INT_TO_STRING(DAY_OF_MONTH1(dx));
      72 : (* letter H returns the day of the month with exactly 2 digits *)
        fs := INT_TO_STRING(DAY_OF_MONTH1(dx));
        IF LEN(fs) < 2 THEN fs := CONCAT(FILL, fs); END_IF;
      73 : (* letter I returns the weekday as the number 1..7 1 = monday *)
        fs := INT_TO_STRING(DAY_OF_WEEK1(dx));
      74 : (* letter J returns the weekday in 2 character writing *)
        fs := WEEKDAY_TO_STRING(DAY_OF_WEEK1(dx), ly, 2);
      75 : (* letter K returns the weekday with all characters *)
        fs := WEEKDAY_TO_STRING(DAY_OF_WEEK1(dx), ly, 0);
      76 : (* letter L returns AM or PM for the given DateTime *)
        IF td >= TOD#12:00:00.0 THEN fs := 'PM'; ELSE fs := 'AM'; END_IF;
      77 : (* letter M returns the hour in 1 or 2 digit form 0..24h *)
        fs := INT_TO_STRING(HOUR(td));
      78 : (* letter N returns the hour in exactly 2 digit form 0..24h *)
        fs := INT_TO_STRING(HOUR(td));
        IF LEN(fs) < 2 THEN fs := CONCAT(FILL, fs); END_IF;
      79 : (* letter O returns the hour in 1 or 2 digit form 0..12h *)
        tmp := HOUR(td) MOD 12;
        IF tmp = 0 THEN tmp := 12; END_IF;
        fs := INT_TO_STRING(tmp);
      80 : (* letter P returns the hour in exactly 2 digit form 0..12h *)
        tmp := HOUR(td) MOD 12;
        IF tmp = 0 THEN tmp := 12; END_IF;
        fs := INT_TO_STRING(tmp);
        IF LEN(fs) < 2 THEN fs := CONCAT(FILL, fs); END_IF;
      81 : (* letter Q returns the minute of the hour in 1 or two digit form *)
        fs := INT_TO_STRING(MINUTE(td));
      82 : (* letter R returns the minute of the hour in exactly two digit form *)
        fs := INT_TO_STRING(MINUTE(td));
        IF LEN(fs) < 2 THEN fs := CONCAT(FILL, fs); END_IF;
      83 : (* letter S returns the second of the minute in 1 or two digit form *)
        fs := INT_TO_STRING(REAL_TO_INT(SECOND(td)));
      84 : (* letter T returns the second of the minute in exactly two digit form *)
        fs := INT_TO_STRING(REAL_TO_INT(SECOND(td)));
        IF LEN(fs) < 2 THEN fs := CONCAT(FILL, fs); END_IF;
      85 : (* letter U returns the milliseconds in 1 to 3 digits *)
        fs := INT_TO_STRING(MS);
      86 : (* letter V returns the milliseconds in exactly 3 digit form *)
        fs := INT_TO_STRING(MS);
        fs := CONCAT('00',fs);
        fs := RIGHT(fs, 3);
      87 : (* letter W returns the day of the month with exactly 2 digits first digit is filled with blank if necessary *)
        fs := INT_TO_STRING(DAY_OF_MONTH1(dx));
        IF LEN(fs) < 2 THEN fs := CONCAT(BLANK, fs); END_IF;
      88 : (* letter X returns the month with exactly 2 digits first digit is filled with blank if necessary *)
        fs := INT_TO_STRING(MONTH_OF_DATE1(dx));
        IF LEN(fs) < 2 THEN fs := CONCAT(BLANK, fs); END_IF;
      END_CASE;
    out := REPLACE(out, fs, 2, pos);
    pos := FIND(out, '#');
  END_WHILE;
  DT_TO_STRF := out;
  
(* revision history
  hm  7. oct. 2008  rev 1.0
    original version

  hm  19. oct. 2008 rev 1.1
    changed language setup constants
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION DWORD_TO_STRB : STRING[32]
(*
  DWORD_TO_STRINGB converts a DWORD to a String of Bits represented by '0' and '1' s.
  The lowest order bit will be on the right and the high order bit on the left.

  version 1.3 20. jun. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    IN : DWORD;
  END_VAR
  VAR
    pt : PTR_TO USINT; //BYTE;
    i: INT;
  END_VAR

  (* pointer für die ausgabe ermitteln *)
  pt := ADR(DWORD_TO_STRB);

  (* die 8 ausgabecharacter ermitteln und schreiben *)
  FOR i := 1 TO 32 DO
    pt^:= BOOL_TO_USINT(in.31) + 48;
    in := SHL(in,1);
    pt := pt + 1;
  END_FOR;

  (* der ausgabestring muss nochg mit 0 abgeschlossen werden *)
  pt^ := 0;

(* revision history
  hm    9.6.2007  rev 1.0
    original version

  hm    15.dec 2007 rev 1.1
    changed code for better performance

  hm  29. mar. 2008 rev 1.2
    changed STRING to STRING(32)

  hm  20. jun. 2008 rev 1.3
    performance improvement
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION FILL : STRING[STRING_LENGTH]
(*
  the function fill creates a string at length L of characters C.

  version 1.1 17. dec. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    C : BYTE;
    L : INT;
  END_VAR
  VAR
    i: INT;
    sx: STRING[1];
  END_VAR

  Sx := CHR_TO_STRING(c);
  (* limit L to maximum 80 characters the length of a standard string *)
  L := LIMIT(0,L,STRING_LENGTH); FILL := '';
  (* create a string of characters to be connected to str *)
  FOR i := 1 TO 8 DO
    FILL := CONCAT(FILL,FILL);
    IF L.7 THEN FILL := CONCAT(FILL,Sx); END_IF;
    L := WORD_TO_INT(SHL(INT_TO_WORD(L),1));
  END_FOR;

(* revision history
  hm  29. mar. 2008 rev 1.0
    original release

  hm  17. dec. 2008 rev 1.1
    changed function chr to chr_to_string
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION FIX : STRING[STRING_LENGTH]
(*
  the function fix truncates a string at length L
  or if the string is shorter then L it will be filled with ending Spaces till its length = N.

  version 1.0 29. mar. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
    L : INT;
    C : BYTE;
    M : INT;
  END_VAR
  VAR
    N : INT;
    SX: STRING[STRING_LENGTH];
  END_VAR

  (* make sure L does not exceed the limits of a string *)
  N := LIMIT(0,L,STRING_LENGTH) - LEN(str);
  IF N <= 0 THEN
    (* truncate the string at length N *)
    IF M = 1 THEN
      FIX := RIGHT(str,L);
    ELSE
      FIX := LEFT(str,L);
    END_IF;
  ELSIF M = 1 THEN
    (* connect fill characters at the beginning *)
    sx := FILL(C,N);
    FIX := CONCAT(sx,str);
  ELSIF M = 2 THEN
    (* center str beween fill characters *)
    (* for an uneven number of fill characters, there is one more at the end *)
    sx := FILL(C,WORD_TO_INT(SHR(INT_TO_WORD(N+1),1)));
    FIX := CONCAT(str,sx);
    SX := LEFT(sx,WORD_TO_UINT(SHR(INT_TO_WORD(N),1)));
    FIX := CONCAT(sx,FIX);
  ELSE
    (* connect fill characters at the end *)
    SX := FILL(C,N);
    FIX := CONCAT(str,SX);
  END_IF;

(* revision history
  hm  29. mar. 2008 rev 1.0
    original release
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION DWORD_TO_STRF : STRING[20]
(*
  dword_to_strF converts a DWORD, BYTE or Word to a fixed length String.
  the string will be filled with leading zeroes to achieve the fixed length, or if too long, the lowest digits will be used.
  the maximum allowed length is 20 mdigits.
  for example:  dword_to_strf(123,4) = '0123'
                dword_to_strf(123,2) = '23'

  version 1.0 26 jan 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IN : DWORD;
    N : INT;
  END_VAR

  (* limit N to max 20 characters *)
  (* convert dword to string first and cut to length N *)
  DWORD_TO_STRF := FIX(DWORD_TO_STRING(in),LIMIT(0,N,20),48,1);

(* revision history
  hm  26. jan.2007  rev 1.0
    original version

  hm  29. mar. 2008 rev 1.1
    changed STRING to STRING(20)
    limit the output string to max 20 digits
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION DWORD_TO_STRH : STRING[8]
(*
  DWORD_TO_STRINGH converts a DWORD to a String of Hexadecimal represented by '0' .. '9' and 'A' .. 'F'.
  The lowest order Character will be on the right and the high order Character on the left.

  version 1.3 29. mar. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    IN : DWORD;
  END_VAR
  VAR
    i : INT;
    temp : USINT; //BYTE;
    pt : PTR_TO USINT; //BYTE;
  END_VAR

  (* read output adress to pointer *)
  pt := ADR(DWORD_TO_STRH) + 8;

  (* wirte the closing byte for the string *)
  pt^:= 0;

  (* write the 8 hex characters backwards *)
  FOR i := 1 TO 8 DO;
    (* decrement the pointer *)
    pt := pt - 1;
    (* read the lowest order hex value *)
    temp := DWORD_TO_USINT(in AND DWORD#16#0000000F);
    (* convert value to hex character *)
    IF temp <= 9 THEN temp := temp + 48; ELSE temp := temp + 55; END_IF;
    (* write character to output string *)
    PT^ := temp;
    (* shift in for nect hex character *)
    in := SHR(in,4);
  END_FOR;

(* code before rev 1.2
  FOR i := 1 TO 8 DO
    X := DWORD_TO_BYTE(in AND 2#1111);
    IF X <= 9 THEN X := X + 48; ELSE X := X + 55; END_IF;
    Cx := CHR(X);
    temp := CONCAT(Cx, temp);
    in := SHR(in,4);
  END_FOR;
  DWORD_TO_STRH := temp;
*)

(* revision history
  hm  9. jun. 2007  rev 1.0
    original version

  hm  11. sep. 2007 rev 1.1
    changed coding for compatibility with twincat, concat cannot support a function as an argument.

  hm  15. dec. 2007 rev 1.2
    changed code for better performance

  hm  29. mar. 2008 rev 1.3
    changed STRING to STRING(8)
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION UPPERCASE : STRING[STRING_LENGTH]
(*
  uppercase returns str while all letters a..z and ä,ö,ü are converted to uppercase

  version 1.3 29. mar. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
  END_VAR
  VAR
    pt : PTR_TO BYTE;
    pos: INT;
    l: INT;
  END_VAR

  pt := ADR(UPPERCASE);
  UPPERCASE := str;
  l := LEN(str);
  FOR pos := 1 TO l DO
    pt^ := TO_UPPER(pt^);
    pt := pt + 1;
  END_FOR;

(* revision history
  hm  6. oct. 2006  rev 1.0
    original release

  hm  4. feb. 2008  rev 1.1
    improved performance
    added Ä,Ö,Ü

  hm  6. mar. 2008  rev 1.2
    added support for exteded Ascii

  hm  29. mar. 2008 rev 1.3
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION TRIM : STRING[STRING_LENGTH]
(*
  the function deletes all blanks within a string.

  version 1.2 29. mar. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
  END_VAR
  VAR
    pos: INT;
  END_VAR

  TRIM := str;
  REPEAT
    pos := FIND(TRIM,' ');
    IF pos > 0 THEN TRIM := REPLACE(TRIM,'',1,pos); END_IF;
  UNTIL pos = 0 END_REPEAT;

(* revision history
  hm  6.10.2006   rev 1.0
    original release

  hm  20. mar. 2008 rev 1.1
    avoid to call replace with pos = 0 because some systems will produce an error

  hm  29. mar. 2008 rev 1.2
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION FINDB_NONUM : INT
(*
  findB_noNum searches str backwards and returns the last position which is not a number.
  a number is characterized by a letter "0..9" or "."

  version 1.3 21. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
  END_VAR
  VAR
    pos: INT;
    pt : PTR_TO USINT; //BYTE;
  END_VAR

  pt := ADR(str) + LEN(str) - 1;
  FOR pos := LEN(str) TO 1 BY -1 DO;
    IF (PT^ < 48 AND PT^ <> 46) OR PT^ > 57 THEN
      FINDB_NONUM := pos;
      RETURN;
    END_IF;
    PT := PT - 1;
  END_FOR;
  FINDB_NONUM := 0;

(* revision history
  hm  6. oct 2006   rev 1.0
    original version

  hm  29. feb 2008  rev 1.1
    improved performance

  hm  29. mar. 2008 rev 1.2
    changed STRING to STRING[STRING_LENGTH]

  hm  21. oct. 2008 rev 1.3
    optimized code
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION FINDB_NUM : INT
(*
  findB_Num searches str backward and returns the last position of a number
  a number is characterized by a letter "0..9" or "."

  version 1.2 29. mar. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
  END_VAR
  VAR
    pos: INT;
    pt : PTR_TO USINT; //BYTE;
  END_VAR

  pt := ADR(str) + LEN(str) - 1;
  FOR pos := LEN(str) TO 1 BY -1 DO;
    IF (PT^ > 47 AND PT^ < 58) OR PT^ = 46 THEN
      FINDB_NUM := pos;
      RETURN;
    END_IF;
    PT := PT - 1;
  END_FOR;
  FINDB_NUM := 0;

(* revision history
  hm  6. oct 2006   rev 1.0
    original version

  hm  29. feb 2008  rev 1.1
    improved performance

  hm  29. mar. 2008 rev 1.2
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION EXEC : STRING[STRING_LENGTH]
(*
  exec executes a mathematical term and returns the result as a string
  the term can only be a simple term without brackets and only one operator
  allowed operastors are: (+, -, *, /, ^, sqrt, sin, cos, tan).

  version 1.4 29. mar. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
  END_VAR
  VAR
    pos: INT;
    R1: REAL;
    R2: REAL;
    operator: STRING[10];
  END_VAR
  VAR_TEMP
    out : STRING[STRING_LENGTH];
    tmp : STRING[STRING_LENGTH];
    tmpr : REAL;
  END_VAR

  (* extract both numbers and operator *)
  out := UPPERCASE(TRIM(str));

  pos := FINDB_NONUM(out);
  IF pos > 1 THEN
    tmp := LEFT(out,pos-1);
    R1 := STRING_TO_REAL(tmp);
  END_IF;
  tmp := RIGHT(out,LEN(out)-pos);
  R2 := STRING_TO_REAL(tmp);
  out := LEFT(out,pos);
  pos := FINDB_NUM(out);
  operator := RIGHT(out,LEN(out) - pos);
  IF operator = '' AND LEN(str) = 0 THEN
    out := '';
    RETURN;
  ELSIF operator = '' THEN
    out := str;
    RETURN;
  END_IF;
  IF operator = '^' THEN
    tmpr := EXPT(R1, R2);
    out := REAL_TO_STRING(tmpr);
  ELSIF operator = 'SQRT' THEN
    tmpr := SQRT(R2);
    out := REAL_TO_STRING(tmpr);
  ELSIF operator = 'SIN' THEN
    tmpr := SIN(r2);
    out := REAL_TO_STRING(tmpr);
  ELSIF operator = 'COS' THEN
    tmpr := COS(r2);
    out := REAL_TO_STRING(tmpr);
  ELSIF operator = 'TAN' THEN
    tmpr := TAN(R2);
    out := REAL_TO_STRING(tmpr);
  ELSIF operator = '*' THEN
    tmpr := R1 * R2;
    out := REAL_TO_STRING(tmpr);
  ELSIF operator = '/' THEN
    IF R2 <> 0.0 THEN
      tmpr := R1 / R2;
      out := REAL_TO_STRING(tmpr);
    ELSE
      out := 'ERROR';
    END_IF;
  ELSIF operator = '+' THEN
    tmpr := r1 + r2;
    out := REAL_TO_STRING(tmpr);
  ELSIF operator = '-' THEN
    tmpr := r1 - r2;
    out := REAL_TO_STRING(tmpr);
  ELSE
    out := 'ERROR';
  END_IF;

  IF out = 'ERROR' THEN
    RETURN;
  (* some systems deliver integer instead of real *)
  ELSIF FIND(out,'.') = 0 THEN
    out := CONCAT(out, '.0');
  (* some systems deliver n. instead of n.0 ! *)
  ELSE
    tmp := RIGHT(out,1);
    IF tmp = '.' THEN out := CONCAT(out,'0'); END_IF;
  END_IF;
  EXEC := out;
  
(* revision history
  hm  6.feb 2007    rev 1.1
    cos has to be written in uppercase
    divide by 0 will return an error

  hm  5. mar. 2008  rev 1.2
    add a 0 to the string if a '.' is at the end of the string

  hm  20. mar. 2008 rev 1.3
    make sure the function always returns a real value in the form of x.y

  hm  29. mar. 2008 rev 1.4
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION



(* @PATH := '\/String' *)
FUNCTION FIND_CHAR : INT
(*
  find_char searches str and returns the starting position of the first character that is not a control character.
  control characters are the ascii character 00 .. 31 and 127

  version 1.3 21. oct. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
    pos : INT;
  END_VAR
  VAR
    i: INT;
    pt : PTR_TO OSCAT_BASIC_ARRAY1_255_OF_BYTE; //ARRAY[1..255] OF BYTE;
    stop: INT;
    X: BYTE;
  END_VAR

  pt := ADR(str);
  stop := LEN(str);
  FOR i := MAX(pos,1) TO stop DO;
    X := pt^[i];
    IF (X > 31) AND ((setup.EXTENDED_ASCII AND (X <> 127)) OR (NOT setup.EXTENDED_ASCII AND (X < 127))) THEN
      FIND_CHAR := i;
      RETURN;
    END_IF;
  END_FOR;
  FIND_CHAR := 0;

(* revision history
  hm  29. feb 2008  rev 1.0
    original version

  hm  26. mar. 2008 rev 1.1
    char will now accept extended ascii

  hm  29. mar. 2008 rev 1.2
    changed STRING to STRING[STRING_LENGTH]

  hm  21. oct. 2008 rev 1.3
    changes setup constants
    optimized code
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION FIND_CTRL : INT
(*
  find_ctrl searches str and returns the starting position of a control character
  control characters are the ascii character 00 .. 31 and 127.

  version 1.2 29. mar. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
    pos : INT;
  END_VAR
  VAR
    i: INT;
    pt : PTR_TO OSCAT_BASIC_ARRAY1_255_OF_BYTE; //ARRAY[1..255] OF BYTE;
    stop: INT;
    x: BYTE;
  END_VAR

  pt := ADR(str);
  stop := LEN(str);
  FOR i := MAX(pos,1) TO stop DO;
    x := PT^[I];
    IF (x < 32) OR (X = 127) THEN
      FIND_CTRL := i;
      RETURN;
    END_IF;
  END_FOR;
  FIND_CTRL := 0;

(* revision history
  hm  29. feb 2008  rev 1.0
    original version

  hm  26. mar. 2008 rev 1.1
    character 127 is now recognized as control

  hm  29. mar. 2008 rev 1.2
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION FIND_NONUM : INT
(*
  find_noNum searches str and returns the first position which is not a number.
  a number is characterized by a letter "0..9" or "."

  version 1.3 21. oct. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
    pos : INT;
  END_VAR
  VAR
    i: INT;
    pt : PTR_TO OSCAT_BASIC_ARRAY1_255_OF_BYTE; //ARRAY[1..255] OF BYTE;
    end: INT;
    X: USINT; //BYTE;
  END_VAR

  pt := ADR(str);
  end := LEN(str);
  FOR i := MAX(pos,1) TO end DO;
    X := BYTE_TO_USINT(pt^[i]);
    IF (X < 48 AND X <> 46) OR X > 57 THEN
      FIND_NONUM := i;
      RETURN;
    END_IF;
  END_FOR;
  FIND_NONUM := 0;

(* revision history
  hm  6. oct. 2006  rev 1.0
    original version

  hm  29. feb 2008  rev 1.1
    added input pos to start search at position

  hm  29. mar. 2008 rev 1.2
    changed STRING to STRING[STRING_LENGTH]

  hm  21. oct. 2008 rev 1.3
    optimized code
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION FIND_NUM : INT
(*
  find_Num searches str and returns the starting position of a number
  a number is characterized by a letter "0..9" or "."

  version 1.2 29. mar. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
    pos : INT;
  END_VAR
  VAR
    i : INT;
    pt : PTR_TO OSCAT_BASIC_ARRAY1_255_OF_BYTE; // ARRAY[1..255] OF BYTE;
    stop : INT;
    X: USINT; //BYTE;
  END_VAR

  pt := ADR(str);
  stop := LEN(str);
  FOR i := MAX(pos,1) TO stop DO;
    X := BYTE_TO_USINT(pt^[i]);
    IF (X > 47 AND X < 58) OR X = 46 THEN
      FIND_NUM := i;
      RETURN;
    END_IF;
  END_FOR;
  FIND_NUM := 0;

(* revision history
  hm  6. oct. 2006  rev 1.0
    original version

  hm  29. feb 2008  rev 1.1
    added input pos to start search at position

  hm  29. mar. 2008 rev 1.2
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION FINDB : INT
(*
  the function find searches an str1 for the presence of str2 and returns the first position of str1 of the last presence in instring.
  the function is similar to find except it searches from the right to left.
   a 0 is returned if the string is not found.

  version 1.3 29. mar. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    str1 : STRING[STRING_LENGTH];
    str2 : STRING[STRING_LENGTH];
  END_VAR
  VAR
    pos: INT;
    length: INT;
  END_VAR
  VAR_TEMP
    tmp : STRING[STRING_LENGTH];
  END_VAR

  length := LEN(str2);
  FOR pos := LEN(str1) - length + 1 TO 1 BY -1 DO
    tmp := MID(str1,length,pos);
    IF tmp = str2 THEN
      FindB := pos;
      RETURN;
    END_IF;
  END_FOR;
  FindB := 0;

(* revision history
  hm  6. oct 2006   rev 1.0
    original version

  hm  15 dec 2007   rev 1.1
    changed code for better performance

  hm  29. feb 2008  rev 1.2
    added findb := 0 for compatibility reasons

  hm  29. mar. 2008 rev 1.3
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION FINDP : INT
(*
  the function findP searches a string str for the occurence of src beginning at the position pos.

  version 1.2 29. mar. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
    src : STRING[STRING_LENGTH];
    pos: INT;
  END_VAR
  VAR
    i: INT;
    ls: INT;
    lx: INT;
    stp: INT;
  END_VAR
  VAR_TEMP
    tmp : STRING[STRING_LENGTH];
  END_VAR

  ls := LEN(str);
  lx := LEN(src);
  IF ls < lx OR lx = 0 THEN RETURN; END_IF;
  stp := ls - lx + 1;
  FOR i := MAX(pos,1) TO stp DO
    tmp := MID(str,lx,i);
    IF tmp = src THEN
      FINDP := i;
      RETURN;
    END_IF;
  END_FOR;
  FINDP := 0;

(* revision history
  hm  4. feb. 2008  rev 1.0
    original release

  hm  29. feb 2008  rev 1.1
    ADDED MAX(pos,1) in loop initialization

  hm  29. mar. 2008 rev 1.2
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION FLOAT_TO_REAL : REAL
(*
  FLOAT_TO_REAL converts a string to a REAL.
  the function ignores all wrong characters.
  the comma can be , or .
  the exponent has to start with capital E or lowercase e .

  version 1.3 23. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    FLT : STRING[20];
  END_VAR
  VAR
    pt : PTR_TO OSCAT_BASIC_ARRAY1_255_OF_BYTE; //ARRAY[1..20] OF BYTE;
    i: INT;
    X: USINT; //BYTE;
    sign: INT := 1;
    stop: INT;
    tmp: DINT;
    d : INT;
  END_VAR
  VAR_TEMP
    str : STRING[20];
  END_VAR

  pt := ADR(FLT);
  stop := LEN(FLT);

  (* we first check for sign and exit if first number or dot is reached *)
  FOR i := 1 TO stop DO
    X := BYTE_TO_USINT(pt^[i]);
    IF X > 47 AND X < 58 OR X = 46 THEN
      EXIT;
    ELSIF X = 45 THEN
      (* code 45 is sign *)
      sign := -1;
    END_IF;
  END_FOR;

  (* now we scan numbers till end or dot or E is reached *)
  FOR i := i TO stop DO
    X := BYTE_TO_USINT(pt^[i]);
    IF X = 44 OR X = 46 OR X = 69 OR X = 101 THEN
      EXIT;
    (* calculate the value of the digit *)
    ELSIF X > 47 AND x < 58 THEN
      tmp := tmp * 10 + USINT_TO_DINT(X) - 48;
    END_IF;
  END_FOR;

  (* process the portion after the comma if comma or dot is reached exit if exponent starts *)
  IF (x = 44) OR (X = 46) THEN
    FOR i := i + 1 TO stop DO
      X := BYTE_TO_USINT(pt^[i]);
      IF (X = 69) OR (X = 101) THEN
        EXIT;
      ELSIF (x > 47) AND (x < 58) THEN
        tmp := tmp * 10 + USINT_TO_DINT(X) - 48;
        d := d - 1;
      END_IF;
    END_FOR;
  END_IF;

  (* process exponent if present *)
  IF (X = 69) OR (X = 101) THEN
    str := RIGHT(FLT, stop - i);
    d := d + DEC_TO_INT(str);
  END_IF;

  FLOAT_TO_REAL :=  EXPN(10.0, d) * DINT_TO_REAL(TMP * INT_TO_DINT(SIGN));

(* revision history
  hm  22. jun. 2008 rev 1.0
    original release

  hm  2. oct. 2008  rev 1.1
    fixed an error, characters 8 and 9 would not be converted

  hm  22. oct. 2008 rev 1.2
    last fix was not done correctly

  hm  23. oct. 2008 rev 1.3
    optimzed code
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION OCT_TO_BYTE : BYTE
(*
  OCT_TO_BYTE converts a octagonal string into a byte.

  version 1.1 20. sep. 2008
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    OCT : STRING[10];
  END_VAR
  VAR
    pt : PTR_TO BYTE;
    i: INT;
    X: USINT; //BYTE;
    stop: INT;
  END_VAR

  pt := ADR(oct);
  stop := LEN(oct);
  OCT_TO_BYTE := 0;
  FOR I := 1 TO stop DO
    (* read the first character and subtract 48 to get value in decimal 0 = 48 *)
    x := BYTE_TO_USINT(pt^);
    (* calculate the value of the digit *)
    IF (X > 47) AND (x < 56) THEN
      OCT_TO_BYTE := USINT_TO_BYTE( BYTE_TO_USINT(SHL( OCT_TO_BYTE,3)) + X - 48);
    END_IF;
    pt := pt + 1;
  END_FOR;

(* revision history
  hm  18. jun. 2008 rev 1.0
    original release

  hm  20. sep. 2008 rev 1.1
    changed length of input string from 20 to 10
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION HEX_TO_BYTE : BYTE
(*
  HEX_TO_BYTE converts a Hexadecimal string into a byte.

  version 1.1 20. sep. 2008
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    HEX : STRING[5];
  END_VAR
  VAR
    pt : PTR_TO BYTE;
    i: INT;
    X: USINT; //BYTE;
    stop: INT;
  END_VAR

  pt := ADR(hex);
  stop := LEN(hex);
  HEX_TO_BYTE := 0;
  FOR I := 1 TO stop DO
    (* read the first character and subtract 48 to get value in decimal 0 = 48 *)
    x := BYTE_TO_USINT(pt^);
    (* calculate the value of the digit *)
    IF (X > 47) AND (x < 58) THEN
      HEX_TO_BYTE := USINT_TO_BYTE( BYTE_TO_USINT(SHL(HEX_TO_BYTE,4)) + X - 48);
    ELSIF (X > 64) AND (X < 71) THEN
      HEX_TO_BYTE := USINT_TO_BYTE( BYTE_TO_USINT(SHL(HEX_TO_BYTE,4)) + X - 55);
    ELSIF (X > 96) AND (X < 103) THEN
      HEX_TO_BYTE := USINT_TO_BYTE( BYTE_TO_USINT(SHL(HEX_TO_BYTE,4)) + X - 87);
    END_IF;
    pt := pt + 1;
  END_FOR;

(* revision history
  hm  18. jun. 2008 rev 1.0
    original release

  hm  20. sep.2008  rev 1.1
    changed length of input string from 20 to 5
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION FSTRING_TO_BYTE : BYTE
(*
  FSTRING_TO_BYTE converts a formatted string into a byte.
  the string can be of the form 2#01010, 8#7234, 16#2AD3 and 1234

  version 1.1 20. sep. 2008
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    IN : STRING[12];
  END_VAR
  VAR_TEMP
    tmp : STRING[12];
  END_VAR

  tmp := LEFT(IN, 2);
  IF tmp = '2#' THEN
    (* we need to convert binary *)
    tmp := RIGHT(in, LEN(in) - 2);
    FSTRING_TO_BYTE := BIN_TO_BYTE(tmp);
  ELSIF tmp = '8#' THEN
    (* weneed to convert octals *)
    tmp := RIGHT(in, LEN(in) - 2);
    FSTRING_TO_BYTE := OCT_TO_BYTE(tmp);
  ELSE
    tmp := LEFT(in, 3);
    IF tmp = '16#' THEN
      (* we need to convert hexadecimal *)
      tmp := RIGHT(in, LEN(in) - 3);
      FSTRING_TO_BYTE := HEX_TO_BYTE(tmp);
    ELSE
      (* we assume decimal representation *)
      FSTRING_TO_BYTE := DEC_TO_BYTE(CLEAN(in,'0123456789'));
    END_IF;
  END_IF;

(* revision history
  hm  18. jun. 2008 rev 1.0
    original release

  hm  20. sep. 2008 rev 1.1
    changed length of input string from 20 to 12
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION TO_LOWER : BYTE
(*
  to_lower converts a character from uppercase to lowercase

  version 1.2 25. oct 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IN : BYTE;
  END_VAR

  IF (in > 64) AND (in < 91) THEN
     TO_LOWER := in OR 16#20;
  ELSIF (in > 191) AND (in < 223) AND (in <> 215) AND setup.EXTENDED_ASCII THEN
     TO_LOWER := in OR 16#20;
  ELSE
     TO_LOWER := in;
  END_IF;

(* revision history
  hm  6. mar. 2008  rev 1.0
    original version

  hm  19. oct. 2008 rev 1.1
    changed setup constants

  ks  25. oct. 2008 rev 1.2
    optimized code
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION LOWERCASE : STRING[STRING_LENGTH]
(*
  lowercase returns str while all letters A..Z and Ä.Ö,Ü are converted to lowercase.

  version 1.3 29. mar. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
  END_VAR
  VAR
    PT : PTR_TO BYTE;
    pos: INT;
    l: INT;
  END_VAR

  PT := ADR(LOWERCASE);
  lowercase := str;
  l := LEN(str);
  FOR pos := 1 TO l DO
    PT^ := TO_LOWER(PT^);
    PT := PT + 1;
  END_FOR;

(* revision history
  hm  6. oct. 2006  rev 1.0
    original release

  hm  4. feb. 2008  rev 1.1
    improved performance
    added Ä.Ö,Ü

  hm  6. mar. 2008  rev 1.2
    added support for exteded Ascii

  hm  29. mar. 2008 rev 1.3
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION FSTRING_TO_MONTH : INT
(*
  FSTRING_TO_MONTH converts a string into a month, the string can be a name for the month or a number.
  the function is language sensitve when LANG > 1 and checks for all languages when LANG = 0

  version 1.2 25. oct 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    MTH : STRING[20];
    LANG : INT;
  END_VAR
  VAR
    lx: INT;
  END_VAR
  VAR_TEMP
    tmp : INT;
  END_VAR

  IF LANG = 0 THEN lx := LANGUAGE.DEFAULT; ELSE lx := MIN(LANG, LANGUAGE.LMAX); END_IF;
  MTH := TRIM(mth);
  MTH := CAPITALIZE( LOWERCASE(MTH));

  FOR tmp := 1 TO 12 DO
    IF MTH = language.MONTHS[lx, tmp] THEN FSTRING_TO_MONTH := tmp; RETURN; END_IF;
    IF MTH = language.MONTHS3[lx, tmp] THEN FSTRING_TO_MONTH := tmp; RETURN; END_IF;
  END_FOR;

  (* since no name matched try to decode as integer *)
  FSTRING_TO_MONTH := STRING_TO_INT(MTH);

(* revision history
  hm  25. sep. 2008 rev 1.0
    original release

  hm  19. oct. 2008 rev 1.1
    changed language setup constants

  hm  25. oct. 2008 rev 1.2
    optimized code
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION FSTRING_TO_DT : DT
(*
  FSTRING_TO_DT converts Formatted String into a DT value.

  version 1.0 24. sep. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    SDT : STRING[60];
    FMT : STRING[60];
  END_VAR
  VAR CONSTANT
    ignore: STRING[1] := '*';  (* ignore character is * *)
    fchar : STRING[1] := '#';  (* format character is # *)
  END_VAR
  VAR
    c: STRING[1];
    tmp: STRING[20];
    end: INT;
    dy : INT := 1970;
    dm : INT := 1;
    dd : INT := 1;
    th : INT;
    tm : INT;
    ts : INT;
  END_VAR
  VAR_TEMP
    t : STRING[1];
  END_VAR

  (* scan input string *)
  WHILE fmt <> '' DO
    c := LEFT(fmt,1);
    IF c = ignore THEN
      (* skip ignore characters *)
      fmt := DELETE(fmt,1,1);
      sdt := DELETE(sdt,1,1);
    ELSIF C = fchar THEN
      (* format chracter found skip format char and read identifier *)
      (* store format identifier in c and skip to next char in fmt *)
      c := MID(fmt,1,2);
      fmt := DELETE(fmt,2,1);
      (* extract the substring until the end of sdt or to next char of fmt *)
      IF fmt = '' THEN
        tmp := sdt;
      ELSE
        (* serach for end of substring *)
        t := LEFT(fmt,1);
        end := FIND(sdt, t)-1;
        tmp := LEFT(sdt, end);
        sdt := DELETE(sdt, end,1);
      END_IF;
      (* extract information from substring *)
      IF c = 'Y' THEN
        dy := STRING_TO_INT(tmp);
        IF dy < 100 THEN dy := dy + 2000; END_IF;
      ELSIF c = 'M' THEN
        dm := STRING_TO_INT(tmp);
      ELSIF c = 'N' THEN
        dm := FSTRING_TO_MONTH(tmp,0);
      ELSIF c = 'D' THEN
        dd := STRING_TO_INT(tmp);
      ELSIF c = 'h' THEN
        th := STRING_TO_INT(tmp);
      ELSIF c = 'm' THEN
        tm := STRING_TO_INT(tmp);
      ELSIF c = 's' THEN
        ts := STRING_TO_INT(tmp);
      END_IF;
    ELSE
      t := LEFT(sdt,1);
      IF c = t THEN
        (* skip matching characters *)
        fmt := DELETE(fmt,1,1);
        sdt := DELETE(sdt,1,1);
      ELSE
        RETURN;
      END_IF;
    END_IF;
  END_WHILE;
  FSTRING_TO_DT := SET_DT(dy,dm,dd,th,tm,ts);

(* revision history
  hm  24. sep. 2008 rev 1.0
    original release
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION OCT_TO_DWORD : DWORD
(*
  OCT_TO_DWORD converts a octagonal string into a dword.

  version 1.0 18. jun 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    OCT : STRING[20];
  END_VAR
  VAR
    pt : PTR_TO BYTE;
    i: INT;
    X: USINT; //BYTE;
    stop: INT;
  END_VAR

  pt := ADR(oct);
  stop := LEN(oct);
  OCT_TO_DWORD := 0;
  FOR I := 1 TO stop DO
    (* read the first character and subtract 48 to get value in decimal 0 = 48 *)
    x := BYTE_TO_USINT(pt^);
    (* calculate the value of the digit *)
    IF (X > 47) AND (x < 56) THEN
      OCT_TO_DWORD := UDINT_TO_DWORD( DWORD_TO_UDINT(SHL(OCT_TO_DWORD,3)) + USINT_TO_UDINT(X) - 48);
    END_IF;
    pt := pt + 1;
  END_FOR;

(* revision history
  hm  18. jun. 2008 rev 1.0
    original release
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION HEX_TO_DWORD : DWORD
(*
  HEX_TO_DWORD converts a Hexadecimal string into a DWORD.

  version 1.4 18. jun. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    Hex : STRING[20];
  END_VAR
  VAR
    pt : PTR_TO BYTE;
    i: INT;
    X: BYTE;
    stop: INT;
  END_VAR

  pt := ADR(hex);
  stop := LEN(hex);
  HEX_TO_DWORD := 0;
  FOR I := 1 TO stop DO
    (* read the first character and subtract 48 to get value in decimal 0 = 48 *)
    x := pt^;
    (* calculate the value of the digit *)
    IF (X > 47) AND (x < 58) THEN
      HEX_TO_DWORD := UDINT_TO_DWORD( DWORD_TO_UDINT(SHL(HEX_TO_DWORD,4)) + BYTE_TO_UDINT(X) - 48);
    ELSIF (X > 64) AND (X < 71) THEN
      HEX_TO_DWORD := UDINT_TO_DWORD( DWORD_TO_UDINT(SHL(HEX_TO_DWORD,4)) + BYTE_TO_UDINT(X) - 55);
    ELSIF (X > 96) AND (X < 103) THEN
      HEX_TO_DWORD := UDINT_TO_DWORD( DWORD_TO_UDINT(SHL(HEX_TO_DWORD,4)) + BYTE_TO_UDINT(X) - 87);
    END_IF;
    pt := pt + 1;
  END_FOR;

(* revision history
  hm  2.10.2007   rev 1.0
    original release

  hm  19.11.2007    rev 1.1
    changed type of function from int to dword

  hm  4. mar 2008   rev 1.2
    added support for a..f and return 0 for invalid string

  hm  29. mar. 2008 rev 1.3
    changed STRING to STRING(8)

  hm  18. jun. 2008 rev 1.4
    changed input hex to STRING(20)
    function now ignores wrong characters
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION FSTRING_TO_DWORD : DWORD
(*
  FSTRING_TO_BYTE converts a formatted string into a byte.
  the string can be of the form 2#01010, 8#7234, 16#2AD3 and 1234

  version 1.1 20. sep. 2008
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    IN : STRING[40];
  END_VAR
  VAR_TEMP
    tmp : STRING[40];
  END_VAR

  tmp := LEFT(IN, 2);
  IF tmp = '2#' THEN
    (* we need to convert binary *)
    tmp := RIGHT(in, LEN(in) - 2);
    FSTRING_TO_DWORD := BIN_TO_DWORD(tmp);
  ELSIF tmp = '8#' THEN
    (* weneed to convert octals *)
    tmp := RIGHT(in, LEN(in) - 2);
    FSTRING_TO_DWORD := OCT_TO_DWORD(tmp);
  ELSE
    tmp := LEFT(in, 3);
    IF tmp = '16#' THEN
      (* we need to convert hexadecimal *)
      tmp := RIGHT(in, LEN(in) - 3);
      FSTRING_TO_DWORD := HEX_TO_DWORD(tmp);
    ELSE
      (* we assume decimal representation *)
      FSTRING_TO_DWORD := DEC_TO_DWORD(CLEAN(in,'0123456789'));
    END_IF;
  END_IF;

(* revision history
  hm  18. jun. 2008 rev 1.0
    original release

  hm  20. sep. 2008 rev 1.1
    changed length of input dtring from 20 to 40
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION FSTRING_TO_WEEKDAY : INT
(*
  FSTRING_TO_WEEKDAY converts a weekday string into an integer 1..7.

  version 1.2 25. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    WDAY : STRING[20];
    LANG : INT;
  END_VAR
  VAR
    tmp: STRING[2];
    i: INT;
    ly: INT;
  END_VAR

  IF LANG = 0 THEN ly := LANGUAGE.DEFAULT; ELSE ly := MIN(LANG, LANGUAGE.LMAX); END_IF;
  (* tmp needs to be calculated first otherwise find can return wrong values *)
  tmp := TRIM(wday);
  tmp := CAPITALIZE(LOWERCASE(tmp));
  FOR i := 1 TO 7 DO
    IF language.WEEKDAYS2[ly, i] = tmp THEN
      FSTRING_TO_WEEKDAY := i;
      RETURN;
    END_IF;
  END_FOR;
  FSTRING_TO_WEEKDAY := STRING_TO_INT(WDAY);

(* revision history
  hm  18. jun. 2008 rev 1.0
    original release

  hm  18. jul. 2008 rev 1.1
    changed nested call of left(trim()) for compatibility reasons

  hm  25. oct. 2008 rev 1.2
    using language constants
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION FSTRING_TO_WEEK : BYTE
(*
  FSTRING_TO_WEEK converts a list of weekdays into a byte where each bit represents a day of the week.
  bit 6 = mo, 0 = su;

  version 1.1 25. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    WEEK : STRING[60];
    LANG : INT;
  END_VAR
  VAR
    pos: INT;
  END_VAR
  VAR_TEMP
    tmp : BYTE;
    str : STRING[60];
  END_VAR

  pos := FIND(WEEK, ',');
  WHILE pos > 0 DO
    str := MID( WEEK, pos - 1, 1);
    tmp := tmp OR SHR( BYTE#128, INT_TO_UINT( FSTRING_TO_WEEKDAY(str, LANG)));
    WEEK := RIGHT(WEEK, LEN(Week) - pos);
    pos := FIND(WEEK, ',');
  END_WHILE;
  tmp := (tmp OR SHR(BYTE#128, INT_TO_UINT( FSTRING_TO_WEEKDAY(WEEK, LANG)))) AND BYTE#127;
  FSTRING_TO_WEEK := tmp;
  
(* revision history
  hm  18. jun. 2008 rev 1.0
    original release

  hm  25. oct. 2008 rev 1.1
    using language defauls and input lang
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION ISC_ALPHA : BOOL
(*
  ISC_ALPHA checks if a character is a..z or A..Z.

  version 1.1 19. oct. 2008
  programmer  oscat
  tested by oscat
*)
  VAR_INPUT
    IN : BYTE;
  END_VAR

  IF setup.EXTENDED_ASCII THEN
    ISC_ALPHA := ((in > 64) AND (in < 91)) OR ((in > 191)  AND (in <> 215) AND (in <> 247)) OR ((in > 96) AND (in < 123));
  ELSE
    ISC_ALPHA := ((IN > 64) AND (IN < 91)) OR ((in > 96) AND (in < 123));
  END_IF;

(* revision history
  hm  6. mar. 2008  rev 1.0
    original version

  hm  19. oct. 2008 rev 1.1
    changes setup constants
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION ISC_NUM : BOOL
(*
  ISC_NUM checks if a character is 0..9.

  version 1.0 6. mar 2008
  programmer  oscat
  tested by   hugo
*)
  VAR_INPUT
    IN : BYTE;
  END_VAR

  ISC_NUM := (IN > 47) AND (IN < 58);

(* revision history
  hm    6. mar. 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION IS_ALNUM : BOOL
(*
  ISC_ALNUM testet ob in einem string nur Zahlen 0..9 vorkommen.

  version 1.1 29. mar. 2008
  programmer    kurt
  tested by   hugo
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
  END_VAR
  VAR
    L: INT;
    pt : PTR_TO BYTE;
    pos: INT;
  END_VAR

  PT := ADR(str);
  L := LEN(str);
  FOR pos := 1 TO L DO
    IF NOT (ISC_ALPHA(pt^) OR ISC_NUM(pt^)) THEN
      IS_ALNUM := FALSE;
      RETURN;
    END_IF;
        PT := PT + 1;
  END_FOR;
  IS_ALNUM := L > 0;

(* revision history
  hm  29. feb 2008  rev 1.0
    original version

  hm  29. mar. 2008 rev 1.1
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION IS_ALPHA : BOOL
(*
  IS_ALPHA testet ob in einem string nur Zeichen a-z oder A - Z vorkommen.

  version 1.1 29. mar. 2008
  programmer    kurt
  tested by   hugo
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
  END_VAR
  VAR
    L: INT;
    pt : PTR_TO BYTE;
    pos: INT;
  END_VAR

  PT := ADR(str);
  L := LEN(str);
  FOR pos := 1 TO L DO
    IF NOT ISC_ALPHA(pt^) THEN
      IS_ALPHA := FALSE;
      RETURN;
    END_IF;
        PT := PT + 1;
  END_FOR;
  IS_ALPHA := L > 0;

(* revision history
  hm  29. feb 2008  rev 1.0
    original version

  hm  29. mar. 2008 rev 1.1
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION IS_CC : BOOL
(*
  ISC_CC testet ob ein string nur aus Zeichen des Strings CMP besteht.

  version 1.1 29. mar. 2008
  programmer  Tobias
  tested by hugo
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
    cmp : STRING[STRING_LENGTH];
  END_VAR
  VAR
    L: INT;
    pos: INT;
  END_VAR
  VAR_TEMP
    tmp : STRING[STRING_LENGTH];
  END_VAR

  L := LEN(str);
  FOR pos := 1 TO L DO
    tmp := MID(str,1,pos);
    IF FIND(CMP, tmp) = 0 THEN RETURN; END_IF;
  END_FOR;
  IS_CC := L > 0;

(* revision history
  hm  19. mar 2008  rev 1.0
    original version

  hm  29. mar. 2008 rev 1.1
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION ISC_CTRL : BOOL
(*
  ISC_ALPHA checks if a character is a control character.

  version 1.0 6. mar 2008
  programmer  oscat
  tested by   hugo
*)
  VAR_INPUT
    IN : BYTE;
  END_VAR

  ISC_CTRL := (IN < 32) OR (IN = 127);

(* revision history
  hm    6. mar. 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION IS_CTRL : BOOL
(*
  IS_CTRL testet ob in einem string nur Steuerzeichen (Char < 32) vorkommen.

  version 1.1 29. mar 2008
  programmer    kurt
  tested by   hugo
*)
  VAR_INPUT
    STR : STRING[STRING_LENGTH];
  END_VAR
  VAR
    L: INT;
    pt : PTR_TO BYTE;
    pos: INT;
  END_VAR

  PT := ADR(str);
  L := LEN(str);
  FOR pos := 1 TO L DO
    IF NOT (ISC_CTRL(pt^)) THEN
      IS_CTRL := FALSE;
      RETURN;
    END_IF;
        PT := PT + 1;
  END_FOR;
  IS_CTRL := L > 0;

(* revision history
  hm  29. feb. 2008 rev 1.0
    original version

  hm  29. mar. 2008 rev 1.1
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION ISC_HEX : BOOL
(*
  ISC_HEX checks if a character is 0..9, A..F, a..f.

  version 1.0 6. mar 2008
  programmer  oscat
  tested by   hugo
*)
  VAR_INPUT
    IN : BYTE;
  END_VAR

  ISC_HEX := ((IN > 47) AND (IN < 58)) OR ((IN > 64) AND (IN < 71)) OR ((IN > 96) AND (IN < 103));

(* revision history
  hm    6. mar. 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION IS_HEX : BOOL
(*
  IS_HEX testet ob in einem string nur Zahlen 0..9 oder A..F oder a..f  vorkommen.

  version 1.1 29. mar. 2008
  programmer    kurt
  tested by   hugo
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
  END_VAR
  VAR
    L: INT;
    pt : PTR_TO BYTE;
    pos: INT;
  END_VAR

  PT := ADR(str);
  L := LEN(str);
  FOR pos := 1 TO L DO
    IF NOT (ISC_HEX(pt^)) THEN
      IS_HEX := FALSE;
      RETURN;
    END_IF;
        PT := PT + 1;
  END_FOR;
  IS_HEX := L > 0;

(* revision history
  hm  29. feb 2008  rev 1.0
    original version

  hm  29. mar. 2008 rev 1.1
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION ISC_LOWER : BOOL
(*
  isc_lower checks if a character is lowercase.

  version 1.1 19. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    IN : BYTE;
  END_VAR

  IF setup.EXTENDED_ASCII THEN
    ISC_LOWER := ((in > 96) AND (in < 123)) OR ((in > 222) AND (in <> 247));
  ELSE
    ISC_LOWER := ((in > 96) AND (in < 123));
  END_IF;

(* revision history
  hm  6. mar. 2008  rev 1.0
    original version

  hm  19. oct. 2008 rev 1.1
    changes setup constants
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION IS_LOWER : BOOL
(*
  IS_LOWER testet ob in einem string nur kleinbuchstaben vorkommen.

  version 1.1 29. mar. 2008
  programmer    kurt
  tested by   hugo
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
  END_VAR
  VAR
    l: INT;
    pt : PTR_TO BYTE;
    pos: INT;
  END_VAR

  PT := ADR(str);
  L := LEN(str);
  FOR pos := 1 TO L DO
    IF NOT (ISC_LOWER(pt^)) THEN
      IS_LOWER := FALSE;
      RETURN;
    END_IF;
        PT := PT + 1;
  END_FOR;
  IS_LOWER := L > 0;

(* revision history
  hm  29. feb 2008  rev 1.0
    original version

  hm  29. mar. 2008 rev 1.1
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION IS_NCC : BOOL
(*
  IS_NCC testet ob in einem string keine Zeichen des Strings CMP enthalten sind.

  version 1.1 29. mar. 2008
  programmer  Tobias
  tested by   hugo
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
    cmp : STRING[STRING_LENGTH];
  END_VAR
  VAR
    L: INT;
    pos: INT;
  END_VAR
  VAR_TEMP
    tmp : STRING[1];
  END_VAR

  L := LEN(str);
  FOR pos := 1 TO L DO
    tmp := MID(str,1,pos);
    IF FIND(CMP, tmp) > 0 THEN RETURN; END_IF;
  END_FOR;
  IS_NCC := TRUE;

(* revision history
  hm  19. mar 2008  rev 1.0
    original version

  hm  29. mar. 2008 rev 1.1
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION



(* @PATH := '\/String' *)
FUNCTION IS_NUM : BOOL
(*
  IS_NUM testet ob in einem string nur Zahlen 0..9 vorkommen.

  version 1.1 29. mar. 2008
  programmer    kurt
  tested by   hugo
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
  END_VAR
  VAR
    L : INT;
    pt : PTR_TO BYTE;
    pos: INT;
  END_VAR

  PT := ADR(str);
  L := LEN(str);
  FOR pos := 1 TO L DO
    IF NOT (ISC_NUM(pt^)) THEN
      IS_NUM := FALSE;
      RETURN;
    END_IF;
        PT := PT + 1;
  END_FOR;
  IS_NUM := L > 0;

(* revision history
  hm  29. feb 2008  rev 1.0
    original version

  hm  29. mar. 2008 rev 1.1
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION ISC_UPPER : BOOL
(*
  ISC_upper checks if a character is uppercase

  version 1.1 19. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    IN : BYTE;
  END_VAR

  IF setup.EXTENDED_ASCII THEN
    ISC_UPPER :=  ((in > 64) AND (in < 91)) OR (((in > 191) AND (in < 223)) AND (in <> 215));
  ELSE
    ISC_UPPER := ((in > 64) AND (in < 91));
  END_IF;

(* revision history
  hm  6. mar. 2008  rev 1.0
    original version

  hm  19. oct. 2008 rev 1.1
    changes setup constants
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION IS_UPPER : BOOL
(*
  IS_UPPER testet ob in einem string keine Kleinbuchstaben vorkommen.

  version 1.1 29. mar. 2008
  programmer    kurt
  tested by   hugo
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
  END_VAR
  VAR
    L: INT;
    pt : PTR_TO BYTE;
    pos: INT;
  END_VAR

  PT := ADR(str);
  L := LEN(str);
  FOR pos := 1 TO L DO
    IF NOT (ISC_UPPER(pt^)) THEN
      IS_UPPER := FALSE;
      RETURN;
    END_IF;
        PT := PT + 1;
  END_FOR;
  IS_UPPER := L > 0;

(* revision history
  hm  29. feb 2008  rev 1.0
    original version

  hm  29. mar. 2008 rev 1.1
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION_BLOCK MESSAGE_4R
(*
  this function generates a rotation meassage with up to 4 strings.
  on each rising edge of EN the next message in line will be displayed.
  when EN stays high longer then one cycle, the next message will be displayed automatically after the time T1 is elapsed.
  the output MX is the generated message and CX is a counter 0..3 signaling the current message displayed.
  the displayed messages are 0 .. MM.

  version 1.1 27. oct. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    M0 : STRING[STRING_LENGTH];
    M1 : STRING[STRING_LENGTH];
    M2 : STRING[STRING_LENGTH];
    M3 : STRING[STRING_LENGTH];
    MM : INT := 3;
    ENQ : BOOL := TRUE;
    CLK : BOOL := TRUE;
    T1 : TIME := T#3s;
  END_VAR
  VAR_OUTPUT
    MX : STRING[STRING_LENGTH];
    MN : INT;
    TR : BOOL;
  END_VAR
  VAR
    timer : TON;
    edge: BOOL;
  END_VAR

  (* check for rising edge on EN *)
  TR := FALSE;
  IF ENQ THEN
    IF (NOT edge AND clk) OR timer.q THEN
        MN := INC1(MN, MM);
        TR := TRUE;
        timer(in := FALSE);
        CASE MN OF
          0 : MX := M0;
          1 : MX := M1;
          2 : MX := M2;
          3 : MX := M3;
        END_CASE;
    END_IF;
    edge := clk;
    timer( in := CLK, pt := T1);
  ELSE
    MX := '';
    MN := 0;
  END_IF;

(* revision history
  hm  8. oct. 2008  rev 1.0
    original version

  hm  27. oct. 2008 rev 1.1
    changed _INC to INC1
*)
END_FUNCTION_BLOCK


(* @PATH := '\/String' *)
FUNCTION_BLOCK MESSAGE_8
(*
  this function generates one out of 4 messages specified by S1 .. S8.
  the selected message will be presented at the output M.
  In1 has higher priority then In2 which has higher priority then IN3 and in8 has the lowest priority.

  version 1.1 29. mar. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    IN1 : BOOL;
    IN2 : BOOL;
    IN3 : BOOL;
    IN4 : BOOL;
    IN5 : BOOL;
    IN6 : BOOL;
    IN7 : BOOL;
    IN8 : BOOL;
  END_VAR
  VAR_INPUT //???CONSTANT
    S1 : STRING[STRING_LENGTH];
    S2 : STRING[STRING_LENGTH];
    S3 : STRING[STRING_LENGTH];
    S4 : STRING[STRING_LENGTH];
    S5 : STRING[STRING_LENGTH];
    S6 : STRING[STRING_LENGTH];
    S7 : STRING[STRING_LENGTH];
    S8 : STRING[STRING_LENGTH];
  END_VAR
  VAR_OUTPUT
    M : STRING[STRING_LENGTH];
  END_VAR

  (* check if an alarm is present if yes set the output M otherwise clear M *)
  IF in1 THEN
    M := S1;
  ELSIF in2 THEN
    M := S2;
  ELSIF in3 THEN
    M := S3;
  ELSIF in4 THEN
    M := S4;
  ELSIF in5 THEN
    M := S5;
  ELSIF in6 THEN
    M := S6;
  ELSIF in7 THEN
    M := S7;
  ELSIF in8 THEN
    M := S8;
  ELSE
    M := '';
  END_IF;

(* revision history
  hm  26.12.2007    rev 1.0
    original version

  hm  29. mar. 2008 rev 1.1
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION_BLOCK


(* @PATH := '\/String' *)
FUNCTION MIRROR : STRING[STRING_LENGTH]
(*
  this function reverses an input string.

  version 1.1 29. mar. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
  END_VAR
  VAR
    pi : PTR_TO OSCAT_BASIC_ARRAY1_255_OF_BYTE; //ARRAY[1..255] OF BYTE;
    po : PTR_TO BYTE;
    lx: INT;
    i: INT;
  END_VAR

  po := ADR(mirror);
  pi := ADR(str);
  lx := LEN(str);
  FOR i := lx TO 1 BY - 1 DO
    po^ := pi^[i];
    po := po + 1;
  END_FOR;
  (* close output string *)
  po^:= 0;

(* revision history
  hm  4. feb. 2008  rev 1.0
    original release

  hm  29. mar. 2008 rev 1.1
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION REAL_TO_STRF : STRING[20]
(*
  Real_to_strf converts a Real to a fixed length String.
  the string will be filles with zeroes to achieve the fixed length N after the decimal separator.
  the input parameter specifies the decimal separator to be used in the output string.

  version 1.8 2. jan 2012
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    IN : REAL;
    N : INT;
    D : STRING[1];
  END_VAR
  VAR
    O: REAL;
    i: INT;
  END_VAR

  (* LIMIT N to 0 .. 7 *)
  N := LIMIT(0,N,7);
  (* round the input to N digits and convert to string *)
  O := ABS(in) * EXP10(INT_TO_REAL(N));
  REAL_TO_STRF := DINT_TO_STRING(REAL_TO_DINT(O));
  (* add zeroes in front to make sure sting is at least 8 digits long *)
  FOR i := LEN(REAL_TO_STRF) TO N DO REAL_TO_STRF := CONCAT('0', REAL_TO_STRF); END_FOR;
  (* add a dot if n > 0 *)
  IF n > 0 THEN REAL_TO_STRF := INSERT(REAL_TO_STRF, D, LEN(REAL_TO_STRF) - N +1); END_IF;
  (* add a minus sign if in is negative *)
  IF in < 0.0 THEN REAL_TO_STRF := CONCAT('-', REAL_TO_STRF); END_IF;

(* revision history
  hm  26 jan 2007 rev 1.0
    original version

  hm  20. nov. 2007 rev 1.1
    when N=0 ther will be no dot at the end of the string.

  hm  15. dec. 2007 rev 1.2
    changed code for better performance

  hm  4. mar. 2008  rev 1.3
    result is now rounded instead of trunc

  hm  20. mar. 2008 rev 1.4
    changed trunc to real_to_dint because trunc was generating wrong values on wago 842

  hm  29. mar. 2008 rev 1.5
    changed STRING to STRING(20)

  hm  4. apr. 2008  rev 1.6
    added variable O to avoid an error uner CoDeSys SP PLCWinNT V2.4

  hm  27. feb. 2009 rev 1.7
    added a missing zero for IN < 1

  hm 2. jan 2012  rev 1.8
    added input parameter D to specify decimal separator
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION REPLACE_ALL : STRING[STRING_LENGTH]
(*
  the function replace_all replaces all occurences of src in str and replaces them by rep.

  version 1.1 29. mar. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
    src : STRING[STRING_LENGTH];
    rep : STRING[STRING_LENGTH];
  END_VAR
  VAR
    pos: INT;
    lp : INT;
    lx : INT;
  END_VAR
  VAR_TEMP
    tmp : STRING[STRING_LENGTH];
  END_VAR

  tmp := str;
  lx := LEN(src);
  lp := LEN(rep);
  pos := FINDP(tmp, src, 1);
  WHILE pos > 0 DO
    tmp := REPLACE(tmp,rep,lx, pos);
    pos := FINDP(tmp, src, pos + lp);
  END_WHILE;
  REPLACE_ALL := tmp;
  
(* revision history
  hm  4. feb. 2008  rev 1.0
    original release

  hm  29. mar. 2008 rev 1.1
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION REPLACE_CHARS : STRING[STRING_LENGTH]
(*
  REPLACE_CHARS erstezt alle character die im string src aufgeführt sind mit dem an der selben stelle im string rep gelisteten character.

  version 1.0   14. may. 2008
  programmer    hugo
  tested by     hugo
*)
  VAR_INPUT
    STR : STRING[STRING_LENGTH];
    SRC : STRING;
    REP : STRING;
  END_VAR
  VAR
    a, b : INT;
    c: STRING[1];
    stp: INT;
  END_VAR
  VAR_TEMP
    d : STRING[1];
    tmp : STRING[STRING_LENGTH];
  END_VAR

  tmp := STR;
  (* make sure rep and src are of same length and length is > 0 *)
  a := LEN(src);
  b := LEN(rep);
  IF a < b THEN
    rep := LEFT(rep, a);
  ELSIF b < a THEN
    src := LEFT(src, b);
  END_IF;

  (* search the string and replace if necessary *)
  stp := LEN(str);
  FOR a := 1 TO stp DO
    c := MID(tmp, 1, a);
    b := FIND(src, c);
    IF b > 0 THEN
      d := MID(rep, 1, b);
      tmp := REPLACE(tmp, d, 1, a);
    END_IF;
  END_FOR;
  REPLACE_CHARS := tmp;
  
(* revision history
  hm  14. may. 2008 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION TO_UML : STRING[2]
(*
  to_uml converts a character above 127 to a two digit character below 127.
  the character Ä is converted to Ae

  version 1.1 17. dec. 2008
  programmer    hugo
  tested by   tobias
*)
  VAR_INPUT
    IN : BYTE;
  END_VAR

  CASE BYTE_TO_USINT(in) OF
    196:  (* Ä *)
      TO_UML := 'Ae';
    214:  (* Ö *)
      TO_UML := 'Oe';
    220:  (* Ü *)
      TO_UML := 'Ue';
    223:  (* ß *)
      TO_UML := 'ss';
    228:  (* ä *)
      TO_UML := 'ae';
    246:  (* ö *)
      TO_UML := 'oe';
    252:  (* ü *)
      TO_UML := 'ue';
  ELSE
    TO_UML := CHR_TO_STRING(IN);
  END_CASE;

(* revision history
  hm  29. mar. 2008 rev 1.0
    original version

  hm  17. dec. 2008 rev 1.1
    changes name of function chr to chr_to_string
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION REPLACE_UML : STRING[STRING_LENGTH]
(*
  REPLACE_UML replaces all occurences of Ä,Ö,Ü and ä,ö,ü,ß with Ae, ae, Oe, oe, Ue, ue and ss.

  version 1.1 29. mar. 2008
  programmer    kurt
  tested by   hugo
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
  END_VAR
  VAR
    L : INT;
    pt : PTR_TO BYTE;
    pto : PTR_TO BYTE;
    ptm : PTR_TO BYTE;
    pt1, pt2 : PTR_TO BYTE;
    su : STRING[2];
    pos : INT;
  END_VAR

  PT := ADR(str);
  //pto := ADR(REPLACE_UML);
  {asm}
    LEAX  __fc__REPLACE_UML
    WRX   pto
  {end_asm}

  ptm := pto + INT_TO_UDINT(string_length);
  pt1 := ADR(su);
  pt2 := pt1 + 1;
  L := LEN(str);
  WHILE pos < L AND pos < string_length DO
    IF pt^ < 127 THEN
      (* no uml character simlply copy the character*)
      pto^ := pt^;
    ELSE
      (* convert the uml character *)
      su := TO_UML(pt^);
      (* we must make sure pointer are not out of range *)
      pto^ := pt1^;
      IF (PTR_TO_UDINT(pto) < PTR_TO_UDINT(ptm)) AND (pt2^ > 0) THEN
        pto := pto + 1;
        pto^ := pt2^;
      END_IF;
    END_IF;
    (* increment pointers *)
    pt := pt + 1;
    pto := pto + 1;
    pos := pos + 1;
  END_WHILE;

  (* properly close the output string *)
  pto^ := 0;

(* revision history
  hm  29. feb 2008  rev 1.0
    original version

  hm  29. mar. 2008 rev 1.1
    changed STRING to STRING[STRING_LENGTH]
    new code to avoid pointer out of range
    use new function to_uml
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION_BLOCK TICKER
(*
  Ticker sends a substring of text with length N every TD Milliseconds to generate a ticker.

  version 1.2 29. mar. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    N : INT;
    PT : TIME;
  END_VAR
  VAR_IN_OUT
    Text : STRING[STRING_LENGTH];
  END_VAR
  VAR_OUTPUT
    Display : STRING[STRING_LENGTH];
  END_VAR
  VAR
    delay : TP;
    step : INT;
  END_VAR

  (* generate next ticker when delay is low *)
  IF N < LEN(text) THEN
    IF NOT delay.Q THEN
      (* increase step for next tick *)
      step := step + 1;
      IF step > LEN(text) THEN step := 1; END_IF;
      (* extract dispay from text *)
      display := MID(text, N, step);
      (* set delay timer for next tick *)
      delay(in := TRUE, PT := PT);
    ELSE;
      (* execute delay timer *)
      delay(in := FALSE);
    END_IF;
  ELSE
    display := text;
  END_IF;
  
(* revision history
  hm  4. dec. 2007  rev 1.0
    original version

  hm  15. dec. 2007 rev 1.1
    step now starts at 1 instaed of 0

  hm  29. mar. 2008 rev 1.2
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION_BLOCK


(* @PATH := '\/String' *)
FUNCTION TRIM1 : STRING[STRING_LENGTH]
(*
  the function replaces all multiple blanks within a string by only one blank.
  leading and ending blanks will be deleted

  version 1.2 29. mar. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
  END_VAR
  VAR
    pos: INT;
    c : STRING[1];
  END_VAR

  TRIM1 := str;
  REPEAT
    pos := FIND( TRIM1,'  ');
    IF pos > 0 THEN TRIM1 := REPLACE(TRIM1,' ',2,pos); END_IF;
  UNTIL pos = 0 END_REPEAT;
  (* beginning and ending blanks need to be stripped off *)
  c := LEFT(TRIM1,1);
  IF c = ' ' THEN TRIM1 := DELETE(TRIM1,1,1); END_IF;
  c := RIGHT(TRIM1,1);
  IF c = ' ' THEN TRIM1 := DELETE(TRIM1,1,LEN(TRIM1)); END_IF;

(* revision history
  hm  4. feb. 2008    rev 1.0
    original release

  hm  20. mar. 2008 rev 1.1
    avoid to call replace with pos = 0 because some systems will produce an error

  hm  29. mar. 2008 rev 1.2
    changed STRING to STRING[STRING_LENGTH]
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION TRIME : STRING[string_length]
(*
  this function deletes all leading and ending blanks of a string.

  version 1.0 28. mar. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    str : STRING[STRING_LENGTH];
  END_VAR
  VAR
    c : STRING[1];
  END_VAR

  TRIME := str;
  (* beginning blanks need to be stripped off *)
  c := LEFT(TRIME,1);
  WHILE c = ' ' DO
    TRIME := DELETE(TRIME,1,1);
    c := LEFT(TRIME,1);
  END_WHILE;

  (* ending blanks need to be stripped off *)
  c := RIGHT(TRIME,1);
  WHILE c = ' ' DO
    TRIME := DELETE(TRIME,1,LEN(TRIME));
    c := RIGHT(TRIME,1);
  END_WHILE;

(* revision history
  hm  28. mar. 2008 rev 1.0
    original release
*)
END_FUNCTION

