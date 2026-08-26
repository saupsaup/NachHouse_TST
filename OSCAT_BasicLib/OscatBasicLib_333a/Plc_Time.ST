(* @PATH := '\/Engineering\/measurements' *)
FUNCTION T_PLC_MS : DWORD
(*
  T_PLC_MS reads the internal PLC timer and return the time, it has the advantage to be able to set a debug mode
  and speed up the counter to test the plc timer overrun which occurs every 50 days respectively 25 days at siemens S7
  this routine also allows to correct the behavior of s7 where the internal plc counter will not count all 32 bits.

  version 1.2 16. nov 2008
  programmer  hugo
  tested by oscat
*)
  VAR CONSTANT
    debug : BOOL := 0;
    N : INT := 0;
    offset : DWORD := 0;
  END_VAR
  VAR
  //  tx : TIME;
  END_VAR
  VAR_EXTERNAL
    AT %SL52 : DWORD;
  END_VAR
  VAR_TEMP
    temp : DWORD;
  END_VAR

  //???tx := TIME();
  T_PLC_MS := %SL52;
  (* hier muss die korrektur für step7 stattfinden
  plctime muss den vollen wertebereich von time ausnutzen:
  wenn bei step7 time -24tage bis plus 24 tage ist dann muss der timer auch beim überlauf auf -24tage springen
  und auf keinen fall auf 0 !!!!
  für siemens muss ein weiterer fb im main eingebunden werden der sicherstellt das alle 32 bits durchgezählt werden.
  es kann nur ein fb sein den er muss sich das oberste (32te) bit merken.
  oder etwa spring s7 bei überlauf auf -24 tage????? dann wäre keine korrektur nötig.
  *)
  IF debug THEN
    //???  T_PLC_MS := (SHL(T_PLC_MS,N) OR SHL(DWORD#1,N)-1) + OFFSET;
    temp := UDINT_TO_DWORD( DWORD_TO_UDINT( SHL(DWORD#1,INT_TO_UINT(N))) -1);
    temp := temp OR SHL(%SL52,INT_TO_UINT(N));
    T_PLC_MS := UDINT_TO_DWORD( DWORD_TO_UDINT(temp) + DWORD_TO_UDINT(OFFSET));
  END_IF;

(* revision history
  hm  14.9.2007 rev 1.0
    original version

  hm  12. nov 2007  rev 1.1
    added temporaray variable tx because some compilers could not handle time() as an argument

  hm  16. nov. 2008 rev 1.2
    initialized constants with 0 for compatibility reasons
*)
END_FUNCTION


(* @PATH := '\/Engineering\/measurements' *)
FUNCTION T_PLC_US : DWORD
(*
  T_PLC_US reads the internal PLC timer and return the time, it has the advantage to be able to set a debug mode
  and speed up the counter to test the plc timer overrun which occurs every 50 days respectively 25 days at siemens S7
  this routine also allows to correct the behavior of s7 where the internal plc counter will not count all 32 bits.

  version 1.2 16 nov 2008
  programmer  hugo
  tested by tobias
*)
  VAR CONSTANT
    debug : BOOL := 0;
    N : INT := 0;
    offset : DWORD := 0;
  END_VAR
  VAR
  //  tx : TIME;
  END_VAR
  VAR_EXTERNAL
    AT %SL52 : DWORD;
  END_VAR
  VAR_TEMP
    temp : DWORD;
    temp_T_PLC_US : DWORD;
  END_VAR

  //???tx := TIME();
  //???T_PLC_US := TIME_TO_DWORD(Tx)*1000;
  T_PLC_US := UDINT_TO_DWORD(DWORD_TO_UDINT(%SL52)*1000);
  (* hier muss die korrektur für step7 stattfinden
  plctime muss den vollen wertebereich von time ausnutzen:
  wenn bei step7 time -24tage bis plus 24 tage ist dann muss der timer auch beim überlauf auf -24tage springen
  und auf keinen fall auf 0 !!!!
  für siemens muss ein weiterer fb im main eingebunden werden der sicherstellt das alle 32 bits durchgezählt werden.
  es kann nur ein fb sein den er muss sich das oberste (32te) bit merken.
  oder etwa spring s7 bei überlauf auf -24 tage????? dann wäre keine korrektur nötig.
  *)
  IF debug THEN
    //???T_PLC_US := (SHL(T_PLC_US,N) OR SHL(DWORD#1,N)-1) + OFFSET;
    temp_T_PLC_US := UDINT_TO_DWORD(DWORD_TO_UDINT(%SL52)*1000);
    temp := UDINT_TO_DWORD( DWORD_TO_UDINT( SHL(DWORD#1,INT_TO_UINT(N))) -1);
    temp := temp OR SHL(temp_T_PLC_US,INT_TO_UINT(N));
    T_PLC_US := UDINT_TO_DWORD( DWORD_TO_UDINT(temp) + DWORD_TO_UDINT(OFFSET));
  END_IF;

(* revision history
  hm  14.9.2007 rev 1.0
    original version

  hm  12. nov 2007  rev 1.1
    added temporaray variable tx because some compilers could not handle time() as an argument

  hm  16. nov. 2008 rev 1.2
    initialized constants with 0 for compatibility reasons
*)
END_FUNCTION


(* @PATH := '\/String' *)
FUNCTION TO_UPPER : BYTE
(*
  to_upper converts a character from lowercase to uppercase

  version 1.3 16. jan. 2009
  programmer  hugo
  tested by   oscat
*)
  VAR_INPUT
    IN : BYTE;
  END_VAR

  IF (in > 96) AND (in < 123) THEN
     TO_UPPER := in AND 16#DF;
  ELSIF (in > 223) AND (in <> 247) AND (in <> 255) AND setup.EXTENDED_ASCII THEN
     TO_UPPER := in AND 16#DF;
  ELSE
     TO_UPPER := in;
  END_IF;

(* revision history
  hm  6. mar. 2008  rev 1.0
    original version

  hm  19. oct. 2008 rev 1.1
    changed setup constants

  ks  25. oct. 2008 rev 1.2
    optimized code

  hm 16. jan 2009 rev 1.3
    corrected an error in module
  *)
END_FUNCTION

