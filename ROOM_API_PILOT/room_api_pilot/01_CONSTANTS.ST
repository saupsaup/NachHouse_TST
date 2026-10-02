(*
   ROOM_API_PILOT - verejn� ��seln� kontrakt a pevn� limity pilotu.
   ��seln� hodnoty s� s��as�ou API; klient ich nesmie svojvo�ne meni�.
*)

VAR_GLOBAL CONSTANT
    C_API_VERSION          : STRING[32] := 'ROOM_API_PILOT/1'; (* Textov� verzia verejn�ho API kontraktu. ENG *)
    C_MAX_ROOMS            : USINT := 40;                     (* Najvy��� po�et miestnost� podporovan� pilotom. *)
    C_DIFF_HISTORY_DEPTH   : USINT := 8;                      (* Po�et uchov�van�ch r�mcov zmien v kruhovej hist�rii. *)

    (* ��seln� k�dy akci� po�a Action v pr�kaze miestnosti. *)
    API_ACTION_NONE          : USINT := 0; (* Nie je zvolen� �iadna akcia. ENG *)
    API_ACTION_ADD_ROOM      : USINT := 1; (* Pridanie novej miestnosti. ENG *)
    API_ACTION_DELETE_ROOM   : USINT := 2; (* Odstr�nenie existuj�cej miestnosti. ENG *)
    API_ACTION_COPY_ROOM     : USINT := 3; (* Vytvorenie k�pie existuj�cej miestnosti. ENG *)
    API_ACTION_SET_ROOM_DATA : USINT := 4; (* Zmena n�zvov�ch �dajov miestnosti. ENG *)

    (* ��seln� n�vratov� k�dy po�a Result. *)
    API_RESULT_NONE               : USINT := 0; (* V�sledok e�te nie je k dispoz�cii. ENG *)
    API_RESULT_OK                 : USINT := 1; (* Oper�cia prebehla �spe�ne. ENG *)
    API_RESULT_ERROR              : USINT := 2; (* V�eobecn�, bli��ie neur�en� chyba. ENG *)
    API_RESULT_NOT_FOUND          : USINT := 3; (* Po�adovan� objekt sa nena�iel. ENG *)
    API_RESULT_NO_FREE_SLOT       : USINT := 4; (* Nie je vo�n� poz�cia pre �al�iu miestnos�. ENG *)
    API_RESULT_ALREADY_EXISTS     : USINT := 5; (* Objekt s rovnak�m identifik�torom u� existuje. ENG *)
    API_RESULT_INVALID_ARGUMENT   : USINT := 6; (* Aspo� jeden vstupn� �daj je neplatn�. ENG *)
    API_RESULT_UNSUPPORTED_ACTION : USINT := 7; (* Klient po�aduje nepodporovan� akciu. ENG *)

    (* Druh oper�cie zap�sanej v jednom z�zname diffu. *)
    API_DIFF_NONE   : USINT := 0; (* Z�znam neobsahuje zmenu. ENG *)
    API_DIFF_UPSERT : USINT := 1; (* Vlo�enie nov�ho alebo �pln� aktualiz�cia existuj�ceho z�znamu. ENG *)
    API_DIFF_DELETE : USINT := 2; (* Odstr�nenie z�znamu. ENG *)

    (* Re�im odpovede synchroniza�n�ho mechanizmu. *)
    API_SYNC_CURRENT       : USINT := 0; (* Cache klienta u� zodpoved� aktu�lnej rev�zii. ENG *)
    API_SYNC_DIFF          : USINT := 1; (* Odpove� obsahuje jeden nadv�zuj�ci r�mec zmien. ENG *)
    API_SYNC_FULL_REQUIRED : USINT := 2; (* Hist�ria nesta�� a klient mus� na��ta� cel� snapshot. ENG *)

    (* Vizu�lna �rove� alarmu zobrazovan� na karte miestnosti. *)
    API_ALARM_OK      : USINT := 0; (* Bez upozornenia alebo alarmu. ENG *)
    API_ALARM_WARNING : USINT := 1; (* Upozornenie. ENG *)
    API_ALARM_ALARM   : USINT := 2; (* Alarm. ENG *)

    (* Identifik�tory existuj�cich ikon dennej f�zy vo frozen browseri V0.5.72. *)
    API_DAY_PHASE_DAY   : UINT := 140; (* Denn� f�za. ENG *)
    API_DAY_PHASE_DUSK  : UINT := 142; (* S�mrak. ENG *)
    API_DAY_PHASE_NIGHT : UINT := 144; (* No�n� f�za. ENG *)
    API_DAY_PHASE_DAWN  : UINT := 146; (* �svit. ENG *)

    (* Predvolen� testovacie hodnoty pou�it� pri pridan� miestnosti. *)
    API_DEFAULT_ICON_ID     : UINT := 16;   (* Predvolen� identifik�tor ikony miestnosti. *)
    API_DEFAULT_TEMPERATURE : REAL := 20.0; (* Predvolen� teplota v stup�och Celzia. *)
    API_DEFAULT_HUMIDITY    : REAL := 40.0; (* Predvolen� relat�vna vlhkos� v percent�ch. *)
END_VAR
