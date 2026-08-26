;# Varování: Tento soubor je spravován vývojovým prostredím Mosaic.
;# Nedoporucuje se upravovat ho rucne!

#program TEST_Api , V1.0.0.0
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
#uselib "LocalLib\SysLib_V53_20260227.mlb"
#uselib "LocalLib\DALI2Lib_V13_20251125.mlb"
#uselib "LocalLib\DaliLibEx_V13_20230602.mlb"
#endlibs

;**************************************
#usefile "PanelMaker\DeklarPT.mos", 'auto'
#usefile "IOConfigurator\CONFIG.ST", 'auto'
#usefile "IOConfigurator\CONFIG.HWC", 'auto'
#usefile "PanelMaker\r0_p0_CP_2000.mos", 'auto'
#usefile "TEST_API.ST"
#usefile "01_Types.st"
#usefile "02_Constants.st"
#usefile "03_GVL_PublicApi.st"
#usefile "04_GVL_Internal.st"
#usefile "05_prgApiInit.st"
#usefile "06_prgApiState.st"
#usefile "07_prgApiCommand.st"
#usefile "prgMain.ST"
#usefile "TEST_Api.mcf", 'auto'
