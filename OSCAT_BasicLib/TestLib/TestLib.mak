; Varování: Tento soubor je spravován vývojovým prostøedím Mosaic.
; Nedoporuèuje se upravovat ho ruènì!

#program TestLib , V1.0
;**************************************
;<ActionName/>
;<Programmer/>
;<FirmName/>
;<Copyright/>
;**************************************
;<History>
;</History>
;**************************************
#useoption CPM = 9              ; Typ CPM: K
#useoption RemZone = 0          ; délka remanentní zóny
#useoption AlarmTime = 150      ; první výstraha [ms]
#useoption MaxCycleTime = 250   ; maximální cyklus [ms]
#useoption PLCstart = 1         ; studený start
#useoption AutoSummerTime = 0   ; vnitøní hodiny PLC se neposouvají pøi pøechodu na letní èas
#useoption RestartOnError = 0   ; PLC nebude po tvrdé chybì restartováno

#uselib "LocalLib\StdLib_V21_20140514.mlb"
#uselib "LocalLib\OSCAT_BasicLib_V33_20150210.mlb"
#endlibs

;**************************************
#usefile "Sysgen\CIBMaker.st", 'auto'
#usefile "SysGen\HWConfig.ST", 'auto'
#usefile "Sysgen\CIBMaker.mos", 'auto'
#usefile "TESTLIB.ST"
#usefile "fbMsCounter.ST"
#usefile "prgMain.ST"
#usefile "TestLib.mcf", 'auto'
