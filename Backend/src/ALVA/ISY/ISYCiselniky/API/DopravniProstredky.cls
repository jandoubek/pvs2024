Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYCiselniky.API.DopravniProstredky Extends %RegisteredObject
{

ClassMethod popis()
{
	// 1 nazev / název / T
}

ClassMethod nacti(ByRef sys As %String, polozkaId As %String, ByRef arr As %String)
{
	//vrati data jedne polozky ciselniku
	//IN
	//polozkaId
	//OUT
	//arr("DTA")=$lb(dta,dta,...) / popis v dsc
	$$$FillParams
	s polozkaId=$g(polozkaId)
	i $g(polozkaId)'="" {
		i polozkaId="A" s arr("DTA")=$lb("autobus")
		i polozkaId="E" s arr("DTA")=$lb("elektrobus")
		i polozkaId="T" s arr("DTA")=$lb("trolejbus")
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
	s polozkaId=$g(polozkaId) k arr("STT")
	i polozkaId'="" {
		i polozkaId="A" s arr("STT")=1
		i polozkaId="E" s arr("STT")=1
		i polozkaId="T" s arr("STT")=1
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
	
	$$$FillParams
	s glb=$g(arr("GLB"))
	i glb="" {
		s arr("DTA","A")=$lb("autobus")
		s arr("DTA","E")=$lb("elektrobus")
		s arr("DTA","T")=$lb("trolejbus")
		//
		s arr("IDX","A")="A"
		s arr("IDX","E")="E"
		s arr("IDX","T")="T"
	}
	else {
		s @glb@("DTA","A")=$lb("autobus")
		s @glb@("DTA","E")=$lb("elektrobus")
		s @glb@("DTA","T")=$lb("trolejbus")
		//
		s @glb@("IDX","A")="A"
		s @glb@("IDX","E")="E"
		s @glb@("IDX","T")="T"
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
