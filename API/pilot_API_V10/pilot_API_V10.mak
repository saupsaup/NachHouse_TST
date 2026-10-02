;# Varov�n�: Tento soubor je spravov�n v�vojov�m prostred�m Mosaic.
;# Nedoporucuje se upravovat ho rucne!

#program pilot_API_V10 , V1.0.0.0
;**************************************
;<ActionName>NachHouse API PLC pilot</ActionName>
;<Programmer>NachHouse</Programmer>
;<FirmName>NachHouse</FirmName>
;<Copyright/>
;**************************************
;<History>
;V1.0.0.0 Native PUBLIC_API word-buffer pilot
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
#usefile "00_pilot_API_PLC_V10.st"
#usefile "01_Nh_Api_STRUCT.st"
#usefile "02_Nh_Api_UTILS.st"
#usefile "03_Nh_Api_ENGINE.st"
#usefile "prgMain.ST"
#usefile "pilot_API_V10.mcf", 'auto'
