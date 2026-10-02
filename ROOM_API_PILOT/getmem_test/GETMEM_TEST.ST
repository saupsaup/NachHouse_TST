(*
   GETMEM_TEST
   Independent CP-2000 project for read-only PLCComS GETMEM tests.

   The 1000-byte buffer is deliberately NOT PUBLIC_API. Only a small control
   surface is public. GETMEM reads the buffer directly from %R10000.
*)
