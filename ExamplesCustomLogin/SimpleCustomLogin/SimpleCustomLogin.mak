; Varování: Tento soubor je spravován vývojovým prostøedím Mosaic.
; Nedoporuèuje se upravovat ho ruènì!

#program SimpleCustomLogin , V1.0.0.0
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

#uselib "LocalLib\StdLib_V21_20140514.mlb"
#uselib "LocalLib\SysLib_V38_20170104.mlb"
#endlibs

;**************************************
#usefile "PanelMaker\DeklarPT.mos", 'auto'
#usefile "IOConfigurator\CONFIG.ST", 'auto'
#usefile "IOConfigurator\CONFIG.HWC", 'auto'
#usefile "SimpleCustomLogin.ST"
#usefile "prgMain.ST"
#usefile "PanelMaker\r0_p0_CP_2000.mos", 'auto'
#usefile "SimpleCustomLogin.mcf", 'auto'
