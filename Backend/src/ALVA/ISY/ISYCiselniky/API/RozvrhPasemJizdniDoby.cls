Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYCiselniky.API.RozvrhPasemJizdniDoby Extends %RegisteredObject
{

ClassMethod popis()
{
	//datovy popis vety ciselniku
	// ^[dataDB]ALVA.ISY.CIS("RozvrhPasemJizdniDoby","DTA",polozkaId)=$lb(dta,dta,...)
	// 1 zkratka / zkratka / T
	// 2 nazev / název / T
	//
	// ^[dataDB]ALVA.ISY.CIS("RozvrhPasemJizdniDoby","DTA",polozkaId,"rozvrh",minOd)=$lb(casovePasmoJizdniDobyId)
	// ^[dataDB]ALVA.ISY.CIS("RozvrhPasemJizdniDoby","DTA",polozkaId,"obvyklaRychlost",casovePasmoJizdniDobyId)=$lb(rychlost)
	//
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
		m arr("DTA")=^[dataDB]ALVA.ISY.CIS("RozvrhPasemJizdniDoby","DTA",polozkaId)
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
	i polozkaId="" { s polozkaId=$i(^[dataDB]ALVA.ISY.CIS("RozvrhPasemJizdniDoby","DTA")) }
	//odstraneni indexu
	d ..obnovIndex(.sys,polozkaId,0)
	//zapis dat do databaze
	k ^[dataDB]ALVA.ISY.CIS("RozvrhPasemJizdniDoby","DTA",polozkaId)
	m ^[dataDB]ALVA.ISY.CIS("RozvrhPasemJizdniDoby","DTA",polozkaId)=arr("DTA")
	d ..obnovIndex(.sys,polozkaId,1)
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
		//vymazu ji z databaze
		k ^[dataDB]ALVA.ISY.CIS("RozvrhPasemJizdniDoby","DTA",(polozkaId*-1))
		m ^[dataDB]ALVA.ISY.CIS("RozvrhPasemJizdniDoby","DTA",(polozkaId*-1))=^[dataDB]ALVA.ISY.CIS("RozvrhPasemJizdniDoby","DTA",polozkaId)
		k ^[dataDB]ALVA.ISY.CIS("RozvrhPasemJizdniDoby","DTA",polozkaId)
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
	s polozkaId=$g( polozkaId) k arr("STT")
	i polozkaId'="" {
		s arr("STT")=($d(^[dataDB]ALVA.ISY.CIS("RozvrhPasemJizdniDoby","DTA",polozkaId))>0)
	}
}

ClassMethod seznam(ByRef sys As %String, ByRef arr As %String)
{
	//vrati cely obsah ciselniku, mozno i podle vstupniho parametru
	//IN
	//arr("GLB")=global s prenasenymi daty
	//OUT
	//arr("DTA",polozkaId)=$lb(dta,dta,...) nebo @arr("GLB")@("DTA",polozkaId)=$lb(dta,dta,...)
	//arr("IDX",abcidx)=polozkaId nebo @arr("GLB")@("IDX",abcidx)=polozkaId
	$$$FillParams
	s glb=$g(arr("GLB"))
	s hledanyText=$g(arr("PAR","hledanyText"))
	s hledanyText=$ZCONVERT(##class(ALVA.GENERALAPI.String).HackyACarkyFuc(hledanyText),"U")
	s abcidx="" f {
		s rozvrhPasemJizdniDobyId="" s abcidx=$o(^[dataDB]ALVA.ISY.CIS("RozvrhPasemJizdniDoby","IDX",1,abcidx),1,rozvrhPasemJizdniDobyId) i (abcidx="") q
		s val=$g(^[dataDB]ALVA.ISY.CIS("RozvrhPasemJizdniDoby","DTA",rozvrhPasemJizdniDobyId))
		s zkratka=$lg(val,1) s popis=$lg(val,2)
		i hledanyText'="" i $ZCONVERT(##class(ALVA.GENERALAPI.String).HackyACarkyFuc(popis),"U")'[hledanyText continue
		i glb="" {
			s arr("DTA",rozvrhPasemJizdniDobyId)=val
			s arr("IDX",abcidx)=rozvrhPasemJizdniDobyId
		}
		else {
			s @glb@("DTA",rozvrhPasemJizdniDobyId)=val
			s @glb@("IDX",abcidx)=rozvrhPasemJizdniDobyId
		}
	}
}

ClassMethod obnovIndex(ByRef sys As %String, polozkaId As %String, par As %String)
{
	$$$FillParams
	i polozkaId {
		s val=$g(^[dataDB]ALVA.ISY.CIS("RozvrhPasemJizdniDoby","DTA",polozkaId))
		s zkratka=$lg(val,1)
		i zkratka'="" {
			s abcidx=##class(ALVA.GENERALAPI.String).gSortTxt(zkratka)
			//zapis indexu
			i +par {
				s ^[dataDB]ALVA.ISY.CIS("RozvrhPasemJizdniDoby","IDX",1,abcidx)=polozkaId		
				s ^[dataDB]ALVA.ISY.CIS("RozvrhPasemJizdniDoby","IDX",2,zkratka)=polozkaId		
			}
			//vymazani indexu
			i 'par {
				k ^[dataDB]ALVA.ISY.CIS("RozvrhPasemJizdniDoby","IDX",1,abcidx)
				k ^[dataDB]ALVA.ISY.CIS("RozvrhPasemJizdniDoby","IDX",2,zkratka)
			}
		}
	}
}

}
