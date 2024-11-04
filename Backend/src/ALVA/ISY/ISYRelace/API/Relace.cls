Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYRelace.API.Relace Extends %RegisteredObject
{

ClassMethod test()
{
	//d ##class(ALVA.ISY.ISYLinky.API.Linky).test()
	s sys("U","IdFa")="VS_CSAD"
		s sys("U","delimiter")=$c(0)
		s sys("U","SystemDB")="MLINE"
		s sys("C","User")=007
		s sys("U","DATA")="USER"
		s sys("U","MLP")=7
		s sys("U","fullName")="007"
		s sys("U","loginName")="007"
		s sys("C","GUID")=7
		k arr 
	d ..nacti(.sys,$lb(1,"",823130),,.arr)
	zw arr
}

ClassMethod popis()
{
	// zakladni udaje relace
	//typRelaceId= Odj / Pri
	//relaceId=textovy identifikator relace
	// arr("DTA")=$lb(dta,dta,...)
	// 1 zastavkaId			/ cislo vychozi zastavky / N
	// 2 zastavkaNazev		/ nazev vychozi zastavky / T
	// 3 zastavkaNazevTisk 	/ nazev vychozi zastavky pro tisk / T
	// arr("DTA","smer","DTA",zastavkaId)=$lb(dta,dta,...)
	// 1 zastavkaNazev		/ nazev smerove zastavky / T
	// 2 zastavkaNazevTisk 	/ nazev smerove zastavky pro tisk / T
	// arr("DTA","smer","DTA",zastavkaId,"pres","DTA",zastavkaId)=$lb(dta,dta,...)
	// 1 zastavkaNazev		/ nazev zastavky pres pro smer / T
	// 3 zastavkaNazevTisk 	/ nazev zastavky pres pro smer pro tisk / T
}

ClassMethod DBDoGLB(ByRef sys As %String, id As %String, dGlb As %String)
{
	//zapise data relace do pracovniho globalu
	//id = $lb(skupinaId,typRelaceId,relaceId)
	//typRelaceId= Odj / Pri
	//dGlb = global, kam se zapisou data linky tak, jak jsou ulozeny v databazi
	//
	$$$FillParams
	//
	s id=$g(id) s dGlb=$g(dGlb)
	s skupinaId=$lg(id,1) s typRelaceId=$lg(id,2) s relaceId=$lg(id,3)
	i (dGlb'="") {
		i ((skupinaId'="")&(typRelaceId'="")&(relaceId'="")) { 
			k @dGlb
			m @dGlb=^[dataDB]JRi(typRelaceId,skupinaId,relaceId)
		}
	}
}

ClassMethod GLBDoDB(ByRef sys As %String, ByRef id As %String, dGlb As %String)
{
	//ulozi data relace z pracovniho globalu do databaze
	//id = $lb(skupinaId,typRelaceId,relaceId)
	//typRelaceId= Odj / Pri
	//dGlb = global, kde jsou data relace tak, jak jsou ulozeny v databazi
	//
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb)
	s skupinaId=$lg(id,1) s typRelaceId=$lg(id,2) s relaceId=$lg(id,3)
	i ((skupinaId'="")&(typRelaceId'="")&(relaceId'="")) {
		d ..obnovIndex(.sys,id,0)
		k ^[dataDB]JRi(typRelaceId,skupinaId,relaceId)
		m ^[dataDB]JRi(typRelaceId,skupinaId,relaceId)=@dGlb
		d ..obnovIndex(.sys,id,1)
	}
}

ClassMethod existuje(ByRef sys As %String, ByRef id As %String, ByRef arr As %String)
{
	//zjisti, zda relace existuje v databazi
	//IN
	//id = $lb(skupinaId,typRelaceId,relaceId)
	//OUT
	//arr("STT")=0 neexistuje / >0 existuje
	$$$FillParams
	s id=$g(id)
	s skupinaId=$lg(id,1) s typRelaceId=$lg(id,2) s relaceId=$lg(id,3)
	k arr("STT") 
	i ((skupinaId'="")&(typRelaceId'="")&(relaceId'="")) {
		s arr("STT")=$d(^[dataDB]JRi(typRelaceId,skupinaId,relaceId))
	}
}

ClassMethod nacti(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//vrati zakladni data relace
	//IN
	//id = $lb(skupinaId,typRelaceId,relaceId)
	//nebo dGlb = global, kde jsou data relace tak, jak jsou ulozeny v databazi, pak se data nacitaji z nej
	//OUT
	//arr("DTA",...)=$lb(dta,dta,...) / popis v popis
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb) k arr("DTA")
	s skupinaId=$lg(id,1) s typRelaceId=$lg(id,2) s relaceId=$lg(id,3)
	//neni-li datovy global a je-li nastaveno id, pak nacitam data z databaze
	i (dGlb="")&((skupinaId'="")&(typRelaceId'="")&(relaceId'="")) {s dGlb=$name(^[dataDB]JRi(typRelaceId,skupinaId,relaceId))}
	s ^wwwj(-100)=dGlb
	s ^wwwj(-101)=id
	s valDB=$g(@dGlb@("Def","Zast"))
	s val=$lfs(valDB) s arr("DTA")=val
	s zastavkaId="" f {
		s valDB="" s zastavkaId=$o(@dGlb@("Def","Smer",zastavkaId),1,valDB) i zastavkaId="" q
		s zastavkaNazev=valDB
		s zastavkaNazevTisk=$g(@dGlb@("Def","Smer",zastavkaId,"Smer"))
		s arr("DTA","smer","DTA",zastavkaId)=$lb(zastavkaNazev,zastavkaNazevTisk)
		//IDX ?
		s zastavkaPresId="" f {
			s valDB="" s zastavkaPresId=$o(@dGlb@("Def","Smer",zastavkaId,"Pres",zastavkaPresId),1,valDB) i zastavkaPresId="" q
			s zastavkaNazev=valDB
			s zastavkaNazevTisk=$g(@dGlb@("Def","Smer",zastavkaId,"Pres",zastavkaPresId,"Pres"))
			s arr("DTA","smer","DTA",zastavkaId,"pres",zastavkaPresId)=$lb(zastavkaNazev,zastavkaNazevTisk)
		}
	}
}

ClassMethod uloz(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//ulozi zakladni data relace
	//IN
	//id = $lb(skupinaId,typRelaceId,relaceId)
	//nebo dGlb = global, kde jsou data relace tak, jak jsou ulozeny v databazi, pak se data zapisuji do nej
	//arr("DTA",...)=$lb(dta,dta,...) / popis v popis
	//OUT
	//
	$$$FillParams
	$$$TMPGLBSET(tmpglb)
	s id=$g(id) s dGlb=$g(dGlb)
	s skupinaId=$lg(id,1) s typRelaceId=$lg(id,2) s relaceId=$lg(id,3)
	//neni-li datovy global a je-li id, pak data zapisuju do databaze
	i (dGlb="")&((skupinaId'="")&(typRelaceId'="")&(relaceId'="")) {s dGlb=$name(^[dataDB]JRi(typRelaceId,skupinaId,relaceId))}
	m @tmpglb@("Def")=@dGlb@("Def")
	k @dGlb@("Def","Smer")
	//vraceni seznamu IDS
		m @dGlb@("Def","LinIDS")=@tmpglb@("Def","LinIDS")
	//vraceni zony vychozi zastavky
		m @dGlb@("Def","ZastZON")=@tmpglb@("Def","ZastZON")
		//zapis
	s val=$g(arr("DTA")) s valDB=$lts(val,"~")
	s @dGlb@("Def","Zast")=valDB
	s zastavkaId="" f {
		s val="" s zastavkaId=$o(arr("DTA","smer","DTA",zastavkaId),1,val) i zastavkaId="" q
		s zastavkaNazev=$lg(val,1),zastavkaNazevTisk=$lg(val,2)
		s @dGlb@("Def","Smer",zastavkaId)=zastavkaNazev
		i zastavkaNazevTisk'="" s @dGlb@("Def","Smer",zastavkaId,"Smer")=zastavkaNazevTisk
		s zastavkaPresId="" f {
			s val="" s zastavkaPresId=$o(arr("DTA","smer","DTA",zastavkaId,"pres",zastavkaPresId),1,val) i zastavkaPresId="" q
			s zastavkaNazev=$lg(val,1),zastavkaNazevTisk=$lg(val,2)
			s @dGlb@("Def","Smer",zastavkaId,"Pres",zastavkaPresId)=zastavkaNazev
			i zastavkaNazevTisk'="" s @dGlb@("Def","Smer",zastavkaId,"Pres",zastavkaPresId,"Pres")=zastavkaNazevTisk
		}
	}
	// projdu smery v datech - pokud neni def. vymazu data
	s zastavkaId="" f {
		 s zastavkaId=$o(@dGlb@("Data",zastavkaId)) i zastavkaId="" q
		 //vraceni zon nastavenych vypoctem
		 m @dGlb@("Def","Smer",zastavkaId,"ZON")=@tmpglb@("Def","Smer",zastavkaId,"ZON")
		 i $d(@dGlb@("Def","Smer",zastavkaId)) continue
		 k @dGlb@("Data",zastavkaId)
	}
		k @tmpglb
}

ClassMethod vymaz(ByRef sys As %String, id As %String, ByRef arr As %String)
{
	//vymaze relaci z databaze, zapis do kose
	//IN
	//id = $lb(skupinaId,typRelaceId,relaceId)
	//OUT
	//-
	//
	$$$FillParams
	s id=$g(id) s dGlb=""
	s skupinaId=$lg(id,1) s typRelaceId=$lg(id,2) s relaceId=$lg(id,3)
	i (skupinaId'="")&(typRelaceId'="")&(relaceId'="") {s dGlb=$name(^[dataDB]JRi(typRelaceId,skupinaId,relaceId))}
	i dGlb'="" {
		//vymazu ji v seznamu
		d ..obnovIndex(.sys,id,0)
		//zapisu ji do kose !!!
		//zrusim ji
		k @dGlb
		//sherlok !!!
	}
}

ClassMethod seznamSkupina(ByRef sys As %String, id As %String, ByRef arr As %String)
{
	//vrati seznam relaci ve skupine
	//IN
	//id=$lb(skupinaId,typRelaceId)
	//arr("PAR","txRelaceId")=zadany text pro hledani
	//OUT
	//arr("DTA",relaceId)=""
	$$$FillParams
	s id=$g(id) k arr("DTA")
	s skupinaId=$lg(id,1) s typRelaceId=$lg(id,2)
	s dGlb="" i (skupinaId'="")&(typRelaceId'="") {s dGlb=$name(^[dataDB]JRi(typRelaceId,skupinaId))}
		s txRelaceId=$g(arr("PAR","txRelaceId"))
	i (dGlb'="") {
		s relaceId="" f {
			s relaceId=$o(@dGlb@(relaceId)) i relaceId="" q
			i txRelaceId'="" { i (relaceId'[txRelaceId) continue }
			s arr("DTA",relaceId)=""
		}
	}
}

ClassMethod seznamEvidovaneRelace(ByRef sys As %String, typRelaceId As %String, ByRef arr As %String)
{
	//vrati seznam relaci daneho typu ve skupinach
	//IN
	//typRelaceId
	//arr("PAR","txRelaceId")=zadany text pro hledani
	//OUT
	//arr("DTA",relaceId,skupinaId)=""
	$$$FillParams
	k arr("DTA")
	s dGlb="" i (typRelaceId'="") { s dGlb=$name(^[dataDB]JRi(typRelaceId))}
	s txRelaceId=$g(arr("PAR","txRelaceId"))
	i dGlb'="" {
		s skupinaId="" f {
				s skupinaId=$o(@dGlb@(skupinaId)) i skupinaId="" q
				s relaceId="" f {
					s relaceId=$o(@dGlb@(skupinaId,relaceId)) i relaceId="" q
					i txRelaceId'="" { i (relaceId'[txRelaceId) continue }
				s arr("DTA",relaceId,skupinaId)=""			
			}
			}
	}
}

ClassMethod obnovIndex(ByRef sys As %String, id As %String, par As %String)
{
	//obsluha indexoveho globalu
	$$$FillParams
	s id=$g(id) s skupinaId=$lg(id,1) s aplId=$lg(id,2) s linkaId=$lg(id,3)
	i linkaId'="" {
		i skupinaId'=""
		i aplId'=""
		//zapis indexu
		i +par {
		}
		//vymazani indexu
		i 'par {
		}
	}
}

}
