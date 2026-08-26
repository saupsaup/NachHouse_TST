FUNCTION_BLOCK FBprgApiCommand
VAR
    RoomIndex : USINT;
END_VAR

IF ApiCommand.Request.Execute THEN

    IF ApiCommand.Request.RequestId <> LastRequestId THEN

        ApiCommand.Result.Finished   := FALSE;
        ApiCommand.Result.RequestId  := ApiCommand.Request.RequestId;
        ApiCommand.Result.ResultCode := RESULT_OK;

        RoomIndex := ApiCommand.Request.RoomId;

        IF (RoomIndex < 1) OR (RoomIndex > ApiConfig.RoomCount) THEN

            ApiCommand.Result.ResultCode := RESULT_INVALID_ROOM;

        ELSE

            CASE ApiCommand.Request.Command OF

                CMD_ROOM_LIGHTS_OFF:
                    ApiState.Rooms[RoomIndex].LightsOn      := FALSE;
                    ApiState.Rooms[RoomIndex].LightsOnCount := 0;
                    ApiState.Rooms[RoomIndex].ChangeCounter :=
                        ApiState.Rooms[RoomIndex].ChangeCounter + 1;

                CMD_ROOM_LIGHTS_ON:
                    ApiState.Rooms[RoomIndex].LightsOn := TRUE;
                    ApiState.Rooms[RoomIndex].LightsOnCount :=
                        ApiState.Rooms[RoomIndex].LightsCount;
                    ApiState.Rooms[RoomIndex].ChangeCounter :=
                        ApiState.Rooms[RoomIndex].ChangeCounter + 1;

                ELSE
                    ApiCommand.Result.ResultCode := RESULT_UNKNOWN_COMMAND;

            END_CASE;

        END_IF;

        LastRequestId := ApiCommand.Request.RequestId;
        ApiCommand.Result.Finished := TRUE;

    END_IF;

    ApiCommand.Request.Execute := FALSE;

END_IF;

END_FUNCTION_BLOCK

VAR_GLOBAL
   prgApiCommand : FBprgApiCommand;
END_VAR
