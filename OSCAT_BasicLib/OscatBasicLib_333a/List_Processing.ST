TYPE
  OSCAT_BASIC_ARRAY1_LIST_LENGTH_OF_BYTE : ARRAY[1..LIST_LENGTH] OF BYTE;
END_TYPE

(* @PATH := '\/List Processing' *)
FUNCTION LIST_ADD : BOOL
(*
  LIST_ADD hängt ein weiteres element ans ende einer liste.
  die liste liegt als string von elementen vor die mit den zeichen SEP am anfang makiert sind.

  version 2.0   21. mar. 2011
  programmer  hugo
  tested by   kurt
*)
  VAR_INPUT
    SEP : BYTE;
    INS : STRING[LIST_LENGTH];
  END_VAR
  VAR_IN_OUT
    LIST : STRING[LIST_LENGTH];
  END_VAR
  VAR
    sx : STRING[1];
  END_VAR

  sx := CHR_TO_STRING(SEP);     (* convert separation character to string *)
  INS := CONCAT(sx, INS);         (* start element with separation character *)

  IF LEN(LIST) + LEN(INS) > LIST_LENGTH THEN
    LIST_ADD := FALSE;          (* return false if element does not fit *)
  ELSE
    LIST := CONCAT(LIST, INS);
    LIST_ADD := TRUE;
  END_IF;

(* revision histroy
  hm  21. mar. 2011 rev 2.0
    original release
*)
END_FUNCTION


(* @PATH := '\/List Processing' *)
FUNCTION LIST_CLEAN : BOOL
(*
  LIST_CLEAN bereinigt eine liste von leeren Elementen.
  die liste liegt als string von elementen vor die mit den zeichen SEP am anfang markiert sind.

  version 2.0 21. mar. 2011
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    SEP : BYTE;
  END_VAR
  VAR_IN_OUT
    LIST : STRING[LIST_LENGTH];
  END_VAR
  VAR
    pt : PTR_TO OSCAT_BASIC_ARRAY1_LIST_LENGTH_OF_BYTE; // ARRAY[1..LIST_LENGTH] OF BYTE;
    read : INT := 1;
    write : INT := 1;
    last: BYTE;
    c: BYTE;
  END_VAR

  pt := ADR(LIST);

  FOR read := 1 TO LIST_LENGTH DO
    c := pt^[read];               (* read character from list *)
    IF c = 0 THEN EXIT;           (* exit the loop if character definbes end of string *)
    ELSIF (c <> SEP) OR (sep <> last) THEN  (* copy element from read to write position unless a double sep character is present *)
      pt^[write] := c;
      write := write + 1;
    END_IF;
    last := c;                  (* remember last character *)
  END_FOR;

  IF last = SEP THEN write := write - 1; END_IF;    (* if last character is sep then delete empty element at end *)
  IF write <= STRING_LENGTH THEN pt^[write] := 0;  END_IF;    (* terminate string with 0 *)

  LIST_CLEAN := TRUE;           (* retrun TRUE *)

(* revision histroy
  hm  28. jun. 2008 rev 1.0
    original release

  hm  19. jan. 2011 rev 1.1
    changed string(255) to string[LIST_LENGTH]

  hm  21. mar. 2011 rev 2.0
    all elements start with SEP
*)
END_FUNCTION


(* @PATH := '\/List Processing' *)
FUNCTION LIST_GET : STRING[LIST_LENGTH]
(*
  LIST_GET liefert das element an der stelle pos einer liste.
  die liste liegt als string von elementen vor die mit den zeichen SEP am anfang makiert sind.

  version 2.0 21. mar. 2011
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    SEP : BYTE;
    POS : INT;
  END_VAR
  VAR_IN_OUT
    LIST : STRING[LIST_LENGTH];
  END_VAR
  VAR
    i : INT := 1;
    o : INT := 1;
    pt : PTR_TO OSCAT_BASIC_ARRAY1_LIST_LENGTH_OF_BYTE; // ARRAY[1..LIST_LENGTH] OF BYTE;
    po : PTR_TO OSCAT_BASIC_ARRAY1_LIST_LENGTH_OF_BYTE; // ARRAY[1..LIST_LENGTH] OF BYTE;
    cnt: INT := 0;
    c: BYTE;
  END_VAR

  pt := ADR(LIST);              (* load pointers *)
//  po := ADR(LIST_GET);
  {asm}
    LEAX  __fc__LIST_GET
    WRX   po
  {end_asm}

  REPEAT
    c := pt^[i];
    IF cnt = pos THEN           (* copy element to output string *)
      IF c = SEP  THEN EXIT; END_IF;    (* next element stop copy and finish *)
      po^[o] := c;
      o := o + 1;
    ELSIF c = SEP THEN
      cnt := cnt + 1;
    END_IF;
    i := i + 1;
  UNTIL
    (i = LIST_LENGTH) OR (c = 0)
  END_REPEAT;
  po^[o] := 0;            (* close the output string *)

(* revision history
  hm  20. jun. 2008 rev 1.0
    original release

  hm  19. jan. 2011 rev 1.1
    changed string(255) to strring[LIST_LENGTH]

  hm  21. mar. 2011 rev 2.0
    all list elements start with SEP
*)
END_FUNCTION


(* @PATH := '\/List Processing' *)
FUNCTION LIST_INSERT : BOOL
(*
  LIST_INSERT setzt ein element an der stelle pos in eine liste ein.
  die liste liegt als string von elementen vor die mit den zeichen SEP am anfang markiert sind.

  version 2.0 21. mar. 2011
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    SEP : BYTE;
    POS : INT;
    INS : STRING[LIST_LENGTH];
  END_VAR
  VAR_IN_OUT
    LIST : STRING[LIST_LENGTH];
  END_VAR
  VAR
    pt : PTR_TO OSCAT_BASIC_ARRAY1_LIST_LENGTH_OF_BYTE; // ARRAY[1..LIST_LENGTH] OF BYTE;
    read : INT := 1;
    cnt : INT := 1;
    sx : STRING[1];
  END_VAR

  (* load pointers *)
  pt := ADR(LIST);

  IF LEN(ins) + 1 + LEN(LIST) > LIST_LENGTH THEN
    LIST_INSERT := FALSE;
  ELSE
    LIST_INSERT := TRUE;
    (* search for position *)
    WHILE read < LIST_LENGTH DO
      IF cnt >= POS THEN
        sx := CHR_TO_STRING(SEP);
        INS := CONCAT(sx, INS);
        LIST := INSERT(LIST, INS, read - 1);
        LIST_INSERT := TRUE;
        RETURN;
      END_IF;
      IF pt^[read]  = 0 THEN        (* list is too short add empty element *)
        pt^[read] := SEP;
        pt^[read + 1] := 0;
      END_IF;
      read := read + 1;
      IF (pt^[read] = SEP) OR (pt^[read] = 0) THEN cnt := cnt + 1; END_IF;
    END_WHILE;
  END_IF;

(* revision history
  hm  28. jun. 2008 rev 1.0
    original release

  hm  17. dec. 2008 rev 1.1
    changes name of function chr to chr_to_string

  hm  19. jan. 2011 rev 1.2
    changed string(255) to string[LIST_LENGTH]

  hm  21. mar. 2011 rev 2.0
    all list elements start with SEP
*)
END_FUNCTION


(* @PATH := '\/List Processing' *)
FUNCTION LIST_LEN : INT
(*
  LIST_LEN liefert die anzahl der elemente einer liste.
  die liste liegt als string von elementen vor die mit den zeichen SEP am anfang markiert sind.

  version 2.0 21. mar. 2011
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    SEP : BYTE;
  END_VAR
  VAR_IN_OUT
    LIST : STRING[LIST_LENGTH];
  END_VAR
  VAR
    pt : PTR_TO OSCAT_BASIC_ARRAY1_LIST_LENGTH_OF_BYTE; // ARRAY[1..LIST_LENGTH] OF BYTE;
    pos: INT := 1;
    c: BYTE;
  END_VAR

  pt := ADR(LIST);
  LIST_LEN := 0;
  REPEAT
  	c := pt^[pos];
  	IF c = SEP THEN LIST_LEN := LIST_LEN + 1; END_IF;
  	pos := pos + 1;
  UNTIL
  	(c = 0) OR (pos > LIST_LENGTH)
  END_REPEAT;

(* revision history
  hm  25. jun. 2008 rev 1.0
    original release

  hm  16. oct. 2008 rev 1.1
    fixed a problem where list_len would only work up to LIST_LENGTH

  hm  19. jan. 2001 rev 1.2
    changed string(255) to string[LIST_LENGTH]

  hm  21. mar. 2011 rev 2.0
    all list elements start with SEP
*)
END_FUNCTION


(* @PATH := '\/List Processing' *)
FUNCTION_BLOCK LIST_NEXT
(*
  LIST_NEXT retrieves the next element of a list, starting from element 1 after reset or first init.
  when the end of the lisat is reached a '' empty string is returned and NUL is set to true.
  die liste liegt als string von elementen vor die mit den zeichen SEP am anfang markiert sind.

  version 2.0 21. mar. 2011
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    SEP : BYTE;
    RST : BOOL;
  END_VAR
  VAR_IN_OUT
    LIST : STRING[LIST_LENGTH];
  END_VAR
  VAR_OUTPUT
    LEL : STRING[LIST_LENGTH];
    NUL : BOOL;
  END_VAR
  VAR
    pos : INT := 1;
    pt : PTR_TO OSCAT_BASIC_ARRAY1_LIST_LENGTH_OF_BYTE; // ARRAY[1..LIST_LENGTH] OF BYTE;
    po : PTR_TO OSCAT_BASIC_ARRAY1_LIST_LENGTH_OF_BYTE; // ARRAY[1..LIST_LENGTH] OF BYTE;
    c: BYTE;
    write: INT;
  END_VAR

  pt := ADR(LIST);
  po := ADR(LEL);

  IF rst THEN
    pos := 1;
  END_IF;

  IF (pt^[pos] = 0) OR (pos = LIST_LENGTH) THEN
    LEL := '';
    NUL := TRUE;
  ELSE
    NUL := FALSE;
    write := 1;
    FOR pos := pos + 1 TO LIST_LENGTH DO
      c := pt^[pos];
      IF (c = 0) OR (c = SEP) THEN
        po^[write] := 0;
        RETURN;
      ELSE
        po^[write] := pt^[pos];
        write := write + 1;
      END_IF;
    END_FOR;
  END_IF;

(* revision history
  hm  25. jun. 2008 rev 1.0
    original release

  hm  19. jan. 2011 rev 1.1
    changed string(255) to string[LIST_LENGTH]

  hm  21. mar. 2011 rev 2.0
    all elements start with SEP
*)
END_FUNCTION_BLOCK


(* @PATH := '\/List Processing' *)
FUNCTION LIST_RETRIEVE : STRING[LIST_LENGTH]
(*
  LIST_RETRIEVE liefert das element an der stelle pos einer liste und löscht das element aus der liste.
  die liste liegt als string von elementen vor die mit den zeichen SEP separiert sind.

  version 2.0   21. mar. 2011
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    SEP : BYTE;
    POS : INT;
  END_VAR
  VAR_IN_OUT
    LIST : STRING[LIST_LENGTH];
  END_VAR
  VAR
    i : INT;
    o : INT := 1;
    w : INT := 1;
    pt : PTR_TO OSCAT_BASIC_ARRAY1_LIST_LENGTH_OF_BYTE; // ARRAY[1..LIST_LENGTH] OF BYTE;
    po : PTR_TO OSCAT_BASIC_ARRAY1_LIST_LENGTH_OF_BYTE; // ARRAY[1..LIST_LENGTH] OF BYTE;
    cnt: INT := 0;
    c: BYTE;
  END_VAR

  (* load pointers *)
  pt := ADR(LIST);
//  po := ADR(LIST_RETRIEVE);
  {asm}
    LEAX  __fc__LIST_RETRIEVE
    WRX   po
  {end_asm}

  IF pos > 0 THEN
    FOR i := 1 TO LIST_LENGTH DO
      c := pt^[i];
      IF c = 0 THEN
        po^[o] := 0;
        IF cnt < pos THEN pt^[w + 1] := 0; ELSE pt^[w] := 0; END_IF;
        RETURN;
      ELSIF cnt = pos AND c <> SEP THEN       (* we have found the element *)
        po^[o] := pt^[i];
        o := o + 1;
      ELSIF cnt >= pos THEN
        pt^[w] := c;
        w := w + 1;
      ELSE
        w := i;
      END_IF;
      IF c = sep THEN cnt := cnt + 1; END_IF;
    END_FOR;
  ELSE
    LIST_RETRIEVE := '';
  END_IF;

(* revision history
  hm  28. jun. 2008 rev 1.0
    original release

  hm  19. jan. 2011 rev 1.1
    changed string(255) to string[LIST_LENGTH]

  hm  21. mar. 2011 rev 2.0
    all elements start with SEP
*)
END_FUNCTION


(* @PATH := '\/List Processing' *)
FUNCTION LIST_RETRIEVE_LAST : STRING[LIST_LENGTH]
(*
  LIST_RETRIEVE_LAST liefert das letzte element einer liste und löscht das element aus der liste.
  die liste liegt als string von elementen vor die mit den zeichen SEP beginnen.

  version 2.0   21. mar. 2011
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    SEP : BYTE;
  END_VAR
  VAR_IN_OUT
    LIST : STRING[LIST_LENGTH];
  END_VAR
  VAR
    i : INT;
    last : INT := 1;
    pt : PTR_TO OSCAT_BASIC_ARRAY1_LIST_LENGTH_OF_BYTE; // ARRAY[1..LIST_LENGTH] OF BYTE;
    c: BYTE;
  END_VAR

  (* load pointers *)
  pt := ADR(LIST);

  (* search position of last element *)
  FOR i := 1 TO LIST_LENGTH DO
    c := pt^[i];
    IF c = 0 THEN
      EXIT;
    ELSIF C = SEP THEN
      last := i;
    END_IF;
  END_FOR;
  (* return last element of list *)
  LIST_RETRIEVE_LAST := MID(LIST, LIST_LENGTH, last + 1);
  (* terminate list at i *)
  pt^[last] := 0;

(* revision history
  hm  21. mar. 2011 rev 2.0
    new module
*)
END_FUNCTION

