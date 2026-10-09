# V13 — čistý základ, 9. 10. 2026

Projekt: TST/API/V13. Zdrojové ST a MAK zostali Windows-1250/CRLF.

Odstránené: generátor JSON schémy a jeho dvojpriechodová kompilácia,
staré ST zálohy, neaktívna inicializácia testovacích dát, staré Tx premenné,
DepRq/DepRes a LoadNewPackage2, staré RAM exporty a dáta simulátora,
nezapojené kópie knižníc, úloha LOAD 800 a staré odkazy V12.
Dátové typy, mRam, ROOM/USER nad mJson a konfigurácia CP-2000 sú zachované.
ROOM a USER zdieľajú mJson; ide o dva pohľady na rovnakú pamäť.
Inicializácia ani JSON komunikácia nie sú zapojené.
Mosaic RunAfterComp je prázdne; žiadny externý program po kompilácii.

Úlohy VS Code:
- Compile: V13 — vytvorí aktuálny TTR, PUX a publikačné súbory.
- PLC: Compile + Upload + RUN + Verify — kompilácia, HALT, prenos cez plc.exe,
  RUN a kontrola čísla programu a ERH/ERS.
- PLC: Compile + Upload without RUN — po prenose zostane PLC v HALT.
- PLC: RUN + Verify V13 — spustí nahratý program a overí ho.
- PLC: Check V13 + RUN — iba číta stav a BuildNo podľa miestneho TecoApi.pub.
- Map N: — mapuje zdieľaný NachHouse_DEV vo Windows.

Pôvodne upravený priamy postup nepoužíva FTP ani cloud; po meraní je FTP opäť dostupné pre prenos TTR. V tomto overení priamy upload-ttr v RUN zlyhal;
po HALT prenos prešiel.
Úplná pôvodná kópia: /private/tmp/V13-before-clean-20261009.

## Výsledok overenia

Kompilácia úspešná. Prenos upload-ttr po HALT skončil úspešne.
TecoApi.pub stiahnutý priamo z PLC zodpovedá V13 (BuildNo R L 19185).
PLC hlási RUN, ERH=false, ERS=false.
Čítanie BuildNo vrátilo 0x2E636572 namiesto 2026100901.
Preto správne spustenie/inicializácia V13 ešte nie je potvrdená.
Príčina rozdielu zatiaľ neurčená. Studený štart navrhnutý na overenie
inicializácie bol zamietnutý automatickou kontrolou schvaľovania a nevykonal sa.
Úloha nasadenia pri tomto rozdiele správne končí chybou.

## FTP prenos — oprava rozhodnutia

Na výslovný pokyn používateľa je FTP povolené pre nasadenie TTR.
Toto nemení návrh aplikačnej komunikácie PLC ↔ klient.
Aktuálny TTR: 114 069 B; FTP upload 1546 ms, spätné stiahnutie 1558 ms.
Súbor sa zhoduje bajt po bajte, SHA-256
479d8cd5d7ef8ba34e8cd4b9ef7781e396932219c54cfdf2491d91d88e905f74.
Nové meranie Mosaic zlyhalo už pri HALT: LSAP service is not activated.
Čas priameho prenosu preto nie je porovnateľne zmeraný.
Úloha PLC: Compile + FTP upload TTR (without activation) je obnovená.
FTP uloží balík do /WWW/UPLOAD/NEW_PACK.TTR a overí presnú zhodu.
Neaktivuje ho. Starý aktivačný mechanizmus DepRq/LoadNewPackage2 bol
pri čistení odstránený; úplný FTP tok nasadenia zatiaľ nie je obnovený.

## Oprava kompletnej úlohy

Kompletná úloha opäť používa FTP + DepRq/LoadNewPackage2, bez HALT.
Aktivačný mechanizmus je obnovený v zdroji prgMain.ST a _01_Types.ST.
Je to obsluha nasadenia, nie aplikačná JSON komunikácia.
Čítanie BuildNo opravené: readn R <bajtová adresa> 4, little-endian.
Voľba -l násobí index; predošlé tvrdenie o nesprávnej inicializácii bolo chybné.
PLC preukázateľne obsahuje V13 BuildNo=2026100901; studený štart netreba.
Aktivačný mechanizmus však v tomto bežiacom čistom V13 ešte nie je.
Jednorazové zavedenie opraveného programu cez Mosaic sa nepodarilo:
HALT hlási LSAP service is not activated aj po connect.
Kým sa opravený program nenahrá cez funkčný Mosaic prenos, kompletná úloha
skončí jasnou chybou o chýbajúcom DepRq. FTP prenos bez aktivácie je dostupný.
