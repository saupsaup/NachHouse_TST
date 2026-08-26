(*
   ROOM_API_PILOT - dátové typy logického API a prenosového protokolu.
   Komentáre opisujú vıznam pre PLC aj klienta; nejde o reálnu domovú automatizáciu.
*)

(* Vısledok vykonania jedného klientského príkazu. *)
TYPE T_API_COMMAND_RESULT :
STRUCT
    ClientId       : STRING[36]; (* Identifikátor klienta, ktorému patrí vısledok. ENG *)
    RequestId      : UDINT;      (* Identifikátor poiadavky pridelenı klientom. ENG *)
    Result         : USINT;      (* Èíselnı návratovı kód API_RESULT_*. ENG *)
    Message        : STRING[80]; (* Krátky slovenskı text vısledku urèenı pre log a testovanie. *)
    ConfigRevision : UDINT;      (* Revízia konfigurácie platná po spracovaní príkazu. ENG *)
    StateRevision  : UDINT;      (* Revízia stavovıch údajov platná po spracovaní príkazu. ENG *)
END_STRUCT
END_TYPE

(* Základné informácie o API a jeho aktuálnych revíziách. *)
TYPE T_API_INFO :
STRUCT
    ApiVersion        : STRING[32];          (* Verzia verejného API kontraktu. ENG *)
    ConfigRevision    : UDINT;               (* Aktuálna revízia konfigurácie miestností. ENG *)
    StateRevision     : UDINT;               (* Aktuálna revízia dynamickıch stavov miestností. ENG *)
    MaxRooms          : USINT;               (* Najvyšší poèet miestností podporovanı PLC. ENG *)
    LastCommandResult : T_API_COMMAND_RESULT; (* Poslednı vısledok príkazu, dostupnı aj po obnovení klienta. ENG *)
END_STRUCT
END_TYPE

(* Konfiguraèné údaje jednej miestnosti. *)
TYPE T_ROOM_CONFIG :
STRUCT
    Used        : BOOL;       (* TRUE znamená, e je táto pozícia po¾a obsadená miestnosou. ENG *)
    RoomId      : UDINT;      (* Stabilnı a jedineènı identifikátor miestnosti; hodnota 0 je neplatná. ENG *)
    Name        : STRING[64]; (* Hlavnı názov miestnosti zobrazenı na karte. ENG *)
    ProjectName : STRING[64]; (* Doplnkovı názov zobrazenı pod hlavnım názvom. ENG *)
    IconId      : UINT;       (* Identifikátor ikony pouívanej frozen browserom. ENG *)
    SortDefault : UINT;       (* Predvolené poradie iba pri prvom naèítaní klienta. ENG *)
END_STRUCT
END_TYPE

(* Úplnı konfiguraènı snapshot všetkıch pozícií miestností. *)
TYPE T_API_CONFIG :
STRUCT
    Rooms : ARRAY[1..40] OF T_ROOM_CONFIG; (* Pevné pole najviac 40 konfiguraènıch záznamov. ENG *)
END_STRUCT
END_TYPE

(* Ruène nastavovanı pilotnı stav jednej miestnosti. *)
TYPE T_ROOM_STATE :
STRUCT
    RoomId       : UDINT; (* Väzba stavového záznamu na stabilné ID v konfigurácii. ENG *)
    Temperature  : REAL;  (* Zobrazovaná testovacia teplota v stupòoch Celzia. ENG *)
    Humidity     : REAL;  (* Zobrazovaná testovacia relatívna vlhkos v percentách. ENG *)
    Presence     : BOOL;  (* Testovací príznak prítomnosti ovplyvòujúci pozadie karty. ENG *)
    DayPhase     : UINT;  (* Kód dennej fázy API_DAY_PHASE_* pre existujúcu ikonu. ENG *)
    CategoryMask : DWORD; (* Bitová maska kategórií, ktorıch ikony sa majú zobrazi. ENG *)
    AlarmLevel   : USINT; (* Vizuálna úroveò API_ALARM_*; nespúša reálny alarm. ENG *)
    Online       : BOOL;  (* Dostupnos dát miestnosti pre klienta. ENG *)
END_STRUCT
END_TYPE

(* Úplnı stavovı snapshot všetkıch pozícií miestností. *)
TYPE T_API_STATE :
STRUCT
    Rooms : ARRAY[1..40] OF T_ROOM_STATE; (* Pevné pole najviac 40 stavovıch záznamov. ENG *)
END_STRUCT
END_TYPE

(* Poiadavka klienta na pridanie, zmazanie, kopírovanie alebo úpravu miestnosti. *)
TYPE T_API_COMMAND_ROOM :
STRUCT
    ClientId     : STRING[36]; (* Identifikátor klienta odosielajúceho príkaz. ENG *)
    RequestId    : UDINT;      (* Nenulovı identifikátor poiadavky pre párovanie a opakovanie. ENG *)
    Action       : USINT;      (* Poadovaná akcia urèená konštantou API_ACTION_*. ENG *)
    RoomId       : UDINT;      (* Cie¾ové stabilné ID miestnosti. ENG *)
    SourceRoomId : UDINT;      (* Zdrojové ID pouité iba pri kopírovaní miestnosti. ENG *)
    Name         : STRING[64]; (* Novı alebo upravenı hlavnı názov miestnosti. ENG *)
    ProjectName  : STRING[64]; (* Novı alebo upravenı doplnkovı názov miestnosti. ENG *)
END_STRUCT
END_TYPE

(* Jedna poloka konfiguraèného diffu. *)
TYPE T_API_CONFIG_CHANGE :
STRUCT
    Valid     : BOOL;          (* TRUE znamená, e poloka obsahuje platnú zmenu. ENG *)
    Operation : USINT;         (* Druh zmeny API_DIFF_UPSERT alebo API_DIFF_DELETE. ENG *)
    RoomId    : UDINT;         (* Stabilné ID zmenenej alebo odstránenej miestnosti. ENG *)
    Room      : T_ROOM_CONFIG; (* Úplnı novı záznam pri UPSERT; pri DELETE je vyèistenı. ENG *)
END_STRUCT
END_TYPE

(* Jedna poloka stavového diffu. *)
TYPE T_API_STATE_CHANGE :
STRUCT
    Valid     : BOOL;         (* TRUE znamená, e poloka obsahuje platnú zmenu. ENG *)
    Operation : USINT;        (* Druh zmeny API_DIFF_UPSERT alebo API_DIFF_DELETE. ENG *)
    RoomId    : UDINT;        (* Stabilné ID zmeneného alebo odstráneného stavu. ENG *)
    Room      : T_ROOM_STATE; (* Úplnı novı stav pri UPSERT; pri DELETE je vyèistenı. ENG *)
END_STRUCT
END_TYPE

(* Jeden revízny rámec zmien konfigurácie. *)
TYPE T_API_CONFIG_DIFF :
STRUCT
    Valid        : BOOL;  (* TRUE znamená, e hlavièka a obsah rámca sú pripravené. ENG *)
    FromRevision : UDINT; (* Revízia, na ktorú tento rámec priamo nadväzuje. ENG *)
    ToRevision   : UDINT; (* Revízia po aplikovaní všetkıch zmien z rámca. ENG *)
    FullRequired : BOOL;  (* TRUE prikazuje klientovi naèíta celı snapshot. ENG *)
    ChangeCount  : USINT; (* Poèet platnıch poloiek na zaèiatku po¾a Changes. ENG *)
    Changes      : ARRAY[1..40] OF T_API_CONFIG_CHANGE; (* Zmeny konfigurácie patriace do jednej revízie. ENG *)
END_STRUCT
END_TYPE

(* Jeden revízny rámec zmien dynamického stavu. *)
TYPE T_API_STATE_DIFF :
STRUCT
    Valid        : BOOL;  (* TRUE znamená, e hlavièka a obsah rámca sú pripravené. ENG *)
    FromRevision : UDINT; (* Revízia, na ktorú tento rámec priamo nadväzuje. ENG *)
    ToRevision   : UDINT; (* Revízia po aplikovaní všetkıch zmien z rámca. ENG *)
    FullRequired : BOOL;  (* TRUE prikazuje klientovi naèíta celı snapshot. ENG *)
    ChangeCount  : USINT; (* Poèet platnıch poloiek na zaèiatku po¾a Changes. ENG *)
    Changes      : ARRAY[1..40] OF T_API_STATE_CHANGE; (* Stavové zmeny patriace do jednej revízie. ENG *)
END_STRUCT
END_TYPE

(* Poiadavka transportného handshake na získanie ïalšieho uchovaného diffu. ENG *)
TYPE T_API_SYNC_REQUEST :
STRUCT
    ClientId           : STRING[36]; (* Identifikátor klienta iadajúceho synchronizáciu. ENG *)
    RequestId          : UDINT;      (* Nenulovı identifikátor synchronizaènej poiadavky. ENG *)
    ConfigFromRevision : UDINT;      (* Posledná konfiguraèná revízia úspešne uloená klientom. ENG *)
    StateFromRevision  : UDINT;      (* Posledná stavová revízia úspešne uloená klientom. ENG *)
END_STRUCT
END_TYPE

(* Odpoveï PLC na jednu synchronizaènú poiadavku. *)
TYPE T_API_SYNC_RESPONSE :
STRUCT
    ClientId   : STRING[36];       (* Identifikátor klienta prevzatı z poiadavky. ENG *)
    RequestId  : UDINT;            (* Identifikátor poiadavky prevzatı z poiadavky. ENG *)
    Result     : USINT;            (* Celkovı návratovı kód synchronizácie API_RESULT_*. ENG *)
    Message    : STRING[80];       (* Krátky slovenskı opis vısledku pre log a testovanie. *)
    ConfigMode : USINT;            (* Reim konfiguraènej odpovede API_SYNC_*. ENG *)
    StateMode  : USINT;            (* Reim stavovej odpovede API_SYNC_*. ENG *)
    ConfigDiff : T_API_CONFIG_DIFF; (* Ïalší konfiguraènı rámec alebo poiadavka na celı snapshot. ENG *)
    StateDiff  : T_API_STATE_DIFF; (* Ïalší stavovı rámec alebo poiadavka na celı snapshot. ENG *)
END_STRUCT
END_TYPE

(* Ruènı testovací vstup oddelenı od produkèného príkazu ApiCommandRoom. *)
TYPE T_API_TEST_STATE_REQUEST :
STRUCT
    ClientId     : STRING[36]; (* Identifikátor testovacieho klienta. ENG *)
    RequestId    : UDINT;      (* Nenulovı identifikátor testovacej poiadavky. ENG *)
    RoomId       : UDINT;      (* Stabilné ID miestnosti, ktorej stav sa má zmeni. ENG *)
    Temperature  : REAL;       (* Poadovaná testovacia teplota od -50 do 100 °C. ENG *)
    Humidity     : REAL;       (* Poadovaná testovacia vlhkos od 0 do 100 %. ENG *)
    Presence     : BOOL;       (* Poadovanı testovací príznak prítomnosti. ENG *)
    DayPhase     : UINT;       (* Poadovaná platná denná fáza API_DAY_PHASE_*. ENG *)
    CategoryMask : DWORD;      (* Poadovaná bitová maska kategórií. ENG *)
    AlarmLevel   : USINT;      (* Poadovaná vizuálna úroveò API_ALARM_*. ENG *)
    Online       : BOOL;       (* Poadovaná testovacia dostupnos dát. ENG *)
END_STRUCT
END_TYPE
