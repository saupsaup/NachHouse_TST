(* @PATH := '\/Engineering\/automation' *)
FUNCTION_BLOCK DRIVER_1
(*
  driver_1 is a multi purpose driver.
  a rising edge on in sets the output high if toggle is flase. while toggle is true, a rising edge on in toggles the output Q.
  if a timeout is specified the output q will be reset to false automatically after the timeout has elapsed.
  a asynchronous reset and set will force the output high or low respectively.

  version 1.0 2 jan 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT //???CONSTANT
    Toggle_Mode : BOOL;
    Timeout : TIME;
  END_VAR
  VAR_INPUT
    SET : BOOL;
    IN : BOOL;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
  END_VAR
  VAR
    off : TON;
    edge: BOOL;
  END_VAR

  IF off.Q THEN Q := FALSE; END_IF;
  IF rst THEN
    Q := FALSE;
  ELSIF set THEN
    Q := TRUE;
  ELSIF IN AND NOT edge THEN
    IF toggle_mode THEN q := NOT Q; ELSE q := TRUE; END_IF;
  END_IF;
  edge := in;
  IF timeout > t#0s THEN off(in := Q, PT := Timeout); END_IF;

(* revision history
  hm  2. jan 2008   rev 1.0
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/automation' *)
FUNCTION_BLOCK DRIVER_4
(*
  driver_4 is a 4 channel multi purpose driver.
  a rising edge on in? sets the output Q? high if toggle_mode is flase. while toggle_mode is true, a rising edge on in? toggles the output Q?.
  if a timeout is specified the output Q? will be reset to false automatically after the timeout has elapsed.
  a asynchronous reset and set will force the output high or low respectively.
  an asynchronous set will force all outputs high simultaneously

  version 1.0 2 jan 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT //???CONSTANT
    Toggle_Mode : BOOL;
    Timeout : TIME;
  END_VAR
  VAR_INPUT
    SET : BOOL;
    IN0, IN1, IN2, IN3 : BOOL;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    Q0, Q1, Q2, Q3 : BOOL;
  END_VAR
  VAR
    d0, d1, d2, d3 : DRIVER_1;
  END_VAR

  D0(Set:=set, in:=in0, rst:=rst, toggle_mode:=toggle_mode, timeout:=timeout);
  D1(Set:=set, in:=in1, rst:=rst, toggle_mode:=toggle_mode, timeout:=timeout);
  D2(Set:=set, in:=in2, rst:=rst, toggle_mode:=toggle_mode, timeout:=timeout);
  D3(Set:=set, in:=in3, rst:=rst, toggle_mode:=toggle_mode, timeout:=timeout);
  Q0 := D0.Q;
  Q1 := D1.Q;
  Q2 := D2.Q;
  Q3 := D3.Q;

(* revision history
  hm  2. jan 2008   rev 1.0
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/automation' *)
FUNCTION_BLOCK DRIVER_4C
(*
  driver_4C is a multi purpose driver.
  a rising edge on in switches from S0 state S1 and the next edge to state S2 and so on.
  in state S0 all outputs Q are FALSE.
  The stet of the Outputs in any state S? is configurable with setup variables.
  The variables S1..S5 define the states, while the sequence is terminated when a state Variable S? = 0.
  The lower bits 0..3 of the state vars S? are corresponding to the Outputs Q0..Q3

  version 1.0 23. mar. 2009
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    IN : BOOL;
    RST : BOOL;
  END_VAR
  VAR_INPUT //??? CONSTANT
    Timeout : TIME;
    SX : ARRAY[1..7] OF BYTE := [1,3,7,15];
  END_VAR
  VAR_OUTPUT
    SN : INT;
    Q0 : BOOL;
    Q1 : BOOL;
    Q2 : BOOL;
    Q3 : BOOL;
  END_VAR
  VAR
    off : TON;
    edge: BOOL;
  END_VAR

  IF RST OR off.Q THEN
    SN := 0;
  ELSIF IN AND NOT edge THEN
    SN := SN + 1;
    IF SN > 7 OR SX[SN] = 0 THEN SN := 0; END_IF;
  END_IF;
  edge := in;
  IF SN > 0 THEN
    Q0 := SX[SN].0;
    Q1 := SX[SN].1;
    Q2 := SX[SN].2;
    Q3 := SX[SN].3;
  ELSE
    Q0 := FALSE;
    Q1 := FALSE;
    Q2 := FALSE;
    Q3 := FALSE;
  END_IF;

  (* maximaum timeout *)
  IF timeout > t#0s THEN off(in := SN > 0, PT := Timeout); END_IF;

(* revision history
  hm  23. mar. 2009 rev 1.0
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/automation' *)
FUNCTION_BLOCK FLOW_CONTROL
(*
  FLOW_CONTROL switches a valves depending on the input in.
  flow control also limits the maximum ontime of the valve and controls pressure on the output side.

  version 1.0 28. jun. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    IN : BOOL;
    REQ : BOOL;
    ENQ : BOOL;
    RST : BOOL;
  END_VAR
  VAR_INPUT //???CONSTANT
    T_AUTO : TIME := T#1h;
    T_DELAY : TIME := T#23h;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
    STATUS : BYTE;
  END_VAR
  VAR
    timer : TP_1D;
  END_VAR

  STATUS := 100;
  IF RST THEN
    Q := FALSE;
    timer(rst := TRUE);
    timer.RST := FALSE;
    STATUS := 103;
  ELSIF ENQ THEN
    IF IN THEN
      status := 101;
    END_IF;
    IF REQ THEN
      (* timer will generate a timed pulse after TP goes high *)
      timer.PT1 := T_AUTO;
      timer.PTD := T_DELAY;
      timer.IN := TRUE;
      STATUS := 102;
    END_IF;
  END_IF;

  (* set output and run timer *)
  timer();
  timer.IN := FALSE;
  Q := (IN AND ENQ) OR timer.Q;

(* revision history
  hm  28. jun. 2008   rev 1.0
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/automation' *)
FUNCTION_BLOCK FT_Profile
(*
  FT_Profile generates an output signal which is defined by values over a time scale.
  the different values are connected by ramps between the individual values.
  a rising edge on E starts the output signal generation and E = True can delay time_3 / value_3 as long as it stays true.
  an additional multiplier K can be used to multiply the output and an offset O can be added to the output dynamically.

  version 1.1 15 sep 2007
  programmer  tobias
  tested by   hugo
*)
  VAR_INPUT
    K : REAL := 1.0;
    O : REAL;
    M : REAL := 1.0;
    E : BOOL;
  END_VAR
  VAR_INPUT //???CONSTANT
    value_0 : REAL;
    time_1 : TIME;
    value_1 : REAL;
    time_2 : TIME;
    value_2 : REAL;
    time_3 : TIME;
    value_3 : REAL;
    time_10 : TIME;
    value_10 : REAL;
    time_11 : TIME;
    value_11 : REAL;
    time_12 : TIME;
    value_12 : REAL;
    time_13 : TIME;
    value_13 : REAL;
  END_VAR
  VAR_OUTPUT
    Y : REAL;
    RUN : BOOL;
    ET : TIME;
  END_VAR
  VAR
    tx : TIME;
    edge : BOOL;
    state: BYTE;
    ta: TIME;
    tb: TIME;
    t0 : TIME;
    temp: REAL;
    va: REAL;
    vb: REAL;
  END_VAR

  (* read system time *)
  tx := DWORD_TO_TIME(T_PLC_MS());

  (* determine start condition *)
  IF E AND NOT edge THEN
    RUN := TRUE;
    ET := t#0s;
    t0 := tx;
    ta := tx;
    tb := multime(time_1, M);
    va := value_0;
    vb := value_1;
    temp := value_0;
    state := 1;
  END_IF;
  edge := E;

  (* generate startup profile *)
  IF run THEN
    CASE BYTE_TO_USINT(state) OF
      1:  IF tx - ta >= tb THEN
          ta := ta + tb;
          tb := multime(time_2 - time_1, M);
          va := value_1;
          vb := value_2;
          temp := value_1;
          state := 2;
        ELSE
          temp := ((vb - va) * TIME_TO_REAL(tx - ta) / TIME_TO_REAL(tb) + va);
        END_IF;
      2:  IF tx - ta >= tb THEN
          ta := ta + tb;
          tb := multime(time_3 - time_2, M);
          va := value_2;
          vb := value_3;
          temp := value_2;
          state := 3;
        ELSE
          temp := ((vb - va) * TIME_TO_REAL(tx - ta) / TIME_TO_REAL(tb) + va);
        END_IF;
      3:  IF tx - ta >= tb THEN
          ta := ta + tb;
          tb := multime(time_10 - time_3, M);
          va := value_3;
          vb := value_10;
          temp := value_3;
          state := 4;
        ELSE
          temp := ((vb - va) * TIME_TO_REAL(tx - ta) / TIME_TO_REAL(tb) + va);
        END_IF;
      4 : IF tx - ta >= tb THEN
          ta := ta + tb;
          tb := multime(time_11 - time_10, M);
          va := value_10;
          vb := value_11;
          temp := value_10;
          IF E THEN state := 5; ELSE state := 6; END_IF;
        ELSE
          temp := ((vb - va) * TIME_TO_REAL(tx - ta) / TIME_TO_REAL(tb) + va);
        END_IF;
      5:  (* extend the signal while E is true *)
        IF E THEN
          ta := tx;
        ELSE
          state := 6;
        END_IF;
      6:  IF tx - ta >= tb THEN
          ta := ta + tb;
          tb := multime(time_12 - time_11, M);
          va := value_11;
          vb := value_12;
          temp := value_11;
          state := 7;
        ELSE
          temp := ((vb - va) * TIME_TO_REAL(tx - ta) / TIME_TO_REAL(tb) + va);
        END_IF;
      7:  IF tx - ta >= tb THEN
          ta := ta + tb;
          tb := multime(time_13 - time_12, M);
          va := value_12;
          vb := value_13;
          temp := value_12;
          state := 8;
        ELSE
          temp := ((vb - va) * TIME_TO_REAL(tx - ta) / TIME_TO_REAL(tb) + va);
        END_IF;
      8:  IF tx - ta >= tb THEN
          temp := value_13;
          run := FALSE;
        ELSE
          temp := ((vb - va) * TIME_TO_REAL(tx - ta) / TIME_TO_REAL(tb) + va);
        END_IF;
    END_CASE;
    Y := temp * K + O;
    ET := tx - t0;
  END_IF;

(* revision history
  hm  27 feb 2007   rev 1.0
    original version

  hm  15. sep2007   rev 1.1
    replaced Time() with T_PLC_MS for compatibility and performance reasons
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/automation' *)
FUNCTION_BLOCK INC_DEC
(*
  incremental decoder with quadruple accuracy.
  2 pulses for each channel are created for each directional pulse.

  version 1.0 4 aug 2006
  programmer  oscat
  tested by   oscat
*)
  VAR_INPUT
    CHa : BOOL;
    CHb : BOOL;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    dir : BOOL;
    cnt : INT;
  END_VAR
  VAR
    edgea : BOOL;
    clk: BOOL;
    clka: BOOL;
    clkb: BOOL;
    edgeb: BOOL;
    axb: BOOL;
  END_VAR

  axb := cha XOR chb;

  (* create pulses for channel a *)
  clka := cha XOR edgea;
  edgea := cha;

  clkb := chb XOR edgeb;
  edgeb := chb;

  (* create pulses for both channels *)
  clk := clka OR clkb;

  (* set the direction output *)
  IF axb AND clka THEN dir := TRUE; END_IF;
  IF axb AND clkb THEN dir := FALSE; END_IF;

  (* increment or decrement the counter *)
  IF clk AND dir THEN cnt := cnt + 1; END_IF;
  IF clk AND NOT dir THEN cnt := cnt -1; END_IF;

  (* reset the counter if rst active *)
  IF rst THEN cnt := 0; END_IF;

END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/automation' *)
FUNCTION_BLOCK INTERLOCK
(*
  INTERLOCK has two inputs I1 and I2 which drive the corresponding outputs Q1 and Q2.
  the inputs signals lock each other out and therfore I1 can only drive Q1 when I2 is Low and vice versa.
  The input TL specifies a dead time between two outputs can become active.
  an output can only become active when the other output was not active for the time TL.

  version 1.0 28 sep 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    I1, I2 : BOOL;
    TL : TIME;
  END_VAR
  VAR_OUTPUT
    Q1, Q2 : BOOL;
  END_VAR
  VAR
    T1, T2 : TOF;
  END_VAR

  (* the input signal have a run delay to lockout the other input *)
  T1(IN := I1, PT := TL);
  T2(IN := I2, PT := TL);

  Q1 := I1 AND NOT t2.Q;
  Q2 := I2 AND NOT t1.Q;

(* revision history
  hm  28 sep 2007   rev 1.0
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/automation' *)
FUNCTION_BLOCK INTERLOCK_4
(*
  INTERLOCK_4 detects one of 4 switches and delivers the number of the switch pressed on the output out
  a output tp is true for one cycle if the output has changed.
  a setup variable MODE selects between 3 different modes:
  MODE = 0, any input active will disable all other inputs
  MODE = 1, the input with the highest number will be acepted
  mode = 2, the input last pressed will disable all others

  version 1.1 14. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    I0 : BOOL;
    I1 : BOOL;
    I2 : BOOL;
    I3 : BOOL;
    E : BOOL;
    MODE : INT;
  END_VAR
  VAR_OUTPUT
    OUT : BYTE;
    TP : BOOL;
  END_VAR
  VAR
    in: BYTE;
    last: BYTE;
    old: BYTE;
    lmode: INT;
  END_VAR

  (* check if enable is active *)
  IF E THEN
  (* reset all vars when there is a mode change on thy fly *)
    IF mode <> lmode THEN
      out := 0;
      last := 0;
      old := 0;
      lmode := mode;
    END_IF;
    (* load inputs into in *)
    in.0 := I0;
    in.1 := I1;
    in.2 := I2;
    in.3 := I3;
    (* only execute when there is any change *)
    IF in <> last THEN
      (* only execute when inputs have chages state *)
      CASE mode OF
        0:  (* output directly display inputs as bits in byte out *)
          out := in;

        1:  (* the input with the highest number will be acepted *)
          IF in.3 THEN out := 8;
          ELSIF in.2 THEN out := 4;
          ELSIF in.1 THEN out := 2;
          ELSE out := in;
          END_IF;

        2:  (* input last pressed will be displayed only *)
          last := ((in XOR last) AND in);
          IF last.3 THEN out := 8;
          ELSIF last.2 THEN out := 4;
          ELSIF last.1 THEN out := 2;
          ELSE out := last;
          END_IF;

        3:  (* any input active will disable all other inputs *)
          IF (out AND in) = 0 THEN
            IF in.3 THEN out := 8;
            ELSIF in.2 THEN out := 4;
            ELSIF in.1 THEN out := 2;
            ELSE out := in;
            END_IF;
          END_IF;

      END_CASE;
      last := in;
    END_IF;
    tp := out <> old;
    old := out;
  ELSE
    out := 0;
    last := 0;
    old := 0;
    lmode := 0;
    tp := FALSE;
  END_IF;

(* revision history
  hm  24. oct 2008  rev 1.0
    original version

  hm  14. mar. 2009 rev 1.1
    replaced double assignments
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/automation' *)
FUNCTION MANUAL : BOOL
(*
  MANUAL is a manual override for digital signals.
  when on and off = FALSE, the output follows IN.
  ON = TRUE forces the output high, and OFF = TRUE forces the output low.

  version 1.0 21. nov. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    IN : BOOL;
    ON : BOOL;
    OFF : BOOL;
  END_VAR

  MANUAL := NOT OFF AND (IN OR ON);

(* revision history
  hm  21. nov 2008  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Engineering\/automation' *)
FUNCTION_BLOCK MANUAL_1
(*
  MANUAL_1 is a manual override for digital signals.
  When MAN = FALSE, the output follows IN and when MAN = TRUE the Output follows M_I.

  version 1.2 14. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    IN : BOOL;
    MAN : BOOL;
    M_I : BOOL;
    SET : BOOL;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
    STATUS : BYTE;
  END_VAR
  VAR
    S_edge : BOOL;
    Redge : BOOL;
    edge: BOOL;
  END_VAR

  IF NOT man THEN
    Q := IN;
    STATUS := 100;
    edge := FALSE;
  ELSIF NOT s_edge AND set THEN
    Q := TRUE;
    edge := TRUE;
    status := 101;
  ELSIF NOT Redge AND rst THEN
    Q := FALSE;
    edge := TRUE;
    status := 102;
  ELSIF NOT edge THEN
    Q := M_I;
    status := 103;
  END_IF;

  (* remember levels of manual signals *)
  s_edge := SET;
  Redge := RST;

(* revision history
  hm  17. jun 2008  rev 1.0
    original version

  hm  17. oct 2008  rev 1.1
    deleted unnecessary variable m_edge

  hm  14. mar. 2009 rev 1.2
    replaced double assignments
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/automation' *)
FUNCTION_BLOCK MANUAL_2
(*
  MANUAL_2 is a manual override for boolean signals.
  it has static force high and low as well as a manual input.

  version 1.0 22. sep. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    IN : BOOL;
    ENA : BOOL;
    ON : BOOL;
    OFF : BOOL;
    MAN : BOOL;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
    STATUS : BYTE;
  END_VAR

  IF ena THEN
    IF NOT ON AND NOT OFF THEN
      Q := IN;
      STATUS := 100;
    ELSIF on AND NOT off THEN
      Q := TRUE;
      STATUS := 101;
    ELSIF NOT on AND off THEN
      q := FALSE;
      STATUS := 102;
    ELSE
      Q := MAN;
      STATUS := 103;
    END_IF;
  ELSE
    Q := FALSE;
    STATUS := 104;
  END_IF;

(* revision history
  hm  22. sep. 2008   rev 1.0
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/automation' *)
FUNCTION_BLOCK MANUAL_4
(*
  MANUAL_4 is a manual override for digital signals.
  When MAN = FALSE, the output follows IN and when MAN = TRUE the Output follows M_I.

  version 1.0 17. jun 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    I0, I1, I2, I3 : BOOL;
    MAN : BOOL;
    STP : BOOL;
    M0, M1, M2, M3 : BOOL;
  END_VAR
  VAR_OUTPUT
    Q0, Q1, Q2, Q3 : BOOL;
    STATUS : BYTE;
  END_VAR
  VAR
    edge: BOOL;
    pos : INT;
    tog: BOOL;
  END_VAR

  IF man THEN
    IF NOT TOG THEN
      Q0 := M0;
      Q1 := M1;
      Q2 := M2;
      Q3 := M3;
      STATUS := 101;
    END_IF;
    IF STP AND NOT edge THEN
      tog := TRUE;
      CASE pos OF
        0:  Q0 := TRUE;
          Q1 := FALSE;
          Q2 := FALSE;
          Q3 := FALSE;
          STATUS := 110;
        1:  Q0 := FALSE;
          Q1 := TRUE;
          Q2 := FALSE;
          Q3 := FALSE;
          STATUS := 111;
        2:  Q0 := FALSE;
          Q1 := FALSE;
          Q2 := TRUE;
          Q3 := FALSE;
          STATUS := 112;
        3:  Q0 := FALSE;
          Q1 := FALSE;
          Q2 := FALSE;
          Q3 := TRUE;
          STATUS := 113;
      END_CASE;
      pos := INC(pos,1,3);
    END_IF;
  ELSE
    Q0 := I0;
    Q1 := I1;
    Q2 := I2;
    Q3 := I3;
    STATUS := 100;
    tog := FALSE;
    pos := 0;
  END_IF;

  (* remember status of stp *)
  edge := STP;

(* revision history
  hm  17. jun 2008    rev 1.0
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/automation' *)
FUNCTION_BLOCK PARSET
(*
  parset selects on of 4 parameter sets adressed by the inputs A0 and A1. if TC is specified, the change of the outputs
  is ramped by the time tc

  version 1.1 16. mar. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    A0, A1 : BOOL;
  END_VAR
  VAR_INPUT //???CONSTANT
    X01, X02, X03, X04 : REAL;
    X11, X12, X13, X14 : REAL;
    X21, X22, X23, X24 : REAL;
    X31, X32, X33, X34 : REAL;
    TC : TIME;
  END_VAR
  VAR_OUTPUT
    P1, P2, P3, P4 : REAL;
  END_VAR
  VAR
    X : ARRAY[0..3,1..4] OF REAL;
    S1, S2, S3, S4 : REAL;
    tx, last : UDINT; //DWORD;
    start : BOOL;
    set : USINT; //BYTE;
    init: BOOL;
  END_VAR

  (* read system_time *)
  tx := DWORD_TO_UDINT( T_PLC_MS());

  (* init sequence *)
  IF NOT init THEN
    set.0 := NOT A0;
    init := TRUE;
    X[0,1] := X01;
    X[0,2] := X02;
    X[0,3] := X03;
    X[0,4] := X04;
    X[1,1] := X11;
    X[1,2] := X12;
    X[1,3] := X13;
    X[1,4] := X14;
    X[2,1] := X21;
    X[2,2] := X22;
    X[2,3] := X23;
    X[2,4] := X24;
    X[3,1] := X31;
    X[3,2] := X32;
    X[3,3] := X33;
    X[3,4] := X34;
    P1 := X01;
    P2 := X02;
    P3 := X03;
    P4 := X04;
  END_IF;

  (* check for input change *)
  IF (A0 XOR set.0) OR (A1 XOR set.1) THEN
    (* a new set is selected *)
    set.0 := A0;
    set.1 := A1;
    IF tc > t#0s THEN
      start := TRUE;
      last := tx;
      (* save the step speed for the output changes in S *)
      S1 := (X[set,1] - P1)/DWORD_TO_REAL(TIME_TO_DWORD(tc));
      S2 := (X[set,2] - P2)/DWORD_TO_REAL(TIME_TO_DWORD(tc));
      S3 := (X[set,3] - P3)/DWORD_TO_REAL(TIME_TO_DWORD(tc));
      S4 := (X[set,4] - P4)/DWORD_TO_REAL(TIME_TO_DWORD(tc));
    END_IF;
  ELSIF start AND (tx - last < TIME_TO_UDINT(tc)) THEN
    (* ramp the outputs to the new value *)
    P1 := X[set,1] - S1 * UDINT_TO_REAL(TIME_TO_UDINT(Tc) - tx + last);
    P2 := X[set,2] - S2 * UDINT_TO_REAL(TIME_TO_UDINT(Tc) - tx + last);
    P3 := X[set,3] - S3 * UDINT_TO_REAL(TIME_TO_UDINT(Tc) - tx + last);
    P4 := X[set,4] - S4 * UDINT_TO_REAL(TIME_TO_UDINT(Tc) - tx + last);
  ELSE
    (* make sure outputs match the correct set values *)
    start := FALSE;
    P1 := X[set,1];
    P2 := X[set,2];
    P3 := X[set,3];
    P4 := X[set,4];
  END_IF;

(* revision history
  hm  2.11.2007   rev 1.0
    original version

  hm  16. mar. 2008 rev 1.1
    added type conversions to avoid warnings under codesys 3.0
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/automation' *)
FUNCTION_BLOCK PARSET2
(*
  parset2 selects on of 4 parameter sets depending on the value of X. if TC is specified, the change of the outputs
  is ramped by the time TC

  version 1.0 3 nov 2007
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR
  VAR_INPUT //???CONSTANT
    X01, X02, X03, X04 : REAL;
    X11, X12, X13, X14 : REAL;
    X21, X22, X23, X24 : REAL;
    X31, X32, X33, X34 : REAL;
    L1, L2, L3 : REAL;
    TC : TIME;
  END_VAR
  VAR_OUTPUT
    P1,P2,P3,P4 : REAL;
  END_VAR
  VAR
    Pset : parset;
    init: BOOL;
  END_VAR

  (* init sequence *)
  IF NOT init THEN
    init := TRUE;
    pset(TC:=TC, X01:=X01, X02:=X02, X03:=X03, X04:=X04, X11:=X11, X12:=X12, X13:=X13, X14:=X14, X21:=X21, X22:=X22, X23:=X23, X24:=X24, X31:=X31, X32:=X32, X33:=X33, X34:=X34);
  END_IF;
  IF ABS(X) < L1 THEN
    pset(A0 := FALSE, A1 := FALSE);
  ELSIF ABS(X) < L2 THEN
    pset(A0 := TRUE, A1 := FALSE);
  ELSIF ABS(x) < L3 THEN
    pset(A0 := FALSE, A1 := TRUE);
  ELSE
    pset(A0 := TRUE, A1 := TRUE);
  END_IF;
  P1 := pset.P1;
  P2 := pset.P2;
  P3 := pset.P3;
  P4 := pset.P4;

(* revision history
  hm    3.11.2007   rev 1.0
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/automation' *)
FUNCTION_BLOCK SIGNAL
(*
  this function generates an output signal according to a bit pattern SIG.
  the patter is shifted to the output in time steps of TS.
  ts defaults to 128 ms if not specified.

  version 1.0 13 dec 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IN : BOOL;
    SIG : BYTE;
    TS : TIME;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
  END_VAR
  VAR
    tx: UDINT; //DWORD;
    step: BYTE;
  END_VAR
  VAR CONSTANT
    one : BYTE := 1;
  END_VAR

  IF in THEN
    (* an alarm is present read system time first *)
    tx := DWORD_TO_UDINT( T_PLC_MS());
    (* calculate the step counter which is the lowest 3 bits of (time / ts) *)
    IF ts > t#0s THEN
      step := DWORD_TO_BYTE( UDINT_TO_DWORD(tx / TIME_TO_UDINT(ts)) AND 16#0000_0007);
    ELSE
      step := DWORD_TO_BYTE(SHR( UDINT_TO_DWORD(tx),7) AND 16#0000_0007);
    END_IF;
    (* convert the value 0-7 in step into one bit only (bit 0-7) *)
    step := SHL(one,BYTE_TO_UINT(step));
    (* generate the output signal *)
    Q := (step AND sig) > 0;
  ELSE
    Q := FALSE;
  END_IF;

(* revision history
  hm  13.12.2007    rev 1.0
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/automation' *)
FUNCTION_BLOCK SIGNAL_4
(*
  this function generates one out of 4 signals specified by bit patterns S1 .. S4.
  the selected pattern will be shifted with the step time TS.
  In1 has higher priority then In2 which has higher priority then IN3 and in4 has the lowest priority.
  ts defaults to 128 ms if not specified.

  version 1.0 13 dec 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IN1 : BOOL;
    IN2 : BOOL;
    IN3 : BOOL;
    IN4 : BOOL;
    TS : TIME;
  END_VAR
  VAR_INPUT //???CONSTANT
    S1 : BYTE := 2#1111_1111;
    S2 : BYTE := 2#1111_0000;
    S3 : BYTE := 2#1010_1010;
    S4 : BYTE := 2#1010_0000;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
  END_VAR
  VAR
    sig : SIGNAL;
  END_VAR

  (* an alarm is present read system time first *)
  (* check if an alarm is present if yes set sig to the alarm pattern otherwise exit the routine *)
  IF in1 THEN
    sig(in := TRUE, sig := s1, TS := TS);
  ELSIF in2 THEN
    sig(in := TRUE, sig := s2, TS := TS);
  ELSIF in3 THEN
    sig(in := TRUE, sig := s3, TS := TS);
  ELSIF in4 THEN
    sig(in := TRUE, sig := s4, TS := TS);
  ELSE
    sig(in := FALSE);
  END_IF;

  (* set the output *)
  Q := sig.Q;

(* revision history
  hm  13.12.2007    rev 1.0
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/automation' *)
FUNCTION_BLOCK SRAMP
(*
  RAMPS generates output signal which are slew rate and acceleration controlled.

  version 1.1 11. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
    A_UP : REAL;
    A_DN :REAL;
    VU_MAX : REAL;
    VD_MAX : REAL;
    LIMIT_HIGH : REAL;
    LIMIT_LOW : REAL;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    Y : REAL;
    V : REAL;
  END_VAR
  VAR
    cycle_time : TC_S;
    init: BOOL;
  END_VAR

  (* read the system_time in microseconds *)
  cycle_time();

  (* assure range of inputs *)
  A_up := MAX(0.0, A_UP);
  A_dn := MIN(0.0, A_dn);
  VU_max := MAX(0.0, VU_max);
  VD_max := MIN(0.0, VD_MAX);

  (* calculate the output offset *)
  IF rst OR NOT init THEN
    init := TRUE;
    Y := 0.0;
    V := 0.0;
  ELSIF X = Y THEN
    v := 0.0;
  ELSIF X > Y THEN
    (* output is too low >> ramp up and brake at the end *)
    (* accelerate the speed and limit to vu_max *)
    v := MIN(v + A_UP * cycle_time.TC, vu_max);
    (* calculate the max speed to be able to brake and select the lowest *)
    v := MIN(SQRT((Y-X) * 2.0 * A_DN), v);
    (* calculate the output and obey limits *)
    y := LIMIT(limit_low, y + MIN(v * cycle_time.TC, X-Y), limit_high);
  ELSIF X < Y THEN
    (* output is too high >> ramp dn and brake at the end *)
    (* accelerate the speed and limit to vd_max *)
    v := MAX(v + A_DN * cycle_time.TC, vd_max);
    (* calculate the max speed to be able to brake and select the lowest *)
    v := MAX(-SQRT((Y-X) * 2.0 * A_UP), v);
    (* calculate the output and obey limits *)
    y := LIMIT(limit_low, y + MAX(v * cycle_time.TC, X-Y), limit_high);
  END_IF;

(* revision history
  hm  13. mar. 2008 rev 1.0
    original version

  hm  11. mar. 2009 rev 1.1
  	real constants updated to new systax using dot																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																											
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/automation' *)
FUNCTION_BLOCK TUNE
(*
  tune generates an output signal which is set by input switches.
  up to 4 switsches can be used to tune the signal up or down.

  version 1.2 11. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    SET : BOOL;
    SU, SD : BOOL;
    RST : BOOL;
  END_VAR
  VAR_INPUT //???CONSTANT
    SS : REAL := 0.1;
    Limit_L : REAL;
    LIMIT_H : REAL := 100.0;
    RST_val : REAL;
    SET_val : REAL := 100.0;
    T1 : TIME := T#500ms;
    T2 : TIME := T#2s;
    S1 : REAL := 2.0;
    S2 : REAL := 10.0;
  END_VAR
  VAR_OUTPUT
    Y : REAL;
  END_VAR
  VAR
    tx : UDINT; //DWORD;
    start, start2 : UDINT; //DWORD;
    state : INT;
    in : BOOL;
    step : REAL;
    SPEED : REAL;
    Y_start : REAL;
    Y_start2: REAL;
  END_VAR

  (* read system time *)
  tx := DWORD_TO_UDINT( T_PLC_MS());

  IF rst THEN
    Y := RST_val;
    state := 0;
  ELSIF set THEN
    Y := SET_val;
    state := 0;
  ELSIF state > 0 THEN
    (* key has been pushed state machine operating *)
    (* first read the correct input *)
    IF state = 1 THEN
      (* step up *)
      in := su;
    ELSE
      (* step down *)
      in := sd;
    END_IF;
    (* check for single step operation *)
    IF NOT in AND (tx - start <= TIME_TO_UDINT(T1)) THEN
      Y := Y_start + step;
      state := 0;
    (* check if fast ramp needs to be generated *)
    ELSIF in AND (tx - start >= TIME_TO_UDINT(T2)) THEN
      Y := Y_start2 + UDINT_TO_REAL(tx - start2) * s2 / speed;
    (* check if slow ramp needs to be generated *)
    ELSIF in AND (tx - start >= TIME_TO_UDINT(T1)) THEN
      Y := Y_start + UDINT_TO_REAL(tx - start - TIME_TO_UDINT(T1)) * S1 / speed;
      start2 := tx;
      Y_start2 := Y;
    ELSIF NOT in THEN
      state := 0;
    END_IF;
  ELSIF su THEN
    (* slow step up *)
    state := 1;
    start := tx;
    step := ss;
    speed := 1000.0;
    Y_start := Y;
  ELSIF sd THEN
    (* slow step down *)
    state := 2;
    start := tx;
    step := -ss;
    speed := -1000.0;
    Y_start := Y;
  END_IF;

  (* make sure output does not exceed limits *)
  Y := LIMIT(LIMIT_L, Y, LIMIT_H);

(* revision history
  hm  3.11.2007   rev 1.0
    original version

  hm  16. mar. 2008 rev 1.1
    added type conversions to avoid warnings under codesys 3.0

  hm  11. mar. 2009 rev 1.2
  	real constants updated to new systax using dot																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																											
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/automation' *)
FUNCTION_BLOCK TUNE2
(*
  tune2 generates an output signal which is set by input switches.
  up to 4 switsches can be used to tune the signal up or down.

  version 1.2 11. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    SET : BOOL;
    SU, SD : BOOL;
    FU, FD : BOOL;
    RST : BOOL;
  END_VAR
  VAR_INPUT //???CONSTANT
    SS : REAL := 0.1;
    FS : REAL := 5.0;
    Limit_L : REAL;
    LIMIT_H : REAL := 100.0;
    RST_val : REAL;
    SET_val : REAL := 100.0;
    TR : TIME := T#500ms;
    S1 : REAL := 2.0;
    S2 : REAL := 10.0;
  END_VAR
  VAR_OUTPUT
    Y : REAL;
  END_VAR
  VAR
    tx : UDINT; //DWORD;
    start : UDINT; //DWORD;
    state : INT;
    in : BOOL;
    step : REAL;
    SPEED : REAL;
    Y_start : REAL;
  END_VAR

  (* read system time *)
  tx := DWORD_TO_UDINT( T_PLC_MS());

  IF rst THEN
    Y := RST_val;
    state := 0;
  ELSIF set THEN
    Y := SET_val;
    state := 0;
  ELSIF state > 0 THEN
    (* key has been pushed state machine operating *)
    (* first read the correct input *)
    CASE state OF
      1 : (* slow up *)
        in := su;
      2 : (* slow down *)
        in := sd;
      3 : (* fast up *)
        in := fu;
      4 : (* fast down *)
        in := fd;
    END_CASE;
    (* check for single step operation *)
    IF NOT in AND (tx - start <= TIME_TO_UDINT(TR)) THEN
      Y := Y_start + step;
      state := 0;
    (* check if ramp needs to be generated *)
    ELSIF in AND (tx - start >= TIME_TO_UDINT(TR)) THEN
      Y := Y_start + UDINT_TO_REAL(tx - start - TIME_TO_UDINT(TR)) * speed;
    ELSIF NOT in THEN
      state := 0;
    END_IF;
  ELSIF su THEN
    (* slow step up *)
    state := 1;
    start := tx;
    step := ss;
    speed := s1 * 1.0E-3;
    Y_start := Y;
  ELSIF sd THEN
    (* slow step down *)
    state := 2;
    start := tx;
    step := -ss;
    speed := -s1 * 1.0E-3;
    Y_start := Y;
  ELSIF fu THEN
    (* fast step up *)
    state := 3;
    start := tx;
    step := fs;
    speed := s2 * 1.0E-3;
    y_start := Y;
  ELSIF fd THEN
    (* fast step down *)
    state := 4;
    start := tx;
    step := -fs;
    speed := -s2 * 1.0E-3;
    y_start := Y;
  END_IF;

  (* make sure output does not exceed limits *)
  Y := LIMIT(LIMIT_L, Y, LIMIT_H);

(* revision history
  hm  3.11.2007   rev 1.0
    original version

  hm  16. 3. 2008 rev 1.1
    added type conversions to avoid warnings in codesys 3.0
    improved performance

  hm  11. mar. 2009 rev 1.2
  	real constants updated to new systax using dot																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																											
*)
END_FUNCTION_BLOCK

