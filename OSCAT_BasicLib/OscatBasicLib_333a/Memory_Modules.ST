(* @PATH := '\/Logic\/memory' *)
FUNCTION_BLOCK FIFO_16
(*
  16 Dword FIFO memory

  version 2.0 24. jul. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    Din : DWORD;
    E : BOOL := TRUE;
    RD : BOOL;
    WD : BOOL;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    Dout : DWORD;
    EMPTY : BOOL := TRUE;
    FULL : BOOL;
  END_VAR
  VAR CONSTANT
    n : INT := 16;  (* changing this value will chage the number of stored elements in the fifo *)
  END_VAR
  VAR
    fifo : ARRAY[0..n] OF DWORD;
    pr : INT;
    pw : INT;
  END_VAR

  IF RST THEN
    pw := pr;
    FULL := FALSE;
    EMPTY := TRUE;
    Dout := 0;
  ELSIF E THEN
    IF NOT EMPTY AND RD THEN
      Dout := fifo[pr];
      pr := INC1(pr,n);
      EMPTY := pr = pw;
      FULL := FALSE;
    END_IF;
    IF NOT FULL AND WD THEN
      fifo[pw] := Din;
      pw := INC1(pw,n);
      FULL := pw = pr;
      EMPTY := FALSE;
    END_IF;
  END_IF;

(* revision history
  hm  4. aug. 2006  rev 1.0
    original version

  hm  19. feb 2008  rev 1.1
    performance improvements

  hm  17. oct. 2008 rev 1.2
    improved performance

  ks  27. oct. 2008 rev 1.3
    optimized coding

  hm  14. mar. 2009 rev 1.4
    removed double assignments

  hm 24. jul. 2009  rev 2.0
    chaged inputs E and WR to E, WD and WR
    allow read and write in one cycle
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/memory' *)
FUNCTION_BLOCK FIFO_32
(*
  32 Dword FIFO memory

  version 2.0 24. jul. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    Din : DWORD;
    E : BOOL := TRUE;
    RD : BOOL;
    WD : BOOL;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    Dout : DWORD;
    EMPTY : BOOL := TRUE;
    FULL : BOOL;
  END_VAR
  VAR CONSTANT
    n : INT := 32;  (* changing this value will chage the number of stored elements in the fifo *)
  END_VAR
  VAR
    fifo : ARRAY[0..n] OF DWORD;
    pr : INT;
    pw : INT;
  END_VAR

  IF RST THEN
    pw := pr;
    FULL := FALSE;
    EMPTY := TRUE;
    Dout := 0;
  ELSIF E THEN
    IF NOT EMPTY AND RD THEN
      Dout := fifo[pr];
      pr := INC1(pr,n);
      EMPTY := pr = pw;
      FULL := FALSE;
    END_IF;
    IF NOT FULL AND WD THEN
      fifo[pw] := Din;
      pw := INC1(pw,n);
      FULL := pw = pr;
      EMPTY := FALSE;
    END_IF;
  END_IF;

(* revision history
  hm  4. aug. 2006  rev 1.0
    original version

  hm  19. feb 2008  rev 1.1
    performance improvements

  hm  17. oct. 2008 rev 1.2
    improved performance

  ks  27. oct. 2008 rev 1.3
    improved code

  hm  14. mar. 2009 rev 1.4
    removed double assignments

  hm 24. jul. 2009  rev 2.0
    chaged inputs E and WR to E, WD and WR
    allow read and write in one cycle
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/memory' *)
FUNCTION_BLOCK STACK_16
(*
  16 Dword STACK memory

  version 2.0 25. jul 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    Din : DWORD;
    E : BOOL := TRUE;
    RD : BOOL;
    WD : BOOL;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    Dout : DWORD;
    EMPTY : BOOL := TRUE;
    FULL : BOOL;
  END_VAR
  VAR CONSTANT
    n : INT := 15;  (* changing this value will chage the number of stored elements in the fifo *)
  END_VAR
  VAR
    stack : ARRAY[0..n] OF DWORD;
    pt : INT;
  END_VAR

  IF RST THEN
    (* asynchronous reset for the fifo *)
    pt := 0;
    EMPTY := TRUE;
    FULL := FALSE;
    Dout := 0;
  ELSIF E THEN
    IF NOT EMPTY AND RD THEN
      (* read one element *)
      pt := pt - 1;
      Dout := stack[pt];
      EMPTY := pt = 0;
      FULL := FALSE;
    END_IF;
    IF NOT FULL AND WD THEN
      (* write one element *)
      stack[pt] := Din;
      pt := pt + 1;
      FULL := pt > n;
      EMPTY := FALSE;
    END_IF;
  END_IF;

(* revision history
  hm  4. aug. 2006  rev 1.0
    original version

  hm  19. feb 2008  rev 1.1
    performance improvements

  hm  17. oct. 2008 rev 1.2
    deleted unnecessary init with 0

  hm  27. oct. 2008 rev 1.3
    optimized performance

  hm  25. jul 2009  rev 2.0
    changed inputs to allow simultsaneous read and write
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/memory' *)
FUNCTION_BLOCK STACK_32
(*
  32 Dword STACK memory

  version 2.0 25. jul 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    Din : DWORD;
    E : BOOL := TRUE;
    RD : BOOL;
    WD : BOOL;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    Dout : DWORD;
    EMPTY : BOOL := TRUE;
    FULL : BOOL;
  END_VAR
  VAR CONSTANT
    n : INT := 31;  (* changing this value will chage the number of stored elements in the fifo *)
  END_VAR
  VAR
    stack : ARRAY[0..n] OF DWORD;
    pt : INT;
  END_VAR

  IF RST THEN
    (* asynchronous reset for the fifo *)
    pt := 0;
    EMPTY := TRUE;
    FULL := FALSE;
    Dout := 0;
  ELSIF E THEN
    IF NOT EMPTY AND RD THEN
      (* read one element *)
      pt := pt - 1;
      Dout := stack[pt];
      EMPTY := pt = 0;
      FULL := FALSE;
    END_IF;
    IF NOT FULL AND WD THEN
      (* write one element *)
      stack[pt] := Din;
      pt := pt + 1;
      FULL := pt > n;
      EMPTY := FALSE;
    END_IF;
  END_IF;

(* revision history
  hm  4. aug. 2006  rev 1.0
    original version

  hm  19. feb 2008  rev 1.1
    performance improvements

  hm  17. oct. 2008 rev 1.2
    deleted unnecessary init with 0

  ks  27. oct. 2008 rev 1.3
    optimized performance

  hm  25. jul 2009  rev 2.0
    changed inputs to allow simultsaneous read and write
*)
END_FUNCTION_BLOCK

