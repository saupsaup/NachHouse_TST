PROGRAM prgMain
  VAR
  END_VAR

  IF passCancel THEN
    webName := myName;
    webPass := '';
    passCancel := false;
  END_IF;

  IF NOT passSet THEN
    IF LEN(webName) > 0 AND LEN(webPass) > 0 THEN //if set from web, copy values to retain
      myName := webName;
      myPass := webPass;
    END_IF;
    SetWebPSW(user := 0, name := myName, password := myPass);
    webName := myName;
    webPass := '';
    passSet := true;
  END_IF;

END_PROGRAM

