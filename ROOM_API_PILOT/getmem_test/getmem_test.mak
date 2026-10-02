;# Varov�n�: Tento soubor je spravov�n v�vojov�m prostred�m Mosaic.
;# Nedoporucuje se upravovat ho rucne!

#program getmem_test , V1.0.0.0
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
#useoption AlarmTime = 150      ; prvn� v�straha [ms]
#useoption MaxCycleTime = 750   ; maxim�ln� cyklus [ms]
#useoption MinCycleTime = 0     ; minim�ln� cyklus [ms]
#useoption RestartOnError = 0   ; PLC nebude po tvrd� chybe restartov�n

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
