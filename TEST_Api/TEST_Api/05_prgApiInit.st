FUNCTION prgApiInit : BOOL
VAR
    i : USINT;
END_VAR

IF NOT ApiInitialized THEN

    FOR i := 1 TO C_ROOM_MAX DO
        ApiConfig.Rooms[i].Id          := 0;
        ApiConfig.Rooms[i].Name        := '';
        ApiConfig.Rooms[i].ShortName   := '';
        ApiConfig.Rooms[i].FloorId     := 0;
        ApiConfig.Rooms[i].SortOrder   := 0;
        ApiConfig.Rooms[i].Icon        := '';
        ApiConfig.Rooms[i].Enabled     := FALSE;

        ApiState.Rooms[i].Temperature   := 0.0;
        ApiState.Rooms[i].Humidity      := 0.0;
        ApiState.Rooms[i].LightLevel    := 0;
        ApiState.Rooms[i].LightsCount   := 0;
        ApiState.Rooms[i].LightsOnCount := 0;
        ApiState.Rooms[i].LightsOn      := FALSE;
        ApiState.Rooms[i].BlindsCount   := 0;
        ApiState.Rooms[i].BlindsMoving  := FALSE;
        ApiState.Rooms[i].HeatingActive := FALSE;
        ApiState.Rooms[i].CoolingActive := FALSE;
        ApiState.Rooms[i].AlarmActive   := FALSE;
        ApiState.Rooms[i].WarningActive := FALSE;
        ApiState.Rooms[i].Occupied      := FALSE;
        ApiState.Rooms[i].ChangeCounter := 0;
    END_FOR;

    ApiConfig.Version   := 1;
    ApiConfig.RoomCount := 2;

    ApiConfig.Rooms[1].Id        := 1;
    ApiConfig.Rooms[1].Name      := 'Obyvacka';
    ApiConfig.Rooms[1].ShortName := 'Obyv.';
    ApiConfig.Rooms[1].FloorId   := 1;
    ApiConfig.Rooms[1].SortOrder := 1;
    ApiConfig.Rooms[1].Icon      := 'living_room';
    ApiConfig.Rooms[1].Enabled   := TRUE;

    ApiConfig.Rooms[2].Id        := 2;
    ApiConfig.Rooms[2].Name      := 'Kuchyna';
    ApiConfig.Rooms[2].ShortName := 'Kuch.';
    ApiConfig.Rooms[2].FloorId   := 1;
    ApiConfig.Rooms[2].SortOrder := 2;
    ApiConfig.Rooms[2].Icon      := 'kitchen';
    ApiConfig.Rooms[2].Enabled   := TRUE;

    ApiState.Version := 1;
    ApiState.Online  := TRUE;
    ApiState.Counter := 0;

    ApiState.Rooms[1].Temperature := 22.5;
    ApiState.Rooms[1].Humidity    := 45.0;
    ApiState.Rooms[1].LightLevel  := 350;
    ApiState.Rooms[1].LightsCount := 4;

    ApiState.Rooms[2].Temperature := 23.0;
    ApiState.Rooms[2].Humidity    := 48.0;
    ApiState.Rooms[2].LightLevel  := 250;
    ApiState.Rooms[2].LightsCount := 3;

    ApiCommand.Request.RequestId := 0;
    ApiCommand.Request.RoomId    := 0;
    ApiCommand.Request.DeviceId  := 0;
    ApiCommand.Request.Command   := CMD_NONE;
    ApiCommand.Request.ValueBool := FALSE;
    ApiCommand.Request.ValueInt  := 0;
    ApiCommand.Request.ValueReal := 0.0;
    ApiCommand.Request.Execute   := FALSE;

    ApiCommand.Result.RequestId  := 0;
    ApiCommand.Result.ResultCode := RESULT_OK;
    ApiCommand.Result.Finished   := FALSE;

    LastRequestId  := 0;
    ApiInitialized := TRUE;

END_IF;

END_FUNCTION
