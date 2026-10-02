# GETMEM browser test

Minimálny read-only test spojenia WSS revision signálu s natívnym PLCComS
`GETMEM`.

```text
browser GET /api/getmem
        -> server.js
        -> TCP 192.168.33.200:5010
        -> GETMEM:%R1000 1000
        <- 1000 B
        <- application/octet-stream
```

Browser súčasne používa priame spojenie
`wss://192.168.33.200:5030/` so subprotokolom `raw`:

```text
WSS get GETMEMREVISION -> počiatočný GETMEM snapshot
WSS diff GETMEMREVISION -> automatický GETMEM refresh
```

Most je úmyselne pevný:

- počúva iba na `127.0.0.1:8765`,
- podporuje iba HTTP `GET /api/getmem`,
- číta iba `%R1000`, presne `1000` bajtov,
- neposkytuje všeobecný PLCComS tunel ani zápisové príkazy.

## Spustenie

Vyžaduje Node.js 18 alebo novší. Nie je potrebné nič inštalovať.

```sh
cd /Users/pambm3/NachHouse/TST/ROOM_API_PILOT/getmem_test/browser_test
node server.js
```

Potom otvoriť:

```text
http://127.0.0.1:8765
```

Stránka sa pokúsi pripojiť WSS automaticky. Po úvodnom `get` načíta binárny
snapshot. Každý nový `diff` pre `GETMEMREVISION` automaticky zopakuje GETMEM.
Tlačidlo **Načítať GETMEM ručne** zostáva na samostatné testovanie mosta.

Ak browser odmietne WSS spojenie, treba v systéme/browseri dôveryhodne
nakonfigurovať certifikát PLC. Test certifikačné chyby neobchádza.
