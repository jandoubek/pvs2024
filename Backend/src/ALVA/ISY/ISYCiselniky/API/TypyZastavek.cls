Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYCiselniky.API.TypyZastavek Extends %RegisteredObject
{

ClassMethod popis()
{
	//datovy popis vety ciselniku
	// 1 nazev / název/ T
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
		i polozkaId="O" s arr("DTA")=$lb("oficiální")
		i polozkaId="L" s arr("DTA")=$lb("lokalní")
	}
}

ClassMethod uloz(ByRef sys As %String, ByRef polozkaId As %String, ByRef arr As %String)
{
	//zapise data polozky ciselniku do databaze
	//IN
	//polozkaId 							/ pokud neni, automaticky se prideli
	//arr("DTA")=$lb(dta,dta,...) 			/ data zastavky, popis v dsc
	//OUT
	//polozkaId (cislo zastavky)
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
	//polozkaId (cislo zastavky)
	//OUT
	//arr("STT")=0 neexistuje / >0 existuje
	$$$FillParams
	s polozkaId=$g(polozkaId) k arr("STT")
	i polozkaId'="" {
		i polozkaId="O" s arr("STT")=1
		i polozkaId="L" s arr("STT")=1
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
		s arr("DTA","O")=$lb("oficiální")
		s arr("DTA","L")=$lb("lokální")
		s arr("IDX",1)="O"
		s arr("IDX",2)="L"
	}
	else {
		s @glb@("DTA","O")=$lb("oficiální")
		s @glb@("DTA","L")=$lb("lokální")
		s @glb@("IDX",1)="O"
		s @glb@("IDX",2)="L"
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
