FUNCTION_BLOCK fbMsCounter
  VAR_INPUT
    start : BOOL;       // 1 = zahajit casovani
  END_VAR
  VAR
    startTim : UDINT;
    usTim    : UDINT;
  END_VAR
  VAR_OUTPUT
    msTim  : REAL;     // cas v milisekundach
  END_VAR

begin
    {asm}
    SYS 20       ; nacist cas (jednotka je stovky mikrosekund)
    WRX usTim    ; ulozit aktualni stav
    {end_asm}
  IF start THEN
    startTim := usTim;   // zapamatovat
    msTim := 0.0;
  ELSE
    msTim := UDINT_TO_REAL(usTim - startTim) / 10.;
  END_IF;
END_FUNCTION_BLOCK

