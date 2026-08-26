(*
   Všetky objekty vidite¾né klientom sú globálne a oznaèené atribútom PUBLIC_API.
   Klient musí najprv zapísa celı obsah poiadavky a príznak Execute a ako poslednı.
   Snapshoty ApiConfig a ApiState sú pod¾a kontraktu urèené iba na èítanie.
   Názvy verejnıch objektov tvoria stabilnı anglickı API kontrakt. ENG
*)

VAR_GLOBAL
    ApiInfo       {PUBLIC_API} : T_API_INFO;   (* Informácie o verzii, revíziách, limite a poslednom príkaze. ENG *)
    ApiConfig     {PUBLIC_API} : T_API_CONFIG; (* Úplnı konfiguraènı snapshot urèenı klientovi iba na èítanie. ENG *)
    ApiState      {PUBLIC_API} : T_API_STATE;  (* Úplnı stavovı snapshot urèenı klientovi iba na èítanie. ENG *)

    ApiConfigDiff {PUBLIC_API} : T_API_CONFIG_DIFF; (* Najnovší vytvorenı rámec zmien konfigurácie. ENG *)
    ApiStateDiff  {PUBLIC_API} : T_API_STATE_DIFF;  (* Najnovší vytvorenı rámec zmien stavu. ENG *)

    (* Dvojfázovı kanál príkazov miestnosti: payload, Execute, spracovanie, Finished. ENG *)
    ApiCommandRoom     {PUBLIC_API} : T_API_COMMAND_ROOM;  (* Obsah poiadavky zapisovanı klientom. ENG *)
    ApiCommandExecute  {PUBLIC_API} : BOOL;                (* Spúšací príznak; klient ho zapisuje ako poslednı. ENG *)
    ApiCommandBusy     {PUBLIC_API} : BOOL;                (* TRUE poèas spracovania príkazu v PLC. ENG *)
    ApiCommandFinished {PUBLIC_API} : BOOL;                (* TRUE po dokonèení; klient môe preèíta vısledok. ENG *)
    ApiCommandResult   {PUBLIC_API} : T_API_COMMAND_RESULT; (* Vısledok práve dokonèeného alebo zopakovaného príkazu. ENG *)

    (* Dvojfázovı kanál obnovy cache a naèítania jedného nadväzujúceho diffu. ENG *)
    ApiSyncRequest  {PUBLIC_API} : T_API_SYNC_REQUEST;  (* Revízie, od ktorıch chce klient pokraèova. ENG *)
    ApiSyncExecute  {PUBLIC_API} : BOOL;                (* Spúšací príznak synchronizácie zapisovanı ako poslednı. ENG *)
    ApiSyncBusy     {PUBLIC_API} : BOOL;                (* TRUE poèas prípravy synchronizaènej odpovede. ENG *)
    ApiSyncFinished {PUBLIC_API} : BOOL;                (* TRUE po pripravení odpovede pre klienta. ENG *)
    ApiSyncResponse {PUBLIC_API} : T_API_SYNC_RESPONSE; (* Vısledné reimy a najviac jeden diff kadej vetvy. ENG *)

    (* Samostatnı kanál ruèného nastavovania pilotnıch stavov bez reálneho IO. *)
    ApiTestStateRequest  {PUBLIC_API} : T_API_TEST_STATE_REQUEST; (* Testovacie stavové hodnoty zapisované klientom. ENG *)
    ApiTestStateExecute  {PUBLIC_API} : BOOL;                     (* Spúšací príznak testovacieho zápisu. ENG *)
    ApiTestStateBusy     {PUBLIC_API} : BOOL;                     (* TRUE poèas validácie a zápisu testovacieho stavu. ENG *)
    ApiTestStateFinished {PUBLIC_API} : BOOL;                     (* TRUE po dokonèení testovacieho zápisu. ENG *)
    ApiTestStateResult   {PUBLIC_API} : T_API_COMMAND_RESULT;     (* Vısledok posledného testovacieho zápisu. ENG *)
END_VAR
