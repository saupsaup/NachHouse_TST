// CFG ROSOCHA LRKE

{ $DEFINE __NH_DALI }
{ $DEFINE __NH_FRM }
{ $DEFINE __NH_PSN }
{ $DEFINE __NH_EXP }
{ $DEFINE __NH_WEB }
{ $DEFINE __NH_METEO_IQWS_4000 }
//{ $DEFINE __NH_WRK }
VAR_GLOBAL CONSTANT
	{$IFDEF __NH_DALI}
		_Nh_DALI_MA	{HIDDEN} : USINT	:=  2;			 	
   {$END_IF}
	{ $IFDEF __NH_METEO_IQWS_4000 }
	    _NhipIQWS           : string [16]		:='192.168.0.99'; 	(*IP adresa anemometru IQWS 4000*)
	{ $END_IF}
	_NhIpWebPush:  string [16]		:='192.168.0.175';
	_Nh_MSG	{HIDDEN} : USINT			:= 2;				
	_Nh_MSG_RCV	: ARRAY[1..3] OF STRING[80] := [
   'x3d1581ecefac0219c69184abf3b233c231b84ee3000415a5736b86ed5d9ad677',     // Laco R.
   'x86d1b96a45a5856249e62a1f587cdc50a477b849750341da5e4132f7d3d752d0'   	// Zuzka M
	];
	// Kosice-Peres
	latitude 	: LREAL := 48.6887920228211;
	longitude   : LREAL := 21.211946313124333;		
END_VAR



