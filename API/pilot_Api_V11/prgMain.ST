VAR_GLOBAL
   // Test PLC deployment only. Upload and verify this file before requesting activation.
   NhDeployRequest {PUBLIC_API} : BOOL := FALSE;
   NhDeployResult  {PUBLIC_API} : USINT := 0; // 0=none, 1=accepted, 2=API busy, 3=rejected
   NhDeployBuild   {PUBLIC_API} : UDINT := 2026100201;
END_VAR

PROGRAM prgMain
   // Starts the API once and advances its handshake in every PLC cycle. SK: Jednorazovo spusti API a v kazdom PLC cykle posunie jeho handshake.
   VAR_INPUT
   END_VAR
   VAR_OUTPUT
   END_VAR
   VAR
      deployStarted : BOOL := FALSE;
      deployAccepted : BOOL;
   END_VAR
   VAR_TEMP
   END_VAR

   NhApiInitialize();
   NhApiCycle();

   // Never deploy on the first cycle or repeat a request automatically.
   IF NOT deployStarted THEN
      NhDeployRequest := FALSE;
      NhDeployResult := 0;
      deployStarted := TRUE;
   ELSIF NhDeployRequest THEN
      NhDeployRequest := FALSE;
      IF NhApiInfo.State <> 0 THEN
         NhDeployResult := 2;
      ELSE
         deployAccepted := LoadNewPackage2(rq := TRUE, pckg := '//WWW/UPLOAD/NEW_PACK.TTR');
         IF deployAccepted THEN
            NhDeployResult := 1;
         ELSE
            NhDeployResult := 3;
         END_IF;
      END_IF;
   END_IF;
END_PROGRAM
