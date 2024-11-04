Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDoby Extends %RegisteredObject
{

ClassMethod test()
{
	//d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDoby).test()
	s sys("U","IdFa")="VS_CSAD"
    s sys("U","delimiter")=$c(0)
    s sys("U","SystemDB")="MLINE"
    s sys("C","User")=007
    s sys("U","DATA")="USER"
    s sys("U","MLP")=7
    s sys("U","fullName")="007"
    s sys("U","loginName")="007"
    s sys("C","GUID")=7
 	k arr s arr("DTA")=$lb("test2","hokus pokus") s err=##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDoby).uloz(.sys,.arr) w !,err
}

ClassMethod popisGlobalu()
{
	// ====
	// data
	// ====
	//
	// ^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId)=$lb(zkratka,popis)
	// -> ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUseky
	//
	// ================
	// indexove globaly
	// ================
	//
	// ^[dataDB]ALVA.ISY.VZD("IDX",1,abcidx)=vzdalenostiJizdniDobyId
	// ^[dataDB]ALVA.ISY.VZD("IDX",2,zkratka)=vzdalenostiJizdniDobyId
	// -> ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUseky
	//
}

ClassMethod popis()
{
	// 1 zkratka / zkratka / T
	// 2 popis   / popis / T
}

ClassMethod DBDoGLB(ByRef sys As %String, vzdalenostiJizdniDobyId As %String, dGlb As %String)
{
	//zapise data vzdalenosti a jiznich dob do pracovniho globalu
	//vzdalenostiJizdniDobyId = id vzdalenosti a jiznich dob
	//dGlb = global, kam se zapisou data vzdalenosti a jiznich dob tak, jak jsou ulozeny v databazi
	$$$FillParams
	//
	s vzdalenostiJizdniDobyId=$g(vzdalenostiJizdniDobyId) s dGlb=$g(dGlb)
	i (dGlb'="") {
		k @dGlb
		i (vzdalenostiJizdniDobyId) {
			m @dGlb=^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId)
		}
	}
}

ClassMethod GLBDoDB(ByRef sys As %String, ByRef vzdalenostiJizdniDobyId As %String, dGlb As %String)
{
	//ulozi data vzdalenosti a jiznich dob do databaze
	//vzdalenostiJizdniDobyId = id vzdalenosti a jiznich dob
	//dGlb = global, odkud se zapisou data vzdalenosti a jiznich dob do databaze
	//
	$$$FillParams
	s vzdalenostiJizdniDobyId=$g(vzdalenostiJizdniDobyId) s dGlb=$g(dGlb)
	//odstraneni indexu
	i +vzdalenostiJizdniDobyId {d ..obnovIndex(.sys,vzdalenostiJizdniDobyId,0)}
	//pokud neni vzdalenostiJizdniDobyId, tak si pridelim nove
	i 'vzdalenostiJizdniDobyId {s vzdalenostiJizdniDobyId=$i(^[dataDB]ALVA.ISY.VZD("DTA"))}
	//zapis dat do databaze
	k ^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId)
	m ^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId)=@dGlb
	//zapis do indexu
	d ..obnovIndex(.sys,vzdalenostiJizdniDobyId,1)
}

ClassMethod nacti(ByRef sys As %String, vzdalenostiJizdniDobyId As %String, dGlb As %String, ByRef arr As %String)
{
	//IN
	//vzdalenostiJizdniDobyId
	//nebo dGlb = global, kde jsou data vzdalenosti a jizdnich dob zastavky tak, jak jsou ulozeny v databazi, pak se data nacitaji z nej
	//OUT
	//arr("DTA")=$lb(dta,dta,...) / popis v popis
	$$$FillParams
	s vzdalenostiJizdniDobyId=$g(vzdalenostiJizdniDobyId) s dGlb=$g(dGlb) k arr("DTA")
	//neni-li datovy global a je-li zastavkaId, pak nacitam data z databaze
	i (dGlb="")&(vzdalenostiJizdniDobyId) {s dGlb=$name(^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId))}
	s arr("DTA")=$g(@dGlb)
}

ClassMethod uloz(ByRef sys As %String, ByRef vzdalenostiJizdniDobyId As %String, dGlb As %String, ByRef arr As %String)
{
	//ulozi zakladni data varianty vzdalenosti a jiznich dob
	//IN
	//vzdalenostiJizdniDobyId - id vzdalenosti	/ pokud neni a uklada-li se do databaze, automaticky se prideli
	//nebo dGlb = global, kde jsou data vzdalenosti tak, jak jsou ulozeny v databazi, pak se data zapisuji do nej
	//arr("DTA")=$lb(dta,dta,...)  			  	/ zakladni data vzdalenosti a jiznich dob viz. popis
	//OUT
	//vzdalenostiJizdniDobyId - pokud se pridelilo
	//arr("DTA")=$lb(dta,dta,...) 
	//
	$$$FillParams
	s vzdalenostiJizdniDobyId=$g(vzdalenostiJizdniDobyId) s dGlb=$g(dGlb)
	//zapis do pomocneho datoveho globalu, prijde-li
	i (dGlb'="") {s @dGlb=$g(arr("DTA"))}
	//zapis primo do databaze, pomocny datovy global neni definovan
	else {
		//odstraneni indexu
		i +vzdalenostiJizdniDobyId {d ..obnovIndex(.sys,vzdalenostiJizdniDobyId,0)}
		//pokud neni zastavkaId, tak si pridelim nove
		i 'vzdalenostiJizdniDobyId {s vzdalenostiJizdniDobyId=$i(^[dataDB]ALVA.ISY.VZD("DTA"))}
		//zapis dat do databaze
		s ^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId)=$g(arr("DTA"))
		//zapis do indexu
		d ..obnovIndex(.sys,vzdalenostiJizdniDobyId,1)	
	}
}

ClassMethod vymaz(ByRef sys As %String, vzdalenostiJizdniDobyId As %String, ByRef arr As %String)
{
	//vymaze variantu vzdalenosti a jizdnich dob z databaze, zapis do kose
	//IN
	//vzdalenostiJizdniDobyId
	//OUT
	//-
	//
	$$$FillParams
	s vzdalenostiJizdniDobyId=$g(vzdalenostiJizdniDobyId)
	i vzdalenostiJizdniDobyId {
		//vymazu ji v seznamu
		d ..obnovIndex(.sys,vzdalenostiJizdniDobyId,0)
		//zapisu ji do kose !!!
		k ^[dataDB]ALVA.ISY.VZD("DTA",-vzdalenostiJizdniDobyId)
		m ^[dataDB]ALVA.ISY.VZD("DTA",-vzdalenostiJizdniDobyId)=^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId)
		//zrusim ji
		k ^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId)
	//sherlok !!!
	}
}

ClassMethod existuje(ByRef sys As %String, vzdalenostiJizdniDobyId As %String, ByRef arr As %String)
{
	//zjisti, zda existuje varianta vzdalenosti a jizdnich dob v databazi podle vzdalenostiJizdniDobyId
	//IN
	//vzdalenostiJizdniDobyId
	//OUT
	//arr("STT")=0 neexistuje / >0 existuje
	$$$FillParams
	k arr("STT")
	s vzdalenostiJizdniDobyId=$g(vzdalenostiJizdniDobyId)
	i +$g(vzdalenostiJizdniDobyId) { s arr("STT")=($d(^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId))>0) }
}

ClassMethod seznam(ByRef sys As %String, ByRef arr As %String)
{
	//vrati seznam evidovanych variant vzdalenosti a jizdnich dob podle vstupniho parametru
	//IN
	//arr("GLB")=global s prenasenymi daty
	//arr("PAR","hledanyText")=zadany hledany text
	//OUT
	//arr("DTA",vzdalenostiJizdniDobyId)=$lb(dta,dta,...)
	//arr("IDX",abcidx)=vzdalenostiJizdniDobyId
	$$$FillParams
	s glb=$g(arr("GLB"))
	s hledanyText=$g(arr("PAR","hledanyText"))
	s hledanyText=$ZCONVERT(##class(ALVA.GENERALAPI.String).HackyACarkyFuc(hledanyText),"U")
	//
	s abcidx="" f {
		s vzdalenostiJizdniDobyId="" s abcidx=$o(^[dataDB]ALVA.ISY.VZD("IDX",1,abcidx),1,vzdalenostiJizdniDobyId) i (abcidx="") q
		s val=$g(^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId))
		s zkratka=$lg(val,1) s popis=$lg(val,2)
		i hledanyText'="" i $ZCONVERT(##class(ALVA.GENERALAPI.String).HackyACarkyFuc(popis),"U")'[hledanyText continue
		i glb="" {
			s arr("DTA",vzdalenostiJizdniDobyId)=val
			s arr("IDX",abcidx)=vzdalenostiJizdniDobyId
		}
		else {
			s @glb@("DTA",vzdalenostiJizdniDobyId)=val
			s @glb@("IDX",abcidx)=vzdalenostiJizdniDobyId
		}
	}
}

ClassMethod obnovIndex(ByRef sys As %String, vzdalenostiJizdniDobyId As %String, par As %String)
{
	//obsluha indexoveho globalu
	$$$FillParams
	i $d(^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId)) {
		s val=$g(^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId))
		s zkratka=$lg(val,1)
		s abcidx=##class(ALVA.GENERALAPI.String).gSortTxt(zkratka)
		//zapis indexu
		i +par {
			s ^[dataDB]ALVA.ISY.VZD("IDX",1,abcidx)=vzdalenostiJizdniDobyId
			s ^[dataDB]ALVA.ISY.VZD("IDX",2,zkratka)=vzdalenostiJizdniDobyId
		}
		//vymazani indexu
		i 'par {
			k ^[dataDB]ALVA.ISY.VZD("IDX",1,abcidx)
			k ^[dataDB]ALVA.ISY.VZD("IDX",2,zkratka)
		}
	}
}

}
