(* @PATH := '\/Engineering\/signal generators' *)
FUNCTION_BLOCK _RMP_B
(*
  _RMP_B generates a ramp on an external var of type byte
  tr is the total ramp time, E is an enable and dir the direction of the ramp

  version 1.2   19. feb. 2011
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    DIR : BOOL;  (* true = up *)
    E : BOOL := TRUE;
    TR : TIME;
  END_VAR
  VAR_IN_OUT
    RMP : BYTE;
  END_VAR
  VAR
    tx, tl, tn : TIME;
    init : BOOL;
    last_dir : BOOL;
    start : BYTE;
  END_VAR

  (* read system timer *)
  tx := DWORD_TO_TIME(T_PLC_MS());

  IF E AND init AND (dir = last_dir) AND (RMP <> SEL(DIR, 0, 255)) AND TR = tn THEN
    RMP := FRMP_B(start, DIR, tx - tl, TR);
  ELSE
    init := TRUE;
    tl := tx;
    tn := tr;
    start := RMP;
  END_IF;
  last_dir := dir;

(* revison history
  hm  22. oct. 2008 rev 1.0
    original version

  hm  20. nov. 2008 rev 1.1
    set default for E to be TRUE
    added init

  hm  19. nov. 2011 rev 1.2
    new code
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal generators' *)
FUNCTION_BLOCK _RMP_NEXT
(*
  _RMP_NEXT  will generate a ramp output following the input IN.
  on a rising ramp the output will stop as soon as it has surpassed the input in, and on a falling ramp it will stop when out is smaller than in.
  a lockout time T_L will be added between up and down direction.

  version 1.4   18. jul. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    E : BOOL := TRUE;
    IN : BYTE;
    TR : TIME;
    TF : TIME;
    TL : TIME;
  END_VAR
  VAR_OUTPUT
    DIR : BOOL;    (* upwards = TRUE *)
    UP : BOOL;
    DN : BOOL;
  END_VAR
  VAR_IN_OUT
    OUT : BYTE;
  END_VAR
  VAR
    rmx : _RMP_B;
    dirx : TREND_DW;
    t_lock :TP;
    xen: BOOL;
    xdir: BOOL;
  END_VAR

  dirx(X := BYTE_TO_DWORD(in));

  t_lock(in := FALSE, pt := TL);

  IF dirx.TU AND (OUT < IN) THEN
    IF NOT xdir AND xen THEN t_lock(in := TRUE); END_IF;
    xen := TRUE;
    xdir := TRUE;
  ELSIF dirx.TD AND (OUT > IN) THEN
    IF xdir AND xen THEN t_lock(in := TRUE); END_IF;
    xen := TRUE;
    xdir := FALSE;
  ELSIF xen THEN
    IF (xdir AND (out >= in)) OR (NOT xdir AND (out <= in)) THEN
      xen := FALSE;
      IF tl > t#0s THEN t_lock(IN := TRUE); END_IF;
    END_IF;
  END_IF;

  IF NOT t_lock.Q AND xen THEN
      UP := XDIR;
      DIR := XDIR;
      DN := NOT XDIR;
  ELSE
    UP := FALSE;
    DN := FALSE;
  END_IF;

  rmx(rmp := OUT, E := E AND (UP OR DN) , dir := DIR, tr := SEL(dir, TF, TR));

(* revison history
  hm  23. nov. 2008 rev 1.0
    original version

  hm  24. jan. 2009 rev 1.1
    deleted unused vars tmp1, tmp2

  hm  20. feb. 2009 rev 1.2
    improved algorithm
    added TL

  hm  9. mar. 2009  rev 1.3
    input E was ignored
    removed double assignments

  hm  18. jul. 2009 rev 1.4
    improved performance
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal generators' *)
FUNCTION_BLOCK GEN_PULSE
(*
  GEN_PULSE uses the internal sps timer to generate a continuous output waveform with programmable high and low time.
  the accuracy of gen_pulse is depending on the system timer.
  when time is 0 the high and low times are exactly one cycle.
  ENQ = TRUE will start and ENQ = FALSE will stop the generator.

  version 1.5 8. apr. 2011
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    ENQ : BOOL := TRUE;
    PTH : TIME;
    PTL : TIME;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
  END_VAR
  VAR
    tx: TIME;
    tn: TIME;
    init: BOOL;
  END_VAR

  IF enq THEN
    tx := DWORD_TO_TIME(T_PLC_MS());
    IF NOT init THEN init := TRUE; tn := tx; END_IF;
    IF tx - tn >= SEL(Q, PTL, PTH) THEN
      tn := tn + SEL(Q, PTL, PTH);
      Q := NOT Q;
    END_IF;
  ELSE
    Q := FALSE;
    init := FALSE;
  END_IF;

(* revision history
  hm  29. jun. 2008 rev 1.0
    original version

  hm  23. nov. 2008 rev 1.1
    set default for enq to be true

  hm  18. jul. 2009 rev 1.2
    improved performance

  hm  13. nov. 2009 rev 1.3
    corrected error

  hm  16. feb. 2011 rev 1.4
    corrected an error when timer overflows

  hm  8. apr. 2011  rev 1.5
    ptl and pth was exchanged
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal generators' *)
FUNCTION_BLOCK GEN_PW2
(*
  GEN_PW2 generates a time TH? followed by a time TL?.
  the input ts selects between 2 sets of timings for the operation.

  version 1.1 14. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    ENQ : BOOL;
    TH1 : TIME;
    TL1 : TIME;
    TH2 : TIME;
    TL2 : TIME;
    TS : BOOL;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
    TH : TIME;
    TL : TIME;
  END_VAR
  VAR
    t_high : TIME;
    t_low : TIME;
    tx : TIME;
    start : TIME;
    init : BOOL;
    et : TIME;
  END_VAR

  (* read system timer *)
  tx := DWORD_TO_TIME(T_PLC_MS());

  (* startup initialization *)
  IF NOT init THEN
    start := tx;
    init := TRUE;
    TH := T#0s;
    TL := T#0s;
  END_IF;

  (* timing selection *)
  IF TS THEN
    t_high := TH2;
    t_low := TL2;
  ELSE
    t_high := TH1;
    t_low := TL1;
  END_IF;

  (* normal operation *)
  IF ENQ THEN
    et := tx - start;
    IF NOT Q THEN
      IF et >= t_low THEN
        Q := TRUE;
        start := tx;
        TL := T#0s;
      ELSE
        TL := et;
      END_IF;
    ELSE
      IF et >= t_high THEN
        Q := FALSE;
        start := tx;
        TH := T#0s;
      ELSE
        TH := et;
      END_IF;
    END_IF;
  ELSE
    Q := FALSE;
    TH := T#0s;
    TL := T#0s;
    start := tx;
  END_IF;

(* revision history
  hm  26. sep. 2008 rev 1.0
    original version

  hm  14. mar. 2009 rev 1.1
    removed double assignments
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal generators' *)
FUNCTION_BLOCK GEN_RDM
(*
  this signal generator generates a random output. The signal is defined by period time (PT),
  amplitude (AM), offset (OS).
  The Output waveform will have its max peak at AM/2 + OS and its minimum peak at -AM/2 + OS.
  The period time PT defines how often the output signal will jump to a new randow value.
  The Output Q will be true for one cycle anytime the output OUT has changed

  version 1.1 16 sep 2007
  programmer  oscat
  tested by   oscat
*)
  VAR_INPUT
    PT : TIME;
    AM : REAL := 1;
    OS : REAL;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
    Out : REAL;
  END_VAR
  VAR
    tx : TIME;
    last : TIME;
    init : BOOL;
  END_VAR

  (* read system time and prepare input data *)
  tx := DWORD_TO_TIME(T_PLC_MS()) - last;

  (* init section *)
  IF NOT init THEN
    init := TRUE;
    last := tx;
    tx := t#0s;
  END_IF;

  (* add last if one cycle is finished *)
  IF tx >= pt THEN
    last := last + pt;
    tx := tx - pt;

    (* generate output signal *)
    out := am * (RDM(0.0) - 0.5) + os;
    q := TRUE;
  ELSE
    q := FALSE;
  END_IF;

(* revision history
  hm  7.2.2007    rev 1.0
    original version

  hm  16.9.2007   rev 1.1
    changes time() to T_plc_ms() for compatibility reasons
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal generators' *)
FUNCTION_BLOCK GEN_RDT
(*
  GEN_RDT generates a defined pulse with pulse width TP_Q at random times. the random time will be defined with an minimum and maximum time.

  version 1.1 16 mar. 2008
  programmer  J. Schohaus
  tested by   Hugo
*)
  VAR_INPUT
    Enable     : BOOL := TRUE ;
    Min_Time_ms : TIME := t#1s ; (* min Taktzeit *)
    Max_Time_ms : TIME := t#1.2s ; (* Max Taktzeit *)
    TP_Q     : TIME := t#100ms ; (* Zeit Ausgang auf TRUE *)
  END_VAR
  VAR_OUTPUT
    xQ     : BOOL ;
  END_VAR
  VAR
    (* Taktgenerator Simulation *)
    tonRDMTimer : TON ; (* Zeitbaustein Taktgenerator *)
    tof_xQ    : TOF ; (* Ausschaltverzögerung Taktgenerator *)
    tRDMTime  : TIME ; (* Sollzeit *)
    rRDMTime  : REAL ; (* Zufalswert Timer *)
  END_VAR

  tonRDMTimer ( IN:= Enable , PT:= tRDMTime );
  tof_xQ ( IN:= tonRDMTimer.Q , PT:= TP_Q );
  XQ := tof_xq.Q;
  IF tonRDMTimer.Q THEN
       xQ := TRUE ;
       rRDMTime := RDM ( last:= rRDMTime ) ;
       tRDMTime := REAL_TO_TIME ( rRDMTime * DINT_TO_REAL(TIME_TO_DINT( Max_Time_ms - Min_Time_ms ) + TIME_TO_DINT(Min_Time_ms ))) ;
       tonRDMTimer ( IN:= FALSE );
  END_IF;

(* revision history
  J. Schohaus 19. nov 2007  rev 1.0
    origial version

  hm  16. mar. 2008     rev 1.1
    added type conversion to avoid warnings under codesys 3.0
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal generators' *)
FUNCTION_BLOCK GEN_RMP
(*
  this signal generator generates a ramp wave output. The ramp wave signal is defined by period time (PT),
  amplitude (AM), offset (OS) and a specific delay for the output signal (DL).
  The Output waveform will have its minimum peak at OS and its maximum peak at AM + OS.
  The delay input can delay a signal up to PT, this can be useful to synchronize different generators
  and generate interleaving signals.
  in addition to the analog output Out there is a second boolean output Q with is true for one cycle when the ramp starts.

  version 1.4 10. mar. 2009
  programmer  oscat
  tested by   oscat
*)
  VAR_INPUT
    PT : TIME := t#1s;
    AM : REAL := 1.0;
    OS : REAL;
    DL : REAL;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
    OUT : REAL;
  END_VAR
  VAR
    tx : TIME;
    last : TIME;
    init : BOOL;
    temp : REAL;
    ltemp: REAL;
  END_VAR

  (* read system time and prepare input data *)
  tx := DWORD_TO_TIME(T_PLC_MS()) - last;
  DL := MODR(dl,1.0);
  IF dl < 0.0 THEN dl := 1.0 - dl; END_IF;

  (* init section *)
  IF NOT init THEN
    init := TRUE;
    last := tx;
    tx := t#0s;
  END_IF;

  (* add last if one cycle is finished *)
  IF tx >= pt THEN
    last := last + pt;
    tx := tx - pt;
  END_IF;

  (* generate sine wave *)
  ltemp := temp;
  IF pt > t#0s THEN temp := FRACT(TIME_TO_REAL(tx + MULTIME(pt, dl)) / TIME_TO_REAL(pt)); END_IF;
  out := am * temp + os;

  (* boolean output Q *)
  Q := temp < ltemp;

(* revision history
  hm  3. mar 2007   rev 1.0
    original version

  hm  17 sep 2007   rev 1.1
    replaced time() with t_plc_ms for compatibilitx reasons

  hm  27. nov 2007  rev 1.2
    avoid divide by 0 when pt = 0

  ks  26. oct. 2008 rev 1.3
    code optimization

  hm  10. mar. 2009 rev 1.4
    changed real constants to use dot syntax
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal generators' *)
FUNCTION_BLOCK GEN_SIN
(*
  this signal generator generates a sine wave output. The sine wave signal is defined by period time (PT),
  amplitude (AM), offset (OS) and a specific delay for the output signal (DL).
  The Output waveform will have its max peak at AM/2 + OS and its minimum peak at -AM/2 + OS.
  The delay input can delay a signal up to PT, this can be useful to synchronize different generators
  and generate interleaving signals. A Cos wave can be generated accordingly.
  in addition to a analog output Out there is a second boolean output Q with the corresponding binary signal.

  version 1.6 11. mar. 2009
  programmer  oscat
  tested by oscat
*)
  VAR_INPUT
    PT : TIME;
    AM : REAL := 1.0;
    OS : REAL;
    DL : REAL;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
    Out : REAL;
  END_VAR
  VAR
    tx : TIME;
    last : TIME;
    init : BOOL;
    temp : REAL;
  END_VAR

  (* read system time and prepare input data *)
  tx := DWORD_TO_TIME(T_PLC_MS()) - last;
  DL := MODR(dl,1.0);
  IF dl < 0.0 THEN dl := 1.0 - dl; END_IF;

  (* init section *)
  IF NOT init THEN
    init := TRUE;
    last := tx;
    tx := t#0s;
  END_IF;

  (* add last if one cycle is finished *)
  IF tx >= pt THEN
    last := last + pt;
    tx := tx - pt;
  END_IF;

  (* generate sine wave *)
  IF pt > t#0s THEN temp := SIN(math.PI2 * DWORD_TO_REAL(TIME_TO_DWORD(tx + MULTIME(pt, dl))) / DWORD_TO_REAL(TIME_TO_DWORD(pt))); END_IF;
  out := am * 0.5 *  temp + os;

  (* boolean output Q *)
  q := NOT SIGN_R(temp);

(* revision history
  hm  22. jan 2007  rev 1.0
    original version

  hm  17 sep 2007 rev 1.1
    replaced time() with t_plc_ms for compatibilitx reasons

  hm  27. nov 2007  rev 1.2
    avoid divide by 0 when pt = 0

  hm  6. jan 2008   rev 1.3
    improved performance

  hm  16. mar. 2008 rev 1.4
    added type conversion to avoid warnings under codesys 3.0

  hm  18. oct. 2008 rev 1.5
    using math constants

  hm  11. mar. 2009 rev 1.6
    changed real constants to use dot syntax
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal generators' *)
FUNCTION_BLOCK GEN_SQR
(*
  this signal generator generates a square wave output. The square wave signal is defined by period time (PT),
  amplitude (AM), offset (OS), duty cycle (DC) and a specific delay for the output signal (DL).
  The Output waveform will switch between AM/2 + OS and -AM/2 + OS. The DC input specifies ther duty cycle,
  DC = 0 means output is low at all times and 1 means output is high at all times.
  The delay input can delay a signal up to PT, this can be useful to synchronize different generators and generate interleaving signals.
  in addition to a analog output Out there is a second boolean output Q.

  version 1.4 11. mar. 2009
  programmer  oscat
  tested by   oscat
*)
  VAR_INPUT
    PT : TIME;
    AM : REAL := 1.0;
    OS : REAL;
    DC : REAL := 0.5;
    DL : REAL;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
    Out : REAL;
  END_VAR
  VAR
    tx : TIME;
    last : TIME;
    init: BOOL;
  END_VAR
  VAR_TEMP
    tmp : TIME;
  END_VAR

  (* check dc = 1 or 0 *)
  IF dc = 0.0 THEN
    out := -am * 0.5 + os;
    Q := FALSE;
    RETURN;
  ELSIF dc = 1.0 THEN
    out := am * 0.5 + os;
    Q := TRUE;
    RETURN;
  END_IF;

  (* read system time and prepare input data *)
  tx := DWORD_TO_TIME(T_PLC_MS()) - last;
  DL := MODR(dl,1.0);
  IF dl < 0.0 THEN dl := 1.0 - dl; END_IF;
  dc := MODR(dc,1.0);
  IF dc < 0.0 THEN dc := 1.0 - dc; END_IF;

  (* init section *)
  IF NOT init THEN
    init := TRUE;
    last := tx;
    tx := t#0s;
  END_IF;

  (* add last if one cycle is finished *)
  IF tx >= pt THEN
    last := last + pt;
    tx := tx - pt;
  END_IF;

  (* check if falling or rising edge first *)
  tmp := MULTIME( pt, dl + dc);
  IF  tmp >= pt THEN
    (* generate falling edge *)
    IF tx >= MULTIME(pt, dl + dc - 1.0) THEN
      out := -am * 0.5 + os;
      Q := FALSE;
    END_IF;
    (* generate rising edge *)
    IF tx >= MULTIME(pt, dl) THEN
      out := am * 0.5 + os;
      Q := TRUE;
    END_IF;
  ELSE
    (* generate rising edge first *)
    IF tx >= MULTIME(pt, dl) THEN
      out := am * 0.5 + os;
      Q := TRUE;
    END_IF;
    (* generate falling edge *)
    IF tx >= MULTIME(pt, dl + dc) THEN
      out := -am * 0.5 +os;
      Q := FALSE;
    END_IF;
  END_IF;

(* revision history
  hm  12. feb 2007  rev 1.1
    added default value for dc = 0.5

  hm  17 sep 2007 rev 1.2
    replaced time() with t_plc_ms for compatibilitx reasons

  hm  6. jan 2008 rev 1.3
    improved performance

  hm  11. mar. 2009 rev 1.4
    changed real constants to use dot syntax
    set default amplitude to 1.0
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK CLK_PRG
(*
  clk_prg uses the internal sps time to generate a clock with programmable period time.
  the first cycle after start is a clk pulse and then depending on the programmed period time a delay.
  every pulse is only valid for one cycle.
  the accuracy of clk_prg is depending on the accuracy of the system clock.

  version 1.3 25. oct. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    PT : TIME := t#10ms;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
  END_VAR
  VAR
    init : BOOL;
    last : TIME;
    tx: TIME;
  END_VAR

  (* read system time *)
  tx := DWORD_TO_TIME(T_PLC_MS());

  (* initialize on startup *)
  IF NOT init THEN
    init := TRUE;
    last := tx - pt;
  END_IF;

  (* generate output pulse when next_pulse is reached *)
  Q := tx - last >= pt;
  IF Q THEN last := tx; END_IF;

(* revision hiostory
  hm 25 feb 2007  rev 1.1
    rewritten code for higher performance
    pt can now be changed during runtime

  hm  17. sep 2007  rev 1.2
    replaced time() with t_plc_ms() for compatibility reasons

  hm  25. oct. 2008 rev 1.3
    optimized code
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK TP_X
(*
  retriggerable edge triggered pulse similar to TP but with a retrigger function
  if the pt input is 0 then output is always low.

  version 1.3 17. dec. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    IN : BOOL;
    PT : TIME;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
    ET : TIME;
  END_VAR
  VAR
    edge : BOOL;
    start : TIME;
    tx: TIME;
  END_VAR

  (* read system_time *)
  tx := DWORD_TO_TIME(T_PLC_MS());

  (* rising edge trigger *)
  IF IN AND NOT edge THEN
    start := tx;
    Q := PT > t#0ms;
  ELSIF Q THEN
    ET := tx - start;
    IF ET >= PT THEN
      Q := FALSE;
      ET := t#0ms;
    END_IF;
  END_IF;
  edge := IN;

(* revision history
  hm  4. aug 2006   rev 1.0
    original version

  hm  17. sep 2007  rev 1.1
    replaced time() with T_PLC_MS() for compatibility reasons

  hm  19. oct. 2008 rev 1.2
    renamed to TP_R to TP_X for compatibility reasons

  hm  17. dec. 2008 rev 1.3
    code optimized
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal generators' *)
FUNCTION_BLOCK PWM_DC
(*
  this signal generator generates a square wave signal which is specified by the frequency and the duty cycle

  version 1.4 11. mar. 2009
  programmer  oscat
  tested by   oscat
*)
  VAR_INPUT
    F : REAL;
    DC : REAL;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
  END_VAR
  VAR
    clk: CLK_PRG;
    pulse: TP_X;
    tmp: REAL;
  END_VAR

  IF F > 0.0 THEN
    tmp := 1000.0 / F;
    CLK(PT := REAL_TO_TIME(tmp));
    Pulse(in := clk.Q, pt := REAL_TO_TIME(tmp * DC));
    Q := pulse.Q;
  END_IF;

(* revision history
  hm  25. feb 2007  rev 1.1
    recoded in st for better performance and better portability

  hm  27. nov 2007  rev 1.2
    avoid divide by 0 when F = 0

  hm  19. oct. 2008 rev 1.3
    changed type TP_R to TP_X because of name change
    improved performance

  hm  11. mar. 2009 rev 1.4
    changed real constants to use dot syntax
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal generators' *)
FUNCTION_BLOCK PWM_PW
(*
  this signal generator generates a square wave signal which is specified by the frequency and the pulse width.

  version 1.5 11. mar. 2009
  programmer  oscat
  tested by   oscat
*)
  VAR_INPUT
    F : REAL;
    PW : TIME;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
  END_VAR
  VAR
    clk: CLK_PRG;
    pulse: TP_X;
  END_VAR

  IF F > 0.0 THEN
    CLK(PT := REAL_TO_TIME(1000.0 / F));
    Pulse(in := clk.Q, pt := pw);
    Q := pulse.Q;
  END_IF;

(* revision history
  hm  25. feb 2007  rev 1.1
    recoded in st for better performance and better portability

  hm  27. nov 2007  rev 1.2
    avoid divide by 0 when F = 0

  hm  9. dec 2007   rev 1.3
    corrected an error with F = 0

  hm  19. oct. 2008 rev 1.4
    changed type tp_r to TP_x brecause of name change

  hm  11. mar. 2009 rev 1.5
    changed real constants to use dot syntax
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal generators' *)
FUNCTION_BLOCK RMP_B
(*
  this ramp generator generates a byte wide ramp with 255 steps
  the generator has an asynchronous set and reset
  the ramp is controlled by PT which is the total ramp time for a full sweep from 0..255
  an UD input controlls the direction Up or Down and the E input enables the ramp generation
  a busy output indicates that the ramp is running, busy false means output is stable.
  the outputs low and high will be true when the output has reached its max or min value.

  version 2.0 23. oct. 2008
  programmer  oscat
  tested by oscat
*)
  VAR_INPUT
    SET : BOOL;
    PT : TIME;
    E : BOOL := TRUE;
    UP : BOOL := TRUE;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    OUT : BYTE;
    BUSY: BOOL;
    HIGH : BOOL;
    LOW : BOOL;
  END_VAR
  VAR
    rmp : _RMP_B;
  END_VAR

  (* generate ramp *)
  rmp(dir := UP, E := E, TR := PT, rmp := out);

  (* set or reset operation *)
  IF RST THEN
    out := 0;
  ELSIF SET THEN
    out := 255;
  END_IF;

  (* checks for outputs stable and reset or set busy flag *)
  low := out = 0;
  high := out = 255;
  busy := NOT (low OR high) AND E;

(* revision history
  hm 5.10.2006  rev 1.1
    added busy output
  hm 17.1.2007  rev 1.2
    renamed input ud to up for better usability
    deleted unused variable step

  hm  17.9.2007   rev 1.3
    replaced time() with t_plc_ms() for compatibility reasons

  hm  28. sep 2007  rev 1.4
    added outputs on and off
    busy is now disabled while en is false
    new coding for higher accuracy and performance

  hm  5. oct 2007 rev 1.5
    added statements to allow for PT to be t#0s output jumps to max or min immediately

  hm  25. dec 2007  rev 1.6
    improved code for better performance

  hm  16. oct. 2008 rev 1.7
    improved code for better performance

  hm  18. oct. 2008 rev 1.8
    added type conversion to avoid warnings
    changed input en to e for compatibility reasons

  hm  23. oct. 2008 REV   2.0
    new code using _RMP_B
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Engineering\/signal generators' *)
FUNCTION_BLOCK RMP_SOFT
(*
  this soft on/off ramp generator generates a soft on and soft off ramp while the max on value is set by the input
  the time for a full ramp can be set by config variables for up and down ramp.

  version 2.0 26. oct. 2008
  programmer  oscat
  tested by   oscat
*)
  VAR_INPUT
    IN : BOOL;
    VAL : BYTE;
  END_VAR
  VAR_INPUT //???CONSTANT
    PT_ON: TIME;
    PT_OFF : TIME;
  END_VAR
  VAR_OUTPUT
    OUT : BYTE;
  END_VAR
  VAR
    rmp : _RMP_B;
    tmp: BYTE;
  END_VAR

  tmp := SEL(in, 0, val);
  IF tmp > out THEN
    (* we need to ramp down *)
    rmp(dir := TRUE, E := TRUE, TR := PT_ON, rmp := out);
    (* make sure out does not surpass tmp *)
    out := MIN(out, tmp);
  ELSIF tmp < out THEN
    (* we need to ramp up *)
    rmp(dir := FALSE, E := TRUE, TR := PT_OFF, rmp := out);
    (* make sure out does not surpass tmp *)
    out := MAX(out, tmp);
  ELSE
    (* no ramp necessary *)
    rmp(E := FALSE, rmp := out);
  END_IF;

(* revision history
  hm 22.1.2007  rev 1.1
    deleted unused variables X1 and I, X2 and X3

  hm  17.9.2007 rev 1.2
    replaced time() with t_plc_ms() for compatibility reasons

  hm  26. oct. 2008 2.0
    new code using _rmp_b
*)
END_FUNCTION_BLOCK




