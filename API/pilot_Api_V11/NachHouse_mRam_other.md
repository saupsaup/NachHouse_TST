# poznatky pre TECO_API

Poďme to natvrdo a kriticky , pretože toto je presne ten moment, kde sa láme chleba medzi naivným IT prístupom a drsnou realitou průmyslového PLC.
Pokud chcete stavět na kombinaci {PUBLIC_API}proměnných (TecoApi) a Websocketů , narážate na obrovský architektonický konflikt s tým, jak máte navrženou paměť ( mRampole a pointery).
Zde je nekompromisná kritika, prečo tato cesta v praxi selže, alebo vás psychicky zničia :
1. Konec dynamické pamäti. TecoApi zabije vašu architektúru
TecoApi funguje tak, že premenné, ktoré chcete publikovať, musíte v ST kód označiť direktívou {PUBLIC_API}. A teraz ta tvrdá facka: TecoApi nevie pracovať s dynamicky alokovanou pamäťou cez pointery tak, jak ji máte navrženou vy.
• TecoApi potrebuje staticky definované veličiny alebo fixnú štruktúru zapísanú v kompilačnom strome Mosaicu.
• Ak v klientskej aplikácii zavoláte GET /tecoapi/getObject?name=mRam, TecoApi buď na limite veľkosti odpovedí (nezvládne poslať obří pole naráz), alebo sa vám vráti surový výpis, v ktorom klient ztratí.
• Ak by ste chceli ísť cestou TecoApi, musel by ste v ST kódu vytvoriť stovky statických premenných typu Svetlo_1, Svetlo_2atď., a každú označiť {PUBLIC_API}. Tím úplne zničíte svoju geniálnu dátovo riadenú architektúru a vrátite sa o 10 rokov späť k otrockému ručnému prepisovaniu kódu pri každej zmene.
2. TecoApi má brutální režii (Stavební bloky z blata)
TecoApi je implementované ako vrstva nad zabudovaným webserverem PLC.
• Pokazé, keď klient pošle požiadavku, TecoApi interne prekladá textové názvy premenných na fyzické pamäťové adresy , parsuje HTTP a skladá JSON text.
• Pre 10 teplomerov je to fajn. Ale pre váš systém, kde máte 200 světel, rolety a topení, je režie TecoApi na procesor CP-2000 obrovská. Ak klientská aplikácia začne posílat stovky požiadaviek za sekundu (napr. pri rýchlom skrolovaní alebo nakláňaní lamiel), zahltíte komunikačný cyklus PLC. Výsledok? Zpožděné reakcie a lagovanie celého domu.
3. Websokety na Tecu: Marketingová minulosť
Teco u rady Foxtrot 2 sice hrdě hlásí podporu Websocketů (protokol pro trvalé obousměrné spojení), ale ďábel je v detailech.
• Aby Websocket fungoval efektívne, potrebujete na strane PLC asynchrónny event-driven engine (ako má Node.js alebo Python). Lenže PLC z princípu funguje v striktnom cyklickom režime (čtení vstupov -> vykonanie ST kódu -> výstupov).
• Ak otvoríte spojenie Websocket z mobilu do Teca, PLC musí v každom cykle (ktorý trvá napríklad 10-20 ms) kontrolovať stav TCP bufferu, udržiavať spojenie a streamovať zmeny.
• Hneď sa pripojí 3 tablety na zdi a 2 mobily, CP-2000 začne páliť drahocenný procesorový čas na obsluhu sieťových zásuviek namiesto riadenia DALI zbernice a logiky.
💥 Verdikt: Prečo tudy cesta nevede?
TecoApi a integrované Websokety navrhnuté pre IT programátory, ktoré nevedia programovať v ST, nechcú si pamätať a chcú si len vytiahnuť pár promenných do Home Assistanta. Pre váš pokročilý, dátovo a pamäťovo optimalizovaný systém je to technologický regres.
🛠️ Ako to urobiť správne a moderne bez straty spoľahlivosti?
Ak chcete čisté, moderné riešenie bez pridaného hardwaru ako plný zachovania vašej mRamarchitektúry, musíte TecoApi úplne obísť a komunikovať nízkoúrovňovo:
1. Modbus TCP je kráľ: Zapomeňte na textové názvy premenných. Váš klient sa bude dotazovať priamo na adresy registrov (napr. registr 1000 = stav prvého světla). Modbus TCP server beží v Tecu na najnižšom systéme. PLC data neprekládá, neparsuje JSON, len kopíruje bloky pamäte priamo mRamdo sieťovej karty. Rýchlosť je v milisekundách a režii na CPU je téměř nulová.
2. Ako vyriešiť Websokety / dáta v reálnom čase? Udělejte to tak, jak to dělají profíci. Klient (mobilná aplikácia) sa pripojí k PLC cez Modbus TCP a bude si držať otvorené rýchle TCP spojenie. Nebude sa ptát dokola, ale vyčte si celú pamäť mRamnaráz pri štarte. Následne môže v rýchlych cykloch vyčítať len malý blok "změnových" registrov, ktoré mu v ST kódu pripravíte.
TecoApi a Websokety v podaní Teca znie moderne na papieri, ale pre vašu komplexnú architektúru je to slepá ulička, ktorá by vás stála stabilný systém.

# jednoduche, moderne RIESENIE

REST API (HTTP JSON) – Klasické spojenie klient-server
Ak vaše PLC (alebo komunikačný modul) podporuje REST API, SmartHome sa dotazuje na konkrétne adresy (URL).
• Jak to funguje: SmartHome pošle HTTP požiadavku (napr. GET /api/v1/inputs) a PLC mu odpoví čistým objektom JSON sa stavom všetkých vstupov.
• Výhoda: Jednoduché na testovanie (stačí zadať URL do prehliadača), veľmi štruktúrované.
• Nevýhoda: Synchronní – SmartHome sa musí neustále dokola pýtať (polling), či sa nezmení stav vypínače, čo môže PLC zaťažovať.

# Riešenie 1: Natívne Modbus TCP API (Primo mapované na vaše mRam)
Modbus TCP je pre vašu architektúru ako vytvorený. Umožňuje totiž namapovať Modbus register priamo na konkrétne pamäťové miesto v PLC.
• Jak to funguje: Vy v prostředí Mosaic (v tabulce síťových kanálů / Modbus profilů) poviete, že Modbus server (ktorý Teco umí sám o sobě) nebude publikovať náhodné veličiny, ale smerujete priamo na začiatok vášho pole mRam.
• Prenos dát: Akýkoli klient (vrátane TapHome , ktorý Modbus TCP natívne podporuje, alebo vaša vlastná mobilná aplikácia) pošle TCP paket: "Dej mi 100 registrov od adresy 1000" . PLC okamžite odpoví surovými dátami z pamäte.
• Dynamické zmeny, keď v konfiguraci pridáte svetlo a posunete pointery, klient (mobil/TapHome) iba dostane informáciu o novej konfigurácii (napr. stažením malého konfiguračného souboru) a ví, že rolety už nezačínajú na registri 2346, ale na 2400.
• Výhoda: Nulová režie pre CPU. PLC dáta neparsuje, nebalí do textu, proste len vezme kus pamäti mRama pošle ho po sieti.

# Riešenie 2: HTTP JSON API (Využitie zabudovaného Web Serveru pre čisté dáta)
Ak nechcete, aby klient videl surovú pamäť cez Modbus, môžete využiť vstavaný webový server v Teco CP-2000, ale úplne inak, než to robíte doteď . Namiesto generovania stránok s Canvasem sa zmeníte na REST API .
• Ako to funguje: Teco Mosaic ponúka konkrétnu webovú stránku (napr. přes soubory .xml nebo šablony v EPSNET), ktoré nevracajú HTML kód, ale čistý JSON string .
• V ST kódu: Napíšte jednoduchú funkciu, ktorá prejde vaše pointery v mRam a poskladá z nich textový reťazec vo formáte JSON (napr {"light_id": 5, "state": 1}.
• Klient (Mobil/Tablet): Už si nestahuje těžkou stránku Canvas z PLC. Klient má svoju aplikáciu uloženú priamo v sebe (native appka v telefóne alebo stiahnutá v prehliadači). Aplikácia sa len dotáže PLC na adresu http://192.168.1. PLC se vrátí lehký text JSON, a samotný telefón (jeho procesor) vykreslí modernú grafiku.
• Výhoda: Klient komunikuje štandardným webovým protokolom, ale prináša len minimálne množstvo dát.
Prečo padá možnosť TapHome?

# 🚀 Odporúčaný smer: Vlastní moderní klient + Modbus TCP alebo JSON
Pretože máte perfektne zvládnutý backend v PLC (štruktúra, pointery, dynamická pamäť), ideálna cesta pre modernizáciu bez pridania HW je:
1. Na strane PLC: Publikujte pole mRambuď cez integrovaný Modbus TCP, alebo cez zabudovaný webový server ako čistý JSON.
2. Na strane klienta (Mobil/PC): Vytvoríte (alebo si nechcete vytvoriť) aplikáciu (napr. v React Native, Flutter alebo čisté HTML/JS), ktorá sa nahrá do mobilu/tabletu. Táto aplikácia sa pripojí k PLC, vytiahne si surová dáta z pamäti a bleskovo je vykreslená v modernom designe.
Tím docílíte toho, že PLC bude robiť len to, v čom je geniálny a stoprocentne spoľahlivý (autonomní ST program, CIB zbernice, správa pamäti), a klientske zariadenia (ktoré má obrovský výkon) sa postarajú o krásne a rýchle používateľské rozhranie.


# X.MOJE ROZHODNUTIE - len princip
- moj program v PLC zisti zmeny devices
- presne vieme co sa zmenilo - vsetko je mRam[]
- z mRam posklada jednoduchy Json a ulozi ho do RAM/ . meno sa dohodneme, napr. RAM/NhTx.Json
- ked bude subor vytvoreny, bude existovat jedina premenna PUBLIC_API, ktora posle klientom DIFF
- klienti si ho nacitaju jednym get 
- to co bude vsetko tato api obsahovat, aj ako  sa bude kontrolovat, ze uz je vsetko nacitane ... neskor
- komunikaciu Rx[] - teda command vyvolany klientom - neskor 
# teraz urob
## 1.potvrd ci webserver vie urobit GET jedneho Jsona z RAM/ - to uz sme asi skusili, ked sme skusali FTP
## 2.trochu ma znepokojuje postoj inych  vyvojarov k TECO_API, ale mne sa paci DIFF - posud a daj mi tvoje odporucanie.    