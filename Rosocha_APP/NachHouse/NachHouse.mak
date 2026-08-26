; Varovï¿½nï¿½: Tento soubor je spravovï¿½n vï¿½vojovï¿½m prostredï¿½m Mosaic.
; Nedoporucuje se upravovat ho rucne!

#program WRK , V1.0.0.0
;**************************************
#libname "NachHouse", 20241204
;<ActionName/>
;<Programmer/>	Ing.Peter Aust
;<FirmName/>	Ing.Peter Aust
;<Copyright/>	Ing.Peter Aust
;**************************************
;<History>
;</History>
;**************************************
#useoption CPM = 11             ; Typ CPM: I
#useoption AlarmTime = 500      ; první výstraha [ms]
#useoption MaxCycleTime = 1200  ; maximální cyklus [ms]
#useoption MinCycleTime = 0     ; minimální cyklus [ms]
#useoption RestartOnError = 1   ; 1 minutu po tvrdé chybe bude PLC restartován

#uselib "LocalLib\StdLib_V22_20180619.mlb"
#uselib "LocalLib\SysLib_V53_20260227.mlb"
#uselib "LocalLib\CrcLib_V14_20250128.mlb"
#uselib "LocalLib\CanvasLib_V23_20190122.mlb"
#uselib "LocalLib\ToStringLib_V13_20110203.mlb"
#uselib "LocalLib\DaliLibEx_V13_20230602.mlb"
#uselib "LocalLib\FileLib_V35_20250701.mlb"
#uselib "LocalLib\ComLib_V42_20251016.mlb"
#uselib "LocalLib\ParadoxLib_V17_20141014.mlb"
#uselib "LocalLib\ConvertLib_V26_20240105.mlb"
#uselib "LocalLib\EncryptLib_V14_20231018.mlb"
#uselib "LocalLib\TimeLib_V16_20230504.mlb"
#uselib "LocalLib\DataBoxLib_V18_20250410.mlb"
#uselib "LocalLib\InternetLib_V72_20260126.mlb"
#uselib "LocalLib\NotifyLib_V10_20190723.mlb"
#uselib "LocalLib\ModelLib_V22_20171205.mlb"
#uselib "LocalLib\JsonBaseLib_V10_20240515.mlb"
#uselib "LocalLib\JsonLibEx_V31_20260122.mlb"
#uselib "LocalLib\iControlLib_V36_20240315.mlb"
#uselib "LocalLib\AstroLib_V15_20200408.mlb"
#uselib "LocalLib\XmlLibEx_V24_20240730.mlb"
#uselib "LocalLib\MeteoLib_V10_20210621.mlb"
#uselib "LocalLib\RamBoxLib_V11_20250116.mlb"
#uselib "LocalLib\ModbusRTU_V50_20260305.mlb"
#uselib "LocalLib\NachHouse_V22_20250330.mlb"
#endlibs

;**************************************
#usefile "PanelMaker\DeklarPT.mos", 'auto'
#usefile "IOConfigurator\CONFIG.ST", 'auto'
#usefile "IOConfigurator\CONFIG.HWC", 'auto'
#usefile "ROSOCHA.ST"
#usefile "PanelMaker\r0_p0_CP_2000.mos", 'auto'
#usefile "NachHouse.mcf", 'auto'
