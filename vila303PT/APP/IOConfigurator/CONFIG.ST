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

   TZONE_ARRAY_CH5_RX : ARRAY[0..249] OF USINT;

   TUNI_CH5_IN : STRUCT
      STAT : TUniStat;
      ERR : USINT;
      NUMR : UINT;
      DATA : TZONE_ARRAY_CH5_RX;
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

   TZONE_ARRAY_CH5_TX : ARRAY[0..49] OF USINT;

   TUNI_CH5_OUT : STRUCT
      CONT : TUniCont;
      SIGN : TUniSign;
      NUMT : UINT;
      DATA : TZONE_ARRAY_CH5_TX;
   END_STRUCT;

   TBIN_4DI : STRUCT
      DI0 : BOOL;
      DI1 : BOOL;
      DI2 : BOOL;
      DI3 : BOOL;
      dummy4 {HIDDEN} : BOOL;
      dummy5 {HIDDEN} : BOOL;
      dummy6 {HIDDEN} : BOOL;
      dummy7 {HIDDEN} : BOOL;
   END_STRUCT;

   TCNTF_IN : STRUCT
      SCNT : UINT;
      VALA : UDINT;
      VALB : UDINT;
   END_STRUCT;

   DT_IR1501_IN : STRUCT
      DIS : TBIN_4DI;
      DIP : TBIN_4DIP;
      CNT_IN1 : TCNTF_IN;
      CNT_IN2 : TCNTF_IN;
   END_STRUCT;

   TBIN_8DOW : STRUCT
      DO0 : BOOL;
      DO1 : BOOL;
      DO2 : BOOL;
      DO3 : BOOL;
      DO4 : BOOL;
      DO5 : BOOL;
      DO6 : BOOL;
      DO7 : BOOL;
      dummy8 {HIDDEN} : BOOL;
      dummy9 {HIDDEN} : BOOL;
      dummy10 {HIDDEN} : BOOL;
      dummy11 {HIDDEN} : BOOL;
      dummy12 {HIDDEN} : BOOL;
      dummy13 {HIDDEN} : BOOL;
      dummy14 {HIDDEN} : BOOL;
      dummy15 {HIDDEN} : BOOL;
   END_STRUCT;

   TCNTF_OUT : STRUCT
      CCNT : UINT;
      SET : UDINT;
   END_STRUCT;

   DT_IR1501_OUT : STRUCT
      DOS : TBIN_8DOW;
      CNT_OUT1 : TCNTF_OUT;
      CNT_OUT2 : TCNTF_OUT;
   END_STRUCT;

   TCIB_CWS4LO_BTN : STRUCT
      UP1 : BOOL;
      DOWN1 : BOOL;
      UP2 : BOOL;
      DOWN2 : BOOL;
      DI1 : BOOL;
      DI2 : BOOL;
      dummy6 {HIDDEN} : BOOL;
      dummy7 {HIDDEN} : BOOL;
      CLICK_UP1 : BOOL;
      CLICK_DOWN1 : BOOL;
      CLICK_UP2 : BOOL;
      CLICK_DOWN2 : BOOL;
      CLICK_DI1 : BOOL;
      CLICK_DI2 : BOOL;
      dummy14 {HIDDEN} : BOOL;
      dummy15 {HIDDEN} : BOOL;
      PRESS_UP1 : BOOL;
      PRESS_DOWN1 : BOOL;
      PRESS_UP2 : BOOL;
      PRESS_DOWN2 : BOOL;
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

   TCIB_C_WS_0400R_Logus_IN : STRUCT
      DI : TCIB_CWS4LO_BTN;
      STAT : TCIB_CWSLo_STAT;
      THERM : REAL;
      AI1 : REAL;
      AI2 : REAL;
   END_STRUCT;

   TCIB_WSB_LED4 : STRUCT
      GREEN1 : BOOL;
      RED1 : BOOL;
      GREEN2 : BOOL;
      RED2 : BOOL;
      dummy4 {HIDDEN} : BOOL;
      dummy5 {HIDDEN} : BOOL;
      dummy6 {HIDDEN} : BOOL;
      dummy7 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_C_WS_0400R_Logus_OUT : STRUCT
      LED : TCIB_WSB_LED4;
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

   TCIB_C_OR_0008M_IN : STRUCT
      STAT : TCIB_COR_STAT;
   END_STRUCT;

   TCIB_DO8 : STRUCT
      DO1 : BOOL;
      DO2 : BOOL;
      DO3 : BOOL;
      DO4 : BOOL;
      DO5 : BOOL;
      DO6 : BOOL;
      DO7 : BOOL;
      DO8 : BOOL;
   END_STRUCT;

   TCIB_C_OR_0008M_OUT : STRUCT
      DOs : TCIB_DO8;
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

   TCIB_DI18 : STRUCT
      DI1 : BOOL;
      DI2 : BOOL;
      DI3 : BOOL;
      DI4 : BOOL;
      DI5 : BOOL;
      DI6 : BOOL;
      DI7 : BOOL;
      DI8 : BOOL;
      DI9 : BOOL;
      DI10 : BOOL;
      DI11 : BOOL;
      DI12 : BOOL;
      DI13 : BOOL;
      DI14 : BOOL;
      DI15 : BOOL;
      DI16 : BOOL;
      DI17 : BOOL;
      DI18 : BOOL;
      dummy18 {HIDDEN} : BOOL;
      dummy19 {HIDDEN} : BOOL;
      dummy20 {HIDDEN} : BOOL;
      dummy21 {HIDDEN} : BOOL;
      dummy22 {HIDDEN} : BOOL;
      dummy23 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_CLICK18 : STRUCT
      CLICK1 : BOOL;
      CLICK2 : BOOL;
      CLICK3 : BOOL;
      CLICK4 : BOOL;
      CLICK5 : BOOL;
      CLICK6 : BOOL;
      CLICK7 : BOOL;
      CLICK8 : BOOL;
      CLICK9 : BOOL;
      CLICK10 : BOOL;
      CLICK11 : BOOL;
      CLICK12 : BOOL;
      CLICK13 : BOOL;
      CLICK14 : BOOL;
      CLICK15 : BOOL;
      CLICK16 : BOOL;
      CLICK17 : BOOL;
      CLICK18 : BOOL;
      dummy18 {HIDDEN} : BOOL;
      dummy19 {HIDDEN} : BOOL;
      dummy20 {HIDDEN} : BOOL;
      dummy21 {HIDDEN} : BOOL;
      dummy22 {HIDDEN} : BOOL;
      dummy23 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_PRESS18 : STRUCT
      PRESS1 : BOOL;
      PRESS2 : BOOL;
      PRESS3 : BOOL;
      PRESS4 : BOOL;
      PRESS5 : BOOL;
      PRESS6 : BOOL;
      PRESS7 : BOOL;
      PRESS8 : BOOL;
      PRESS9 : BOOL;
      PRESS10 : BOOL;
      PRESS11 : BOOL;
      PRESS12 : BOOL;
      PRESS13 : BOOL;
      PRESS14 : BOOL;
      PRESS15 : BOOL;
      PRESS16 : BOOL;
      PRESS17 : BOOL;
      PRESS18 : BOOL;
      dummy18 {HIDDEN} : BOOL;
      dummy19 {HIDDEN} : BOOL;
      dummy20 {HIDDEN} : BOOL;
      dummy21 {HIDDEN} : BOOL;
      dummy22 {HIDDEN} : BOOL;
      dummy23 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_TAMPER18 : STRUCT
      TAMPER1 : BOOL;
      TAMPER2 : BOOL;
      TAMPER3 : BOOL;
      TAMPER4 : BOOL;
      TAMPER5 : BOOL;
      TAMPER6 : BOOL;
      TAMPER7 : BOOL;
      TAMPER8 : BOOL;
      TAMPER9 : BOOL;
      TAMPER10 : BOOL;
      TAMPER11 : BOOL;
      TAMPER12 : BOOL;
      TAMPER13 : BOOL;
      TAMPER14 : BOOL;
      TAMPER15 : BOOL;
      TAMPER16 : BOOL;
      TAMPER17 : BOOL;
      TAMPER18 : BOOL;
      dummy18 {HIDDEN} : BOOL;
      dummy19 {HIDDEN} : BOOL;
      dummy20 {HIDDEN} : BOOL;
      dummy21 {HIDDEN} : BOOL;
      dummy22 {HIDDEN} : BOOL;
      dummy23 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_CIB1800M : STRUCT
      DI : TCIB_DI18;
      CLICK : TCIB_CLICK18;
      PRESS : TCIB_PRESS18;
      TAMPER : TCIB_TAMPER18;
   END_STRUCT;

   TCIB_AI4_STAT : STRUCT
      OUF1 : BOOL;
      VLD1 : BOOL;
      OUF2 : BOOL;
      VLD2 : BOOL;
      OUF3 : BOOL;
      VLD3 : BOOL;
      OUF4 : BOOL;
      VLD4 : BOOL;
   END_STRUCT;

   r4146_p10_TCIB_C_IB_1800M_IN : STRUCT
      DIs : TCIB_CIB1800M;
      STAT : TCIB_AI4_STAT;
      AI1 : REAL;
      AI2 : REAL;
      AI3 : REAL;
      AI4 : REAL;
   END_STRUCT;

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

   TCIB_RI_STAT : STRUCT
      OUF1 : BOOL;
      VLD1 : BOOL;
      OUF2 : BOOL;
      VLD2 : BOOL;
      OUFI : BOOL;
      VLDI : BOOL;
      dummy6 {HIDDEN} : BOOL;
      dummy7 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_RI_THERM : STRUCT
      AI1 : REAL;
      AI2 : REAL;
   END_STRUCT;

   TCIB_DI2 : STRUCT
      DI1 : BOOL;
      DI2 : BOOL;
      dummy2 {HIDDEN} : BOOL;
      dummy3 {HIDDEN} : BOOL;
      dummy4 {HIDDEN} : BOOL;
      dummy5 {HIDDEN} : BOOL;
      dummy6 {HIDDEN} : BOOL;
      dummy7 {HIDDEN} : BOOL;
   END_STRUCT;

   TCIB_IRStat : STRUCT
      Receive_End : BOOL;
      Err_Receive : BOOL;
      Transmit_End : BOOL;
      Learn_End : BOOL;
      Err_Learn : BOOL;
      Clear_End : BOOL;
      dummy6 {HIDDEN} : BOOL;
      ErrMode : BOOL;
   END_STRUCT;

   TCIB_IRin : STRUCT
      stat : TCIB_IRStat;
      IR_code : UINT;
   END_STRUCT;

   TCIB_C_RI_0401S_IN : STRUCT
      STAT : TCIB_RI_STAT;
      THERM : TCIB_RI_THERM;
      LIGHT : UINT;
      DI : TCIB_DI2;
      IRin : TCIB_IRin;
   END_STRUCT;

   TCIB_IRControl : STRUCT
      Receive_ON : BOOL;
      Transmit_ON : BOOL;
      Learn_ON : BOOL;
      Learn_Mask : BOOL;
      Clear : BOOL;
      LED_AUTO : BOOL;
      LED_ON : BOOL;
      LED_Blink : BOOL;
   END_STRUCT;

   TCIB_IRout : STRUCT
      cont : TCIB_IRControl;
      IR_code : UINT;
   END_STRUCT;

   TCIB_C_RI_0401S_OUT : STRUCT
      IRout : TCIB_IRout;
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
(* CH5 *)
   r16_p2_Statistic_CH5 : TCHStatistic;
   r16_p2_UNI_CH5_IN : TUNI_CH5_IN;
(* IR-1501 *)
   r4128_p23_IN : DT_IR1501_IN;
   (* Aliases *)
   IO_10_IN AT r4128_p23_IN;
   GAT_X01_Q {PUBLIC} AT r4128_p23_IN.DIS.DI0;
(* C-WS-0400R-Logus *)
   r4144_p0_IN : TCIB_C_WS_0400R_Logus_IN;
   (* Aliases *)
   WS_106_2_IN AT r4144_p0_IN;
   TER_1W6 {PUBLIC} AT r4144_p0_IN.THERM; (* Kúp_1P-WC 356E;106 *)
   WSB_1W6_4 {PUBLIC} AT r4144_p0_IN.DI.UP1; (* Kúp_1P-WC;106 *)
(* C-WS-0400R-Logus *)
   r4144_p1_IN : TCIB_C_WS_0400R_Logus_IN;
   (* Aliases *)
   WS_206_IN AT r4144_p1_IN;
   TER_206 {PUBLIC} AT r4144_p1_IN.THERM; (* Izba 2.06;206 *)
   WSB_206_4 {PUBLIC} AT r4144_p1_IN.DI.UP1; (* Izba 2.06;206 *)
(* C-RQ-0600 *)
   r4144_p2_IN : TCIB_C_RQ_0600_IN;
   (* Aliases *)
   RQ6_01_IN AT r4144_p2_IN;
(* C-WS-0200R-Logus *)
   r4144_p3_IN : TCIB_C_WS_0200R_Logus_IN;
   (* Aliases *)
   WS_106_1_IN AT r4144_p3_IN;
   TER_106 {PUBLIC} AT r4144_p3_IN.THERM; (* Kúpelna_1P;106 *)
   WSB_106_2 {PUBLIC} AT r4144_p3_IN.DI.UP1; (* Kúpelna_1P;106 *)
(* C-WS-0400R-Logus *)
   r4144_p4_IN : TCIB_C_WS_0400R_Logus_IN;
   (* Aliases *)
   WS_001_P_IN AT r4144_p4_IN;
   WSB_0P1_4 {PUBLIC} AT r4144_p4_IN.DI.UP1; (* Vst.Hala-P;001 *)
(* C-WS-0400R-Logus *)
   r4144_p5_IN : TCIB_C_WS_0400R_Logus_IN;
   (* Aliases *)
   WS_001_L_IN AT r4144_p5_IN;
   TER_001 {PUBLIC} AT r4144_p5_IN.THERM; (* Vstup.hala;001 *)
   WSB_0L1_4 {PUBLIC} AT r4144_p5_IN.DI.UP1; (* Vst.Hala-L;001 *)
(* C-WS-0400R-Logus *)
   r4144_p6_IN : TCIB_C_WS_0400R_Logus_IN;
   (* Aliases *)
   WS_007_1_IN AT r4144_p6_IN;
   TER_007 {PUBLIC} AT r4144_p6_IN.THERM; (* Chodba-PP;007 *)
   WSB_007_4 {PUBLIC} AT r4144_p6_IN.DI.UP1; (* Chodba-Fitko;007 *)
(* C-WS-0400R-Logus *)
   r4144_p7_IN : TCIB_C_WS_0400R_Logus_IN;
   (* Aliases *)
   WS_007_2_IN AT r4144_p7_IN;
   TER_010 {PUBLIC} AT r4144_p7_IN.THERM; (* Chodba_PP/WC/Kúp.;007 *)
   WSB_0B7_4 {PUBLIC} AT r4144_p7_IN.DI.UP1; (* Chodba_PP-WC;007 *)
(* C-WS-0400R-Logus *)
   r4144_p8_IN : TCIB_C_WS_0400R_Logus_IN;
   (* Aliases *)
   WS_021_IN AT r4144_p8_IN;
   TER_021 {PUBLIC} AT r4144_p8_IN.THERM; (* Kotolna;021 *)
   WSB_021_4 {PUBLIC} AT r4144_p8_IN.DI.UP1; (* Kotolna;021 *)
(* C-WS-0400R-Logus *)
   r4144_p9_IN : TCIB_C_WS_0400R_Logus_IN;
   (* Aliases *)
   WS_020_IN AT r4144_p9_IN;
   TER_020 {PUBLIC} AT r4144_p9_IN.THERM; (* Show Room;020 *)
   WSB_020_4 {PUBLIC} AT r4144_p9_IN.DI.UP1; (* Show Room;020 *)
(* C-WS-0400R-Logus *)
   r4144_p10_IN : TCIB_C_WS_0400R_Logus_IN;
   (* Aliases *)
   WS_104_2_IN AT r4144_p10_IN;
   WSB_1P4_4 {PUBLIC} AT r4144_p10_IN.DI.UP1; (* Obýv.Schody-P;104 *)
(* C-WS-0400R-Logus *)
   r4144_p11_IN : TCIB_C_WS_0400R_Logus_IN;
   (* Aliases *)
   WS_207_IN AT r4144_p11_IN;
   TER_207 {PUBLIC} AT r4144_p11_IN.THERM; (* Kúpelna_2P;207 *)
   WSB_207_4 {PUBLIC} AT r4144_p11_IN.DI.UP1; (* Kúpelna_2P;207 *)
(* C-WS-0400R-Logus *)
   r4144_p12_IN : TCIB_C_WS_0400R_Logus_IN;
   (* Aliases *)
   WS_104_1_IN AT r4144_p12_IN;
   TER_104 {PUBLIC} AT r4144_p12_IN.THERM; (* Obýv.-stred;104 *)
   WSB_104_4 {PUBLIC} AT r4144_p12_IN.DI.UP1; (* Obýv.Schody-L;104 *)
(* C-WS-0400R-Logus *)
   r4144_p13_IN : TCIB_C_WS_0400R_Logus_IN;
   (* Aliases *)
   WS_104_3_IN AT r4144_p13_IN;
   WSB_1T4_4 {PUBLIC} AT r4144_p13_IN.DI.UP1; (* Obýv-Na terasu;104 *)
(* C-WS-0400R-Logus *)
   r4144_p14_IN : TCIB_C_WS_0400R_Logus_IN;
   (* Aliases *)
   WS_X11_IN AT r4144_p14_IN;
   TER_X11 {PUBLIC} AT r4144_p14_IN.THERM; (* Terasa-velká;X11 *)
   WSB_X11_4 {PUBLIC} AT r4144_p14_IN.DI.UP1; (* Terasa-velká;X11 *)
(* C-WS-0400R-Logus *)
   r4144_p15_IN : TCIB_C_WS_0400R_Logus_IN;
   (* Aliases *)
   WS_104_4_IN AT r4144_p15_IN;
   TER_1C4 {PUBLIC} AT r4144_p15_IN.THERM; (* Obyv-do chodby;104 *)
   WSB_1C4_4 {PUBLIC} AT r4144_p15_IN.DI.UP1; (* Obyv-do chodby;104 *)
(* C-WS-0400R-Logus *)
   r4144_p16_IN : TCIB_C_WS_0400R_Logus_IN;
   (* Aliases *)
   WS_105_IN AT r4144_p16_IN;
   TER_105 {PUBLIC} AT r4144_p16_IN.THERM; (* Chodba_1P;105 *)
   WSB_105_4 {PUBLIC} AT r4144_p16_IN.DI.UP1; (* Chodba_1P;105 *)
(* C-WS-0400R-Logus *)
   r4144_p17_IN : TCIB_C_WS_0400R_Logus_IN;
   (* Aliases *)
   WS_107_IN AT r4144_p17_IN;
   TER_107 {PUBLIC} AT r4144_p17_IN.THERM; (* Izba 1.07;107 *)
   WSB_107_4 {PUBLIC} AT r4144_p17_IN.DI.UP1; (* Izba 1.07;107 *)
(* C-WS-0400R-Logus *)
   r4144_p18_IN : TCIB_C_WS_0400R_Logus_IN;
   (* Aliases *)
   WS_108_IN AT r4144_p18_IN;
   TER_108 {PUBLIC} AT r4144_p18_IN.THERM; (* Izba 1.08;108 *)
   WSB_108_4 {PUBLIC} AT r4144_p18_IN.DI.UP1; (* Izba 1.08;108 *)
(* C-WS-0400R-Logus *)
   r4144_p19_IN : TCIB_C_WS_0400R_Logus_IN;
   (* Aliases *)
   WS_204_2_IN AT r4144_p19_IN;
   WSB_204_4 {PUBLIC} AT r4144_p19_IN.DI.UP1; (* Kuchyna-P;204 *)
(* C-WS-0400R-Logus *)
   r4144_p20_IN : TCIB_C_WS_0400R_Logus_IN;
   (* Aliases *)
   WS_204_1_IN AT r4144_p20_IN;
   TER_2L4 {PUBLIC} AT r4144_p20_IN.THERM; (* Kuchyna;204 *)
   WSB_2L4_4 {PUBLIC} AT r4144_p20_IN.DI.UP1; (* Kuchyna-L;204 *)
(* C-WS-0400R-Logus *)
   r4144_p21_IN : TCIB_C_WS_0400R_Logus_IN;
   (* Aliases *)
   WS_204_3_IN AT r4144_p21_IN;
   WSB_2T4_4 {PUBLIC} AT r4144_p21_IN.DI.UP1; (* Kuch-terasa;204 *)
(* C-WS-0200R-Logus *)
   r4144_p22_IN : TCIB_C_WS_0200R_Logus_IN;
   (* Aliases *)
   WS_106_3_IN AT r4144_p22_IN;
   TER_1A6 {PUBLIC} AT r4144_p22_IN.THERM; (* Kúp_106-Vana AFC1;106 *)
   WSB_1A6_2 {PUBLIC} AT r4144_p22_IN.DI.UP1; (* Kúp_106-Vana;106  *)
(* C-WS-0200R-Logus *)
   r4144_p23_IN : TCIB_C_WS_0200R_Logus_IN;
   (* Aliases *)
   WS_005_IN AT r4144_p23_IN;
   TER_005 {PUBLIC} AT r4144_p23_IN.THERM; (* Garáž;005 *)
   GAT_005_Q {PUBLIC} AT r4144_p23_IN.DI.DI1;
   WSB_005_2 {PUBLIC} AT r4144_p23_IN.DI.UP1; (* Garáž;005 *)
(* C-WS-0200R-Logus *)
   r4144_p24_IN : TCIB_C_WS_0200R_Logus_IN;
   (* Aliases *)
   WS_008_IN AT r4144_p24_IN;
   TER_008 {PUBLIC} AT r4144_p24_IN.THERM; (* Fitko;008 *)
   WSB_008_2 {PUBLIC} AT r4144_p24_IN.DI.UP1; (* Fitko;008 *)
(* C-WS-0200R-Logus *)
   r4144_p25_IN : TCIB_C_WS_0200R_Logus_IN;
   (* Aliases *)
   WS_006_IN AT r4144_p25_IN;
   TER_006 {PUBLIC} AT r4144_p25_IN.THERM; (* Sklad;006 *)
   WSB_006_2 {PUBLIC} AT r4144_p25_IN.DI.UP1; (* Sklad;006 *)
(* C-OR-0011M-800 *)
   r4146_p0_IN : TCIB_C_OR_0011M_800_IN;
   (* Aliases *)
   IO_09_IN AT r4146_p0_IN;
(* C-OR-0011M-800 *)
   r4146_p1_IN : TCIB_C_OR_0011M_800_IN;
   (* Aliases *)
   IO_02_IN AT r4146_p1_IN;
(* C-OR-0011M-800 *)
   r4146_p2_IN : TCIB_C_OR_0011M_800_IN;
   (* Aliases *)
   IO_04_IN AT r4146_p2_IN;
(* C-OR-0008M *)
   r4146_p3_IN : TCIB_C_OR_0008M_IN;
   (* Aliases *)
   IO_03_IN AT r4146_p3_IN;
(* C-OR-0008M *)
   r4146_p4_IN : TCIB_C_OR_0008M_IN;
   (* Aliases *)
   IO_06_IN AT r4146_p4_IN;
(* C-OR-0011M-800 *)
   r4146_p5_IN : TCIB_C_OR_0011M_800_IN;
   (* Aliases *)
   IO_05_IN AT r4146_p5_IN;
(* C-OR-0011M-800 *)
   r4146_p6_IN : TCIB_C_OR_0011M_800_IN;
   (* Aliases *)
   IO_01_IN AT r4146_p6_IN;
(* C-JC-0006M *)
   r4146_p7_IN : TCIB_C_JC_0006M_IN;
   (* Aliases *)
   IO_07_IN AT r4146_p7_IN;
(* C-JC-0006M *)
   r4146_p8_IN : TCIB_C_JC_0006M_IN;
   (* Aliases *)
   IO_08_IN AT r4146_p8_IN;
(* C-OR-0011M-800 *)
   r4146_p9_IN : TCIB_C_OR_0011M_800_IN;
   (* Aliases *)
   NH_11_IN AT r4146_p9_IN;
(* C-IB-1800M *)
   r4146_p10_IN : r4146_p10_TCIB_C_IB_1800M_IN;
   (* Aliases *)
   NH_10_IN AT r4146_p10_IN;
   PIR_207 {PUBLIC} AT r4146_p10_IN.DIs.DI.DI12; (* Kúpelna_2P;207 *)
   PIR_010 {PUBLIC} AT r4146_p10_IN.DIs.DI.DI11; (* Kúpelna_PP;010 *)
   PIR_1A6 {PUBLIC} AT r4146_p10_IN.DIs.DI.DI9; (* Chodbicka;106 *)
   PIR_009 {PUBLIC} AT r4146_p10_IN.DIs.DI.DI8; (* WC_PP;009 *)
   PIR_106 {PUBLIC} AT r4146_p10_IN.DIs.DI.DI7; (* Vana;106 *)
(* C-IT-0504S *)
   r4146_p11_IN : TCIB_C_IT_0504S_IN;
   (* Aliases *)
   NH_021_IN AT r4146_p11_IN;
   TEK_021 {PUBLIC} AT r4146_p11_IN.AI.AI1; (* Kotol;021 *)
(* C-RI-0401S *)
   r4146_p12_IN : TCIB_C_RI_0401S_IN;
   (* Aliases *)
   NH_X22_IN AT r4146_p12_IN;
   LUX_X01_1 {PUBLIC} AT r4146_p12_IN.LIGHT; (* Súmrak vonku;X01 *)
   TER_X01 {PUBLIC} AT r4146_p12_IN.THERM.AI1; (* Vonk.teplota;X01 *)
END_VAR

VAR_GLOBAL_OUTPUT
(* CP-2000 *)
   r0_p0_ITCL_CONTROL : UINT;
   r16_p1_TCL2_CONTROL : UINT;
   r16_p1_CIB_CONTROL : UINT;
   r16_p2_CIB_CONTROL : UINT;
   r16_p6_IO_OUT : DT_IR2553_OUT;
   r16_p7_DISP_OUT : DT_OI2872_OUT;
(* CH5 *)
   r16_p2_Control_CH5 : TCHControl2;
   r16_p2_UNI_CH5_OUT : TUNI_CH5_OUT;
(* IR-1501 *)
   r4128_p23_OUT : DT_IR1501_OUT;
   (* Aliases *)
   IO_10_OUT AT r4128_p23_OUT;
   TVE_107_0 {PUBLIC} AT r4128_p23_OUT.DOS.DO2; (* Izba 1.07;107 *)
   TVE_005_0 {PUBLIC} AT r4128_p23_OUT.DOS.DO1; (* Garáž;005 *)
   TVE_010_0 {PUBLIC} AT r4128_p23_OUT.DOS.DO0; (* Kúpelna_PP;010 *)
(* C-WS-0400R-Logus *)
   r4144_p0_OUT : TCIB_C_WS_0400R_Logus_OUT;
   (* Aliases *)
   WS_106_2_OUT AT r4144_p0_OUT;
   WSB_1W6_Q {PUBLIC} AT r4144_p0_OUT.LED.GREEN1;
(* C-WS-0400R-Logus *)
   r4144_p1_OUT : TCIB_C_WS_0400R_Logus_OUT;
   (* Aliases *)
   WS_206_OUT AT r4144_p1_OUT;
   WSB_206_Q {PUBLIC} AT r4144_p1_OUT.LED.GREEN1;
(* C-RQ-0600 *)
   r4144_p2_OUT : TCIB_C_RQ_0600_OUT;
   (* Aliases *)
   RQ6_01_OUT AT r4144_p2_OUT;
(* C-WS-0200R-Logus *)
   r4144_p3_OUT : TCIB_C_WS_0200R_Logus_OUT;
   (* Aliases *)
   WS_106_1_OUT AT r4144_p3_OUT;
   WSB_106_Q {PUBLIC} AT r4144_p3_OUT.LED.GREEN1;
(* C-WS-0400R-Logus *)
   r4144_p4_OUT : TCIB_C_WS_0400R_Logus_OUT;
   (* Aliases *)
   WS_001_P_OUT AT r4144_p4_OUT;
   WSB_0P1_Q AT r4144_p4_OUT.LED.GREEN1;
(* C-WS-0400R-Logus *)
   r4144_p5_OUT : TCIB_C_WS_0400R_Logus_OUT;
   (* Aliases *)
   WS_001_L_OUT AT r4144_p5_OUT;
   WSB_0L1_Q {PUBLIC} AT r4144_p5_OUT.LED.GREEN1;
(* C-WS-0400R-Logus *)
   r4144_p6_OUT : TCIB_C_WS_0400R_Logus_OUT;
   (* Aliases *)
   WS_007_1_OUT AT r4144_p6_OUT;
   WSB_007_Q {PUBLIC} AT r4144_p6_OUT.LED.GREEN1;
(* C-WS-0400R-Logus *)
   r4144_p7_OUT : TCIB_C_WS_0400R_Logus_OUT;
   (* Aliases *)
   WS_007_2_OUT AT r4144_p7_OUT;
   WSB_0B7_Q {PUBLIC} AT r4144_p7_OUT.LED.GREEN1;
(* C-WS-0400R-Logus *)
   r4144_p8_OUT : TCIB_C_WS_0400R_Logus_OUT;
   (* Aliases *)
   WS_021_OUT AT r4144_p8_OUT;
   WSB_021_Q {PUBLIC} AT r4144_p8_OUT.LED.GREEN1;
(* C-WS-0400R-Logus *)
   r4144_p9_OUT : TCIB_C_WS_0400R_Logus_OUT;
   (* Aliases *)
   WS_020_OUT AT r4144_p9_OUT;
   WSB_020_Q {PUBLIC} AT r4144_p9_OUT.LED.GREEN1;
(* C-WS-0400R-Logus *)
   r4144_p10_OUT : TCIB_C_WS_0400R_Logus_OUT;
   (* Aliases *)
   WS_104_2_OUT AT r4144_p10_OUT;
   WSB_1P4_Q {PUBLIC} AT r4144_p10_OUT.LED.GREEN1;
(* C-WS-0400R-Logus *)
   r4144_p11_OUT : TCIB_C_WS_0400R_Logus_OUT;
   (* Aliases *)
   WS_207_OUT AT r4144_p11_OUT;
   WSB_207_Q {PUBLIC} AT r4144_p11_OUT.LED.GREEN1;
(* C-WS-0400R-Logus *)
   r4144_p12_OUT : TCIB_C_WS_0400R_Logus_OUT;
   (* Aliases *)
   WS_104_1_OUT AT r4144_p12_OUT;
   WSB_104_Q {PUBLIC} AT r4144_p12_OUT.LED.GREEN1;
(* C-WS-0400R-Logus *)
   r4144_p13_OUT : TCIB_C_WS_0400R_Logus_OUT;
   (* Aliases *)
   WS_104_3_OUT AT r4144_p13_OUT;
   WSB_1T4_Q {PUBLIC} AT r4144_p13_OUT.LED.GREEN1;
(* C-WS-0400R-Logus *)
   r4144_p14_OUT : TCIB_C_WS_0400R_Logus_OUT;
   (* Aliases *)
   WS_X11_OUT AT r4144_p14_OUT;
   WSB_X11_Q {PUBLIC} AT r4144_p14_OUT.LED.GREEN1;
(* C-WS-0400R-Logus *)
   r4144_p15_OUT : TCIB_C_WS_0400R_Logus_OUT;
   (* Aliases *)
   WS_104_4_OUT AT r4144_p15_OUT;
   WSB_1C4_Q {PUBLIC} AT r4144_p15_OUT.LED.GREEN1;
(* C-WS-0400R-Logus *)
   r4144_p16_OUT : TCIB_C_WS_0400R_Logus_OUT;
   (* Aliases *)
   WS_105_OUT AT r4144_p16_OUT;
   WSB_105_Q {PUBLIC} AT r4144_p16_OUT.LED.GREEN1;
(* C-WS-0400R-Logus *)
   r4144_p17_OUT : TCIB_C_WS_0400R_Logus_OUT;
   (* Aliases *)
   WS_107_OUT AT r4144_p17_OUT;
   WSB_107_Q {PUBLIC} AT r4144_p17_OUT.LED.GREEN1;
(* C-WS-0400R-Logus *)
   r4144_p18_OUT : TCIB_C_WS_0400R_Logus_OUT;
   (* Aliases *)
   WS_108_OUT AT r4144_p18_OUT;
   WSB_108_Q {PUBLIC} AT r4144_p18_OUT.LED.GREEN1;
(* C-WS-0400R-Logus *)
   r4144_p19_OUT : TCIB_C_WS_0400R_Logus_OUT;
   (* Aliases *)
   WSB_204_Q {PUBLIC} AT r4144_p19_OUT.LED.GREEN1;
(* C-WS-0400R-Logus *)
   r4144_p20_OUT : TCIB_C_WS_0400R_Logus_OUT;
   (* Aliases *)
   WSB_2L4_Q {PUBLIC} AT r4144_p20_OUT.LED.GREEN1;
(* C-WS-0400R-Logus *)
   r4144_p21_OUT : TCIB_C_WS_0400R_Logus_OUT;
   (* Aliases *)
   WS_204_3_OUT AT r4144_p21_OUT;
   WSB_2T4_Q {PUBLIC} AT r4144_p21_OUT.LED.GREEN1;
(* C-WS-0200R-Logus *)
   r4144_p22_OUT : TCIB_C_WS_0200R_Logus_OUT;
   (* Aliases *)
   WS_106_3_OUT AT r4144_p22_OUT;
   WSB_1A6_Q {PUBLIC} AT r4144_p22_OUT.LED.GREEN1;
(* C-WS-0200R-Logus *)
   r4144_p23_OUT : TCIB_C_WS_0200R_Logus_OUT;
   (* Aliases *)
   WS_005_OUT AT r4144_p23_OUT;
   WSB_005_Q {PUBLIC} AT r4144_p23_OUT.LED.GREEN1;
(* C-WS-0200R-Logus *)
   r4144_p24_OUT : TCIB_C_WS_0200R_Logus_OUT;
   (* Aliases *)
   WS_008_OUT AT r4144_p24_OUT;
   WSB_008_Q {PUBLIC} AT r4144_p24_OUT.LED.GREEN1;
(* C-WS-0200R-Logus *)
   r4144_p25_OUT : TCIB_C_WS_0200R_Logus_OUT;
   (* Aliases *)
   WS_006_OUT AT r4144_p25_OUT;
   WSB_006_Q {PUBLIC} AT r4144_p25_OUT.LED.GREEN1;
(* C-OR-0011M-800 *)
   r4146_p0_OUT : TCIB_C_OR_0011M_800_OUT;
   (* Aliases *)
   IO_09_OUT AT r4146_p0_OUT;
   GAT_005_0 {PUBLIC} AT r4146_p0_OUT.DOs.DO11; (* Brána-garáž;005 *)
   TVE_2X4_0 {PUBLIC} AT r4146_p0_OUT.DOs.DO10; (* Kuchyna-P;204 *)
   TVE_204_0 {PUBLIC} AT r4146_p0_OUT.DOs.DO9; (* Kuchyna-S;204 *)
   TVE_2K4_0 {PUBLIC} AT r4146_p0_OUT.DOs.DO8; (* Kuchyna-L;204 *)
   TVE_020_0 {PUBLIC} AT r4146_p0_OUT.DOs.DO7; (* Show Room;020 *)
   TVE_006_0 {PUBLIC} AT r4146_p0_OUT.DOs.DO6; (* Sklad;006 *)
   TVE_008_0 {PUBLIC} AT r4146_p0_OUT.DOs.DO5; (* Fitko;008 *)
   TVE_001_0 {PUBLIC} AT r4146_p0_OUT.DOs.DO4; (* Vstup.Hala;001 *)
   TVE_R10_0 {PUBLIC} AT r4146_p0_OUT.DOs.DO3; (* Rebrík;010 *)
   TVE_009_0 {PUBLIC} AT r4146_p0_OUT.DOs.DO2; (* WC PP;009 *)
   TVE_002_0 {PUBLIC} AT r4146_p0_OUT.DOs.DO1; (* Schody PP1;002 *)
(* C-OR-0011M-800 *)
   r4146_p1_OUT : TCIB_C_OR_0011M_800_OUT;
   (* Aliases *)
   IO_02_OUT AT r4146_p1_OUT;
   SVD_108 {PUBLIC} AT r4146_p1_OUT.DOs.DO11; (* Strop 1.08;108 *)
   SVD_1A7 {PUBLIC} AT r4146_p1_OUT.DOs.DO10; (* Strop 1.07;107 *)
   SVD_1F4 {PUBLIC} AT r4146_p1_OUT.DOs.DO9; (* Štorec.2;104 *)
   SVD_1E4 {PUBLIC} AT r4146_p1_OUT.DOs.DO8; (* Štvorec.1;104 *)
   SVD_107 {PUBLIC} AT r4146_p1_OUT.DOs.DO7; (* Podhlad 1.07;107 *)
   SVD_Y01 {PUBLIC} AT r4146_p1_OUT.DOs.DO6; (* LP SP.30 ? *)
   SVD_1D4 {PUBLIC} AT r4146_p1_OUT.DOs.DO5; (* Chodba-obýv.;104 *)
   SVD_1B6 {PUBLIC} AT r4146_p1_OUT.DOs.DO4; (* WC-podhlad;106 *)
   SVD_1A6 {PUBLIC} AT r4146_p1_OUT.DOs.DO3; (* Podhlad-Vana_1P;106 *)
   SVD_1C4 {PUBLIC} AT r4146_p1_OUT.DOs.DO2; (* Strop.3-obýv.;104 *)
   SVD_1B4 {PUBLIC} AT r4146_p1_OUT.DOs.DO1; (* Strop.2-obýv.;104 *)
(* C-OR-0011M-800 *)
   r4146_p2_OUT : TCIB_C_OR_0011M_800_OUT;
   (* Aliases *)
   IO_04_OUT AT r4146_p2_OUT;
   SVD_XZ1 {PUBLIC} AT r4146_p2_OUT.DOs.DO11; (* Stena;X11 *)
   SVD_XY1 {PUBLIC} AT r4146_p2_OUT.DOs.DO10; (* Bodovky;X11 *)
   SVD_009 {PUBLIC} AT r4146_p2_OUT.DOs.DO9; (* Strop-WC_PP;009 *)
   SVD_0E0 {PUBLIC} AT r4146_p2_OUT.DOs.DO8; (* Strop-Kúp_PP;010 *)
   SVD_0E1 {PUBLIC} AT r4146_p2_OUT.DOs.DO7; (* Stropná rampa;001 *)
   SVD_2I4 {PUBLIC} AT r4146_p2_OUT.DOs.DO6; (* Štvorec.2;204 *)
   SVD_2H4 {PUBLIC} AT r4146_p2_OUT.DOs.DO5; (* Štvorec.1;204 *)
   SVD_2C7 {PUBLIC} AT r4146_p2_OUT.DOs.DO4; (* Zrkadlo;207 *)
   SVD_2B7 {PUBLIC} AT r4146_p2_OUT.DOs.DO3; (* Strop kúp_2P;207 *)
   SVD_2B6 {PUBLIC} AT r4146_p2_OUT.DOs.DO2; (* Strop 2.06;206 *)
   SVD_X01 {PUBLIC} AT r4146_p2_OUT.DOs.DO1; (* Stena-parkovisko;X01 *)
(* C-OR-0008M *)
   r4146_p3_OUT : TCIB_C_OR_0008M_OUT;
   (* Aliases *)
   IO_03_OUT AT r4146_p3_OUT;
   SVD_2C4 {PUBLIC} AT r4146_p3_OUT.DOs.DO8; (* Luster;204 *)
   SVD_2B4 {PUBLIC} AT r4146_p3_OUT.DOs.DO7; (* Bodovky-stred;204 *)
   SVD_2A4 {PUBLIC} AT r4146_p3_OUT.DOs.DO6; (* Bodovky-Terasa;204 *)
   SVD_207 {PUBLIC} AT r4146_p3_OUT.DOs.DO5; (* Sprcha;207 *)
   SVD_206 {PUBLIC} AT r4146_p3_OUT.DOs.DO4; (* Podhlad 2.06;206 *)
   SVD_204 {PUBLIC} AT r4146_p3_OUT.DOs.DO3; (* Podhlad;204 *)
   SVD_1G4 {PUBLIC} AT r4146_p3_OUT.DOs.DO2; (* Podhlad/terasa;104 *)
   SVD_Y02 {PUBLIC} AT r4146_p3_OUT.DOs.DO1; (* SP.32 ? *)
(* C-OR-0008M *)
   r4146_p4_OUT : TCIB_C_OR_0008M_OUT;
   (* Aliases *)
   IO_06_OUT AT r4146_p4_OUT;
   GAT_X01_1 {PUBLIC} AT r4146_p4_OUT.DOs.DO8; (* Brána-hlavná;X01 *)
   SVD_1M6 {PUBLIC} AT r4146_p4_OUT.DOs.DO7; (* Chodbicka;106 *)
   SVD_201 {PUBLIC} AT r4146_p4_OUT.DOs.DO6; (* Schodisko_2P;201 *)
   SVD_2R4 {PUBLIC} AT r4146_p4_OUT.DOs.DO5; (* Kuch.Linka;204 *)
   ROL_207_D {PUBLIC} AT r4146_p4_OUT.DOs.DO4;
   ROL_207_U {PUBLIC} AT r4146_p4_OUT.DOs.DO3; (* Kúpelna_2P;207 *)
   ROL_206_D {PUBLIC} AT r4146_p4_OUT.DOs.DO2;
   ROL_206_U {PUBLIC} AT r4146_p4_OUT.DOs.DO1; (* Izba 2.06;206 *)
(* C-OR-0011M-800 *)
   r4146_p5_OUT : TCIB_C_OR_0011M_800_OUT;
   (* Aliases *)
   IO_05_OUT AT r4146_p5_OUT;
   SVD_XX1 {PUBLIC} AT r4146_p5_OUT.DOs.DO11; (* Bodovky-parkovisko;X01 *)
   SVD_XG1 {PUBLIC} AT r4146_p5_OUT.DOs.DO10; (* Gabion;X11 *)
   SVD_XE1 {PUBLIC} AT r4146_p5_OUT.DOs.DO9; (* Kvetinác;X11 *)
   SVD_1L4 {PUBLIC} AT r4146_p5_OUT.DOs.DO8; (* Chodba;104 *)
   SVD_2E6 {PUBLIC} AT r4146_p5_OUT.DOs.DO7; (* Podhlad 2.06;206 *)
   SVD_1K6 {PUBLIC} AT r4146_p5_OUT.DOs.DO6; (* Podhlad-WC.1;106 *)
   SVD_1J6 {PUBLIC} AT r4146_p5_OUT.DOs.DO5; (* Strop-Vana;106 *)
   SVD_1I6 {PUBLIC} AT r4146_p5_OUT.DOs.DO4; (* Strop-WC.2;106 *)
   SVD_1H6 {PUBLIC} AT r4146_p5_OUT.DOs.DO3; (* Strop-Sprcha;106 *)
   SVD_1G6 {PUBLIC} AT r4146_p5_OUT.DOs.DO2; (* Vana-Zrkadlo;106 *)
   SVD_X21 {PUBLIC} AT r4146_p5_OUT.DOs.DO1; (* Balkon-Vyhadzuje istic;X21 *)
(* C-OR-0011M-800 *)
   r4146_p6_OUT : TCIB_C_OR_0011M_800_OUT;
   (* Aliases *)
   IO_01_OUT AT r4146_p6_OUT;
   SVD_1M4 {PUBLIC} AT r4146_p6_OUT.DOs.DO11; (* Strop.1-obýv.;104 *)
   SVD_104 {PUBLIC} AT r4146_p6_OUT.DOs.DO10; (* Luster-obýv.;104 *)
   SVD_0A1 {PUBLIC} AT r4146_p6_OUT.DOs.DO9; (* Podhlad-vst.h.;001 *)
   SVD_006 {PUBLIC} AT r4146_p6_OUT.DOs.DO8; (* Sklad;006 *)
   SVD_005 {PUBLIC} AT r4146_p6_OUT.DOs.DO7; (* Garáž;005 *)
   SVD_020 {PUBLIC} AT r4146_p6_OUT.DOs.DO6; (* Show Room;020 *)
   SVD_021 {PUBLIC} AT r4146_p6_OUT.DOs.DO5; (* Kotolna;021 *)
   SVD_0A9 {PUBLIC} AT r4146_p6_OUT.DOs.DO4; (* LP-WC_PP;009 *)
   SVD_010 {PUBLIC} AT r4146_p6_OUT.DOs.DO3; (* LP-Sprcha_PP;010 *)
   SVD_008 {PUBLIC} AT r4146_p6_OUT.DOs.DO2; (* Strop-Fitko;008 *)
   SVD_001 {PUBLIC} AT r4146_p6_OUT.DOs.DO1; (* Luster-vst.h.;001 *)
(* C-JC-0006M *)
   r4146_p7_OUT : TCIB_C_JC_0006M_OUT;
   (* Aliases *)
   IO_07_OUT AT r4146_p7_OUT;
   ROL_020_D {PUBLIC} AT r4146_p7_OUT.DOs.DO6d;
   ROL_020_U {PUBLIC} AT r4146_p7_OUT.DOs.DO6u; (* Show Room;020 *)
   ROL_108_D {PUBLIC} AT r4146_p7_OUT.DOs.DO5d;
   ROL_108_U {PUBLIC} AT r4146_p7_OUT.DOs.DO5u; (* Izba 1.08;108 *)
   ROL_107_D {PUBLIC} AT r4146_p7_OUT.DOs.DO4d;
   ROL_107_U {PUBLIC} AT r4146_p7_OUT.DOs.DO4u; (* Izba 1.07;107 *)
   ROL_1E4_D {PUBLIC} AT r4146_p7_OUT.DOs.DO3d;
   ROL_1E4_U {PUBLIC} AT r4146_p7_OUT.DOs.DO3u; (* Obýv-3;104 *)
   ROL_2D4_D {PUBLIC} AT r4146_p7_OUT.DOs.DO2d;
   ROL_2D4_U {PUBLIC} AT r4146_p7_OUT.DOs.DO2u; (* Kuch-D;204 *)
   ROL_1D4_D {PUBLIC} AT r4146_p7_OUT.DOs.DO1d;
   ROL_1D4_U {PUBLIC} AT r4146_p7_OUT.DOs.DO1u; (* Obýv-4;104 *)
(* C-JC-0006M *)
   r4146_p8_OUT : TCIB_C_JC_0006M_OUT;
   (* Aliases *)
   IO_08_OUT AT r4146_p8_OUT;
   ROL_2B4_D {PUBLIC} AT r4146_p8_OUT.DOs.DO6d;
   ROL_2B4_U {PUBLIC} AT r4146_p8_OUT.DOs.DO6u; (* Kuchyna-3;204 *)
   ROL_2A4_D {PUBLIC} AT r4146_p8_OUT.DOs.DO5d;
   ROL_2A4_U {PUBLIC} AT r4146_p8_OUT.DOs.DO5u; (* Kuchyna-2;204 *)
   ROL_204_D {PUBLIC} AT r4146_p8_OUT.DOs.DO4d;
   ROL_204_U {PUBLIC} AT r4146_p8_OUT.DOs.DO4u; (* Kuchyna-1;204 *)
   ROL_1B4_D {PUBLIC} AT r4146_p8_OUT.DOs.DO3d;
   ROL_1B4_U {PUBLIC} AT r4146_p8_OUT.DOs.DO3u; (* Obýv-2;104 *)
   ROL_1A4_D {PUBLIC} AT r4146_p8_OUT.DOs.DO2d;
   ROL_1A4_U {PUBLIC} AT r4146_p8_OUT.DOs.DO2u; (* Obýv-1;104 *)
   ROL_104_D {PUBLIC} AT r4146_p8_OUT.DOs.DO1d;
   ROL_104_U {PUBLIC} AT r4146_p8_OUT.DOs.DO1u; (* Obýv-5;104 *)
(* C-OR-0011M-800 *)
   r4146_p9_OUT : TCIB_C_OR_0011M_800_OUT;
   (* Aliases *)
   NH_11_OUT AT r4146_p9_OUT;
   TVE_207_0 {PUBLIC} AT r4146_p9_OUT.DOs.DO11; (* Kúpelna 2P;207 *)
   TVE_2R7_0 {PUBLIC} AT r4146_p9_OUT.DOs.DO10; (* Rebrík-Kúp.2P;207 *)
   TVE_206_0 {PUBLIC} AT r4146_p9_OUT.DOs.DO9; (* Izba 2.06;206 *)
   TVE_101_0 {PUBLIC} AT r4146_p9_OUT.DOs.DO8; (* Schody 1P;101 *)
   TVE_1K4_0 {PUBLIC} AT r4146_p9_OUT.DOs.DO7; (* Obývacka-L;104 *)
   TVE_104_0 {PUBLIC} AT r4146_p9_OUT.DOs.DO6; (* Obývacka-S;104 *)
   TVE_1O4_0 {PUBLIC} AT r4146_p9_OUT.DOs.DO5; (* Obývacka-P;104 *)
   TVE_108_0 {PUBLIC} AT r4146_p9_OUT.DOs.DO4; (* Izba 1.08;108 *)
   TVE_X12_0 {PUBLIC} AT r4146_p9_OUT.DOs.DO3; (* Terasa-malá;X12 *)
   TVE_106_0 {PUBLIC} AT r4146_p9_OUT.DOs.DO2; (* Kúpelna 1P;106 *)
   TVE_1R6_0 {PUBLIC} AT r4146_p9_OUT.DOs.DO1; (* Rebrík-Vana 1P;106 *)
(* C-IT-0504S *)
   r4146_p11_OUT : TCIB_C_IT_0504S_OUT;
   (* Aliases *)
   NH_021_OUT AT r4146_p11_OUT;
   KOT_021_1 {PUBLIC} AT r4146_p11_OUT.AO.AO2; (* Kotol;021 *)
   VEN_021_2 {PUBLIC} AT r4146_p11_OUT.AO.AO1; (* Rekuperácia;021 *)
(* C-RI-0401S *)
   r4146_p12_OUT : TCIB_C_RI_0401S_OUT;
   (* Aliases *)
   NH_X22_OUT AT r4146_p12_OUT;
END_VAR

VAR_GLOBAL
END_VAR

VAR_EXTERNAL
END_VAR



(* ******************************************************************************* *)
(* Generováno programem Mosaic *)
(* © 2001-2025 Teco a.s. *)
