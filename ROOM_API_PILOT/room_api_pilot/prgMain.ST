(* Hlavn� cyklick� program ROOM_API_PILOT vykon�van� PLC. *)
PROGRAM prgMain
VAR
    (* Program z�merne nepotrebuje �iadne lok�lne premenn�. *)
END_VAR

(* Jednorazov� inicializ�cia; po prvom �spe�nom cykle u� d�ta nemen�. *)
ApiPilotInit();

IF ApiInitialized THEN
	SizeApiHeder 	:= SIZEOF(NH_API_DIFF_HEAD);	
	SizeStructRoom := SIZEOF(T_ROOM_STATE);
	SizeApiVars		:= SIZEOF(ApiVarsPublic);
	Ptr_T_ROOM_STATE_Dest^ := Ptr_T_ROOM_STATE_Src^;

    (* Najprv sa spracuj poiadavky, ktor mu zmeni konfigurciu alebo stav. *)
    ApiProcessRoomCommand();
    ApiProcessTestState();

    (* Zachyt aj run zmeny vykonan cez okno Watch v Mosaic. ENG *)
    ApiCaptureConfigChanges();
    ApiCaptureStateChanges();

    (* Synchroniz�cia sa spracuje a� po zachyten� v�etk�ch zmien dan�ho cyklu. *)
    ApiProcessSyncRequest();
END_IF;
END_PROGRAM
