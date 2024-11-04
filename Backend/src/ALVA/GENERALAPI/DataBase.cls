Include GENERAL

Class ALVA.GENERALAPI.DataBase Extends %RegisteredObject
{

ClassMethod getSys(idFa, ByRef sys)
{
	s sys("U","IdFa")=idFa
	d ##class(ALVA.EDISON.Main).GetApplicationInfo(-1,.loadedInfo,idFa)
	s sys("U","DATA")=loadedInfo(0)
	s sys("U","SystemDB")=..sysDB()
	s sys("U","delimiter")=$c(0)
	s sys("C","GUID")=$system.Util.CreateGUID()
	s sys("U","MLP")=-1
	s sys("U","fullName")="<neznámý>"
	s sys("U","loginName")="<neznámý>"
}

/// 
/// Vrátí systémovou databázi
/// 
ClassMethod sysDB() As %String
{

 s sysDB=##class(ALVA.EDISON.Main).GetSystemDB()
 i sysDB= "" s sysDB ="MLINE"
 q sysDB
}

/// 
/// podle idfa vrátí datvou db
/// 
ClassMethod dataDB(ByRef idfa As %String) As %String
{

 i idfa="" q ""
 d ##class(ALVA.EDISON.Main).GetApplicationInfo(-1,.out,idfa)
 s dataDB=$g(out(0))
 q dataDB
}

/// 
/// podle dataDB vrátí IdFa
/// 
ClassMethod getIdFaForDataDB(ByRef dataDB As %String) As %String
{
	// w ##class(ALVA.GENERALAPI.DataBase).getIdFaForDataDB("CSADCB")
	
	if $g(dataDB)="" q ""
	k err,listIdFa,firm
	d ##class(ALVA.EDISON.Main).GetDatabaseList(.err,.listIdFa)
	q $g(listIdFa($g(dataDB),1))
}

/// Nacte datum a cas serveru
ClassMethod GetDateTime(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	try{s ^||ML("OUT",$i(counter))=$tr(dateTime,"/",".")}
	catch(ex){s ^||ML("ERR")=err}
	quit 0
}

/// 
/// pro zaslané idfa vrátí dataDB
/// 
ClassMethod getDataDBForIdFa(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try
    {
	    $$$FillParams
	    s idx=""
    	for
    	{
		    s idx=$o(^||ML("IN",idx),1,param) q:idx=""
        	s radka = $listfromstring(param,del)
        	if ($lg(radka,1)="IdFa") {s IdFaO=$lg(radka,2)}
    	}
    	s dataDBO =..dataDB(IdFaO)
    	s output($i(i)) = $listtostring($lb("dataDB",dataDBO),del)
 		// Vystup
        m ^||ML("OUT")=output
    }
   	catch (ex){ $$$CatchErrRest }
    q err
}

}
