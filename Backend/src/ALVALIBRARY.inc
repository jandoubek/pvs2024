ROUTINE ALVALIBRARY [Type=INC]
#define CacheVersion $System.Version.GetMajor()
#define GetStack $g(err)_ex.DisplayString() 	
#define InitializeMethod ##continue
	s err="" ##continue
	s workID=$i(^||temp) ##continue
	k ^||temp(workID)
#define FinalizeMethod ##continue
	k ^||temp(workID) ##continue
	s ^CacheTempMLSrv($j,"OUT",0)=err ##continue
	quit 0
#define InitializeMethodEx(%package) ##continue
	s err="" ##continue
	s workID=$i(@("^||temp"_$g(%package))) ##continue
	k @("^||temp"_$g(%package)_"("""_workID_""")")
#define FinalizeMethodEx(%package) ##continue
	k @("^||temp"_$g(%package)_"("""_workID_""")") ##continue
	s ^CacheTempMLSrv($j,"OUT",0)=err ##continue
	quit 0
/// InitializeMethod - Rest
#define InitializeMethodRest(%package) ##continue
	s err="" s retValue=$$$OK ##continue
	s workID=$i(@("^||temp"_$g(%package))) ##continue
	k @("^||temp"_$g(%package)_"("""_workID_""")")
/// FinalizeMethod - Rest
#define FinalizeMethodRest(%package) ##continue
	k @("^||temp"_$g(%package)_"("""_workID_""")") ##continue
	s ^||ML("ERR")=err ##continue
	quit retValue
#define FillParams ##continue
	s IdFa=$g(sys("U","IdFa")) ##continue
	s del=$g(sys("U","delimiter")) ##continue
	s systemDB=$g(sys("U","SystemDB")) ##continue
	s systemUser=$g(sys("C","User")) ##continue
	s dataDB=$g(sys("U","DATA")) ##continue
	s userID=$g(sys("U","MLP")) ##continue
	s userName=$g(sys("U","fullName")) ##continue
	s loginName=$g(sys("U","loginName")) ##continue
	s GUID=$g(sys("C","GUID")) ##continue
	if IdFa="" s err="Chybi parametr: IdFa" ztrap ##continue
	if del="" s err="Chybi parametr: delimiter" ztrap ##continue
	if systemDB="" s err="Chybi parametr: SystemDB" ztrap
#define DisableJournal ##continue
	s journalDisabled=$$STOP^%NOJRN
#define EnableJournal ##continue
	if $g(journalDisabled) d ENABLE^%NOJRN
#define CatchErrRest ##continue
	if ($g(sys("C","App"))="ALWA.SYS.MLRest"){s ret="1~"_$g(err)_$C(13,10)_ex.DisplayString() s ^||ML("ERR")=ret	}##continue
	else{s (ret,err)="1~"_$g(err)_$C(13,10)_ex.DisplayString()  s ^CacheTempMLSrv($j,"OUT",0)=ret}
#define Init ##continue
      s ret=0 ##continue
      s err=""
#define uGo ##continue
    s app = $g(sys("C","App"))	##continue
	if (app="ALWA.SYS.MLRest"){s uGo="^||ML"}##continue
	else {s uGo="^CacheTempMLSrv($j)"}

GetStack(ex,err)
{
	/*
	s errState=ex.Location
	if ex.Name'="<ILLEGAL VALUE>" s errState=ex.Name_errState
	if err'="" s errState=$s(err["<":errState_$c(13,10)_err,1:"<"_err_">"_errState)
	quit errState	
	if ex.Name="<ZTRAP>" s errState=$g(err)_" ["_ex.Location_"]"
	if ex.Name'="<ZTRAP>" s errState=ex.Name_" ["_ex.Location_"]"
		*/	
	s errState=$g(err)_ex.DisplayString() 	
	quit errState
}