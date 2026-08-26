(* @PATH := '\/Logic\/gate logic' *)
FUNCTION BCDC_TO_INT : INT
(*
  this function converts a two digit bcd number into an integer.

  version 1.1 30. jun. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    IN : BYTE;
  END_VAR

  BCDC_TO_INT := BYTE_TO_INT((in AND 16#0F)) + (BYTE_TO_INT( SHR(in,4)) * 10);

(* revision history
  hm  13.12.2007  rev 1.0
    original version

  hm  30.6.2008 rev 1.1
    changed name BCD_TO_INT to BCDC_TO_INT to avoid collision with util.lib
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION BIT_COUNT : INT
(*
  BIT_COUNT counts the amount True of bits in a dword.
  for example: bit_count(3) returns 2 because two bits (bits 0 and 1) are true and all others are false.

  version 1.1 10 sep 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IN : DWORD;
  END_VAR

  BIT_COUNT := 0;
  WHILE in > 0 DO
  	IF in.0 THEN BIT_COUNT := BIT_COUNT + 1; END_IF;
  	in := SHR(in,1);
  END_WHILE;

(* revision history
  5.7.2007  rev 1.0   original version

  10.9.2007 rev 1.1   hm
    changed algorithm for better performace
    the execution time has reduced by a factor of 5
    deleted unused variable temp
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION BIT_LOAD_B : BYTE
(*
  this function loads a bit into a byte at position pos.
  version 1.1 16. mar 2008
  programmer  hugo
  tested by tobias
 *)
  VAR_INPUT
    IN : BYTE;
    VAL : BOOL;
    POS : INT;
  END_VAR
  VAR CONSTANT
    dat : BYTE := 1;
  END_VAR

  IF VAL THEN
    BIT_LOAD_B := in OR SHL( dat, INT_TO_UINT(pos));
  ELSE
    BIT_LOAD_B := in AND (NOT SHL(dat, INT_TO_UINT(pos)));
  END_IF;

(* revision history
  hm  29. feb 2008  rev 1.0
    original version

  hm  16. mar 2008  rev 1.1
    change input bit to val for compatibility reasons
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION BIT_LOAD_B2 : BYTE
(*
  this function loads N bits of D at pos P in Byte I

  version 1.0 18. oct. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    I : BYTE;
    D : BOOL;
    P : INT;
    N : INT;
  END_VAR

  IF D THEN
    BIT_LOAD_B2 := ROL(SHR(BYTE#255, 8 - INT_TO_UINT(N)) OR ROR(i, INT_TO_UINT(P)), INT_TO_UINT(P));
  ELSE
    BIT_LOAD_B2 := ROL(SHL(BYTE#255, INT_TO_UINT(N)) AND ROR(I, INT_TO_UINT(P)), INT_TO_UINT(P));
  END_IF;

(* revision history
  hm  18. oct. 2008 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION BIT_LOAD_DW : DWORD
(*
  this function loads a bit into a DWord at position pos.

  version 1.1 16. mar 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    IN : DWORD;
    VAL : BOOL;
    POS : INT;
  END_VAR
  VAR CONSTANT
    dat : DWORD := 1;
  END_VAR

  IF val THEN
    BIT_LOAD_DW := in OR SHL(dat, INT_TO_UINT(pos));
  ELSE
    BIT_LOAD_DW := in AND (NOT SHL(dat, INT_TO_UINT(pos)));
  END_IF;

(* revision history
  hm  29. feb 2008  rev 1.0
    original version

  hm  16. mar 2008  rev 1.1
    change input bit to val for compatibility reasons
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION BIT_LOAD_DW2 : DWORD
(*
  this function loads N bits of D at pos P in DWORD I

  version 1.0 18. oct. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    I : DWORD;
    D : BOOL;
    P : INT;
    N : INT;
  END_VAR

  IF D THEN
    BIT_LOAD_DW2 := ROL(SHR(DWORD#4294967295, 32 - INT_TO_UINT(N)) OR ROR(i, INT_TO_UINT(P)), INT_TO_UINT(P));
  ELSE
    BIT_LOAD_DW2 := ROL(SHL(DWORD#4294967295, INT_TO_UINT(N)) AND ROR(I, INT_TO_UINT(P)), INT_TO_UINT(P));
  END_IF;

(* revision history
  hm  18. oct. 2008 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION BIT_LOAD_W : WORD
(*
  this function loads a bit into a Word at position pos.

  version 1.1 16. mar 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    IN : WORD;
    VAL : BOOL;
    POS : INT;
  END_VAR
  VAR CONSTANT
    dat : WORD := 1;
  END_VAR

  IF val THEN
    BIT_LOAD_W := in OR SHL(dat, INT_TO_UINT(pos));
  ELSE
    BIT_LOAD_W := in AND (NOT SHL(dat, INT_TO_UINT(pos)));
  END_IF;

(* revision history
  hm  29. feb 2008  rev 1.0
    original version

  hm  16. mar 2008  rev 1.1
    change input bit to val for compatibility reasons
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION BIT_LOAD_W2 : WORD
(*
  this function loads N bits of D at pos P in WORD I

  version 1.0 18. oct. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    I : WORD;
    D : BOOL;
    P : INT;
    N : INT;
  END_VAR

  IF D THEN
    BIT_LOAD_W2 := ROL(SHR(WORD#65535, 16 - INT_TO_UINT(N)) OR ROR(i, INT_TO_UINT(P)), INT_TO_UINT(P));
  ELSE
    BIT_LOAD_W2 := ROL(SHL(WORD#65535, INT_TO_UINT(N)) AND ROR(I, INT_TO_UINT(P)), INT_TO_UINT(P));
  END_IF;

(* revision history
  hm  18. oct. 2008 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION BIT_OF_DWORD : BOOL
(*
  this function extracts a single bit from the nth position from right (right is lowest bit)
  the lowest Bit (Bit0 from in) is selected with N=0.

  version 1.2 6. jun. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    in : DWORD;
    N : INT;
  END_VAR

  BIT_OF_DWORD := (SHR(in, INT_TO_UINT(N)) AND 16#00000001) > 0;


(* old code used before rev 1.1
  temp := SHR(in,n);
  Bit_of_Dword := temp.0;
*)
(* revision history
  hm  4. aug. 2006  rev 1.0
    original version

  hm  29. feb 2008  rev 1.1
    improved performance

  hm  6. jun. 2008  rev 1.2
    changes type of input N from byte to int
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION BIT_TOGGLE_B : BYTE
(*
  this function toggles a bit of a BYTE at position pos.

  version 1.0 18. oct. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    IN : BYTE;
    POS : INT;
  END_VAR

  BIT_TOGGLE_B := SHL(BYTE#1, INT_TO_UINT(POS)) XOR IN;

(* revision history
  hm  18. oct. 2008 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION BIT_TOGGLE_DW : DWORD
(*
  this function toggles a bit of a WORD at position pos.

  version 1.0 18. oct. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    IN : DWORD;
    POS : INT;
  END_VAR

  BIT_TOGGLE_DW := SHL(DWORD#1, INT_TO_UINT(POS)) XOR IN;

(* revision history
  hm  18. oct. 2008 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION BIT_TOGGLE_W : WORD
(*
  this function toggles a bit of a WORD at position pos.

  version 1.0 18. oct. 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    IN : WORD;
    POS : INT;
  END_VAR

  BIT_TOGGLE_W := SHL(WORD#1, INT_TO_UINT(POS)) XOR IN;

(* revision history
  hm  18. oct. 2008 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION BYTE_OF_BIT : BYTE
(*
  this function creates a byte from 8 individual bits

  version 1.1  18. feb 2006
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    B0:BOOL;
    B1:BOOL;
    B2:BOOL;
    B3:BOOL;
    B4:BOOL;
    B5:BOOL;
    B6:BOOL;
    B7:BOOL;
  END_VAR

  Byte_of_bit := SHL(SHL(SHL(SHL(SHL(SHL(SHL(BOOL_TO_BYTE(B7),1) OR BOOL_TO_BYTE(B6),1) OR BOOL_TO_BYTE(B5),1) OR BOOL_TO_BYTE(B4),1)
                 OR BOOL_TO_BYTE(B3),1) OR BOOL_TO_BYTE(B2),1) OR BOOL_TO_BYTE(B1),1) OR BOOL_TO_BYTE(B0);

(* revision history
  hm  4. aug 2006   rev 1.0
    original version

  hm  18. feb. 2008 rev 1.1
    improved performance
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION BYTE_OF_DWORD : BYTE
(*
  this function extracts a single byte from the nth position from right (right is lowest byte)
  the lower byte (starting with Bit0 from in) is selected with N=0.

  version 1.2 30. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    in : DWORD;
    N : BYTE;
  END_VAR
  VAR_TEMP
    tmp : DWORD;
  END_VAR

  tmp := SHL( BYTE_TO_DWORD(n), 3);
  BYTE_OF_DWORD := DWORD_TO_BYTE( SHR(in, DWORD_TO_UINT(tmp)));

(* revision history
  hm  17. jan 2007  rev 1.0
    original version

  hm  2. jan 2008   rev 1.1
    improved performance

  hm  30. oct. 2008 rev 1.2
    improved performance
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION_BLOCK BYTE_TO_BITS
(*
  this Function Block extracts the 8 Bits from a byte

  version 1.1 16. mar. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IN: BYTE;
  END_VAR
  VAR_OUTPUT
    B0: BOOL;
    B1: BOOL;
    B2: BOOL;
    B3: BOOL;
    B4: BOOL;
    B5: BOOL;
    B6: BOOL;
    B7: BOOL;
  END_VAR

  B0 := IN.0;
  B1 := IN.1;
  B2 := IN.2;
  B3 := IN.3;
  B4 := IN.4;
  B5 := IN.5;
  B6 := IN.6;
  B7 := IN.7;

(* revision history
  hm    4. aug 2006 rev 1.0
    original version

  hm    16. mar 2008  rev 1.1
    renamed from byte_to_bit to byte_to_bits for compatibility reasons
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION BYTE_TO_GRAY : BYTE
(*
  this function converts a binary to gray code

  version 1.0 9. nov. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    IN : BYTE;
  END_VAR

  BYTE_TO_GRAY := IN XOR SHR(IN,1);

(* revision history
  hm  9. nov. 2009  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION CHECK_PARITY : BOOL
(*
  this function checks for an even partity for a dword and partity bit.

  version 1.3 18 feb 2008
  programmer  hugo
  tested by tobias
*)
  VAR_INPUT
    in : DWORD;
    p : BOOL;
  END_VAR

  CHECK_PARITY := NOT p;
  WHILE in > 0 DO
  	CHECK_PARITY := CHECK_PARITY XOR in.0 XOR in.1 XOR in.2 XOR in.3;
  	in := SHR(in,4);
  END_WHILE;

(* code before rev 1.2
  WHILE in > 0 DO
    IF in.0 THEN cnt := cnt + 1; END_IF;
    in := SHR(in,1);
  END_WHILE;
  check_parity := even(cnt) XOR P;
*)
(* revision history
  rev 1.0 HM  1.oct.2006

  rev 1.1 hm  10.sep.2007
    changed algorithm to improove performance

  rev 1.2 hm  8 dec 2007
    changed algorithm to improove performance

  rev 1.3 hm  18. feb 2008
    changed algorithm to improove performance
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION CHK_REAL : BYTE
(*
  this function checks a floating point variable of type real (IEEE754-32Bits) for NAN and infinity
  RETURN values: #0 = normal value, #20 = +infinity, #40 = -infinty, #80 = NAN

  version 1.0 20. jan. 2011
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR
  VAR
    pt : PTR_TO DWORD;
    tmp : DWORD;
  END_VAR

  pt := ADR(X);       (* move real to dword, real_to_dword does not work becasze it treats dword as a number on many systems *)
  tmp := ROL(pt^,1);      (* rotate left foir easy checking, sign will be at lease significant digit *)
  IF tmp < 16#FF000000 THEN
    CHK_REAL := 16#00;    (* normalized and denormalized numbers *)
  ELSIF tmp = 16#FF000000 THEN
    CHK_REAL := 16#20;    (* X is +infinity see IEEE754 *)
  ELSIF tmp = 16#FF000001 THEN
    CHK_REAL := 16#40;    (* X is -infinity see IEEE754 *)
  ELSE
    CHK_REAL := 16#80;    (* X is NAN see IEEE754 *)
  END_IF;

(* revision history
  hm   20. jan. 2011  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION_BLOCK DEC_2
(*
  a bit input will be decoded to the two outputs Q0 or Q1
  dependent on the value of A
  A=0 decodes to Q0 and A=1 decodes to Q1

  version 1.1 3 Mar 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    D: BOOL;
    A: BOOL;
  END_VAR
  VAR_OUTPUT
    Q0: BOOL;
    Q1: BOOL;
  END_VAR

  Q0 := D AND NOT A;
  Q1 := D AND A;

(* revision history
  hm 3.3.2007 rev 1.1
    rewritten in ST for better compatibility
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION_BLOCK DEC_4
(*
  a bit input will be decoded to one of the 4 outputs
  dependent on the Adress on A0 and A1

  executioin TIME on wago 750-841 = 9us
  version 1.1 3 Mar 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    D: BOOL;
    A0: BOOL;
    A1: BOOL;
  END_VAR
  VAR_OUTPUT
    Q0: BOOL;
    Q1: BOOL;
    Q2: BOOL;
    Q3: BOOL;
  END_VAR

  Q0 := D AND NOT A0 AND NOT A1;
  Q1 := D AND A0 AND NOT A1;
  Q2 := D AND NOT A0 AND A1;
  Q3 := D AND A0 AND A1;

(* revision history
  hm 3.3.2007 rev 1.1
    rewritten in ST for better compatibility
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION_BLOCK DEC_8
(*
  a bit input will be decoded to one of the 8 outputs
  dependent on the Adress on A0, A1 and A2


  version 1.3 28. mar. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    D: BOOL;
    A0: BOOL;
    A1: BOOL;
    A2: BOOL;
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
    X : INT;
  END_VAR

  X.0 := A0; X.1 := A1; X.2 := A2;

  Q0 := FALSE;
  Q1 := FALSE;
  Q2 := FALSE;
  Q3 := FALSE;
  Q4 := FALSE;
  Q5 := FALSE;
  Q6 := FALSE;
  Q7 := FALSE;

  CASE X OF
    0 : Q0 := D;
    1 : Q1 := D;
    2 : Q2 := D;
    3 : Q3 := D;
    4 : Q4 := D;
    5 : Q5 := D;
    6 : Q6 := D;
    7 : Q7 := D;
  END_CASE;

(* revision history
  hm 3. mar. 2007 rev 1.1
    rewritten in ST for better compatibility

  hm  26. oct. 2008 rev 1.2
    code optimized

  hm  28. mar. 2009 rev 1.3
    replaced multiple assignments
*)
END_FUNCTION_BLOCK


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION DW_TO_REAL : REAL
(*
  this function converts a DWORD to REAL in a bitwise manner.

  version 1.0 18. apr. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : DWORD;
  END_VAR
  VAR
    pt : PTR_TO REAL;
  END_VAR

  pt := ADR(X);
  DW_TO_REAL := pt^;

(* revision history
  hm  18. apr. 2008
    original version
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION DWORD_OF_BYTE : DWORD
(*
  this function creates a Dword from 4 individual bytes

  version 1.3 18. jul. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    B3 : BYTE;
    B2 : BYTE;
    B1 : BYTE;
    B0 : BYTE;
  END_VAR

  DWORD_OF_BYTE := SHL(SHL(SHL(BYTE_TO_DWORD(B3),8) OR BYTE_TO_DWORD(B2),8) OR BYTE_TO_DWORD(B1),8) OR BYTE_TO_DWORD(B0);

(* revision history
  hm  24. jan 2007  rev 1.0
    original version

  hm 2. jan 2008  rev 1.1
    inproved performance

  hm  23. apr. 2008 rev 1.2
    reverse order of inputs to be more logical

  hm  18. jul. 2009 rev 1.3
    added type conversions for compatibility reasons
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION DWORD_OF_WORD : DWORD
(*
  this function creates a Dword from 2 individual Words

  version 1.0 18. jul. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    W1 : WORD;
    W0 : WORD;
  END_VAR

  DWORD_OF_WORD := SHL(WORD_TO_DWORD(W1),16) OR WORD_TO_DWORD(W0);


(* revision history
  hm  18. jul. 2009 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION GRAY_TO_BYTE : BYTE
(*
  this function converts a gray code into binary

  version 1.0 9. nov. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    IN : BYTE;
  END_VAR

  GRAY_TO_BYTE := SHR(IN,4) XOR IN;
  GRAY_TO_BYTE := SHR(GRAY_TO_BYTE,2) XOR GRAY_TO_BYTE;
  GRAY_TO_BYTE := SHR(GRAY_TO_BYTE,1) XOR GRAY_TO_BYTE;

(* revision history
  hm  9. nov. 2009  rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION INT_TO_BCDC : BYTE
(*
  this function converts an integer into a two digit bcd number.

  version 1.1 30. jun. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IN : INT;
  END_VAR

  INT_TO_BCDC := SHL(INT_TO_BYTE(IN / INT#10),4) OR INT_TO_BYTE(in MOD INT#10);

(* revision history
  hm  13.12.2007
    original version

  hm  30.6.2008 rev 1.1
    changed name INT_TO_BCD to INT_TO_BCDC to avoid collision with util.lib
    corrected error in code
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION MUX_2 : BOOL
(*
  dual input multiplexer
  depending on the value of A0, D0 or D1 will be switched to the Output

  executioin TIME on wago 750-841 = 7us
  version 1.2 16. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    D0: BOOL;
    D1: BOOL;
    A0: BOOL;
  END_VAR

  MUX_2 := SEL(A0, D0, D1);

(* revision history:
  hm  5.10.2006   rev 1.1
    changed to ST Langage for better portability.

  hm  16. oct. 2008 rev 1.2
    improved performance
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION MUX_4 : BOOL
(*
  quad input multiplexer
  depending on the value of A0 and A1, one of the 4 inputs will be switched to the Output

  version 1.2 16. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    D0: BOOL;
    D1: BOOL;
    D2: BOOL;
    D3: BOOL;
    A0: BOOL;
    A1: BOOL;
  END_VAR

  IF A1 THEN
    MUX_4 := SEL(A0, D2, D3);
  ELSE
    MUX_4 := SEL(A0, D0, D1);
  END_IF;

(* revision history:
  hm  5.10.2006   rev 1.1
    rewritten to ST for better portability

  hm  16. oct. 2008 rev 1.2
    improved performance
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION PARITY : BOOL
(*
  this function calculates the even parity of an input Dword
  the output will be true if the amount of high bits are an odd number.

  version 1.3 18 feb 2008
  programmer  hugo
  tested by   hans
*)
  VAR_INPUT
    in : DWORD;
  END_VAR

  PARITY := 0;
  WHILE in > 0 DO
  	PARITY := PARITY XOR in.0 XOR in.1 XOR in.2 XOR in.3;
  	in := SHR(in,4);
  END_WHILE;

(* code before rev 1.2
  WHILE in > 0 DO
    IF in.0 THEN cnt := cnt +1; END_IF;
    in := SHR(in,1);
  END_WHILE;
  IF (cnt MOD 2) = 1 THEN parity := TRUE; ELSE parity := FALSE; END_IF;
*)
(* revision history
  rev 1.0 hm 1 sep 2006
    original version

  rev 1.1 hm 10.9.2007
    changed algorithm to improve performance

  rev 1.2 hm  8 dec 2007
    changed algorithm to improve performance

  rev 1.3 hm  18 feb 2008
    changed algorithm to improve performance
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION REAL_TO_DW : DWORD
(*
  this function converts a 32 Bit Real to a dword in a bitwise manner.

  version 1.0 18. apr. 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    X : REAL;
  END_VAR
  VAR
    pt : PTR_TO DWORD;
  END_VAR

  pt := ADR(X);
  REAL_TO_DW := pt^;

(* revision history
  hm  18. apr. 2008
    original version
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION REFLECT : DWORD
(*
  This function reverses the specified amount of bits from bit 0 to bit n within a dword  while L specifies the amount of Bits to be reflected.

  version 1.0 16. jan 2011
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    D : DWORD;
    L : INT;
  END_VAR
  VAR
    i : INT;
  END_VAR

  REFLECT := 0;
  FOR i := 1 TO L DO
  	REFLECT := SHL(REFLECT, 1) OR BOOL_TO_DWORD(D.0);
  	D := SHR(D, 1);
  END_FOR;
  REFLECT := REFLECT OR SHL(D, INT_TO_UINT(L));

(* revision history
  hm   16. jan 2011
    new module
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION REVERSE : BYTE
(*
  This function reverses the bits of a byte so that after execution bit 7 is at bit 0 location and so forth.

  version 1.1 18. feb 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IN : BYTE;
  END_VAR

  REVERSE := SHL(in,7) OR SHR(in,7) OR (ROR(in,3) AND 2#01000100) OR (ROL(in,3) AND 2#00100010)
             OR (SHL(in,1) AND 2#00010000) OR (SHR(in,1) AND 2#00001000);

(* revision history
  hm    9.oct 2007    rev 1.0
    original version

  hm    18. feb 2008  rev 1.1
    improved performance
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION SHL1 : DWORD
(*
  SHL1 shifts N bits to the left filling the new bits with 1

  version 1.1 27 dec 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IN : DWORD;
    N : INT;
  END_VAR
  VAR CONSTANT
    temp : DWORD := 16#FFFF_FFFF;
  END_VAR

  SHL1 := SHR(temp, 32 - INT_TO_UINT(N)) OR SHL(IN, INT_TO_UINT(N));

(* revision history
  hm  14.9.2007   rev 1.0
    original version

  hm  27. dec 2007  rev 1.1
    changed code for better performance
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION SHR1 : DWORD
(*
  SHR1 shifts N bits to the right filling the new bits with 1

  version 1.1 27 dec 2007
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IN : DWORD;
    N : INT;
  END_VAR
  VAR CONSTANT
    temp : DWORD := 16#FFFF_FFFF;
  END_VAR

  SHR1 := SHL(temp,32-INT_TO_UINT(N)) OR SHR(IN, INT_TO_UINT(N));

(* revision history
  hm  14.9.2007   rev 1.0
    original version

  hm  27. dec 2007  rev 1.1
    changed code for better performance
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION SWAP_BYTE : WORD
(*
  This function swaps the high and low byte of the word in.

  version 1.0 4 feb 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IN : WORD;
  END_VAR

  SWAP_BYTE := ROL(in,8);

(* revision history
  hm    4. feb 2008 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION SWAP_BYTE2 : DWORD
(*
  This function reverses the byte order in the dword.

  version 1.0 4 feb 2008
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    IN : DWORD;
  END_VAR

  Swap_Byte2 := (ROR(in,8) AND 16#FF00FF00) OR (ROL(in,8) AND 16#00FF00FF);

(* revision history
  hm    4. feb 2008 rev 1.0
    original version
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION WORD_OF_BYTE : WORD
(*
  this function creates a word from 2 individual bytes

  version 1.4 18. jul. 2009
  programmer  hugo
  tested by   tobias
*)
  VAR_INPUT
    B1 : BYTE;
    B0 : BYTE;
  END_VAR

  WORD_OF_BYTE := SHL(BYTE_TO_WORD(B1),8) OR BYTE_TO_WORD(B0);

(* revision history
  hm  24. jan 2007  rev 1.0
    original version

  hm  2. jan 2008 rev 1.1
    improved performance

  hm  19. feb 2008  rev 1.2
    replaced and with or for better compatibility

  hm  23. apr. 2008 rev 1.3
    reverse order of inputs to be more logical

  hm  18. jul. 2009 rev 1.4
    added type conversions for compatibility reasons
*)
END_FUNCTION


(* @PATH := '\/Logic\/gate logic' *)
FUNCTION WORD_OF_DWORD : WORD
(*
  this function extracts a single word from the nth position from right (right is lowest byte)
  the lower word (starting with Bit0 from in) is selected with N=0.

  version 1.2 30. oct. 2008
  programmer  hugo
  tested by oscat
*)
  VAR_INPUT
    in : DWORD;
    N : BYTE;
  END_VAR

  WORD_OF_DWORD := DWORD_TO_WORD( SHR( in, DWORD_TO_UINT( SHL( BYTE_TO_DWORD(n), 4))));

(* revision history
  hm  17. jan 2007  rev 1.0
    original version

  hm  2. jan 2008   rev 1.1
    improved performance

  hm  30. oct. 2008 rev 1.2
    improved performance
*)
END_FUNCTION

