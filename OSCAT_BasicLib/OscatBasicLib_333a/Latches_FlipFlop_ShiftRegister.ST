(* @PATH := '\/Logic\/FF edge triggered' *)
FUNCTION_BLOCK COUNT_BR
(*
  Count_BR is a byte counter with independen up and dn inputs. the counter counts from 0 to mx and continues at 0 after is has reached mx
  a step input sets the counters stepping width.

  version 1.0 16 jan 2008
  programmer  hugo
  tested BY tobias
*)
  VAR_INPUT
    SET : BOOL;
    IN : BYTE;
    UP : BOOL;
    DN : BOOL;
    STEP : BYTE := 1;
    MX : BYTE := 255;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    CNT : BYTE;
  END_VAR
  VAR
    last_up: BOOL;
    last_dn: BOOL;
  END_VAR

  IF rst THEN
    cnt := 0;
  ELSIF set THEN
    cnt := LIMIT(0,in,mx);
  ELSIF up AND NOT last_up THEN
    cnt := INT_TO_BYTE(INC( BYTE_TO_INT(cnt),BYTE_TO_INT(step),BYTE_TO_INT(mx)));
  ELSIF dn AND NOT last_dn THEN
    cnt := INT_TO_BYTE(INC( BYTE_TO_INT(cnt),-BYTE_TO_INT(step),BYTE_TO_INT(mx)));
  END_IF;
  last_up := up;
  last_dn := dn;

(* revision history
  hm  16. jan 2008  rev 1.0
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/FF edge triggered' *)
FUNCTION_BLOCK COUNT_DR
(*
  Count_DR is a DWORD counter with independen up and dn inputs. the counter counts from 0 to mx and continues at 0 after is has reached mx
  a step input sets the counters stepping width.

  version 1.1 20. jan. 2011
  programmer  hugo
  tested BY   tobias
*)
  VAR_INPUT
    SET : BOOL;
    IN : DWORD;
    UP : BOOL;
    DN : BOOL;
    STEP : DWORD := 1;
    MX : DWORD := 16#FFFFFFFF;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    CNT : DWORD;
  END_VAR
  VAR
    last_up: BOOL;
    last_dn: BOOL;
  END_VAR

  IF rst THEN
    cnt := 0;
  ELSIF set THEN
    cnt := LIMIT(0,in,mx);
  ELSIF up AND NOT last_up THEN
    IF STEP > UDINT_TO_DWORD( DWORD_TO_UDINT(MX) - DWORD_TO_UDINT(CNT)) THEN
      CNT := UDINT_TO_DWORD( DWORD_TO_UDINT(CNT) - DWORD_TO_UDINT(MX) + DWORD_TO_UDINT(STEP) - 1);
    ELSE
      CNT := UDINT_TO_DWORD( DWORD_TO_UDINT(CNT) + DWORD_TO_UDINT(STEP));
    END_IF;
  ELSIF dn AND NOT last_dn THEN
    IF STEP > CNT THEN
      CNT := UDINT_TO_DWORD( DWORD_TO_UDINT(CNT) - DWORD_TO_UDINT(STEP) + DWORD_TO_UDINT(MX) + 1);
    ELSE
      CNT := UDINT_TO_DWORD( DWORD_TO_UDINT(CNT) - DWORD_TO_UDINT(STEP));
    END_IF;
  END_IF;
  last_up := up;
  last_dn := dn;

(* revision history
  hm  12. jun 2008  rev 1.0
    original version

  hm  20. jan. 2011 rev 1.1
    corrected init value of MX to 16#FFFFFFFF
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/FF edge triggered' *)
FUNCTION_BLOCK FF_D2E
(*
  dual D-type flip flop with reset and rising clock trigger

  version 1.3 14. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    D0 : BOOL;
    D1 : BOOL;
    CLK : BOOL;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    Q0 : BOOL;
    Q1 : BOOL;
  END_VAR
  VAR
    edge : BOOL;
  END_VAR

  IF rst THEN
    Q0 := FALSE;
    Q1 := FALSE;
  ELSIF clk AND NOT edge THEN
    Q0 := D0;
    Q1 := D1;
  END_IF;
  edge := CLK;

(* revision history
  hm  25. dec 2007  rev 1.0
    original version

  hm  27. dec 2007  rev 1.1
    changed code for better performance

  hm  30. oct. 200  rev 1.2
    deleted unnecessary init with 0

  hm  14. mar. 2009 rev 1.3
    removed double assignments
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/FF edge triggered' *)
FUNCTION_BLOCK FF_D4E
(*
  quad D-type flip flop with reset and rising clock trigger

  version 1.3 14. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    D0 : BOOL;
    D1 : BOOL;
    D2 : BOOL;
    D3 : BOOL;
    CLK : BOOL;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    Q0 : BOOL;
    Q1 : BOOL;
    Q2 : BOOL;
    Q3 : BOOL;
  END_VAR
  VAR
    edge : BOOL;
  END_VAR

  IF rst THEN
    Q0 := FALSE;
    Q1 := FALSE;
    Q2 := FALSE;
    Q3 := FALSE;
  ELSIF clk AND NOT edge THEN
    Q0 := D0;
    Q1 := D1;
    Q2 := D2;
    Q3 := D3;
  END_IF;
  edge := CLK;

(* revision history
  hm  4. aug 2006 rev 1.0
    original version

  hm  27. dec 2007  rev 1.1
    changed code for better performance

  hm  30. oct. 200  rev 1.2
    deleted unnecessary init with 0

  hm  14. mar. 2009 rev 1.3
    removed double assignments
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/FF edge triggered' *)
FUNCTION_BLOCK FF_DRE
(*
  D-type flip flop with set, reset and rising clock trigger

  version 1.2 30. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    SET : BOOL;
    D : BOOL;
    CLK : BOOL;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
  END_VAR
  VAR
    edge : BOOL;
  END_VAR

  IF rst OR set THEN
    Q := NOT rst;
  ELSIF clk AND NOT edge THEN
    Q := D;
  END_IF;
  edge := CLK;

(* revision history
  hm  4. aug 2006   rev 1.0
    original version

  hm  27. dec 2007  rev 1.1
    changed code for better performance

  hm  30. oct. 2008 rev 1.2
    optimized performance
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/FF edge triggered' *)
FUNCTION_BLOCK FF_JKE
(*
  JK-type flip flop with set, reset and rising clock trigger
  set and reset are asynchron while the FF is rising edge triggered
  J=0 and K=0 and CLK >>> no action
  J=1 and K=0 and CLK >>> output = 1
  J=0 and K=1 and CLK >>> output = 0
  J=1 and K=1 and CLK >>> toggle output

  version 1.2 30. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    SET : BOOL;
    J : BOOL;
    CLK : BOOL;
    K : BOOL;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
  END_VAR
  VAR
    edge : BOOL;
  END_VAR

  IF rst OR set THEN
    Q := NOT rst;
  ELSIF clk AND NOT edge THEN
    IF J XOR K THEN Q := J;
    ELSE Q := K XOR Q;
    END_IF;
  END_IF;
  edge := CLK;

(* revision history
  hm  4. aug 2006   rev 1.0
    original version

  hm  27. dec 2007  rev 1.1
    changed code for better performance

  hm  30. oct. 2008 rev 1.2
    optimized performance
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/FF edge triggered' *)
FUNCTION_BLOCK FF_RSE
(*
  this is a rising edge triggered rs flip flop
  a rising edge on CS sets Q = TRUE and a rising edge on CR sets Q = FALSE.
  CR has priority over CS.

  version 1.0 16. jul. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    CS : BOOL;
    CR : BOOL;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
  END_VAR
  VAR
    es, er : BOOL;
  END_VAR

  IF rst THEN
    (* asynchronous reset *)
    Q := FALSE;
  ELSIF CR AND NOT er THEN
    (* rising edge on CR *)
    Q := FALSE;
  ELSIF CS AND NOT es THEN
    (* rising edge on CS *)
    Q := TRUE;
  END_IF;
  es := CS;
  er := CR;

(* revision history
  hm  16. jul. 2008 rev 1.0
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/FF edge triggered' *)
FUNCTION_BLOCK SELECT_8
(*
  select_8 selects one of 8 outputs at any time. the outputscan be selected by up or down keys and an independent anable switches all outouts off if set false

  version 1.1 27. feb. 2009
  programmer  hugo
  tested BY   oscat
*)
  VAR_INPUT
    E : BOOL;
    SET : BOOL;
    IN : BYTE;
    UP : BOOL;
    DN : BOOL;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7 : BOOL;
    STATE : INT;
  END_VAR
  VAR
    last_up: BOOL;
    last_dn : BOOL;
  END_VAR

  IF rst THEN
    state := 0;
  ELSIF set THEN
    state := BYTE_TO_INT(IN);
  ELSIF up AND NOT last_up THEN
    state := inc(state,1,7);
  ELSIF dn AND NOT last_dn THEN
    state := inc(state,-1,7);
  END_IF;
  last_UP := UP;
  last_DN := DN;

  Q0 := FALSE;
  Q1 := FALSE;
  Q2 := FALSE;
  Q3 := FALSE;
  Q4 := FALSE;
  Q5 := FALSE;
  Q6 := FALSE;
  Q7 := FALSE;

  IF E THEN
    CASE state OF
      0: Q0 := TRUE;
      1: Q1 := TRUE;
      2: Q2 := TRUE;
      3: Q3 := TRUE;
      4: Q4 := TRUE;
      5: Q5 := TRUE;
      6: Q6 := TRUE;
      7: Q7 := TRUE;
    END_CASE;
  END_IF;

(* revision history
  hm  16. jan 2008  rev 1.0
    original version

  hm  27. feb. 2009 rev 1.1
    renamed input en to e
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/FF edge triggered' *)
FUNCTION_BLOCK SHR_4E
(*
  4 bit shift register with reset

  version 1.1 25. oct. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    SET : BOOL;
    D0: BOOL;
    CLK: BOOL;
    RST: BOOL;
  END_VAR
  VAR_OUTPUT
    Q0: BOOL;
    Q1: BOOL;
    Q2: BOOL;
    Q3: BOOL;
  END_VAR
  VAR
    trig : R_TRIG;
  END_VAR

  (* trig.Q signals a rising edge on clk *)
  trig(clk := clk);

  IF set OR rst THEN
    Q0 := NOT rst;
    Q1 := Q0;
    Q2 := Q0;
    Q3 := Q0;
  ELSIF trig.Q THEN
    Q3 := Q2;
    Q2 := Q1;
    Q1 := Q0;
    Q0 := D0;
  END_IF;

(* revision history
  hm  4. aug. 2006  rev 1.0
    original version

  hm  25. oct. 2008 rev 1.1
    optimized code
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/FF edge triggered' *)
FUNCTION_BLOCK SHR_4UDE
(*
  4 bit shift register with reset up / down direction input

  version 1.2 14. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    SET : BOOL;
    D0: BOOL;
    D3: BOOL;
    CLK: BOOL;
    DN : BOOL;
    RST: BOOL;

  END_VAR
  VAR_OUTPUT
    Q0: BOOL;
    Q1: BOOL;
    Q2: BOOL;
    Q3: BOOL;
  END_VAR
  VAR
    trig : R_TRIG;
  END_VAR

  (* trig.Q signals a rising edge on clk *)
  trig(clk := clk);

  IF set OR rst THEN
    Q0 := NOT RST;
    Q1 := Q0;
    Q2 := Q0;
    Q3 := Q0;
  ELSIF trig.Q THEN
    IF dn THEN
      Q0 := Q1;
      Q1 := Q2;
      Q2 := Q3;
      Q3 := D3;
    ELSE
      Q3 := Q2;
      Q2 := Q1;
      Q1 := Q0;
      Q0 := D0;
    END_IF;
  END_IF;

(* revision history
  hm  4. aug. 2006  rev 1.0
    original version

  hm  25. oct. 2008 rev 1.1
    optimized code

  hm  14. mar. 2009 rev 1.2
    removed double assignments
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/FF edge triggered' *)
FUNCTION_BLOCK SHR_8PLE
(*
  8 bit shift register with reset and parallel load
  the register can shift up or down
  it also has a serial input.
  the Din input is on Bit0 for up shift and on bit 7 for down shift
  the Dout output is on Bit7 for up shift and on bit 0 for down shift
  paralle clock is performed clock synchron while a shift is performed first and then the register is reloaded

  version 1.0 4 aug 2006
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    Din : BOOL;
    Dload : BYTE;
    CLK: BOOL;
    UP: BOOL :=1;
    load : BOOL;
    RST: BOOL;
  END_VAR
  VAR_OUTPUT
    DOut: BOOL;
  END_VAR
  VAR
    edge : BOOL :=1;
    register : BYTE;
  END_VAR

  (* flankenerkennung clk wird high und edge war high reset ist nicht aktiv und set ist nicht aktiv *)
  IF CLK AND edge AND NOT rst THEN
    edge := FALSE;  (* flanke wurde erkannt und weitere flankenerkennung wird verhindert bis edge wieder true ist *)
    (* hier ist der code für das flankenevent *)
    IF UP THEN            (*shift up *)
      register := SHL(register,1);
      register.0 := Din;
      Dout := register.7;
    ELSE                (* shift down *);
      register := SHR(register,1);
      register.7 := Din;
      Dout := register.0;
    END_IF;
    IF load THEN              (* the byte on Din will be loaded if load = true *)
      register := Dload;
      IF up THEN Dout := register.7; ELSE Dout := register.0; END_IF;
    END_IF;
  END_IF;
  IF NOT clk THEN edge := TRUE; END_IF; (* sobald clk wieder low wird warten auf nächste flanke *)
  IF rst THEN                 (* wenn reset aktiv dann ausgang rücksetzen *)
    register := 0;
    Dout := FALSE;
  END_IF;
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/FF edge triggered' *)
FUNCTION_BLOCK SHR_8UDE
(*
  8 bit shift register with reset

  version 1.2 14. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    SET : BOOL;
    D0: BOOL;
    D7: BOOL;
    CLK: BOOL;
    DN : BOOL;
    RST: BOOL;
  END_VAR
  VAR_OUTPUT
    Q0: BOOL;
    Q1: BOOL;
    Q2: BOOL;
    Q3: BOOL;
    Q4: BOOL;
    Q5: BOOL;
    Q6: BOOL;
    Q7: BOOL;
  END_VAR
  VAR
    trig : R_TRIG;
  END_VAR

  (* trig.Q signals a rising edge on clk *)
  trig(clk := clk);

  IF set OR rst THEN
    Q0 := NOT RST;
    Q1 := Q0;
    Q2 := Q0;
    Q3 := Q0;
    Q4 := Q0;
    Q5 := Q0;
    Q6 := Q0;
    Q7 := Q0;
  ELSIF trig.Q THEN
    IF dn THEN
      Q0 := Q1;
      Q1 := Q2;
      Q2 := Q3;
      Q3 := Q4;
      Q4 := Q5;
      Q5 := Q6;
      Q6 := Q7;
      Q7 := D7;
    ELSE
      Q7 := Q6;
      Q6 := Q5;
      Q5 := Q4;
      Q4 := Q3;
      Q3 := Q2;
      Q2 := Q1;
      Q1 := Q0;
      Q0 := D0;
    END_IF;
  END_IF;

(* revision history
  hm  4. aug. 2006  rev 1.0
    original version

  hm  25. oct. 2008 rev 1.1
    optimized code

  hm  14. mar. 2009 rev 1.2
    removed double assignments
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/FF edge triggered' *)
FUNCTION_BLOCK TOGGLE
(*
  toggle flip flop the output changes state with every rising edge of clk.

  version 1.1 30. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    CLK : BOOL;
    rst : BOOL;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
  END_VAR
  VAR
    edge : BOOL;
  END_VAR

  IF rst THEN
    q := 0;
  ELSIF clk AND NOT edge THEN
    Q := NOT Q;
  END_IF;
  edge := clk;

(* revision history
  hm  13.9.2007   rev 1.0
    original version

  hm  30. oct. 2008 rev 1.1
    deleted unnecessary init
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/FF pulse triggered' *)
FUNCTION_BLOCK LTCH
(*
  Transparent Latch with asynchronous reset

  version 1.2 30. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    D : BOOL;
    L : BOOL;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
  END_VAR

  (* as long as L is true, the latch is transparent and and change of D is transferred to Q *)
  (* of course only when there is no asynchronous reset *)
  IF rst THEN       (* if asynchronous reset then Q=0 *)
    Q := FALSE;
  ELSIF L THEN      (* latch is transparent *)
    Q := D;
  END_IF;

(* revision history
  hm  4. aug 2006   rev 1.0
    original version

  hm  27. dec 2007  rev 1.1
    changed code for better performance

  hm  30. oct. 2008 rev 1.2
    deleted unnecessary init with 0
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/FF pulse triggered' *)
FUNCTION_BLOCK LTCH_4
(*
  Quad Transparent Latch with asynchronous reset

  version 1.3 14. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    D0 : BOOL;
    D1 : BOOL;
    D2 : BOOL;
    D3 : BOOL;
    L : BOOL;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    Q0 : BOOL;
    Q1 : BOOL;
    Q2 : BOOL;
    Q3 : BOOL;
  END_VAR

  (* as long as L is true, the latch is transparent and and change of D is transferred to Q *)
  (* of course only when there is no asynchronous reset *)
  IF rst THEN     (* if asynchronous reset then Q=0 *)
    Q0 := FALSE;
    Q1 := FALSE;
    Q2 := FALSE;
    Q3 := FALSE;
  ELSIF L THEN      (* latch is transparent *)
    Q0 := D0;
    Q1 := D1;
    Q2 := D2;
    Q3 := D3;
  END_IF;

(* revision history
  hm  4. aug 2006 rev 1.0
    original version

  hm  27. dec 2007  rev 1.1
    changed code for better performance

  hm  30. oct. 2008 rev 1.2
    deleted unnecessary init with 0

  hm  14. mar. 2009 rev 1.3
    removed double assignments
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/FF pulse triggered' *)
FUNCTION_BLOCK STORE_8
(*
  Store_4 stores up to 4 boolean inputs until a reset is clearing the outputs.
  the respective output is set with a true at the respective input and stays true until a reset is generated.
  a set input is used to set all outputs true at the same time, independent of their inputs.
  a clear input is used to reset only the lowest priority of the outputs one at a time.
  the lowest priority is q3.

  version 1.2 14. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    Set : BOOL;
    D0,D1, D2, D3, D4, D5, D6, D7 : BOOL;
    Clr : BOOL;
    Rst : BOOL;
  END_VAR
  VAR_OUTPUT
    Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7 : BOOL;
  END_VAR
  VAR
    edge: BOOL;
  END_VAR

  IF rst OR set THEN
    q0 := NOT rst;
    q1 := q0;
    q2 := q0;
    q3 := q0;
    q4 := q0;
    q5 := q0;
    q6 := q0;
    q7 := q0;
  ELSE
    IF D0 THEN Q0 := TRUE; END_IF;
    IF D1 THEN Q1 := TRUE; END_IF;
    IF D2 THEN Q2 := TRUE; END_IF;
    IF D3 THEN Q3 := TRUE; END_IF;
    IF D4 THEN Q4 := TRUE; END_IF;
    IF D5 THEN Q5 := TRUE; END_IF;
    IF D6 THEN Q6 := TRUE; END_IF;
    IF D7 THEN Q7 := TRUE; END_IF;

    IF clr AND NOT edge THEN
      IF q0 THEN q0 := FALSE;
      ELSIF q1 THEN q1 := FALSE;
      ELSIF q2 THEN q2 := FALSE;
      ELSIF q3 THEN q3 := FALSE;
      ELSIF q4 THEN q4 := FALSE;
      ELSIF q5 THEN q5 := FALSE;
      ELSIF q6 THEN q6 := FALSE;
      ELSE q7 := FALSE;
      END_IF;
    END_IF;
    edge := clr;
  END_IF;

(* revision history
  hm  25.12.2007  rev 1.0
    original version

  hm  30. oct. 2008 rev 1.1
    optimized performance

  hm  14. mar. 2009 rev 1.2
    removed double assignments
*)
END_FUNCTION_BLOCK

