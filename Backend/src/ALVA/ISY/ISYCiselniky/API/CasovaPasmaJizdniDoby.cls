Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYCiselniky.API.CasovaPasmaJizdniDoby Extends %RegisteredObject
{

ClassMethod popis()
{
	//datovy popis vety ciselniku
	// 1 nazev / název / T
}

ClassMethod nacti(ByRef sys As %String, polozkaId As %String, ByRef arr As %String)
{
	//vrati data jedne polozky ciselniku
	//IN
	//polozkaId = id polozky
	//OUT
	//arr("DTA")=$lb(dta,dta,...) / popis v dsc
	$$$FillParams
	s polozkaId=$g(polozkaId)
	i $g(polozkaId)'="" {
		i polozkaId="Z" s arr("DTA")=$lb("základní")
		i polozkaId="P" s arr("DTA")=$lb("pomalé")
		i polozkaId="R" s arr("DTA")=$lb("rychlé")
	}
}

ClassMethod uloz(ByRef sys As %String, ByRef polozkaId As %String, ByRef arr As %String)
{
	//zapise data polozky ciselniku do databaze
	//IN
	//polozkaId 							/ pokud neni, automaticky se prideli
	//arr("DTA")=$lb(dta,dta,...) 			/ data zastavky, popis v dsc
	//OUT
	//polozkaId
	//arr("DTA")=$lb(dta,dta,...)
	//
	$$$FillParams
	s polozkaId=$g(polozkaId)
	k arr("ERR") s arr("ERR",$i(arr("ERR")))="do číselníku nelze vkládat položky, je pevně definovaný"
}

ClassMethod vymaz(ByRef sys As %String, polozkaId As %String, ByRef arr As %String)
{
	//vymaze polozku z ciselniku
	//IN
	//polozkaId
	//OUT
	//-
	//
	$$$FillParams
	s polozkaId=$g(polozkaId)
	k arr("ERR") s arr("ERR",$i(arr("ERR")))="do číselníku nelze vkládat položky, je pevně definovaný"
}

ClassMethod existuje(ByRef sys As %String, polozkaId As %String, ByRef arr As %String)
{
	//zjisti, zda polozkaId v ciselniku existuje v databazi
	//IN
	//polozkaId
	//OUT
	//arr("STT")=0 neexistuje / >0 existuje
	$$$FillParams
	k arr("STT")
	s polozkaId=$g(polozkaId)
	i polozkaId'="" {
		i polozkaId="Z" s arr("STT")=1
		i polozkaId="P" s arr("STT")=1
		i polozkaId="R" s arr("STT")=1
	}
}

ClassMethod seznam(ByRef sys As %String, ByRef arr As %String)
{
	//vrati cely obsah ciselniku, mozno i podle vstupniho parametru
	//IN
	//arr("GLB")=global s prenasenymi daty
	//arr("PAR","parametrKlic")=parametrData
	//OUT
	//arr("DTA",polozkaId)=$lb(polozkaData,polozkaData,...) nebo @arr("GLB")@("DTA",polozkaId)=$lb(polozkaData,polozkaData)
	//abcIndex pro razeni podle poradi, !!! jeste vymyslet, jak to udelat pro id
	//arr("IDX",abcIndex)=polozkaId nebo @arr("GLB")@("IDX",abcIndex)=polozkaId
	//kde abcIndex je index pro razeni podle poradi
	s glb=$g(arr("GLB"))
	i glb="" {
		s arr("DTA","Z")=$lb("základní")
		s arr("DTA","P")=$lb("pomalé")
		s arr("DTA","R")=$lb("rychlé")
		//
		s arr("IDX","Z")="Z"
		s arr("IDX","P")="P"
		s arr("IDX","R")="R"
	}
	else {
		s @glb@("DTA","Z")=$lb("základní")
		s @glb@("DTA","P")=$lb("pomalé")
		s @glb@("DTA","R")=$lb("rychlé")
		//
		s @glb@("IDX","Z")="Z"
		s @glb@("IDX","P")="P"
		s @glb@("IDX","R")="R"
	}
}

ClassMethod noveID(ByRef sys As %String, ByRef polozkaId As %String, ByRef arr As %String)
{
	//vrati volne ID pro ciselnikovou polozku
	//IN
	//OUT
	//polozkaId
	$$$FillParams
}

ClassMethod obnovIndex(ByRef sys As %String, polozkaId As %String, par As %String)
{
	//obsluha indexoveho globalu
	//
	$$$FillParams
	i polozkaId {
		s val=""
		//zapis indexu
		i +par {
		}
		//vymazani indexu
		i 'par {
		}
	}
}

}
