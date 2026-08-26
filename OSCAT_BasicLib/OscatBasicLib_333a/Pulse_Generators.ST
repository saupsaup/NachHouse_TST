(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK A_TRIG
(*
  this block is similar to the IEC Standard R_trig and F_trig but it monitors a REAL for change.
  if the valiue on IN changes more then D from the last value it will generate trigger and display the difference in output D.
  the trigger will only be active for one cycle.

  version 1.1 25. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    IN : REAL;
    RES : REAL;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
    D : REAL;
  END_VAR
  VAR
    last_in : REAL;
  END_VAR

  D := IN - LAST_IN;
  Q := ABS(D) > res;
  IF Q THEN last_in := IN; END_IF;
  D := IN - LAST_IN;

(* revision history
  hm  16. jul. 2008 rev 1.0
    original version released

  hm  25. oct. 2008 rev 1.1
    code optimization
    a_trig now also works for res = 0
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK B_TRIG
(*
  this block is similar to R_trig and F_trig but it generates a pulse on rising and falling edge.

  version 1.0 4. aug. 2006
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    CLK : BOOL;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
  END_VAR
  VAR
    edge : BOOL;
  END_VAR

  Q := clk XOR edge;
  edge := CLK;

(* revision history
  hm    4. aug. 2006  rev 1.0
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK CLICK_CNT
(*
  this Module decodes a specified number of clicks.
  the output trig is high for one cycle if N clicks are present within a specified time TC.

  version 1.0 16. jul. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    IN : BOOL;
    N : INT;
    TC : TIME;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
  END_VAR
  VAR
    tx : TP;
    edge: BOOL;
    cnt: INT := -1;
  END_VAR

  (* Q shall only be active for one cycle only *)
  Q := FALSE;

  IF in AND NOT edge AND NOT tx.q THEN
    (* a rising edge on in sets the counter to 0 *)
    cnt := 0;
  ELSIF tx.Q AND NOT IN AND edge THEN
    (* count falling edges when tp.q is true *)
    cnt := cnt + 1;
  ELSIF NOT tx.Q THEN
    Q := cnt = N;
    cnt := -1;
  END_IF;

  (* remember the status of IN *)
  edge := IN;
  tx(in := IN, pt := TC);

(* revision history
  hm  16. jul. 2008 rev 1.0
    original version released
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK CLICK_DEC
(*
  this Module detects a rising edge on In and decodes the amount of falling edges (Pulses) within a specified time TC.
  the outputs Q0..Q3 will go true for one cycle and the amount of clicks within a specified time TC.
  if only a rising egde is detected within TC Q0 will respond, Q1 for 1 pulse and so on..

  version 1.1 14. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    IN : BOOL;
    TC : TIME;
  END_VAR
  VAR_OUTPUT
    Q0, Q1, Q2, Q3 : BOOL;
  END_VAR
  VAR
    tx : TP;
    edge: BOOL;
    cnt: INT := -1;
  END_VAR

  (* Q shall only be active for one cycle only *)
  IF in = FALSE THEN
    Q0 := FALSE;
    Q1 := FALSE;
    Q2:= FALSE;
    Q3 := FALSE;
  END_IF;

  IF in AND NOT edge AND NOT tx.q THEN
    (* a rising edge on in sets the counter to 0 *)
    cnt := 0;
  ELSIF tx.Q AND NOT IN AND edge THEN
    (* count falling edges when tp.q is true *)
    cnt := cnt + 1;
  ELSIF NOT tx.Q THEN
    CASE cnt OF
      0 : Q0 := TRUE;
      1 : Q1 := TRUE;
      2 : Q2 := TRUE;
      3 : Q3 := TRUE;
    END_CASE;
    cnt := -1;
  END_IF;

  (* remember the status of IN *)
  edge := IN;
  tx(in := IN, pt := TC);

(* revision history
  hm 17. jul. 2008  rev 1.0
    original version released

  hm  14. mar. 2009 rev 1.1
    removed double assignments
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK CLK_DIV
(*
  this is a clock divider
  each output divides the signal by 2
  Q0 = clk / 2 , Q1 = Q0 / 2 and so on.
  the outputs have a 50% duty cycle each.

  version 1.1 2 jan 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    clk : BOOL;
    rst: BOOL;
  END_VAR
  VAR_OUTPUT
    Q0 : BOOL;
    Q1 : BOOL;
    Q2 : BOOL;
    Q3 : BOOL;
    Q4 : BOOL;
    Q5 : BOOL;
    Q6 : BOOL;
    Q7 : BOOL;
  END_VAR
  VAR
    cnt: USINT; //BYTE;
  END_VAR

  IF rst THEN
    cnt:= 0;
    Q0 := 0;
    Q1 := 0;
    Q2 := 0;
    Q3 := 0;
    Q4 := 0;
    Q5 := 0;
    Q6 := 0;
    Q7 := 0;
  ELSIF clk THEN
    cnt:= cnt +1;
    Q0 := cnt.0;
    Q1 := cnt.1;
    Q2 := cnt.2;
    Q3 := cnt.3;
    Q4 := cnt.4;
    Q5 := cnt.5;
    Q6 := cnt.6;
    Q7 := cnt.7;
  END_IF;

(* revision history
  hm  4. aug. 2006  rev 1.0
    original version

  hm  2. jan 2008   rev 1.1
    improved performance
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK CLK_N
(*
  clk_N uses the internal sps time to generate one pulse every N ms
  every pulse is only valid for one cycle so that a edge trigger is not necessary
  clk_N generates pulses depending on the accuracy of the system clock.
  The input N controlls the period time of the clock.
  N=0 equals 1ms, N=1 equals 2ms, N=2 equals 4ms, N=3 equals 8ms ....

  be careful, 1ms clocks will only work on very powerful sps cpu's
  version 1.0 17 sep 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    N : INT;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
  END_VAR
  VAR
    edge : BOOL;
    stime: DWORD;
    clk: BOOL;
  END_VAR

  stime := SHR(T_PLC_MS(),INT_TO_UINT(N));
  clk := stime.0;
  Q := clk XOR edge;
  edge := CLK;

(* revision history
  hm  16. dec 2007    rev 1.0
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK CLK_PULSE
(*
  clk_pulse uses the internal sps time to generate a clock with programmable period time.
  the period time is defined for 10ms .. 65s.
  pulse generation is continuous if N = 0 and for n pulses otherwise.
  the first cycle after start is a clk pulse and then depending on the programmed period time a delay.
  every pulse is only valid for one cycle so that a edge trigger is not necessary
  clk_prg depending on the accuracy of the system clock.

  version 1.2   16 feb 2011
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    PT : TIME;
    N : INT;
    RST : BOOL ;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
    CNT : INT;
    RUN : BOOL;
  END_VAR
  VAR
    tx, tn: UDINT; //DWORD;
    init: BOOL;
  END_VAR

  tx := DWORD_TO_UDINT( T_PLC_MS());   (* read system *)
  Q := FALSE;       (* reset Q we generate pulses only for one cycle *)
  RUN := CNT < N;

  IF NOT init OR RST THEN
    init := TRUE;
    CNT := 0;
    tn := tx - TIME_TO_UDINT(PT);
    RUN := FALSE;
  ELSIF (cnt < N OR N = 0) AND tx - tn >= TIME_TO_UDINT(PT) THEN    (* generate a pulse *)
    CNT := CNT + 1;
    Q := TRUE;
    tn := tn + TIME_TO_UDINT(PT);
  END_IF;

(* revision history
  hm    4. aug 2006   rev 1.0
    original version

  hm    17. sep 2007  rev 1.1
    replaced time() with T_PLC_S() for compatblity reasons

  hm    16. feb. 2011 rev 1.2
    fixed an error when timer overflows
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK CYCLE_4
(*

  version 1.0
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    E : BOOL := TRUE;
    T0, T1, T2, T3 : TIME;
    S0 : BOOL;
    SX : INT;
    SL : BOOL;
  END_VAR
  VAR_OUTPUT
    STATE : INT;
  END_VAR
  VAR
    tx : TIME;
    last : TIME;
    init: BOOL;
  END_VAR

  (* read system timer *)
  tx := DWORD_TO_TIME(T_PLC_MS());
  (* init on first cycle *)
  IF NOT init THEN
    init := TRUE;
    last := tx;
  END_IF;

  IF E THEN
    IF SL THEN
      (* when sx > 0 then the state sx is forced to start *)
      state:= LIMIT(0,SX,3);
      last := tx;
      (* this is to avoid to reset sx from the calling programm it does work fine on codesys but i am not sure about other systems, because we are writing to an input *)
      SL := FALSE;
    ELSE
      CASE state OF
        0 : (* wait for T0 and switch to next cycle *)
          IF tx - last >= T0 THEN
            state := 1;
            last := tx;
          END_IF;
        1 : (* wait for T1 over 1st cycle *)
          IF tx - last >= T1 THEN
            state := 2;
            last := tx;
          END_IF;
        2 : (* wait for T1 over 1st cycle *)
          IF tx - last >= T2 THEN
            state := 3;
            last := tx;
          END_IF;
        3 : (* wait for T2 over 2nd cycle *)
          IF tx - last >= T3 THEN
            IF S0 THEN State := 0; END_IF; (* if S0 is false, the sequence stops at state 3 *)
            last := tx;
          END_IF;
      END_CASE;
    END_IF;
  ELSE
    state := 0;
    last := tx;
  END_IF;

(* revision history
  hm  3. nov. 2008  rev 1.0
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK D_TRIG
(*
  this block is similar to the IEC Standard R_trig and F_trig but it monitors a DWORD, WORD or Byte Variable instead and generated an Output Pulse for one cycle only when the input has changed.
  an additional output x (Dword) will state the chage of the input.
  Example: the input has chaged from 0001 to 0010 then the output x will be 2.

  version 1.1 19. feb 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    in : DWORD;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
    X : DWORD;
  END_VAR
  VAR
    last_in : DWORD;
  END_VAR

  Q := in <> last_in;
  X := UDINT_TO_DWORD( DWORD_TO_UDINT(in) - DWORD_TO_UDINT(last_in));
  last_in := in;

(* revision history
  hm  4.09.2007   rev 1.0
    original version released

  hm  19. feb. 2008 rev 1.1
    performance improvement
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK GEN_BIT
(*
  gen_bit is 4 bit sequencial pattern generator with 4 DWORD inputs and 4 serial outputs.
  with the first clock pulse after a reset or after power on, bit 0 of the input DWORDS IN is present on the Outputs Q and the next clock cycle shifts to Bit 1 and so on.
  the input steps defines how many bits of the input dwords will be shifted to the outputs. the sequence can be repetive when rep = 0 or any amount of repetitions can be defined with input rep.

  version 1.2 14. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    in0 : DWORD;
    in1 : DWORD;
    in2 : DWORD;
    in3 : DWORD;
    clk : BOOL;
    steps : INT;
    rep : INT;
    rst : BOOL;
  END_VAR
  VAR_OUTPUT
    Q0 :BOOL;
    Q1 :BOOL;
    Q2 :BOOL;
    Q3 :BOOL;
    cnt : INT;
    run : BOOL;
  END_VAR
  VAR
    r0: DWORD;
    r1: DWORD;
    r2: DWORD;
    r3: DWORD;
    rx : INT := 1;
  END_VAR

  (* check if number of runs is finished or rep = 0 which means continuous *)
  IF clk AND NOT rst THEN
    run := (rep = 0) OR (rx <= rep);
    IF run THEN
      (* check for step counter reached and reset to 0 if cnt = steps *)
      IF cnt = steps THEN
        cnt := 0;
      END_IF;

      (* when cnt = 0 then reload the inputs into the registers *)
      IF cnt = 0 THEN
        r0 := in0;
        r1 := in1;
        r2 := in2;
        r3 := in3;
      END_IF;

      (* when cnt < steps, shift the lowest bits to the outputs *)
      IF (cnt < steps) THEN
        Q0 := r0.0;
        Q1 := r1.0;
        Q2 := r2.0;
        Q3 := r3.0;
        r0 := SHR(r0,1);
        r1 := SHR(r1,1);
        r2 := SHR(r2,1);
        r3 := SHR(r3,1);
      END_IF;

      (* increment the step counter *)
      cnt := cnt +1;
      IF (cnt = steps) AND (rep <> 0) THEN rx := rx +1; END_IF;
      IF (rx > rep) AND (rep <> 0) THEN run := FALSE; END_IF;
    END_IF;
  ELSE
    IF rst THEN
      run := FALSE;
      Q0 := FALSE;
      Q1 := FALSE;
      Q2 := FALSE;
      Q3 := FALSE;
      r0 := 0;
      r1 := 0;
      r2 := 0;
      r3 := 0;
      cnt := 0;
      rx := 1;
    END_IF;
  END_IF;

(* revision history
  hm  4 aug 2006  rev 1.0
    original version

  hm 15. oct. 2008  rev 1.1
    improved performance

  hm  14. mar. 2009 rev 1.2
    removed double assignments
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK GEN_SQ
(*
  gen_sq generates square wave signal with programmable period time.

  version 1.3 16. feb. 2011
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    PT : TIME;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
  END_VAR
  VAR
    tn: UDINT; //DWORD;
    tx: UDINT; //DWORD;
    init : BOOL;
  END_VAR

  (* read system time *)
  tx := DWORD_TO_UDINT( T_PLC_MS());

  IF NOT init THEN
    init := TRUE;
    tn := tx;
    Q := TRUE;
  ELSIF tx - tn >= DWORD_TO_UDINT( SHR(TIME_TO_DWORD(PT),1)) THEN
    Q := NOT Q;
    tn := tn + DWORD_TO_UDINT( SHR(TIME_TO_DWORD(pt),1));
  END_IF;

(* revision history
  hm  4. aug 2006 rev 1.0
    original version

  hm  17. sep 2007  rev 1.1
    replaced time() with T_PLC_MS() for compatibility reasons

  hm  18. jul. 2009 rev 1.2
    improved accuracy

  hm  16. feb 2011  rev 1.3
    corrected an error with timer overflow
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK SCHEDULER
(*
  SCHEDULER is used to call programs or function blocks at specific intervals.
  T0..T3 defines the interval times.

  version 1.1 14. mar. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    E0 : BOOL;
    E1 : BOOL;
    E2 : BOOL;
    E3 : BOOL;
  END_VAR
  VAR_INPUT //???CONSTANT
    T0, T1, T2, T3 : TIME;
  END_VAR
  VAR_OUTPUT
    Q0, Q1, Q2, Q3 : BOOL;
  END_VAR
  VAR
    init : BOOL;
    s0, s1, s2, s3 : TIME;
    tx : TIME;
    c : INT;
  END_VAR

  (* read system_time *)
  tx := DWORD_TO_TIME(T_PLC_MS());

  IF NOT init THEN
    init := TRUE;
    s0 := tx - T0;
    s1 := tx - T1;
    s2 := tx - T2;
    s3 := tx - T3;
  END_IF;

  Q0 := FALSE;
  Q1 := FALSE;
  Q2 := FALSE;
  Q3 :=FALSE;

  CASE c OF
    0:  IF tx - s0 >= T0 THEN
        Q0 := E0;
        s0 := tx;
      END_IF;
      c := 1;
    1:  IF tx - s1 >= T1 THEN
        Q1 := E1;
        s1 := tx;
      END_IF;
      c := 2;
    2:  IF tx - s2 >= T2 THEN
        Q2 := E2;
        s2 := tx;
      END_IF;
      c := 3;
    3:  IF tx - s3 >= T3 THEN
        Q3 := E3;
        s3 := tx;
      END_IF;
      c := 0;
  END_CASE;

(* revision history
  hm 28. sep. 2008  rev 1.0
    original version

  hm  14. mar. 2009 rev 1.1
    removed double assignments
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK SCHEDULER_2
(*
  SCHEDULER_2 is used to call programs or function blocks at specific cycles.
  C0..C3 defines after how many cycles the output becomes active.
  O0..O3 defines a cycle offset at startup.

  version 1.0 29. sep 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    E0 : BOOL;
    E1 : BOOL;
    E2 : BOOL;
    E3 : BOOL;
  END_VAR
  VAR_INPUT //???CONSTANT
    C0, C1, C2, C3 : UINT;
    O0, O1, O2, O3 : UINT;
  END_VAR
  VAR_OUTPUT
    Q0, Q1, Q2, Q3 : BOOL;
  END_VAR
  VAR
    sx : UINT;
  END_VAR

  Q0 := E0 AND (sx MOD C0 - O0 = 0);
  Q1 := E1 AND (sx MOD C1 - O1 = 0);
  Q2 := E2 AND (sx MOD C2 - O2 = 0);
  Q3 := E3 AND (sx MOD C3 - O3 = 0);

  (* increment cycle counter every cycle *)
  sx := sx + 1;

(* revision history
  hm 29. sep. 2008    rev 1.0
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK SEQUENCE_4
(*
  sequence_4 enables run when a low to high transition is present on start.
  a low to high transition on start will restart the sequencer at any time while a rst will hold the sequencer in reset while true.
  after run is enabled with a rising edge on start the sequencer waits for wait0 on in0 to enable q0 which stays on for delay0.
  the next cycle starts with wait1, continues with delay 1 and so on...
  if an edge is not detected during the wait period, the sequencer will then display the error number on the status output.
  the status numbers 1..4 are errors in step 0..3.
  after the last step that sets q3, the sequencer leaves q3 on for delay3 and then resets to the initial state.
  a step output will indicate the current step of the sequencer and will also be present with a fault condition.
  after the first output is turened on the sequencer switches from q0 to q1 and so on, at any time there is only one output enabled.
  if an input signal is not detected during a wait period, the sequencer will display the error number ( 1 for in0, 2 for in1 .... ).
  when an error is present and the config variable stop_on_error is set then the sequencer will stop. otherwise it will continue.
  The status output will also display 110 for waiting and 111 for sequence running.
  
  version 1.5 13. mar. 2009
  programmer  oscat
  tested by   hans
*)
  VAR_INPUT
    in0 : BOOL := TRUE;
    in1 : BOOL := TRUE;
    in2 : BOOL := TRUE;
    in3 : BOOL := TRUE;
    start : BOOL;
    rst : BOOL;
    wait0 : TIME;
    delay0 : TIME;
    wait1 : TIME;
    delay1 : TIME;
    wait2 : TIME;
    delay2 : TIME;
    wait3 : TIME;
    delay3 : TIME;
  END_VAR
  VAR_INPUT //???CONSTANT
    stop_on_error : BOOL;
  END_VAR
  VAR_OUTPUT
    Q0 : BOOL;
    Q1 : BOOL;
    Q2 : BOOL;
    Q3 : BOOL;
    QX : BOOL;
    run: BOOL;
    step : INT := -1;
    status : BYTE;
  END_VAR
  VAR
    last : TIME;
    edge : BOOL;
    tx: TIME;
    init: BOOL;
  END_VAR

  (* read sps timer *)
  tx := DWORD_TO_TIME(T_PLC_MS());

  (* initialize on startup *)
  IF NOT init THEN
    last := tx;
    init := TRUE;
    status := 110;
  END_IF;

  (* asynchronous reset *)
  IF rst THEN
    step := -1;
    Q0 := 0;
    Q1 := 0;
    Q2 := 0;
    Q3 := 0;
    status := 110;
    run := 0;

  (* edge on start input restarts the sequencer *)
  ELSIF start AND NOT edge THEN
    step := 0;
    last := tx;
    status := 111;
    Q0 := 0;
    Q1 := 0;
    Q2 := 0;
    Q3 := 0;
    run := 1;
  END_IF;
  edge := start;

  (* check if stop on status is necessary *)
  IF (status > 0) AND (status < 100) AND stop_on_error THEN RETURN; END_IF;

  (* sequence is running *)
  IF run AND step = 0 THEN
    IF NOT q0 AND in0 AND tx - last <= wait0 THEN
      Q0 := TRUE;
      last := tx;
    ELSIF NOT q0 AND tx - last > wait0 THEN
      status := 1;
      run := FALSE;
    ELSIF q0 AND tx - last >= delay0 THEN
      step := 1;
      last := tx;
    END_IF;
  END_IF;
  IF run AND step = 1 THEN
    IF NOT q1 AND in1 AND tx - last <= wait1 THEN
      Q0 := FALSE;
      Q1 := TRUE;
      last := tx;
    ELSIF NOT q1 AND Tx - last > wait1 THEN
      status := 2;
      q0 := FALSE;
      run := FALSE;
    ELSIF q1 AND tx - last >= delay1 THEN
      step := 2;
      last := tx;
    END_IF;
  END_IF;
  IF run AND step = 2 THEN
    IF NOT q2 AND in2 AND tx - last <= wait2 THEN
      Q1 := FALSE;
      Q2 := TRUE;
      last := tx;
    ELSIF NOT q2 AND Tx - last > wait2 THEN
      status := 3;
      q1 := FALSE;
      run := FALSE;
    ELSIF q2 AND tx - last >= delay2 THEN
      step := 3;
      last := tx;
    END_IF;
  END_IF;
  IF run AND step = 3 THEN
    IF NOT q3 AND in3 AND tx - last <= wait3 THEN
      Q2 := FALSE;
      Q3 := TRUE;
      last := tx;
    ELSIF NOT q3 AND Tx - last > wait3 THEN
      status := 4;
      q2 := FALSE;
      run := FALSE;
    ELSIF q3 AND tx - last >= delay3 THEN
      step := -1;
      q3 := FALSE;
      run := FALSE;
      status := 110;
    END_IF;
  END_IF;
  QX := q0 OR q1 OR q2 OR q3;

(* revision history
  hm 1.10.06    rev 1.1
    corrected delay logic to be after event and not before
    added any output

  hm 1.12.06    rev 1.2
    corrected failure in sequence logic.
    added init at startup to prevent from initial error after start.

  hm 17.1.2007    rev 1.3
    changed output fault to status for better compatibility with other modules (ESR).
    added stop on error functionality and setup variable
    default for inputs in0..3 is true.
    renamed variable state to step

  hm  17.sep 2007 rev 1.4
    replaced time() with T_PLC_MS() for compatibility reasons

  hm  13. mar. 2009 rev 1.5
    renamed output any to qx for compatibility resons
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK SEQUENCE_64
(*
  sequence generates a sequence of states with a programmable length for each state.

  version 1.0 29. jun. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    START : BOOL;
    SMAX : INT;
    PROG : ARRAY[0..63]OF TIME;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    STATE : INT := -1;
    TRIG : BOOL;
  END_VAR
  VAR
    tx : TIME;
    edge: BOOL;
    last: TIME;
  END_VAR

  (* read system timer *)
  tx := DWORD_TO_TIME(T_PLC_MS());
  TRIG := FALSE;

  IF RST THEN
    STATE := -1;

  (* start sequence *)
  ELSIF START AND NOT edge THEN
    STATE := 0;
    last := tx;
    TRIG := TRUE;

  (* sequence generator *)
  ELSIF (STATE >= 0) THEN
    IF (tx - last) >= PROG[STATE] THEN
      STATE := INC2(STATE, 1, -1, SMAX);
      last := tx;
      TRIG := TRUE;
    END_IF;
  END_IF;

  edge := START;

(* revision history
  hm  29. jun. 2008
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK SEQUENCE_8
(*
  sequence_8 enables run when a low to high transition is present on start.
  a low to high transition on start will restart the sequencer at any time while a rst will hold the sequencer in reset while true.
  after run is enabled with a rising edge on start the sequencer waits for wait0 on in0 to enable q0 which stays on for delay0.
  the next cycle starts with wait1, continues with delay 1 and so on...
  if an edge is not detected during the wait period, the sequencer will then display the error number on the status output.
  The status numbers are 1 .. 8 for erros in step 0..7.
  after the last step that sets q7, the sequencer leaves q7 on for delay7 and then resets to the initial state.
  a step output will indicate the current step of the sequencer and will also be present with a fault condition.
  after the first output is turened on the sequencer switches from q0 to q1 and so on, at any time there is only one output enabled.
  if an input signal is not detected during a wait period, the sequencer will display the error number ( 1 for in0, 2 for in1 .... ).
  when an error is present and the config variable stop_on_error is set then the sequencer will stop. otherwise it will continue.
  The status output will also display 110 for waiting and 111 sequece running.

  version 1.5 13. mar. 2009
  programmer  oscat
  tested by   hans
*)
  VAR_INPUT
    in0 : BOOL := TRUE;
    in1 : BOOL := TRUE;
    in2 : BOOL := TRUE;
    in3 : BOOL := TRUE;
    in4 : BOOL := TRUE;
    in5 : BOOL := TRUE;
    in6 : BOOL := TRUE;
    in7 : BOOL := TRUE;
    start : BOOL;
    rst : BOOL;
    wait0 : TIME;
    delay0 : TIME;
    wait1 : TIME;
    delay1 : TIME;
    wait2 : TIME;
    delay2 : TIME;
    wait3 : TIME;
    delay3 : TIME;
    wait4 : TIME;
    delay4 : TIME;
    wait5 : TIME;
    delay5 : TIME;
    wait6 : TIME;
    delay6 : TIME;
    wait7 : TIME;
    delay7 : TIME;
  END_VAR
  VAR_INPUT //???CONSTANT
    stop_on_error : BOOL;
  END_VAR
  VAR_OUTPUT
    Q0 : BOOL;
    Q1 : BOOL;
    Q2 : BOOL;
    Q3 : BOOL;
    Q4 : BOOL;
    Q5 : BOOL;
    Q6 : BOOL;
    Q7 : BOOL;
    QX : BOOL;
    run: BOOL;
    step : INT := -1;
    status : BYTE;
  END_VAR
  VAR
    last : TIME;
    edge : BOOL;
    tx: TIME;
    init: BOOL;
  END_VAR

  (* read sps timer *)
  tx := DWORD_TO_TIME(T_PLC_MS());

  (* initialize on startup *)
  IF NOT init THEN
    last := tx;
    init := TRUE;
    status := 110;
  END_IF;

  (* asynchronous reset *)
  IF rst THEN
    step := -1;
    Q0 := 0;
    Q1 := 0;
    Q2 := 0;
    Q3 := 0;
    Q4 := 0;
    Q5 := 0;
    Q6 := 0;
    Q7 := 0;
    status := 110;
    run := 0;

  (* edge on start input restarts the sequencer *)
  ELSIF start AND NOT edge THEN
    step := 0;
    last := tx;
    status := 111;
    Q0 := 0;
    Q1 := 0;
    Q2 := 0;
    Q3 := 0;
    Q4 := 0;
    Q5 := 0;
    Q6 := 0;
    Q7 := 0;
    run := 1;
  END_IF;
  edge := start;

  (* check if stop on error is necessary *)
  IF (status > 0) AND (status < 100) AND stop_on_error THEN RETURN; END_IF;

  (* sequence is running *)
  IF run AND step = 0 THEN
    IF NOT q0 AND in0 AND tx - last <= wait0 THEN
      Q0 := TRUE;
      last := tx;
    ELSIF NOT q0 AND tx - last > wait0 THEN
      status := 1;
      run := FALSE;
    ELSIF q0 AND tx - last >= delay0 THEN
      step := 1;
      last := tx;
    END_IF;
  END_IF;
  IF run AND step = 1 THEN
    IF NOT q1 AND in1 AND tx - last <= wait1 THEN
      Q0 := FALSE;
      Q1 := TRUE;
      last := tx;
    ELSIF NOT q1 AND Tx - last > wait1 THEN
      status := 2;
      q0 := FALSE;
      run := FALSE;
    ELSIF q1 AND tx - last >= delay1 THEN
      step := 2;
      last := tx;
    END_IF;
  END_IF;
  IF run AND step = 2 THEN
    IF NOT q2 AND in2 AND tx - last <= wait2 THEN
      Q1 := FALSE;
      Q2 := TRUE;
      last := tx;
    ELSIF NOT q2 AND Tx - last > wait2 THEN
      status := 3;
      q1 := FALSE;
      run := FALSE;
    ELSIF q2 AND tx - last >= delay2 THEN
      step := 3;
      last := tx;
    END_IF;
  END_IF;
  IF run AND step = 3 THEN
    IF NOT q3 AND in3 AND tx - last <= wait3 THEN
      Q2 := FALSE;
      Q3 := TRUE;
      last := tx;
    ELSIF NOT q3 AND Tx - last > wait3 THEN
      status := 4;
      q2 := FALSE;
      run := FALSE;
    ELSIF q3 AND tx - last >= delay3 THEN
      step := 4;
      last := tx;
    END_IF;
  END_IF;
  IF run AND step = 4 THEN
    IF NOT q4 AND in4 AND tx - last <= wait4 THEN
      Q3 := FALSE;
      Q4 := TRUE;
      last := tx;
    ELSIF NOT q4 AND Tx - last > wait4 THEN
      status := 5;
      q3 := FALSE;
      run := FALSE;
    ELSIF q4 AND tx - last >= delay4 THEN
      step := 5;
      last := tx;
    END_IF;
  END_IF;
  IF run AND step = 5 THEN
    IF NOT q5 AND in5 AND tx - last <= wait5 THEN
      Q4 := FALSE;
      Q5 := TRUE;
      last := tx;
    ELSIF NOT q5 AND Tx - last > wait5 THEN
      status := 6;
      q4 := FALSE;
      run := FALSE;
    ELSIF q5 AND tx - last >= delay5 THEN
      step := 6;
      last := tx;
    END_IF;
  END_IF;
  IF run AND step = 6 THEN
    IF NOT q6 AND in6 AND tx - last <= wait6 THEN
      Q5 := FALSE;
      Q6 := TRUE;
      last := tx;
    ELSIF NOT q6 AND Tx - last > wait6 THEN
      status := 7;
      q5 := FALSE;
      run := FALSE;
    ELSIF q6 AND tx - last >= delay6 THEN
      step := 7;
      last := tx;
    END_IF;
  END_IF;
  IF run AND step = 7 THEN
    IF NOT q7 AND in7 AND tx - last <= wait7 THEN
      Q6 := FALSE;
      Q7 := TRUE;
      last := tx;
    ELSIF NOT q7 AND Tx - last > wait7 THEN
      status := 8;
      q6 := FALSE;
      run := FALSE;
    ELSIF q7 AND tx - last >= delay7 THEN
      step := -1;
      Q7 := FALSE;
      Run := FALSE;
      status := 110;
    END_IF;
  END_IF;
  QX := q0 OR q1 OR q2 OR q3 OR q4 OR q5 OR q6 OR q7;

(* revision history
  hm 1.10.06    rev 1.1
    corrected delay logic to be after event and not before
    added any output

  hm 1.12.06    rev 1.2
    corrected failure in sequence logic.
    added init at startup to prevent from initial statuss after start.

  hm 17.1.2007    rev 1.3
    changed output fault to status for better compatibility with other modules (ESR)
    added stop on error functionality and setup variable
    default for inputs in0..7 is true.
    renames variable state to step

  hm  17.sep 2007 rev 1.4
    replaced time() with T_PLC_MS() for compatibility reasons

  hm  13. mar. 2009 rev 1.5
    renamed output any to qx for compatibility resons
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK TMAX
(*
  Q of tmax will follow IN except that it forces a maximum ontime for the output Q.
  the output Z will be active for one cycle if the output is forced low by the timeout.

  version 1.0 20. jul. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    IN : BOOL;
    PT : TIME;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
    Z : BOOL;
  END_VAR
  VAR
    tx : TIME;
    start : TIME;
    last_in: BOOL;
  END_VAR

  (* read system timer *)
  tx := DWORD_TO_TIME(T_PLC_MS());

  Z := FALSE;

  IF NOT in THEN
    Q := FALSE;
  ELSIF IN AND NOT last_in THEN
    Q := TRUE;
    start := tx;
  ELSIF (tx - start >= PT) AND Q THEN
    Q := FALSE;
    Z := TRUE;
  END_IF;

  last_in := IN;

(* revision history
  hm  20. jul. 2008 rev 1.0
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK TMIN
(*
  Q of tMIN will follow IN except that it forces a minimum ontime for the output Q.

  version 1.0 21. jul. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    IN : BOOL;
    PT : TIME;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
  END_VAR
  VAR
    pm : TP;
  END_VAR

  pm(in := IN, PT := PT);
  Q := IN OR pm.Q;

(* revision history
  hm  21. jul. 2008 rev 1.0
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK TOF_1
(*
  TOF_1 will extend a pulse on input in for PT seconds.
  in addition the timer can be cleared asynchronously with rst.
  TOF_1 is the same function as TOF from the standard LIB except the asynchronous reset input.

  version 1.0 17. jul. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    IN : BOOL;
    PT : TIME;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
  END_VAR
  VAR
    tx : TIME;
    start : TIME;
  END_VAR

  (* read system timer *)
  tx := DWORD_TO_TIME(T_PLC_MS());

  IF RST THEN
    Q := FALSE;
  ELSIF IN THEN
    Q := TRUE;
    start := tx;
  ELSIF tx - start >= PT THEN
    Q := FALSE;
  END_IF;

(* revision history
  hm  17. jul. 2008 rev 1.0
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK TONOF
(*
  TONOF generated a TON and TOF Delay for the Input N TON (T1) and TOF (T2) can be configured separately
  version 1.2 21. jul 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IN : BOOL;
      T_ON,T_OFF : TIME;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
  END_VAR
  VAR
     X : TON;
     old: BOOL;
     mode: BOOL;
  END_VAR

  IF IN XOR old THEN
    X(IN := FALSE, PT := SEL(IN,T_OFF,T_ON));
    mode := IN;
    old := IN;
  END_IF;
  X(IN := TRUE);
  IF X.Q THEN Q := mode;END_IF;

(* revision history
  hm  10. dec 2007  rev 1.0
    original version

  hm  17. sep. 2007 rev 1.1
    improved performance

  hm  21. jul. 2009 rev 1.2
    fixed a timing probelm
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK TP_1
(*
  TP_1 generates a pulse every time it is calles with in := TRUE.
  in addition the timer can be cleared asynchronously with rst.
  the timer can be retriggered as often as necessary. it will count PT from the last trigger.

  version 1.0 28. jun. 2008
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    IN : BOOL;
    PT : TIME;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
  END_VAR
  VAR
    tx : TIME;
    start : TIME;
    ix : BOOL;
  END_VAR

  (* read system timer *)
  tx := DWORD_TO_TIME(T_PLC_MS());

  IF RST THEN
    Q := FALSE;
  ELSIF IN AND NOT ix THEN
    Q := TRUE;
    start := tx;
  ELSIF tx - start >= PT THEN
    Q := FALSE;
  END_IF;

  ix:= IN;

(* revision history
  hm  28. jun. 2008
    original version
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/generators' *)
FUNCTION_BLOCK TP_1D
(*
  TP_1D generates a pulse every time it is calles with in := TRUE.
  the module will reset IN by itself so no clearing of in is necessary.
  in addition the timer can be cleared asynchronously with rst.
  also the rst input is cleared by the module itself.
  the timer can be retriggered as often as necessary. it will count PT from the last trigger.
  after the time PT1 is elapsed, the timer blocks itself for PT2 and only allow new sequences after PT2 has elapsed.

  version 1.0 28. jun. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    IN : BOOL;
    PT1 : TIME;
    PTD : TIME;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    Q : BOOL;
    W : BOOL;
  END_VAR
  VAR
    tx : TIME;
    start: TIME;
    ix: BOOL;
  END_VAR

    (* read system timer *)
    tx := DWORD_TO_TIME(T_PLC_MS());

    IF RST THEN
      Q := FALSE;
      rst := FALSE;
      W := FALSE;
    ELSIF W THEN
      IF tx - start >= PTD THEN
        W := FALSE;
      END_IF;
    ELSIF IN AND NOT ix THEN
      Q := TRUE;
      start := tx;
      in := FALSE;
    ELSIF tx - start >= PT1 THEN
      Q := FALSE;
      W := TRUE;
      start := tx;
    END_IF;

    ix := IN;

(* revision history
  hm  28. jun. 2008
    original version
*)
END_FUNCTION_BLOCK

