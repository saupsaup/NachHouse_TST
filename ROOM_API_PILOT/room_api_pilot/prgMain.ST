(* Hlavnı cyklickı program ROOM_API_PILOT vykonávanı PLC. *)
PROGRAM prgMain
VAR
    (* Program zámerne nepotrebuje iadne lokálne premenné. *)
END_VAR

(* Jednorazová inicializácia; po prvom úspešnom cykle u dáta nemení. *)
ApiPilotInit();

IF ApiInitialized THEN
    (* Najprv sa spracujú poiadavky, ktoré môu zmeni konfiguráciu alebo stav. *)
    ApiProcessRoomCommand();
    ApiProcessTestState();

    (* Zachytí aj ruèné zmeny vykonané cez okno Watch v Mosaic. ENG *)
    ApiCaptureConfigChanges();
    ApiCaptureStateChanges();

    (* Synchronizácia sa spracuje a po zachytení všetkıch zmien daného cyklu. *)
    ApiProcessSyncRequest();
END_IF;
END_PROGRAM
