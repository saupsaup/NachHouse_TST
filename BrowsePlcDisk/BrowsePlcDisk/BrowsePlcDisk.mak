;# Varování: Tento soubor je spravován vývojovým prostredím Mosaic.
;# Nedoporucuje se upravovat ho rucne!

#program BrowsePlcDisk , V0.1.0.0
;**************************************
#libname "BrowsePlcDisk", 20251216
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
#uselib "LocalLib\SysLib_V52_20241212.mlb"
#uselib "LocalLib\ToStringLib_V13_20110203.mlb"
#uselib "LocalLib\FileLib_V35_20250701.mlb"
#endlibs

;**************************************
#usefile "PanelMaker\DeklarPT.mos", 'auto'
#usefile "IOConfigurator\CONFIG.ST", 'auto'
#usefile "IOConfigurator\CONFIG.HWC", 'auto'
#usefile "BROWSEPLCDISK.ST"
#usefile "fbDirBrowser.ST", 'lib'
#usefile "prgMain.ST"
#usefile "PanelMaker\r0_p0_CP_2000.mos", 'auto'
#usefile "BrowsePlcDisk.mcf", 'auto'
