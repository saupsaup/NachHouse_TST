(* Fixed GETMEM test layout. All offsets are byte offsets from %R10000.

   0..3    ASCII "GMEM"
   4       format version = 1
   5       header size = 16
   6..7    payload size = 984, little-endian
   8..11   frame revision, little-endian
   12      pattern seed
   13..15  reserved, zero
   16..999 deterministic payload
*)

VAR_GLOBAL
    (* Raw memory read by: GETMEM:%R10000 1000 *)
    GetMemBuffer AT %R1000 : ARRAY[0..999] OF BYTE;

    (* Small public control/status surface. *)
    GetMemAddress     {PUBLIC_API} : STRING[16] := '%R1000';
    GetMemReadCommand {PUBLIC_API} : STRING[64] := 'GETMEM:%R1000 1000';
    GetMemLength      {PUBLIC_API} : UINT := 1000;
    GetMemRevision    {PUBLIC_API} : UDINT := 0;
    GetMemReady       {PUBLIC_API} : BOOL := FALSE;
    GetMemExecute     {PUBLIC_API} : BOOL := FALSE;
    GetMemSeed        {PUBLIC_API} : USINT := 0;

    GetMemInitialized : BOOL := FALSE;
END_VAR

FUNCTION GetMemBuildFrame : BOOL
VAR_INPUT
    Revision : UDINT;
    Seed     : USINT;
END_VAR
VAR
    i : UINT;
END_VAR

(* Fill the complete block first. *)
FOR i := 0 TO 999 DO
    GetMemBuffer[i] := UINT_TO_BYTE(i MOD 256) XOR USINT_TO_BYTE(Seed);
END_FOR;

(* Overwrite the first 16 bytes with a stable, easy-to-recognize header. *)
GetMemBuffer[0] := BYTE#16#47; (* G *)
GetMemBuffer[1] := BYTE#16#4D; (* M *)
GetMemBuffer[2] := BYTE#16#45; (* E *)
GetMemBuffer[3] := BYTE#16#4D; (* M *)
GetMemBuffer[4] := BYTE#1;
GetMemBuffer[5] := BYTE#16;
GetMemBuffer[6] := BYTE#16#D8; (* 984 = 16#03D8 *)
GetMemBuffer[7] := BYTE#16#03;
GetMemBuffer[8] := UDINT_TO_BYTE(Revision);
GetMemBuffer[9] := UDINT_TO_BYTE(SHR(Revision, 8));
GetMemBuffer[10] := UDINT_TO_BYTE(SHR(Revision, 16));
GetMemBuffer[11] := UDINT_TO_BYTE(SHR(Revision, 24));
GetMemBuffer[12] := USINT_TO_BYTE(Seed);
GetMemBuffer[13] := BYTE#0;
GetMemBuffer[14] := BYTE#0;
GetMemBuffer[15] := BYTE#0;

GetMemBuildFrame := TRUE;
END_FUNCTION
