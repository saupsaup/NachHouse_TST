;# Varovanie: Tento súbor spravuje vývojové prostredie Mosaic. ; Warning: This file is managed by the Mosaic development environment.
;# Neodporúča sa upravovať ručne. ; Manual editing is not recommended.

#program V13 , V1.0.0.0
;**************************************
;<ActionName/>
;<Programmer/>
;<FirmName/>
;<Copyright/>
;**************************************
;<History>
;</History>
;**************************************
#useoption CPM = 11              ; Typ CPM: I ; CPM type: I
#useoption AlarmTime = 150       ; Prvá výstraha [ms] ; First warning [ms]
#useoption MaxCycleTime = 750    ; Maximálny čas cyklu [ms] ; Maximum cycle time [ms]
#useoption MinCycleTime = 0      ; Minimálny čas cyklu [ms] ; Minimum cycle time [ms]
#useoption RestartOnError = 0    ; PLC sa po závažnej chybe nereštartuje. ; The PLC will not restart after a critical error.

#uselib "LocalLib\StdLib_V22_20180619.mlb"
#uselib "LocalLib\SysLib_V53_20260227.mlb"
#uselib "LocalLib\ToStringLib_V13_20110203.mlb"
#uselib "LocalLib\TimeLib_V17_20251106.mlb"
#uselib "LocalLib\FileLib_V36_20251203.mlb"
#uselib "LocalLib\ConvertLib_V28_20260924.mlb"
#endlibs

;**************************************
#usefile "PanelMaker\DeklarPT.mos", 'auto'
#usefile "IOConfigurator\CONFIG.ST", 'auto'
#usefile "IOConfigurator\CONFIG.HWC", 'auto'
#usefile "_01_Types.ST"
#usefile "prgMain.ST"
#usefile "PanelMaker\r0_p0_CP_2000.mos", 'auto'
#usefile "V13.mcf", 'auto'
