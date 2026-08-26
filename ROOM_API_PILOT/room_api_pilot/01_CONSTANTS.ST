(*
   ROOM_API_PILOT - verejnı èíselnı kontrakt a pevné limity pilotu.
   Èíselné hodnoty sú súèasou API; klient ich nesmie svojvo¾ne meni.
*)

VAR_GLOBAL CONSTANT
    C_API_VERSION          : STRING[32] := 'ROOM_API_PILOT/1'; (* Textová verzia verejného API kontraktu. ENG *)
    C_MAX_ROOMS            : USINT := 40;                     (* Najvyšší poèet miestností podporovanı pilotom. *)
    C_DIFF_HISTORY_DEPTH   : USINT := 8;                      (* Poèet uchovávanıch rámcov zmien v kruhovej histórii. *)

    (* Èíselné kódy akcií po¾a Action v príkaze miestnosti. *)
    API_ACTION_NONE          : USINT := 0; (* Nie je zvolená iadna akcia. ENG *)
    API_ACTION_ADD_ROOM      : USINT := 1; (* Pridanie novej miestnosti. ENG *)
    API_ACTION_DELETE_ROOM   : USINT := 2; (* Odstránenie existujúcej miestnosti. ENG *)
    API_ACTION_COPY_ROOM     : USINT := 3; (* Vytvorenie kópie existujúcej miestnosti. ENG *)
    API_ACTION_SET_ROOM_DATA : USINT := 4; (* Zmena názvovıch údajov miestnosti. ENG *)

    (* Èíselné návratové kódy po¾a Result. *)
    API_RESULT_NONE               : USINT := 0; (* Vısledok ešte nie je k dispozícii. ENG *)
    API_RESULT_OK                 : USINT := 1; (* Operácia prebehla úspešne. ENG *)
    API_RESULT_ERROR              : USINT := 2; (* Všeobecná, blišie neurèená chyba. ENG *)
    API_RESULT_NOT_FOUND          : USINT := 3; (* Poadovanı objekt sa nenašiel. ENG *)
    API_RESULT_NO_FREE_SLOT       : USINT := 4; (* Nie je vo¾ná pozícia pre ïalšiu miestnos. ENG *)
    API_RESULT_ALREADY_EXISTS     : USINT := 5; (* Objekt s rovnakım identifikátorom u existuje. ENG *)
    API_RESULT_INVALID_ARGUMENT   : USINT := 6; (* Aspoò jeden vstupnı údaj je neplatnı. ENG *)
    API_RESULT_UNSUPPORTED_ACTION : USINT := 7; (* Klient poaduje nepodporovanú akciu. ENG *)

    (* Druh operácie zapísanej v jednom zázname diffu. *)
    API_DIFF_NONE   : USINT := 0; (* Záznam neobsahuje zmenu. ENG *)
    API_DIFF_UPSERT : USINT := 1; (* Vloenie nového alebo úplná aktualizácia existujúceho záznamu. ENG *)
    API_DIFF_DELETE : USINT := 2; (* Odstránenie záznamu. ENG *)

    (* Reim odpovede synchronizaèného mechanizmu. *)
    API_SYNC_CURRENT       : USINT := 0; (* Cache klienta u zodpovedá aktuálnej revízii. ENG *)
    API_SYNC_DIFF          : USINT := 1; (* Odpoveï obsahuje jeden nadväzujúci rámec zmien. ENG *)
    API_SYNC_FULL_REQUIRED : USINT := 2; (* História nestaèí a klient musí naèíta celı snapshot. ENG *)

    (* Vizuálna úroveò alarmu zobrazovaná na karte miestnosti. *)
    API_ALARM_OK      : USINT := 0; (* Bez upozornenia alebo alarmu. ENG *)
    API_ALARM_WARNING : USINT := 1; (* Upozornenie. ENG *)
    API_ALARM_ALARM   : USINT := 2; (* Alarm. ENG *)

    (* Identifikátory existujúcich ikon dennej fázy vo frozen browseri V0.5.72. *)
    API_DAY_PHASE_DAY   : UINT := 140; (* Denná fáza. ENG *)
    API_DAY_PHASE_DUSK  : UINT := 142; (* Súmrak. ENG *)
    API_DAY_PHASE_NIGHT : UINT := 144; (* Noèná fáza. ENG *)
    API_DAY_PHASE_DAWN  : UINT := 146; (* Úsvit. ENG *)

    (* Predvolené testovacie hodnoty pouité pri pridaní miestnosti. *)
    API_DEFAULT_ICON_ID     : UINT := 16;   (* Predvolenı identifikátor ikony miestnosti. *)
    API_DEFAULT_TEMPERATURE : REAL := 20.0; (* Predvolená teplota v stupòoch Celzia. *)
    API_DEFAULT_HUMIDITY    : REAL := 40.0; (* Predvolená relatívna vlhkos v percentách. *)
END_VAR
