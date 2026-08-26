TYPE
  OSCAT_BASIC_ARRAY0_32767_OF_BYTE : ARRAY[0..32767] OF BYTE;
  OSCAT_BASIC_ARRAY0_STRING_LENGTH_OF_BYTE : ARRAY[0..STRING_LENGTH] OF BYTE;
END_TYPE

(* @PATH := '\/Buffer Management' *)
FUNCTION _BUFFER_CLEAR : BOOL
(*
  this function will initialize a given array of byte with 0.
  the function needs to be called:	_buffer_clear(adr("array"),sizeof("array"));
  this function will manipulate a given array.
  the function manipulates the original array, it rerturnes true when finished.
  because this function works with pointers its very time efficient and it needs no extra memory.

  version 1.2	31. oct. 2008
  programmer 	hugo
  tested by	oscat
*)
  VAR_INPUT
  	PT : PTR_TO BYTE;
  	SIZE : UINT;
  END_VAR
  VAR
  	ptw        : PTR_TO DWORD;
  	temp       : UDINT;
  	end, end32 : UDINT;
  END_VAR

  (* this routine uses 32 bit access to gain speed *)
  (* first access bytes till pointer is aligned for 32 bit access *)
  temp := PTR_TO_UDINT( pt);
  end := temp + UINT_TO_UDINT(size);
  end32 := end - 3;
  WHILE (PTR_TO_UDINT(pt) < end) AND ((UDINT_TO_DWORD(temp) AND 16#00000003) > 0) DO
  	pt^ := 0;
  	pt := pt + 1;
  	temp := temp + 1;
  END_WHILE;
  (* pointer is aligned, now copy 32 bits at a time *)
  ptw := pt;
  WHILE PTR_TO_UDINT(ptw) < end32 DO (* *)
  	ptw^ := 0;
  	ptw := ptw + 4;
  END_WHILE;
  (* copy the remaining bytes in byte mode *)
  pt := ptw;
  WHILE PTR_TO_UDINT(pt) < end DO
  	pt^ := 0;
  	pt := pt + 1;
  END_WHILE;
  _BUFFER_CLEAR := TRUE;

(* revision History
  hm 	5. mar. 2008	rev 1.0
  	original version

  hm	16. mar. 2008	rev 1.1
  	added type conversion to avoid warnings under codesys 30
  	chaged type of input size to uint
  	deleted unused variable i

  hm	31. oct. 2008	rev 1.2
  	corrected an error while routine would write outside of arrays
  *)
END_FUNCTION


(* @PATH := '\/Buffer Management' *)
FUNCTION _BUFFER_INIT : BOOL
(*
  this function will initialize a given array of byte with init.
  the function needs to be called:	_buffer_init(adr("array"),sizeof("array"),init);
  this function will manipulate a given array.
  the function manipulates the original array, it rerturnes true when finished.
  because this function works with pointers its very time efficient and it needs no extra memory.

  version 1.2	31. oct. 2008
  programmer 	hugo
  tested by	oscat
*)
  VAR_INPUT
  	PT : PTR_TO BYTE;
  	SIZE : UINT;
  	INIT : BYTE;
  END_VAR
  VAR
  	ptw : PTR_TO UDINT;
  	temp : UDINT;
  	end, end32 : UDINT;
  END_VAR

  (* this routine uses 32 bit access to gain speed *)
  (* first access bytes till pointer is aligned for 32 bit access *)
  temp := PTR_TO_UDINT(pt);
  end := temp + UINT_TO_UDINT(size);
  end32 := end - 3;
  WHILE (PTR_TO_UDINT(pt) < end) AND ((UDINT_TO_DWORD(temp) AND 16#00000003) > 0) DO
  	pt^ := init;
  	pt := pt + 1;
  	temp := temp + 1;
  END_WHILE;
  (* pointer is aligned, now copy 32 bits at a time *)
  ptw := pt;
  temp := DWORD_TO_UDINT( SHL(BYTE_TO_DWORD(init),24) OR SHL(BYTE_TO_DWORD(init),16) OR SHL(BYTE_TO_DWORD(init),8) OR BYTE_TO_DWORD(init));
  WHILE PTR_TO_UDINT(ptw) < end32 DO
  	ptw^ := temp;
  	ptw := ptw + 4;
  END_WHILE;
  (* copy the remaining bytes in byte mode *)
  pt := ptw;
  WHILE PTR_TO_UDINT(pt) < end DO
  	pt^ := init;
  	pt := pt + 1;
  END_WHILE;
  _BUFFER_INIT := TRUE;

(* revision History
  hm 	5. mar. 2008	rev 1.0
  	original version

  hm	16. mar. 2008	rev 1.1
  	added type conversion to avoid warnings under codesys 3.0
  	chaged type of input size to uint.

  hm	31. oct. 2008	rev 1.2
  	corrected an error while routine would write outside of arrays
  *)
END_FUNCTION


(* @PATH := '\/Buffer Management' *)
FUNCTION _STRING_TO_BUFFER : INT
(*
  this function will copy a string into an array of byte starting at position pos.
  the function needs to be called:	_String_To_buffer(str, pos, adr("array"),sizeof("array"));
  this function will manipulate the array directly in memory and returns the position after the input string when finished.
  because this function works with pointers its very time efficient and it needs no extra memory.

  version 1.4	2. jan. 2012
  programmer 	hugo
  tested by		oscat
*)
  VAR_INPUT
  	STR : STRING[STRING_LENGTH];
  	POS : INT;
  	PT : PTR_TO OSCAT_BASIC_ARRAY0_32767_OF_BYTE; // ARRAY[0..32767] OF BYTE;
  	SIZE : UINT;
  END_VAR
  VAR
  	ps : PTR_TO BYTE;
  	i: INT;
  	end: INT;
  END_VAR

  ps := ADR(str);
  end := MIN(pos + LEN(str), UINT_TO_INT(size));
  IF end > 0 THEN end := end -1; END_IF;
  FOR i := pos TO end DO
  	pt^[i] := ps^;
  	ps := ps + 1;
  END_FOR;
  _STRING_TO_BUFFER := i;

(* revision History

  hm 	5. mar. 2008	rev 1.0
  	original version

  hm	16. mar. 2008	rev 1.1
  	changed type of input size to uint

  hm	13. may. 2008	rev 1.2
  	changed type of pointer to array[1..32767]
  	changed size of string to STRING_LENGTH

  hm	12. nov. 2009	rev 1.3
  	limit end to size - 1

  hm	2. jan 2012	rev 1.4
  	return the position after the input string when finished
*)
END_FUNCTION


(* @PATH := '\/Buffer Management' *)
FUNCTION _BUFFER_INSERT : INT
(*
  this function will insert a string at a given position in a buffer.
  the function needs to be called:	_buffer_insert(str, pos, adr("array"), sizeof("array"));
  this function will manipulate a given array.
  the function manipulates the original array, it returnes the next position after the input string when finished.
  because this function works with pointers its very time efficient and it needs no extra memory.

  version 1.5	2. jan. 2012
  programmer 	hugo
  tested by	oscat
*)
  VAR_INPUT
  	STR : STRING[STRING_LENGTH];
  	POS : INT;
  	PT : PTR_TO OSCAT_BASIC_ARRAY0_32767_OF_BYTE; // ARRAY[0..32767] OF BYTE;
  	SIZE : UINT;
  END_VAR
  VAR
  	end : INT;
  	lx: INT;
  	i: INT;
  END_VAR

  lx := LEN(str);
  end := pos + lx;
  (* first move the upper part of the buffer to make space for the string *)
  FOR i := UINT_TO_INT(size) - 1 TO end BY -1 DO
  	pt^[i] := pt^[i-lx];
  END_FOR;
  (* copy the string *)
  _BUFFER_INSERT := _STRING_TO_BUFFER(str, pos, PT, size);

(* revision History
  hm 	9. mar. 2008	rev 1.0
  	original version

  hm	16. mar. 2008	rev 1.1
  	changed type of input size to uint

  hm	13. may. 2008	rev 1.2
  	changed type of pointer to array[1..32767]
  	changed size of string to STRING_LENGTH

  hm	23. mar. 2009	rev 1.3
  	avoid writing to input pos

  hm	12. nov. 2009	rev 1.4
  	code optimized

  hm 2. jan 2012	rev 1.5
  	function now returns the next position after the input string
*)
END_FUNCTION


(* @PATH := '\/Buffer Management' *)
FUNCTION _BUFFER_UPPERCASE : BOOL
(*
  this function will convert an array of byte into uppercase
  the function needs to be called:  _buffer_clear(adr("array"),sizeof("array"));
  this function will manipulate a given array.
  the function manipulates the original array, it rerturnes true when finished.
  because this function works with pointers its very time efficient and it needs no extra memory.

  version 1.0 20. jan. 2011
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    PT : PTR_TO OSCAT_BASIC_ARRAY0_32767_OF_BYTE; //ARRAY[0..32000] OF BYTE;
    SIZE : INT;
  END_VAR
  VAR
    pos: INT;
  END_VAR

  pos := 0;
  WHILE pos < size DO
    PT^[pos] := TO_UPPER(pt^[pos]);
    pos := pos + 1;
  END_WHILE;
  _BUFFER_UPPERCASE := TRUE;

(* revision History
  hm  20. jan. 2011 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Buffer Management' *)
FUNCTION BUFFER_COMP : INT
(*
  version 1.1 12. nov. 2009
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    PT1 : PTR_TO OSCAT_BASIC_ARRAY0_32767_OF_BYTE; // ARRAY[0..32767] OF BYTE;
    SIZE1 : INT;
    PT2 : PTR_TO OSCAT_BASIC_ARRAY0_32767_OF_BYTE; // ARRAY[0..32767] OF BYTE;
    SIZE2 : INT;
    START : INT;
  END_VAR
  VAR
    i, j, end : INT;
    firstbyte: BYTE;
  END_VAR

  (* search for first character match *)
  IF size2 <= size1 THEN
    end := size1 - size2;
    firstbyte := PT2^[0];
    FOR i := START TO end DO
      IF PT1^[i] = firstbyte THEN
        (* first character matches, now compare rest of array *)
        j := 1;
        WHILE j < size2 DO
          IF pt2^[j] <> pt1^[j+i] THEN EXIT; END_IF;
          j := j + 1;
        END_WHILE;
        (* when J > size2 a match was found return the position i in buffer1 *)
        IF j = size2 THEN
          BUFFER_COMP := i;
          RETURN;
        END_IF;
      END_IF;
    END_FOR;
  END_IF;
  BUFFER_COMP := -1;

(*
  hm 14. nov. 2008  rev 1.0
    original version

  hm  12. nov. 2009 rev 1.1
    performance increase
*)
END_FUNCTION


(* @PATH := '\/Buffer Management' *)
FUNCTION BUFFER_SEARCH : INT
(*
  this function will search for a string STR in an array of byte starting at position pos.
  the function needs to be called: buffer_search(adr("array"),sizeof("array"), STR, POS, IGN);
  because this function works with pointers its very time efficient and it needs no extra memory.
  The function returns the position of the first character of the string in the array if found.
  a -1 is returned if the string is not found in the array.
  when IGN = TRUE, STR must be in capital letters and the search is case insensitv.

  version 1.4 25. jan 2011
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    PT : PTR_TO OSCAT_BASIC_ARRAY0_32767_OF_BYTE; // ARRAY[0..32767] OF BYTE;
    SIZE : INT;
    STR : STRING[STRING_LENGTH];
    POS : INT;
    IGN : BOOL;
  END_VAR
  VAR
    ps : PTR_TO OSCAT_BASIC_ARRAY0_STRING_LENGTH_OF_BYTE; // ARRAY[0..STRING_LENGTH] OF BYTE;
    chx : BYTE;
    i: INT;
    end: INT;
    k: INT;
    lx: INT;
  END_VAR

  ps := ADR(STR);
  lx := LEN(STR);
  end := MIN(SIZE - lx, SIZE - 1);
  lx := lx - 1;
  FOR i := pos TO end DO
    FOR k := 0 TO lx DO
      IF IGN THEN chx := TO_UPPER(pt^[i+k]); ELSE chx := pt^[i+k]; END_IF;
      IF ps^[k] <> chx THEN EXIT; END_IF;
    END_FOR;
    IF k > lx THEN
      BUFFER_SEARCH := i;
      RETURN;
    END_IF;
  END_FOR;
  BUFFER_SEARCH := -1;

(* revision History
  hm 5. mar. 2008 rev 1.0
    original version

  hm  16. mar. 2008 rev 1.1
    chaged type of input size to uint

  hm  13. may. 2008 rev 1.2
    changed type of pointer to array[1..32767]
    changed size of string to STRING_LENGTH

  hm  12. nov. 2009 rev 1.3
    limit end to array size

  hm  25. jan. 2011 rev 1.4
    ign = True will now ignore case
    return -1 if nothing found
*)
END_FUNCTION


(* @PATH := '\/Buffer Management' *)
FUNCTION BUFFER_TO_STRING : STRING[STRING_LENGTH]
(*
  this function will retrieve a string from an array of byte starting at position start and stop at position stop.
  the function needs to be called:  buffer_TO_String(adr("array"),sizeof("array"), start, stop);
  because this function works with pointers its very time efficient and it needs no extra memory.

  version 1.5 12. nov. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    PT : PTR_TO OSCAT_BASIC_ARRAY0_32767_OF_BYTE; // ARRAY[0..32767] OF BYTE;
    SIZE : UINT;
    START : UINT;
    STOP : UINT;
  END_VAR
  VAR
    ps : PTR_TO BYTE;
    i : UINT;
    stp: UINT;
    sta: UINT;
  END_VAR

  ps := ADR(BUFFER_TO_STRING);
  IF size = 0 THEN RETURN; END_IF;
  sta := MIN(start, size -1);
  stp := MIN(stop, size -1);

  (* check for maximum string_length *)
  IF UINT_TO_INT(stp - sta + 1) >= STRING_LENGTH THEN
    stp := sta + INT_TO_UINT(STRING_LENGTH) - 1;
  END_IF;

  FOR i := sta TO stp DO
    ps^ := pt^[i];
    ps := ps + 1;
  END_FOR;

  (* terminate the string *)
  ps^ := 0;

(* revision History
  hm  5. mar. 2008  rev 1.0
    original version

  hm  16. mar. 2008 rev 1.1
    changed type of input size to uint

  hm  13. may. 2008 rev 1.2
    changed type of pointer to array[0..32767]
    changed size of string to STRING_LENGTH

  hm  12. jun. 2008 rev 1.3
    check for pointer overrun
    change input start and stop to uint
    added type conversions to avoid warnings under codesys 3.0

  hm  23. mar. 2009 rev 1.4
    avoid writing to input stop

  hm  12. nov. 2009 rev 1.5
    limit start and stop to size -1
*)
END_FUNCTION

