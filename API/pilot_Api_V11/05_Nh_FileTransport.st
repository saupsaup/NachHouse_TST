// Browser-direct binary transport: PLC writes each complete NHAP frame into the inactive RAM-disk slot.
// Browser receives only NhFileFrameId over WSS and downloads one immutable binary response over HTTPS at /RAM/NACHHOUSE/.

VAR_GLOBAL
   NhFileFrameId    {PUBLIC_API} : UDINT := 0; // Commit written only after FileWrite and FileClose succeed.
   NhFileStatus     {PUBLIC_API} : USINT := 0; // 0 idle/OK, 2 open error, 3 short write, 4 close error, 5 invalid frame.
   NhFileLastBytes  {PUBLIC_API} : UINT := 0;  // Diagnostic only; authoritative length is inside the NHAP header.
   NhFileCycleCount {PUBLIC_API} : UDINT := 0; // Diagnostic proof that the publisher runs in every PLC cycle.

   NhFileInitialized            : BOOL := FALSE;
   NhFileLastPublished          : UDINT := 0;
   NhFileName                   : STRING[80];
   NhFileDirectory              : STRING[80] := '//RAM/NACHHOUSE/';
   NhFileHandle                 : HANDLE := INVALID_HANDLE_VALUE;
   NhFileWritten                : UDINT := 0;
   NhFileClosed                 : BOOL := FALSE;
END_VAR

FUNCTION NhFileTransportCycle : BOOL
   VAR_TEMP
      FrameLength : UINT;
   END_VAR

   NhFileTransportCycle := FALSE;
   NhFileCycleCount := NhFileCycleCount + 1;

   IF NOT NhFileInitialized THEN
      // DirCreate may return FALSE when the directory already exists; opening the file is the decisive check.
      DirCreate(dirName := NhFileDirectory);
      NhFileInitialized := TRUE;
   END_IF;

   IF (NhPublishedFrameId = 0) OR (NhPublishedFrameId = NhFileLastPublished) THEN
      NhFileTransportCycle := TRUE;
      RETURN;
   END_IF;

   FrameLength := UDINT_TO_UINT(NhApiReadU32(Buffer := ADR(NhApiTX), Offset := 28));
   IF (FrameLength < NH_API_HEADER_SIZE) OR (FrameLength > NH_API_TX_BYTE_CAPACITY) THEN
      NhFileStatus := 5;
      RETURN;
   END_IF;

   IF (NhPublishedFrameId MOD 2) = 0 THEN
      NhFileName := '//RAM/NACHHOUSE/nhapi-0.bin';
   ELSE
      NhFileName := '//RAM/NACHHOUSE/nhapi-1.bin';
   END_IF;

   NhFileHandle := FileOpen(fileName := NhFileName, mode := F_WRITE);
   IF NhFileHandle = INVALID_HANDLE_VALUE THEN
      NhFileStatus := 2;
      RETURN;
   END_IF;

   NhFileWritten := FileWrite(hFile := NhFileHandle, adrBuf := PTR_TO_UDINT(ADR(NhApiTX)), size := UINT_TO_UDINT(FrameLength));
   NhFileClosed := FileClose(hFile := NhFileHandle);
   NhFileHandle := INVALID_HANDLE_VALUE;

   IF NhFileWritten <> UINT_TO_UDINT(FrameLength) THEN
      NhFileStatus := 3;
      RETURN;
   END_IF;
   IF NOT NhFileClosed THEN
      NhFileStatus := 4;
      RETURN;
   END_IF;

   NhFileLastBytes := FrameLength;
   NhFileStatus := 0;
   NhFileLastPublished := NhPublishedFrameId;
   NhFileFrameId := NhPublishedFrameId; // Application-level commit: always publish last.
   NhFileTransportCycle := TRUE;
END_FUNCTION
