TYPE
  TDirViewList : ARRAY [0..15] OF STRING;
END_TYPE

FUNCTION_BLOCK fbDirBrowser
  VAR_INPUT
    up : BOOL R_EDGE;
    dn : BOOL R_EDGE;
    top : BOOL R_EDGE;
    btn : BOOL R_EDGE;
    home : BOOL R_EDGE;
    level_up : BOOL R_EDGE;
    level_dn : BOOL R_EDGE;
    homeDir : STRING;
  END_VAR
  VAR_OUTPUT
    actDir  : STRING;
    selName : STRING;
    firstIdx : UINT;
    selIdx : UINT;
    view : TDirViewList;
    error : STRING;
    beg : BOOL;
    end : BOOL;
    isDir : BOOL;
    isHome : BOOL;
  END_VAR
  VAR_IN_OUT
    selMask : WORD;
  END_VAR
  VAR
    dirInfo : TFileInfo;
    h : HANDLE;
    dirCnt : UINT;
    idx : UINT;
    readDir : BOOL;
    oldMask : WORD;
  END_VAR
  VAR_TEMP
    newDir : STRING;
    test   : STRING[1];
    slashIdx : UDINT;
    pBeg   : PTR_TO USINT;
    pEnd   : PTR_TO USINT;
  END_VAR
  
  IF selMask <> oldMask THEN
    selMask := selMask XOR oldMask;
  END_IF;
  
  selIdx := 0;
  WHILE SHR(selMask, selIdx + 1) <> 0 DO
    selIdx := selIdx + 1;
  END_WHILE;

  IF actDir = '' or home THEN
    test := RIGHT(IN := homeDir, L := 1);
    IF test = '/' THEN
      actDir := homeDir;
    ELSE
      actDir := homeDir + '/';
    END_IF;
    selIdx  := 0;
    readDir := true;
  END_IF;
  
  IF FIND(actDir, '/') <> 1 THEN
    actDir := '/' + actDir;
  END_IF;
  
  IF up & firstIdx > 0 THEN
    firstIdx := firstIdx - 1;
    readDir := true;
  END_IF;
  
  IF dn THEN
    firstIdx := firstIdx + 1;
    readDir := true;
  END_IF;
  
  IF top THEN
    firstIdx := 0;
    readDir := true;
  END_IF;
  
  IF btn THEN
    firstIdx := 65535;
    readDir := true;
  END_IF;
  
  IF level_up THEN
    pEnd := ADR(actDir) + LEN(IN := actDir) - 1;
    pBeg :=  ADR(actDir);
    slashIdx := 0;
    WHILE PTR_TO_UDINT(pBeg) < PTR_TO_UDINT(pEnd) DO
      IF pBeg^ = 47 THEN
        slashIdx := PTR_TO_UDINT(pBeg) - PTR_TO_UDINT(ADR(actDir));
      END_IF;
      pBeg := pBeg + 1;
    END_WHILE;
    newDir := LEFT(IN := actDir, L := slashIdx + 1);
    selIdx  := 0;
    IF LEN(newDir) > LEN(homeDir) THEN
      actDir := newDir;
      readDir := true;
    ELSE
      actDir := '';
    END_IF;
  END_IF;
  
  IF level_dn THEN
    IF FIND(view[selIdx], '/') > 0 THEN
      newDir := actDir + view[selIdx];
      IF FileExists(fileName := newDir) THEN
        actDir := newDir;
        selIdx  := 0;
        readDir := true;
      END_IF;
    END_IF
  END_IF;

  IF readDir THEN
    Memset(val :=  0, length := SIZEOF(view), dest := void(view));
    readDir := false;
    h := DirOpen(dirName := actDir, dirInfo := dirInfo);
    dirCnt := 0;
    IF h <> INVALID_HANDLE_VALUE THEN
      REPEAT
        dirCnt := dirCnt + 1;
      UNTIL NOT DirRead(hDir := h, dirInfo := dirInfo) END_REPEAT;
      DirClose(hDir := h);
      firstIdx := MIN(firstIdx, MAX(16,dirCnt) - 16);

      h := DirOpen(dirName := actDir, dirInfo := dirInfo);
      idx := 0;
      REPEAT
        IF firstIdx <= idx THEN
          IF idx-firstIdx < 16 THEN
            view[idx-firstIdx] := dirInfo.fileName;
          END_IF;
        END_IF;
        idx := idx + 1;
      UNTIL NOT DirRead(hDir := h, dirInfo := dirInfo) END_REPEAT;
      DirClose(hDir := h);
    ELSE
      firstIdx := 0;
      GetLastErrTxt(errCode := GetLastErr(), errMessage := error);
    END_IF;
  END_IF;

  selMask := SHL(IN := 1, N := selIdx);
  oldMask := selMask;
  
  selName := actDir + view[selIdx];

  test := RIGHT(IN := view[selIdx], L := 1);
  isDir := test = '/';
  beg := firstIdx = 0;
  end := dirCnt < 16 OR firstIdx + 16 >= dirCnt;

  test := RIGHT(IN := homeDir, L := 1);
  IF test = '/' THEN
    newDir := homeDir;
  ELSE
    newDir := homeDir + '/';
  END_IF;
  
  IF FIND(newDir, '/') <> 1 THEN
    newDir := '/' + newDir;
  END_IF;

  isHome := actDir = newDir;
  

END_FUNCTION_BLOCK

