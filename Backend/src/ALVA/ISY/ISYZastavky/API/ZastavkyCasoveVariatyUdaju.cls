Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYZastavky.API.ZastavkyCasoveVariatyUdaju Extends %RegisteredObject
{

ClassMethod popis()
{
	// udajId=1 - nazev zastavky - DTA=$lb(obec,castObce,lokalita,blizkaObec,nazevMHD)
}

ClassMethod nacti(ByRef sys As %String, ByRef id As %String, dGlb As %String, ByRef arr As %String)
{
	//vrati data casovych udaju zastavky
	//IN
	//id=$lb(zastavkaId,udajId,horolog)
	//nebo dGlb = global, kde jsou data zastavky tak, jak jsou ulozeny v databazi, pak se data nacitaji z nej
	//OUT
	//arr("DTA")=$lb(dta,dta,...) / data casovych udaju zastavky, popis v popis
	$$$FillParams
	s zastavkaId=$lg(id,1) s udajId=$lg(id,2) s hrl=$lg(id,3) s dGlb=$g(dGlb) k arr("DTA")
	//neni-li datovy global a je-li zastavkaId, pak nacitam data z databaze
	i (dGlb="")&(zastavkaId) {s dGlb=$name(^[dataDB]JRZ(zastavkaId))}
	//neni hrl, vemu posledni 
	i hrl="" {s hrl=$o(@dGlb@("CasoveVariantyUdaju",udajId,hrl),-1)}
	//je hrl ale udaj neni pod hrl v databazi - vemu nejblizsi predchozi 
	i hrl i '$d(@dGlb@("CasoveVariantyUdaju",udajId,hrl)) s hrl=$o(@dGlb@("CasoveVariantyUdaju",udajId,(hrl+.01)),-1)
	s $li(id,3)=hrl
	i hrl {
		s valDB=$g(@dGlb@("CasoveVariantyUdaju",udajId,hrl))
		s arr("DTA")=$lfs(valDB,"~")
	}
}

ClassMethod uloz(ByRef sys As %String, ByRef id As %String, dGlb As %String, ByRef arr As %String)
{
	//zapise data casovych udaju zastavky
	//IN
	//id=$lb(zastavkaId,udajId,horolog)
	//nebo dGlb = global, kde jsou data zastavky tak, jak jsou ulozeny v databazi, pak se data zapisuji do nej
	//arr("DTA")=$lb(dta,dta,...)  / data casovych udaju zastavky, popis v popis
	//OUT
	//
	$$$FillParams
	s zastavkaId=$lg(id,1) s udajId=$lg(id,2) s hrl=$lg(id,3) s dGlb=$g(dGlb)
	//neni-li datovy global a je-li zastavkaId, pak nacitam data z databaze
	i (dGlb="")&(zastavkaId) {s dGlb=$name(^[dataDB]JRZ(zastavkaId))}
	i hrl {s @dGlb@("CasoveVariantyUdaju",udajId,hrl)=$lts($g(arr("DTA")),"~")}
}

ClassMethod vymaz(ByRef sys As %String, ByRef id As %String, dGlb As %String, ByRef arr As %String)
{
	//vymaze data casovych udaju zastavky
	//IN
	//id=$lb(zastavkaId,udajId,horolog)
	//OUT
	//
	$$$FillParams
	s zastavkaId=$lg(id,1) s udajId=$lg(id,2) s hrl=$lg(id,3) s dGlb=$g(dGlb)
	//neni-li datovy global a je-li zastavkaId, pak nacitam data z databaze
	i (dGlb="")&(zastavkaId) {s dGlb=$name(^[dataDB]JRZ(zastavkaId))}
	i hrl {k @dGlb@("CasoveVariantyUdaju",udajId,hrl)}
}

ClassMethod existuje(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//zjisti, zda casova data zastavky existuji
	//IN
	//id=$lb(zastavkaId,udajId,horolog)
	//OUT
	//arr("STT")=0 neexistuje / >0 existuje
	$$$FillParams
	k arr("STT") 
	s zastavkaId=$lg(id,1) s udajId=$lg(id,2) s hrl=$lg(id,3) s dGlb=$g(dGlb) 
	//neni-li datovy global a je-li zastavkaId, pak nacitam data z databaze
	i (dGlb="")&(zastavkaId) {s dGlb=$name(^[dataDB]JRZ(zastavkaId))}
	s arr("STT")=($d(@dGlb@("CasoveVariantyUdaju",udajId,hrl))>0)
}

ClassMethod seznam(ByRef sys As %String, zastavkaId As %String, dGlb As %String, ByRef arr As %String)
{
	//vrati seznam casovych dat zastavek podle vstupnich parametru
	//IN
	//arr("GLB")=global pro vystupni seznam zastavek
	//arr("PAR","hledanyText")=zadany hledany text
	//arr("PAR","udajLstId")=$lb(udajId,udajId,...)
	//OUT
	//arr("DTA",udajId,hrl)=$lb(dta,dta,...) nebo @arr("GLB")@("DTA",udajId,hrl)=$lb(dta,dta,...)
	$$$FillParams
	$$$TMPGLBSET(glbDta)
	$$$TMPGLBSET(glbLst)
	k arr("DTA")
	i (dGlb="")&(zastavkaId) {s dGlb=$name(^[dataDB]JRZ(zastavkaId))}
	s glb=$g(arr("GLB"))
	s hledanyText=$g(arr("PAR","hledanyText"))
	s zastavkaLstId=$g(arr("PAR","zastavkaLstId"))
	s udajLstId=$g(arr("PAR","udajLstId"))
	//
	s udajId="" f {
		s udajId=$o(@dGlb@("CasoveVariantyUdaju",udajId)) i udajId="" q
		i $ll(udajLstId) i '$lf(udajLstId,udajId) continue
		s hrl="" f {
			s hrl=$o(@dGlb@("CasoveVariantyUdaju",udajId,hrl)) i hrl="" q
			k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyCasoveVariatyUdaju).nacti(.sys,$lb(zastavkaId,udajId,hrl),dGlb,.arrDta)
			i glb="" {
				m arr("DTA",udajId,hrl)=arrDta("DTA")
			}
			else {
				m @glb@("DTA",udajId,hrl)=arrDta("DTA")
			}	
		}	
	}
}

}
