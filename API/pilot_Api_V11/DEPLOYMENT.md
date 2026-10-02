# Aktualizácia testovacieho PLC

## VS Code úlohy (macOS)

Spustiť cez Terminal → Run Task:

- `PLC: Check connection and build` – iba čítanie stavu PLC.
- `PLC: Compile + Upload TTR (without activation)` – nový TTR uloží ako
  `NEW_PACK.TTR`, overí SHA-256 a PLC program nemení.
- `PLC: Activate uploaded TTR + Verify RUN` – aktivuje už overený
  `NEW_PACK.TTR`; predtým vyžaduje, aby bol lokálny NhDeployBuild vyšší
  než build v PLC.
- `PLC: Compile + Upload + Activate + Verify RUN` – celý cyklus vrátane kompilácie.

Kompletná úloha načíta heslo z macOS Keychain (heslo sa neukladá do projektu),
zvýši `NhDeployBuild` v prgMain.ST, preloží program podľa settings.json,
nahrá nový balík, overí SHA-256, jednorazovo aktivuje a čaká na nový
identifikátor a RUN bez chybových príznakov. PLC sa pri aktualizácii krátko zastaví.
Zdrojový súbor preto pred úlohou ulož a nenechaj otvorený editor prepísať nový identifikátor.

Vyžaduje Node.js s fetch, prlctl, spustenú Windows VM a knižnicu ws z
`/Users/pambm3/NachHouse_APP/ROOMS_BROWSER_V0.5.73/node_modules/ws`.
Cestu k ws možno zmeniť premennou `NH_WS_MODULE`.
Pri prerušení procesu môže zostať `.vscode/.deploy.lock`; odstrániť ho
až po overení, že už nebeží žiadne nasadenie.

Heslo je uložené v Keychain pod službou
`NachHouse PLC 192.168.33.200 deployment`. Pre jednorazové nahradenie
možno použiť premenné `NH_PLC_USER` a `NH_PLC_PASSWORD`; majú prednosť
pred Keychain.

Celý skript overený na HW 2026-10-02: zostavenie 2026100203 → 2026100206,
zhodný SHA-256, nový build, RUN, API 11, State=0, ERH=false, ERS=false.
Medziležiace čísla 204 a 205 boli spotrebované pri zlyhaní volania Parallels
pred prenosom. Volanie PowerShell cez cmd vyriešilo tento problém pri overenom behu.
Overené bolo aj nasadenie z Keychain bez zadania hesla: 2026100209 → 2026100210.
Samostatné úlohy boli overené: upload 2026100212 bez zmeny PLC, následná
samostatná aktivácia 2026100211 → 2026100212, RUN bez chýb.

## Život TTR v PLC

1. Úloha uloží TTR na disk PLC do `//WWW/UPLOAD/NEW_PACK.TTR`.
2. Aktivátor v bežiacom programe zavolá `LoadNewPackage2` nad týmto súborom.
3. PLC z neho načíta nový program, krátko sa zastaví a spustí nový program.
4. Po úspešnom načítaní PLC `NEW_PACK.TTR` samo zmaže.

Posledný krok bol overený výpisom `/UPLOAD/`: po aktivácii je priečinok
prázdny. TTR teda nezostáva ako rastúci odpad na disku PLC.

## Overené 2026-10-02 na HW PLC

`prgMain.ST` obsahuje aktivátor cez SysLib_V53_20260227:

- `NhDeployBuild = 2026100201` identifikuje prvú verziu s aktivátorom.
- `NhDeployRequest = TRUE` jednorazovo zavolá LoadNewPackage2 pre
  `//WWW/UPLOAD/NEW_PACK.TTR`, iba ak `NhApiInfo.State = 0`.
- `NhDeployResult`: 0 bez výsledku, 1 funkcia vrátila TRUE,
  2 API obsadené, 3 funkcia vrátila FALSE. Návrat FALSE nie je konečný
  výsledok: pri oboch úspešných aktualizáciách funkcia najprv vrátila FALSE.
- Prvý cyklus požiadavku vynuluje. Kód požiadavku sám neopakuje.
- Výsledok 1 nepotvrdzuje dokončené nasadenie. Po reštarte treba
  prečítať nové NhDeployBuild a overiť RUN a funkčnosť API.

Kompilácia úspešná, balík:
`PILOT_API_V11 v2-0-00000-00000 PROG_PCKG 2026-10-02_09-01-44.TTR`.
Verzia V2.0.0.0 bola už v aktuálnom projektovom makefile; identifikátor
binárneho protokolu zostáva 11.

Aktivátor bol jednorazovo zavedený cez Mosaic ako build 2026100201.
Následne boli bez Mosaicu úspešne nasadené buildy 2026100202 a
2026100203. Pri oboch PLC prešlo krátko do HALT, samo sa vrátilo do RUN,
nový NhDeployBuild bol čitateľný cez WSS a API skončilo v stave 0.
Po druhom cykle: ApiVersion=11, NhDeployBuild=2026100203, RUN=true,
ERH=false a ERS=false.

Ďalšie automatické nasadenie: preložiť verziu s novým NhDeployBuild,
nahrať NEW_PACK.TTR, stiahnuť a porovnať SHA-256, počkať na voľné API,
nastaviť NhDeployRequest a po obnovení spojenia overiť očakávané
NhDeployBuild, ApiVersion, State=0, RUN a chybové príznaky PLC.

Prenos súborov cez plc.exe upload-file funguje. Priamy upload-ttr
zlyháva na LSAP; VSC2M nerozpoznáva otvorený projekt. Podrobnosti
sú v `/Users/pambm3/NachHouse_DEV/HELP/HELP_Mosaic_PLC.md`.
