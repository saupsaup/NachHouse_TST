
VAR_GLOBAL
   xx,yy,zz    : REAL;
   ok          : BOOL;
   yTx4        : STRING[255];
END_VAR

PROGRAM prgMain
  VAR_INPUT
  END_VAR
  VAR_OUTPUT
  END_VAR
  VAR
      Go    : USINT;
  END_VAR
  VAR_TEMP
  END_VAR
   CASE Go OF
      0: ;
      40:
          // Upload program
xx:=xx+1;
				ok 				:= LoadNewPackage2( rq := true, pckg := yTx4);
            IF ok THEN yy:=yy+1; END_IF;
				Go			:= 0;	

   END_CASE; 
END_PROGRAM

