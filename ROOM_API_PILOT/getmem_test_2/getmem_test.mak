; Minimal independent GETMEM test project for CP-2000.

#program getmem_test , V0.1.0.0
;**************************************
;<ActionName/>
;<Programmer/>
;<FirmName/>
;<Copyright/>
;**************************************
;<History>
;</History>
;**************************************
#useoption CPM = 11
#useoption AlarmTime = 150
#useoption MaxCycleTime = 750
#useoption MinCycleTime = 0
#useoption RestartOnError = 0

#uselib "LocalLib\StdLib_V22_20180619.mlb"
#endlibs

;**************************************
#usefile "PanelMaker\DeklarPT.mos", 'auto'
#usefile "IOConfigurator\CONFIG.ST", 'auto'
#usefile "IOConfigurator\CONFIG.HWC", 'auto'
#usefile "PanelMaker\r0_p0_CP_2000.mos", 'auto'
#usefile "GETMEM_TEST.ST"
#usefile "01_GETMEM_DATA.ST"
#usefile "prgMain.ST"
#usefile "getmem_test.mcf", 'auto'
