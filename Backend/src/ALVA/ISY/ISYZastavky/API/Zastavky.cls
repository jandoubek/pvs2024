Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYZastavky.API.Zastavky Extends %RegisteredObject
{

ClassMethod popis(ByRef arr As %String)
{
	//datovy popis vety zastavky
	//
	s arr(1)=$lb("obec","obec","T")
	s arr(2)=$lb("castObce","část obce","T")
	s arr(3)=$lb("lokalita","lokalita","T")
	s arr(4)=$lb("blizkaObec","blízká|obec","T")
	s arr(5)=$lb("provozovatel","provozovatel","T")
	s arr(6)=$lb("casovePasmo","časové|pásmo","T")
	s arr(7)=$lb("atribut","atribut","T")
	s arr(8)=$lb("smerTyp","směr typ","N")
	s arr(9)=$lb("odbZaNazKratky","odbav.zař.|název krátký","T")
	s arr(10)=$lb("odbZaNazDlouhy","odbav.zař.|název dlouhý","T")
	s arr(11)=$lb("odbZaNazBocniTablo","odbav.zař.|název boční tablo","T")
	s arr(12)=$lb("odbZaCislo","odbav.zař.|číslo","N")
	s arr(13)=$lb("nazevMHD","název pro MHD","T")
	s arr(14)=$lb("cisloCRZ","číslo|CRZ(CIS)","N")
	s arr(15)=$lb("tarZona","tarifní zóna","T")
	s arr(16)=$lb("hranicniIDS","hraniční IDS","N")
	s arr(17)=$lb("tarZonaDalsi","tarifní zóna|další","T")
	s arr(18)=$lb("odbZaNazPredniTablo","odbav.zař.|název přední tablo","T")
	s arr(19)=$lb("GPSN","GPSN|severní šířka","N")
	s arr(20)=$lb("GPSE","GPSE|východní délka","N")
	s arr(21)=$lb("odbZaHlasic","odbav.zař.|hlásič","T")
	s arr(22)=$lb("odbZaSkuSleva","odbav.zař.|skupina pro slevu","T")
	s arr(23)=$lb("odbZaRadius","odbav.zař.|rádius","N")
	s arr(24)=$lb("odbZaNazLCD","odbav.zař.|název LCD","T")
	s arr(25)=$lb("odbZaNazTiskDisplay","odbav.zař.|název tisk a display","T")
	s arr(26)=$lb("vlakova","vlaková","N")
	s arr(27)=$lb("cisloSR70","číslo SR70","T")
	s arr(28)=$lb("vyznamna","významná","N")
	s arr(29)=$lb("odbZaNazVnitrniTablo","odbav.zař.|název vnitřní tablo","T")
	s arr(30)=$lb("odbZaTarZona","odbav.zař.|tarifní zóna (ME)","T")
	s arr(31)=$lb("odbZaTarZonaDalsi","odbav.zař.|tarifní zóna další (ME)","T")
	s arr(32)=$lb("odbZaNazMHDBocniTablo","odbav.zař.|název MHD, boční tablo","T")
	s arr(33)=$lb("odbZaNazMHDVnitrniTablo","odbav.zař.|název MHD, vnitřní tablo","T")
	s arr(34)=$lb("cisloSR70M","číslo SR70|mezinárodní","T")
	s arr(35)=$lb("odbZaNazMHDPredniTablo","odbav.zař.|název  MHD, přední tablo","T")
	s arr(36)=$lb("smart","SMART","N")
	s arr(37)=$lb("odbZaVzdyExport","odbav.zař.|vždy exportovat (ME)","N")
	s arr(38)=$lb("odbZaNazMHDLCD","odbav.zař.|název  MHD,LCD","T")
	s arr(39)=$lb("typ","typ","T")
	s arr(40)=$lb("cisloUzlu","číslo uzlu| v Ropidu","N")
}

ClassMethod DBDoGLB(ByRef sys As %String, zastavkaId As %String, dGlb As %String)
{
	//zapise data zastavky do pracovniho globalu
	//zastavkaId = id/cislo zastavky
	//dGlb = global, kam se zapisou data zastavky tak, jak jsou ulozeny v databazi
	//
	//@dGlb=data zastavky tak, jak jsou ulozeny v databazi
	//@dGlb@("Sloupek",...)= data oznacniku, tak jak jsou ulozeny v databazi 
	$$$FillParams
	//
	s zastavkaId=$g(zastavkaId) s dGlb=$g(dGlb)
	i (dGlb'="") {
		k @dGlb
		i (zastavkaId) {
			s @dGlb=$g(^[dataDB]JRZ(zastavkaId))
			m @dGlb@("Sloupek")=^[dataDB]JRZ(zastavkaId,"Sloupek")
			m @dGlb@("CasoveVariantyUdaju")=^[dataDB]JRZ(zastavkaId,"CasoveVariantyUdaju")
		}
	}
}

ClassMethod GLBDoDB(ByRef sys As %String, ByRef zastavkaId As %String, dGlb As %String)
{
	//ulozi data zastavky z pracovniho globalu do databaze
	//zastavkaId = id/cislo zastavky, je-li prazdne, pak se prideli a vrati se
	//dGlb = global, kde jsou data zastavky tak, jak jsou ulozeny v databazi
	//@dGlb=data zastavky tak, jak jsou ulozeny v databazi
	//@dGlb@("Sloupek",...)= data oznacniku, tak jak jsou ulozeny v databazi 
	//
	$$$FillParams
	s zastavkaId=$g(zastavkaId) s dGlb=$g(dGlb)
	//odstraneni indexu
	i +zastavkaId {d ..obnovIndex(.sys,zastavkaId,0)}
	//pokud neni zastavkaId, tak si pridelim nove
	i 'zastavkaId {
		k arr s arr("PAR","jakHledat")=1 d ..noveID(.sys,.zastavkaId,.arr) k arr
	}
	//zapis dat do databaze
	s ^[dataDB]JRZ(zastavkaId)=$g(@dGlb)
	k ^[dataDB]JRZ(zastavkaId,"Sloupek")
	m ^[dataDB]JRZ(zastavkaId,"Sloupek")=@dGlb@("Sloupek")
	m ^[dataDB]JRZ(zastavkaId,"CasoveVariantyUdaju")=@dGlb@("CasoveVariantyUdaju")
	//zapis do indexu
	d ..obnovIndex(.sys,zastavkaId,1)
}

ClassMethod nacti(ByRef sys As %String, zastavkaId As %String, dGlb As %String, ByRef arr As %String)
{
	//	vrati data zastavky
	//	IN
	//	
	//	zastavkaId = id/cislo zastavky
	//	nebo dGlb = global, kde jsou data zastavky tak, jak jsou ulozeny v databazi, pak se data nacitaji z nej
	//	arr("PAR","zdrojDat")   AD = 0, MHD = 1
	//	
	//	OUT
	//
	//	arr("DTA")=$lb(dta,dta,...) / popis v popis
	$$$FillParams

	s zastavkaId=$g(zastavkaId) s dGlb=$g(dGlb)
	//neni-li datovy global a je-li zastavkaId, pak nacitam data z databaze
	i (dGlb="")&(zastavkaId'="") {s dGlb=$name(^[dataDB]JRZ(zastavkaId))}
	s zdrojDat = $g(arr("PAR","zdrojDat"))
	i zdrojDat = 1 {
		s $li(val,1)=$g(^[dataDB]ALVA.MHD.ZST(IdFa,1,"DTA",zastavkaId,"DTA",1,"ModelZastavkaCIS",1,"Val","NazevObce"))
 		s $li(val,2)=$g(^[dataDB]ALVA.MHD.ZST(IdFa,1,"DTA",zastavkaId,"DTA",1,"ModelZastavkaCIS",1,"Val","CastObce"))
 		s $li(val,3)=$g(^[dataDB]ALVA.MHD.ZST(IdFa,1,"DTA",zastavkaId,"DTA",1,"ModelZastavkaNazvy",1,"Val","Nazev"))
		s $li(val,4)=$g(^[dataDB]ALVA.MHD.ZST(IdFa,1,"DTA",zastavkaId,"DTA",1,"ModelZastavkaCIS",1,"Val","BlizkaObec"))
		s $li(val,5)=""
		s $li(val,6)= ""
		s attribs = "" s attribId = "" f {
			s attribId = $o(^[dataDB]ALVA.MHD.ZST(IdFa,1,"DTA",zastavkaId,"DTA",1,"Atributy",attribId)) i attribId = "" q
			s $list(attribs,*+1) = $g(^[dataDB]ALVA.MHD.ZST(IdFa,1,"DTA",zastavkaId,"DTA",1,"Atributy",attribId,"Itm"))
		}
		s $li(val,7)= attribs
		s $li(val,8)= ""
		s $li(val,9)= ""
		s $li(val,10)= ""
		s $li(val,11)= ""
		s $li(val,12)= ""
		s $li(val,13)= $g(^[dataDB]ALVA.MHD.ZST(IdFa,1,"DTA",zastavkaId,"DTA",1,"Name"))
		s $li(val,14)= $g(^[dataDB]ALVA.MHD.ZST(IdFa,1,"DTA",zastavkaId,"DTA",1,"Cislo"))_"/"_$g(^[dataDB]ALVA.MHD.ZST(IdFa,1,"DTA",zastavkaId,"DTA",1,"Oznacnik"))
		s $li(val,15)= ""
		s $li(val,16)= ""
		s $li(val,17)= ""
		s $li(val,18)= ""
		s $li(val,19)= $g(^[dataDB]ALVA.MHD.ZST(IdFa,1,"DTA",zastavkaId,"DTA",1,"GPSLatitude"))
		s $li(val,20)= $g(^[dataDB]ALVA.MHD.ZST(IdFa,1,"DTA",zastavkaId,"DTA",1,"GPSLongitude"))
		s $li(val,21)= ""
		s $li(val,22)= ""
		s $li(val,23)= ""
		s $li(val,24)= ""
		s $li(val,25)= ""
		s $li(val,26)= ""
		s $li(val,27)= ""
		s $li(val,28)= ""
		s $li(val,29)= ""
		s $li(val,30)= ""
		s $li(val,31)= ""
		s $li(val,32)= ""
		s $li(val,33)= ""
		s $li(val,34)= ""
		s $li(val,35)= ""
		s $li(val,36)= ""
		s $li(val,37)= ""
		s $li(val,38)= ""
		s $li(val,39)= ""
		s $li(val,40)= ""
		s arr("DTA")=val
		ret
	}
	
	s valDB="" s val=""
	s valDB=$g(@dGlb)		
	//korekce novych hodnot zastavek
	i ($p(valDB,"$",26)="") s $p(valDB,"$",26)="O"						//oficialni zastavka
	//nazev pro autobusovou zastávku
	i '$p(valDB,"$",17) {
		s $li(val,1)=$p($p(valDB,"$",2),",",1)
 		s $li(val,2)=$p($p(valDB,"$",2),",",2)
 		s $li(val,3)=$p($p(valDB,"$",2),",",3)
	}
	//nazev vlakovou zastavku - jen jeden text, nerozdeluje se na casti
 	i +$p(valDB,"$",17) {
		s $li(val,1)=$p(valDB,"$",2)
		s $li(val,2)=""
		s $li(val,3)="" 
 	}
 	s $li(val,4)=$p(valDB,"$",3)
 	s $li(val,5)=$p(valDB,"$",4)
 	s $li(val,6)=$p(valDB,"$",6)
 	s $li(val,7)=$lfs($p(valDB,"$",8),",")
 	s $li(val,8)=+$p(valDB,"$",10)
 	s $li(val,9)=$p($p(valDB,"$",5),"~",1)
 	s $li(val,10)=$p($p(valDB,"$",5),"~",2)
 	s $li(val,11)=$p($p(valDB,"$",5),"~",3)
 	s $li(val,12)=$p($p(valDB,"$",5),"~",4)
 	s $li(val,13)=$p(valDB,"$",7)
 	s $li(val,14)=$p(valDB,"$",9)
 	s $li(val,15)=$p($p(valDB,"$",11),"~",1)
 	s $li(val,16)=+$p($p(valDB,"$",11),"~",2)
 	s $li(val,17)=$lfs($p($p(valDB,"$",11),"~",3),";")
 	s $li(val,18)=$p($p(valDB,"$",5),"~",5)
 	s $li(val,19)=$p(valDB,"$",12)
 	s $li(val,20)=$p(valDB,"$",13)
 	s $li(val,21)=$p(valDB,"$",14)
 	s $li(val,22)=$p(valDB,"$",15)
 	s $li(val,23)=$p(valDB,"$",16)
 	s $li(val,24)=$p($p(valDB,"$",5),"~",6)
 	s $li(val,25)=$p($p(valDB,"$",5),"~",7)
 	s $li(val,26)=$p(valDB,"$",17)
 	s $li(val,27)=$p(valDB,"$",18)
 	s $li(val,28)=$p(valDB,"$",19)
 	s $li(val,29)=$p($p(valDB,"$",5),"~",8)
 	s $li(val,30)=$p(valDB,"$",20)
 	s $li(val,31)=$lfs($p(valDB,"$",21),";")
 	s $li(val,32)=$p($p(valDB,"$",5),"~",9)
 	s $li(val,33)=$p($p(valDB,"$",5),"~",10)
 	s $li(val,34)=$p(valDB,"$",22)
 	s $li(val,35)=$p($p(valDB,"$",5),"~",11)
 	s $li(val,36)=$p(valDB,"$",23)
 	s $li(val,37)=$p(valDB,"$",24)
 	s $li(val,38)=$p(valDB,"$",25)
 	s $li(val,39)=$p(valDB,"$",26) 
 	s $li(val,40)=$p(valDB,"$",27) 
 	s arr("DTA")=val
}

ClassMethod uloz(ByRef sys As %String, ByRef zastavkaId As %String, dGlb As %String, ByRef arr As %String)
{
	//zapise data zastavky do databaze
	//IN
	//zastavkaId = id/cislo zastavky, je-li prazdne a zapisuje-li se do db (na do globalu), pak se prideli a vrati se
	//nebo dGlb = global, kde jsou data zastavky tak, jak jsou ulozeny v databazi, pak se data zapisuji do nej
	//arr("DTA")=$lb(dta,dta,...)  / data zastavky, popis v popis
	//OUT
	//
	$$$FillParams
	s zastavkaId=$g(zastavkaId) s dGlb=$g(dGlb)
	//priprava dat
	s val=$g(arr("DTA"))
	//uprava nazvu pro pro autobusovou a vlakovou zastávku
	s nazev=""
	f cnt=1:1:3 {
		i $lg(val,cnt)'="" {
			//autobusova
			i '$lg(val,26) {
				s $p(nazev,",",cnt)=$lg(val,cnt)
			}
			//vlakova, jeden text, nerozdeluje se podle ,
			i +$lg(val,26) {
				i nazev'="" s nazev=nazev_","
				s nazev=nazev_$lg(val,cnt)
			}	
		}	
	}	
	//pokud neni cislo dle registru, zkusim ho dohledat
	i '$lg(val,14) {
		s zastavkaCRZId="" k arrCRZ s arrCRZ("DTA")=$lb($lg(val,1),$lg(val,2),$lg(val,3),$lg(val,4))
		d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyCRZ).vyhledejIdPodleNazvu(.sys,.zastavkaCRZId,.arrCRZ)
		s $li(val,14)=$g(zastavkaCRZId)
	}
	s valDB=""
 	s $p(valDB,"$",1)=$ZCONVERT(##class(ALVA.GENERALAPI.String).HackyACarkyFuc(nazev),"U")
 	s $p(valDB,"$",2)=nazev
 	s $p(valDB,"$",3)=$lg(val,4)
 	s $p(valDB,"$",4)=$lg(val,5)
 	s partVal=""
 	s $p(partVal,"~",1)=$lg(val,9)
 	s $p(partVal,"~",2)=$lg(val,10)
 	s $p(partVal,"~",3)=$lg(val,11)
 	s $p(partVal,"~",4)=$lg(val,12)
 	s $p(partVal,"~",5)=$lg(val,18)
 	s $p(partVal,"~",6)=$lg(val,24)
 	s $p(partVal,"~",7)=$lg(val,25)
 	s $p(partVal,"~",8)=$lg(val,29)
 	s $p(partVal,"~",9)=$lg(val,32)
 	s $p(partVal,"~",10)=$lg(val,33)
 	s $p(partVal,"~",11)=$lg(val,35)
 	s $p(valDB,"$",5)=partVal
 	s $p(valDB,"$",6)=$lg(val,6)
 	s $p(valDB,"$",7)=$lg(val,13)
 	s $p(valDB,"$",8)=$lts($lg(val,7),",")
 	s $p(valDB,"$",9)=$lg(val,14)
 	s $p(valDB,"$",10)=$lg(val,8)
 	s partVal=""
 	s $p(partVal,"~",1)=$lg(val,15)
 	s $p(partVal,"~",2)=$lg(val,16)
 	s $p(partVal,"~",3)=$lts($lg(val,17),";")
 	s $p(valDB,"$",11)=partVal
 	s $p(valDB,"$",12)=$lg(val,19)
 	s $p(valDB,"$",13)=$lg(val,20)
 	s $p(valDB,"$",14)=$lg(val,21)
 	s $p(valDB,"$",15)=$lg(val,22)
 	s $p(valDB,"$",16)=$lg(val,23)
 	s $p(valDB,"$",17)=$lg(val,26)
	s $p(valDB,"$",18)=$lg(val,27)
	s $p(valDB,"$",19)=$lg(val,28)
	s $p(valDB,"$",20)=$lg(val,30)
	s $p(valDB,"$",21)=$lts($lg(val,31),";")
	s $p(valDB,"$",22)=$lg(val,34)
	s $p(valDB,"$",23)=$lg(val,36)
	s $p(valDB,"$",24)=$lg(val,37)
	s $p(valDB,"$",25)=$lg(val,38)
	s $p(valDB,"$",26)=$lg(val,39)
	s $p(valDB,"$",27)=$lg(val,40)
	//zapis do pomocneho datoveho globalu, prijde-li
	i (dGlb'="") {s @dGlb=valDB}
	//zapis primo do databaze, pomocny datovy global neni definovan
	else {
		//odstraneni indexu
		i +zastavkaId {d ..obnovIndex(.sys,zastavkaId,0)}
		//pokud neni zastavkaId, tak si pridelim nove
		i 'zastavkaId { k arr s arr("PAR","jakHledat")=1 d ..noveID(.sys,.zastavkaId,.arr) k arr }
		//zapis dat do databaze
		s ^[dataDB]JRZ(zastavkaId)=valDB
		//zapis do indexu
		d ..obnovIndex(.sys,zastavkaId,1)	
	}
}

ClassMethod vymaz(ByRef sys As %String, zastavkaId As %String, ByRef arr As %String)
{
	//vymaze data zastavky z databaze, zapise ji do kose
	//IN
	//zastavkaId = id/cislo zastavky
	//OUT
	//
	$$$FillParams
	s zastavkaId=$g(zastavkaId)
	i zastavkaId {
		//vymazu ji v seznamu
		d ..obnovIndex(.sys,zastavkaId,0)
		//zapisu ji do kose
		//zrusim ji
		k ^[dataDB]JRZ(zastavkaId)
		// zruseni zastavky - rozpis
 		s skupinaId="" f {
	 		s skupinaId=$o(^[dataDB]JRSET("Definice","ZastavkyRozpis",skupinaId)) i skupinaId="" q
 				k ^[dataDB]JRSET("Definice","ZastavkyRozpis",skupinaId,zastavkaId)
 		}
		// zruseni v tabulce vzdalenosti - postaru - volam stare api
 		s err=$$dZstTabVzd^JRapi(IdFa,dataDB,zastavkaId,"","") 
 		//
		//sherlok, dodelat !!!
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
	i +$g(zastavkaId) {s arr("STT")=($d(^[dataDB]JRZ(zastavkaId))>0)}
}

ClassMethod seznam(ByRef sys As %String, ByRef arr As %String)
{
	//vrati seznam zastavek podle vstupniho parametru
	//IN
	//arr("GLB")=global pro vystupni seznam zastavek
	//arr("PAR","hledanyText")=zadany hledany text, vice udaju oddenych ";"
	//arr("PAR","blizkaObecLstId")=$lb(blizkaObecId,blizkaObecId,...)
	//arr("PAR","zonaIDSLstId")=$lb(zonaIDSId,zonaIDSId,...)
	//arr("PAR","skupinaLstId")=$lb(skupinaId,skupinaId,...)
	//arr("PAR","typ")= 0 vse / 1 lokalni / 2 oficialni
	//arr("PAR","druh")= 0 vse / 1 autobusove / 2 vlakove
	//arr("PAR","provozuje")=zadany provozovatel - text
	//arr("PAR","pouzite")=0 vse / 1 pouzite na linkach / 2 nepouzite na linkach
	//arr("PAR","rozdilCRZ")=0 vse / 1 rozdil v nazvu s CRZ
	//arr("PAR","linkyId") = $lb(linkaId,linkaId,...)
	//arr("PAR","maxPocet") = maximalni pocet zastavek k vraceni
	//OUT
	//arr("DTA",zastavkaId)="" zastavkaId nebo @arr("GLB")@("DTA",zastavkaId )=""
	//arr("IDX",abcidx)=zastavkaId nebo @arr("GLB")@("IDX",abcidx)=zastavkaId 
	#; $$$FillParams
	k ^jmTest s ^jmTest("tady")=""
	$$$TMPGLBSET(glbDta)
	$$$TMPGLBSET(glbLst)
	s glb=$g(arr("GLB"))
	s hledanyText=$g(arr("PAR","hledanyText"))
	i hledanyText = "" s hledanyText = "*" // prazdne vyhledavani se bude chovat stejne jako vyhledavani vseho
	k hledanyTextArr
	f cnt=1:1:$l(hledanyText,";") {
		s txt=$p(hledanyText,";",cnt) i txt'="" s hledanyTextArr(txt)=$ZCONVERT(##class(ALVA.GENERALAPI.String).HackyACarkyFuc(txt),"U")
	}
	//zastavky pouze ze skupin
	s skupinaLstId=$g(arr("PAR","skupinaLstId"))
	i skupinaLstId'="" {
		k arrDta s arrDta("GLB")=$name(@glbLst@(1)) s arrDta("PAR","linkyId") = $g(arr("PAR","linkyId"))
		d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).zastavkyZeSkupiny(.sys,skupinaLstId,.arrDta)
		s @glbLst@(1)=""
		k arrDta
	}
	//pouzite zastavky
	i +$g(arr("PAR","pouzite")) {
		k arrDta s arrDta("GLB")=$name(@glbLst@(2))
		d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).pouziteZastavky(.sys,.arrDta)
		s @glbLst@(2)=""
		k arrDta
	}
	s ctr=0
	i hledanyText'="" {
		s zastavkaId="" f {
			s valDB="" s zastavkaId=$o(^[dataDB]JRZ(zastavkaId),1,valDB) i zastavkaId="" q
			s nazevU=$p(valDB,"$",1) s nazev=$p(valDB,"$",2) s blizkaObec=$p(valDB,"$",3)
			s provozuje=$p(valDB,"$",4) s zastavkaCRZId=$p(valDB,"$",9)
			s vlakova=+$p(valDB,"$",17) s typ=$p(valDB,"$",26) 
			//test na zastavky ze skupiny
			i ($d(@glbLst@(1))&('$d(@glbLst@(1,"DTA",zastavkaId)))) continue
			//test na pouzite zastavky
			i $g(arr("PAR","pouzite"))=1 i '$d(@glbLst@(2,"DTA",zastavkaId)) continue
			//test na nepouzite zastavky
			i $g(arr("PAR","pouzite"))=2 i +$d(@glbLst@(2,"DTA",zastavkaId)) continue
			k arrZonaIDSId
			i $g(arr("PAR","zonaIDSLstId"))'="" {
				//zony do pole
				s zonaIDSId=$p($p(valDB,"$",11),"~",1) i zonaIDSId'="" s arrZonaIDSId(zonaIDSId)=""
				s val=$p($p(valDB,"$",11),"~",3) f idx=1:1:$l(val,";") s zonaIDSId=$p(val,";",idx) i zonaIDSId'="" s arrZonaIDSId(zonaIDSId)=""
 				s zonaIDSId=$p(valDB,"$",20) i zonaIDSId'="" s arrZonaIDSId(zonaIDSId)=""
 				s val=$p(valDB,"$",21) f idx=1:1:$l(val,";") s zonaIDSId=$p(val,";",idx) i zonaIDSId'="" s arrZonaIDSId(zonaIDSId)=""
			}
			s vyhovuje=0
			i hledanyText="*" {
				s vyhovuje=1
			}
			elseif $d(hledanyTextArr(zastavkaId)) {
				s vyhovuje=1
			}
			elseif (zastavkaCRZId'="")&&$d(hledanyTextArr(zastavkaCRZId)) {
				s vyhovuje=1
			}
			else {
				s txt="" f {
					s txtU="" s txt=$o(hledanyTextArr(txt),1,txtU) i (txt="")!(vyhovuje) q
					i nazevU[txtU s vyhovuje=1
				}
			}
			//blizke obce
			i vyhovuje {
				i $g(arr("PAR","blizkaObecLstId"))'="" {
					i '$lf($g(arr("PAR","blizkaObecLstId")),blizkaObec) s vyhovuje=0
				}
			}
			//zony IDS
			i vyhovuje {
				i $g(arr("PAR","zonaIDSLstId"))'="" {
					s vyhovujeZonaIDSId=0
					s zonaIDSId="" f {
						s zonaIDSId=$o(arrZonaIDSId(zonaIDSId)) i (zonaIDSId="")!(vyhovujeZonaIDSId) q
						i $lf($g(arr("PAR","zonaIDSLstId")),zonaIDSId) s vyhovujeZonaIDSId=1
					}
					s vyhovuje=vyhovujeZonaIDSId
				}
			}
			//lokalni/oficialni
			i vyhovuje {
				//1 lokalni
				i $g(arr("PAR","typ"))=1 {i (typ="O")!(typ="") s vyhovuje=0}
				//2 oficialni
				i $g(arr("PAR","typ"))=2 {i typ="L" s vyhovuje=0}
			}
			//autobusova/vlakova
			i vyhovuje {
				//1 autobusove
				i $g(arr("PAR","druh"))=1 {i vlakova s vyhovuje=0}
				//2 vlakove
				i $g(arr("PAR","druh"))=2 {i 'vlakova s vyhovuje=0}
			}
			//provozuje
			i vyhovuje {
				i $g(arr("PAR","provozuje"))'="" {
					i (provozuje'=arr("PAR","provozuje")) {s vyhovuje=0}
				}
			}
			//rozdil proti CRZ
			i vyhovuje {
				i $g(arr("PAR","rozdilCRZ")) {
					//u vlakovych nekontroluju
					i vlakova s vyhovuje=0
					//u lokalnich nekontroluju
					i typ="L" s vyhovuje=0
					//je cislo dle cis ?
					i ('zastavkaCRZId) s vyhovuje=0
					i (vyhovuje) {
						s valCRZDB=$g(^[dataDB]JRCRZ("ZA",zastavkaCRZId))
						s text1=($p(nazev,",",1)_$p(nazev,",",2)_$p(nazev,",",3)_blizkaObec)
						s text2=($p(valCRZDB,"~",1)_$p(valCRZDB,"~",2)_$p(valCRZDB,"~",3)_$p(valCRZDB,"~",4))
						i text1=text2 {s vyhovuje=0}
					}
				}
			}
			i vyhovuje {
				s ctr=$i(ctr)
				i $g(arr("PAR","maxPocet")),ctr>arr("PAR","maxPocet") q
				
				s abcidx=##class(ALVA.GENERALAPI.String).gSortTxt(nazev_"$"_blizkaObec_"$"_(+zastavkaId))
				k arrDta d ..nacti(.sys,zastavkaId,"",.arrDta)
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
	k @glbDta
	k @glbLst
}

ClassMethod noveID(ByRef sys As %String, ByRef zastavkaId As %String, ByRef arr As %String)
{
	//vrati volne ID/cislo pro zastavku
	//IN
	//arr("PAR","jakHledat")=0 od pocatku / 1 od posledniho
	//OUT
	//zastavkaId = nove zastavkaId
	$$$FillParams
	k arr("ID")
	s jakHledat=$g(arr("PAR","jakHledat"))
	s minId=1
	i jakHledat {
		s minId=($o(^[dataDB]JRZ(""),-1))
		i 'minId s minId=1
	}
	//nastavene minimalni cislo pro pridelovani cisla zastavky
	i (+$g(^[dataDB]JRSET("Definice","ZST","CIS")))&(minId<+$g(^[dataDB]JRSET("Definice","ZST","CIS"))) s minId=+$g(^[dataDB]JRSET("Definice","ZST","CIS"))
 	f zastavkaId=minId:1 i '$d(^[dataDB]JRZ(zastavkaId)) q
}

ClassMethod obnovIndex(ByRef sys As %String, zastavkaId As %String, par As %String)
{
	//obsluha indexoveho globalu
	//stary JR mely global JRSEZ, ten se aktualne nepouziva, bude-li potreba, pak udelat nove
	$$$FillParams
	i $d(^[dataDB]JRZ(zastavkaId)) {
		s val=$g(^[dataDB]JRZ(zastavkaId))
		s nazev=$p(val,"$",2) s blizkaObec=$p(val,"$",3)
		//zapis indexu
		i +par {
			s idx=$ZCONVERT(##class(ALVA.GENERALAPI.String).HackyACarkyFuc(nazev),"U")_"$"_blizkaObec_"$"_(+zastavkaId)
			s ^[dataDB]JRSEZ("NAZ",idx)=zastavkaId
			s idx=##class(ALVA.GENERALAPI.String).gSortTxt(nazev_"$"_blizkaObec_"$"_(+zastavkaId))
 			s ^[dataDB]JRSEZ("DINAZ",idx)=zastavkaId
		}
		//vymazani indexu
		i 'par {
			s idx=$ZCONVERT(##class(ALVA.GENERALAPI.String).HackyACarkyFuc(nazev),"U")_"$"_blizkaObec_"$"_(+zastavkaId)
			k ^[dataDB]JRSEZ("NAZ",idx)
			s idx=##class(ALVA.GENERALAPI.String).gSortTxt(nazev_"$"_blizkaObec_"$"_(+zastavkaId))
 			k ^[dataDB]JRSEZ("DINAZ",idx)
		}
	}
}

}
