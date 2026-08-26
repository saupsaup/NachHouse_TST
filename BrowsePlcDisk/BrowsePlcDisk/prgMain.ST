  VAR_GLOBAL
//    mDirSelMask : WORD;
//    mDirBrowser : fbDirBrowser;
  END_VAR

PROGRAM prgMain
  VAR_INPUT
  END_VAR
  VAR_OUTPUT
  END_VAR
  VAR
    DirSelMask : WORD;
    DirBrowser : fbDirBrowser;
  END_VAR
  VAR_TEMP
  END_VAR
  
  DirBrowser(selMask := DirSelMask);

END_PROGRAM

