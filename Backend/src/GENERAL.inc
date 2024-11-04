ROUTINE GENERAL [Type=INC]
/// Create a success %Status code
#define Init ##continue
      s ret=0 ##continue
      s err=""
            
/// MLS - vlastnosti MLServeru
#define FillParams ##continue
    k output ##continue
    s IdFa=$g(sys("U","IdFa")) ##continue
    s del=$g(sys("U","delimiter")) ##continue
    s systemDB=$g(sys("U","SystemDB")) ##continue
    s systemUser=$g(sys("C","User")) ##continue
    s dataDB=$g(sys("U","DATA")) ##continue
    s userID=$g(sys("U","MLP")) ##continue
    s userName=$g(sys("U","fullName")) ##continue
    s loginName=$g(sys("U","loginName")) ##continue
    s GUID=$g(sys("C","GUID")) ##continue
    if userName="" s userName=loginName  ##continue
    if IdFa="" s err="Chybi parametr: IdFa" ztrap ##continue
    if del="" s err="Chybi parametr: delimiter" ztrap ##continue
    if systemDB="" s err="Chybi parametr: SystemDB" ztrap ##continue
    if userID="" s err="Chybi parametr: userID" ztrap ##continue
    if userName="" s err="Chybi parametr: userName" ztrap ##continue
    if loginName="" s err="Chybi parametr: loginName" ztrap ##continue
    if dataDB="" s err="Chybi parametr: dataDB" ztrap
 /// input macro pro rest
#define InputParams ##continue
	k input,filtr ##continue
	if ($g(sys("C","App"))="ALWA.SYS.MLRest") { ##continue
		k ^CacheTempMLSrv($j) ##continue
		m ^CacheTempMLSrv($j,"IN")=^||ML("IN") ##continue
		m ^CacheTempMLSrv($j,"SYS")=sys ##continue
	} ##continue
	s ind="" f { ##continue
		s ind=$o(^||ML("IN",ind)) q:ind="" ##continue
		s val=$g(^||ML("IN",ind)) ##continue
		if $p(val,del,1)'="" { ##continue
			if $p(val,del,1)="Filter" { s filtr($p(val,del,2))=$p(val,del,3) } ##continue
			else { if $l($p(val,del,1))<480  { s input($p(val,del,1))=$p(val,del,2) } } ##continue
 		} ##continue
 	}
#define GetFiltr ##continue	
	s ind="" ##continue
	for  ##continue
	{ ##continue
		s ind=$o(^||ML("IN",ind)) q:ind="" ##continue
		s val=$g(^||ML("IN",ind)) ##continue
		if $p(val,del,1)'=""  ##continue
		{ ##continue
			if $p(val,del,1)="Filter"{##continue			  
				s filtr($p(val,del,2))=$p(val,del,3) ##continue
				if $p(val,del,3)'="" {	s filtr($p(val,del,2),$p(val,del,3))=""} ##continue
			} ##continue			
		} ##continue
	}	##continue
/// output
#define OutputParams ##continue
	m ^||ML("OUT")=^CacheTempMLSrv($j,"OUT")
/// CatchErr - zachyceni erroru v Catch
#define CatchErr ##continue
	s ret="1~"_err_$C(13,10)_ex.DisplayString() ##continue
    s ^CacheTempMLSrv($j,"OUT",0)=ret
#define CatchErrRest ##continue
	if ($g(sys("C","App"))="ALWA.SYS.MLRest") { s ret="1~"_err_$C(13,10)_ex.DisplayString() s ^||ML("ERR")=ret } ##continue
	else { s (ret,err)="1~"_$g(err)_$C(13,10)_ex.DisplayString() s ^CacheTempMLSrv($j,"OUT",0)=ret }
#define CatchErrToInputErr ##continue
    s err=err_$C(13,10)_ex.DisplayString() ##continue
   	s ret="1~"_ex.DisplayString()
   	
#define ThrowErr(%sc,%err) if $case($g(%sc),"":0,"0":0,"1":0,:1) s %err=$case($e(%sc),0:$SYSTEM.Status.GetErrorText(%sc),1:%sc,:%sc) ztrap
   	
   	/// hrl -> index
#define HorToId(%H) (%H*100000+$p(%H,",",2))
   	
#define uGo ##continue
    s app = $g(sys("C","App"))	##continue
	if (app="ALWA.SYS.MLRest"){s uGo="^||ML"}##continue
	else {s uGo="^CacheTempMLSrv($j)"}
	
	
	#define TiskTypeBtnPrint 1
	#define TiskTypeBtnPrintList 2
	
	#define TiskIkonaWindow 0
	#define TiskIkonaWindowTable 1