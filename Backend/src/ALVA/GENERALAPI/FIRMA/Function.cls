Class ALVA.GENERALAPI.FIRMA.Function Extends %RegisteredObject
{

/// 
/// podle idfa vrátí datovou db
/// 
ClassMethod dataDB(ByRef idfa As %String) As %String
{

	i idfa="" q ""
 	d ##class(ALVA.EDISON.Main).GetApplicationInfo(-1,.out,idfa)
	s dataDB=$g(out(0))
 	q dataDB
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

}
