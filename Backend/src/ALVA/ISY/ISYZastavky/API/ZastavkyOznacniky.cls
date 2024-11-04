Include (ALVALIBRARY, ALVAEDFORMS, GENERAL)

Class ALVA.ISY.ISYZastavky.API.ZastavkyOznacniky Extends %RegisteredObject
{

ClassMethod popis(ByRef arr As %String)
{
	s arr(1)=$lb("nastupiste","nástupiště","T")
	s arr(2)=$lb("GPSN","GPSN|severní šířka","N")
	s arr(3)=$lb("GPSE","GPSE|východní délka","N")
	s arr(4)=$lb("popis","popis","T")
	s arr(5)=$lb("provozovatel","provozovatel","T")
	s arr(6)=$lb("odbZaRadius","odbav.zař.|rádius","N")
	s arr(7)=$lb("smart","SMART","N")
	s arr(8)=$lb("odbZaRadiusPriblizeni","odbav.zař.ME|rádius přiblížení","N")
	s arr(9)=$lb("odbZaRadiusPrijezd","odbav.zař.ME|rádius příjezd","N")
	s arr(10)=$lb("odbZaRadiusOdjezd","odbav.zař.ME|rádius odjezd","N")
	s arr(11)=$lb("odbZaRadiusOpusteni","odbav.zař.ME|rádius opuštění","N")
	s arr(12)=$lb("odbZaBodNazDisplay","odbav.zař.ME|název bodu pro display","T")
	s arr(13)=$lb("odbZaBodNazTisk","odbav.zař.ME|název bodu pro tisk","T")
	s arr(14)=$lb("odbZaNazTiskDisplay","odbav.zař.|název tisk a display","T")
	s arr(15)=$lb("odbZaNazLCD","odbav.zař.|název LCD","T")
	s arr(16)=$lb("odbZaNazPredniTablo","odbav.zař.|název přední tablo","T")
	s arr(17)=$lb("odbZaNazBocniTablo","odbav.zař.|název boční tablo","T")
	s arr(18)=$lb("odbZaNazVnitrniTablo","odbav.zař.|název vnitřní tablo","T")
	s arr(19)=$lb("odbZaNazMHDLCD","odbav.zař.|název MHD, LCD","T")
	s arr(20)=$lb("odbZaNazMHDPredniTablo","odbav.zař.|název  MHD, přední tablo","T")
	s arr(21)=$lb("odbZaNazMHDBocniTablo","odbav.zař.|název MHD, boční tablo","T")
	s arr(22)=$lb("odbZaNazMHDVnitrniTablo","odbav.zař.|název MHD, vnitřní tablo","T")
	s arr(23)=$lb("odbZaHlasic","odbav.zař.|hlásič","T")
	s arr(24)=$lb("odbZaTLMXNeGpsGTEL","odbav.zař.TLMX.|neukládat souřadnice do GTEL","N")
	s arr(25)=$lb("odbZaSlpNazDisplay","odbav.zař.ME|název sloupku pro displej","T")
}

ClassMethod nacti(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//vrati data oznacniku
	//IN
	//id=$lb(zastavkaId,oznacnikId), pak nacita data primo z databaze
	//nebo dGlb = global, kde jsou data zastavky tak, jak jsou ulozeny v databazi (co vraci DBDoGLB u zastavek) + id=$lb("",oznacnikId)
	//OUT
	//arr("DTA")=$lb(dta,dta,...) / popis v popis
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb) s zastavkaId=$lg(id,1) s oznacnikId=$lg(id,2) k arr("DTA")
	//neni-li datovy global a je-li zastavkaId, pak nacitam data z databaze
	i (dGlb="")&(+zastavkaId) {s dGlb=$name(^[dataDB]JRZ(zastavkaId))}
	s val=""
	i (oznacnikId'="") {
		s dbVal=$g(@dGlb@("Sloupek",oznacnikId))
		f cnt=1:1:25 {
			s $li(val,cnt)=$p(dbVal,"~",cnt)
		}
 		s arr("DTA")=val
	}
}

ClassMethod uloz(ByRef sys As %String, ByRef id As %String, dGlb As %String, ByRef arr As %String)
{
	//zapise data oznacniku zastavky do databaze
	//IN
	//id=$lb(zastavkaId,oznacnikId), pak zapisuje data primo z databaze
	//nebo dGlb = pomocny global, kde jsou data zastavky a oznacniky tak, jak jsou ulozeny v databazi (co vraci DBDoGLB u zastavek), pak se data zapisuji do nej + id=$lb("",oznacnikId)
	//arr("DTA")=$lb(dta,dta,...)  / data zastavky, popis v popis
	//OUT
	//id=$lb(zastavkaId,oznacnikId) - nove oznacnikId
	//arr("DTA")=$lb(dta,dta,...)
	//
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb) s zastavkaId=$lg(id,1) s oznacnikId=$lg(id,2)
	//neni-li datovy global a je-li zastavkaId, pak zapisuji data primo do databaze
	i (dGlb="")&(+zastavkaId) {s dGlb=$name(^[dataDB]JRZ(zastavkaId))}
	//zapis dat
	s val=$g(arr("DTA")) s dbVal=""
	f cnt=1:1:25 {
		s $p(dbVal,"~",cnt)=$lg(val,cnt)
	}
	//
	i oznacnikId {
		i (dGlb'="") {s @dGlb@("Sloupek",oznacnikId)=dbVal}
	}
}

ClassMethod vymaz(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	///vymaze data sloupku z databaze
	//IN
	//id=$lb(zastavkaId,oznacnikId), pak maze data primo v databazi
	//nebo dGlb = pomocny global, kde jsou data zastavky a oznacniky tak, jak jsou ulozeny v databazi (co vraci DBDoGLB u zastavek), pak se data odstrani v nem + id=$lb("",oznacnikId)
	//OUT
	//-
	//
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb) s zastavkaId=$lg(id,1) s oznacnikId=$lg(id,2)
	//neni-li datovy global a je-li zastavkaId, pak mazu data primo v databazi
	i (dGlb="")&(+zastavkaId) {s dGlb=$name(^[dataDB]JRZ(zastavkaId))}
	//vymazani
	i oznacnikId {
		i (dGlb'="") {k @dGlb@("Sloupek",oznacnikId)}
	}
}

ClassMethod existuje(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//zjisti, zda sloupek existuje v databazi
	//IN
	//id=$lb(zastavkaId,oznacnikId), pak kontrola existence primo v databazi
	//nebo dGlb = pomocny global, kde jsou data zastavky a oznacniky tak, jak jsou ulozeny v databazi (co vraci DBDoGLB u zastavek), pak se kontroluje vyskyt v nem + id=$lb("",oznacnikId)
	//OUT
	//arr("STT")=0 neexistuje / >0 existuje
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb) s zastavkaId=$lg(id,1) s oznacnikId=$lg(id,2) k arr("STT")
	//neni-li datovy global a je-li zastavkaId, pak mazu data primo v databazi
	i (dGlb="")&(+zastavkaId) {s dGlb=$name(^[dataDB]JRZ(zastavkaId))}
	//kontrola
	i oznacnikId {
		i (dGlb'="") {s arr("STT")=($d(@dGlb@("Sloupek",oznacnikId))>0)}
	}
}

ClassMethod seznam(ByRef sys As %String, zastavkaId As %String, dGlb As %String, ByRef arr As %String)
{
	//vrati seznam sloupku pro zastavku podle vstupniho parametru
	//IN
	//zastavkaId = zastavkaId pak se data nacitaji primo z databaze
	//nebo dGlb = pomocny global, kde jsou data zastavky a oznacniky tak, jak jsou ulozeny v databazi (co vraci DBDoGLB u zastavek), pak se data nacitaji z nej 
	//OUT
	//arr("DTA",oznacnikId)=$lb(dta,dta,...)
	$$$FillParams
	s zastavkaId=$g(zastavkaId) s dGlb=$g(dGlb) k arr("DTA")
	s myDGlb=dGlb
	i (myDGlb="")&(+zastavkaId) {s myDGlb=$name(^[dataDB]JRZ(zastavkaId))}
	s oznacnikId="" f {
		s oznacnikId=$o(@myDGlb@("Sloupek",oznacnikId)) i oznacnikId="" q
		k dataArr d ..nacti(.sys,$lb(zastavkaId,oznacnikId),dGlb,.dataArr)
		s arr("DTA",oznacnikId)=$g(dataArr("DTA"))
	}
}

ClassMethod noveID(ByRef sys As %String, ByRef id As %String, dGlb As %String, ByRef arr As %String)
{
	//vrati volne ID/cislo pro zastavku
	//IN
	//id=$lb(zastavkaId,""), pak kontrola existence primo v databazi
	//nebo dGlb = pomocny global, kde jsou data zastavky a oznacniky tak, jak jsou ulozeny v databazi (co vraci DBDoGLB u zastavek), pak se prideluje cislo podle nej
	//OUT
	//id=$lb(zastavkaId,oznacnikId)
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb) s zastavkaId=$lg(id,1) s oznacnikId=""
	//neni-li datovy global a je-li zastavkaId, pak mazu data primo v databazi
	i (dGlb="")&(+zastavkaId) {s dGlb=$name(^[dataDB]JRZ(zastavkaId))}
	//novy oznacnikId
	i (dGlb'="") {s oznacnikId=$o(@dGlb@("Sloupek",""),-1)+1}
	s $li(id,2)=oznacnikId
}

}
