PROGRAM prgMain
  VAR
    DepStarted  : BOOL := FALSE;
    DepAccepted     : BOOL;
  END_VAR


  IF NOT DepStarted THEN
    DepRq := FALSE;  // Na začiatku zruší požiadavku, aby sa nespustilo nechcené nahratie programu. ; Clear the request initially to avoid an unintended deployment.
    DepRes := 0;
    DepStarted := TRUE;
  ELSIF DepRq THEN
    DepRq := FALSE;  // Prijatú požiadavku zruší pred načítaním balíka. ; Clear the accepted request before loading the package.
    DepAccepted := LoadNewPackage2(rq := TRUE, pckg := '//WWW/UPLOAD/NEW_PACK.TTR');  // Požiada PLC o načítanie balíka zo zadaného súboru. ; Ask the PLC to load the package from the specified file.
    // Vráti stav prijatia balíka. ; Return the package-accepted status.
    IF DepAccepted THEN DepRes := 1;
    ELSE DepRes := 3;
    END_IF;
  END_IF;

END_PROGRAM
