# ROOM_API_PILOT – V11.2.2 LOAD_800

## Výsledok

Test prešiel na reálnom PLC `192.168.33.200`, build `2026100221`, API V11,
projekt V2.2.0.0. Po testoch zostalo PLC v RUN, `State=0`,
`OwnerClientId=0`, `ERH=false`, `ERS=false` a modelové dáta boli obnovené.

## Model

Použitých bolo 800 kompaktných modelových zariadení:

| Rozsah | Druh | Počet | Zmena pri scéne „odchod“ |
|---:|---|---:|---|
| 1–300 | svetlá | 300 | vypnúť |
| 301–420 | rolety | 120 | zatvoriť |
| 421–520 | kúrenie | 100 | nastaviť 17,0 °C |
| 521–600 | klimatizácia | 80 | nastaviť 18,0 °C |
| 601–640 | voda | 40 | vypnúť |
| 641–800 | snímače | 160 | bez zmeny, kontrolná skupina |

Scéna teda zmenila 640 z 800 zariadení v jednom PLC cykle. Pôvodný room
model (30 miestností) zostal nezmenený.

## Hraničný scenár

Scenár bol vykonaný dvakrát, zakaždým s tromi variantmi pripojenia:

- dvaja klienti boli pripojení pred spustením;
- piatim logickým klientom sa odoslala správa „zamykam...“;
- dvaja z nich sa pripojili po 0, 100 alebo 500 ms;
- po každom variante sa vykonala úplná obnova normálneho stavu.

Výsledok šiestich behov:

| Metrika | Nameraná hodnota |
|---|---:|
| zmenené zariadenia | 640/640 |
| zmeny prijaté každým vopred pripojeným klientom | 640/640 |
| prvá prijatá zmena | 243–499 ms |
| posledná prijatá zmena | 5,18–7,17 s |
| potvrdenie vykonania scény klientovi | 5,25–7,22 s |
| interné vykonanie scény v PLC | menej než 1 ms (meranie vrátilo 0 ms) |
| obnova 640 zariadení | 5,21–6,98 s |
| neskoro pripojení klienti | vždy načítali správnych 800/800 hodnôt |
| strata alebo nesprávna hodnota | 0 |

Úzkym miestom nebolo vykonanie logiky v PLC. Čas spotreboval postupný prenos
640 samostatných natívnych PLCComS zmien ku klientom.

## Bežná prevádzka

Test použil deväť pripojených klientov: päť aktívnych a štyroch pasívnych.
Päť aktívnych klientov naraz zmenilo päť rôznych miestností cez spoločný
handshake API V11. Test bol vykonaný dvakrát, teda spolu desať zápisov a
desať následných obnovovacích zápisov.

| Metrika | Nameraná hodnota |
|---|---:|
| úspešné zápisy | 10/10 |
| úspešné obnovy | 10/10 |
| chyba alebo timeout | 0 |
| latencia jednotlivých zápisov | 1,57–7,76 s |
| p95/p99 v päťklientskom súbehu | 7,76 s |
| dokončenie celej skupiny piatich | 7,29–7,76 s |
| úplný snapshot 30 miestností | 7,22–8,89 s |

Zápisy sa podľa návrhu API V11 vykonali postupne. Súbeh piatich klientov
nespôsobil poškodenie dát ani uviaznutie vlastníka, ale posledný klient čakal
približne päťnásobok latencie jednej transakcie.

## Odporúčanie

1. Scénu „odchod“ možno v PLC vykonať naraz; samotná zmena 640 kompaktných
   stavov PLC nepreťažila.
2. Správu „zamykam...“ treba odoslať ešte pred vykonaním scény. Klient nemá
   čakať na prijatie všetkých individuálnych diffov, aby zobrazil priebeh.
3. Po reconnecte alebo neskorom otvorení musí klient načítať aktuálny stav;
   nesmie predpokladať, že zachytil všetky best-effort diffy.
4. Pre produkciu odporúčam k hromadnej scéne publikovať aj jedno malé pole
   `SceneSequence/SceneState`. Klient tak vie okamžite potvrdiť začiatok a
   koniec, kým jednotlivé zariadenia sa dosynchronizujú na pozadí.
5. Ak sa požaduje úplná synchronizácia 640 zariadení pod 2 sekundy, jednotlivé
   PUBLIC_API diffy nestačia. Treba použiť dávkový binárny rámec alebo viac
   zmien zabaliť do jedného záznamu.
6. Päť aktívnych klientov potrebuje spoločnú poradovú frontu v aplikačnej
   bráne. Súčasný jediný mailbox je dátovo bezpečný, ale p95 približne 7,8 s
   je vysoké pre interaktívne ovládanie.

## Reprodukcia

Vo VS Code je dostupná úloha `PLC: Run LOAD 800 tests`. Test pri každej chybe
vykoná núdzovú obnovu, overí všetkých 800 hodnôt a na konci vyžaduje
`State=0`, `OwnerClientId=0` a neaktívnu scénu odchod.
