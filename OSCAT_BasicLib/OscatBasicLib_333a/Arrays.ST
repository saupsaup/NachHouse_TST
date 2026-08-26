TYPE
  OSCAT_BASIC_ARRAY0_32000_OF_REAL : ARRAY[0..32000] OF REAL;
  OSCAT_BASIC_ARRAY1_32000_OF_REAL : ARRAY[1..32000] OF REAL;
END_TYPE


(* @PATH := '\/Mathematical\/Array' *)
FUNCTION _ARRAY_ABS : BOOL
(*
  this function will calculate the absolute value of each element of the array and stroe the result instead of the element.
  Array[i] := ABS(ARRAY[i]).
  the function needs to be called:  array_avg(adr("array"),sizeof("array"));
  because this function works with pointers its very time efficient and it needs no extra memory.

  version 1.0 2. apr. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    pt : PTR_TO OSCAT_BASIC_ARRAY0_32000_OF_REAL;
    size : UINT;
  END_VAR
  VAR
    i: UINT;
    stop: UINT;
  END_VAR

  stop := WORD_TO_UINT(SHR(UINT_TO_WORD(size),2))-1;
  FOR i := 0 TO stop DO
    PT^[i] := ABS(PT^[i]);
  END_FOR;
  _ARRAY_ABS := TRUE;

(* revision history
  hm  2. apr 2008   rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Array' *)
FUNCTION _ARRAY_ADD : BOOL
(*
  this function will add an offset X to each element of the array and stroe the result instead of the element.
  Array[i] := ARRAY[i] + X.
  the function needs to be called:  array_avg(adr("array"),sizeof("array"));
  because this function works with pointers its very time efficient and it needs no extra memory.

  version 1.0 2. apr. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    pt : PTR_TO OSCAT_BASIC_ARRAY0_32000_OF_REAL;
    size : UINT;
    X : REAL;
  END_VAR
  VAR
    i: UINT;
    stop: UINT;
  END_VAR

  stop := WORD_TO_UINT(SHR(UINT_TO_WORD(size),2))-1; //SHR(size,2)-1;
  FOR i := 0 TO stop DO
    PT^[i] := PT^[i] + X;
  END_FOR;
  _ARRAY_ADD := TRUE;

(* revision history
  hm  2. apr 2008   rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Array' *)
FUNCTION _ARRAY_INIT : BOOL
(*
  this function will initialize a given array with a value init.
  the function needs to be called:  _array_init(adr("array"),sizeof("array"));
  this function will manipulate a given array.
  the function manipulates the original array, it rerturnes true when finished.
  because this function works with pointers its very time efficient and it needs no extra memory.

  version 1.3 16 mar 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    pt : PTR_TO OSCAT_BASIC_ARRAY0_32000_OF_REAL;
    size : UINT;
    init : REAL;
  END_VAR
  VAR
    i: UINT;
    stop: UINT;
  END_VAR

  stop := WORD_TO_UINT(SHR(UINT_TO_WORD(size),2))-1; //SHR(size,2)-1;
  FOR i := 0 TO stop DO
    pt^[i] := init;
  END_FOR;

  _array_init := TRUE;

(* revision History
  hm 6.1.2007   rev 1.1
    change type of function to bool
    added  array_init := true to set output true.

  hm  14.11.2007  rev 1.2
    changed stop calculation to be more efficient

  hm  16.3. 2008    rev 1.3
    changed type of input size to uint
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Array' *)
FUNCTION _ARRAY_SORT : BOOL
(*
  this function will sort a given array.
  the function needs to be called:  _array_sort(adr("array"),sizeof("array"));
  this function will manipulate a given array.
  the function will not return anything except true, it will instead manipulate the original array.
  because this function works with pointers its very time efficient and it needs no extra memory.

  version 2.0 19. jan. 2011
  programmer  Alexander Trikitis
  tested by oscat
*)
  VAR_INPUT
    PT : PTR_TO OSCAT_BASIC_ARRAY1_32000_OF_REAL; // ARRAY[1..32000] OF REAL;
    SIZE : UINT;
  END_VAR
  VAR
    stack_count: UINT;        (* Laufvariable Stack*)
    stack: ARRAY[1..32] OF UINT;  (* Stackgröße~ 1,6*Log(n)/log(2) *)
                      (* Stackgröße 32 => ~1 Mio Elemente *)
    links: UINT;            (* Anfangselement des Arrays *)
    rechts: UINT;           (* Endelement des Arrays *)
    pivot: REAL;            (* temporärer Schwellwert für Tauschbedingung *)
    i: UINT;              (* Laufvariable1 *)
    j: UINT;              (* Laufvariable2 *)
    ende_innen: BOOL;       (* Ende innere Schleife *)
    ende_aussen: BOOL;        (* Ende äußere Schleife *)
    tmp: REAL;            (* Hilfsvariable zum Tauschen von Werten *)
  END_VAR

  (* Startwerte zur Arraygröße *)
  links := 1;         (* Anfangselement des Arrays *)
  rechts :=  WORD_TO_UINT(SHR(UINT_TO_WORD(size),2)); //SHR(size,2);    (* Endelement des Arrays *)
  stack_count := 1;     (* Laufvariable Stack *)

  WHILE NOT ende_aussen DO            (* äußere Schleife *)
    IF links < rechts THEN
      pivot := PT^[WORD_TO_UINT(SHR(UINT_TO_WORD(rechts+links),1))];      (* Wert des mittleren Elements als Pivot-Wert *)
      i := links -1;
      j := rechts +1;

      (* innere Schleife, teile Feld *)
      ende_innen := FALSE;
      REPEAT

        (* steigende Reihenfolge *)
        REPEAT  i := i+1; UNTIL (PT^[i] >= pivot) OR NOT (i < rechts) END_REPEAT;
        REPEAT  j := j-1; UNTIL (PT^[j] <= pivot) OR NOT (j > links)  END_REPEAT;


        (*sinkende Reihenfolge *)
  (*      REPEAT  i := i+1; UNTIL (PT^[i] <= pivot) OR NOT (i < rechts) END_REPEAT  *)
  (*      REPEAT  j := j-1; UNTIL (PT^[j] >= pivot) OR NOT (j > links)  END_REPEAT  *)

        IF i >= j THEN
          ende_innen := TRUE;
        ELSE
             tmp := PT^[j];
          PT^[j] := PT^[i];
          PT^[i] := tmp;
        END_IF;

      UNTIL ende_innen END_REPEAT;

      (* Push stack *)
      stack[stack_count] := rechts;   (* rechten Teil später sortieren *)
      IF Stack_count < 32 THEN
        stack_count := stack_count +1;
      ELSE
        ende_aussen := TRUE;
        _ARRAY_SORT := FALSE;         (* Fehler: Stack zu klein *)
      END_IF;

      (* linken Teil sortiern *)
      rechts := MAX(links, i-1);

    ELSE

      IF stack_count = 1 THEN
        ende_aussen := TRUE;
      ELSE

        links := rechts+1;

        (* pop stack *)
        stack_count := stack_count -1;    (* jetzt rechten Teil sortierne *)
        rechts:= stack[stack_count];
      END_IF;

    END_IF;

  END_WHILE;

  _ARRAY_SORT := TRUE;        (* Sortierung beendet *)


(* algorithm used before rev 2.0
  size := SHR(size,2);
  size2 := UINT_TO_INT(SHR(size,1));
  FOR i := SIZE2  TO 1 BY -1 DO
    j:=i;
      WHILE j <= SIZE2 DO
        stop := j * 2 + 1;
          IF stop > UINT_TO_INT(SIZE) THEN stop := stop - 1;
          ELSIF pt^[stop-1] > pt^[stop] THEN stop := stop - 1;
      END_IF;
          IF pt^[j] < pt^[stop] THEN
            temp := pt^[j];
              pt^[j] := pt^[stop];
              pt^[stop] := temp;
          END_IF;
          j := stop;
      END_WHILE;
  END_FOR;
*)

(* heapsort
  FOR heapsize := UINT_TO_INT(size) TO 1 BY -1 DO
    popmax := pt^[1];
    pt^[1] := pt^[heapsize];
      i := 1;
    hs2 := SHR(heapsize,1);
    WHILE i <= hs2 DO
          stop := i * 2 + 1;
            IF stop > heapsize THEN stop := stop - 1;
            ELSIF pt^[stop-1] > pt^[stop] THEN stop := stop - 1;
      END_IF;
            IF pt^[i] < pt^[stop] THEN
                  temp := pt^[i];
                  pt^[i] := pt^[stop];
                  pt^[stop] := temp;
            END_IF;
            i := stop;
        END_WHILE;
    pt^[heapsize] := popmax;
  END_FOR;

  _ARRAY_SORT2 := TRUE;
*)

(* old algorithm bubble sort used before rev 1.2
  stop := (size - SIZEOF(pt)) / SIZEOF(pt);
  FOR i := 0 TO stop - 1 DO
    FOR m := i + 1 TO stop DO
      IF pt^[i] > pt^[m] THEN
        temp := pt^[i];
        pt^[i] := pt^[m];
        pt^[m] := temp;
      END_IF;
    END_FOR;
  END_FOR;
  _array_sort := TRUE;
*)

(* revision history
  hm  6.1.2007  rev 1.1
    changed return value to true

  hm  22. sep 2007  rev 1.2
    changed sorting algorithm to heap sort for performance reasons

  hm  14. nov 2007  rev 1.3
    changed calculation of stop to be more efficient

  hm  15 dec 2007 rev 1.4
    added function return true

  hm  5. jan 2008   rev 1.5
    improved performance

  hm  16. mar. 2008 rev 1.6
    changed type of input size to uint

  hm  28. mar. 2008 rev 1.7
    changed input f to pt

  hm  19. jan. 2011 rev 2.0
    new faster algorithm using qucksort (Alexander Drikitis)
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Array' *)
FUNCTION _ARRAY_MEDIAN : REAL
(*
  this function will calculate the median of a given array.
  in order to do so the ariginal array is sorted and stays sorted after the function finishes
  the function needs to be called:  _array_median(adr("array"),sizeof("array"));
  this function will manipulate a given array.
  the function will return the median of the original array.
  for example [12,0,4,7,1] the median is 4 and the array after the function is called is [0,1,4,7,12]
  because this function works with pointers its very time efficient and it needs no extra memory.

  version 1.5 16 mar 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    pt : PTR_TO OSCAT_BASIC_ARRAY0_32000_OF_REAL;
    size : UINT;
  END_VAR
  VAR
    i: UINT;
    stop: UINT;
  END_VAR

  _ARRAY_SORT(pt,size);
  stop := WORD_TO_UINT(SHR(UINT_TO_WORD(size),2))-1; //SHR(size,2)-1;
  IF EVEN(UINT_TO_DINT(stop)) THEN
    _ARRAY_MEDIAN := pt^[WORD_TO_UINT(SHR(UINT_TO_WORD(stop),1))];
  ELSE
    i := WORD_TO_UINT(SHR(UINT_TO_WORD(stop),1));
    _ARRAY_MEDIAN := (pt^[i] + pt^[i+1]) * 0.5;
  END_IF;

(* old code
  stop := (size - SIZEOF(pt)) / SIZEOF(pt);
  FOR i := 0 TO stop - 1 DO
    FOR m := i + 1 TO stop DO
      IF pt^[i] > pt^[m] THEN
        temp := pt^[i];
        pt^[i] := pt^[m];
        pt^[m] := temp;
      END_IF;
    END_FOR;
  END_FOR;
  IF even(stop) THEN
    _array_median := pt^[stop/2];
  ELSE
    i := stop/2;
    _array_median := (pt^[i] + pt^[i+1])/2;
  END_IF;
*)
(* revision history
  hm  3.3.2007    rev 1.1
    corrected an error, changed the statement line 14 i := TRUNC(stop/2); to i := stop/2;

  hm    22. sep 2007  rev 1.2
    changed algorithm to use _array_soft for performance reasons

  hm    8. oct 2007   rev 1.3
    deleted unused variables m and temp

  hm    14. nov 2007  rev 1.4
    corrected a problem with size calculation

  hm    16.3. 2008    rev 1.5
    changed type of input size to uint
    performance improvements
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Array' *)
FUNCTION _ARRAY_MUL : BOOL
(*
  this function will multiply each element of the array and stroe the result instead of the element.
  Array[i] := ARRAY[i] * X.
  the function needs to be called:  array_avg(adr("array"),sizeof("array"));
  because this function works with pointers its very time efficient and it needs no extra memory.

  version 1.0 2. apr. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    pt : PTR_TO OSCAT_BASIC_ARRAY0_32000_OF_REAL;
    size : UINT;
    X : REAL;
  END_VAR
  VAR
    i: UINT;
    stop: UINT;
  END_VAR

  stop := WORD_TO_UINT(SHR(UINT_TO_WORD(size),2))-1; //SHR(size,2)-1;
  FOR i := 0 TO stop DO
    PT^[i] := PT^[i] * X;
  END_FOR;
  _ARRAY_MUL := TRUE;

(* revision history
  hm  2. apr 2008   rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Array' *)
FUNCTION _ARRAY_SHUFFLE : BOOL
(*
  this function will randomly shuffle the elements of an array

  version 1.2 30. mar. 2008
  programmer  kurt
  tested by   hugo
*)
  VAR_INPUT
    pt : PTR_TO OSCAT_BASIC_ARRAY0_32000_OF_REAL;
    size : UINT;
  END_VAR
  VAR
    temp : REAL;
    pos  : INT;
    i: INT;
    stop: INT;
  END_VAR

  stop := WORD_TO_INT(SHR(UINT_TO_WORD(size),2))-1; //UINT_TO_INT(SHR(size,2)-1);
  FOR i := 0 TO stop DO
          pos := RDM2(i+pos,0,stop);
          (* swap elements *)
          temp := pt^[i];
          pt^[i] := pt^[pos];
          pt^[pos] := temp;
  END_FOR;

  _ARRAY_SHUFFLE := TRUE;

(* revision History
  hm  4. mar 2008 rev 1.0
    original version

  hm  16. mar. 2008 rev 1.1
    changed type of input size to uint

  hm  30. mar. 2008 rev 1.2
    changed last in rdm2 fromm pos to i + pos to allow for more randomness
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Array' *)
FUNCTION ARRAY_AVG : REAL
(*
  this function will calculate the average of a given array.
  the function needs to be called:  array_avg(adr("array"),sizeof("array"));
  because this function works with pointers its very time efficient and it needs no extra memory.

  version 1.3 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    pt : PTR_TO OSCAT_BASIC_ARRAY0_32000_OF_REAL;
    size : UINT;
  END_VAR
  VAR
    i: UINT;
    stop: UINT;
  END_VAR
  VAR_TEMP
    tmp : REAL;
  END_VAR

  stop := WORD_TO_UINT(SHR(UINT_TO_WORD(size),2))-1; //SHR(size,2)-1;
  tmp := pt^[0];
  FOR i := 1 TO stop DO
    tmp := tmp + pt^[i];
  END_FOR;
  tmp := tmp / UINT_TO_REAL(stop + 1);
  ARRAY_AVG := tmp;

(* revision history
  hm  2. oct 2007   rev 1.0
    original version

  hm  12. dec 2007  rev 1.1
    chaged code for better performance

  hm  16. mar. 2008 rev 1.2
    changed input size to uint

  hm  10. mar. 2009 rev 1.3
    added type conversion for compatibility reasons
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Array' *)
FUNCTION ARRAY_GAV : REAL
(*
  this function will calculate the geometric average of a given array.
  the function needs to be called:  array_avg(adr("array"),sizeof("array"));
  because this function works with pointers its very time efficient and it needs no extra memory.

  version 1.1 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    pt : PTR_TO OSCAT_BASIC_ARRAY0_32000_OF_REAL;
    size : UINT;
  END_VAR
  VAR
    i: UINT;
    stop: UINT;
  END_VAR
  VAR_TEMP
    tmp : REAL;
  END_VAR

  stop := WORD_TO_UINT(SHR(UINT_TO_WORD(size),2))-1; //SHR(size,2)-1;
  tmp := 1.0;
  FOR i := 0 TO stop DO
    IF pt^[i] > 0.0 THEN
      tmp := tmp * pt^[i];
    ELSE
      tmp := 0.0;
      RETURN;
    END_IF;
  END_FOR;
  tmp := SQRTN(tmp,UINT_TO_INT(stop)+1);
  ARRAY_GAV := tmp;

(* revision history
  hm  2. apr 2008 rev 1.0
    original version

  hm  10. mar. 2009 rev 1.1
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Array' *)
FUNCTION ARRAY_HAV : REAL
(*
  this function will calculate the harmonic average of a given array.
  the function needs to be called:  array_avg(adr("array"),sizeof("array"));
  because this function works with pointers its very time efficient and it needs no extra memory.

  version 1.1 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    pt : PTR_TO OSCAT_BASIC_ARRAY0_32000_OF_REAL;
    size : UINT;
  END_VAR
  VAR
    i: UINT;
    stop: UINT;
  END_VAR
  VAR_TEMP
    tmp : REAL;
  END_VAR

  stop := WORD_TO_UINT(SHR(UINT_TO_WORD(size),2))-1; //SHR(size,2)-1;
  FOR i := 0 TO stop DO
    IF pt^[i] <> 0.0 THEN
      tmp := tmp + 1.0 / pt^[i];
    ELSE
      tmp := 0.0;
      RETURN;
    END_IF;
  END_FOR;
  tmp := UINT_TO_REAL(stop + 1) / tmp;
  ARRAY_HAV := tmp;

(* revision history
  hm  2. apr 2008 rev 1.0
    original version

  hm  10. mar. 2009 rev 1.1
    real constants updated to new systax using dot
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Array' *)
FUNCTION ARRAY_MAX : REAL
(*
  this function will calculate the max value of a given array.
  the function needs to be called:  array_max(adr("array"),sizeof("array"));
  because this function works with pointers its very time efficient and it needs no extra memory.

  version 1.1 16. mar. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    pt : PTR_TO OSCAT_BASIC_ARRAY0_32000_OF_REAL;
    size : UINT;
  END_VAR
  VAR
    i: UINT;
    stop: UINT;
  END_VAR
  VAR_TEMP
    tmp : REAL;
  END_VAR

  stop := (size -SIZEOF(pt)) / SIZEOF(pt);
  tmp := pt^[0];
  FOR i := 1 TO stop DO
    IF pt^[i] > tmp THEN tmp := pt^[i]; END_IF;
  END_FOR;
  ARRAY_MAX := tmp;

(* revision history
  hm  2. oct 2006   rev 1.0
    original version

  hm  16. mar. 2008 rev 1.1
    changed input size to uint
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Array' *)
FUNCTION ARRAY_MIN : REAL
(*
  this function will calculate the min value of a given array.
  the function needs to be called:  array_min(adr("array"),sizeof("array"));
  because this function works with pointers its very time efficient and it needs no extra memory.

  version 1.1 16. mar. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    pt : PTR_TO OSCAT_BASIC_ARRAY0_32000_OF_REAL;
    size : UINT;
  END_VAR
  VAR
    i: UINT;
    stop: UINT;
  END_VAR
  VAR_TEMP
    tmp : REAL;
  END_VAR

  stop := (size - SIZEOF(pt)) / SIZEOF(pt);
  tmp := pt^[0];
  FOR i := 1 TO stop DO
    IF pt^[i] < tmp THEN tmp := pt^[i]; END_IF;
  END_FOR;
  ARRAY_MIN := tmp;

(* revision history
  hm    2. oct. 2006
    original version

  hm    16. mar. 2008
    changed type of input size to uint
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Array' *)
FUNCTION ARRAY_VAR : REAL
(*
  this function will calculate the variance of a given array.
  the function needs to be called:  array_var(adr("array"),sizeof("array"));
  because this function works with pointers its very time efficient and it needs no extra memory.

  version 1.3 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    pt : PTR_TO OSCAT_BASIC_ARRAY0_32000_OF_REAL;
    size : UINT;
  END_VAR
  VAR
    avg : REAL;
    i: UINT;
    stop: UINT;
  END_VAR
  VAR_TEMP
    tmp : REAL;
  END_VAR

  (* at first we calualte the arithmetic average of the array *)

  stop := WORD_TO_UINT(SHR(UINT_TO_WORD(size),2))-1; //SHR(size,2)-1;
  avg := pt^[0];
  FOR i := 1 TO stop DO
    avg := avg + pt^[i];
  END_FOR;
  avg := avg / UINT_TO_REAL(stop + 1);

  (* in a second run we calculate the variance of the array *)

  tmp := (pt^[0] - avg) * (pt^[0] - avg);
  FOR i := 1 TO stop DO
    tmp := tmp + (pt^[i] - avg) * (pt^[i] - avg);
  END_FOR;
  ARRAY_VAR := tmp / UINT_TO_REAL(stop);

(* revision history
  hm  1.4.2007  rev 1.0
    function created

  hm  12.12.2007  rev 1.1
    changed code for better performance

  hm  16. mar. 2008 rev 1.2
    changed type of input size to uint

  hm  10. mar. 2009 rev 1.3
    added type conversions for compatibility reasons
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Array' *)
FUNCTION ARRAY_SDV : REAL
(*
  this function will calculate the standard deviation of a given array.
  the function needs to be called:  array_sdv(adr("array"),sizeof("array"));
  because this function works with pointers its very time efficient and it needs no extra memory.

  version 1.1 16. mar 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    pt : PTR_TO OSCAT_BASIC_ARRAY0_32000_OF_REAL;
    size : UINT;
  END_VAR

  (* standard deviation is simply the square root of the variance *)
  array_sdv := SQRT( array_var(pt, size));

(* revision history
  hm  1.4.2007    rev 1.0
    function created

  hm  16. mar. 2008 rev 1.1
    changed type of input size to uint
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Array' *)
FUNCTION ARRAY_SPR : REAL
(*
  this function will calculate the spread of a given array.
  the function needs to be called:  array_spr(adr("array"),sizeof("array"));
  for example: spread of [12,0,4,1,7] is 12 - 0 = 12.
  because this function works with pointers its very time efficient and it needs no extra memory.

  version 1.1 16. mar. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    pt : PTR_TO OSCAT_BASIC_ARRAY0_32000_OF_REAL;
    size : UINT;
  END_VAR
  VAR
    i: UINT;
    stop: UINT;
    array_max : REAL;
    array_min : REAL;
  END_VAR

  stop := (size -SIZEOF(pt)) / SIZEOF(pt);
  array_min := pt^[0];
  array_max := pt^[0];
  FOR i := 1 TO stop DO
    IF pt^[i] > array_max THEN array_max := pt^[i];
    ELSIF pt^[i] < array_min THEN array_min := pt^[i];
    END_IF;
  END_FOR;
  array_spr := array_max - array_min;

(* revision history
  hm  2. oct. 2006  rev 1.0
    original version

  hm  16. mar. 2008 rev 1.1
    changed type of input size to uint
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Array' *)
FUNCTION ARRAY_SUM : REAL
(*
  this function will calculate the sum of a given array.
  the function needs to be called:  array_sum(adr("array"),sizeof("array"));
  because this function works with pointers its very time efficient and it needs no extra memory.

  version 1.1 16. mar. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    pt : PTR_TO OSCAT_BASIC_ARRAY0_32000_OF_REAL;
    size : UINT;
  END_VAR
  VAR
    i: UINT;
    stop: UINT;
  END_VAR
  VAR_TEMP
    tmp : REAL;
  END_VAR

  stop := (size -SIZEOF(pt)) / SIZEOF(pt);
  tmp := pt^[0];
  FOR i := 1 TO stop DO
    tmp := tmp + pt^[i];
  END_FOR;
  ARRAY_SUM := tmp;

(* revision history
  hm  2. oct. 2006  rev 1.0
    function created

  hm  16. mar. 2008 rev 1.1
    changed type of input size to uint
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Array' *)
FUNCTION ARRAY_TREND : REAL
(*
  this function will calculate the trend of a given array.
  trend will calculate the avg of the first half of the array and then the avg of the second half, trend = avg2 - avg1.
  for example:  [0,1,4,5,3,4,6,3] = 4 - 2.5 = 1.5
  the function needs to be called:  array_trend(adr("array"),sizeof("array"));
  because this function works with pointers its very time efficient and it needs no extra memory.

  version 1.3 10. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    pt : PTR_TO OSCAT_BASIC_ARRAY0_32000_OF_REAL;
    size : UINT;
  END_VAR
  VAR
    i: UINT;
    stop: UINT;
    x: REAL;
    stop2: UINT;
  END_VAR

  stop := WORD_TO_UINT(SHR(UINT_TO_WORD(size),2))-1; //SHR(size,2)-1;
  stop2 := WORD_TO_UINT(SHR(UINT_TO_WORD(stop),1));  //SHR(stop,1);
  FOR i := 0 TO stop2 DO x := x - pt^[i]; END_FOR;
  IF EVEN(UINT_TO_DINT(stop)) THEN
    FOR i := stop2 TO stop DO X := X + pt^[i]; END_FOR;
  ELSE
    FOR i := stop2 + 1 TO stop DO X := X + pt^[i]; END_FOR;
  END_IF;
  ARRAY_TREND := x / UINT_TO_REAL(stop2 + 1);

(* revision history
  hm  2 oct 2007  rev 1.0
    original version

  hm  12 dec 2007 rev 1.1
    changed code for better performance

  hm  16. mar. 2008 rev 1.2
    changed type of input size to uint

  hm  10. mar. 2009 rev 1.3
    added type conversions for compatibility reasons
*)
END_FUNCTION


(* @PATH := '\/Mathematical\/Array' *)
FUNCTION IS_SORTED : BOOL
(*
  this function will return true if the given array is sorted in an ascending order.
  the function needs to be called:  array_sorted(adr("array"),sizeof("array"));
  because this function works with pointers its very time efficient and it needs no extra memory.

  version 1.1 4. apr. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    pt : PTR_TO OSCAT_BASIC_ARRAY0_32000_OF_REAL;
    size : UINT;
  END_VAR
  VAR
    stop: INT;
    i: INT;
  END_VAR

  stop := WORD_TO_INT(SHR(UINT_TO_WORD(size),2))-2; //UINT_TO_INT(SHR(size,2)-2);
  FOR i := 0 TO stop DO
    IF pt^[i] > pt^[i+1] THEN
      IS_SORTED := FALSE;
      RETURN;
    END_IF;
  END_FOR;

  IS_SORTED := TRUE;

(* revision history
  hm  29. mar. 2008   rev 1.0
    original version

  hm  4. apr. 2008  rev 1.1
    added type conversion to avoid warnings under codesys 3.0
*)
END_FUNCTION

