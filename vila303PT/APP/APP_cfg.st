(* SEDLAK Pod Taborom CFG 30.3.2022 *)

VAR_GLOBAL
//   rb          : BOOL;


   ROM_104     {HIDDEN} {PUBLIC}  AT rb;  //Obývaèka;1
   ROM_105     {HIDDEN} {PUBLIC}  AT rb;  //Chodba 1P;1
   ROM_106     {HIDDEN} {PUBLIC}  AT rb;  //Kúpelòa 1P;1
   ROM_107     {HIDDEN} {PUBLIC}  AT rb;  //Izba 1.07;1
   ROM_108     {HIDDEN} {PUBLIC}  AT rb;  //Izba 1.08;1

   ROM_204     {HIDDEN} {PUBLIC}  AT rb;  //Kuchyòa;1
//   ROM_205     {HIDDEN} {PUBLIC}  AT rb;  //Chodba 2P;1
   ROM_206     {HIDDEN} {PUBLIC}  AT rb;  //Izba 2.06;1
   ROM_207     {HIDDEN} {PUBLIC}  AT rb;  //Kúpelòa 2P;1

   ROM_001     {HIDDEN} {PUBLIC}  AT rb;  //Vstup.Hala;1
   ROM_005     {HIDDEN} {PUBLIC}  AT rb;  //Garáž;1
   ROM_006     {HIDDEN} {PUBLIC}  AT rb;  //Sklad;1
   ROM_007     {HIDDEN} {PUBLIC}  AT rb;  //Chodba_PP;1
   ROM_008     {HIDDEN} {PUBLIC}  AT rb;  //Fitko;1
   ROM_009     {HIDDEN} {PUBLIC}  AT rb;  //WC-PP;1
   ROM_010     {HIDDEN} {PUBLIC}  AT rb;  //Kúpelòa PP;1
   ROM_020     {HIDDEN} {PUBLIC}  AT rb;  //Show room;1
   ROM_021     {HIDDEN} {PUBLIC}  AT rb;  //Kotolòa;1


   ROM_002     {HIDDEN} {PUBLIC}  AT rb;  //Schody PP;1
   ROM_101     {HIDDEN} {PUBLIC}  AT rb;  //Schody 1P;1
   ROM_201     {HIDDEN} {PUBLIC}  AT rb;  //Schody 2P;1

   ROM_X01     {HIDDEN} {PUBLIC}  AT rb;  //Parkovisko;2
   ROM_X11     {HIDDEN} {PUBLIC}  AT rb;  //Terasa ve¾ká;2
   ROM_X12     {HIDDEN} {PUBLIC}  AT rb;  //Terasa malá;2
   ROM_X21     {HIDDEN} {PUBLIC}  AT rb;  //Balkón_2P;2

//   ROM_102     {HIDDEN} {PUBLIC}  AT rb;  //Vytah;1
//   ROM_103     {HIDDEN} {PUBLIC}  AT rb;  //Sachta;1
//   ROM_104k     {HIDDEN} {PUBLIC}  AT rb;  //Obývaèka-vlavo (k oknu);1
//   ROM_104J     {HIDDEN} {PUBLIC}  AT rb;  //Obývaèka-stred;1
//   ROM_104o     {HIDDEN} {PUBLIC}  AT rb;  //Obývaèka-vpravo (k izbam 1.07, 1.08);1
//   ROM_106     {HIDDEN} {PUBLIC}  AT rb;  //Kúpelòa-1P;1
//   ROM_101     {HIDDEN} {PUBLIC}  AT rb;  //WC-1P;1
//   ROM_102     {HIDDEN} {PUBLIC}  AT rb;  //Vaòa-1P;1
//   ROM_120  (ROM_X12)    {HIDDEN} {PUBLIC}  AT rb;  //Terasa-mala;1

//   ROM_202     {HIDDEN} {PUBLIC}  AT rb;  //Sachta 2P;1
//   ROM_203     {HIDDEN} {PUBLIC}  AT rb;  //Vytah 2P;1
//   ROM_204k     {HIDDEN} {PUBLIC}  AT rb;  //Kuchyòa-vlavo (k oknu);1
//   ROM_204x     {HIDDEN} {PUBLIC}  AT rb;  //Kuchyòa-vpravo (k izbe);1

//   ROM_X22     {HIDDEN} {PUBLIC}  AT rb;  //Meteostanica;2





END_VAR


VAR_GLOBAL
      paradoxUnlock           : BOOL;
      paradoxLock             : BOOL;
      paradox_data            : T_PAR_DIG_EVO_SYSTEM_DATA;
      Paradox                 : fbPAR_DIG_EVOsystem;
      paradox_max_zone_count  : UINT := 28;
   //   ParadoxERR     : STRING;             // poslední chyba


   PIR_501     {HIDDEN} {PUBLIC}  AT paradox_data.zone[1].state;     //Obyv-vpravo;104
   PIR_502     {HIDDEN} {PUBLIC}  AT paradox_data.zone[2].state;     //Kuchyna;204
   PIR_503     {HIDDEN} {PUBLIC}  AT paradox_data.zone[3].state;     //Obyv-stred;104
   PIR_504     {HIDDEN} {PUBLIC}  AT paradox_data.zone[4].state;     //Izba 1.07;107
   PIR_509     {HIDDEN} {PUBLIC}  AT paradox_data.zone[9].state;     //Schody 2P;201
   PIR_510     {HIDDEN} {PUBLIC}  AT paradox_data.zone[10].state;    //Izba 2.06;206
   PIR_511     {HIDDEN} {PUBLIC}  AT paradox_data.zone[11].state;    //Obyvacka;104
   PIR_512     {HIDDEN} {PUBLIC}  AT paradox_data.zone[12].state;    //Izba 1.08;108
   PIR_517     {HIDDEN} {PUBLIC}  AT paradox_data.zone[17].state;    //Sklad;006
   PIR_518     {HIDDEN} {PUBLIC}  AT paradox_data.zone[18].state;    //Show room ?;020
   PIR_519     {HIDDEN} {PUBLIC}  AT paradox_data.zone[19].state;    //Fitko ?;008
   PIR_520     {HIDDEN} {PUBLIC}  AT paradox_data.zone[20].state;    //Schody PP;002
   PIR_525     {HIDDEN} {PUBLIC}  AT paradox_data.zone[25].state;    //Garaz;005
   PIR_526     {HIDDEN} {PUBLIC}  AT paradox_data.zone[26].state;    //Vstup.Hala;001
   PIR_527     {HIDDEN} {PUBLIC}  AT paradox_data.zone[27].state;    //Kotolna;021
   PIR_528     {HIDDEN} {PUBLIC}  AT paradox_data.zone[28].state;    //Schody 1P;101


END_VAR


