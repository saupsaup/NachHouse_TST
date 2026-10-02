PROGRAM prgMain
VAR
    nextRevision : UDINT;
    nextSeed     : USINT;
END_VAR

(* Build a known first frame after program start. *)
IF NOT GetMemInitialized THEN
    GetMemReady := FALSE;
    GetMemBuildFrame(Revision := 1, Seed := 0);
    GetMemSeed := 0;
    GetMemRevision := 1; (* Commit is published only after the buffer is complete. *)
    GetMemReady := TRUE;
    GetMemInitialized := TRUE;
END_IF;

(* A SET of GetMemExecute=TRUE creates a visibly different test frame. *)
IF GetMemExecute THEN
    GetMemReady := FALSE;
    nextRevision := GetMemRevision + 1;
    nextSeed := GetMemSeed + 1;
    GetMemBuildFrame(Revision := nextRevision, Seed := nextSeed);
    GetMemSeed := nextSeed;
    GetMemRevision := nextRevision; (* Commit last. *)
    GetMemReady := TRUE;
    GetMemExecute := FALSE;
END_IF;
END_PROGRAM
