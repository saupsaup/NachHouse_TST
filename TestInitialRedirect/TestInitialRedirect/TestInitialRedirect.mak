; Varování: Tento soubor je spravován vývojovým prostøedím Mosaic.
; Nedoporuèuje se upravovat ho ruènì!

#program TestInitialRedirect , V1.0.0.0
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
#uselib "LocalLib\SysLib_V44_20200302.mlb"
#uselib "LocalLib\ComLib_V32_20191210.mlb"
#endlibs

;**************************************
#usefile "PanelMaker\DeklarPT.mos", 'auto'
#usefile "IOConfigurator\CONFIG.ST", 'auto'
#usefile "IOConfigurator\CONFIG.HWC", 'auto'
#usefile "TESTINITIALREDIRECT.ST"
#usefile "prgMain.ST"
#usefile "PanelMaker\r0_p0_CP_2000.mos", 'auto'
#usefile "TestInitialRedirect.mcf", 'auto'
