(*
   ROOM_API_PILOT - d�tov� typy logick�ho API a prenosov�ho protokolu.
   Koment�re opisuj� v�znam pre PLC aj klienta; nejde o re�lnu domov� automatiz�ciu.
*)


TYPE
   NH_API_INFO : STRUCT
    	ApiVersion		: UINT;          (* Verzia verejn�ho API kontraktu. ENG *)
		ApiVarNext		: UINT;          (* Adresa v pam�ti PLC, kde sa nach�dza za�iatok �al��ch premenn�ch API. ENG *)
		ApiVarSize		: UDINT;          (* Ve�kos� v bajtoch, ktor� zaber� v pam�ti PLC. ENG *)		
		ApiBussy			: BOOL;          (* TRUE znamen�, �e PLC je zanepr�znene spracovan�m pr�kazu. ENG *)
   END_STRUCT

   NH_LOG_INFO : STRUCT
		BufferBegin		: UDINT;          (* Adresa v pam�ti PLC, kde sa nach�dza za�iatok logovacieho bufferu. ENG *)	
		BufferEnd		: UDINT;          (* Adresa v pamti PLC, kde sa nachdza zaiatok logovacieho bufferu. ENG *)	
		BufferNext		: UDINT;          (* Adresa v pamti PLC, kde sa nachdza zaiatokalch premennch API. ENG *)
		BufferSize		: UDINT;          (* Vekos v bajtoch, ktor zaber v pamti PLC. ENG *)		
   END_STRUCT

END_TYPE

TYPE
    NH_API_DIFF_HEAD : STRUCT                    (* Header pre diff udajov, Sizeof = 40B *)
        StructID        : UINT := 1;          		(* Cislo struktury zaslatych udajov - parser  *)	
        Name            : STRING[21] := 'T_ROOM_STATE';   (* What scheme used for parser. StructID = 1 = T_ROOM_STATE*)	
        Records         : INT := 2;          		(* Pocet zaslatych zaznamov T_ROOM_STATE *)
        RecSize         : UDINT := 21;      			(* Size of 1. T_ROOM_STATE*)		
        MessageSize     : UDINT := 42;      			(* Len Doplnujuce info Records * RecSize := 2*21=42B *)
        HeadIndex       : UINT := 0;						(* index tohto headera ApiVarsPublic[0], koniec ApiVarsPublic[0] + 40B = ApiVarsPublic[3] *)
        BeginIndex      : UINT := 4;          		(* kde zacinaju data struktury = 1.veta ApiVarsPublic[4] *)
        EndIndex        : UINT := 8;          		(* kde koncia data ApiVarsPublic[8] .. len informacne, lebo nemusi byt zaplnenychcelych 4B DWORD *)
	END_STRUCT

	T_ROOM_STATE : STRUCT
      RoomId          : UDINT; (* V?zba stavov?ho z?znamu na stabiln? ID v konfigur?cii. ENG *)
    	Temperature     : REAL;  (* Zobrazovan? testovacia teplota v stup?och Celzia. ENG *)
    	Humidity        : REAL;  (* Zobrazovan? testovacia relat?vna vlhkos? v percent?ch. ENG *)
    	Presence        : BOOL;  (* Testovac? pr?znak pr?tomnosti ovplyv?uj?ci pozadie karty. ENG *)
    	DayPhase        : UINT;  (* K?d dennej f?zy API_DAY_PHASE_* pre existuj?cu ikonu. ENG *)
    	CategoryMask    : DWORD; (* Bitov? maska kateg?ri?, ktor?ch ikony sa maj? zobrazi?. ENG *)
    	AlarmLevel      : USINT; (* Vizu?lna ?rove? API_ALARM_*; nesp???a re?lny alarm. ENG *)
    	Online          : BOOL;  (* Dostupnos? d?t miestnosti pre klienta. ENG *)
	END_STRUCT
END_TYPE
TYPE
   NH_API_DIFF_HEAD : STRUCT                    (* Header pre diff udajov, Sizeof = 40B *)  
		StructID		: UINT := 1;          		(* Cislo struktury zaslatych udajov - parser  *)	
		Name			: STRING[21] := 'T_ROOM_STATE';   (* What scheme used for parser. StructID = 1 = T_ROOM_STATE*)	
		Records			: INT := 2;          		(* Pocet zaslatych zaznamov T_ROOM_STATE *)
		RecSize			: UDINT := 21;      			(* Size of 1. T_ROOM_STATE*)		
		MessageSize		: UDINT := 42;      			(* Len Doplnujuce info Records * RecSize := 2*21=42B *)
         HeadIndex      : UINT := 0;						(* index tohto headera ApiVarsPublic[0], koniec ApiVarsPublic[0] + 40B = ApiVarsPublic[3] *)
		BeginIndex		: UINT := 4;          		(* kde zacinaju data struktury = 1.veta ApiVarsPublic[4] *)
		EndIndex		: UINT := 8;          		(* kde koncia data ApiVarsPublic[8] .. len informacne, lebo nemusi byt zaplnenychcelych 4B DWORD *)
	END_STRUCT

	T_ROOM_STATE : STRUCT
   	    RoomId          : UDINT; (* V�zba stavov�ho z�znamu na stabiln� ID v konfigur�cii. ENG *)
    	Temperature     : REAL;  (* Zobrazovan� testovacia teplota v stup�och Celzia. ENG *)
    	Humidity        : REAL;  (* Zobrazovan� testovacia relat�vna vlhkos� v percent�ch. ENG *)
    	Presence        : BOOL;  (* Testovac� pr�znak pr�tomnosti ovplyv�uj�ci pozadie karty. ENG *)
    	DayPhase        : UINT;  (* K�d dennej f�zy API_DAY_PHASE_* pre existuj�cu ikonu. ENG *)
    	CategoryMask    : DWORD; (* Bitov� maska kateg�ri�, ktor�ch ikony sa maj� zobrazi�. ENG *)
    	AlarmLevel      : USINT; (* Vizu�lna �rove� API_ALARM_*; nesp���a re�lny alarm. ENG *)
    	Online          : BOOL;  (* Dostupnos� d�t miestnosti pre klienta. ENG *)
	END_STRUCT
END_TYPE



(* V�sledok vykonania jedn�ho klientsk�ho pr�kazu. *)
TYPE
T_API_COMMAND_RESULT : STRUCT
    ClientId       : STRING[36]; (* Identifik�tor klienta, ktor�mu patr� v�sledok. ENG *)
    RequestId      : UDINT;      (* Identifik�tor po�iadavky pridelen� klientom. ENG *)
    Result         : USINT;      (* ��seln� n�vratov� k�d API_RESULT_*. ENG *)
    Message        : STRING[80]; (* Kr�tky slovensk� text v�sledku ur�en� pre log a testovanie. *)
    ConfigRevision : UDINT;      (* Rev�zia konfigur�cie platn� po spracovan� pr�kazu. ENG *)
    StateRevision  : UDINT;      (* Rev�zia stavov�ch �dajov platn� po spracovan� pr�kazu. ENG *)
END_STRUCT
END_TYPE

(* Z�kladn� inform�cie o API a jeho aktu�lnych rev�zi�ch. *)
TYPE T_API_INFO :
STRUCT
    ApiVersion        : STRING[32];          (* Verzia verejn�ho API kontraktu. ENG *)
    ConfigRevision    : UDINT;               (* Aktu�lna rev�zia konfigur�cie miestnost�. ENG *)
    StateRevision     : UDINT;               (* Aktu�lna rev�zia dynamick�ch stavov miestnost�. ENG *)
    MaxRooms          : USINT;               (* Najvy��� po�et miestnost� podporovan� PLC. ENG *)
    LastCommandResult : T_API_COMMAND_RESULT; (* Posledn� v�sledok pr�kazu, dostupn� aj po obnoven� klienta. ENG *)
END_STRUCT
END_TYPE

(* Konfigura�n� �daje jednej miestnosti. *)
TYPE T_ROOM_CONFIG :
STRUCT
    Used        : BOOL;       (* TRUE znamen�, �e je t�to poz�cia po�a obsaden� miestnos�ou. ENG *)
    RoomId      : UDINT;      (* Stabiln� a jedine�n� identifik�tor miestnosti; hodnota 0 je neplatn�. ENG *)
    Name        : STRING[64]; (* Hlavn� n�zov miestnosti zobrazen� na karte. ENG *)
    ProjectName : STRING[64]; (* Doplnkov� n�zov zobrazen� pod hlavn�m n�zvom. ENG *)
    IconId      : UINT;       (* Identifik�tor ikony pou��vanej frozen browserom. ENG *)
    SortDefault : UINT;       (* Predvolen� poradie iba pri prvom na��tan� klienta. ENG *)
END_STRUCT
END_TYPE

(* �pln� konfigura�n� snapshot v�etk�ch poz�ci� miestnost�. *)
TYPE T_API_CONFIG :
STRUCT
    Rooms : ARRAY[1..40] OF T_ROOM_CONFIG; (* Pevn� pole najviac 40 konfigura�n�ch z�znamov. ENG *)
END_STRUCT
END_TYPE

(* Ru�ne nastavovan� pilotn� stav jednej miestnosti. *)

(* �pln� stavov� snapshot v�etk�ch poz�ci� miestnost�. *)
TYPE T_API_STATE :
STRUCT
    Rooms : ARRAY[1..40] OF T_ROOM_STATE; (* Pevn� pole najviac 40 stavov�ch z�znamov. ENG *)
END_STRUCT
END_TYPE

(* Po�iadavka klienta na pridanie, zmazanie, kop�rovanie alebo �pravu miestnosti. *)
TYPE T_API_COMMAND_ROOM :
STRUCT
    ClientId     : STRING[36]; (* Identifik�tor klienta odosielaj�ceho pr�kaz. ENG *)
    RequestId    : UDINT;      (* Nenulov� identifik�tor po�iadavky pre p�rovanie a opakovanie. ENG *)
    Action       : USINT;      (* Po�adovan� akcia ur�en� kon�tantou API_ACTION_*. ENG *)
    RoomId       : UDINT;      (* Cie�ov� stabiln� ID miestnosti. ENG *)
    SourceRoomId : UDINT;      (* Zdrojov� ID pou�it� iba pri kop�rovan� miestnosti. ENG *)
    Name         : STRING[64]; (* Nov� alebo upraven� hlavn� n�zov miestnosti. ENG *)
    ProjectName  : STRING[64]; (* Nov� alebo upraven� doplnkov� n�zov miestnosti. ENG *)
END_STRUCT
END_TYPE

(* Jedna polo�ka konfigura�n�ho diffu. *)
TYPE T_API_CONFIG_CHANGE :
STRUCT
    Valid     : BOOL;          (* TRUE znamen�, �e polo�ka obsahuje platn� zmenu. ENG *)
    Operation : USINT;         (* Druh zmeny API_DIFF_UPSERT alebo API_DIFF_DELETE. ENG *)
    RoomId    : UDINT;         (* Stabiln� ID zmenenej alebo odstr�nenej miestnosti. ENG *)
    Room      : T_ROOM_CONFIG; (* �pln� nov� z�znam pri UPSERT; pri DELETE je vy�isten�. ENG *)
END_STRUCT
END_TYPE

(* Jedna polo�ka stavov�ho diffu. *)
TYPE T_API_STATE_CHANGE :
STRUCT
    Valid     : BOOL;         (* TRUE znamen�, �e polo�ka obsahuje platn� zmenu. ENG *)
    Operation : USINT;        (* Druh zmeny API_DIFF_UPSERT alebo API_DIFF_DELETE. ENG *)
    RoomId    : UDINT;        (* Stabiln� ID zmenen�ho alebo odstr�nen�ho stavu. ENG *)
    Room      : T_ROOM_STATE; (* �pln� nov� stav pri UPSERT; pri DELETE je vy�isten�. ENG *)
END_STRUCT
END_TYPE

(* Jeden rev�zny r�mec zmien konfigur�cie. *)
TYPE T_API_CONFIG_DIFF :
STRUCT
    Valid        : BOOL;  (* TRUE znamen�, �e hlavi�ka a obsah r�mca s� pripraven�. ENG *)
    FromRevision : UDINT; (* Rev�zia, na ktor� tento r�mec priamo nadv�zuje. ENG *)
    ToRevision   : UDINT; (* Rev�zia po aplikovan� v�etk�ch zmien z r�mca. ENG *)
    FullRequired : BOOL;  (* TRUE prikazuje klientovi na��ta� cel� snapshot. ENG *)
    ChangeCount  : USINT; (* Po�et platn�ch polo�iek na za�iatku po�a Changes. ENG *)
    Changes      : ARRAY[1..40] OF T_API_CONFIG_CHANGE; (* Zmeny konfigur�cie patriace do jednej rev�zie. ENG *)
END_STRUCT
END_TYPE

(* Jeden rev�zny r�mec zmien dynamick�ho stavu. *)
TYPE T_API_STATE_DIFF :
STRUCT
    Valid        : BOOL;  (* TRUE znamen�, �e hlavi�ka a obsah r�mca s� pripraven�. ENG *)
    FromRevision : UDINT; (* Rev�zia, na ktor� tento r�mec priamo nadv�zuje. ENG *)
    ToRevision   : UDINT; (* Rev�zia po aplikovan� v�etk�ch zmien z r�mca. ENG *)
    FullRequired : BOOL;  (* TRUE prikazuje klientovi na��ta� cel� snapshot. ENG *)
    ChangeCount  : USINT; (* Po�et platn�ch polo�iek na za�iatku po�a Changes. ENG *)
    Changes      : ARRAY[1..40] OF T_API_STATE_CHANGE; (* Stavov� zmeny patriace do jednej rev�zie. ENG *)
END_STRUCT
END_TYPE

(* Po�iadavka transportn�ho handshake na z�skanie �al�ieho uchovan�ho diffu. ENG *)
TYPE T_API_SYNC_REQUEST :
STRUCT
    ClientId           : STRING[36]; (* Identifik�tor klienta �iadaj�ceho synchroniz�ciu. ENG *)
    RequestId          : UDINT;      (* Nenulov� identifik�tor synchroniza�nej po�iadavky. ENG *)
    ConfigFromRevision : UDINT;      (* Posledn� konfigura�n� rev�zia �spe�ne ulo�en� klientom. ENG *)
    StateFromRevision  : UDINT;      (* Posledn� stavov� rev�zia �spe�ne ulo�en� klientom. ENG *)
END_STRUCT
END_TYPE

(* Odpove� PLC na jednu synchroniza�n� po�iadavku. *)
TYPE T_API_SYNC_RESPONSE :
STRUCT
    ClientId   : STRING[36];       (* Identifik�tor klienta prevzat� z po�iadavky. ENG *)
    RequestId  : UDINT;            (* Identifik�tor po�iadavky prevzat� z po�iadavky. ENG *)
    Result     : USINT;            (* Celkov� n�vratov� k�d synchroniz�cie API_RESULT_*. ENG *)
    Message    : STRING[80];       (* Kr�tky slovensk� opis v�sledku pre log a testovanie. *)
    ConfigMode : USINT;            (* Re�im konfigura�nej odpovede API_SYNC_*. ENG *)
    StateMode  : USINT;            (* Re�im stavovej odpovede API_SYNC_*. ENG *)
    ConfigDiff : T_API_CONFIG_DIFF; (* �al�� konfigura�n� r�mec alebo po�iadavka na cel� snapshot. ENG *)
    StateDiff  : T_API_STATE_DIFF; (* �al�� stavov� r�mec alebo po�iadavka na cel� snapshot. ENG *)
END_STRUCT
END_TYPE

(* Ru�n� testovac� vstup oddelen� od produk�n�ho pr�kazu ApiCommandRoom. *)
TYPE T_API_TEST_STATE_REQUEST :
STRUCT
    ClientId     : STRING[36]; (* Identifik�tor testovacieho klienta. ENG *)
    RequestId    : UDINT;      (* Nenulov� identifik�tor testovacej po�iadavky. ENG *)
    RoomId       : UDINT;      (* Stabiln� ID miestnosti, ktorej stav sa m� zmeni�. ENG *)
    Temperature  : REAL;       (* Po�adovan� testovacia teplota od -50 do 100 �C. ENG *)
    Humidity     : REAL;       (* Po�adovan� testovacia vlhkos� od 0 do 100 %. ENG *)
    Presence     : BOOL;       (* Po�adovan� testovac� pr�znak pr�tomnosti. ENG *)
    DayPhase     : UINT;       (* Po�adovan� platn� denn� f�za API_DAY_PHASE_*. ENG *)
    CategoryMask : DWORD;      (* Po�adovan� bitov� maska kateg�ri�. ENG *)
    AlarmLevel   : USINT;      (* Po�adovan� vizu�lna �rove� API_ALARM_*. ENG *)
    Online       : BOOL;       (* Po�adovan� testovacia dostupnos� d�t. ENG *)
END_STRUCT
END_TYPE
