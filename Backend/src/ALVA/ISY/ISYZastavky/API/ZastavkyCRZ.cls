Include (ALVALIBRARY, ALVAEDFORMS, GENERAL)

Class ALVA.ISY.ISYZastavky.API.ZastavkyCRZ Extends %RegisteredObject
{

ClassMethod popis()
{
	//datovy popis vety zastavky v CRZ
	// 1 obec 			/ obec / T
	// 2 castObce		/ část obce / T
	// 3 lokalita		/ lokalita / T
	// 4 blizkaObec		/ blízká obec / T
	// 5 horologOd		/ datum zmeny / N
}

ClassMethod nacti(ByRef sys As %String, zastavkaId As %String, ByRef arr As %String)
{
	//vrati data zastavky
	//IN
	//zastavkaId = cislo zastavky v CRZ (CISu)
	//OUT
	//arr("DTA")=$lb(dta,dta,...) / popis v popis
	$$$FillParams
	s zastavkaId=$g(zastavkaId)
	i +zastavkaId {
		s dbVal=$g(^[dataDB]JRCRZ("ZA",zastavkaId))
		s val=$lfs(dbVal,"~")
 		s arr("DTA")=val
	}
}

ClassMethod uloz(ByRef sys As %String, zastavkaId As %String, ByRef arr As %String)
{
	//zapise data zastavky do databaze
	//IN
	//zastavkaId = cislo zastavky v CRZ (CISu)
	//arr("DTA")=$lb(dta,dta,...)  / data zastavky, popis v popis
	//OUT
	//arr("DTA")=$lb(dta,dta,...)
	//
	$$$FillParams
	s zastavkaId=$g(zastavkaId)
	//odstraneni indexu
	i +$g(zastavkaId) {
		d ..obnovIndex(.sys,zastavkaId,0)
		s ^[dataDB]JRCRZ("ZA",zastavkaId)=$lts($g(arr("DTA")),"~")	
		d ..obnovIndex(.sys,zastavkaId,1)
	}
}

ClassMethod existuje(ByRef sys As %String, zastavkaId As %String, ByRef arr As %String)
{
	//zjisti, zda zastavkaId zastavky existuje v databazi
	//IN
	//zastavkaId = id/cislo zastavky,
	//OUT
	//arr("STT")=0 neexistuje / >0 existuje
	$$$FillParams
	s zastavkaId=$g(zastavkaId)
	k arr("STT") 
	i +$g(zastavkaId) {s arr("STT")=($d(^[dataDB]JRCRZ("ZA",zastavkaId))>0)}
}

ClassMethod seznam(ByRef sys As %String, ByRef arr As %String) As %String
{
	//vrati seznam zastavek podle vstupniho parametru
	//IN
	//arr("GLB")=global s prenasenymi daty
	//arr("PAR","hledanyText")=zadany heldany text
	//arr("PAR","blizkaObecLstId")=$lb(blizkaObec,blizkaObec,...)
	//OUT
	//arr("DTA",id)=$lb(dta,dta,...) nebo @arr("GLB")@("DTA",id)=$lb(dta,dta,...)
	//arr("IDX",abcidx)=id nebo @arr("GLB")@("IDX",abcidx)=id
	#; $$$FillParams
	s glb=$g(arr("GLB"))
	s hledanyText=$g(arr("PAR","hledanyText"))
	k hledanyTextArr
	f cnt=1:1:$l(hledanyText,",") {
		s txt=$p(hledanyText,",",cnt) i txt'="" s hledanyTextArr(txt)=$ZCONVERT(##class(ALVA.GENERALAPI.String).HackyACarkyFuc(txt),"U")
	}
	i hledanyText'="" {
		s zastavkaId="" f {
			s dbVal="" s zastavkaId=$o(^[dataDB]JRCRZ("ZA",zastavkaId),1,dbVal) i zastavkaId="" q
			s obec=$p(dbVal,"~",1) s castObce=$p(dbVal,"~",2) s lokalita=$p(dbVal,"~",2) s blizkaObec=$p(dbVal,"~",4)
			s nazev=obec_","_castObce_","_lokalita
			s nazevU=$ZCONVERT(##class(ALVA.GENERALAPI.String).HackyACarkyFuc(nazev),"U")		
			s vyhovuje=0
			//nazev
			i hledanyText="*" {
				s vyhovuje=1
			}
			else {
				s txt="" f {
					s txtU="" s txt=$o(hledanyTextArr(txt),1,txtU) i txt="" q
					i vyhovuje q
					i nazevU[txtU s vyhovuje=1	
					i (+txtU)&(zastavkaId=txtU) s vyhovuje=1
				}
			}
			//blizka obec
			i vyhovuje {
				i $g(arr("PAR","blizkaObecLstId"))'="" {
					i '$lf($g(arr("PAR","blizkaObecLstId")),blizkaObec) s vyhovuje=0
			}
			i vyhovuje {
				s abcidx=##class(ALVA.GENERALAPI.String).gSortTxt(nazev_"$"_blizkaObec_"$"_(+zastavkaId))
				k arrDta d ..nacti(.sys,zastavkaId,.arrDta)
				i glb="" {
					s arr("DTA",zastavkaId)=$g(arrDta("DTA"))
					s arr("IDX",abcidx)=zastavkaId
				}
				else {
					s @glb@("DTA",zastavkaId)=$g(arrDta("DTA"))
					s @glb@("IDX",abcidx)=zastavkaId
				}		
			}
		}
	}
	
	}
}

ClassMethod vyhledejIdPodleNazvu(ByRef sys As %String, ByRef zastavkaId As %String, ByRef arr As %String) As %String
{
	//vyhleda a vrati zastavkaId podle nazvu
	//IN
	//arr("DTA")=$lb(obec,castObce,lokalita,blizkaObec)
	//OUT
	//zastavkaId=zastavkaId v celostatnim registru
	$$$FillParams
	s val=$g(arr("DTA"))
	s obec=$lg(val,1) s castObce=$lg(val,2) s lokalita=$lg(val,3) s blizkaObec=$lg(val,4)
	s zastavkaId=$g(^[dataDB]JRCRZ("IZ",obec_"~"_castObce_"~"_lokalita_"~"_blizkaObec))
}

ClassMethod obnovIndex(ByRef sys As %String, zastavkaId As %String, par As %String)
{
	//obsluha indexoveho globalu
	$$$FillParams
	i $d(^[dataDB]JRCRZ("ZA",zastavkaId)) {
		s dbVal=$g(^[dataDB]JRCRZ("ZA",zastavkaId))
		s obec=$p(dbVal,"~",1) s castObce=$p(dbVal,"~",2) s lokalita=$p(dbVal,"~",3) s blizkaObec=$p(dbVal,"~",4)
		//zapis indexu
		i +par {
			s idx=obec_"~"_castObce_"~"_lokalita_"~"_blizkaObec
			s ^[dataDB]JRCRZ("IZ",idx)=zastavkaId
			s idx=obec_"~"_castObce_"~"_lokalita
			s idx=$ZCONVERT(##class(ALVA.GENERALAPI.String).HackyACarkyFuc(idx),"U")_blizkaObec_zastavkaId
			s ^[dataDB]JRCRZ("SZ",idx)=zastavkaId
		}
		//vymazani indexu
		i 'par {
			s idx=obec_"~"_castObce_"~"_lokalita_"~"_blizkaObec
			k ^[dataDB]JRCRZ("IZ",idx)
			s idx=obec_"~"_castObce_"~"_lokalita
			s idx=$ZCONVERT(##class(ALVA.GENERALAPI.String).HackyACarkyFuc(idx),"U")_blizkaObec_zastavkaId
			k ^[dataDB]JRCRZ("SZ",idx)
		}
	}
}

}
