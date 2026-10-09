;# Varování: Tento soubor je spravován vývojovým prostredím Mosaic.
;# Nedoporucuje se upravovat ho rucne!

#program pilot_Api_V11 , V2.2.0.0
;**************************************
;<ActionName>NachHouse API V11 pilot</ActionName>
;<Programmer/>
;<FirmName>NachHouse</FirmName>
;<Copyright/>
;**************************************
;<History>
; V2.2.0.0 - LOAD_800 test branch
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
#uselib "LocalLib\ToStringLib_V13_20110203.mlb"
#uselib "LocalLib\TimeLib_V17_20251106.mlb"
#uselib "LocalLib\FileLib_V36_20251203.mlb"
#uselib "LocalLib\ComLib_V43_20260604.mlb"
#uselib "LocalLib\EncryptLib_V15_20260115.mlb"
#uselib "LocalLib\DataBoxLib_V18_20250410.mlb"
#uselib "LocalLib\ConvertLib_V27_20260527.mlb"
#uselib "LocalLib\InternetLib_V72_20260126.mlb"
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
#usefile "04_Nh_Connect.st"
#usefile "05_Nh_FileTransport.st"
#usefile "06_Nh_RxTextTransport.st"
#usefile "07_Nh_JsonRamTest.st"
#usefile "prgMain.ST"
#usefile "pilot_Api_V11.mcf", 'auto'
