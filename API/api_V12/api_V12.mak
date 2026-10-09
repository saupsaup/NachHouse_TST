;# Varování: Tento soubor je spravován vývojovým prostredím Mosaic.
;# Nedoporucuje se upravovat ho rucne!

#program api_V12 , V1.0.0.0
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
#uselib "LocalLib\ToStringLib_V13_20110203.mlb"
#uselib "LocalLib\TimeLib_V17_20251106.mlb"
#uselib "LocalLib\FileLib_V36_20251203.mlb"
#uselib "LocalLib\ConvertLib_V28_20260924.mlb"
#uselib "LocalLib\JsonBaseLib_V10_20240515.mlb"
#endlibs

;**************************************
#usefile "PanelMaker\DeklarPT.mos", 'auto'
#usefile "IOConfigurator\CONFIG.ST", 'auto'
#usefile "IOConfigurator\CONFIG.HWC", 'auto'
#usefile "_01_Types.ST"
#usefile "_02_DataInit.ST"
#usefile "_03_Schema.ST"
#usefile "_04_SchemaRun.ST"
#usefile "_05_TxJson.ST"
#usefile "_06_RxJson.ST"
#usefile "_07_RxBuf.ST"
#usefile "prgMain.ST"
#usefile "PanelMaker\r0_p0_CP_2000.mos", 'auto'
#usefile "api_V12.mcf", 'auto'
