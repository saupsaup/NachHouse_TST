PROGRAM prgMain
  VAR
    accessTable : TWebServerAccessTable;
    i : USINT;
    t : USINT;
    test : STRING [3];
    idx : USINT;
    usage : ARRAY [1..3] OF USINT;
    logout : ARRAY [1..3] OF BOOL;
    maxUsage : USINT;
  END_VAR

  GetWebServerAccess(accessTable);
  memset(0, sizeof(usage), void(usage));

  FOR i := 0 TO 7 DO
    test := MID(accessTable[i].lastFile, 1, 3);
    idx := STRING_TO_USINT(test);
    IF accessTable[i].state = 3 AND idx >= 1 AND idx <= 3 THEN
      usage[idx] := usage[idx] + 1;
    END_IF;
  END_FOR;

  maxUsage := 255;
  t        := 1;
  FOR i := 1 TO 3 DO
    IF usage[i] < maxUsage THEN
      t := i;
      maxUsage := usage[i];
    END_IF;
  END_FOR;

  targetPage := 'M' + USINT_TO_STRING(t) + '.XML';

  FOR i := 1 TO 3 DO
    IF logout[i] AND usage[i] > 0 THEN
      pageLogout[i] := 'LOGOUT.XML';
    ELSE
      pageLogout[i] := '';
      logout[i] := false;
    END_IF;
  END_FOR;
END_PROGRAM

