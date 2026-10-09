#program pilot_Api_V11 , V2.3.0.0
#useoption CPM = 11
#useoption AlarmTime = 150
#useoption MaxCycleTime = 750
#useoption MinCycleTime = 0
#useoption RestartOnError = 0

#uselib "LocalLib\StdLib_V22_20180619.mlb"
#uselib "LocalLib\SysLib_V53_20260227.mlb"
#uselib "..\..\vila303PT\APP\LocalLib\CrcLib_V14_20250128.mlb"
#uselib "..\..\vila303PT\APP\LocalLib\CanvasLib_V23_20190122.mlb"
#uselib "..\..\vila303PT\APP\LocalLib\ToStringLib_V13_20110203.mlb"
#uselib "..\..\vila303PT\APP\LocalLib\FileLib_V35_20250701.mlb"
#uselib "..\..\vila303PT\APP\LocalLib\ComLib_V42_20251016.mlb"
#uselib "..\..\vila303PT\APP\LocalLib\ConvertLib_V26_20240105.mlb"
#uselib "..\..\vila303PT\APP\LocalLib\SfcLib_V15_20190605.mlb"
#uselib "..\..\vila303PT\APP\LocalLib\EncryptLib_V14_20231018.mlb"
#uselib "..\..\vila303PT\APP\LocalLib\TimeLib_V17_20251106.mlb"
#uselib "..\..\vila303PT\APP\LocalLib\DataBoxLib_V18_20250410.mlb"
#uselib "..\..\vila303PT\APP\LocalLib\InternetLib_V70_20241220.mlb"
#endlibs

#usefile "PanelMaker\DeklarPT.mos", 'auto'
#usefile "IOConfigurator\CONFIG.ST", 'auto'
#usefile "IOConfigurator\CONFIG.HWC", 'auto'
#usefile "PanelMaker\r0_p0_CP_2000.mos", 'auto'
#usefile "00_pilot_Api_V11.st"
#usefile "01_Nh_Api_STRUCT.st"
#usefile "02_Nh_Api_UTILS.st"
#usefile "03_Nh_Api_ENGINE.st"
#usefile "04_Nh_Connect.st"
#usefile "prgMain.ST"
#usefile "pilot_Api_V11.mcf", 'auto'
