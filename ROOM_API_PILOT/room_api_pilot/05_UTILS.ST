(* ROOM_API_PILOT - malé deterministické pomocné funkcie bez skrytého stavu. *)

(* Porovná všetky polia dvoch konfiguraènıch záznamov miestnosti. *)
FUNCTION ApiRoomConfigEqual : BOOL
VAR_INPUT
    A : T_ROOM_CONFIG; (* Prvı porovnávanı konfiguraènı záznam. *)
    B : T_ROOM_CONFIG; (* Druhı porovnávanı konfiguraènı záznam. *)
END_VAR

(* TRUE sa vráti iba vtedy, keï sú všetky polia zhodné. *)
ApiRoomConfigEqual :=
    (A.Used = B.Used) AND
    (A.RoomId = B.RoomId) AND
    (A.Name = B.Name) AND
    (A.ProjectName = B.ProjectName) AND
    (A.IconId = B.IconId) AND
    (A.SortDefault = B.SortDefault);
END_FUNCTION


(* Porovná všetky polia dvoch stavovıch záznamov miestnosti. *)
FUNCTION ApiRoomStateEqual : BOOL
VAR_INPUT
    A : T_ROOM_STATE; (* Prvı porovnávanı stavovı záznam. *)
    B : T_ROOM_STATE; (* Druhı porovnávanı stavovı záznam. *)
END_VAR

(* TRUE sa vráti iba vtedy, keï sú všetky polia zhodné. *)
ApiRoomStateEqual :=
    (A.RoomId = B.RoomId) AND
    (A.Temperature = B.Temperature) AND
    (A.Humidity = B.Humidity) AND
    (A.Presence = B.Presence) AND
    (A.DayPhase = B.DayPhase) AND
    (A.CategoryMask = B.CategoryMask) AND
    (A.AlarmLevel = B.AlarmLevel) AND
    (A.Online = B.Online);
END_FUNCTION


(* Vyh¾adá obsadenú konfiguraènú pozíciu pod¾a stabilného RoomId. *)
FUNCTION ApiFindConfigSlot : USINT
VAR_INPUT
    RoomId : UDINT; (* H¾adané stabilné ID; hodnota 0 sa zámerne neh¾adá. ENG *)
END_VAR
VAR
    i : USINT; (* Index pre prechod po¾om miestností. *)
END_VAR

(* Hodnota 0 znamená, e miestnos nebola nájdená. *)
ApiFindConfigSlot := 0;
IF RoomId <> 0 THEN
    FOR i := 1 TO C_MAX_ROOMS DO
        IF ApiConfig.Rooms[i].Used AND (ApiConfig.Rooms[i].RoomId = RoomId) THEN
            ApiFindConfigSlot := i;
            RETURN;
        END_IF;
    END_FOR;
END_IF;
END_FUNCTION


(* Vyh¾adá stavovú pozíciu pod¾a stabilného RoomId. *)
FUNCTION ApiFindStateSlot : USINT
VAR_INPUT
    RoomId : UDINT; (* H¾adané stabilné ID; hodnota 0 sa zámerne neh¾adá. ENG *)
END_VAR
VAR
    i : USINT; (* Index pre prechod po¾om stavov. *)
END_VAR

(* Hodnota 0 znamená, e stav miestnosti nebol nájdenı. *)
ApiFindStateSlot := 0;
IF RoomId <> 0 THEN
    FOR i := 1 TO C_MAX_ROOMS DO
        IF ApiState.Rooms[i].RoomId = RoomId THEN
            ApiFindStateSlot := i;
            RETURN;
        END_IF;
    END_FOR;
END_IF;
END_FUNCTION


(* Nájde prvú vo¾nú pozíciu v konfiguraènom poli. *)
FUNCTION ApiFindFreeConfigSlot : USINT
VAR
    i : USINT; (* Index pre prechod po¾om miestností. *)
END_VAR

(* Hodnota 0 znamená, e všetkıch 40 pozícií je obsadenıch. *)
ApiFindFreeConfigSlot := 0;
FOR i := 1 TO C_MAX_ROOMS DO
    IF NOT ApiConfig.Rooms[i].Used THEN
        ApiFindFreeConfigSlot := i;
        RETURN;
    END_IF;
END_FOR;
END_FUNCTION


(* Nájde prvú vo¾nú pozíciu v stavovom poli. *)
FUNCTION ApiFindFreeStateSlot : USINT
VAR
    i : USINT; (* Index pre prechod po¾om stavov. *)
END_VAR

(* Vo¾nı stavovı slot je oznaèenı hodnotou RoomId = 0. ENG *)
ApiFindFreeStateSlot := 0;
FOR i := 1 TO C_MAX_ROOMS DO
    IF ApiState.Rooms[i].RoomId = 0 THEN
        ApiFindFreeStateSlot := i;
        RETURN;
    END_IF;
END_FOR;
END_FUNCTION


(* Vynuluje konfiguraènı záznam a oznaèí jeho pozíciu ako nepouitú. *)
FUNCTION ApiClearRoomConfig : BOOL
VAR_IN_OUT
    Room : T_ROOM_CONFIG; (* Konfiguraènı záznam odovzdanı referenciou na vyèistenie. *)
END_VAR

(* Kadé pole sa nastavuje explicitne kvôli deterministickému vısledku. *)
Room.Used := FALSE;
Room.RoomId := 0;
Room.Name := '';
Room.ProjectName := '';
Room.IconId := 0;
Room.SortDefault := 0;
ApiClearRoomConfig := TRUE;
END_FUNCTION


(* Vynuluje stavovı záznam a uvo¾ní jeho pozíciu hodnotou RoomId = 0. *)
FUNCTION ApiClearRoomState : BOOL
VAR_IN_OUT
    Room : T_ROOM_STATE; (* Stavovı záznam odovzdanı referenciou na vyèistenie. *)
END_VAR

(* Bezpeèné nulové hodnoty nepredstavujú iadnu reálnu IO informáciu. *)
Room.RoomId := 0;
Room.Temperature := 0.0;
Room.Humidity := 0.0;
Room.Presence := FALSE;
Room.DayPhase := API_DAY_PHASE_DAY;
Room.CategoryMask := DWORD#16#00000000;
Room.AlarmLevel := API_ALARM_OK;
Room.Online := FALSE;
ApiClearRoomState := TRUE;
END_FUNCTION


(* Vyèistí hlavièku aj všetkıch 40 poloiek konfiguraèného diffu. *)
FUNCTION ApiClearConfigDiff : BOOL
VAR_IN_OUT
    Diff : T_API_CONFIG_DIFF; (* Konfiguraènı rámec odovzdanı referenciou na vyèistenie. ENG *)
END_VAR
VAR
    i : USINT; (* Index pre vyèistenie celého po¾a Changes. ENG *)
END_VAR

(* Po vyèistení rámec nie je platnı, kım ho producent znova nenaplní. *)
Diff.Valid := FALSE;
Diff.FromRevision := 0;
Diff.ToRevision := 0;
Diff.FullRequired := FALSE;
Diff.ChangeCount := 0;
FOR i := 1 TO C_MAX_ROOMS DO
    Diff.Changes[i].Valid := FALSE;
    Diff.Changes[i].Operation := API_DIFF_NONE;
    Diff.Changes[i].RoomId := 0;
    ApiClearRoomConfig(Diff.Changes[i].Room);
END_FOR;
ApiClearConfigDiff := TRUE;
END_FUNCTION


(* Vyèistí hlavièku aj všetkıch 40 poloiek stavového diffu. *)
FUNCTION ApiClearStateDiff : BOOL
VAR_IN_OUT
    Diff : T_API_STATE_DIFF; (* Stavovı rámec odovzdanı referenciou na vyèistenie. ENG *)
END_VAR
VAR
    i : USINT; (* Index pre vyèistenie celého po¾a Changes. ENG *)
END_VAR

(* Po vyèistení rámec nie je platnı, kım ho producent znova nenaplní. *)
Diff.Valid := FALSE;
Diff.FromRevision := 0;
Diff.ToRevision := 0;
Diff.FullRequired := FALSE;
Diff.ChangeCount := 0;
FOR i := 1 TO C_MAX_ROOMS DO
    Diff.Changes[i].Valid := FALSE;
    Diff.Changes[i].Operation := API_DIFF_NONE;
    Diff.Changes[i].RoomId := 0;
    ApiClearRoomState(Diff.Changes[i].Room);
END_FOR;
ApiClearStateDiff := TRUE;
END_FUNCTION


(* Vypoèíta nasledujúcu nenulovú revíziu s ošetrením preteèenia UDINT. *)
FUNCTION ApiNextRevision : UDINT
VAR_INPUT
    Revision : UDINT; (* Aktuálna revízia, z ktorej sa má vytvori nasledovník. ENG *)
END_VAR

ApiNextRevision := Revision + 1;
(* Hodnota 0 je vyhradená pre klienta bez naèítaného snapshotu. *)
IF ApiNextRevision = 0 THEN
    ApiNextRevision := 1;
END_IF;
END_FUNCTION


(* Overí, èi hodnota patrí medzi štyri denné fázy podporované browserom. *)
FUNCTION ApiValidDayPhase : BOOL
VAR_INPUT
    DayPhase : UINT; (* Kontrolovanı identifikátor dennej fázy. ENG *)
END_VAR

ApiValidDayPhase :=
    (DayPhase = API_DAY_PHASE_DAY) OR
    (DayPhase = API_DAY_PHASE_DUSK) OR
    (DayPhase = API_DAY_PHASE_NIGHT) OR
    (DayPhase = API_DAY_PHASE_DAWN);
END_FUNCTION
