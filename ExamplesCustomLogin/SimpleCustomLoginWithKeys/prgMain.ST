PROGRAM prgMain
  VAR
    emp : STRING[1];
  END_VAR

  IF passCancel THEN
    webPass := '';
    passCancel := false;
  END_IF;

  IF NOT passSet THEN
    IF LEN(webPass) > 0 THEN //if set from web, copy values to retain
      myPass := webPass;
    END_IF;
    SetWebPSW(user := 0, name := emp, password := myPass);
    webPass := '';
    passSet := true;
  END_IF;

END_PROGRAM

