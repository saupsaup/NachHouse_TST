(*
   V�etky objekty vidite�n� klientom s� glob�lne a ozna�en� atrib�tom PUBLIC_API.
   Klient mus� najprv zap�sa� cel� obsah po�iadavky a pr�znak Execute a� ako posledn�.
   Snapshoty ApiConfig a ApiState s� pod�a kontraktu ur�en� iba na ��tanie.
   N�zvy verejn�ch objektov tvoria stabiln� anglick� API kontrakt. ENG
*)

VAR_GLOBAL
    ApiInfo       {PUBLIC_API} : T_API_INFO;   (* Inform�cie o verzii, rev�zi�ch, limite a poslednom pr�kaze. ENG *)
    ApiConfig     {PUBLIC_API} : T_API_CONFIG; (* �pln� konfigura�n� snapshot ur�en� klientovi iba na ��tanie. ENG *)
    ApiState      {PUBLIC_API} : T_API_STATE;  (* �pln� stavov� snapshot ur�en� klientovi iba na ��tanie. ENG *)

    ApiConfigDiff {PUBLIC_API} : T_API_CONFIG_DIFF; (* Najnov�� vytvoren� r�mec zmien konfigur�cie. ENG *)
    ApiStateDiff  {PUBLIC_API} : T_API_STATE_DIFF;  (* Najnov�� vytvoren� r�mec zmien stavu. ENG *)

    (* Dvojf�zov� kan�l pr�kazov miestnosti: payload, Execute, spracovanie, Finished. ENG *)
    ApiCommandRoom     {PUBLIC_API} : T_API_COMMAND_ROOM;  (* Obsah po�iadavky zapisovan� klientom. ENG *)
    ApiCommandExecute  {PUBLIC_API} : BOOL;                (* Sp���ac� pr�znak; klient ho zapisuje ako posledn�. ENG *)
    ApiCommandBusy     {PUBLIC_API} : BOOL;                (* TRUE po�as spracovania pr�kazu v PLC. ENG *)
    ApiCommandFinished {PUBLIC_API} : BOOL;                (* TRUE po dokon�en�; klient m��e pre��ta� v�sledok. ENG *)
    ApiCommandResult   {PUBLIC_API} : T_API_COMMAND_RESULT; (* V�sledok pr�ve dokon�en�ho alebo zopakovan�ho pr�kazu. ENG *)

    (* Dvojf�zov� kan�l obnovy cache a na��tania jedn�ho nadv�zuj�ceho diffu. ENG *)
    ApiSyncRequest  {PUBLIC_API} : T_API_SYNC_REQUEST;  (* Rev�zie, od ktor�ch chce klient pokra�ova�. ENG *)
    ApiSyncExecute  {PUBLIC_API} : BOOL;                (* Sp���ac� pr�znak synchroniz�cie zapisovan� ako posledn�. ENG *)
    ApiSyncBusy     {PUBLIC_API} : BOOL;                (* TRUE po�as pr�pravy synchroniza�nej odpovede. ENG *)
    ApiSyncFinished {PUBLIC_API} : BOOL;                (* TRUE po pripraven� odpovede pre klienta. ENG *)
    ApiSyncResponse {PUBLIC_API} : T_API_SYNC_RESPONSE; (* V�sledn� re�imy a najviac jeden diff ka�dej vetvy. ENG *)

    (* Samostatn� kan�l ru�n�ho nastavovania pilotn�ch stavov bez re�lneho IO. *)
    ApiTestStateRequest  {PUBLIC_API} : T_API_TEST_STATE_REQUEST; (* Testovacie stavov� hodnoty zapisovan� klientom. ENG *)
    ApiTestStateExecute  {PUBLIC_API} : BOOL;                     (* Sp���ac� pr�znak testovacieho z�pisu. ENG *)
    ApiTestStateBusy     {PUBLIC_API} : BOOL;                     (* TRUE po�as valid�cie a z�pisu testovacieho stavu. ENG *)
    ApiTestStateFinished {PUBLIC_API} : BOOL;                     (* TRUE po dokon�en� testovacieho z�pisu. ENG *)
    ApiTestStateResult   {PUBLIC_API} : T_API_COMMAND_RESULT;     (* V�sledok posledn�ho testovacieho z�pisu. ENG *)

	ApiVarsPublic 	{PUBLIC_API} : ARRAY[0..999] OF DWORD; (* Jedina komunikacna oblast binarnychch Vars, ktoru naplna PLC zmenami*)
	
	SizeApiHeder 	: UDINT;	
	SizeStructRoom	: UDINT;
	SizeApiVars	: UDINT;
	
	Ptr_T_ROOM_STATE_Src    : PTR_TO T_ROOM_STATE;
   Ptr_T_ROOM_STATE_Dest   : PTR_TO T_ROOM_STATE;

END_VAR
