Include ALVAEDREPORTS

Class ALVA.ISY.ISYAPI.Codebook Extends %RegisteredObject
{

ClassMethod ItemExists(ByRef in As %String, ByRef out As %String) As %String
{
	
	s sc=$$$OK
	try
	{
		s Codebook=$lg($g(in("Codebook")),1)
		if Codebook=$$$CodebookTypeNegZn {
			s idfa=in("IdFa")
			s dataDB=##class(ALVA.GENERALAPI.DataBase).dataDB(idfa)		
			s id=$g(in("id"))
			s skup=$p(id,"/",1)
			s nz=$p(id,"/",2)
			if ($g(nz)'="")&&($g(skup)'="") {
				if $d(^[dataDB]JRSET("Cis","InPlatDef",skup,nz)) { 
					s out("exists")=1
					s out("id")=id
				}
			}
		}
	} 
	catch ex { s sc=ex.AsStatus() }
	q sc
}

ClassMethod LoadItem(ByRef in As %String, ByRef out As %String) As %String
{
	s sc=$$$OK
	try
	{
		s Codebook=$lg($g(in("Codebook")),1)
		if Codebook=$$$CodebookTypeNegZn {
			s idfa=in("IdFa")
			s dataDB=##class(ALVA.GENERALAPI.DataBase).dataDB(idfa)		
			s id=$g(in("id"))
			s skup=$p(id,"/",1)
			s nz=$p(id,"/",2)
			if ($g(nz)'="")&&($g(skup)'="") {
				if $d(^[dataDB]JRSET("Cis","InPlatDef",skup,nz)) {
					s pop=$g(^[dataDB]JRSET("Cis","InPlatDef",skup,nz)) 
					s out("data","item")=$lb(id,pop)
				}
			}
		}
	} 
	catch ex { s sc=ex.AsStatus() }
	q sc
}

}
