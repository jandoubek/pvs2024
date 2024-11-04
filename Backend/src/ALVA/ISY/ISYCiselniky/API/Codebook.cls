Include (ALVAEDREPORTS, ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYCiselniky.API.Codebook Extends %RegisteredObject
{

/// ================================================================
/// odtud se nacitaji data pro kontrolu zadavani polozek do BIGu !!!
/// ================================================================
ClassMethod ItemExists(ByRef in As %String, ByRef out As %String) As %String
{
	s sc=$$$OK
	try
	{
		$$$FillSysParamsBig(in)
		//k ^["mline"]wwwj m ^["mline"]wwwj("ItemExists")=in
		s polozkaId=$g(in("id")) s cisId=$lg($g(in("Codebook")),1) k out	 
		if (cisId=$$$CodebookTypeISYBlizkeObce){k arrDta d ##class(ALVA.ISY.ISYCiselniky.API.BlizkeObce).existuje(.sys,polozkaId,.arrDta) s out("exists")=+$g(arrDta("STT")) s out("id")=polozkaId} 
				elseif (cisId=$$$CodebookTypeISYSkupinyZastavekProSlevu){k arrDta d ##class(ALVA.ISY.ISYCiselniky.API.SkupinyZastavekProSlevu).existuje(.sys,polozkaId,.arrDta) s out("exists")=+$g(arrDta("STT")) s out("id")=polozkaId} 
				elseif (cisId=$$$CodebookTypeISYTarifniZony){k arrDta d ##class(ALVA.ISY.ISYCiselniky.API.TarifniZony).existuje(.sys,polozkaId,.arrDta) s out("exists")=+$g(arrDta("STT")) s out("id")=polozkaId} 
				elseif (cisId=$$$CodebookTypeZastavky){k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).existuje(.sys,polozkaId,.arrDta) s out("exists")=+$g(arrDta("STT")) s out("id")=polozkaId}
				elseif (cisId=$$$CodebookTypeSkupinyLinek){k arrDta d ##class(ALVA.ISY.ISYCiselniky.API.SkupinyLinek).existuje(.sys,polozkaId,.arrDta) s out("exists")=+$g(arrDta("STT")) s out("id")=polozkaId}
				elseif (cisId=$$$CodebookTypeCelostatRegistrZastavek){k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyCRZ).existuje(.sys,polozkaId,.arrDta) s out("exists")=+$g(arrDta("STT")) s out("id")=polozkaId}
	} 
	catch ex { s sc=ex.AsStatus() }
	q sc
}

ClassMethod LoadItem(ByRef in As %String, ByRef out As %String) As %String
{
	s sc=$$$OK
	try
	{
		$$$FillSysParamsBig(in)
		//k ^["mline"]wwwj m ^["mline"]wwwj("LoadItem")=in
		s polozkaId=$g(in("id")) s cisId=$lg($g(in("Codebook")),1) k out	 
		if (cisId=$$$CodebookTypeISYBlizkeObce){k arrDta d ##class(ALVA.ISY.ISYCiselniky.API.BlizkeObce).nacti(.sys,polozkaId,.arrDta) s out("data","item")=$lb(polozkaId,$lg($g(arrDta),1))} 
				elseif (cisId=$$$CodebookTypeISYSkupinyZastavekProSlevu){k arrDta d ##class(ALVA.ISY.ISYCiselniky.API.SkupinyZastavekProSlevu).nacti(.sys,polozkaId,.arrDta) s out("data","item")=$lb(polozkaId,$lg($g(arrDta),1))} 
				elseif (cisId=$$$CodebookTypeISYTarifniZony){k arrDta d ##class(ALVA.ISY.ISYCiselniky.API.TarifniZony).nacti(.sys,polozkaId,.arrDta) s out("data","item")=$lb(polozkaId,$lg($g(arrDta),1))} 	
				elseif (cisId=$$$CodebookTypeZastavky){
					k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,polozkaId,,.arrDta)
					s out("data","item")=$lb(polozkaId,$lg($g(arrDta("DTA")),1)_","_$lg($g(arrDta("DTA")),2)_","_$lg($g(arrDta("DTA")),3)_"/"_$lg($g(arrDta("DTA")),4))
			}
				elseif (cisId=$$$CodebookTypeSkupinyLinek) {k arrDta d ##class(ALVA.ISY.ISYCiselniky.API.SkupinyLinek).nacti(.sys,polozkaId,.arrDta) s out("data","item")=$lb(polozkaId,$lg($g(arrDta("DTA")),1))}
				elseif (cisId=$$$CodebookTypeCelostatRegistrZastavek){
					k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyCRZ).nacti(.sys,polozkaId,,.arrDta)
					s out("data","item")=$lb(polozkaId,$lg($g(arrDta("DTA")),1)_","_$lg($g(arrDta("DTA")),2)_","_$lg($g(arrDta("DTA")),3)_"/"_$lg($g(arrDta("DTA")),4))
			}
	} 
	catch ex { s sc=ex.AsStatus() }
	q sc
}

}
