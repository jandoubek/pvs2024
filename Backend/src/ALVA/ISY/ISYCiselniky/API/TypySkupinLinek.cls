Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYCiselniky.API.TypySkupinLinek Extends %RegisteredObject
{

ClassMethod popis()
{
	//datovy popis vety ciselniku
	// 1 nazev / název / T
	// 2 poradi / pořadí / N
}

ClassMethod nacti(ByRef sys As %String, polozkaId As %String, ByRef arr As %String)
{
	//vrati data jedne polozky ciselniku
	//IN
	//polozkaId
	//OUT
	//arr("DTA")=$lb(dta,dta,...) / popis v dsc
	$$$FillParams
	s polozkaId=$g(polozkaId) k arr("DTA")
	i $g(polozkaId)'="" {
		s dbVal=$g(^[dataDB]JRSET("Definice","SKSKU",polozkaId))
		s val=$lfs(dbVal,"~")
		s arr("DTA")=val
	}
}

ClassMethod uloz(ByRef sys As %String, ByRef polozkaId As %String, ByRef arr As %String)
{
	//zapise data polozky ciselniku do databaze
	//IN
	//polozkaId 							/ musi byt zadano ve formulari
	//arr("DTA")=$lb(dta,dta,...) 			/ data polozky, popis v dsc
	//OUT
	//polozkaId
	//arr("DTA")=$lb(dta,dta,...)
	//
	$$$FillParams
	s polozkaId=$g(polozkaId)
	i polozkaId'="" {
		//odstraneni indexu
		d ..obnovIndex(.sys,polozkaId,0)
		//zapis dat do databaze
		s val=$g(arr("DTA")) s dbVal=$lts(val,"~")
		s ^[dataDB]JRSET("Definice","SKSKU",polozkaId)=dbVal
		d ..obnovIndex(.sys,polozkaId,1)
	}
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
	i polozkaId'="" {
		//vymazu ji v seznamu 
		d ..obnovIndex(.sys,polozkaId,0)
		//zajistit prevod skupin na jiny typ !!!
		//zrusim ho
		k ^[dataDB]JRSET("Definice","SKSKU",polozkaId)
		//sherlock
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
		s arr("STT")=($d(^[dataDB]JRSET("Definice","SKSKU",polozkaId))>0)
	}
}

ClassMethod seznam(ByRef sys As %String, ByRef arr As %String)
{
	//vrati cely obsah ciselniku, mozno i podle vstupniho parametru
	//IN
	//arr("GLB")=global s prenasenymi daty
	//arr("PAR","parametrKlic")=parametrData
	//OUT
	//arr("DTA",polozkaId)=$lb(dta,dta,...) nebo @arr("GLB")@("DTA",polozkaId)=$lb(dta,dta,...)
	//arr("IDX",abcidx)=polozkaId nebo @arr("GLB")@("IDX",abcidx)=polozkaId
	$$$FillParams
	s glb=$g(arr("GLB"))
	s polozkaId="" f {
		s polozkaId=$o(^[dataDB]JRSET("Definice","SKSKU",polozkaId)) i polozkaId="" q
		k arrDTA d ..nacti(.sys,polozkaId,.arrDTA)
		s nazev=$lg($g(arrDTA("DTA")),1)
		s abcidx=##class(ALVA.GENERALAPI.String).gSortTxt(nazev_polozkaId)
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
