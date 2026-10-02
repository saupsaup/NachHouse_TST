PROGRAM prgMain
   // Runs initialization and one API step in every PLC cycle. SK: Spusta inicializaciu a jeden API krok v kazdom PLC cykle.
   VAR
      InitOk : BOOL; // Diagnostic result of one-time initialization. SK: Diagnosticky vysledok jednorazovej inicializacie.
      CycleOk : BOOL;// Diagnostic result of the API cycle. SK: Diagnosticky vysledok API cyklu.
   END_VAR

   // After the first cycle the function no longer overwrites authoritative data. SK: Funkcia po prvom cykle uz autoritativne data neprepisuje.
   InitOk := NhApiInitialize();
   IF InitOk THEN
      // Registry, RX, snapshot, diff and TX ACK run once per PLC cycle. SK: Registry, RX, snapshot, diff a TX ACK sa spracuju raz za PLC cyklus.
      CycleOk := NhApiCycle();
   END_IF;
END_PROGRAM
