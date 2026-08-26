(* Upozornení *)
(* Soubor je automaticky regenerován a všechny rucní modifikace budou ztracené. *)

VAR_GLOBAL CONSTANT
   CPU_TYPE : USINT := 73; (* Typ CPU *)
   CPU_CODE : UINT := 2000; (* Kód CPU *)
   CPU_SYSTEM_ID : USINT := 18; (* System ID *)
   CPU_CPM_ID : USINT := 11; (* Cpm ID *)
   CPU_PROG_MEM_SIZE : UDINT := 1048572; (* Velikost pameti pro program *)
   CPU_RETAIN_SIZE : UDINT := 49152; (* Velikost retain zóny *)
   CPU_NOTE_R_SIZE : UDINT := 327680; (* Velikost R zóny *)
   CPU_MAX_CYCLE_TIME : UDINT := 1200; (* Maximální doba cyklu *)
END_VAR

TYPE

   DT_ITCL_DEVICES_ARRAY : ARRAY[0..7] OF BYTE;

   DT_ITCL_MODULES_ARRAY : ARRAY[0..7] OF DT_ITCL_DEVICES_ARRAY;

   DT_ITCL_DIAG : STRUCT
      STAT : DT_ITCL_MODULES_ARRAY;
      ERR : DT_ITCL_MODULES_ARRAY;
   END_STRUCT;

   DT_TCL2_ARRAY : ARRAY[0..63] OF BYTE;

   DT_TCL2_DIAG : STRUCT
      STAT : DT_TCL2_ARRAY;
      ERR : DT_TCL2_ARRAY;
   END_STRUCT;

   DT_CIB_ARRAY : ARRAY[0..31] OF BYTE;

   DT_CIB_LINE_STAT : STRUCT
      IPWR : BOOL;
      dummy1 {HIDDEN} : BOOL;
      dummy2 {HIDDEN} : BOOL;
      FUSE : BOOL;
      ECIB : BOOL;
      WCIB : BOOL;
      dummy6 {HIDDEN} : BOOL;
      dummy7 {HIDDEN} : BOOL;
      SCANE : BOOL;
      dummy9 {HIDDEN} : BOOL;
      dummy10 {HIDDEN} : BOOL;
      dummy11 {HIDDEN} : BOOL;
      dummy12 {HIDDEN} : BOOL;
      dummy13 {HIDDEN} : BOOL;
      dummy14 {HIDDEN} : BOOL;
      dummy15 {HIDDEN} : BOOL;
   END_STRUCT;

   DT_CIB_LINE : STRUCT
      STPW : DT_CIB_LINE_STAT;
      UCIB : REAL;
   END_STRUCT;

   DT_CIB_DIAG : STRUCT
      STAT : DT_CIB_ARRAY;
      ERR : DT_CIB_ARRAY;
      LINE : DT_CIB_LINE;
   END_STRUCT;

   TBIN_7DI : STRUCT
      DI0 : BOOL;
      DI1 : BOOL;
      DI2 : BOOL;
      DI3 : BOOL;
      IN230 : BOOL;
      HDO0 : BOOL;
      HDO1 : BOOL;
      dummy7 {HIDDEN} : BOOL;
   END_STRUCT;

   TBIN_4DIP : STRUCT
      DIP0 : BOOL;
      DIP1 : BOOL;
      DIP2 : BOOL;
      DIP3 : BOOL;
      dummy4 {HIDDEN} : BOOL;
      dummy5 {HIDDEN} : BOOL;
      dummy6 {HIDDEN} : BOOL;
      dummy7 {HIDDEN} : BOOL;
   END_STRUCT;

   TAIStat : STRUCT
      UNF : BOOL;
      UNR : BOOL;
      OVR : BOOL;
      OVF : BOOL;
      FLS : BOOL;
      CJC : BOOL;
      dummy6 {HIDDEN} : BOOL;
      dummy7 {HIDDEN} : BOOL;
      CHC : BOOL;
      dummy9 {HIDDEN} : BOOL;
      dummy10 {HIDDEN} : BOOL;
      dummy11 {HIDDEN} : BOOL;
      dummy12 {HIDDEN} : BOOL;
      dummy13 {HIDDEN} : BOOL;
      dummy14 {HIDDEN} : BOOL;
      dummy15 {HIDDEN} : BOOL;
   END_STRUCT;

   TAI : STRUCT
      STAT : TAIStat;
      FS : INT;
      ENG : REAL;
      PCT : REAL;
   END_STRUCT;

   TSTPW2 : STRUCT
      ACUC : BOOL;
      PWRA : BOOL;
      dummy2 {HIDDEN} : BOOL;
      dummy3 {HIDDEN} : BOOL;
      WSRC : BOOL;
      ESRC : BOOL;
      WACU : BOOL;
      EACU : BOOL;
      dummy8 {HIDDEN} : BOOL;
      dummy9 {HIDDEN} : BOOL;
      dummy10 {HIDDEN} : BOOL;
      dummy11 {HIDDEN} : BOOL;
      dummy12 {HIDDEN} : BOOL;
      dummy13 {HIDDEN} : BOOL;
      dummy14 {HIDDEN} : BOOL;
      dummy15 {HIDDEN} : BOOL;
   END_STRUCT;

   DT_IR2553_IN : STRUCT
      DIS : TBIN_7DI;
      DIP : TBIN_4DIP;
      AI0 : TAI;
      AI1 : TAI;
      AI2 : TAI;
      AI3 : TAI;
      STPW : TSTPW2;
      USRC : REAL;
      SACU : REAL;
      IACU : REAL;
   END_STRUCT;

   DT_OI2872_IN : STRUCT
      Keyb : USINT;
   END_STRUCT;

   TBIN_2DO : STRUCT
      DO0 : BOOL;
      DO1 : BOOL;
      dummy2 {HIDDEN} : BOOL;
      dummy3 {HIDDEN} : BOOL;
      dummy4 {HIDDEN} : BOOL;
      dummy5 {HIDDEN} : BOOL;
      dummy6 {HIDDEN} : BOOL;
      dummy7 {HIDDEN} : BOOL;
   END_STRUCT;

   DT_IR2553_OUT : STRUCT
      DOS : TBIN_2DO;
   END_STRUCT;

   TVideoRamArray : ARRAY[0..79] OF USINT;

   DT_OI2872_OUT : STRUCT
      VideoRam : TVideoRamArray;
      CodePage : UINT;
   END_STRUCT;

END_TYPE

VAR_GLOBAL_INPUT
(* CP-2000 *)
   r0_p0_ITCL_DIAG : DT_ITCL_DIAG;
   r16_p1_TCL2_DIAG : DT_TCL2_DIAG;
   r16_p1_CIB_DIAG : DT_CIB_DIAG;
   r16_p2_CIB_DIAG : DT_CIB_DIAG;
   r16_p6_IO_IN : DT_IR2553_IN;
   r16_p7_DISP_IN : DT_OI2872_IN;
   (* Aliases *)
   IOP_OI_STAT AT r0_p0_ITCL_DIAG.STAT[7];
   IOP_OI_SysUsb_STAT AT r0_p0_ITCL_DIAG.STAT[7,3];
   IOP_OI_UsrDisp_STAT AT r0_p0_ITCL_DIAG.STAT[7,2];
   IOP_OI_SysDisp_STAT AT r0_p0_ITCL_DIAG.STAT[7,1];
   IOP_IR_STAT AT r0_p0_ITCL_DIAG.STAT[6];
   IOP_IR_IO_STAT AT r0_p0_ITCL_DIAG.STAT[6,1];
   IOP_PGB2_STAT AT r0_p0_ITCL_DIAG.STAT[5];
   IOP_PGB2_PORT2_STAT AT r0_p0_ITCL_DIAG.STAT[5,2];
   IOP_PGB2_PORT1_STAT AT r0_p0_ITCL_DIAG.STAT[5,1];
   IOP_PGB1_STAT AT r0_p0_ITCL_DIAG.STAT[4];
   IOP_PGB1_PORT2_STAT AT r0_p0_ITCL_DIAG.STAT[4,2];
   IOP_PGB1_PORT1_STAT AT r0_p0_ITCL_DIAG.STAT[4,1];
   IOP_SX2_STAT AT r0_p0_ITCL_DIAG.STAT[2];
   IOP_SX2_CIB_STAT AT r0_p0_ITCL_DIAG.STAT[2,2];
   IOP_SX2_TCL2_STAT AT r0_p0_ITCL_DIAG.STAT[2,1];
   IOP_SX1_STAT AT r0_p0_ITCL_DIAG.STAT[1];
   IOP_SX1_CIB_STAT AT r0_p0_ITCL_DIAG.STAT[1,2];
   IOP_SX1_TCL2_STAT AT r0_p0_ITCL_DIAG.STAT[1,1];
   IOP_OI_ERR AT r0_p0_ITCL_DIAG.ERR[7];
   IOP_OI_SysUsb_ERR AT r0_p0_ITCL_DIAG.ERR[7,3];
   IOP_OI_UsrDisp_ERR AT r0_p0_ITCL_DIAG.ERR[7,2];
   IOP_OI_SysDisp_ERR AT r0_p0_ITCL_DIAG.ERR[7,1];
   IOP_IR_ERR AT r0_p0_ITCL_DIAG.ERR[6];
   IOP_IR_IO_ERR AT r0_p0_ITCL_DIAG.ERR[6,1];
   IOP_PGB2_ERR AT r0_p0_ITCL_DIAG.ERR[5];
   IOP_PGB2_PORT2_ERR AT r0_p0_ITCL_DIAG.ERR[5,2];
   IOP_PGB2_PORT1_ERR AT r0_p0_ITCL_DIAG.ERR[5,1];
   IOP_PGB1_ERR AT r0_p0_ITCL_DIAG.ERR[4];
   IOP_PGB1_PORT2_ERR AT r0_p0_ITCL_DIAG.ERR[4,2];
   IOP_PGB1_PORT1_ERR AT r0_p0_ITCL_DIAG.ERR[4,1];
   IOP_SX2_ERR AT r0_p0_ITCL_DIAG.ERR[2];
   IOP_SX2_CIB_ERR AT r0_p0_ITCL_DIAG.ERR[2,2];
   IOP_SX2_TCL2_ERR AT r0_p0_ITCL_DIAG.ERR[2,1];
   IOP_SX1_ERR AT r0_p0_ITCL_DIAG.ERR[1];
   IOP_SX1_CIB_ERR AT r0_p0_ITCL_DIAG.ERR[1,2];
   IOP_SX1_TCL2_ERR AT r0_p0_ITCL_DIAG.ERR[1,1];
END_VAR

VAR_GLOBAL_OUTPUT
(* CP-2000 *)
   r0_p0_ITCL_CONTROL : UINT;
   r16_p1_TCL2_CONTROL : UINT;
   r16_p1_CIB_CONTROL : UINT;
   r16_p2_CIB_CONTROL : UINT;
   r16_p6_IO_OUT : DT_IR2553_OUT;
   r16_p7_DISP_OUT : DT_OI2872_OUT;
END_VAR

VAR_GLOBAL
END_VAR

VAR_EXTERNAL
END_VAR



(* ******************************************************************************* *)
(* Generováno programem Mosaic *)
(* © 2001-2025 Teco a.s. *)
