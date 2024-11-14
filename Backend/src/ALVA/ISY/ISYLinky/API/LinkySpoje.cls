Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYLinky.API.LinkySpoje Extends %RegisteredObject
{

ClassMethod test()
{
	//d ##class(ALVA.ISY.ISYLinky.API.LinkySpoje).test()
	s sys("U","IdFa")="CK_SCHWAN"
	s sys("U","delimiter")=$c(0)
	s sys("U","SystemDB")="MLINE"
	s sys("C","User")=007
	s sys("U","DATA")="USER"
	s sys("U","MLP")=7
	s sys("U","fullName")="007"
	s sys("U","loginName")="007"
	s sys("C","GUID")=7
	// $lb(skupinaId,aplId,linkaId,smerId,spojId)
	#; k arr d ..nacti(.sys,$lb(9,"",060605,0,51),"",.arr) //w ! zw arr
	#; d ..uloz(.sys,$lb(9,"",823130,0,3),"",.arr)
	#; k arr d ..seznam(.sys,$lb(6,"","0230009"),"",.arr) zw arr
	k arr d ..nacti(.sys,$lb(6,"","0230009",0,3),"",.arr) w ! zw arr k ^jm m ^jm = arr
}

ClassMethod popis()
{
	// zakladni udaje spoje
	// arr("DTA")=$lb(dta,dta,...)
	// 01 bodOdId
	// 02 bodDoId
	// 03 trasaId (odkaz na trasu spoje)
	// 04 odjezdCas  (cas odjezdu v min)
	// 05 dobaJizdy  (doba jizdy v min)
	// 06 mistenkovani (R)
	// 07 tydenniPlatnostLstId $lb(tydenniPlatnostId,tydenniPlatnostId,...) (1234567X+)
	// 08 dlouhodobaPlatnostId
	// 09 typBus
	// 10 cisloSpojeSdileny
	// 11 dopravceIdSdileny $lb(firmaId,provozId)
	// 12 mistenkovaniTyp - 1 nutno, 2 mozno AMS, 3 nutno AMS
	// 13 postovniPreprava (0/1)
	// 14 povolenaVnitrostatniDoprava (pro mezinarodni linky 0/1)
	// 15 ids (0/1)
	// 16 bezbarierovePristupneVozidlo (0/1)
	// 17 samoobsluznySystemOdbaveni (0/1)
	// 18 prepravujeCestovniZavazadla (0/1)
	// 19 obcerstveni (0/1)
	// 20 prepravujeJizdniKola (0/1)
	// 21 nizkokapacitniAutobus (0/1)
	// 22 dopravceHlavni $lb(firmaId,provozId)
	// 23 dopravceDalsi  $lb(firmaId,provozId)
	// 24 dopravceDalsiAlternativni (0/1)
	// 25 zdrojLinkaSpoj (pro souhrn) $lb(linkaIndex,spojCislo)  - indexLinky !!!
	// 26 vzdalenost - presna vzdalenost spoje [m]
	// 27 uzamceno	- uzamceny spoj pro editaci (0/1)
	// 28 prepravniSystem (prepravni system pro cely spoj)
	// 29 negativniZnacka
	// 30 radiobus/jede na objednani (0/1)
	// 31 oznaceniVlakovehoSpoje
	// 32 SSAId seznam skupin akci
	// 33 castecneBezbarierovePristupneVozidlo (0/1)
	// 34 jedePodminecne (0/1)
	// 35 posilovySpoj (0/1)
	// 36 textRadiobus/jede na objednani
	// 37 textJedePodminecne
	// 38 barva spoje, format: rrr;ggg;bbb
	// 39 tabloId - pro TELMAX
	// 40 linkaDruhId - typSpojeADId (je-li odlisny od typu linky)
	// 41 vychoziDopravniSystemId (ME)
	// 42 vychoziDopravniSystemProISId (ME)
	// 43 cisloLinkyIDS
	// 44 dopravceDalsi1  $lb(firmaId,provozId)
	// 45 dopravceDalsi1Alternativni (0/1)
	// 46 bezdratovePripojeniKInternetu (0/1)
	// 47 pripojka230V (0/1)
	// 48 dopravceDalsi2 $lb(firmaId,provozId)
	// 49 dopravceDalsi2Alternativni (0/1)
	// 50 dopravceDalsi3 $lb(firmaId,provozId)
	// 51 dopravceDalsi3Alternativni (0/1)
	// 52 navaznySpoje (ME) (0/1)
	// 53 kategorieAutobusu (ciselnik vozidla)
	// 54 rozvrhPasemJizdniDobyId - odkaz na ciselnik ISY
	// 55 nazev spoje pro Mikroelektroniku
	//
	// trasa spoje:
	// arr("DTA","trasa",bodId)=$lb(dta,dta,...)
	// 01 casPrijezdu 			 [min]
	// 02 ceka		   			 [min]			
	// 03 vzdalenostTarifni 	 [m]
	// 04 vzdalenostPresna		 [m]
	// 05 atribut                $lb(atribut,atribut,...)    
	//                               (N-nastup,
	//                                V-vystup,
	//                                x-na znameni,
	//                                G-paragraf,
	//                                a-paragraf 1,
	//                                b-paragraf 2,
	//                                c-paragraf 3,
	//                                P-prov.preruseni,
	//                                Z-detekovat zónu při průjezdu
	//                                K-kontrolni bod,
	//                                r-zastavku obsluhuje na objednani,
	//                                j-zastavku obsluhuje podminecne)
	//               		          X-stridani ridicu
	//                          	  E-nacestna zastavka
	//                          	  e-Metro A
	//                          	  f-Metro B
	//                          	  g-Metro C
	//                          	  h-Metro D
	//                          	  O-letadlo
	//                          	  D-lod
	//                          	  L-vlak
	//                          	  H-cilova zastavka pro tablo  
	// 06 uzamceno                    (0/1 uzamceny cas)
	// 07 nastupiste
	// 08 tarZona                     $lb(tarZonaId,tarZonaId,...)
	// 09 zajizdka1              	  (0/1 ne/ano)
	// 10 odbZaVzdalenostTarifni [m]
	// 11 zajizdka2              	  (0/1 ne/ano)
	// 12 vzdalenostZajizdka     [m]  celkove km zajizdky, zadava se do posledniho tc zajizdky
	// 13 oznacnikId                  (sloupek zastávky)
	// 14 DSInfoSysME                 (dopravni system pro informační systém Mikroelektroniky)
	// 15 PovelBUSE                   (povel pro informační systém BUSE)
	// 
	// datumova omezeni spoje
	//
	// arr("DTA","datumoveOmezeni",omezeniId)=$lb(znakOmezeni)
	// omezeniId = 11 / jede jen ,12 / jede take ,13 /jede ,14 / jede v sudych tydnech ,15 / jede v lichych tydnech ,22 / nejede 
	// arr("DTA","datumoveOmezeni",omezeniId,hrlOd)=$lb(hrlDo)
	//
	// prepravni system
	//
	// arr("DTA","prepravniSystem",prsId)=$lb(vzdalenost)           
	// 1 vzdalenost [m]
	//
	// navaznosti
	//
	// arr("DTA","navaznost",navaznostId,idx)=$lb(...,...,...)
	//
	// omezeniId=31 / vycka
	//
	// 01 bodId
	// 02 vyckaCasMin			... delka cekani v bodu
	// 03 autobusVlakLod		...	ceka na A/V/L
	// 04 linkaCislo			... cislo linky
	// 05 spojCislo				... cislo spoje
	// 06 smerOd				... smer spoje od
	// 07 smerDo				... smer spoje do
	// 08 dopravce				... dopravce spoje textove
	// 09 prijezdMin			... cas prijezdu do bodu
	// 10 typVystupuId			...	0 tiskJR / 1 tiskJR+exp.odbav.zar. / 2 exp.odbav.zar.
	// 11 typZobrazeniId		... 0 znackou u spoje / 1 pripojny radek / 2 znackou u spoje + pripojny radek
	// 12 autobusVlakLodTisk	...	ceka na A/V/L - oznaceni A/V/L pro tisk
	//
	// omezeniId=32 / navazuje
	//
	// 01 bodId
	// 02 autobusVlakLod		...	navazuje A/V/L
	// 03 linkaCislo			... cislo linky
	// 04 spojCislo				... cislo spoje
	// 05 smerOd				... smer spoje od
	// 06 smerDo				... smer spoje do
	// 07 dopravce				... dopravce spoje textove
	// 08 odjezdMin				... cas odjezdu z bodu
	// 09 typVystupuId			...	0 tiskJR / 1 tiskJR+exp.odbav.zar. / 2 exp.odbav.zar.
	// 10 typZobrazeniId		... 0 znackou u spoje / 1 pripojny radek / 2 znackou u spoje + pripojny radek
	// 11 zobrazitTablo  		... 0 ne / 1 ano
	// 12 preferujeCsad			... 0 ne / 1 ano
	// 13 scitatCenu			... 0 ne / 1 ano
	// 14 autobusVlakLodTisk	...	navazuje na A/V/L - oznaceni A/V/L pro tisk
	//
	//omezeniId=34 / pokracuje
	//
	// 01 linkaCislo		... cislo linky
	// 02 spojCislo			... cislo spoje
	// 03 smerDo			... smer spoje do
	// 04 odjezdMin			... cas odjezdu navazujiciho bodu
	// 05 typVystupuId		...	0 tiskJR / 1 tiskJR+exp.odbav.zar. / 2 exp.odbav.zar.
	// 06 proVypocetRelaci	...	0 ne / 1 ano
	//
	// poznamka pro odbavovaci zarizeni
	//
	// arr("DTA","poznamkaOdbavovaciZarizeni",bodId)=$lb(poznamkaText)
	// 01 poznamkaTest
	//
	// technicka pauza
	//
	// arr("DTA","technickaPauza",minutPo)=$lb(minut)
	// 01 minut
	//
	//silnice
	//
	// arr("DTA","silnice",cnt)=$lb(silniceId,dotovatelId,vzdalenost)
	// 01 silniceId
	// 02 dotovatelId
	// 03 vzdalenost
	//
	//atributy omezeni
	//
	// arr("DTA","atributyOmezeni",atributOmezeniId,cnt)=$lb(...,...,...)
	// atributOmezeniId=15 - bezbarierova pristupne vozidlo
	// 01 horlogDo
	// 02 horlogDo
	// atributOmezeniId=19 - preprava jizdnich kol
	// 01 horlogOd
	// 02 horlogDo
	// 03 pocet
}

ClassMethod nacti(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//vrati data spoje
	//IN
	//id = $lb(skupinaId,aplId,linkaId,smerId,spojId)
	//smerId= 0 tam / 1 zpet
	//nebo dGlb = global, kde jsou data linky tak, jak jsou ulozeny v databazi, pak se data nacitaji z nej
	//OUT
	//arr("DTA",...)=$lb(dta,dta,...) / popis v popis
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb)
	s skupinaId=$lg(id,1) s aplId=$lg(id,2) s linkaId=$lg(id,3) s smerId=$lg(id,4) s spojId=$lg(id,5)
	i linkaId'="" s linkaId=##class(ALVA.ISY.ISYLinky.API.LinkyFce).cisloLinkyDoIndexu(linkaId)
	//neni-li datovy global a je-li zastavkaId, pak nacitam data z databaze
	i (dGlb="")&(skupinaId) {s dGlb=$name(^[dataDB]JRL(skupinaId,linkaId))}
	i (dGlb="")&(aplId) {s dGlb=$name(^[dataDB]JRAPL(linkaId,aplId,"arr"))}
	s valDB="" s val=""
	s smerIdx=$e("TZ",smerId+1)
	s valDB=$g(@dGlb@(smerIdx,spojId))
	s val=""
	s $li(val,1)=$p($p(valDB,"#",1),":",1)
	s $li(val,2)=$p($p(valDB,"#",1),":",2)
	s trasaId=$p($p(valDB,"#",1),":",3) s $li(val,3)=trasaId
	s odjezdCas=$p($p(valDB,"#",1),":",4) s $li(val,4)=odjezdCas
	s $li(val,5)=$p($p(valDB,"#",1),":",5)
	s $li(val,6)=$p($p(valDB,"#",1),":",6)
	s valTmp=$p($p(valDB,"#",1),":",7) s valLst="" f cnt=1:1:$l(valTmp) s $li(valLst,($ll(valLst)+1))=$e(valTmp,cnt)
	s $li(val,7)=valLst
	s $li(val,8)=$p($p(valDB,"#",1),":",8)
	s $li(val,9)=$p($p(valDB,"#",1),":",9)
	s $li(val,10)=$p($p($p(valDB,"#",1),":",10),"$",1)
	s $li(val,11)=$lfs($p($p($p(valDB,"#",1),":",10),"$",2),"/")
	s $li(val,12)=+$p($p(valDB,"#",1),":",11)
	s $li(val,13)=+$p($p(valDB,"#",1),":",12)
	s $li(val,14)=+$p($p(valDB,"#",1),":",13)
	s $li(val,15)=+$p($p(valDB,"#",1),":",14)
	s $li(val,16)=+$p($p(valDB,"#",1),":",15)
	s $li(val,17)=+$p($p(valDB,"#",1),":",16)
	s $li(val,18)=+$p($p(valDB,"#",1),":",17)
	s $li(val,19)=+$p($p(valDB,"#",1),":",18)
	s $li(val,20)=+$p($p(valDB,"#",1),":",19)
	s $li(val,21)=+$p($p(valDB,"#",1),":",20)
	s $li(val,22)=$lfs($p($p(valDB,"#",2),"~",1),":")
	s $li(val,23)=$lfs($p($p(valDB,"#",2),"~",2),":")
	s $li(val,24)=+$p($p(valDB,"#",2),"~",3)
	s $li(val,25)=$lfs($p(valDB,"#",3),"~")
	s $li(val,26)=($p(valDB,"#",4)*1000)
	s $li(val,27)=+$p(valDB,"#",5)
	s $li(val,28)=$p(valDB,"#",6)
	s $li(val,29)=$p(valDB,"#",7)
	s $li(val,30)=+$p($p(valDB,"#",1),":",21)
	s $li(val,31)=$p(valDB,"#",8)
	s $li(val,32)=$p(valDB,"#",9)
	s $li(val,33)=+$p($p(valDB,"#",1),":",22)
	s $li(val,34)=+$p($p(valDB,"#",1),":",23)
	s $li(val,35)=+$p($p(valDB,"#",1),":",24)
	s $li(val,36)=$p(valDB,"#",10)
	s $li(val,37)=$p(valDB,"#",11)
	s $li(val,38)=$p(valDB,"#",12)
	s $li(val,39)=$p(valDB,"#",13)
	s $li(val,40)=$p(valDB,"#",14)
	s $li(val,41)=$p(valDB,"#",15)
	s $li(val,42)=$p(valDB,"#",16)
	s $li(val,43)=$p(valDB,"#",17)
	s $li(val,44)=$lfs($p($p(valDB,"#",2),"~",4),":")
	s $li(val,45)=+$p($p(valDB,"#",2),"~",5)
	s $li(val,46)=+$p($p(valDB,"#",1),":",25)
	s $li(val,47)=+$p($p(valDB,"#",1),":",26)
	s $li(val,48)=$lfs($p($p(valDB,"#",2),"~",6),":")
	s $li(val,49)=+$p($p(valDB,"#",2),"~",7)
	s $li(val,50)=$lfs($p($p(valDB,"#",2),"~",8),":")
	s $li(val,51)=+$p($p(valDB,"#",2),"~",9)
	s $li(val,52)=+$p(valDB,"#",18)
	s $li(val,53)=$p(valDB,"#",19)
	s $li(val,54)=$p(valDB,"#",20)
	s $li(val,55)=$p(valDB,"#",21)
	s arr("DTA")=val
	//trasa spoje
	s trasaValDB=""
	f trasaIdx=trasaId:.01 {
		i '$d(@dGlb@("W",trasaIdx)) q
		s trasaValDB=trasaValDB_$g(@dGlb@("W",trasaIdx))
	}
	f idx=1:1:$l(trasaValDB,"#") {
		s valDB=$p(trasaValDB,"#",idx)
		s val=""
		s bodId=$p(valDB,":",1) i bodId="" continue
		s casBod=$p($p(valDB,":",2),"/",1) i (casBod'="<")&(casBod'="|") s casBod=casBod+odjezdCas
		s $li(val,1)=casBod
		s $li(val,2)=$p($p(valDB,":",2),"/",2)
		s vzdalenost=$p(valDB,":",3) i vzdalenost'="" s vzdalenost=vzdalenost*1000
		s $li(val,3)=vzdalenost
		s vzdalenost=$p(valDB,":",4) i vzdalenost'="" s vzdalenost=vzdalenost*1000
		s $li(val,4)=vzdalenost
		s valTmp=$p(valDB,":",5) s valLst="" f cnt=1:1:$l(valTmp) s $li(valLst,($ll(valLst)+1))=$e(valTmp,cnt)
		s $li(val,5)=valLst
		s $li(val,6)=($p(valDB,":",6)="X")
		s $li(val,7)=$p(valDB,":",7)
		s $li(val,8)=$lfs($p(valDB,":",8),";")
		s $li(val,9)=+$p(valDB,":",9)
		s vzdalenost=$p(valDB,":",10) i vzdalenost'="" s vzdalenost=vzdalenost*1000
		s $li(val,10)=vzdalenost
		s $li(val,11)=+$p(valDB,":",11)
		s vzdalenost=$p(valDB,":",12) i vzdalenost'="" s vzdalenost=vzdalenost*1000
		s $li(val,12)=vzdalenost
		s $li(val,13)=$p(valDB,":",13)
		s $li(val,14)=$p(valDB,":",14)
		s $li(val,15)=$p(valDB,":",15)
		s arr("DTA","trasa",bodId)=val
	}
	//datumove omezeni spoje 
	f omezeniId=11,12,13,14,15,22 {
		s valDB=$g(@dGlb@(smerIdx,spojId,omezeniId)) i valDB="" continue
		s arr("DTA","datumoveOmezeni",omezeniId)=$lb($p(valDB,"@",1))
		s valDB=$p(valDB,"@",2)
		f cnt=1:1:$l(valDB,"#") {
			s valTmp=$p(valDB,"#",cnt)
			s datumOd=$p(valTmp,":",1) 
			s datumDo=$p(valTmp,":",1)
			s horlogOd="" i datumOd s horlogOd=##class(ALVA.GENERALAPI.Date).DateToHor(datumOd)
			s horlogDo="" i datumDo s horlogDo=##class(ALVA.GENERALAPI.Date).DateToHor(datumDo)
			s arr("DTA","datumoveOmezeni",omezeniId,horlogOd)=$lb(horlogDo)
		}
	}
	//navaznosti spoje
	d ..nactiNavaznost(.sys,id,dGlb,.arr)
	//prepravni system
	s prsId="" f {
		s val="" s prsId=$o(@dGlb@("PATCH","PRS",spojId,prsId),1,val) i prsId="" q
		s arr("DTA","prepravniSystem",prsId)=$lb(val*1000)  
	}
	//poznamky pro strojky
	s bodId="" f {
		s poznamkaText="" s bodId=$o(@dGlb@("PATCH","StrPoz",spojId,bodId),1,poznamkaText) i bodId="" q
		i poznamkaText="" continue
		s arr("DTA","poznamkaOdbavovaciZarizeni",bodId)=$lb(poznamkaText)
	}
	//silnice
	s cnt=0 s silniceDotovatelId="" f {
		s valDB="" s silniceDotovatelId=$o(@dGlb@("PATCH","SIL",spojId,silniceDotovatelId),1,valDB) i silniceDotovatelId="" q
		s silniceId=$p(silniceDotovatelId,"~",1)
		s dotovatelId=$p(silniceDotovatelId,"~",2)
		s vzdalenost=valDB*1000
		i 'vzdalenost continue
		s arr("DTA","silnice",$i(cnt))=$lb(silniceId,dotovatelId,vzdalenost)
	}
	//technicke pauzy
	s minutPo="" f {
		s valDB="" s minutPo=$o(@dGlb@("PATCH","TCHP",spojId,minutPo),1,valDB) i minutPo="" q
		s arr("DTA","technickaPauza",minutPo)=$lb(valDB)
	}
	//atributy omezeni
	f atributOmezeniId=15,19 {
		s valDB=$g(@dGlb@("PATCH","attrOm",atributOmezeniId,spojId))
		f cnt=1:1:$l(valDB,"#") {
			s val=$p(valDB,"#",cnt)
			i val'="" {
				s datumOd=$p(val,"~",1) s horlogOd=##class(ALVA.GENERALAPI.Date).DateToHor(datumOd)
				s datumDo=$p(val,"~",2) s horlogDo=##class(ALVA.GENERALAPI.Date).DateToHor(datumDo)
				s pocet=$p(val,"~",3)
				i atributOmezeniId=15 s arr("DTA","atributyOmezeni",atributOmezeniId,cnt)=$lb(horlogOd,horlogDo)
				i atributOmezeniId=19 s arr("DTA","atributyOmezeni",atributOmezeniId,cnt)=$lb(horlogOd,horlogDo,pocet)
			}
		}
	}
}

ClassMethod nactiPlatnost(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//vrati data platnosti spoje
	//IN
	//id = $lb(skupinaId,aplId,linkaId,smerId,spojId)
	//smerId= 0 tam / 1 zpet
	//nebo dGlb = global, kde jsou data linky tak, jak jsou ulozeny v databazi, pak se data nacitaji z nej
	//OUT
	//arr("DTA")=$lb($lb(tydenniPlatnostId,tydenniPlatnostId,...),dlouhodobeOmezeniId,negativniZnacka)
	//arr("DTA","datumoveOmezeni",omezeniId,hrl)=""
	//omezeniId = 11 / jede jen ,12 / jede take ,13 /jede ,14 / jede v sudych tydnech ,15 / jede v lichych tydnech ,22 / nejede 
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb)
	s skupinaId=$lg(id,1) s aplId=$lg(id,2) s linkaId=$lg(id,3) s smerId=$lg(id,4) s spojId=$lg(id,5)
	i linkaId'="" s linkaId=##class(ALVA.ISY.ISYLinky.API.LinkyFce).cisloLinkyDoIndexu(linkaId)
	//neni-li datovy global a je-li zastavkaId, pak nacitam data z databaze
	i (dGlb="")&(skupinaId) {s dGlb=$name(^[dataDB]JRL(skupinaId,linkaId))}
	i (dGlb="")&(aplId) {s dGlb=$name(^[dataDB]JRAPL(linkaId,aplId,"arr"))}
	s valDB=""
	s smerIdx=$e("TZ",smerId+1)
	s valDB=$g(@dGlb@(smerIdx,spojId))
	s val=""
	s valTmp=$p($p(valDB,"#",1),":",7) s valLst="" f cnt=1:1:$l(valTmp) s $li(valLst,($ll(valLst)+1))=$e(valTmp,cnt)
	s $li(val,1)=valLst
	s $li(val,2)=$p($p(valDB,"#",1),":",8)
	s $li(val,3)=$p(valDB,"#",7)
	s arr("DTA")=val
	//datumove omezeni spoje 
	f omezeniId=11,12,13,14,15,22 {
		s valDB=$g(@dGlb@(smerIdx,spojId,omezeniId)) i valDB="" continue
		s arr("DTA","datumoveOmezeni",omezeniId)=$lb($p(valDB,"@",1))
		s valDB=$p(valDB,"@",2)
		f cnt=1:1:$l(valDB,"#") {
			s valTmp=$p(valDB,"#",cnt)
			s datumOd=$p(valTmp,":",1) 
			s datumDo=$p(valTmp,":",2) i datumDo="" s datumDo=datumOd
			s horlogOd=##class(ALVA.GENERALAPI.Date).DateToHor(datumOd)
			s horlogDo=##class(ALVA.GENERALAPI.Date).DateToHor(datumDo)
			f horlog=horlogOd:1:horlogDo s arr("DTA","datumoveOmezeni",omezeniId,horlog)=""
		}
	}
}

ClassMethod uloz(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//ulozi data spoje
	//IN
	//id = $lb(skupinaId,aplId,linkaId,smerId,spojId)
	//smerId= 0 tam / 1 zpet
	//nebo dGlb = global, kde jsou data spoje tak, jak jsou ulozeny v databazi, pak se data ukladaji do nej
	//arr("DTA",...)=$lb(dta,dta,...) / popis v popis
	//OUT
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb)
	s skupinaId=$lg(id,1) s aplId=$lg(id,2) s linkaId=$lg(id,3) s smerId=$lg(id,4) s spojId=$lg(id,5)
	i linkaId'="" s linkaId=##class(ALVA.ISY.ISYLinky.API.LinkyFce).cisloLinkyDoIndexu(linkaId)
	//neni-li datovy global, pak vytvorim 
	i (dGlb="")&(skupinaId) {s dGlb=$name(^[dataDB]JRL(skupinaId,linkaId))}
	i (dGlb="")&(aplId) {s dGlb=$name(^[dataDB]JRAPL(linkaId,aplId,"arr"))}
	s smerIdx=$e("TZ",smerId+1)
	//zaloha puvodni negativni znacky spoje pro pripadnou aktualizaci
	k arrPuvodniNZ
	i $d(@dGlb@(smerIdx,spojId)) {
		s valDB=$g(@dGlb@(smerIdx,spojId))
		s arrPuvodniNZ=$p(valDB,"#",7)
		s arrPuvodniNZ("DPL")=$p($p(valDB,"#",1),":",8)
		f omezeniId=11,12,13,14,15,22 {
			s arrPuvodniNZ(omezeniId)=$p($g(@dGlb@(smerIdx,spojId,omezeniId)),"@",2)
		}
	}
	s valDB="" s val=""
	//zakladni veta spoje
	s val=$g(arr("DTA"))
	s $p(valDB,":",1)=$lg(val,1) s bodOdId=$lg(val,1)
	s $p(valDB,":",2)=$lg(val,2) s bodDoId=$lg(val,2)
	s $p(valDB,":",3)=$lg(val,3) //trasa pozdeji aktualizace
	s $p(valDB,":",4)=$lg(val,4) s odjezdCas=$lg(val,4)
	s $p(valDB,":",5)=$lg(val,5)
	s $p(valDB,":",6)=$lg(val,6)
	s $p(valDB,":",7)=$lts($lg(val,7),"")
	s $p(valDB,":",8)=$lg(val,8)
	s $p(valDB,":",9)=$lg(val,9)
	s $p(valDB,":",10)=$lg(val,10)_"$"_$lts($lg(val,11),"/")
	s $p(valDB,":",11)=$lg(val,12)
	s $p(valDB,":",12)=$lg(val,13)
	s $p(valDB,":",13)=$lg(val,14)
	s $p(valDB,":",14)=$lg(val,15)
	s $p(valDB,":",15)=$lg(val,16)
	s $p(valDB,":",16)=$lg(val,17)
	s $p(valDB,":",17)=$lg(val,18)
	s $p(valDB,":",18)=$lg(val,19)
	s $p(valDB,":",19)=$lg(val,20)
	s $p(valDB,":",20)=$lg(val,21)
	s $p(valDB,":",21)=$lg(val,30)
	s $p(valDB,":",22)=$lg(val,33)
	s $p(valDB,":",23)=$lg(val,34)
	s $p(valDB,":",24)=$lg(val,35)
	s $p(valDB,":",25)=$lg(val,46)
	s $p(valDB,":",26)=$lg(val,47)
	s tmpVal=""
	s $p(tmpVal,"~",1)=$lts($lg(val,22),":")
	s $p(tmpVal,"~",2)=$lts($lg(val,23),":")
	s $p(tmpVal,"~",3)=$lg(val,24)
	s $p(tmpVal,"~",4)=$lts($lg(val,44),":")
	s $p(tmpVal,"~",5)=$lg(val,45)
	s $p(tmpVal,"~",6)=$lts($lg(val,48),":")
	s $p(tmpVal,"~",7)=$lg(val,49)
	s $p(tmpVal,"~",8)=$lts($lg(val,50),":")
	s $p(tmpVal,"~",9)=$lg(val,51)
	s $p(valDB,"#",2)=tmpVal
	s $p(valDB,"#",3)=$lts($lg(val,25),"~")
	s $p(valDB,"#",4)=$lg(val,26)/1000
	s $p(valDB,"#",5)=$lg(val,27)
	s $p(valDB,"#",6)=$lg(val,28)
	s $p(valDB,"#",7)=$lg(val,29)
	s $p(valDB,"#",8)=$lg(val,31)
	s $p(valDB,"#",9)=$lg(val,32)
	s $p(valDB,"#",10)=$lg(val,36)
	s $p(valDB,"#",11)=$lg(val,37)
	s $p(valDB,"#",12)=$lg(val,38)
	s $p(valDB,"#",13)=$lg(val,39)
	s $p(valDB,"#",14)=$lg(val,40)
	s $p(valDB,"#",15)=$lg(val,41)
	s $p(valDB,"#",16)=$lg(val,42)
	s $p(valDB,"#",17)=$lg(val,43)
	s $p(valDB,"#",18)=$lg(val,52)
	s $p(valDB,"#",19)=$lg(val,53)
	s $p(valDB,"#",20)=$lg(val,54)
	s $p(valDB,"#",21)=$lg(val,55)
	//trasa spoje
	s valTrasaDB=""
	s par=1 i smerId=1 s par=-1
	f bodId=bodOdId:par:bodDoId {
		s val=$g(arr("DTA","trasa",bodId))
		s tmpVal=""
		s $p(tmpVal,":",1)=bodId
		s bodCas=$lg(val,1) i (bodCas'="<")&(bodCas'="|") s bodCas=bodCas-odjezdCas
		s $p(tmpVal,":",2)=bodCas_"/"_$lg(val,2)
		s vzdalenost=$lg(val,3) i vzdalenost'="" s vzdalenost=vzdalenost/1000
		s $p(tmpVal,":",3)=vzdalenost
		s vzdalenost=$lg(val,4) i vzdalenost'="" s vzdalenost=vzdalenost/1000
		s $p(tmpVal,":",4)=vzdalenost
		s $p(tmpVal,":",5)=$lts($lg(val,5),"")
		s $p(tmpVal,":",6)="" i $lg(val,6) s $p(tmpVal,":",6)="X"
		s $p(tmpVal,":",7)=$lg(val,7)
		s $p(tmpVal,":",8)=$lts($lg(val,8),";")
		s $p(tmpVal,":",9)=$lg(val,9)
		s vzdalenost=$lg(val,10) i vzdalenost'="" s vzdalenost=vzdalenost/1000
		s $p(tmpVal,":",10)=vzdalenost
		s $p(tmpVal,":",11)=$lg(val,11)
		s vzdalenost=$lg(val,12) i vzdalenost'="" s vzdalenost=vzdalenost/1000
		s $p(tmpVal,":",12)=vzdalenost
		s $p(tmpVal,":",13)=$lg(val,13)
		s $p(tmpVal,":",14)=$lg(val,14)
		s $p(tmpVal,":",15)=$lg(val,15)
		s valTrasaDB=valTrasaDB_tmpVal_"#"
	}
	i $e(valTrasaDB,$l(valTrasaDB))="#" s valTrasaDB=$e(valTrasaDB,1,($l(valTrasaDB)-1))
	f trasaId=1:1 { i '$d(@dGlb@("W",trasaId)) s @dGlb@("W",trasaId)=valTrasaDB q }
	//zapis trasyId do vety spoje
	s $p(valDB,":",3)=trasaId
	//zapis zakladni vety spoje
	s @dGlb@(smerIdx,spojId)=valDB
	//datumove omezeni spoje 
	f omezeniId=11,12,13,14,15,22 {
		s valDB=""	 	
		s horlogOd="" f {
			s val="" s horlogOd=$o(arr("DTA","datumoveOmezeni",omezeniId,horlogOd),1,val) i horlogOd="" q
			s horlogDo=$lg(val,1)
			s datumOd=##class(ALVA.GENERALAPI.Date).horToDate(horlogOd)
			s datumDo="" i horlogDo s datumDo=##class(ALVA.GENERALAPI.Date).horToDate(horlogDo)
			s valDB=valDB_datumOd_":"_datumDo_"#"
		}
		i $e(valDB,$l(valDB))="#" s valDB=$e(valDB,1,$l(valDB)-1)
		k @dGlb@(smerIdx,spojId,omezeniId)
		i valDB'="" {
			s @dGlb@(smerIdx,spojId,omezeniId)=$g(^[dataDB]JRSET("Cis","InPlatOzn",omezeniId))_"@"_valDB
		}
	}
	//navaznosti spoje
	d ..ulozNavaznost(.sys,id,dGlb,.arr)
	//prepravni system
	k @dGlb@("PATCH","PRS",spojId)
	s prsId="" f {
		s val="" s prsId=$o(arr("DTA","prepravniSystem",prsId),1,val) i prsId="" q
		s vzdalenost=$lg(val,1)
		s @dGlb@("PATCH","PRS",spojId,prsId)=(vzdalenost/1000)
	}
	//poznamky pro strojky
	k @dGlb@("PATCH","StrPoz",spojId)
	s bodId="" f {
		s val="" s bodId=$o(arr("DTA","poznamkaOdbavovaciZarizeni",bodId),1,val) i bodId="" q
		s poznamkaText=$lg(val,1)
		s @dGlb@("PATCH","StrPoz",spojId,bodId)=poznamkaText
	}
	//silnice
	k @dGlb@("PATCH","SIL",spojId)
	s cnt="" f {
		s val="" s cnt=$o(arr("DTA","silnice",cnt),1,val) i cnt="" q
		s silniceId=$lg(val,1)
		s dotovatelId=$lg(val,2)
		s vzdalenost=$lg(val,3)
		s silniceDotovatelId=silniceId_"~"_dotovatelId
		s @dGlb@("PATCH","SIL",spojId,silniceDotovatelId)=(vzdalenost/1000)
	}
	//technicke pauzy
	k @dGlb@("PATCH","TCHP",spojId)
	s minutPo="" f {
		s val="" s minutPo=$o(arr("DTA","technickaPauza",minutPo),1,val) i minutPo="" q
		s minut=$lg(val,1)
		s @dGlb@("PATCH","TCHP",spojId,minutPo)=minut
	}
	//omezeni atributy
	f atributOmezeniId=15,19 {
		k @dGlb@("PATCH","attrOm",atributOmezeniId,spojId)
		s valDB=""
		s cnt="" f {
			s val="" s cnt=$o(arr("DTA","atributyOmezeni",atributOmezeniId,cnt),1,val) i cnt="" q
			s horlogOd=$lg(val,1) s datumOd=##class(ALVA.GENERALAPI.Date).horToDate(horlogOd)
			s horlogDo=$lg(val,2) s datumDo=##class(ALVA.GENERALAPI.Date).horToDate(horlogDo)
			s pocet=$lg(val,3)
			i atributOmezeniId=15 {
				i valDB'="" s valDB=valDB_"#"
				s valDB=valDB_datumOd_"~"_datumDo
			}
			i atributOmezeniId=19 {
				i valDB'="" s valDB=valDB_"#"
				s valDB=valDB_datumOd_"~"_datumDo_"~"_pocet
			}
		}
		i valDB'="" s @dGlb@("PATCH","attrOm",atributOmezeniId,spojId)=valDB
	}
	//korekce cisla NZ
	k tmpArr m tmpArr("PAR","puvodniNZ")=arrPuvodniNZ
	d ##class(ALVA.ISY.ISYLinky.API.LinkySpojeFce).korekceNZ(.sys,id,dGlb,.tmpArr)
	k tmpArr
	// prepocet kms
	k tmpArr
	s tmpArr("PAR","maximalniPocet")=+$g(^[dataDB]JRSET("Definice","Kms","Filtr"),10)
	s tmpArr("PAR","maximalniFiltr")=+$g(^[dataDB]JRSET("Definice","Kms","MaxFiltr"))
	s tmpArr("PAR","skladatDoSebe")=+$g(^[dataDB]JRSET("Definice","Kms","Pack"))
	f kmsSmer=-1,0,1 s tmpArr("PAR","smer")=kmsSmer d ##class(ALVA.ISY.ISYLinky.API.LinkySpojeFce).vypocitejKilometrickeSloupce(.sys,id,dGlb,.tmpArr)
	k tmpArr
	// vymazani nepotrebnych tras
	d ##class(ALVA.ISY.ISYLinky.API.LinkySpojeFce).vymazNepotrebneTrasy(.sys,id,dGlb,"")
		//
	// pocitadlo spoju
	s pocetSpoju=""
	s spojId="" f  {
		s spojId=$o(@dGlb@(smerIdx,spojId)) i spojId="" q
		s pocetSpoju=pocetSpoju+1
	}
	s @dGlb@(smerIdx)=pocetSpoju
	//vymazani chybnych odkazu na spoje
	//s err=$$CleanSp(idfa,nmsp,sku,lin,sm,sp) i err zt "merr"
#;==============
}

ClassMethod nactiNavaznost(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//vrati data platnosti spoje
	//IN
	//id = $lb(skupinaId,aplId,linkaId,smerId,spojId)
	//nebo dGlb = global, kde jsou data linky tak, jak jsou ulozeny v databazi, pak se data nacitaji z nej
	//OUT
	//arr("DTA","navaznost",navaznostId,idx)=$lb(...,...,...)
	//navaznostId=31 / vycka
	//
	//1 bodId
	//2 vyckaCasMin				... delka cekani v bodu
	//3 autobusVlakLod			...	ceka na A/V/L
	//4 linkaCislo				... cislo linky
	//5 spojCislo				... cislo spoje
	//6 smerOd					... smer spoje od
	//7 smerDo					... smer spoje do
	//8 dopravce				... dopravce spoje textove
	//9 prijezdMin				... cas prijezdu do bodu
	//10 typVystupuId			...	0 tiskJR / 1 tiskJR+exp.odbav.zar. / 2 exp.odbav.zar.
	//11 typZobrazeniId			... 0 znackou u spoje / 1 pripojny radek / 2 znackou u spoje + pripojny radek
	//12 linkaCisloTisk			...	ceka cislo linky - oznaceni cisla linky pro tisk	
	//
	//navaznostId=32 / navazuje
	//1 bodId
	//2 autobusVlakLod			...	navazuje A/V/L
	//3 linkaCislo				... cislo linky
	//4 spojCislo				... cislo spoje
	//5 smerOd					... smer spoje od
	//6 smerDo					... smer spoje do
	//7 dopravce				... dopravce spoje textove
	//8 odjezdMin				... cas odjezdu z bodu
	//9 typVystupuId			...	0 tiskJR / 1 tiskJR+exp.odbav.zar. / 2 exp.odbav.zar.
	//10 typZobrazeniId			... 0 znackou u spoje / 1 pripojny radek / 2 znackou u spoje + pripojny radek
	//11 zobrazitTablo  		... 0 ne / 1 ano
	//12 preferujeCsad			... 0 ne / 1 ano
	//13 scitatCenu				... 0 ne / 1 ano
	//14 linkaCisloTisk			...	navazuje cislo linky - oznaceni cisla linky pro tisk	
	//
	//navaznostId=34 / pokracuje
	//1 linkaCislo			... cislo linky
	//2 spojCislo			... cislo spoje
	//3 smerDo				... smer spoje do
	//4 odjezdMin			... cas odjezdu navazujiciho bodu
	//5 typVystupuId		...	0 tiskJR / 1 tiskJR+exp.odbav.zar. / 2 exp.odbav.zar.
	//6 proVypocetRelaci	...	0 ne / 1 ano
	//
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb) k arr("DTA","navaznost")
	s skupinaId=$lg(id,1) s aplId=$lg(id,2) s linkaId=$lg(id,3) s smerId=$lg(id,4) s spojId=$lg(id,5)
	i linkaId'="" s linkaId=##class(ALVA.ISY.ISYLinky.API.LinkyFce).cisloLinkyDoIndexu(linkaId)
	//neni-li datovy global a je-li zastavkaId, pak nacitam data z databaze
	i (dGlb="")&(skupinaId) {s dGlb=$name(^[dataDB]JRL(skupinaId,linkaId))}
	i (dGlb="")&(aplId) {s dGlb=$name(^[dataDB]JRAPL(linkaId,aplId,"arr"))}
	s valDB=""
	s smerIdx=$e("TZ",smerId+1)
	f navaznostId=31,32,34 {
		s valDB=$g(@dGlb@(smerIdx,spojId,navaznostId)) i valDB="" continue
		//vycka
		i navaznostId=31 {
			f cntPart=2:1 {
				s valPart=$p(valDB,"@",cntPart) i valPart="" q
						s bodId=$p(valPart,"#",1) s vyckaCasMax=$p(valPart,"#",2)
						f cnt=3:1 {
							s valPartDta=$p(valPart,"#",cnt) i valPartDta="" q
							s autobusVlakLod=$p(valPartDta,":",1) i autobusVlakLod="" s autobusVlakLod="A"
							s linkaCislo=$p(valPartDta,":",2)
							s spojCislo=$p(valPartDta,":",3)
							s typVystupuId=$p(valPartDta,":",4)
							s smerOd=$p(valPartDta,":",5)
							s prijezdMin=$p(valPartDta,":",6)
							s typZobrazeniId=$p(valPartDta,":",7)
							s dopravce=$p(valPartDta,":",8)
							s vyckaCas=$p(valPartDta,":",9) i vyckaCas="" s vyckaCas=vyckaCasMax
							s smerDo=$p(valPartDta,":",10)
							s linkaCisloTisk=$p(valPartDta,":",11)
							s val=""
							s $li(val,1)=bodId
							s $li(val,2)=vyckaCas
							s $li(val,3)=autobusVlakLod
							s $li(val,4)=linkaCislo
							s $li(val,5)=spojCislo
							s $li(val,6)=smerOd
							s $li(val,7)=smerDo
							s $li(val,8)=dopravce
							s $li(val,9)=prijezdMin
							s $li(val,10)=typVystupuId
							s $li(val,11)=typZobrazeniId
							s $li(val,12)=linkaCisloTisk
							s arr("DTA","navaznost",navaznostId,$i(arr("DTA","navaznost",navaznostId)))=val
						}
			}
		}
		//navazuje
		i navaznostId=32 {
			f cntPart=2:1 {
				s valPart=$p(valDB,"@",cntPart) i valPart="" q
				s bodId=$p(valPart,"#",1)
				f cnt=2:1 {
							s valPartDta=$p(valPart,"#",cnt) i valPartDta="" q
							s linkaCislo=$p(valPartDta,":",1)
							s spojCislo=$p(valPartDta,":",2)
							s smerDo=$p(valPartDta,":",3)
							s typVystupuId=$p(valPartDta,":",4)
							s preferujeCsad=(+$p(valPartDta,":",5)=0)
							s autobusVlakLod=$p(valPartDta,":",6) i autobusVlakLod="" s autobusVlakLod="A"
							s zobrazitTablo=$p(valPartDta,":",7)
							s odjezdMin=$p(valPartDta,":",8)
							s typZobrazeniId=$p(valPartDta,":",9)
							s scitatCenu=(+$p(valPartDta,":",10)=0)
							s dopravce=$p(valPartDta,":",11)
							s linkaCisloTisk=$p(valPartDta,":",12)
							s val=""
							s $li(val,1)=bodId
							s $li(val,2)=autobusVlakLod
							s $li(val,3)=linkaCislo
							s $li(val,4)=spojCislo
							s $li(val,5)=""
							s $li(val,6)=smerDo
							s $li(val,7)=dopravce
							s $li(val,8)=odjezdMin
							s $li(val,9)=typVystupuId
							s $li(val,10)=typZobrazeniId
							s $li(val,11)=zobrazitTablo
							s $li(val,12)=preferujeCsad
							s $li(val,13)=scitatCenu
							s $li(val,14)=linkaCisloTisk
							s arr("DTA","navaznost",navaznostId,$i(arr("DTA","navaznost",navaznostId)))=val
				}
			}
		}
		//pokracuje
		i navaznostId=34 {
			s valDB=$p(valDB,"@",2)
			s linkaCislo=$p(valDB,":",2)
			s spojCislo=$p(valDB,":",3)
			s smerDo=$p(valDB,":",4)
			s typVystupuId=$p(valDB,":",5)
			s proVypocetRelaci=($p(valDB,":",6)=0)
			s val=""
					s $li(val,1)=linkaCislo
					s $li(val,2)=spojCislo
					s $li(val,3)=smerDo
					s $li(val,4)=""
					s $li(val,5)=typVystupuId
					s $li(val,6)=proVypocetRelaci
					s arr("DTA","navaznost",navaznostId)=1
					s arr("DTA","navaznost",navaznostId,1)=val
				}
	}
}

ClassMethod ulozNavaznost(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//zapise data navaznosti spoje - zatim priprava, nikde se nevola, vola se ##class(ALVA.ISY.ISYLinky.API.LinkySpoje).navaznostDoVetyDB
	//IN
	//id = $lb(skupinaId,aplId,linkaId,smerId,spojId)
	//nebo dGlb = global, kde jsou data linky tak, jak jsou ulozeny v databazi, pak se data nacitaji z nej
	//arr("DTA","navaznost",navaznostId,idx)=$lb(...,...,...)
	//OUT
	//
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb)
	s skupinaId=$lg(id,1) s aplId=$lg(id,2) s linkaId=$lg(id,3) s smerId=$lg(id,4) s spojId=$lg(id,5)
	i linkaId'="" s linkaId=##class(ALVA.ISY.ISYLinky.API.LinkyFce).cisloLinkyDoIndexu(linkaId)
	//neni-li datovy global a je-li zastavkaId, pak nacitam data z databaze
	i (dGlb="")&(skupinaId) {s dGlb=$name(^[dataDB]JRL(skupinaId,linkaId))}
	i (dGlb="")&(aplId) {s dGlb=$name(^[dataDB]JRAPL(linkaId,aplId,"arr"))}
	s smerIdx=$e("TZ",smerId+1)
	f navaznostId=31,32,34 {
		k @dGlb@(smerIdx,spojId,navaznostId)
		s valDB=##class(ALVA.ISY.ISYLinky.API.LinkySpoje).navaznostDoVetyDB(.sys,navaznostId,.arr)
		i valDB'="" {s @dGlb@(smerIdx,spojId,navaznostId)=valDB}
	}
}

ClassMethod navaznostDoVetyDB(ByRef sys As %String, navaznostId, ByRef arr As %String) As %String
{
	$$$FillParams
	//IN
	//arr("DTA","navaznost",navaznostId,cnt)=$lb(val,val,...)
	s valDB=""
	i $d(arr("DTA","navaznost",navaznostId)) {
		//vycka
		i navaznostId=31 {
			k arrDta
			s cnt="" f {
				s valDta="" s cnt=$o(arr("DTA","navaznost",navaznostId,cnt),1,valDta) i cnt="" q
				s bodId=$lg(valDta,1)
						s vyckaCas=$lg(valDta,2)
						s autobusVlakLod=$lg(valDta,3)
						s linkaCislo=$lg(valDta,4)
						s spojCislo=$lg(valDta,5)
						s smerOd=$lg(valDta,6)
						s smerDo=$lg(valDta,7)
						s dopravce=$lg(valDta,8)
						s prijezdMin=$lg(valDta,9)
						s typVystupuId=$lg(valDta,10)
						s typZobrazeniId=$lg(valDta,11)
						s linkaCisloTisk=$lg(valDta,12)
						//
						i $g(arrDta(bodId))<vyckaCas s arrDta(bodId)=vyckaCas
						//
						s valPartDta=""
						s $p(valPartDta,":",1)=autobusVlakLod
						s $p(valPartDta,":",2)=linkaCislo
						s $p(valPartDta,":",3)=spojCislo
						s $p(valPartDta,":",4)=typVystupuId
						s $p(valPartDta,":",5)=smerOd
						s $p(valPartDta,":",6)=prijezdMin
						s $p(valPartDta,":",7)=typZobrazeniId
						s $p(valPartDta,":",8)=dopravce
						s $p(valPartDta,":",9)=vyckaCas
						s $p(valPartDta,":",10)=smerDo
						s $p(valPartDta,":",11)=linkaCisloTisk
						
						s arrDta(bodId,$o(arrDta(bodId,""),-1)+1)=valPartDta
			}
			s valDB="m"
			s bodId="" f {
				s vyckaCas="" s bodId=$o(arrDta(bodId),1,vyckaCas) i bodId="" q
					i valDB'="" s valDB=valDB_"@"
					s valDB=valDB_bodId_"#"_vyckaCas
					s cnt="" f {
						s valPartDta="" s cnt=$o(arrDta(bodId,cnt),1,valPartDta) i cnt="" q
						s valDB=valDB_"#"_valPartDta
					}
			}
		}
		i navaznostId=32 {
			k arrDta
			s cnt="" f {
				s valDta="" s cnt=$o(arr("DTA","navaznost",navaznostId,cnt),1,valDta) i cnt="" q
				s bodId=$li(valDta,1)
						s autobusVlakLod=$lg(valDta,2)
						s linkaCislo=$lg(valDta,3)
						s spojCislo=$lg(valDta,4)
						s smerDo=$lg(valDta,6)
						s dopravce=$lg(valDta,7)
						s odjezdMin=$lg(valDta,8)
						s typVystupuId=$lg(valDta,9)
						s typZobrazeniId=$lg(valDta,10)
						s zobrazitTablo=$lg(valDta,11)
						s preferujeCsad=$lg(valDta,12)
						s scitatCenu=$lg(valDta,13)
						s linkaCisloTisk=$lg(valDta,14)
						//
						s valPartDta=""
						s $p(valPartDta,":",1)=linkaCislo
						s $p(valPartDta,":",2)=spojCislo
						s $p(valPartDta,":",3)=smerDo
						s $p(valPartDta,":",4)=typVystupuId
						s $p(valPartDta,":",5)=(+preferujeCsad=0)
						s $p(valPartDta,":",6)=autobusVlakLod
						s $p(valPartDta,":",7)=zobrazitTablo
						s $p(valPartDta,":",8)=odjezdMin
						s $p(valPartDta,":",9)=typZobrazeniId
						s $p(valPartDta,":",10)=(+scitatCenu=0)
						s $p(valPartDta,":",11)=dopravce
						s $p(valPartDta,":",12)=linkaCisloTisk
						s arrDta(bodId,$o(arrDta(bodId,""),-1)+1)=valPartDta
			}
			s valDB="m"
			s bodId="" f {
				s bodId=$o(arrDta(bodId)) i bodId="" q
					i valDB'="" s valDB=valDB_"@"
					s valDB=valDB_bodId
					s cnt="" f {
						s valPartDta="" s cnt=$o(arrDta(bodId,cnt),1,valPartDta) i cnt="" q
						s valDB=valDB_"#"_valPartDta
					}
			}
		}
		i navaznostId=34 {
			 s valDta=$g(arr("DTA","navaznost",navaznostId,1))
			 i valDta'="" {
				s linkaCislo=$li(valDta,1)
						s spojCislo=$li(valDta,2)
						s smerDo=$li(valDta,3)
						s typVystupuId=$li(valDta,5)
						s proVypocetRelaci=$li(valDta,6)
						//
						s valPartDta=""
						s $p(valPartDta,":",2)=linkaCislo
				s $p(valPartDta,":",3)=spojCislo
				s $p(valPartDta,":",4)=smerDo
				s $p(valPartDta,":",5)=typVystupuId
				s $p(valPartDta,":",6)=(+proVypocetRelaci=0)
						s valDB="u@"_valPartDta
			 }
		 }
	 }
	 q valDB
}

ClassMethod vymaz(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//vymaze data spoje
	//IN
	//id = $lb(skupinaId,aplId,linkaId,smerId,spojId)
	//nebo dGlb = global, kde jsou data linky tak, jak jsou ulozeny v databazi, pak se data nacitaji z nej
	//OUT
	//
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb)
	s skupinaId=$lg(id,1) s aplId=$lg(id,2) s linkaId=$lg(id,3) s smerId=$lg(id,4) s spojId=$lg(id,5)
	i linkaId'="" s linkaId=##class(ALVA.ISY.ISYLinky.API.LinkyFce).cisloLinkyDoIndexu(linkaId)
	//neni-li datovy global a je-li zastavkaId, pak nacitam data z databaze
	i (dGlb="")&(skupinaId) {s dGlb=$name(^[dataDB]JRL(skupinaId,linkaId))}
	i (dGlb="")&(aplId) {s dGlb=$name(^[dataDB]JRAPL(linkaId,aplId,"arr"))}
	s smerIdx=$e("TZ",smerId+1)
	k @dGlb@(smerIdx,spojId)			 			//data spoje
	k @dGlb@("PATCH","PRS",spojId)       			//prepravni system
	k @dGlb@("PATCH","SIL",spojId)       			//silnice
	k @dGlb@("PATCH","TCHP",spojId)      			//technicke prestavky
	k @dGlb@("PATCH","StrPoz",spojId)	 			//odstraneni poznamky pro strojek
	k @dGlb@("PATCH","attrOm",15,spojId) 			//bezbarierovy pristup
	k @dGlb@("PATCH","PATCH","attrOm",19,spojId) 	//omezeni pro kola
	// spoj v poznamkach pro mistenkovani
	s cnt="" f {
			s cnt=$o(@dGlb@("C",2,cnt)) i cnt="" q
			s val=$g(@dGlb@("C",2,cnt))
			s spVal=$p(val,"~",1)
			k tmpArr f ind=1:1:$l(spVal,",") {
				 i $p(spVal,",",ind)'="" {
					 s tmpArr($p(spVal,",",ind))=""
				 }
			}
			k tmpArr(spojId)
		// spoj byl v poznamce sam, zruseni poznamky
			i $o(tmpArr(""))="" k @dGlb@("C",2,cnt) continue
		//zabaleni spoju do vety
			s spVal="" s ind="" f {
				s ind=$o(tmpArr(ind)) i ind="" q
					i spVal'="" s spVal=spVal_","
					s spVal=spVal_ind
			}
			s $p(val,"~",1)=spVal
			s @dGlb@("C",2,cnt)=val
	}
	//prepocet kms
	s err=$$mkKmsLin^JRapi(idfa,nmsp,sku,lin,"","") zt:+err "merr" s err=""
	#; ============
	#; vymazani nepotrebnych tras
	s err=$$dIdleTrsSp^JRapi(idfa,nmsp,sku,lin,"","") zt:+err "merr" s err=""
	#; ==========================
	#;obnova/oprava rucniho poradi spoju - chybi li pouze smazany spoj
	s err=$$mkPoradiSpdSp^JRapi(idfa,nmsp,sku,lin,sm,sp,.in,.out) zt:+err "merr" s err=""
	#; pocitadlo spoju
	s @dGlb@(smerIdx)=""
	s sp="" f {
		s sp=$o(@dGlb@(smerIdx,sp)) i sp="" q
		s @dGlb@(smerIdx)=$g(@dGlb@(smerIdx))+1
	}
}

ClassMethod seznam(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//vrati seznam spoju na lince 
	//IN
	//id = $lb(skupinaId,aplId,linkaId)
	//nebo dGlb = global, kde jsou data linky tak, jak jsou ulozeny v databazi, pak se data nacitaji z nej
	//OUT
	//arr("DTA",smerId,spojId)=""
	//smerId=0 - tam / 1 zpet
	//spojId=id/cislo spoje
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb)
	s skupinaId=$lg(id,1) s aplId=$lg(id,2) s linkaId=$lg(id,3)
	i linkaId'="" s linkaId=##class(ALVA.ISY.ISYLinky.API.LinkyFce).cisloLinkyDoIndexu(linkaId)
	//neni-li datovy global a je-li zastavkaId, pak nacitam data z databaze
	i (dGlb="")&(skupinaId) {s dGlb=$name(^[dataDB]JRL(skupinaId,linkaId))}
	i (dGlb="")&(aplId) {s dGlb=$name(^[dataDB]JRAPL(linkaId,aplId,"arr"))}
	s ^jm("test")=dGlb
	f smer="T","Z" {
		s smerId=0 i smer="Z" s smerId=1 
		s spojId="" f {
			 s spojId=$o(@dGlb@(smer,spojId)) i spojId="" q
			 s arr("DTA",smerId,spojId)=""
		}
	}
}

}
