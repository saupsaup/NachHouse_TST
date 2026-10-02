# GETMEM_TEST

Samostatny Mosaic projekt v skupine `ROOM_API_PILOT`. Povodny projekt
`room_api_pilot` nemeni.

## Ucel

- overit natívny PLCComS prikaz `GETMEM`,
- precitat 1000 surovych bajtov bez publikovania pola,
- overit signalizaciu noveho ramca cez malu `PUBLIC_API` plochu.

## Pamat

Buffer je pevne umiestneny:

```text
GetMemBuffer AT %R10000 : ARRAY[0..999] OF BYTE
```

Buffer nie je `PUBLIC_API`. Verejne su iba:

```text
GetMemAddress
GetMemReadCommand
GetMemLength
GetMemRevision
GetMemReady
GetMemExecute
GetMemSeed
```

## GETMEM

Natívny prikaz PLCComS:

```text
GETMEM:%R10000 1000
```

Prvych 16 bajtov:

```text
00..03  47 4D 45 4D       ASCII GMEM
04      01                format version
05      10                header length 16
06..07  D8 03             payload length 984, little-endian
08..11  revision          UDINT, little-endian
12      seed
13..15  00 00 00
```

Po starte je `GetMemRevision=1`. Zapis
`GetMemExecute=TRUE` vytvori novy obsah, zvysi seed a ako posledne zvysi
`GetMemRevision`.

## Bezpecnost

Projekt je pripraveny iba na kompilaciu a manualny test. Codex ho do PLC
neprenasa. Prenos tohto testu by docasne nahradil program bezaci v PLC.
