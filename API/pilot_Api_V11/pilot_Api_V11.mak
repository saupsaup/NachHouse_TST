;# Varování: Tento soubor je spravován vývojovým prostredím Mosaic.
;# Nedoporucuje se upravovat ho rucne!

#program pilot_Api_V11 , V2.0.0.0
;**************************************
;<ActionName>NachHouse API V11 pilot</ActionName>
;<Programmer/>
;<FirmName>NachHouse</FirmName>
;<Copyright/>
;**************************************
;<History>
; V2.0.0.0 - shared RX/TX, test single owner, State handshake, CRC, no data revisions
;- connect PLC
;</History>
;**************************************
#useoption CPM = 11             ; Typ CPM: I
#useoption AlarmTime = 150      ; první výstraha [ms]
#useoption MaxCycleTime = 750   ; maximální cyklus [ms]
#useoption MinCycleTime = 0     ; minimální cyklus [ms]
#useoption RestartOnError = 0   ; PLC nebude po tvrdé chybe restartován

#uselib "LocalLib\StdLib_V22_20180619.mlb"
#uselib "LocalLib\SysLib_V53_20260227.mlb"
#endlibs

;**************************************
#usefile "PanelMaker\DeklarPT.mos", 'auto'
#usefile "IOConfigurator\CONFIG.ST", 'auto'
#usefile "IOConfigurator\CONFIG.HWC", 'auto'
#usefile "PanelMaker\r0_p0_CP_2000.mos", 'auto'
#usefile "00_pilot_Api_V11.st"
#usefile "01_Nh_Api_STRUCT.st"
#usefile "02_Nh_Api_UTILS.st"
#usefile "03_Nh_Api_ENGINE.st"
#usefile "prgMain.ST"
#usefile "pilot_Api_V11.mcf", 'auto'
