(* Upozornení *)
(* Soubor je automaticky regenerován a všechny rucní modifikace budou ztracené. *)

VAR_GLOBAL CONSTANT
   CPU_TYPE : USINT := 73; (* CPU type *)
   CPU_CODE : UINT := 2000; (* CPU code *)
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

   DT_ETCL_PORTS_ARRAY : ARRAY[0..3] OF BYTE;

   DT_ETCL_MODULES_ARRAY : ARRAY[0..15] OF DT_ETCL_PORTS_ARRAY;

   DT_ETCL_SEG_ARRAY : ARRAY[0..1] OF DT_ETCL_MODULES_ARRAY;

   DT_ETCL_DIAG : STRUCT
      STAT : DT_ETCL_SEG_ARRAY;
      ERR : DT_ETCL_SEG_ARRAY;
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

{$IFNDEF TStatC_DL_0012S}
   TStatC_DL_0012S : STRUCT
      dummy0 {HIDDEN} : BOOL;
      dummy1 {HIDDEN} : BOOL;
      RNDOK : BOOL;
      SHS : BOOL;
      RRE : BOOL;
      RRF : BOOL;
      DONE : BOOL;
      ARC : BOOL;
   END_STRUCT;
{$END_IF}

{$IFNDEF tC_DL_0012Sin}
   tC_DL_0012Sin : STRUCT
      STAT : TStatC_DL_0012S;
      DATA : USINT;
   END_STRUCT;
{$END_IF}

{$IFNDEF TContC_DL_0012S}
   TContC_DL_0012S : STRUCT
      LENM : BOOL;
      DBL : BOOL;
      RNDS : BOOL;
      CHS : BOOL;
      dummy4 {HIDDEN} : BOOL;
      dummy5 {HIDDEN} : BOOL;
      TRG : BOOL;
      ACN : BOOL;
   END_STRUCT;
{$END_IF}

{$IFNDEF tC_DL_0012Sout}
   tC_DL_0012Sout : STRUCT
      CONT : TContC_DL_0012S;
      ADDRESS : USINT;
      COMMAND : USINT;
      DATA : USINT;
   END_STRUCT;
{$END_IF}

   TCIB_DI5T : STRUCT
      DI1 : BOOL;
      DI2 : BOOL;
      DI3 : BOOL;
      DI4 : BOOL;
      DI5 : BOOL;
      dummy5 {HIDDEN} : BOOL;
      dummy6 {HIDDEN} : BOOL;
      dummy7 {HIDDEN} : BOOL;
      TAMPER1 : BOOL;
      TAMPER2 : BOOL;
      TAMPER3 : BOOL;
      TAMPER4 : BOOL;
      TAMPER5 : BOOL;
      dummy13 {HIDDEN} : BOOL;
      dummy14 {HIDDEN} : BOOL;
      dummy15 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_AI5_STAT : STRUCT
      OUF1 : BOOL;
      VLD1 : BOOL;
      OUF2 : BOOL;
      VLD2 : BOOL;
      OUF3 : BOOL;
      VLD3 : BOOL;
      OUF4 : BOOL;
      VLD4 : BOOL;
      OUF5 : BOOL;
      VLD5 : BOOL;
      dummy10 {HIDDEN} : BOOL;
      dummy11 {HIDDEN} : BOOL;
      dummy12 {HIDDEN} : BOOL;
      dummy13 {HIDDEN} : BOOL;
      dummy14 {HIDDEN} : BOOL;
      dummy15 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_AI4 : STRUCT
      AI1 : REAL;
      AI2 : REAL;
      AI3 : REAL;
      AI4 : REAL;
   END_STRUCT;

   TCIB_C_IT_0504S_IN : STRUCT
      DI : TCIB_DI5T;
      STAT : TCIB_AI5_STAT;
      AI : TCIB_AI4;
      AI5 : REAL;
   END_STRUCT;

   TCIB_AO4 : STRUCT
      AO1 : REAL;
      AO2 : REAL;
      AO3 : REAL;
      AO4 : REAL;
   END_STRUCT;

   TCIB_C_IT_0504S_OUT : STRUCT
      AO : TCIB_AO4;
   END_STRUCT;

   TCIB_COR_STAT : STRUCT
      dummy0 {HIDDEN} : BOOL;
      dummy1 {HIDDEN} : BOOL;
      dummy2 {HIDDEN} : BOOL;
      dummy3 {HIDDEN} : BOOL;
      dummy4 {HIDDEN} : BOOL;
      ExtPower {HIDDEN} : BOOL;
      ManMode : BOOL;
      PowerErr : BOOL;
   END_STRUCT;

   TCIB_C_OR_0011M_800_IN : STRUCT
      STAT : TCIB_COR_STAT;
   END_STRUCT;

   TCIB_DO11 : STRUCT
      DO1 : BOOL;
      DO2 : BOOL;
      DO3 : BOOL;
      DO4 : BOOL;
      DO5 : BOOL;
      DO6 : BOOL;
      DO7 : BOOL;
      DO8 : BOOL;
      DO9 : BOOL;
      DO10 : BOOL;
      DO11 : BOOL;
      dummy11 {HIDDEN} : BOOL;
      dummy12 {HIDDEN} : BOOL;
      dummy13 {HIDDEN} : BOOL;
      dummy14 {HIDDEN} : BOOL;
      dummy15 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_C_OR_0011M_800_OUT : STRUCT
      DOs : TCIB_DO11;
   END_STRUCT;

   TCIB_CJC_STAT : STRUCT
      WD1 : BOOL;
      WD2 : BOOL;
      WD3 : BOOL;
      WD4 : BOOL;
      WD5 : BOOL;
      WD6 : BOOL;
      ManMode : BOOL;
      dummy7 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_C_JC_0006M_IN : STRUCT
      STAT : TCIB_CJC_STAT;
   END_STRUCT;

   TCIB_CJC : STRUCT
      DO1u : BOOL;
      DO1d : BOOL;
      DO2u : BOOL;
      DO2d : BOOL;
      DO3u : BOOL;
      DO3d : BOOL;
      DO4u : BOOL;
      DO4d : BOOL;
      DO5u : BOOL;
      DO5d : BOOL;
      DO6u : BOOL;
      DO6d : BOOL;
      dummy12 {HIDDEN} : BOOL;
      dummy13 {HIDDEN} : BOOL;
      dummy14 {HIDDEN} : BOOL;
      dummy15 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_C_JC_0006M_OUT : STRUCT
      DOs : TCIB_CJC;
      PD1 : USINT;
      PD2 : USINT;
      PD3 : USINT;
      PD4 : USINT;
      PD5 : USINT;
      PD6 : USINT;
   END_STRUCT;

{$IFNDEF TCIB_RFID}
   TCIB_RFID : ARRAY[0..7] OF BYTE;
{$END_IF}

{$IFNDEF TCIB_CKY0001R_DI}
   TCIB_CKY0001R_DI : STRUCT
      DI1 : BOOL;
      DI2 : BOOL;
      CLICK_DI1 : BOOL;
      CLICK_DI2 : BOOL;
      PRESS_DI1 : BOOL;
      PRESS_DI2 : BOOL;
      TAMPER1 : BOOL;
      TAMPER2 : BOOL;
   END_STRUCT;
{$END_IF}

{$IFNDEF TCIB_CKY0001R_STAT}
   TCIB_CKY0001R_STAT : STRUCT
      OUFT : BOOL;
      VLDT : BOOL;
      OUF1 : BOOL;
      VLD1 : BOOL;
      OUF2 : BOOL;
      VLD2 : BOOL;
      dummy6 {HIDDEN} : BOOL;
      dummy7 {HIDDEN} : BOOL;
   END_STRUCT;
{$END_IF}

{$IFNDEF TCIB_C_KY_0001R_IN}
   TCIB_C_KY_0001R_IN : STRUCT
      BUTTONS : BYTE;
      RF_CODE : TCIB_RFID;
      DI : TCIB_CKY0001R_DI;
      STAT : TCIB_CKY0001R_STAT;
      THERM : REAL;
      AI1 : REAL;
      AI2 : REAL;
   END_STRUCT;
{$END_IF}

{$IFNDEF TCIB_C_KY_0001R_OUT}
   TCIB_C_KY_0001R_OUT : STRUCT
      SETT : BYTE;
      ICONS : BYTE;
      TIM : INT;
      TEXT1 : STRING[16];
      TEXT2 : STRING[16];
   END_STRUCT;
{$END_IF}

   TCIB_CWS2LO_BTN : STRUCT
      UP1 : BOOL;
      DOWN1 : BOOL;
      dummy2 {HIDDEN} : BOOL;
      dummy3 {HIDDEN} : BOOL;
      DI1 : BOOL;
      DI2 : BOOL;
      dummy6 {HIDDEN} : BOOL;
      dummy7 {HIDDEN} : BOOL;
      CLICK_UP1 : BOOL;
      CLICK_DOWN1 : BOOL;
      dummy10 {HIDDEN} : BOOL;
      dummy11 {HIDDEN} : BOOL;
      CLICK_DI1 : BOOL;
      CLICK_DI2 : BOOL;
      dummy14 {HIDDEN} : BOOL;
      dummy15 {HIDDEN} : BOOL;
      PRESS_UP1 : BOOL;
      PRESS_DOWN1 : BOOL;
      dummy18 {HIDDEN} : BOOL;
      dummy19 {HIDDEN} : BOOL;
      PRESS_DI1 : BOOL;
      PRESS_DI2 : BOOL;
      dummy22 {HIDDEN} : BOOL;
      dummy23 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_CWSLo_STAT : STRUCT
      iOUF : BOOL;
      iVLD : BOOL;
      OUF1 : BOOL;
      VLD1 : BOOL;
      OUF2 : BOOL;
      VLD2 : BOOL;
      dummy6 {HIDDEN} : BOOL;
      dummy7 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_C_WS_0200R_Logus_IN : STRUCT
      DI : TCIB_CWS2LO_BTN;
      STAT : TCIB_CWSLo_STAT;
      THERM : REAL;
      AI1 : REAL;
      AI2 : REAL;
   END_STRUCT;

   TCIB_WSB_LED2 : STRUCT
      GREEN1 : BOOL;
      RED1 : BOOL;
      dummy2 {HIDDEN} : BOOL;
      dummy3 {HIDDEN} : BOOL;
      dummy4 {HIDDEN} : BOOL;
      dummy5 {HIDDEN} : BOOL;
      dummy6 {HIDDEN} : BOOL;
      dummy7 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_C_WS_0200R_Logus_OUT : STRUCT
      LED : TCIB_WSB_LED2;
   END_STRUCT;

   TCIB_BTN2_CJC : STRUCT
      DI1 : BOOL;
      DI2 : BOOL;
      CLICK1 : BOOL;
      CLICK2 : BOOL;
      PRESS1 : BOOL;
      PRESS2 : BOOL;
      dummy6 {HIDDEN} : BOOL;
      WD : BOOL;
   END_STRUCT;

   TCIB_C_JC_0201B_IN : STRUCT
      DI : TCIB_BTN2_CJC;
   END_STRUCT;

   TCIB_DO2_CJC : STRUCT
      DO1u : BOOL;
      DO1d : BOOL;
      dummy2 {HIDDEN} : BOOL;
      dummy3 {HIDDEN} : BOOL;
      dummy4 {HIDDEN} : BOOL;
      dummy5 {HIDDEN} : BOOL;
      dummy6 {HIDDEN} : BOOL;
      dummy7 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_C_JC_0201B_OUT : STRUCT
      DOs : TCIB_DO2_CJC;
      PD1 : USINT;
   END_STRUCT;

   TCIB_BTN_DI2 : STRUCT
      DI1 : BOOL;
      DI2 : BOOL;
      CLICK1 : BOOL;
      CLICK2 : BOOL;
      PRESS1 : BOOL;
      PRESS2 : BOOL;
      dummy6 {HIDDEN} : BOOL;
      dummy7 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_CWSPG_STAT : STRUCT
      OUF1 : BOOL;
      VLD1 : BOOL;
      OUF2 : BOOL;
      VLD2 : BOOL;
      OUFT : BOOL;
      VLDT : BOOL;
      OUFR : BOOL;
      VLDR : BOOL;
   END_STRUCT;

   TCIB_C_WS_0000R_PG_BTN : STRUCT
      BTN1 : BOOL;
      BTN2 : BOOL;
      BTN3 : BOOL;
      BTN4 : BOOL;
      BTN5 : BOOL;
      BTN6 : BOOL;
      BTN7 : BOOL;
      BTN8 : BOOL;
      BTN9 : BOOL;
      BTN10 : BOOL;
      BTN11 : BOOL;
      BTN12 : BOOL;
      dummy12 {HIDDEN} : BOOL;
      dummy13 {HIDDEN} : BOOL;
      dummy14 {HIDDEN} : BOOL;
      PR : BOOL;
   END_STRUCT;

   TCIB_C_WS_0000R_PG_CLICK : STRUCT
      CLICKB1 : BOOL;
      CLICKB2 : BOOL;
      CLICKB3 : BOOL;
      CLICKB4 : BOOL;
      CLICKB5 : BOOL;
      CLICKB6 : BOOL;
      CLICKB7 : BOOL;
      CLICKB8 : BOOL;
      CLICKB9 : BOOL;
      CLICKB10 : BOOL;
      CLICKB11 : BOOL;
      CLICKB12 : BOOL;
      dummy12 {HIDDEN} : BOOL;
      dummy13 {HIDDEN} : BOOL;
      dummy14 {HIDDEN} : BOOL;
      dummy15 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_C_WS_0000R_PG_PRESS : STRUCT
      PRESSB1 : BOOL;
      PRESSB2 : BOOL;
      PRESSB3 : BOOL;
      PRESSB4 : BOOL;
      PRESSB5 : BOOL;
      PRESSB6 : BOOL;
      PRESSB7 : BOOL;
      PRESSB8 : BOOL;
      PRESSB9 : BOOL;
      PRESSB10 : BOOL;
      PRESSB11 : BOOL;
      PRESSB12 : BOOL;
      dummy12 {HIDDEN} : BOOL;
      dummy13 {HIDDEN} : BOOL;
      dummy14 {HIDDEN} : BOOL;
      dummy15 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_C_WS_0000R_PG_BTNs : STRUCT
      BTN : TCIB_C_WS_0000R_PG_BTN;
      CLICK : TCIB_C_WS_0000R_PG_CLICK;
      PRESS : TCIB_C_WS_0000R_PG_PRESS;
   END_STRUCT;

   TCIB_C_WS_0000R_PG_GLASSI : STRUCT
      BTNs : TCIB_C_WS_0000R_PG_BTNs;
      IDENT : BYTE;
   END_STRUCT;

   TCIB_C_WS_0000R_PG_IN : STRUCT
      DI : TCIB_BTN_DI2;
      STAT : TCIB_CWSPG_STAT;
      AI1 : REAL;
      AI2 : REAL;
      GLASS : TCIB_C_WS_0000R_PG_GLASSI;
      THERM : REAL;
      RH : REAL;
   END_STRUCT;

   TCIB_C_WS_0000R_PG_CONT : STRUCT
      DOT1A : BOOL;
      DOT2A : BOOL;
      DOT1B : BOOL;
      DOT2B : BOOL;
      DBA : BOOL;
      DBB : BOOL;
      BZ : BOOL;
      PX : BOOL;
   END_STRUCT;

   TCIB_C_WS_0000R_PG_LED : STRUCT
      LED1 : BOOL;
      LED2 : BOOL;
      LED3 : BOOL;
      LED4 : BOOL;
      LED5 : BOOL;
      LED6 : BOOL;
      LED7 : BOOL;
      LED8 : BOOL;
      LED9 : BOOL;
      LED10 : BOOL;
      LED11 : BOOL;
      LED12 : BOOL;
      dummy12 {HIDDEN} : BOOL;
      dummy13 {HIDDEN} : BOOL;
      dummy14 {HIDDEN} : BOOL;
      dummy15 {HIDDEN} : BOOL;
      RED1 : BOOL;
      RED2 : BOOL;
      RED3 : BOOL;
      RED4 : BOOL;
      RED5 : BOOL;
      RED6 : BOOL;
      dummy22 {HIDDEN} : BOOL;
      dummy23 {HIDDEN} : BOOL;
      GREEN1 : BOOL;
      GREEN2 : BOOL;
      GREEN3 : BOOL;
      GREEN4 : BOOL;
      GREEN5 : BOOL;
      GREEN6 : BOOL;
      dummy30 {HIDDEN} : BOOL;
      dummy31 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_C_WS_0000R_PG_GLASSO : STRUCT
      CONT : TCIB_C_WS_0000R_PG_CONT;
      LED : TCIB_C_WS_0000R_PG_LED;
      BLIGHT : USINT;
      DISPA : INT;
      DISPB : INT;
      SETA : USINT;
      SETB : USINT;
   END_STRUCT;

   TCIB_C_WS_0000R_PG_OUT : STRUCT
      GLASS : TCIB_C_WS_0000R_PG_GLASSO;
   END_STRUCT;

   TCIB_CRQ0600_DI : STRUCT
      PIR : BOOL;
      DI1 : BOOL;
      DI2 : BOOL;
      dummy3 {HIDDEN} : BOOL;
      CLICKPIR : BOOL;
      CLICK1 : BOOL;
      CLICK2 : BOOL;
      dummy7 {HIDDEN} : BOOL;
      PRESSPIR : BOOL;
      PRESS1 : BOOL;
      PRESS2 : BOOL;
      dummy11 {HIDDEN} : BOOL;
      TAMPERPIR : BOOL;
      TAMPER1 : BOOL;
      TAMPER2 : BOOL;
      dummy15 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_CRQ0600_STAT : STRUCT
      OUFCO2 : BOOL;
      VLDCO2 : BOOL;
      OUFT : BOOL;
      VLDT : BOOL;
      OUFRH : BOOL;
      VLDRH : BOOL;
      OUF1 : BOOL;
      VLD1 : BOOL;
      OUF2 : BOOL;
      VLD2 : BOOL;
      dummy10 {HIDDEN} : BOOL;
      dummy11 {HIDDEN} : BOOL;
      dummy12 {HIDDEN} : BOOL;
      dummy13 {HIDDEN} : BOOL;
      dummy14 {HIDDEN} : BOOL;
      dummy15 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_CRQ0400_AI : STRUCT
      THERM : REAL;
      RH : REAL;
   END_STRUCT;

   TCIB_C_RQ_0600_IN : STRUCT
      DI : TCIB_CRQ0600_DI;
      STAT : TCIB_CRQ0600_STAT;
      CO2 : REAL;
      AI : TCIB_CRQ0400_AI;
      AI1 : REAL;
      AI2 : REAL;
   END_STRUCT;

   TCIB_C_RQ_0600_OUT : STRUCT
      CO2KAL : BYTE;
   END_STRUCT;

   TCIB_C_LC_0202B_IN : STRUCT
      DI : TCIB_BTN_DI2;
   END_STRUCT;

   TCIB_DO2 : STRUCT
      DO1 : BOOL;
      DO2 : BOOL;
      dummy2 {HIDDEN} : BOOL;
      dummy3 {HIDDEN} : BOOL;
      dummy4 {HIDDEN} : BOOL;
      dummy5 {HIDDEN} : BOOL;
      dummy6 {HIDDEN} : BOOL;
      dummy7 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_C_LC_0202B_OUT : STRUCT
      DOs : TCIB_DO2;
   END_STRUCT;

   TCIB_AI2_STAT : STRUCT
      OUF1 : BOOL;
      VLD1 : BOOL;
      OUF2 : BOOL;
      VLD2 : BOOL;
      dummy4 {HIDDEN} : BOOL;
      dummy5 {HIDDEN} : BOOL;
      dummy6 {HIDDEN} : BOOL;
      dummy7 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_DI2T : STRUCT
      DI1 : BOOL;
      DI2 : BOOL;
      dummy2 {HIDDEN} : BOOL;
      dummy3 {HIDDEN} : BOOL;
      TAMPER1 : BOOL;
      TAMPER2 : BOOL;
      dummy6 {HIDDEN} : BOOL;
      dummy7 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_C_OR_0202B_IN : STRUCT
      STAT : TCIB_AI2_STAT;
      AI1 : REAL;
      AI2 : REAL;
      DI : TCIB_DI2T;
   END_STRUCT;

   TCIB_C_OR_0202B_OUT : STRUCT
      DOs : TCIB_DO2;
   END_STRUCT;

   TCIB_C_IR_0202S_IN : STRUCT
      DI : TCIB_DI2T;
      STAT : TCIB_AI2_STAT;
      AI1 : REAL;
      AI2 : REAL;
   END_STRUCT;

   TCIB_C_IR_0202S_OUT : STRUCT
      DO1 : BOOL;
      dummy1 {HIDDEN} : BOOL;
      dummy2 {HIDDEN} : BOOL;
      dummy3 {HIDDEN} : BOOL;
      dummy4 {HIDDEN} : BOOL;
      dummy5 {HIDDEN} : BOOL;
      dummy6 {HIDDEN} : BOOL;
      dummy7 {HIDDEN} : BOOL;
      AO1 : REAL;
   END_STRUCT;

   TCIB_CWG0503S_VAL : ARRAY[0..4] OF USINT;

   TCIB_CWG0503S_CODE : STRUCT
      STAT : USINT;
      VAL : TCIB_CWG0503S_VAL;
   END_STRUCT;

   TCIB_CWG0503S_STAT : STRUCT
      OUF4 : BOOL;
      VLD4 : BOOL;
      OUF5 : BOOL;
      VLD5 : BOOL;
      dummy4 {HIDDEN} : BOOL;
      dummy5 {HIDDEN} : BOOL;
      dummy6 {HIDDEN} : BOOL;
      dummy7 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_CWG0503S_DI : STRUCT
      DI1 : BOOL;
      DI2 : BOOL;
      DI3 : BOOL;
      DI4 : BOOL;
      DI5 : BOOL;
      TAMPER4 : BOOL;
      TAMPER5 : BOOL;
      dummy7 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_C_WG_0503S_IN : STRUCT
      CODE : TCIB_CWG0503S_CODE;
      STAT : TCIB_CWG0503S_STAT;
      AI4 : REAL;
      AI5 : REAL;
      DI : TCIB_CWG0503S_DI;
   END_STRUCT;

   TCIB_DO3 : STRUCT
      DO1 : BOOL;
      DO2 : BOOL;
      DO3 : BOOL;
      dummy3 {HIDDEN} : BOOL;
      dummy4 {HIDDEN} : BOOL;
      dummy5 {HIDDEN} : BOOL;
      dummy6 {HIDDEN} : BOOL;
      dummy7 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_C_WG_0503S_OUT : STRUCT
      DOs : TCIB_DO3;
   END_STRUCT;

   TCHStatistic : STRUCT
      STAT : USINT;
      ERR : USINT;
      trueMes : UDINT;
      falseMes : UDINT;
   END_STRUCT;

   TUniStat : STRUCT
      DSR : BOOL;
      CTS : BOOL;
      dummy2 {HIDDEN} : BOOL;
      TRO : BOOL;
      RCF : BOOL;
      ROV : BOOL;
      TRF : BOOL;
      ARC : BOOL;
   END_STRUCT;

   TZONE_ARRAY_ETH1_UNI0_RX : ARRAY[0..511] OF USINT;

   TUNI_ETH1_UNI0_IN : STRUCT
      STAT : TUniStat;
      ERR : USINT;
      NUMR : UINT;
      DATA : TZONE_ARRAY_ETH1_UNI0_RX;
   END_STRUCT;

   TCHControl2 : STRUCT
      CONTROL : BYTE;
      dummy1 {HIDDEN} : BOOL;
      dummy2 {HIDDEN} : BOOL;
      dummy3 {HIDDEN} : BOOL;
      dummy4 {HIDDEN} : BOOL;
      LOG_TEXT_ONLY : BOOL;
      LOG_HEX_ONLY : BOOL;
      LOG_CYCLIC : BOOL;
      LOG_ON : BOOL;
   END_STRUCT;

   TUniCont : STRUCT
      dummy0 {HIDDEN} : BOOL;
      dummy1 {HIDDEN} : BOOL;
      dummy2 {HIDDEN} : BOOL;
      dummy3 {HIDDEN} : BOOL;
      dummy4 {HIDDEN} : BOOL;
      TRG : BOOL;
      CLR : BOOL;
      ACN : BOOL;
   END_STRUCT;

   TUniSign : STRUCT
      DTR : BOOL;
      RTS : BOOL;
      dummy2 {HIDDEN} : BOOL;
      dummy3 {HIDDEN} : BOOL;
      dummy4 {HIDDEN} : BOOL;
      dummy5 {HIDDEN} : BOOL;
      dummy6 {HIDDEN} : BOOL;
      dummy7 {HIDDEN} : BOOL;
   END_STRUCT;

   TZONE_ARRAY_ETH1_UNI0_TX : ARRAY[0..511] OF USINT;

   TUNI_ETH1_UNI0_OUT : STRUCT
      CONT : TUniCont;
      SIGN : TUniSign;
      NUMT : UINT;
      DATA : TZONE_ARRAY_ETH1_UNI0_TX;
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
   r0_p0_ETH2_ETCL_DIAG : DT_ETCL_DIAG;
   (* Aliases *)
   ROSOCHA_ITCL_DIAG AT r0_p0_ITCL_DIAG;
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
   ROSOCHA_TCL2_DIAG AT r16_p1_TCL2_DIAG;
   CP_CIB_DIAG_1 AT r16_p1_CIB_DIAG;
   ROSOCHA_CIB_DIAG AT r16_p2_CIB_DIAG;
   ROSOCHA_IO_IN {PUBLIC} AT r16_p6_IO_IN;
   SYS_000_1 {PUBLIC} AT r16_p6_IO_IN.DIS.HDO0; (* HDO;000 *)
   SYS_230 {PUBLIC} AT r16_p6_IO_IN.DIS.IN230; (* AC 230V;000 *)
   DOR_X12 {PUBLIC} AT r16_p6_IO_IN.DIS.DI3; (* Predna Brana;X01 *)
   PIR_X11_2 {PUBLIC} AT r16_p6_IO_IN.DIS.DI2; (* Pred Garážou;X01 *)
   PIR_XB1 {PUBLIC} AT r16_p6_IO_IN.DIS.DI1; (* Na bazén;X01 *)
   PIR_X00 {PUBLIC} AT r16_p6_IO_IN.DIS.DI0; (* Technika bazén;X00 *)
   ROSOCHA_DISP_IN AT r16_p7_DISP_IN;
   SEG1_STAT AT r0_p0_ETH2_ETCL_DIAG.STAT[1];
   SEG0_STAT AT r0_p0_ETH2_ETCL_DIAG.STAT[0];
   GW6_STAT AT r0_p0_ETH2_ETCL_DIAG.STAT[0,6];
   GW5_STAT AT r0_p0_ETH2_ETCL_DIAG.STAT[0,5];
   GW4_STAT AT r0_p0_ETH2_ETCL_DIAG.STAT[0,4];
   GW3_STAT AT r0_p0_ETH2_ETCL_DIAG.STAT[0,3];
   GW2_STAT AT r0_p0_ETH2_ETCL_DIAG.STAT[0,2];
   GW1_STAT AT r0_p0_ETH2_ETCL_DIAG.STAT[0,1];
   GW0_STAT AT r0_p0_ETH2_ETCL_DIAG.STAT[0,0];
   SEG1_ERR AT r0_p0_ETH2_ETCL_DIAG.ERR[1];
   SEG0_ERR AT r0_p0_ETH2_ETCL_DIAG.ERR[0];
   GW6_ERR AT r0_p0_ETH2_ETCL_DIAG.ERR[0,6];
   GW5_ERR AT r0_p0_ETH2_ETCL_DIAG.ERR[0,5];
   GW4_ERR AT r0_p0_ETH2_ETCL_DIAG.ERR[0,4];
   GW3_ERR AT r0_p0_ETH2_ETCL_DIAG.ERR[0,3];
   GW2_ERR AT r0_p0_ETH2_ETCL_DIAG.ERR[0,2];
   GW1_ERR AT r0_p0_ETH2_ETCL_DIAG.ERR[0,1];
   GW0_ERR AT r0_p0_ETH2_ETCL_DIAG.ERR[0,0];
(* C-DL-0064M *)
   r4144_p0_IN : tC_DL_0012Sin; (* Dali-1;000 *)
   (* Aliases *)
   DLM_001 {PUBLIC} AT r4144_p0_IN; (* Dali-1;000 *)
(* C-IT-0504S *)
   r4144_p1_IN : TCIB_C_IT_0504S_IN;
   (* Aliases *)
   IO_104_Satnicek_PIR_TEH_IN AT r4144_p1_IN;
   TEH_102 {PUBLIC} AT r4144_p1_IN.AI5; (* Podlaha;102 *)
   PIR_102 {PUBLIC} AT r4144_p1_IN.DI.DI2; (* Šatnícek;102 *)
(* C-OR-0011M-800 *)
   r4144_p2_IN : TCIB_C_OR_0011M_800_IN;
   (* Aliases *)
   RE_1_Kurenie_IN AT r4144_p2_IN;
(* C-JC-0006M *)
   r4144_p3_IN : TCIB_C_JC_0006M_IN;
   (* Aliases *)
   REZ_2_IN AT r4144_p3_IN;
(* C-JC-0006M *)
   r4144_p4_IN : TCIB_C_JC_0006M_IN;
   (* Aliases *)
   REZ_3_IN AT r4144_p4_IN;
(* C-OR-0011M-800 *)
   r4144_p5_IN : TCIB_C_OR_0011M_800_IN;
   (* Aliases *)
   RE_4_SVD_Gabion_Rekuperacia_IN AT r4144_p5_IN;
(* C-OR-0011M-800 *)
   r4144_p6_IN : TCIB_C_OR_0011M_800_IN;
   (* Aliases *)
   RE_2_Kurenie_IN AT r4144_p6_IN;
(* C-OR-0011M-800 *)
   r4144_p7_IN : TCIB_C_OR_0011M_800_IN;
   (* Aliases *)
   RE_5_SVD_Brany_IN AT r4144_p7_IN;
(* C-JC-0006M *)
   r4144_p8_IN : TCIB_C_JC_0006M_IN;
   (* Aliases *)
   REZ_1_Rolety_IN AT r4144_p8_IN;
(* C-KY-0001R *)
   r4144_p9_IN : TCIB_C_KY_0001R_IN; (* Klavesnica predsien;101 *)
   (* Aliases *)
   KEY_002_1 {PUBLIC} AT r4144_p9_IN; (* Klavesnica predsien;101 *)
(* C-WS-0200R-Logus *)
   r4144_p14_IN : TCIB_C_WS_0200R_Logus_IN;
   (* Aliases *)
   WS_109_Spajz_IN AT r4144_p14_IN;
   DYM_201 {PUBLIC} AT r4144_p14_IN.AI1; (* Chodba-2;201 *)
   TER_109 {PUBLIC} AT r4144_p14_IN.THERM; (* Miestnost;109 *)
   PIR_109 {PUBLIC} AT r4144_p14_IN.DI.DI2; (* Spajz;109 *)
   WSB_109_2 {PUBLIC} AT r4144_p14_IN.DI.UP1; (* Špajz;109 *)
(* C-JC-0201B *)
   r4144_p16_IN : TCIB_C_JC_0201B_IN;
   (* Aliases *)
   ROL_108_Garaz_IN AT r4144_p16_IN;
(* C-WS-0000R-PG *)
   r4144_p17_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_103_Chodba_1_na_schody_IN AT r4144_p17_IN;
   TER_131 {PUBLIC} AT r4144_p17_IN.THERM; (* Chodba-1;103 *)
   TGL_131_6 {PUBLIC} AT r4144_p17_IN.GLASS.BTNs; (* Na schody;103 *)
   LUX_103 {PUBLIC} AT r4144_p17_IN.AI2; (* Súmrak 1P;103 *)
   PIR_131_2 {PUBLIC} AT r4144_p17_IN.DI.DI1; (* Schod-1.1;012 *)
(* C-WS-0000R-PG *)
   r4144_p18_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_105_Satnik_hlavny_IN AT r4144_p18_IN;
   TER_2X1 {PUBLIC} AT r4144_p18_IN.THERM; (* Šatník;105 *)
   TGL_2X1_6 {PUBLIC} AT r4144_p18_IN.GLASS.BTNs; (* Šatník;105 *)
   TEH_2X1 {PUBLIC} AT r4144_p18_IN.AI1; (* Podlaha;105 *)
   PIR_2X1_2 {PUBLIC} AT r4144_p18_IN.DI.DI2; (* Šatník;105 *)
(* C-WS-0000R-PG *)
   r4144_p20_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TLG_107_Pracovna_IN AT r4144_p20_IN;
   TER_107 {PUBLIC} AT r4144_p20_IN.THERM; (* Miestnost;107 *)
   TGL_107_6 {PUBLIC} AT r4144_p20_IN.GLASS.BTNs; (* Pracovna;107 *)
   TEH_107 {PUBLIC} AT r4144_p20_IN.AI1; (* Podlaha;107 *)
   PIR_107_2 {PUBLIC} AT r4144_p20_IN.DI.DI2; (* Pracovna;107 *)
(* C-WS-0000R-PG *)
   r4144_p21_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_113_WC_IN AT r4144_p21_IN;
   TER_113 {PUBLIC} AT r4144_p21_IN.THERM; (* WC;113 *)
   TGL_113_6 {PUBLIC} AT r4144_p21_IN.GLASS.BTNs; (* WC;113 *)
   TEH_103 {PUBLIC} AT r4144_p21_IN.AI1; (* Podlaha chdba;103 *)
   PIR_113_2 {PUBLIC} AT r4144_p21_IN.DI.DI2; (* WC;113 *)
(* C-WS-0000R-PG *)
   r4144_p22_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_101_1_Predsien_Lavy_IN AT r4144_p22_IN;
   TGL_101_6 {PUBLIC} AT r4144_p22_IN.GLASS.BTNs; (* Predsien;101 *)
   LUX_X12 {PUBLIC} AT r4144_p22_IN.AI2; (* Hl.vchod;X12 *)
   TEH_101 {PUBLIC} AT r4144_p22_IN.AI1; (* Podlaha;101 *)
(* C-WS-0000R-PG *)
   r4144_p23_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_101_2_Predsien_Pravy_IN AT r4144_p23_IN;
   TER_101 {PUBLIC} AT r4144_p23_IN.THERM; (* Miestnost;101 *)
   TGL_11P_6 {PUBLIC} AT r4144_p23_IN.GLASS.BTNs; (* Predsien-P;101 *)
   PIR_X12 {PUBLIC} AT r4144_p23_IN.DI.DI2; (* Hl.Vstup;X12 *)
   PIR_101_2 {PUBLIC} AT r4144_p23_IN.DI.DI1; (* Predsien-P;101 *)
(* C-WS-0000R-PG *)
   r4144_p24_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_112_1_Obyvacka_Lavy_IN AT r4144_p24_IN;
   TGL_1BL_6 {PUBLIC} AT r4144_p24_IN.GLASS.BTNs; (* Obývacka-L;112 *)
   TEH_112 {PUBLIC} AT r4144_p24_IN.AI1; (* Obývacka;112 *)
   PIR_112_2 {PUBLIC} AT r4144_p24_IN.DI.DI2; (* Chodba;112 *)
(* C-WS-0000R-PG *)
   r4144_p25_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_112_2_Obyvacka_pravy_IN AT r4144_p25_IN;
   TER_112 {PUBLIC} AT r4144_p25_IN.THERM; (* Miestnost;112 *)
   TGL_1BP_6 {PUBLIC} AT r4144_p25_IN.GLASS.BTNs; (* Obývacka-P;112 *)
   PIR_13X_2 {PUBLIC} AT r4144_p25_IN.DI.DI2; (* Obyvacka;112 *)
   PIR_110_2 {PUBLIC} AT r4144_p25_IN.DI.DI1; (* Kuchyna;110 *)
(* C-RQ-0600 *)
   r4144_p26_IN : TCIB_C_RQ_0600_IN;
   (* Aliases *)
   CO2_110_Kuchyna_IN AT r4144_p26_IN;
   COX_110_0 {PUBLIC} AT r4144_p26_IN.CO2; (* CO2 Kuchyna;110 *)
   DYM_110 {PUBLIC} AT r4144_p26_IN.DI.DI2; (* Dym kuchyna;110 *)
   PIR_XE0 {PUBLIC} AT r4144_p26_IN.DI.DI1; (* Chodník-bazén;X00 *)
(* C-JC-0201B *)
   r4144_p27_IN : TCIB_C_JC_0201B_IN;
   (* Aliases *)
   ROL_107_Pracovna_IN AT r4144_p27_IN;
(* C-WS-0000R-PG *)
   r4144_p28_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_X10_Terasa_1_IN AT r4144_p28_IN;
   TER_X10 {PUBLIC} AT r4144_p28_IN.THERM; (* Terasa-1;X10 *)
   TGL_X10_6 {PUBLIC} AT r4144_p28_IN.GLASS.BTNs; (* Terasa-1;X10 *)
   PIR_X10 {PUBLIC} AT r4144_p28_IN.DI.DI1; (* Terasa;X10 *)
(* C-WS-0000R-PG *)
   r4144_p30_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_110_Kuchyna_IN AT r4144_p30_IN;
   TER_110 {PUBLIC} AT r4144_p30_IN.THERM; (* Kuchyna;110 *)
   TGL_110_6 {PUBLIC} AT r4144_p30_IN.GLASS.BTNs; (* Kuchyna;110 *)
   TEH_110 {PUBLIC} AT r4144_p30_IN.AI1; (* Podlaha;110 *)
   PIR_X13 {PUBLIC} {PUBLIC_API} AT r4144_p30_IN.DI.DI2; (* Chodník-garáž;X01 *)
(* C-LC-0202B *)
   r4146_p0_IN : TCIB_C_LC_0202B_IN;
   (* Aliases *)
   ZAS_204_IN AT r4146_p0_IN;
(* C-WS-0000R-PG *)
   r4146_p1_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_204_3_postel_L_F76E_na_F922_IN AT r4146_p1_IN;
   TER_243 {PUBLIC} AT r4146_p1_IN.THERM; (* Miestnost;204 *)
   TGL_243_6 {PUBLIC} AT r4146_p1_IN.GLASS.BTNs; (* Postel-L;204 *)
   PIR_24L_2 {PUBLIC} AT r4146_p1_IN.DI.DI1; (* Postel-L;204 *)
(* C-WS-0000R-PG *)
   r4146_p2_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_202_L_Kup_2_pri_zrkadle_lavy_IN AT r4146_p2_IN;
   TGL_22L_6 {PUBLIC} AT r4146_p2_IN.GLASS.BTNs; (* Zrkadlo-L;202 *)
   PIR_21S_2 {PUBLIC} AT r4146_p2_IN.DI.DI2; (* Schody-Podesta;103   *)
   PIR_1A3_2 {PUBLIC} AT r4146_p2_IN.DI.DI1; (* Kupelna-2;202 *)
(* C-WS-0000R-PG *)
   r4146_p3_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_202_P_Kup_2_pri_zrkadle_pravy_IN AT r4146_p3_IN;
   TER_202 {PUBLIC} AT r4146_p3_IN.THERM; (* Kupelna-2;202 *)
   TGL_22P_6 {PUBLIC} AT r4146_p3_IN.GLASS.BTNs; (* Kúpelna-2-P;202 *)
(* C-DL-0064M *)
   r4146_p4_IN : tC_DL_0012Sin; (* Dali-2;000 *)
   (* Aliases *)
   DLM_002 {PUBLIC} AT r4146_p4_IN; (* Dali-2;000 *)
(* C-WS-0000R-PG *)
   r4146_p5_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_204_2_postel_P_IN AT r4146_p5_IN;
   TGL_242_6 {PUBLIC} AT r4146_p5_IN.GLASS.BTNs; (* Postel-P;204 *)
   TEH_204 {PUBLIC} AT r4146_p5_IN.AI1; (* Podlaha 204;204 *)
   PIR_24P_2 {PUBLIC} AT r4146_p5_IN.DI.DI2; (* Postel-P;204 *)
(* C-WS-0000R-PG *)
   r4146_p6_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_204_1_na_terasu_F922_na_F76E_IN AT r4146_p6_IN;
   TGL_241_6 {PUBLIC} AT r4146_p6_IN.GLASS.BTNs; (* Na terasu;204 *)
   PIR_X21_2 {PUBLIC} AT r4146_p6_IN.DI.DI1; (* Terasa-X21;X02 *)
(* C-JC-0201B *)
   r4146_p7_IN : TCIB_C_JC_0201B_IN;
   (* Aliases *)
   ROL_204_1_vlavo_R_18_IN AT r4146_p7_IN;
(* C-JC-0201B *)
   r4146_p8_IN : TCIB_C_JC_0201B_IN;
   (* Aliases *)
   ROL_204_2_na_terasu_R_13_IN AT r4146_p8_IN;
(* C-WS-0000R-PG *)
   r4146_p9_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_203_4_pri_dverach_IN AT r4146_p9_IN;
   TGL_233_6 {PUBLIC} AT r4146_p9_IN.GLASS.BTNs; (* Dvere;203 *)
   TEH_233 {PUBLIC} AT r4146_p9_IN.AI1; (* Podlaha;203 *)
   PIR_201_2 {PUBLIC} AT r4146_p9_IN.DI.DI2; (* Chodba-2;201 *)
(* C-JC-0201B *)
   r4146_p10_IN : TCIB_C_JC_0201B_IN;
   (* Aliases *)
   ROL_201_chodba_IN AT r4146_p10_IN;
(* C-WS-0000R-PG *)
   r4146_p11_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_203_1_na_terasu_IN AT r4146_p11_IN;
   TGL_234_6 {PUBLIC} AT r4146_p11_IN.GLASS.BTNs; (* Na terasu;203 *)
   PIR_X22_2 {PUBLIC} AT r4146_p11_IN.DI.DI2; (* Terasa-X22;X23 *)
   PIR_X23 {PUBLIC} AT r4146_p11_IN.DI.DI1; (* Teraska-X23;X23 *)
(* C-OR-0202B *)
   r4146_p12_IN : TCIB_C_OR_0202B_IN;
   (* Aliases *)
   ZAS_203_Zasuvky_pod_postelou_IN AT r4146_p12_IN;
(* C-WS-0000R-PG *)
   r4146_p13_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_201_Chodba_2_01_IN AT r4146_p13_IN;
   TER_201 {PUBLIC} AT r4146_p13_IN.THERM; (* Chodba-2;201 *)
   TGL_201_6 {PUBLIC} AT r4146_p13_IN.GLASS.BTNs; (* Chodba-2;201 *)
   PIR_2E1_2 {PUBLIC} AT r4146_p13_IN.DI.DI1; (* Sch.2->1;012 *)
(* C-IT-0504S *)
   r4146_p14_IN : TCIB_C_IT_0504S_IN;
   (* Aliases *)
   IT_202_Kupelna_2_v_povodnom_vypinaci_pri_dverach_IN AT r4146_p14_IN;
   TEH_202 {PUBLIC} AT r4146_p14_IN.AI5; (* Podlaha K2;202 *)
   LUX_202 {PUBLIC} AT r4146_p14_IN.AI.AI2; (* Súmrak 2P;202 *)
(* C-WS-0000R-PG *)
   r4146_p15_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_203_3_postel_L_IN AT r4146_p15_IN;
   TER_203 {PUBLIC} AT r4146_p15_IN.THERM; (* Miestnost;203 *)
   TGL_231_6 {PUBLIC} AT r4146_p15_IN.GLASS.BTNs; (* Postel-L;203 *)
   PIR_231_2 {PUBLIC} AT r4146_p15_IN.DI.DI1; (* Postel-L;203 *)
(* C-IT-0504S *)
   r4146_p16_IN : TCIB_C_IT_0504S_IN;
   (* Aliases *)
   IT_003_Stary_Sumrak_zadna_brana_Kotol_0_10_IN AT r4146_p16_IN;
   LUX_001 AT r4146_p16_IN.AI5; (* Súmrak vonku;X02 *)
   PIR_A03 {PUBLIC} AT r4146_p16_IN.DI.DI2; (* Nad rozvadzacom;003 *)
   DOR_X11 {PUBLIC} AT r4146_p16_IN.DI.DI1; (* Zadna brana;X01 *)
(* C-IR-0202S *)
   r4146_p17_IN : TCIB_C_IR_0202S_IN;
   (* Aliases *)
   SIR_X01_Velka_sirena_V_Garazi_pod_WS_108_1_IN AT r4146_p17_IN;
(* C-WS-0000R-PG *)
   r4146_p18_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_203_2_postel_P_IN AT r4146_p18_IN;
   TGL_232_6 {PUBLIC} AT r4146_p18_IN.GLASS.BTNs; (* Postel-P;203 *)
   TEH_203 {PUBLIC} AT r4146_p18_IN.AI2; (* Podlaha;203 *)
   PIR_23P_2 {PUBLIC} AT r4146_p18_IN.DI.DI1; (* Postel-P;203 *)
(* C-WG-0503S *)
   r4146_p19_IN : TCIB_C_WG_0503S_IN; (* Klavesnica-garaz;108 *)
   (* Aliases *)
   KEY_108_0 {PUBLIC} AT r4146_p19_IN; (* Klavesnica-garaz;108 *)
(* C-JC-0201B *)
   r4146_p20_IN : TCIB_C_JC_0201B_IN;
   (* Aliases *)
   ROL_203_1_oproti_dveram_IN AT r4146_p20_IN;
(* C-JC-0201B *)
   r4146_p24_IN : TCIB_C_JC_0201B_IN;
   (* Aliases *)
   ROL_203_2_oproti_posteli_IN AT r4146_p24_IN;
(* C-WS-0200R-Logus *)
   r4146_p25_IN : TCIB_C_WS_0200R_Logus_IN;
   (* Aliases *)
   WS_108_1_Garaz_brana_IN AT r4146_p25_IN;
   DOR_108 {PUBLIC} AT r4146_p25_IN.DI.DI2; (* Garaz-snimac;108 *)
   PIR_108 {PUBLIC} AT r4146_p25_IN.DI.DI1; (* Garaz;108 *)
   WSB_108_2 {PUBLIC} AT r4146_p25_IN.DI.UP1; (* Garáž-brana;108 *)
(* C-WS-0200R-Logus *)
   r4146_p26_IN : TCIB_C_WS_0200R_Logus_IN;
   (* Aliases *)
   WS_108_2_Garaz_do_domu_IN AT r4146_p26_IN;
   TER_108 {PUBLIC} AT r4146_p26_IN.THERM; (* Miestnost;108 *)
   WSB_182_2 {PUBLIC} AT r4146_p26_IN.DI.UP1; (* Garáž-dvere;108 *)
(* C-WS-0000R-PG *)
   r4146_p27_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_106_1_Kupelna_Lavy_IN AT r4146_p27_IN;
   TGL_16L_6 {PUBLIC} AT r4146_p27_IN.GLASS.BTNs; (* Kúpelna-L;106 *)
   PIR_106_2 {PUBLIC} AT r4146_p27_IN.DI.DI1; (* Kupelna;106 *)
(* C-WS-0000R-PG *)
   r4146_p28_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_106_2_Kupelna_Pravy_IN AT r4146_p28_IN;
   TER_106 {PUBLIC} AT r4146_p28_IN.THERM; (* Kupelna-1;106 *)
   TGL_16P_6 {PUBLIC} AT r4146_p28_IN.GLASS.BTNs; (* Kúpelna-P;106 *)
   TEH_106 {PUBLIC} AT r4146_p28_IN.AI1; (* Podlaha;106 *)
(* C-WS-0000R-PG *)
   r4146_p29_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_104_3_postel_P_F911D_pri_dverach_IN AT r4146_p29_IN;
   TGL_14P_6 {PUBLIC} AT r4146_p29_IN.GLASS.BTNs; (* Postel-P;104 *)
   PIR_14P_2 {PUBLIC} AT r4146_p29_IN.DI.DI1; (* Postel-P;104 *)
(* C-WS-0000R-PG *)
   r4146_p30_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_104_1_pri_dverach_F8FD_postel_p_IN AT r4146_p30_IN;
   TGL_14D_6 {PUBLIC} AT r4146_p30_IN.GLASS.BTNs; (* Pri dverách;104 *)
   TEH_104 {PUBLIC} AT r4146_p30_IN.AI1; (* Podlaha;104 *)
(* C-WS-0000R-PG *)
   r4146_p31_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_104_2_postel_L_IN AT r4146_p31_IN;
   TER_104 {PUBLIC} AT r4146_p31_IN.THERM; (* Spálna;104 *)
   TGL_14L_6 {PUBLIC} AT r4146_p31_IN.GLASS.BTNs; (* Postel-L;104 *)
   PIR_14L_2 {PUBLIC} AT r4146_p31_IN.DI.DI1; (* Postel-L;104 *)
(* CF-2141 *)
   r82_p0_CIB_DIAG : DT_CIB_DIAG;
(* C-RQ-0600 *)
   r21040_p0_IN : TCIB_C_RQ_0600_IN;
   (* Aliases *)
   CO2_002_Vinaren_IN AT r21040_p0_IN;
   COX_002_0 {PUBLIC} AT r21040_p0_IN.CO2; (* CO2 Vináren;002 *)
(* C-WS-0000R-PG *)
   r21040_p1_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_002_Vinaren_pri_dverach_IN AT r21040_p1_IN;
   TER_002 {PUBLIC} AT r21040_p1_IN.THERM; (* Miestnost;002 *)
   TGL_002_6 {PUBLIC} AT r21040_p1_IN.GLASS.BTNs; (* Vináren;002 *)
   TEH_002 {PUBLIC} AT r21040_p1_IN.AI1; (* Podlaha;002 *)
   PIR_002_2 {PUBLIC} AT r21040_p1_IN.DI.DI2; (* Vináren;002 *)
(* C-WS-0000R-PG *)
   r21040_p2_IN : TCIB_C_WS_0000R_PG_IN;
   (* Aliases *)
   TGL_001_Chodba_0_pri_vinarni_IN AT r21040_p2_IN;
   TER_001 {PUBLIC} AT r21040_p2_IN.THERM; (* Chodba-0;001 *)
   TGL_YY1_6 {PUBLIC} AT r21040_p2_IN.GLASS.BTNs; (* Chodba.0;001  *)
   TEH_001 {PUBLIC} {PUBLIC_API} AT r21040_p2_IN.AI1; (* Podlaha;001 *)
   PIR_001 {PUBLIC} AT r21040_p2_IN.DI.DI2; (* Chodba-0;001 *)
(* C-WS-0200R-Logus *)
   r21040_p3_IN : TCIB_C_WS_0200R_Logus_IN;
   (* Aliases *)
   WS_003_Technicka_pri_dverach_IN AT r21040_p3_IN;
   TEH_003 {PUBLIC} AT r21040_p3_IN.AI1; (* Podlaha;003 *)
   TER_003 {PUBLIC} AT r21040_p3_IN.THERM; (* Miestnost;003 *)
   WSB_003_2 {PUBLIC} AT r21040_p3_IN.DI.UP1; (* Technika;003 *)
(* C-WS-0200R-Logus *)
   r21040_p4_IN : TCIB_C_WS_0200R_Logus_IN;
   (* Aliases *)
   WS_006_WC_v_technickej_003_IN AT r21040_p4_IN;
   PIR_003 {PUBLIC} AT r21040_p4_IN.DI.DI2; (* PIR-technika;003 *)
   PIR_006 {PUBLIC} AT r21040_p4_IN.DI.DI1; (* PIR-WC-0;003 *)
   WSB_006_2 {PUBLIC} {PUBLIC_API} AT r21040_p4_IN.DI.UP1; (* WC-technika;003 *)
(* C-WS-0200R-Logus *)
   r21040_p5_IN : TCIB_C_WS_0200R_Logus_IN;
   (* Aliases *)
   WS_005_Sklad_IN AT r21040_p5_IN;
   TER_005 {PUBLIC} AT r21040_p5_IN.THERM; (* Miestnost;005 *)
   PIR_005 {PUBLIC} AT r21040_p5_IN.DI.DI2; (* Sklad;005 *)
   PIR_004 {PUBLIC} AT r21040_p5_IN.DI.DI1; (* Fitness;004 *)
   WSB_005_2 {PUBLIC} AT r21040_p5_IN.DI.UP1; (* Sklad;005 *)
(* C-WS-0200R-Logus *)
   r21040_p6_IN : TCIB_C_WS_0200R_Logus_IN;
   (* Aliases *)
   WS_004_2_Fitko_do_skladu_IN AT r21040_p6_IN;
   TEH_004 {PUBLIC} AT r21040_p6_IN.AI2; (* Podlaha;004 *)
   TEH_005 {PUBLIC} AT r21040_p6_IN.AI1; (* Podlaha;005 *)
   TER_004 {PUBLIC} AT r21040_p6_IN.THERM; (* Miestnost;004 *)
   WSB_04X_2 {PUBLIC} AT r21040_p6_IN.DI.UP1; (* Fitko-sklad;004 *)
(* C-WS-0200R-Logus *)
   r21040_p7_IN : TCIB_C_WS_0200R_Logus_IN;
   (* Aliases *)
   WS_004_Fitko_z_chodby_IN AT r21040_p7_IN;
   PIR_01X_2 {PUBLIC} AT r21040_p7_IN.DI.DI2; (* Sch??;012 *)
   PIR_01S_2 {PUBLIC} AT r21040_p7_IN.DI.DI1; (* Podesta-0;012 *)
   WSB_004_2 {PUBLIC} AT r21040_p7_IN.DI.UP1; (* Fitness;004 *)
(* C-JC-0201B *)
   r21040_p8_IN : TCIB_C_JC_0201B_IN;
   (* Aliases *)
   X10_2xMale_zaluzie_na_Terase_IN AT r21040_p8_IN;
(* ETH1_UNI0 *)
   r0_p0_Statistic_ETH1_UNI0 : TCHStatistic;
   UNI_ETH1_UNI0_IN : TUNI_ETH1_UNI0_IN;
END_VAR

VAR_GLOBAL_OUTPUT
(* CP-2000 *)
   r0_p0_ITCL_CONTROL : UINT;
   r16_p1_TCL2_CONTROL : UINT;
   r16_p1_CIB_CONTROL : UINT;
   r16_p2_CIB_CONTROL : UINT;
   r16_p6_IO_OUT : DT_IR2553_OUT;
   r16_p7_DISP_OUT : DT_OI2872_OUT;
   r0_p0_ETH2_ETCL_CONTROL : UINT;
   (* Aliases *)
   ROSOCHA_ITCL_CONTROL AT r0_p0_ITCL_CONTROL;
   ROSOCHA_TCL2_CONTROL AT r16_p1_TCL2_CONTROL;
   CP_CIB_CONTROL_1 AT r16_p1_CIB_CONTROL;
   ROSOCHA_CIB_CONTROL AT r16_p2_CIB_CONTROL;
   ROSOCHA_IO_OUT AT r16_p6_IO_OUT;
   ZAS_000 {PUBLIC} AT r16_p6_IO_OUT.DOS.DO1; (* HW-Reset;000 *)
   ZAS_DAL {PUBLIC} AT r16_p6_IO_OUT.DOS.DO0; (* HW-reset DALI;000 *)
   ROSOCHA_DISP_OUT AT r16_p7_DISP_OUT;
   ROM_112 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[77]; (* Obývacka;1 *)
   ROM_110 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[76]; (* Kuchyna;1 *)
   ROM_103 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[75]; (* Chodba;1 *)
   ROM_101 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[74]; (* Predsien;1 *)
   ROM_104 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[73]; (* Spálna;1 *)
   ROM_106 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[72]; (* Kúpelna;1 *)
   ROM_105 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[71]; (* Šatník;1 *)
   ROM_102 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[70]; (* Šatnícek;1 *)
   ROM_113 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[69]; (* WC;1 *)
   ROM_107 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[68]; (* Pracovna;1 *)
   ROM_109 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[67]; (* Špajz;1 *)
   ROM_108 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[66]; (* Garáž;1 *)
   ROM_012 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[65]; (* Schodisko;1 *)
   ROM_002 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[61]; (* Vináren;3 *)
   ROM_001 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[60]; (* Chodba-PP;3 *)
   ROM_003 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[59]; (* Technika;3 *)
   ROM_004 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[58]; (* Fitness;3 *)
   ROM_005 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[57]; (* Sklad;3 *)
   ROM_201 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[54]; (* Chodba-2P;1 *)
   ROM_202 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[53]; (* Kúpelna-2P;1 *)
   ROM_203 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[52]; (* Host 2.03;1 *)
   ROM_204 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[51]; (* Host 2.04;1 *)
   ROM_X02 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[7]; (* 2.NP Vonku;2 *)
   ROM_X01 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[6]; (* 1.NP Vonku;2 *)
   ROM_X10 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[5]; (* Terasa-1;2 *)
   ROM_X00 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[4]; (* Bazén room;3 *)
   ROM_000 {PUBLIC} AT r16_p7_DISP_OUT.VideoRam[0]; (* #Setup;0 *)
(* C-DL-0064M *)
   r4144_p0_OUT : tC_DL_0012Sout;
   (* Aliases *)
   DLM_001_Q {PUBLIC} AT r4144_p0_OUT;
(* C-IT-0504S *)
   r4144_p1_OUT : TCIB_C_IT_0504S_OUT;
   (* Aliases *)
   IO_104_Satnicek_PIR_TEH_OUT AT r4144_p1_OUT;
(* C-OR-0011M-800 *)
   r4144_p2_OUT : TCIB_C_OR_0011M_800_OUT;
   (* Aliases *)
   RE_1_Kurenie_OUT AT r4144_p2_OUT;
   TVE_107 {PUBLIC} AT r4144_p2_OUT.DOs.DO11; (* Pracovna;107 *)
   TVE_105 {PUBLIC} AT r4144_p2_OUT.DOs.DO10; (* Šatník;105 *)
   TVE_102 {PUBLIC} AT r4144_p2_OUT.DOs.DO9; (* Šatnícek;102 *)
   TVE_108 {PUBLIC} AT r4144_p2_OUT.DOs.DO8; (* Garáž;108 *)
   TVE_104 {PUBLIC} AT r4144_p2_OUT.DOs.DO7; (* Spálna.1;104 *)
   TVE_106 {PUBLIC} AT r4144_p2_OUT.DOs.DO6; (* Kúpelna.1;106 *)
   TVE_005 {PUBLIC} AT r4144_p2_OUT.DOs.DO5; (* Sklad;005 *)
   TVE_004 {PUBLIC} AT r4144_p2_OUT.DOs.DO4; (* Fitness;004 *)
   TVE_003 {PUBLIC} AT r4144_p2_OUT.DOs.DO3; (* Technika;003 *)
   TVE_002 {PUBLIC} AT r4144_p2_OUT.DOs.DO2; (* Vináren;002 *)
   TVE_001 {PUBLIC} AT r4144_p2_OUT.DOs.DO1; (* Chodba.0;001 *)
(* C-JC-0006M *)
   r4144_p3_OUT : TCIB_C_JC_0006M_OUT;
   (* Aliases *)
   REZ_2_OUT AT r4144_p3_OUT;
   ROL_004_D {PUBLIC} AT r4144_p3_OUT.DOs.DO6d;
   ROL_004_U {PUBLIC} AT r4144_p3_OUT.DOs.DO6u; (* Fitness??;004 *)
   ROL_001_D {PUBLIC} AT r4144_p3_OUT.DOs.DO5d;
   ROL_001_U {PUBLIC} AT r4144_p3_OUT.DOs.DO5u; (* Chodba-0;001 *)
   ROL_104_D {PUBLIC} AT r4144_p3_OUT.DOs.DO4d;
   ROL_104_U {PUBLIC} AT r4144_p3_OUT.DOs.DO4u; (* Spálna;104 *)
   ROL_106_D {PUBLIC} AT r4144_p3_OUT.DOs.DO3d;
   ROL_106_U {PUBLIC} AT r4144_p3_OUT.DOs.DO3u; (* Kúpelna-1;106 *)
   ROL_003_D {PUBLIC} AT r4144_p3_OUT.DOs.DO2d;
   ROL_003_U {PUBLIC} AT r4144_p3_OUT.DOs.DO2u; (* Technika;003 *)
   ROL_1A2_D {PUBLIC} AT r4144_p3_OUT.DOs.DO1d;
   ROL_1A2_U {PUBLIC} AT r4144_p3_OUT.DOs.DO1u; (* K jazierku;112 *)
(* C-JC-0006M *)
   r4144_p4_OUT : TCIB_C_JC_0006M_OUT;
   (* Aliases *)
   REZ_3_OUT AT r4144_p4_OUT;
   ROL_114_D {PUBLIC} AT r4144_p4_OUT.DOs.DO5d;
   ROL_114_U {PUBLIC} AT r4144_p4_OUT.DOs.DO5u; (* Schodisko;012 *)
   ROL_202_D {PUBLIC} AT r4144_p4_OUT.DOs.DO4d;
   ROL_202_U {PUBLIC} AT r4144_p4_OUT.DOs.DO4u; (* Kúpelna-2;202 *)
   ROL_103_D {PUBLIC} AT r4144_p4_OUT.DOs.DO3d;
   ROL_103_U {PUBLIC} AT r4144_p4_OUT.DOs.DO3u; (* Chodba-1;103 *)
   ROL_0F4_D {PUBLIC} AT r4144_p4_OUT.DOs.DO2d;
   ROL_0F4_U {PUBLIC} AT r4144_p4_OUT.DOs.DO2u; (* Fitness;004 *)
   ROL_002_D {PUBLIC} AT r4144_p4_OUT.DOs.DO1d;
   ROL_002_U {PUBLIC} AT r4144_p4_OUT.DOs.DO1u; (* Vinnáren;002 *)
(* C-OR-0011M-800 *)
   r4144_p5_OUT : TCIB_C_OR_0011M_800_OUT;
   (* Aliases *)
   RE_4_SVD_Gabion_Rekuperacia_OUT AT r4144_p5_OUT;
   SVD_GA2 {PUBLIC} AT r4144_p5_OUT.DOs.DO9; (* Gabión-terasa;X01 *)
   SVD_GA1 {PUBLIC} AT r4144_p5_OUT.DOs.DO8; (* Gabión-garáž;X01 *)
   VEN_001_Q {PUBLIC} AT r4144_p5_OUT.DOs.DO2;
   VEN_001_1 {PUBLIC} AT r4144_p5_OUT.DOs.DO1; (* Rekuperácia;003 *)
(* C-OR-0011M-800 *)
   r4144_p6_OUT : TCIB_C_OR_0011M_800_OUT;
   (* Aliases *)
   RE_2_Kurenie_OUT AT r4144_p6_OUT;
   ZAS_KAM {PUBLIC} AT r4144_p6_OUT.DOs.DO11; (* Nahravanie-KAM;000 *)
   VVO_003_Q {PUBLIC} AT r4144_p6_OUT.DOs.DO10;
   VVO_003_2 {PUBLIC} AT r4144_p6_OUT.DOs.DO9; (* Ventil vody;003 *)
   TVE_201 {PUBLIC} AT r4144_p6_OUT.DOs.DO8; (* Chodba.2;201 *)
   TVE_202 {PUBLIC} AT r4144_p6_OUT.DOs.DO7; (* Kúpelna.2;202 *)
   TVE_204 {PUBLIC} AT r4144_p6_OUT.DOs.DO6; (* Host 2.04;204 *)
   TVE_203 {PUBLIC} AT r4144_p6_OUT.DOs.DO5; (* Host 2.03;203 *)
   TVE_103 {PUBLIC} AT r4144_p6_OUT.DOs.DO4; (* Chodba.1;103 *)
   TVE_100 {PUBLIC} AT r4144_p6_OUT.DOs.DO3; (* Kuchyna;110 *)
   TVE_112 {PUBLIC} AT r4144_p6_OUT.DOs.DO2; (* Obývacka;112 *)
(* C-OR-0011M-800 *)
   r4144_p7_OUT : TCIB_C_OR_0011M_800_OUT;
   (* Aliases *)
   RE_5_SVD_Brany_OUT AT r4144_p7_OUT;
   SVD_005 {PUBLIC} AT r4144_p7_OUT.DOs.DO11; (* Sklad;005 *)
   SVD_004 {PUBLIC} AT r4144_p7_OUT.DOs.DO10; (* Fitness;004 *)
   SVD_003 {PUBLIC} AT r4144_p7_OUT.DOs.DO9; (* Technika;003 *)
   SVD_001 {PUBLIC} AT r4144_p7_OUT.DOs.DO8; (* Chodba-0.01;001 *)
   SVD_006 {PUBLIC} AT r4144_p7_OUT.DOs.DO7; (* Strop-WC;003 *)
   GAT_108_0 {PUBLIC} AT r4144_p7_OUT.DOs.DO3; (* Garaz;108 *)
   GAT_X11_1 {PUBLIC} AT r4144_p7_OUT.DOs.DO2; (* Zadna brana;X01 *)
   GAT_X12_1 {PUBLIC} AT r4144_p7_OUT.DOs.DO1; (* Predna Brana;X01 *)
(* C-JC-0006M *)
   r4144_p8_OUT : TCIB_C_JC_0006M_OUT;
   (* Aliases *)
   REZ_1_Rolety_OUT AT r4144_p8_OUT;
   ROL_XZ6_D {PUBLIC} AT r4144_p8_OUT.DOs.DO6d;
   ROL_XZ6_U {PUBLIC} AT r4144_p8_OUT.DOs.DO6u; (* Jazierko-L;X10 *)
   ROL_XY6_D {PUBLIC} AT r4144_p8_OUT.DOs.DO5d;
   ROL_XY6_U {PUBLIC} AT r4144_p8_OUT.DOs.DO5u; (* Bazen-L;X10 *)
   ROL_XX6_D {PUBLIC} AT r4144_p8_OUT.DOs.DO4d;
   ROL_XX6_U {PUBLIC} AT r4144_p8_OUT.DOs.DO4u; (* Bazen-P;X10 *)
   ROL_112_D {PUBLIC} AT r4144_p8_OUT.DOs.DO3d;
   ROL_112_U {PUBLIC} AT r4144_p8_OUT.DOs.DO3u; (* Na Aqárium;112 *)
   ROL_X16_D {PUBLIC} AT r4144_p8_OUT.DOs.DO2d;
   ROL_X16_U {PUBLIC} AT r4144_p8_OUT.DOs.DO2u; (* Jazierko-P;X10 *)
   ROL_110_D {PUBLIC} AT r4144_p8_OUT.DOs.DO1d;
   ROL_110_U {PUBLIC} AT r4144_p8_OUT.DOs.DO1u; (* Kuchyna;110 *)
(* C-KY-0001R *)
   r4144_p9_OUT : TCIB_C_KY_0001R_OUT;
   (* Aliases *)
   KEY_002_Q {PUBLIC} AT r4144_p9_OUT;
(* C-WS-0200R-Logus *)
   r4144_p14_OUT : TCIB_C_WS_0200R_Logus_OUT;
   (* Aliases *)
   WS_109_Spajz_OUT AT r4144_p14_OUT;
   WSB_109_Q {PUBLIC} AT r4144_p14_OUT.LED.GREEN1;
(* C-JC-0201B *)
   r4144_p16_OUT : TCIB_C_JC_0201B_OUT;
   (* Aliases *)
   ROL_108_Garaz_OUT AT r4144_p16_OUT;
   ROL_108_D {PUBLIC} AT r4144_p16_OUT.DOs.DO1d;
   ROL_108_U {PUBLIC} AT r4144_p16_OUT.DOs.DO1u; (* Garáž;108 *)
(* C-WS-0000R-PG *)
   r4144_p17_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_103_Chodba_1_na_schody_OUT AT r4144_p17_OUT;
   TGL_131_Q {PUBLIC} AT r4144_p17_OUT.GLASS;
(* C-WS-0000R-PG *)
   r4144_p18_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_105_Satnik_hlavny_OUT AT r4144_p18_OUT;
   TGL_2X1_Q {PUBLIC} AT r4144_p18_OUT.GLASS;
(* C-WS-0000R-PG *)
   r4144_p20_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TLG_107_Pracovna_OUT AT r4144_p20_OUT;
   TGL_107_Q {PUBLIC} AT r4144_p20_OUT.GLASS;
(* C-WS-0000R-PG *)
   r4144_p21_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_113_WC_OUT AT r4144_p21_OUT;
   TGL_113_Q {PUBLIC} AT r4144_p21_OUT.GLASS;
(* C-WS-0000R-PG *)
   r4144_p22_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_101_1_Predsien_Lavy_OUT AT r4144_p22_OUT;
   TGL_101_Q {PUBLIC} AT r4144_p22_OUT.GLASS;
(* C-WS-0000R-PG *)
   r4144_p23_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_101_2_Predsien_Pravy_OUT AT r4144_p23_OUT;
   TGL_11P_Q {PUBLIC} AT r4144_p23_OUT.GLASS;
(* C-WS-0000R-PG *)
   r4144_p24_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_112_1_Obyvacka_Lavy_OUT AT r4144_p24_OUT;
   TGL_1BL_Q {PUBLIC} AT r4144_p24_OUT.GLASS;
(* C-WS-0000R-PG *)
   r4144_p25_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_112_2_Obyvacka_pravy_OUT AT r4144_p25_OUT;
   TGL_1BP_Q {PUBLIC} AT r4144_p25_OUT.GLASS;
(* C-RQ-0600 *)
   r4144_p26_OUT : TCIB_C_RQ_0600_OUT;
   (* Aliases *)
   CO2_110_Kuchyna_OUT AT r4144_p26_OUT;
(* C-JC-0201B *)
   r4144_p27_OUT : TCIB_C_JC_0201B_OUT;
   (* Aliases *)
   ROL_107_Pracovna_OUT AT r4144_p27_OUT;
   ROL_107_D {PUBLIC} AT r4144_p27_OUT.DOs.DO1d;
   ROL_107_U {PUBLIC} AT r4144_p27_OUT.DOs.DO1u; (* Pracovna;107 *)
(* C-WS-0000R-PG *)
   r4144_p28_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_X10_Terasa_1_OUT AT r4144_p28_OUT;
   SIR_002 {PUBLIC} AT r4144_p28_OUT.GLASS.CONT.BZ; (* Siréna-terasa;X10 *)
   TGL_X10_Q {PUBLIC} AT r4144_p28_OUT.GLASS;
(* C-WS-0000R-PG *)
   r4144_p30_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_110_Kuchyna_OUT AT r4144_p30_OUT;
   TGL_110_Q {PUBLIC} AT r4144_p30_OUT.GLASS;
(* C-LC-0202B *)
   r4146_p0_OUT : TCIB_C_LC_0202B_OUT;
   (* Aliases *)
   ZAS_204_OUT AT r4146_p0_OUT;
   ZAS_24L {PUBLIC} AT r4146_p0_OUT.DOs.DO2; (* N.Lampa-L 2.04;204 *)
   ZAS_24P {PUBLIC} AT r4146_p0_OUT.DOs.DO1; (* N.Lampa-P 2.04;204 *)
(* C-WS-0000R-PG *)
   r4146_p1_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_204_3_postel_L_F76E_na_F922_OUT AT r4146_p1_OUT;
   TGL_243_Q {PUBLIC} AT r4146_p1_OUT.GLASS;
(* C-WS-0000R-PG *)
   r4146_p2_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_202_L_Kup_2_pri_zrkadle_lavy_OUT AT r4146_p2_OUT;
   TGL_22L_Q {PUBLIC} AT r4146_p2_OUT.GLASS;
(* C-WS-0000R-PG *)
   r4146_p3_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_202_P_Kup_2_pri_zrkadle_pravy_OUT AT r4146_p3_OUT;
   TGL_22P_Q {PUBLIC} AT r4146_p3_OUT.GLASS;
(* C-DL-0064M *)
   r4146_p4_OUT : tC_DL_0012Sout;
   (* Aliases *)
   DLM_002_Q {PUBLIC} AT r4146_p4_OUT;
(* C-WS-0000R-PG *)
   r4146_p5_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_204_2_postel_P_OUT AT r4146_p5_OUT;
   TGL_242_Q {PUBLIC} AT r4146_p5_OUT.GLASS;
(* C-WS-0000R-PG *)
   r4146_p6_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_204_1_na_terasu_F922_na_F76E_OUT AT r4146_p6_OUT;
   TGL_241_Q {PUBLIC} AT r4146_p6_OUT.GLASS;
(* C-JC-0201B *)
   r4146_p7_OUT : TCIB_C_JC_0201B_OUT;
   (* Aliases *)
   ROL_204_1_vlavo_R_18_OUT AT r4146_p7_OUT;
   ROL_204_D {PUBLIC} AT r4146_p7_OUT.DOs.DO1d;
   ROL_204_U {PUBLIC} AT r4146_p7_OUT.DOs.DO1u; (* Vlavo;204 *)
(* C-JC-0201B *)
   r4146_p8_OUT : TCIB_C_JC_0201B_OUT;
   (* Aliases *)
   ROL_204_2_na_terasu_R_13_OUT AT r4146_p8_OUT;
   ROL_24T_D {PUBLIC} AT r4146_p8_OUT.DOs.DO1d;
   ROL_24T_U {PUBLIC} AT r4146_p8_OUT.DOs.DO1u; (* Na terasu;204 *)
(* C-WS-0000R-PG *)
   r4146_p9_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_203_4_pri_dverach_OUT AT r4146_p9_OUT;
   TGL_233_Q {PUBLIC} AT r4146_p9_OUT.GLASS;
(* C-JC-0201B *)
   r4146_p10_OUT : TCIB_C_JC_0201B_OUT;
   (* Aliases *)
   ROL_201_chodba_OUT AT r4146_p10_OUT;
   ROL_201_D {PUBLIC} AT r4146_p10_OUT.DOs.DO1d;
   ROL_201_U {PUBLIC} AT r4146_p10_OUT.DOs.DO1u; (* Chodba-2;201 *)
(* C-WS-0000R-PG *)
   r4146_p11_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_203_1_na_terasu_OUT AT r4146_p11_OUT;
   TGL_234_Q {PUBLIC} AT r4146_p11_OUT.GLASS;
(* C-OR-0202B *)
   r4146_p12_OUT : TCIB_C_OR_0202B_OUT;
   (* Aliases *)
   ZAS_203_Zasuvky_pod_postelou_OUT AT r4146_p12_OUT;
   ZAS_23P {PUBLIC} AT r4146_p12_OUT.DOs.DO2; (* N.Lampa-P 2.03;203 *)
   ZAS_23L {PUBLIC} AT r4146_p12_OUT.DOs.DO1; (* N.Lampa-L 2.03;203 *)
(* C-WS-0000R-PG *)
   r4146_p13_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_201_Chodba_2_01_OUT AT r4146_p13_OUT;
   TGL_201_Q {PUBLIC} AT r4146_p13_OUT.GLASS;
(* C-IT-0504S *)
   r4146_p14_OUT : TCIB_C_IT_0504S_OUT;
   (* Aliases *)
   IT_202_Kupelna_2_v_povodnom_vypinaci_pri_dverach_OUT AT r4146_p14_OUT;
(* C-WS-0000R-PG *)
   r4146_p15_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_203_3_postel_L_OUT AT r4146_p15_OUT;
   TGL_231_Q {PUBLIC} AT r4146_p15_OUT.GLASS;
(* C-IT-0504S *)
   r4146_p16_OUT : TCIB_C_IT_0504S_OUT;
   (* Aliases *)
   IT_003_Stary_Sumrak_zadna_brana_Kotol_0_10_OUT AT r4146_p16_OUT;
   KOT_003_1 {PUBLIC} AT r4146_p16_OUT.AO.AO1; (* Kotol;003 *)
(* C-IR-0202S *)
   r4146_p17_OUT : TCIB_C_IR_0202S_OUT;
   (* Aliases *)
   SIR_X01_Velka_sirena_V_Garazi_pod_WS_108_1_OUT AT r4146_p17_OUT;
   SIR_001 {PUBLIC} AT r4146_p17_OUT.DO1; (* Siréna garáž;X01 *)
(* C-WS-0000R-PG *)
   r4146_p18_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_203_2_postel_P_OUT AT r4146_p18_OUT;
   TGL_232_Q {PUBLIC} AT r4146_p18_OUT.GLASS;
(* C-WG-0503S *)
   r4146_p19_OUT : TCIB_C_WG_0503S_OUT;
   (* Aliases *)
   KEY_108_Q {PUBLIC} AT r4146_p19_OUT;
(* C-JC-0201B *)
   r4146_p20_OUT : TCIB_C_JC_0201B_OUT;
   (* Aliases *)
   ROL_203_1_oproti_dveram_OUT AT r4146_p20_OUT;
   ROL_2D3_D {PUBLIC} AT r4146_p20_OUT.DOs.DO1d;
   ROL_2D3_U {PUBLIC} AT r4146_p20_OUT.DOs.DO1u; (* Ter.zad.brána;203 *)
(* C-JC-0201B *)
   r4146_p24_OUT : TCIB_C_JC_0201B_OUT;
   (* Aliases *)
   ROL_203_2_oproti_posteli_OUT AT r4146_p24_OUT;
   ROL_2P3_D {PUBLIC} AT r4146_p24_OUT.DOs.DO1d;
   ROL_2P3_U {PUBLIC} AT r4146_p24_OUT.DOs.DO1u; (* Oproti posteli;203 *)
(* C-WS-0200R-Logus *)
   r4146_p25_OUT : TCIB_C_WS_0200R_Logus_OUT;
   (* Aliases *)
   WS_108_1_Garaz_brana_OUT AT r4146_p25_OUT;
   WSB_108_Q {PUBLIC} AT r4146_p25_OUT.LED.GREEN1;
(* C-WS-0200R-Logus *)
   r4146_p26_OUT : TCIB_C_WS_0200R_Logus_OUT;
   (* Aliases *)
   WS_108_2_Garaz_do_domu_OUT AT r4146_p26_OUT;
   WSB_182_Q {PUBLIC} AT r4146_p26_OUT.LED.GREEN1;
(* C-WS-0000R-PG *)
   r4146_p27_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_106_1_Kupelna_Lavy_OUT AT r4146_p27_OUT;
   TGL_16L_Q {PUBLIC} AT r4146_p27_OUT.GLASS;
(* C-WS-0000R-PG *)
   r4146_p28_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_106_2_Kupelna_Pravy_OUT AT r4146_p28_OUT;
   TGL_16P_Q {PUBLIC} AT r4146_p28_OUT.GLASS;
(* C-WS-0000R-PG *)
   r4146_p29_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_104_3_postel_P_F911D_pri_dverach_OUT AT r4146_p29_OUT;
   TGL_14P_Q {PUBLIC} AT r4146_p29_OUT.GLASS;
(* C-WS-0000R-PG *)
   r4146_p30_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_104_1_pri_dverach_F8FD_postel_p_OUT AT r4146_p30_OUT;
   TGL_14D_Q {PUBLIC} AT r4146_p30_OUT.GLASS;
(* C-WS-0000R-PG *)
   r4146_p31_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_104_2_postel_L_OUT AT r4146_p31_OUT;
   TGL_14L_Q {PUBLIC} AT r4146_p31_OUT.GLASS;
(* CF-2141 *)
   r82_p0_CIB_CONTROL : UINT;
(* C-RQ-0600 *)
   r21040_p0_OUT : TCIB_C_RQ_0600_OUT;
   (* Aliases *)
   CO2_002_Vinaren_OUT AT r21040_p0_OUT;
(* C-WS-0000R-PG *)
   r21040_p1_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_002_Vinaren_pri_dverach_OUT AT r21040_p1_OUT;
   TGL_002_Q {PUBLIC} AT r21040_p1_OUT.GLASS;
(* C-WS-0000R-PG *)
   r21040_p2_OUT : TCIB_C_WS_0000R_PG_OUT := (GLASS := (BLIGHT := 100));
   (* Aliases *)
   TGL_001_Chodba_0_pri_vinarni_OUT AT r21040_p2_OUT;
   TGL_YY1_Q {PUBLIC} AT r21040_p2_OUT.GLASS;
(* C-WS-0200R-Logus *)
   r21040_p3_OUT : TCIB_C_WS_0200R_Logus_OUT;
   (* Aliases *)
   WS_003_Technicka_pri_dverach_OUT AT r21040_p3_OUT;
   WSB_003_Q {PUBLIC} AT r21040_p3_OUT.LED.GREEN1;
(* C-WS-0200R-Logus *)
   r21040_p4_OUT : TCIB_C_WS_0200R_Logus_OUT;
   (* Aliases *)
   WS_006_WC_v_technickej_003_OUT AT r21040_p4_OUT;
   WSB_006_Q {PUBLIC} AT r21040_p4_OUT.LED.GREEN1;
(* C-WS-0200R-Logus *)
   r21040_p5_OUT : TCIB_C_WS_0200R_Logus_OUT;
   (* Aliases *)
   WS_005_Sklad_OUT AT r21040_p5_OUT;
   WSB_005_Q {PUBLIC} AT r21040_p5_OUT.LED.GREEN1;
(* C-WS-0200R-Logus *)
   r21040_p6_OUT : TCIB_C_WS_0200R_Logus_OUT;
   (* Aliases *)
   WS_004_2_Fitko_do_skladu_OUT AT r21040_p6_OUT;
   WSB_04X_Q {PUBLIC} AT r21040_p6_OUT.LED.GREEN1;
(* C-WS-0200R-Logus *)
   r21040_p7_OUT : TCIB_C_WS_0200R_Logus_OUT;
   (* Aliases *)
   WS_004_Fitko_z_chodby_OUT AT r21040_p7_OUT;
   WSB_004_Q {PUBLIC} AT r21040_p7_OUT.LED.GREEN1;
(* C-JC-0201B *)
   r21040_p8_OUT : TCIB_C_JC_0201B_OUT;
   (* Aliases *)
   X10_2xMale_zaluzie_na_Terase_OUT AT r21040_p8_OUT;
   ROL_XTU_D {PUBLIC} AT r21040_p8_OUT.DOs.DO1d;
   ROL_XTU_U {PUBLIC} AT r21040_p8_OUT.DOs.DO1u; (* Roletka 2x;X10 *)
(* ETH1_UNI0 *)
   r0_p0_Control_ETH1_UNI0 : TCHControl2;
   UNI_ETH1_UNI0_OUT : TUNI_ETH1_UNI0_OUT;
END_VAR

VAR_GLOBAL
END_VAR

VAR_EXTERNAL
END_VAR



(* ******************************************************************************* *)
(* Generováno programem Mosaic *)
(* © 2001-2026 Teco a.s. *)
