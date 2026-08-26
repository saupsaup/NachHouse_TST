(*
   Interné pracovné údaje PLC sa neexportujú do TecoApi ani PLCComS.
   Klient k nim nemá pristupova a nie sú súèasou verejného kontraktu.
*)

VAR_GLOBAL
    ApiInitialized : BOOL; (* TRUE po jednorazovom dokonèení inicializácie pilotnıch dát. ENG *)

    (* Tieòové kópie posledného zachyteného snapshotu pouívané na vıpoèet zmien. *)
    ApiConfigShadow : ARRAY[1..40] OF T_ROOM_CONFIG; (* Posledná známa konfigurácia pre porovnanie. ENG *)
    ApiStateShadow  : ARRAY[1..40] OF T_ROOM_STATE;  (* Poslednı známy stav pre porovnanie. ENG *)

    (* Kruhové histórie ôsmich poslednıch revíznych rámcov pre obnovu cache klienta. *)
    ApiConfigDiffHistory : ARRAY[1..8] OF T_API_CONFIG_DIFF; (* Uchované konfiguraèné diffy. ENG *)
    ApiStateDiffHistory  : ARRAY[1..8] OF T_API_STATE_DIFF;  (* Uchované stavové diffy. ENG *)
    ApiConfigHistoryHead : USINT; (* Index najnovšieho konfiguraèného rámca; 0 pred prvım zápisom. ENG *)
    ApiStateHistoryHead  : USINT; (* Index najnovšieho stavového rámca; 0 pred prvım zápisom. ENG *)

    (* Údaje potrebné na idempotentné zopakovanie bezprostredne posledného príkazu. *)
    ApiLastCommandClientId  : STRING[36];          (* ClientId posledného spracovaného príkazu. ENG *)
    ApiLastCommandRequestId : UDINT;               (* RequestId posledného spracovaného príkazu. ENG *)
    ApiLastStoredResult     : T_API_COMMAND_RESULT; (* Úplnı uloenı vısledok posledného príkazu. ENG *)
END_VAR
