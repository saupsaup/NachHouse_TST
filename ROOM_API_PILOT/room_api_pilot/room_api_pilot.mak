;# Varování: Tento soubor je spravován vývojovým prostredím Mosaic.
;# Nedoporucuje se upravovat ho rucne!

#program room_api_pilot , V1.0.0.2
;**************************************
;<ActionName/>
;<Programmer/>
;<FirmName/>
;<Copyright/>
;**************************************
;<History>
;</History>
;**************************************
#useoption CPM = 11             ; Typ CPM: I
#useoption AlarmTime = 150      ; první výstraha [ms]
#useoption MaxCycleTime = 750   ; maximální cyklus [ms]
#useoption MinCycleTime = 0     ; minimální cyklus [ms]
#useoption RestartOnError = 0   ; PLC nebude po tvrdé chybe restartován

#uselib "LocalLib\StdLib_V22_20180619.mlb"
#endlibs

;**************************************
#usefile "PanelMaker\DeklarPT.mos", 'auto'
#usefile "IOConfigurator\CONFIG.ST", 'auto'
#usefile "IOConfigurator\CONFIG.HWC", 'auto'
#usefile "PanelMaker\r0_p0_CP_2000.mos", 'auto'
#usefile "ROOM_API_PILOT.ST"
#usefile "01_CONSTANTS.ST"
#usefile "02_TYPES.ST"
#usefile "03_PUBLIC_API.ST"
#usefile "04_INTERNAL.ST"
#usefile "05_UTILS.ST"
#usefile "06_DIFF_ENGINE.ST"
#usefile "07_INIT.ST"
#usefile "08_COMMAND_ENGINE.ST"
#usefile "09_STATE_TEST.ST"
#usefile "10_SYNC_ENGINE.ST"
#usefile "prgMain.ST"
#usefile "room_api_pilot.mcf", 'auto'
