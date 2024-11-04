Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYCiselniky.API.TypyUzluNavaznosti Extends %RegisteredObject
{

ClassMethod popis()
{
	// 1 zkratka / zkratka / T
	// 2 nazev / název / T
}

ClassMethod data(ByRef arr As %String)
{
	k arr
	s arr(1)=$lb("V","významný")
	s arr(2)=$lb("N","nevýznamný")
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
	k arrDta d ..data(.arrDta)
	i $g(polozkaId)'="" { s arr("DTA")=$g(arrDta(polozkaId))}
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
	k arrDta d ..data(.arrDta)
	i polozkaId'="" { s arr("STT")=$d(arrDta(polozkaId))}
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
	k arrDta d ..data(.arrDta)
	s polozkaId="" f {
		s valDta="" s polozkaId=$o(arrDta(polozkaId),1,valDta) i polozkaId="" q
		s zkratka=$lg(valDta,2)
		i glb="" {
			s arr("DTA",polozkaId)=valDta
			s arr("IDX",zkratka)=polozkaId
		}
		else {
			s @glb@("DTA",polozkaId)=valDta
			s @glb@("IDX",zkratka)=polozkaId
		}
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
