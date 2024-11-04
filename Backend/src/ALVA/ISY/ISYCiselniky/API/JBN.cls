Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYCiselniky.API.JBN Extends %RegisteredObject
{

ClassMethod popis()
{
	//popis vety ciselniku
	//1 polozkaId               /id/N
	//2 kilometry				/pocet km/N
	//3 odmena					/ulice,číslo /T
}

ClassMethod nacti(ByRef sys As %String, polozkaId As %String, ByRef arr As %String)
{
	//vrati data polozky z ciselniku
	//IN
	//polozkaId = id
	//OUT
	//arr("DTA")=$lb(dta,dta,...) / popis v popis
	$$$FillParams
	s polozkaId=$g(polozkaId) k arr("DTA") s val=""
	i polozkaId'="" {
		s valDB=$g(^[dataDB]JBN("DTA","Polozky",polozkaId))
		s arr("DTA")=valDB
	}
}

ClassMethod uloz(ByRef sys As %String, ByRef polozkaId As %String, ByRef arr As %String)
{
	//zapise data polozky ciselniku do databaze
	//IN
	//polozkaId = firmaId
	//arr("DTA")=$lb(dta,dta,...) 				/ data, popis v popis
	//OUT
	//polozkaId
	//arr("DTA")=$lb(dta,dta,...)
	//
	
	$$$FillParams
	s polozkaId=$g(polozkaId)
	i polozkaId="" {
		i '$g(^[dataDB]JBN("DTA","Polozky")) {
				s ^[dataDB]JBN("DTA","Polozky")=0
			}
		s polozkaId= $i(^[dataDB]JBN("DTA","Polozky"))
		s $list(arr("DTA"),1) = polozkaId
	} 
	s ^[dataDB]JBN("DTA","Polozky",polozkaId)= arr("DTA")
}

ClassMethod vymaz(ByRef sys As %String, polozkaId As %String, ByRef arr As %String)
{
	//vymaze polozku z ciselniku
	//IN
	//polozkaId = id
	//OUT
	//-
	//
	$$$FillParams
	s polozkaId=$g(polozkaId)
	i polozkaId'="" {
		k ^[dataDB]JBN("DTA","Polozky",polozkaId)
	}
}

ClassMethod existuje(ByRef sys As %String, polozkaId As %String, ByRef arr As %String)
{
	//zjisti, zda polozkaId v ciselniku existuje v databazi
	//IN
	//polozkaId
	//OUT
	//arr("STT")=0 neexistuje / >0 existuje
	$$$FillParams
	s polozkaId=$g(polozkaId) k arr("STT")
	i polozkaId'="" {
		s arr("STT")=($d(^[dataDB]JBN("DTA","Polozky",polozkaId))>0)
	}
}

ClassMethod seznam(ByRef sys As %String, ByRef arr As %String)
{
	//vrati cely obsah ciselniku, mozno i podle vstupniho parametru
	//IN
	//arr("GLB")=pro navrat dat
	//OUT
	//arr("DTA",polozkaId)=$lb(dta,dta,...) nebo @arr("GLB")@("DTA",polozkaId)=$lb(dta,dta,...)
	//arr("IDX",abcidx)=polozkaId nebo @arr("GLB")@("IDX",abcidx)=polozkaId	
	$$$FillParams
	s glb=$g(arr("GLB"))
	s polozkaId="" f {
		s polozkaId=$o(^[dataDB]JBN("DTA","Polozky",polozkaId)) i polozkaId="" q
		k arrDTA d ..nacti(.sys,polozkaId,.arrDTA) s arrDTA("DTA")=$g(arrDTA("DTA"))
		s kilometry=$lg(arrDTA("DTA"),1)
		s abcidx=##class(ALVA.GENERALAPI.String).gSortTxt(kilometry_"|"_polozkaId)
		i glb="" {
			s arr("DTA",polozkaId)=$g(arrDTA("DTA"))
			s arr("IDX",abcidx)=polozkaId
		}
		else {
			s @glb@("DTA",polozkaId)=$g(arrDTA("DTA"))
			s @glb@("IDX",abcidx)=polozkaId
		}
	}
}

/// 
/// Init gridu
/// 
ClassMethod InitFg(ByRef sys As %String, ByRef out As %String) As %String
{
	$$$FillParams   
	s out($i(i))=$lts($lb("ITEM","id","Id","T"),del)
	s out($i(i))=$lts($lb("ITEM","kilometry","Kilometry","T"),del)
	s out($i(i))=$lts($lb("ITEM","odmena","Odměna","T"),del)	
	q 0
}

/// 
/// Nacteni gridu
/// 
ClassMethod LoadFg(ByRef sys As %String, ByRef out As %String) As %String
{
	$$$FillParams   
	k arrDta d ..seznam(.sys,.arrDta)
	//arr("GLB")=pro navrat dat
	//OUT
	//arr("DTA",polozkaId)=$lb(dta,dta,...) nebo @arr("GLB")@("DTA",polozkaId)=$lb(dta,dta,...)
	//arr("IDX",abcidx)=polozkaId nebo @arr("GLB")@("IDX",abcidx)=polozkaId
	s abcidx=""
	f {
		s polozkaId="" s abcidx=$o(arrDta("IDX",abcidx),1,polozkaId) i abcidx="" q
		s valDta=$g(arrDta("DTA",polozkaId))
		s idRadku=polozkaId
		s out($i(i))=$lts($lb("ITEM",polozkaId,"id",polozkaId,"",$lg(valDta,1)),del)
		s out($i(i))=$lts($lb("ITEM",polozkaId,"kilometry",$lg(valDta,1),"",$lg(valDta,1)),del)
		s out($i(i))=$lts($lb("ITEM",polozkaId,"odmena",$lg(valDta,2),"",$lg(valDta,1)),del)
	}
	q 0
}

}
