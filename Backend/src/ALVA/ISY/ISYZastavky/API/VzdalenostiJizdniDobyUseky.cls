Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUseky Extends %RegisteredObject
{

ClassMethod popis()
{
	// ====
	// data
	// ====
	//
	// ^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId,"useky","DTA",usekId)=$lb(zastavkaOdId,oznacniOdId,zastavkaDoId,oznacnikDoId, vzdalenostPodleMap, trvaniPodleMap)
	// ^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId,"useky","DTA",usekId,"vzdalenostDoba","DTA",hrlod)=$lb(vzdalenostPresna,zakladniDobaJizdy,vzdalenostTarifni)
	// ^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId,"useky","DTA",usekId,"vzdalenostDoba","DTA",hrlod,"pasma",DTA,pasmoJizdniDobaId)=$lb(dobaJizdy)
	//
	// ================
	// indexove globaly
	// ================
	//
	// ^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId,"useky","IDX",1,zastavkaOdId,oznacniOdId,zastavkaDoId,oznacnikDoId)=usekId
	// ^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId,"useky","IDX",2,zastavkaOdId,usekId)=""
	// ^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId,"useky","IDX",3,zastavkaOdId,oznacnikOdId,usekId)=""
	// ^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId,"useky","IDX",4,zastavkaDoId,usekId)=""
	// ^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId,"useky","IDX",5,zastavkaDoId,oznacnikDoId,usekId)=""
}

ClassMethod nacti(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//vrati data useku vzdalenosti a jiznich dob
	//IN
	//id=$lb(vzdalenostiJizdniDobyId,usekId), pak nacita data primo z databaze
	//nebo dGlb = global, kde jsou data zastavky tak, jak jsou ulozeny v databazi (co vraci DBDoGLB u VzdalenostiJizdniDoby) + id=$lb("",usekId)
	//OUT
	//arr("DTA")=$lb(dta,dta,...) 		/ popis v popis
	//arr("DTA",...)=$lb(dta,dta,...)	/ popis v popis	
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb) s vzdalenostiJizdniDobyId=$lg(id,1) s usekId=$lg(id,2) k arr("DTA")
	//neni-li datovy global a je-li vzdalenostiJizdniDobyId, pak nacitam data z databaze
	i (dGlb="")&(+vzdalenostiJizdniDobyId) {s dGlb=$name(^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId))}
	//data
	m arr("DTA")=@dGlb@("useky","DTA",usekId)
}

ClassMethod uloz(ByRef sys As %String, ByRef id As %String, dGlb As %String, ByRef arr As %String)
{
	//zapise data useku vzdalenosti a jiznich dob
	//IN
	//id=$lb(vzdalenostiJizdniDobyId,usekId), pak nacita data primo z databaze
	//nebo dGlb = global, kde jsou data zastavky tak, jak jsou ulozeny v databazi (co vraci DBDoGLB u VzdalenostiJizdniDoby) + id=$lb("",usekId)
	//pokud neni usekId, automaticky se prideli
	//arr("DTA")=$lb(dta,dta,...)  		/ data useku vzdalenosti a jiznich dob viz. popis
	//arr("DTA",...)=$lb(dta,dta,...)  	/ data useku vzdalenosti a jiznich dob viz. popis
	//OUT
	//id=$lb(vzdalenostiJizdniDobyId,usekId)
	//arr("DTA")=$lb(dta,dta,...)
	//arr("DTA",...)=$lb(dta,dta,...)  	/ data useku vzdalenosti a jiznich dob viz. popis
	//
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb) s vzdalenostiJizdniDobyId=$lg(id,1) s usekId=$lg(id,2)
	//neni-li datovy global a je-li vzdalenostiJizdniDobyId, pak nacitam data z databaze
	i (dGlb="")&(+vzdalenostiJizdniDobyId) {s dGlb=$name(^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId))}
	//odstraneni indexu
	i +$g(usekId) { d ..obnovIndex(.sys,dGlb,usekId,0) }
	//pokud neni usekId, tak si pridelim nove
	i 'usekId { s usekId=$i(@dGlb@("useky","DTA")) s $li(id,2)=usekId }
	//zapis dat do databaze
	m ^ps("save",usekId) = arr("DTA")
	k @dGlb@("useky","DTA",usekId)
	m @dGlb@("useky","DTA",usekId)=arr("DTA")
	//zapis do indexu
	i +$g(usekId) { d ..obnovIndex(.sys,dGlb,usekId ,1) }
}

ClassMethod vymaz(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//vymaze usek vzdalenosti a jizdnich dob z databaze, zapis do kose
	//IN
	//id=$lb(vzdalenostiJizdniDobyId,usekId)
	//nebo dGlb = global, kde jsou data vzdalenosti tak, jak jsou ulozeny v databazi (co vraci DBDoGLB u VzdalenostiJizdniDoby) + id=$lb("",usekId)
	//OUT
	//-
	//
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb) s vzdalenostiJizdniDobyId=$lg(id,1) s usekId=$lg(id,2)
	//neni-li datovy global a je-li vzdalenostiJizdniDobyId, pak nacitam data z databaze
	i (dGlb="")&(+vzdalenostiJizdniDobyId) {s dGlb=$name(^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId))}
	i +$g(usekId) {
		d ..obnovIndex(.sys,dGlb,usekId,0)
		k @dGlb@("useky","DTA",-usekId)
		m @dGlb@("useky","DTA",-usekId)=@dGlb@("useky","DTA",usekId)
		k @dGlb@("useky","DTA",usekId)
		//do kose !!!
		//sherlok !!!
	}
}

ClassMethod existuje(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//test na existeni useku podle usekId
	//IN
	///id=$lb(vzdalenostiJizdniDobyId,usekId)
	//nebo dGlb = global, kde jsou data vzdalenosti tak, jak jsou ulozeny v databazi (co vraci DBDoGLB u VzdalenostiJizdniDoby) + id=$lb("",usekId)
	//OUT
	//arr("STT")=0 neexistuje / >0 existuje
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb) s vzdalenostiJizdniDobyId=$lg(id,1) s usekId=$lg(id,2) k arr("STT")
	//neni-li datovy global a je-li vzdalenostiJizdniDobyId, pak nacitam data z databaze
	i (dGlb="")&(+vzdalenostiJizdniDobyId) {s dGlb=$name(^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId))}
	i +$g(usekId) {
		s arr("STT")=($d(@dGlb("useky","DTA",usekId))>0)
	}
}

ClassMethod obnovIndex(ByRef sys As %String, dGlb As %String, usekId As %String, par As %String)
{
	//obsluha indexoveho globalu
	$$$FillParams
	i $d(@dGlb@("useky","DTA",usekId)) {
		s val=$g(@dGlb@("useky","DTA",usekId))
		s zastavkaOdId=$lg(val,1)
		s oznacnikOdId=+$lg(val,2)
		s zastavkaDoId=$lg(val,3)
		s oznacnikDoId=+$lg(val,4)
		//zapis indexu
		i +par {
			s @dGlb@("useky","IDX",1,zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId)=usekId
			s @dGlb@("useky","IDX",2,zastavkaOdId,usekId)=""
			s @dGlb@("useky","IDX",3,zastavkaOdId,oznacnikOdId,usekId)=""
			s @dGlb@("useky","IDX",4,zastavkaDoId,usekId)=""
			s @dGlb@("useky","IDX",5,zastavkaDoId,oznacnikDoId,usekId)=""				
		}
		//vymazani indexu
		i 'par {
			k @dGlb@("useky","IDX",1,zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId)
			k @dGlb@("useky","IDX",2,zastavkaOdId,usekId)
			k @dGlb@("useky","IDX",3,zastavkaOdId,oznacnikOdId,usekId)
			k @dGlb@("useky","IDX",4,zastavkaDoId,usekId)
			k @dGlb@("useky","IDX",5,zastavkaDoId,oznacnikDoId,usekId)
		}
	}
}

ClassMethod seznam(ByRef sys As %String, vzdalenostiJizdniDobyId As %String, dGlb As %String, ByRef arr As %String)
{
	//vrati seznam evidovanych useku vzdalenosti a jizdnich dob podle vstupniho parametru
	//IN
	//vzdalenostiJizdniDobyId
	//arr("PAR","hledanyText")=zadany hledany text / * vse / "" nic / cast nazvu zastavky
	//arr("PAR","vzdalenostOd")=vzdalenostOd ... porovnava se s presnou vzdalenosti
	//arr("PAR","vzdalenostDo")=vzdalenostDo ... porovnava se s presnou vzdalenosti
	//arr("PAR","dobaJizdyOd")=dobaJizdyOd
	//arr("PAR","dobaJizdyDo")=dobaJizdyDo
	//arr("GLB")=global pro navrat dat, pokud neni tak v arr
	//OUT
	//arr("DTA",usekId)=$lb(dta,dta,...)
	//arr("IDX",abcidx)=usekId
	$$$FillParams
	$$$TMPGLBSET(tmpglblst) k @tmpglblst
	s vzdalenostiJizdniDobyId=$g(vzdalenostiJizdniDobyId) s dGlb=$g(dGlb) s glb=$g(arr("GLB")) k arr("DTA")
	//neni-li datovy global a je-li vzdalenostiJizdniDobyId, pak nacitam data z databaze
	i (dGlb="")&(+vzdalenostiJizdniDobyId) {s dGlb=$name(^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId))}	
	//parametry
	s hledanyText=$g(arr("PAR","hledanyText")) s hledanyText=$ZCONVERT(##class(ALVA.GENERALAPI.String).HackyACarkyFuc(hledanyText),"U")
	s vzdalenostOd=$g(arr("PAR","vzdalenostOd"))
	s vzdalenostDo=$g(arr("PAR","vzdalenostDo"))
	s dobaJizdyOd=$g(arr("PAR","dobaJizdyOd"))
	s dobaJizdyDo=$g(arr("PAR","dobaJizdyDo"))
	//
	i hledanyText'="" {		
		//priprava vsech polozek 
		s usekId=0 f  {
			s val="" s usekId=$o(@dGlb@("useky","DTA",usekId),1,val) i usekId="" q
			//
			s hrlod=$o(@dGlb@("useky","DTA",usekId,"vzdalenostDoba","DTA",""),-1)
			s vzdalenostPresna="" s zakladniDobaJizdy="" s vzdalenostTarifni=""
			i hrlod {
				s tmpval=$g(@dGlb@("useky","DTA",usekId,"vzdalenostDoba","DTA",hrlod))
				s vzdalenostPresna=$lg(tmpval,1)
				s zakladniDobaJizdy=$lg(tmpval,2)
				s vzdalenostTarifni=$lg(tmpval,3)
			}
			s zastavkaOdId=$lg(val,1) s zastavkaOdNazev=""
			k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).nactiNazev(.sys,zastavkaOdId,.arrDta)
			s valZst=$g(arrDta("DTA")) s zastavkaOdNazev=$lg(valZst,1)_","_$lg(valZst,2)_","_$lg(valZst,3)_"/"_$lg(valZst,4)
			//
			s oznacnikOdId=$lg(val,2)
			//
			s zastavkaDoId=$lg(val,3) s zastavkaDoNazev=""
			k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).nactiNazev(.sys,zastavkaDoId,.arrDta)
			s valZst=$g(arrDta("DTA")) s zastavkaDoNazev=$lg(valZst,1)_","_$lg(valZst,2)_","_$lg(valZst,3)_"/"_$lg(valZst,4)
			//
			s oznacnikDoId=$lg(val,4)
			//
			s abcidx1=##class(ALVA.GENERALAPI.String).gSortTxt(zastavkaOdNazev)
			s abcidx2=##class(ALVA.GENERALAPI.String).gSortTxt(zastavkaDoNazev)
			//			                               1            2               3            4            5               6            7     8               9                 0
			s @tmpglblst@(abcidx1,abcidx2,usekId)=$lb(zastavkaOdId,zastavkaOdNazev,oznacnikOdId,zastavkaDoId,zastavkaDoNazev,oznacnikDoId,hrlod,vzdalenostPresna,zakladniDobaJizdy,vzdalenostTarifni)
			i hrlod {
				m @tmpglblst@(abcidx1,abcidx2,usekId,"pasma")=@dGlb@("useky","DTA",usekId,"vzdalenostDoba","DTA",hrlod,"pasma","DTA")
			}
		}
		s idx=0
		s idx1="" f  {
			s idx1=$o(@tmpglblst@(idx1)) i idx1="" q
			s idx2="" f {
				s idx2=$o(@tmpglblst@(idx1,idx2)) i idx2="" q
				s usekId="" f {
					s val="" s usekId=$o(@tmpglblst@(idx1,idx2,usekId),1,val) i (usekId="") q
					s zastavkaOdNazev=$lg(val,2)
					s zastavkaDoNazev=$lg(val,5)
					s vzdalenostPresna=$lg(val,8)
					s zakladniDobaJizdy=$lg(val,9)
					//filtr
					i ((vzdalenostOd'="")&(vzdalenostPresna<vzdalenostOd)) continue
					i ((vzdalenostDo'="")&(vzdalenostPresna>vzdalenostDo)) continue
					i ((dobaJizdyOd'="")&(zakladniDobaJizdy<dobaJizdyOd)) continue
					i ((dobaJizdyDo'="")&(zakladniDobaJizdy>dobaJizdyDo)) continue
					//hledanyText
					i hledanyText'="*" {
						i $ZCONVERT(##class(ALVA.GENERALAPI.String).HackyACarkyFuc(zastavkaOdNazev_zastavkaDoNazev),"U")'[hledanyText continue
					}
					i glb="" {
						m arr("DTA",usekId)=@dGlb@("useky","DTA",usekId)
						s arr("IDX",$i(idx))=usekId
					}
					else {
						m @glb@("DTA",usekId)=@dGlb@("useky","DTA",usekId)
						s @glb@("IDX",$i(idx))=usekId
					}
				}
			}
		}
	}
	k @tmpglblst
}

}
