# Aktualizácia testovacieho PLC

## Pripravené 2026-10-02

`prgMain.ST` obsahuje aktivátor cez SysLib_V53_20260227:

- `NhDeployBuild = 2026100201` identifikuje prvú verziu s aktivátorom.
- `NhDeployRequest = TRUE` jednorazovo zavolá LoadNewPackage2 pre
  `//WWW/UPLOAD/NEW_PACK.TTR`, iba ak `NhApiInfo.State = 0`.
- `NhDeployResult`: 0 bez výsledku, 1 funkcia prijala požiadavku,
  2 API obsadené, 3 funkcia požiadavku odmietla.
- Prvý cyklus požiadavku vynuluje. Kód požiadavku sám neopakuje.
- Výsledok 1 nepotvrdzuje dokončené nasadenie. Po reštarte treba
  prečítať nové NhDeployBuild a overiť RUN a funkčnosť API.

Kompilácia úspešná, balík:
`PILOT_API_V11 v2-0-00000-00000 PROG_PCKG 2026-10-02_09-01-44.TTR`.
Verzia V2.0.0.0 bola už v aktuálnom projektovom makefile; identifikátor
binárneho protokolu zostáva 11.

Aktivátor zatiaľ nie je overený behom na HW. Najprv je potrebné túto
verziu jednorazovo nasadiť cez Mosaic. Pri znovuotvorení projektu načítať
nové súbory z disku, neprepísať ich starou kópiou z editora.

Ďalšie automatické nasadenie: preložiť verziu s novým NhDeployBuild,
nahrať NEW_PACK.TTR, stiahnuť a porovnať SHA-256, počkať na voľné API,
nastaviť NhDeployRequest a po obnovení spojenia overiť očakávané
NhDeployBuild. Tento celý cyklus ešte nebol vykonaný.

Prenos súborov cez plc.exe upload-file funguje. Priamy upload-ttr
zlyháva na LSAP; VSC2M nerozpoznáva otvorený projekt. Podrobnosti
sú v `/Users/pambm3/NachHouse_DEV/HELP/HELP_Mosaic_PLC.md`.
