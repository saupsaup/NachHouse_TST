; Varování: Tento soubor je spravován vývojovým prostøedím Mosaic.
; Nedoporuèuje se upravovat ho ruènì!

#program OscatBasicLib_333a , V3.3
;**************************************
#libname "OSCAT_BasicLib", 20161215
;<ActionName/>	Open Source Community for Automation Technology
;<Programmer/>	ported by nem
;<FirmName/>	www.oscat.de
;<Copyright/>	(c) 2014 OSCAT
;**************************************
;<History>
;{CSY}
;v3.3 30.12.2014 Nem Úvodni portace OSCAT Basic Library
;                    (original verze 3.33)
;     15.12.2016 Nem Odstranìny kolize jmen s Teco knihovnou TimeLib
;                    Funkce YEAR_OF_DATE()  prejmenovaná na YEAR_OF_DATE1()
;                    Funkce DAY_OF_YEAR()   prejmenovaná na DAY_OF_YEAR1()
;                    Funkce MONTH_OF_DATE() prejmenovaná na MONTH_OF_DATE1()
;                    Funkce DAY_OF_DATE()   prejmenovaná na DAY_OF_DATE1()
;                    Funkce HOUR_OF_DT()    prejmenovaná na HOUR_OF_DT1()
;                    Funkce DAY_OF_WEEK()   prejmenovaná na DAY_OF_WEEK1()
;                    Funkce DAY_OF_MONTH()  prejmenovaná na DAY_OF_MONTH1()
;
;{ENU}
;v3.3 2014-12-30 Nem First portation of OSCAT Basic Library
;                    (original version 3.33)
;     2016-12-15 Nem Solved collision with Teco library TimeLib
;                    Function YEAR_OF_DATE()  renamed on YEAR_OF_DATE1()
;                    Function DAY_OF_YEAR()   renamed on DAY_OF_YEAR1()
;                    Function MONTH_OF_DATE() renamed on MONTH_OF_DATE1()
;                    Function DAY_OF_DATE()   renamed on DAY_OF_DATE1()
;                    Function HOUR_OF_DT()    renamed on HOUR_OF_DT1()
;                    Function DAY_OF_WEEK()   renamed on DAY_OF_WEEK1()
;                    Function DAY_OF_MONTH()  renamed on DAY_OF_MONTH1()
;</History>
;**************************************
#useoption CPM = 9              ; Typ CPM: K
#useoption RemZone = 0          ; délka remanentní zóny
#useoption AlarmTime = 150      ; první výstraha [ms]
#useoption MaxCycleTime = 250   ; maximální cyklus [ms]
#useoption PLCstart = 1         ; studený start
#useoption AutoSummerTime = 0   ; vnitøní hodiny PLC se neposouvají pøi pøechodu na letní èas
#useoption RestartOnError = 0   ; PLC nebude po tvrdé chybì restartováno

#uselib "LocalLib\StdLib_V21_20140514.mlb", 'lib'
#uselib "LocalLib\ToStringLib_V13_20110203.mlb"
#uselib "LocalLib\SysLib_V38_20161121.mlb"
#uselib "LocalLib\TimeLib_V14_20130724.mlb"
#endlibs

;**************************************
#usefile "Sysgen\CIBMaker.st", 'auto'
#usefile "SysGen\HWConfig.ST", 'auto'
#usefile "Sysgen\CIBMaker.mos", 'auto'
#usefile "PLCnet\PlcNet.net", 'auto'
#usefile "OscatBasicLib_333a.ST", 'lib'
#usefile "Plc_Time.ST", 'lib'
#usefile "BUFFER_Management.ST", 'lib'
#usefile "Logic_Modules.st", 'lib'
#usefile "Arithmetics_With_Double_Precision.ST", 'lib'
#usefile "Mathematics.ST", 'lib'
#usefile "Time_and_Date.ST", 'lib'
#usefile "String_Functions.st", 'lib'
#usefile "Signal_Processing.ST", 'lib'
#usefile "Arithmetic_Functions.ST", 'lib'
#usefile "Signal_Generators.ST", 'lib'
#usefile "Control_Modules.ST", 'lib'
#usefile "Measuring_Modules.ST", 'lib'
#usefile "Pulse_Generators.ST", 'lib'
#usefile "Device_Driver.ST", 'lib'
#usefile "Complex_Mathematics.ST", 'lib'
#usefile "Arrays.ST", 'lib'
#usefile "Geometric_Functions.ST", 'lib'
#usefile "Vector_Mathematics.ST", 'lib'
#usefile "Memory_Modules.ST", 'lib'
#usefile "Latches_FlipFlop_ShiftRegister.ST", 'lib'
#usefile "Sensors.ST", 'lib'
#usefile "Calculations.ST", 'lib'
#usefile "List_Processing.ST", 'lib'
#usefile "Other_Functions.ST", 'lib'
#usefile "prgMain.ST"
#usefile "OscatBasicLib_333a.mcf", 'auto'
