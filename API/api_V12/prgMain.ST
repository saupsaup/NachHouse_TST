// Hlavnı cyklickı program: inicializácia, schéma, export, blokovı príjem a import ; Main cyclic program: initialization, schema, export, block receive, and import.
PROGRAM prgMain
  VAR
    DepStarted  : BOOL := FALSE;  // Urèuje, èi sa vykonal úvodnı reset poiadavky na balík ; Tracks whether the initial package-request reset has run.
    DepAccepted : BOOL;           // Pracovnı vısledok prijatia balíka PLC ; Temporary result of PLC package acceptance.
  END_VAR

  InitData();  // Musí by prvé: testovacie dáta a mRam sa inicializujú pred ostatnımi cyklami. ; Keep this first: test data and mRam must be initialized before the other cycles.
  SchInit();  // Overí tabu¾ku schémy oproti typom a rozloeniu pamäte ; Validate the schema table against types and memory layout.
  TxCycle();  // Obslúi prípadnú poiadavku klienta na export JSON ; Process a client request to export JSON.
  RbCycle();  // Spracuje novı prijatı blok a prípadne doplní rx.json ; Process a new received block and append it to rx.json.
  RxCycle();  // Spracuje poiadavku na prevod rx.json do mRam ; Process a request to convert rx.json into mRam.

  IF NOT DepStarted THEN
    DepRq := FALSE;  // Poèiatoène zruší poiadavku, aby sa nespustil nechcenı deploy ; Clear the request initially to avoid an unintended deployment.
    DepRes := 0;
    DepStarted := TRUE;
  ELSIF DepRq THEN
    DepRq := FALSE;  // Zruší prijatú poiadavku pred naèítaním balíka ; Clear the accepted request before loading the package.
    DepAccepted := LoadNewPackage2(rq := TRUE, pckg := '//WWW/UPLOAD/NEW_PACK.TTR');  // Poiada PLC o naèítanie balíka z urèeného súboru ; Ask the PLC to load the package from the specified file.
    // Vráti stav úspešného prijatia balíka ; Return the package-accepted status.
    IF DepAccepted THEN DepRes := 1;
    ELSE DepRes := 3;
    END_IF;
  END_IF;
END_PROGRAM
