// NaplnÌ testovacie z·znamy a jednorazovo ich skopÌruje do mRam. ; Populate test records and copy them into mRam once.
// Pri prvom cykle vytvorÌ testovacie ROOM/USER d·ta a skopÌruje ich do mRam ; On the first cycle, creates test ROOM/USER data and copies it into mRam.
FUNCTION InitData : BOOL
  VAR
    Rec    : INT;    // Index testovanej vety 1..10 ; Test record index, 1..10.
    Pos    : INT;    // Index prvku vn˙tornÈho poæa pouûÌvateæa ; Index into a nested user array.
    Copied : UDINT;  // PoËet bajtov skutoËne skopÌrovan˝ch funkciou MemCpyPtr ; Number of bytes actually copied by MemCpyPtr.
  END_VAR
  InitData := TRUE;
  // Inicializ·ciu vykon· iba pri ötartovacej hodnote Ini ; Initialize only when Ini has its startup value.
  IF aSys.Ini <> 250 THEN RETURN; END_IF;

  // Naplnenie desiatich testovacÌch viet oboch typov ; Fill ten test records for both data types.
  FOR Rec := 1 TO 10 DO
    yRooms[Rec].mem.rec.Ok := TRUE;  // ZaËiatok naplnenia stavovej a konfiguraËnej Ëasti aktu·lnej miestnosti ; Begin filling the current room's state and configuration.
    yRooms[Rec].mem.rec.ID := Rec;
    yRooms[Rec].mem.all.RoomID := Rec;
    yRooms[Rec].mem.all.CategoryID := 5;
    yRooms[Rec].mem.Temperature := 20.0 + INT_TO_REAL(Rec);
    yRooms[Rec].mem.Humidity := 40.0 + INT_TO_REAL(Rec);
    yRooms[Rec].mem.Presence := (Rec MOD 2) = 0;
    yRooms[Rec].mem.DayPhase := INT_TO_UINT(140 + Rec);
    yRooms[Rec].mem.CategoryMask := 16#00000005;
    yRooms[Rec].mem.AlarmLevel := INT_TO_USINT(Rec MOD 3);
    yRooms[Rec].mem.Online := TRUE;
    yRooms[Rec].mem.Twilight := (Rec MOD 2) <> 0;
    yRooms[Rec].cfg.Name := 'Test room';
    yRooms[Rec].cfg._Dint := INT_TO_DINT(-1000 - Rec);
    yRooms[Rec].cfg._Sint := INT_TO_SINT(-10 + Rec);
    yRooms[Rec].cfg._Usint := INT_TO_USINT(100 + Rec);
    yRooms[Rec].cfg._Uint := INT_TO_UINT(1000 + Rec);
    yRooms[Rec].cfg._Real := 10.5 + INT_TO_REAL(Rec);
    yRooms[Rec].cfg._LReal := 1000.5 + INT_TO_LREAL(Rec);
    yRooms[Rec].cfg._String := '';
    yRooms[Rec].cfg._StringCZSK := 'SVKBEGIN_+æöËùû˝·ÌÈ_SVKEND';
    yRooms[Rec].cfg._BYTE := 16#A5; yRooms[Rec].cfg._WORD := 16#A55A;
    yRooms[Rec].cfg._TIME := T#12h34m56s789ms;
    yRooms[Rec].cfg._DATE := D#2026-10-07;
    yRooms[Rec].cfg._TIME_OF_DAY := TOD#12:34:56.789;
    yRooms[Rec].cfg._DATE_AND_TIME := DT#2026-10-07-12:34:56.789;

    yUsers[Rec].mem.rec.Ok := TRUE; yUsers[Rec].mem.rec.ID := Rec;  // ZaËiatok naplnenia aktu·lnej testovacej vety USER ; Begin filling the current USER test record.
    yUsers[Rec].mem.all.RoomID := Rec; yUsers[Rec].mem.all.CategoryID := 1;
    yUsers[Rec].mem.Connected := (Rec MOD 2) = 0;
    yUsers[Rec].mem.LastError := '';
    yUsers[Rec].mem.LastUpdate := UDINT#2026100700 + INT_TO_UDINT(Rec);
    yUsers[Rec].cfg.Name := 'Test user'; yUsers[Rec].cfg.LoginHome := TRUE;
    yUsers[Rec].cfg.DshSet := FALSE; yUsers[Rec].cfg.OwnDSH := TRUE;
    yUsers[Rec].cfg.OwnQCK := TRUE;
    yUsers[Rec].cfg.UsrRight := INT_TO_USINT(1 + (Rec MOD 3));
    // ZÛnovÈ opr·vnenia sa menia podæa ËÌsla testovacej vety ; Zone permissions vary with the test-record number.
    FOR Pos := 1 TO 16 DO yUsers[Rec].cfg.ZonList[Pos] := Pos <= (Rec + 1); END_FOR;
    yUsers[Rec].cfg.sbj := INT_TO_USINT(Rec);
    yUsers[Rec].cfg.lng := INT_TO_USINT(Rec MOD 2);
    FOR Pos := 0 TO 7 DO
      yUsers[Rec].cfg.fav[Pos] := INT_TO_USINT(Pos + Rec);
      yUsers[Rec].cfg.msg[Pos] := Pos = (Rec MOD 8);
    END_FOR;
    yUsers[Rec].cfg.keyPas := '123456'; yUsers[Rec].cfg.IPnbr := 1;
    yUsers[Rec].cfg.IP[1] := '192.168.33.10';
    yUsers[Rec].cfg.IP[2] := ''; yUsers[Rec].cfg.IP[3] := '';
    yUsers[Rec].cfg.mail := 'test@example.com';
    yUsers[Rec].cfg.TOKENAPPLE := 'apple-test-token';
    yUsers[Rec].cfg.TOKENUNI := 'uni-test-token';
    yUsers[Rec].cfg.gsm := '+421900000000';
    yUsers[Rec].cfg.skin := INT_TO_USINT(Rec MOD 2);
    FOR Pos := 0 TO 30 DO
      IF Pos = 0 THEN yUsers[Rec].cfg.Brw[Pos] := 0;
      ELSE yUsers[Rec].cfg.Brw[Pos] := 1;
      END_IF;
    END_FOR;
  END_FOR;

  aCfg[1].iRam := 0;  // ROOM zaber· prv˙ oblasù mRam od bajtu nula ; ROOM occupies the first mRam region starting at byte zero.
  aCfg[2].iRam := aCfg[1].Siz * aCfg[1].Rec;  // USER oblasù zaËÌna bezprostredne za vöetk˝mi vetami ROOM ; USER starts immediately after all ROOM records.
  xRoom := ADR(mRam[aCfg[1].iRam]);  // VypoËÌta ukazovateæ na prv˙ ROOM vetu ; Calculate a pointer to the first ROOM record.
  xUser := ADR(mRam[aCfg[2].iRam]);  // VypoËÌta ukazovateæ na prv˙ USER vetu ; Calculate a pointer to the first USER record.
  aCfg[1].Ram := PTR_TO_UDINT(xRoom);  // UloûÌ absol˙tnu adresu ROOM oblasti pre adresovanie schÈmou ; Store the ROOM base address for schema-based access.
  aCfg[2].Ram := PTR_TO_UDINT(xUser);  // UloûÌ absol˙tnu adresu USER oblasti pre adresovanie schÈmou ; Store the USER base address for schema-based access.
  Copied := MemCpyPtr(source := ADR(yRooms[1]), dest := xRoom, length := aCfg[1].Siz * aCfg[1].Rec);  // SkopÌruje vöetk˝ch desaù testovacÌch miestnostÌ do s˙vislej oblasti mRam ; Copy all ten test rooms into their contiguous mRam region.
  aCfg[1].ok := Copied = aCfg[1].Siz * aCfg[1].Rec;
  Copied := MemCpyPtr(source := ADR(yUsers[1]), dest := xUser, length := aCfg[2].Siz * aCfg[2].Rec);  // SkopÌruje vöetk˝ch desaù testovacÌch pouûÌvateæov do mRam ; Copy all ten test users into mRam.
  aCfg[2].ok := Copied = aCfg[2].Siz * aCfg[2].Rec;
  aSys.Restart := FALSE;  // OznaËÌ dokonËenie ötartovacej inicializ·cie ; Mark startup initialization as complete.
  aSys.Ini := 0;  // Zabr·ni op‰tovnÈmu naplneniu testovacÌch d·t v ÔalöÌch cykloch ; Prevent test data from being initialized again in later cycles.
END_FUNCTION
