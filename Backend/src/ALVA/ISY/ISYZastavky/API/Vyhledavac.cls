Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYZastavky.API.Vyhledavac [ Abstract ]
{

ClassMethod GetSys(ByRef sys)
{
	s sys=""
	#; s sys("U","IdFa")="VS_CSAD"
	s sys("U","IdFa")="CK_SCHWAN"
    s sys("U","delimiter")=$c(0)
    s sys("U","SystemDB")="MLINE"
    s sys("C","User")=007
    s sys("U","DATA")="USER"
    s sys("U","MLP")=7
    s sys("U","fullName")="007"
    s sys("U","loginName")="007"
    s sys("C","GUID")=7
    
    q $$$OK
}

ClassMethod Test()
{
	// w ##class(ALVA.ISY.ISYZastavky.API.Vyhledavac).Test()
	//d ..PreplnitTestovaciData()
	//
	s p("Datum")=$zdh("10/07/2020",4)
	s p("CasOdjezd")=$zth("05:00:00")
	s p("Prestupy")=1 //pocet ... -1=neomezeno
	s odkud="38133"
	s kam="41994"
	
	d ..GetSys(.sys)
	k arr
 	s arr("PAR","skupinaId")=10
	s arr("PAR","horlogOdDo")=$lb(p("Datum")-1,p("Datum")+1)
	s arr("GLB")="^ALVA.ISY.Vyhledavac"
	d ##class(ALVA.ISY.ISYZastavky.API.Vyhledavac).NaplnitData(.sys,.arr)
	
	d ..Hledej2(odkud,kam,.p,.v)
	m cesty=v("Cesty")
	
	q $$$OK
		
	w "----- Parametry -----"
	w !,"Odkud: "_odkud
	w !,"Kam: "_kam
	w !,"----- Cesta -----"
	w !
	zw cesty
	w "----- Stav -----"
	w !
	q "OK"
}

ClassMethod tstNaplnitData()
{
	//d ##class(ALVA.ISY.ISYZastavky.API.Vyhledavac).tstNaplnitData()
	d ..GetSys(.sys)
 	k arr 
 	s arr("PAR","skupinaId")=132
 	s horlogOd=##class(ALVA.GENERALAPI.Date).DateToHor("1.10.2024")
 	s horlogDo=##class(ALVA.GENERALAPI.Date).DateToHor("2.10.2024")
	s arr("PAR","horlogOdDo")=$lb(horlogOd,horlogDo)
	s arr("GLB")="^ALVA.ISY.Vyhledavac"
	d ..NaplnitData(.sys,.arr)
}

ClassMethod NaplnitData(ByRef sys As %String, ByRef arr As %String) As %String
{
	//naplni data pro vyhledavani
	// ------ Data pro hledani ------
	// Podle a aktualni zastavky ci nactu dalsi zastavku
	// 	spojId - nemusi to byt nutne jen id spoje, jde o to poznat, kdy jsem prestoupil
	//s ^ALVA.ISY.Vyhledavac("Z",zastavkaId,"D",datumOdjezduHrl,"C",casOdjezduHrl,"I",index)=$lb(cilovaZastavkaId,datumPrijezduHrl,casPrijezduHrl,linkaId,spojId) 
	//
	//IN
	//arr("PAR","skupinaId")=skupinaId , odkud nacitat data linek
	//arr("PAR","horlogOdDo")=$lb(horlogOd,horlogDo)
	//arr("GLB")="^www", global, kam naplnit data
	//
	$$$FillParams
	$$$TMPGLBSET(tmpglbstatistika)
	s skupinaId=$g(arr("PAR","skupinaId"))
	s horlogOd=$lg($g(arr("PAR","horlogOdDo")),1)
	s horlogDo=$lg($g(arr("PAR","horlogOdDo")),2) i 'horlogDo s horlogDo=horlogOd
	s glb=$g(arr("GLB")) k @glb
	//
	//statistika linek a nastaveni spoju
	k tmpArr s tmpArr("PAR","horlogOdDo")=$lb(horlogOd,horlogDo) s tmpArr("GLB")=$name(@tmpglbstatistika@("CAL"))
	d ##class(ALVA.ISY.ISYOmezeni.API.DopravniKalendar).nacti(.sys,.tmpArr)
	k arrLst d ##class(ALVA.ISY.ISYLinky.API.Linky).seznamSkupina(.sys,skupinaId,.arrLst)
	s linkaId="" f {
		s linkaId=$o(arrLst("DTA",linkaId)) i linkaId="" q
		k tmpArr
		s tmpArr("PAR","horlogOdDo")=$lb(horlogOd,horlogDo)
		s tmpArr("PAR","platnostLin")=1
		s tmpArr("GLB")=$name(@tmpglbstatistika)
		d ##class(ALVA.ISY.ISYLinky.API.LinkyStatistika).jede(.sys,$lb(skupinaId,"",linkaId),,.tmpArr)
		k arrDtaLinka d ##class(ALVA.ISY.ISYLinky.API.Linky).nacti(.sys,$lb(skupinaId,"",linkaId),"",.arrDtaLinka)
		s cisloDleLicence=$lg($g(arrDtaLinka("DTA")),1)
		k arrDtaTrasa d ##class(ALVA.ISY.ISYLinky.API.LinkyTrasa).nacti(.sys,$lb(skupinaId,"",linkaId),"",.arrDtaTrasa)
		s smerId="" f {
			s smerId=$o(@tmpglbstatistika@("DTA",smerId)) i smerId="" q
			s parSmer=1 i smerId=1 s parSmer=-1
			s spojId="" f {
				s valDB=""  s spojId=$o(@tmpglbstatistika@("DTA",smerId,spojId),1,valDB) i spojId="" q
				s spojJede=$lg(valDB,1) s spojHorlogOd=$lg(valDB,2) s spojBitMap=$lg(valDB,3)
				i 'spojJede continue
				//nactu data spoje
				k arrDtaSpoj d ##class(ALVA.ISY.ISYLinky.API.LinkySpoje).nacti(.sys,$lb(skupinaId,"",linkaId,smerId,spojId),,.arrDtaSpoj)
				s memZastavkaId="" s memZastavkaNazev="" s memCasPrijezd="" s memCasCeka=""
				s bodId="" f {
					s val="" s bodId=$o(arrDtaSpoj("DTA","trasa",bodId),parSmer,val) i bodId="" q
					s casPrijezd=$lg(val,1) s casCeka=$lg(val,2)
					i casPrijezd="|" continue
					i casPrijezd="<" continue
					s val=$g(arrDtaTrasa("DTA",bodId))
					s zastavkaId=$lg(val,1) i 'zastavkaId continue
					k arrDtaZastavka d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaId,"",.arrDtaZastavka)
					s arrDtaZastavka("DTA")=$g(arrDtaZastavka("DTA"))
					s zastavkaNazev=$lg(arrDtaZastavka("DTA"),1)_","_$lg(arrDtaZastavka("DTA"),2)_","_$lg(arrDtaZastavka("DTA"),3)_"/"_$lg(arrDtaZastavka("DTA"),4)
					i memZastavkaId {
						f cnt=1:1:$l(spojBitMap) {
							//jede
							i $e(spojBitMap,cnt) {
								s hrl=(spojHorlogOd+cnt-1)
								s hrlUsekOd=(hrl+((memCasPrijezd+memCasCeka)\1440))
	     						s hrlUsekDo=(hrl+(casPrijezd\1440))
	     						//s ^[dataDB]KDZ.JR.TEST.DATA("Z",zastavkaId,"D",datumOdjezduHrl,"C",casOdjezduHrl,"I",index)=$lb(cilovaZastavkaId,datumPrijezduHrl,casPrijezduHrl,linkaId,spojId) 
	     						s val=$lb(zastavkaId,hrlUsekDo,((casPrijezd#1440)*60),cisloDleLicence,spojId)
	     						s idx=$i(@glb@("Z",memZastavkaId,"D",hrlUsekOd,"C",(((memCasPrijezd+memCasCeka)#1440)*60),"I"))
	     						s @glb@("Z",memZastavkaId,"D",hrlUsekOd,"C",(((memCasPrijezd+memCasCeka)#1440)*60),"I",idx)=val
							}
						}	
					}
					s memZastavkaId=zastavkaId
					s memZastavkaNazev=zastavkaNazev
					s memCasPrijezd=casPrijezd
					s memCasCeka=casCeka
					}	
				}
			}
		}
  	k @tmpglbstatistika
	q $$$OK
}

/// --------- Popis ---------
/// Vrati odhadovany cas jizdy ze zastavky odkudZastavkaId do kamZastavkaId (neco jako vzdalenost*prumRychlost v sekundach, abych zachoval miru)
/// Pozor, musi to byt monotoni heuristika, jinak dfs nebude fungovat
ClassMethod VratHeuristickyCasJizdy(odkudZastavkaId, kamZastavkaId)
{
	q 0
}

/// --------- Popis ---------
/// Vrati zastavky, do kterych to jede z dane zastavky od nejakeho casu dale
ClassMethod VratNasledniky(zastavkaId, parametry, ByRef naslednici)
{
	s casOdjezd=$g(parametry("CasOdjezd"))
	s maxCasOdjezd=$g(parametry("MaxCasOdjezd"))
	s casOdjezdIn=casOdjezd
	s datum=$g(parametry("Datum"))

	s casOdjezd=casOdjezd-1
	f{
		s casOdjezd=$o(^ALVA.ISY.Vyhledavac("Z",zastavkaId,"D",datum,"C",casOdjezd)) q:casOdjezd=""
		i casOdjezd>maxCasOdjezd q
		
		s i=""
		f{
			s i=$o(^ALVA.ISY.Vyhledavac("Z",zastavkaId,"D",datum,"C",casOdjezd,"I",i),1,zastavkaLb) q:i=""
			s naslednikId=$lg(zastavkaLb,1)
			s casPrijezd=$lg(zastavkaLb,3)
			s linkaId=$lg(zastavkaLb,4)
			s spojId=$lg(zastavkaLb,5)
			// casOdjezd - cas odjezdu z zastavkaId do naslednikId
			// casPrijezd - cas prijezdu do naslednikId
			// datum - datum odjezdu
			s dobaPrejezdu=casPrijezd-casOdjezdIn
			s naslednici(casPrijezd,naslednikId,linkaId,spojId)=$lb(casPrijezd,casOdjezd,casPrijezd,datum)
		}
	}
	
	q $$$OK
}

/// --------- Popis ---------
/// Vyhleda trasu v jizdnim radu z dane zastavky do cislove a podle nastavenych parametru
/// Implementace relaxacniho algoritmu A*
/// --------- Vstup ---------
/// odkudZastavkaId: id zastavky, odkud se jede
/// kamZastavkaId id zastavky, kam se jede
/// parametry("CasOdjezd"): cas odjezdu
/// parametry("Datum"): datum
/// parametry("Prestupy"): Maximalni pocet prestupu (-1=neomezeno) ... pri pouziti nejlepe iterovat 1,2,3...
/// --------- Vystup ---------
/// vystup("Cesta"): seznam zastavek, po kterych vede trasa indexovany vzdy predchozi zastavkou
/// vystup("Cesta",cilovaZastavka)=predchoziZastavka
/// --------- Poznamky ---------
///  - Zatim hleda nejkratsi cestu do vsech vrcholu, pokud by to bylo nejak obludne pomale, muze se to omezit
///  - Doplnit heuristiku jako vzdalenost
ClassMethod Hledej(odkudZastavkaId, kamZastavkaId, parametry, ByRef vystup)
{
	
	// Nactu vstup
	s casOdjezd=$g(parametry("CasOdjezd"))
	s datum=$g(parametry("Datum"))
	s prestupyMax=$g(parametry("Prestupy")) i prestupyMax="" s prestupyMax=-1
	
	// 		cesty(zastavkaId,linkaId,spojId)=$lb(
	// #1		predchudceZastavkaId (predchudce, ze ktereho se dostanu do zastavkaId),										
	// #2		dobaJizdy (doba jizdy do zastavkaId z odkudZastavkaId),
	// #3		pocetPrestupu (pocet prestupu do zastavkaId z odkudZastavkaId)
	// #4		linkaId (id linky)
	// #5		spojId (id spoje)
	// #6		casOdjezd - cas odjezdu ze zastavky
	// #7		casPrijzed - cas prijezdu do naslednika
	// #8		datum - datum odjezdu ze zastavky
	// 		)
	k cesty
	s cesty(odkudZastavkaId,0,0)=$lb("",0,0,"","")

	// priorFronta(dobaJizdy,zastavkaId,linkaId,spojId)=
	k priorFronta
	s priorFronta(0,odkudZastavkaId,0,0)=""
			
	// Dokud jsou nejake otevrene vrcholy
	while $d(priorFronta){ 
		
		// Vezmu nejblizsi zastavku z priorFronty
		s minDobaJizdy=$o(priorFronta(""))
		s zastavkaId=$o(priorFronta(minDobaJizdy,""))
		s zastavkaLinkaId=$o(priorFronta(minDobaJizdy,zastavkaId,""))		
		s zastavkaSpojId=$o(priorFronta(minDobaJizdy,zastavkaId,zastavkaLinkaId,""))		
		
		//zw priorFronta
		//w "Zastavka: "_zastavkaId_" | Linka: "_zastavkaLinkaId_" | Spoj: "_zastavkaSpojId,!
		
		// Odeberu zastavku z priorFronty	
		k priorFronta(minDobaJizdy,zastavkaId,zastavkaLinkaId,zastavkaSpojId)
		
		// Info o zastavce - doba jizdy, pocet prestupu do zastavky
		s zastavkaDobaJizdy=$lg(cesty(zastavkaId,zastavkaLinkaId,zastavkaSpojId),2)
		s zastavkaPocetPrestupu=$lg(cesty(zastavkaId,zastavkaLinkaId,zastavkaSpojId),3)
		
		// Pokud uz jsem nasel kratsi cestu, nema smysl znovu prohledavat nasledniky (byl jsem tam driv, takze vsechny nasledujici uz jsem stejne nasel).
		// Asi ... kdyby to nefungovalo, tady muze byt problem
		i minDobaJizdy>zastavkaDobaJizdy continue
		
		// Nactu nasledniky, tj. zastavky, do kterych to z te aktulani jede (v nejake 'rozumne blizke' budoucnosti)
		// naslednici(casOdjezdDoNaslednika,naslednikId,naslednikLinkaId,naslednikSpojId)=$lb(dobaJizdyDoNaslednika)
		k nasledniciParametry,naslednici
		s nasledniciParametry("CasOdjezd")=casOdjezd+$lg(cesty(zastavkaId,zastavkaLinkaId,zastavkaSpojId),2) // Odjezd ze zastavky od doby prijezdu
		s nasledniciParametry("Datum")=datum
		d ..VratNasledniky(zastavkaId,.nasledniciParametry,.naslednici)
		
	
		//w "Zastavka: "_zastavkaId_" ... "_"Naslednik: "_naslednikId_" ... ."_"doNaslednikaVedeCestaSMenePrestupy: "_doNaslednikaVedeCestaSMenePrestupy,!
		
		// Projdu nasledniky od nejblizsiho
		s naslednikCasPrijezd=""
		f{
			s naslednikCasPrijezd=$o(naslednici(naslednikCasPrijezd)) q:naslednikCasPrijezd=""
			s naslednikId=""
			f{
				s naslednikId=$o(naslednici(naslednikCasPrijezd,naslednikId)) q:naslednikId=""
				s naslednikLinkaId=""
				f{
					s naslednikLinkaId=$o(naslednici(naslednikCasPrijezd,naslednikId,naslednikLinkaId)) q:naslednikLinkaId=""
					s naslednikSpojId=""
					f{
						s naslednikSpojId=$o(naslednici(naslednikCasPrijezd,naslednikId,naslednikLinkaId,naslednikSpojId)) q:naslednikSpojId=""
						
						s naslednik=naslednici(naslednikCasPrijezd,naslednikId,naslednikLinkaId,naslednikSpojId)
						
						// Info o naslednikovi - doba jizdy, pocet prestupu
						s naslednikCasPrijezduAktualni=+$lg($g(cesty(naslednikId,naslednikLinkaId,naslednikSpojId),$lb()),2)
						s naslednikPocetPrestupuAktualni=+$lg($g(cesty(naslednikId,naslednikLinkaId,naslednikSpojId),$lb()),3)
						
						// Info o ceste mezi aktulani zastavkou a naslednikem
						// Doba prejezdu mezi aktualni zastavkou a jejim naslednikem
						s naslednikLb=naslednici(naslednikCasPrijezd,naslednikId,naslednikLinkaId,naslednikSpojId)		
						s naslednikCasPrijezduNovy=$lg(naslednikLb,1)
						//s naslednikDobaJizdyNova=zastavkaDobaJizdy+naslednikDobaPrejezdu
						
						// Overim, zda do naslednika prestupuji (tj. meni se linka nebo spoj)
						s naslednikNovyPocetPrestupu=zastavkaPocetPrestupu
						i (+zastavkaLinkaId'=0)&&(+zastavkaSpojId'=0)&&((zastavkaLinkaId'=naslednikLinkaId)||(zastavkaSpojId'=naslednikSpojId)){ 
							s naslednikNovyPocetPrestupu=zastavkaPocetPrestupu+1
													
							// Pokud je prestupu moc, naslednika ignoruji
							i prestupyMax>-1,naslednikNovyPocetPrestupu>prestupyMax continue
						}
						
						// Priznaky pro relaxaci
						s vNaslednikoviJsemJesteNebyl=('$d(cesty(naslednikId,naslednikLinkaId,naslednikSpojId)))
						s doNaslednikaVedeKratsiCesta=(naslednikCasPrijezduAktualni>naslednikCasPrijezduNovy)
						// TODO: mozna se jeste bude hodit
						s doNaslednikaVedeCestaSMenePrestupy=0 //(naslednikPocetPrestupu>naslednikNovyPocetPrestupu)
					
						// Relaxace (pokud jsem v naslednikovi jeste nebyl nebo nasel kratsi cestu -> relaxuju, tj. zkratim cestu)
						i (vNaslednikoviJsemJesteNebyl||doNaslednikaVedeKratsiCesta||doNaslednikaVedeCestaSMenePrestupy){
							// Pridam naslednika do seznamu cest
							i '$d(cesty(naslednikId,naslednikLinkaId,naslednikSpojId)){
								s cesty(naslednikId,naslednikLinkaId,naslednikSpojId)=$lb()
							} 
							
							// Nastavim naslednikovi aktualni zastavku jako predchudce
							s $li(cesty(naslednikId,naslednikLinkaId,naslednikSpojId),1)=zastavkaId
							
							// Spoctu novou vzdalenost
							
							s $li(cesty(naslednikId,naslednikLinkaId,naslednikSpojId),2)=naslednikCasPrijezduNovy
							
							// Pripocitam prestup
							s $li(cesty(naslednikId,naslednikLinkaId,naslednikSpojId),3)=naslednikNovyPocetPrestupu
							
							// Nastavim naslednikovi po jake lince a jakem spoji se do nej dostanu
							s $li(cesty(naslednikId,naslednikLinkaId,naslednikSpojId),4)=zastavkaLinkaId
							s $li(cesty(naslednikId,naslednikLinkaId,naslednikSpojId),5)=zastavkaSpojId
							
							// Cas prijezdu a odjezdu
							s $li(cesty(naslednikId,naslednikLinkaId,naslednikSpojId),6)=$lg(naslednik,2) // Cas odjezdu ze zastavkaId do naslednikId
							s $li(cesty(naslednikId,naslednikLinkaId,naslednikSpojId),7)=$lg(naslednik,3) // Cas prijezdu do naslednikId
							s $li(cesty(naslednikId,naslednikLinkaId,naslednikSpojId),8)=$lg(naslednik,4) // Datum odjezdu ze zastavkaId do naslednikId
							
							// K casu jizdy do naslednika prictu predpokladanou dobu jizdy z naslednika do cile
							//s naslednikDobaJizdyNova=naslednikDobaJizdyNova+..VratHeuristickyCasJizdy(naslednikId,kamZastavkaId)
							
							// Zaradim naslednika do priorFronty
							s priorFronta(naslednikCasPrijezd,naslednikId,naslednikLinkaId,naslednikSpojId)=""
							
							//zw cesty
						} 		
					}
				}
			}		
		}
	}

	// Vytvorim cestu ze seznamu predchudcu
	i $d(cesty(kamZastavkaId)){
		s zastavkaKamLinkaId=$o(cesty(kamZastavkaId,""))
		s zastavkaKamSpojId=$o(cesty(kamZastavkaId,zastavkaKamLinkaId,""))
		
		// cesta(i)=$lb(zastavkaId, pocetPrestupu, linkaId, spojId, casPrijezd, casOdjezd)
		
		s i=0, zastavkaId=kamZastavkaId, linkaId=zastavkaKamLinkaId, spojId=zastavkaKamSpojId
		s zastavkaLb=cesty(kamZastavkaId,zastavkaKamLinkaId,zastavkaKamSpojId)
		s cesta(-$i(i))=$lb(kamZastavkaId,$lg(zastavkaLb,3),$lg(zastavkaLb,4),$lg(zastavkaLb,5),"","")
		
		// Postavim cestu pozpatku
		s casPrijezd=""
		f{
			s zastavkaLb=cesty(zastavkaId,linkaId,spojId) 
			s zastavkaId=$lg(zastavkaLb,1) q:zastavkaId=""
			s linkaId=$lg(zastavkaLb,4)
			s spojId=$lg(zastavkaLb,5)
			s casOdjezd=$lg(zastavkaLb,6) // cas odjezdu ze zastavkaId
			s casPrijezdDoNaslednika=$lg(zastavkaLb,7) // prijezd do naslednika
			s datumOdjezd=$lg(zastavkaLb,8) // datum odjezdu ze zastavkaId
			
			// Cas prijezdu do naslednika
			s $li(cesta((-i)),5)=casPrijezdDoNaslednika
			
			// Zastavka
			s cesta(-$i(i))=$lb(zastavkaId,$lg(cesty(zastavkaId,linkaId,spojId),3),linkaId,spojId,"",casOdjezd,datumOdjezd)
		}
		
		// Nastavim spoj a linka prvni zastavky
		s prvniZastavka=$o(cesta(""))
		s $li(cesta(prvniZastavka),3)=$lg(cesta(prvniZastavka+1),3)
		s $li(cesta(prvniZastavka),4)=$lg(cesta(prvniZastavka+1),4)
		
		// Precisluju
		s i=""
		f{
			s i=$o(cesta(i)) q:i>0
			s cesta($i(j))=cesta(i)
			k cesta(i)
		}
	} else{
		s cesta=""
	}

	
	m vystup("Cesta")=cesta
	
	q $$$OK
}

/// --------- Popis ---------
/// Vyhleda trasu v jizdnim radu z dane zastavky do cislove a podle nastavenych parametru
/// Implementace relaxacniho algoritmu A*
/// --------- Vstup ---------
/// odkudZastavkaId: id zastavky, odkud se jede
/// kamZastavkaId id zastavky, kam se jede
/// parametry("CasOdjezd"): cas odjezdu
/// parametry("Datum"): datum
/// parametry("Prestupy"): Maximalni pocet prestupu (-1=neomezeno) ... pri pouziti nejlepe iterovat 1,2,3...
/// --------- Vystup ---------
/// vystup("Cesta"): seznam zastavek, po kterych vede trasa indexovany vzdy predchozi zastavkou
/// vystup("Cesta",cilovaZastavka)=predchoziZastavka
/// --------- Poznamky ---------
///  - Zatim hleda nejkratsi cestu do vsech vrcholu, pokud by to bylo nejak obludne pomale, muze se to omezit
///  - Doplnit heuristiku jako vzdalenost
ClassMethod Hledej2(odkudZastavkaId, kamZastavkaId, parametry, ByRef vystup)
{
	
	// Nactu vstup
	s casOdjezdOd=$g(parametry("CasOdjezd"))
	s maxCekaniMinut=$g(parametry("MaxCekaniMinut")) i +maxCekaniMinut=0 s maxCekaniMinut=60
	s datum=$g(parametry("Datum"))
	s prestupyMax=$g(parametry("Prestupy")) i prestupyMax="" s prestupyMax=-1
	
	// 		cesty(zastavkaId,linkaId,spojId)=$lb(
	// #1		predchudceZastavkaId (predchudce, ze ktereho se dostanu do zastavkaId),									
	// #2		pocetPrestupu (pocet prestupu do zastavkaId z odkudZastavkaId)
	// #3		linkaId (id linky)
	// #4		spojId (id spoje)
	// #5		casOdjezd - cas odjezdu ze zastavky
	// #6		casPrijzed - cas prijezdu do naslednika
	// #7		datum - datum odjezdu ze zastavky
	// 		)
	k cesty
	s cesty(odkudZastavkaId,0,0)=$lb("",0,0,"","",casOdjezdOd)

	// priorFronta(casPrijezdu,zastavkaId,linkaId,spojId)=
	k priorFronta
	s priorFronta(casOdjezdOd,odkudZastavkaId,0,0)=""
			
	// Dokud jsou nejake otevrene vrcholy
	while $d(priorFronta){ 
		
		// Vezmu nejblizsi zastavku z priorFronty
		s zastavkaCasPrijezd=$o(priorFronta(""))
		s zastavkaId=$o(priorFronta(zastavkaCasPrijezd,""))
		s zastavkaLinkaId=$o(priorFronta(zastavkaCasPrijezd,zastavkaId,""))		
		s zastavkaSpojId=$o(priorFronta(zastavkaCasPrijezd,zastavkaId,zastavkaLinkaId,""))		
				
		// Odeberu zastavku z priorFronty	
		k priorFronta(zastavkaCasPrijezd,zastavkaId,zastavkaLinkaId,zastavkaSpojId)
		
		// Info o zastavce - doba jizdy, pocet prestupu do zastavky
		s zastavkaPocetPrestupu=$lg(cesty(zastavkaId,zastavkaLinkaId,zastavkaSpojId),2)
		
		// Nactu nasledniky, tj. zastavky, do kterych to z te aktulani jede (v nejake 'rozumne blizke' budoucnosti)
		k nasledniciParametry,naslednici
		s nasledniciParametry("CasOdjezd")=zastavkaCasPrijezd // Odjezd ze zastavky od doby prijezdu
		s nasledniciParametry("Datum")=datum
		s nasledniciParametry("MaxCasOdjezd")=zastavkaCasPrijezd+(maxCekaniMinut*60)
		d ..VratNasledniky(zastavkaId,.nasledniciParametry,.naslednici)
		
		// Projdu nasledniky od nejblizsiho
		s naslednikCasPrijezd=""
		f{
			s naslednikCasPrijezd=$o(naslednici(naslednikCasPrijezd)) q:naslednikCasPrijezd=""
			s naslednikId=""
			f{
				s naslednikId=$o(naslednici(naslednikCasPrijezd,naslednikId)) q:naslednikId=""
				s naslednikLinkaId=""
				f{
					s naslednikLinkaId=$o(naslednici(naslednikCasPrijezd,naslednikId,naslednikLinkaId)) q:naslednikLinkaId=""
					s naslednikSpojId=""
					f{
						s naslednikSpojId=$o(naslednici(naslednikCasPrijezd,naslednikId,naslednikLinkaId,naslednikSpojId)) q:naslednikSpojId=""
						
						s naslednik=naslednici(naslednikCasPrijezd,naslednikId,naslednikLinkaId,naslednikSpojId)
						
						// Aktulani nejlepsi cas prijezdu do naslednika
						s naslednikPocetPrestupuAkt=+$lg($g(cesty(naslednikId,naslednikLinkaId,naslednikSpojId),$lb()),2)
						s naslednikCasPrijezdAkt=+$lg($g(cesty(naslednikId,naslednikLinkaId,naslednikSpojId),$lb()),6)
						
						// Overim, zda do naslednika prestupuji (tj. meni se linka nebo spoj)
						s naslednikPocetPrestupuNovy=zastavkaPocetPrestupu
						i (+zastavkaLinkaId'=0)&&(+zastavkaSpojId'=0)&&((zastavkaLinkaId'=naslednikLinkaId)||(zastavkaSpojId'=naslednikSpojId)){ 
							s naslednikPocetPrestupuNovy=zastavkaPocetPrestupu+1
													
							// Pokud je prestupu moc, naslednika ignoruji
							i prestupyMax>-1,naslednikPocetPrestupuNovy>prestupyMax continue
						}

						// Priznaky pro relaxaci
						s vNaslednikoviJsemJesteNebyl=('$d(cesty(naslednikId,naslednikLinkaId,naslednikSpojId))) //
						s doNaslednikaVedeKratsiCesta=(naslednikCasPrijezdAkt>naslednikCasPrijezd)
						// TODO: mozna se jeste bude hodit
						s doNaslednikaVedeCestaSMenePrestupy=0 //(naslednikPocetPrestupuAkt>naslednikPocetPrestupuNovy)
					
						// Relaxace (pokud jsem v naslednikovi jeste nebyl nebo nasel kratsi cestu -> relaxuju, tj. zkratim cestu)
						i (vNaslednikoviJsemJesteNebyl||doNaslednikaVedeKratsiCesta||doNaslednikaVedeCestaSMenePrestupy){
							// Pridam naslednika do seznamu cest
							s cesty(naslednikId,naslednikLinkaId,naslednikSpojId)=$lb()
							
							// Nastavim naslednikovi aktualni zastavku jako predchudce
							s $li(cesty(naslednikId,naslednikLinkaId,naslednikSpojId),1)=zastavkaId
							
							// Pripocitam prestup
							s $li(cesty(naslednikId,naslednikLinkaId,naslednikSpojId),2)=naslednikPocetPrestupuNovy
							
							// Nastavim naslednikovi po jake lince a jakem spoji se do nej dostanu
							s $li(cesty(naslednikId,naslednikLinkaId,naslednikSpojId),3)=zastavkaLinkaId
							s $li(cesty(naslednikId,naslednikLinkaId,naslednikSpojId),4)=zastavkaSpojId
							
							// Cas prijezdu a odjezdu
							s $li(cesty(naslednikId,naslednikLinkaId,naslednikSpojId),5)=$lg(naslednik,2) // Cas odjezdu ze zastavkaId do naslednikId
							s $li(cesty(naslednikId,naslednikLinkaId,naslednikSpojId),6)=$lg(naslednik,3) // Cas prijezdu do naslednikId
							s $li(cesty(naslednikId,naslednikLinkaId,naslednikSpojId),7)=$lg(naslednik,4) // Datum odjezdu ze zastavkaId do naslednikId
							
							// K casu jizdy do naslednika prictu predpokladanou dobu jizdy z naslednika do cile
							//s naslednikDobaJizdyNova=naslednikDobaJizdyNova+..VratHeuristickyCasJizdy(naslednikId,kamZastavkaId)
							
							// Zaradim naslednika do priorFronty
							s priorFronta(naslednikCasPrijezd,naslednikId,naslednikLinkaId,naslednikSpojId)=""
							
							//zw cesty
						} 		
					}
				}
			}		
		}
	}

	// Vytvorim cestu ze seznamu predchudcu
	
	i $d(cesty(kamZastavkaId)){
		
		s zastavkaKamLinkaId=""
		f{
			s zastavkaKamLinkaId=$o(cesty(kamZastavkaId,zastavkaKamLinkaId)) q:zastavkaKamLinkaId=""
			s zastavkaKamSpojId=""
			f{
				s zastavkaKamSpojId=$o(cesty(kamZastavkaId,zastavkaKamLinkaId,zastavkaKamSpojId)) q:zastavkaKamSpojId=""
			
				// cesta(i)=$lb(zastavkaId, pocetPrestupu, linkaId, spojId, casPrijezd, casOdjezd)
				k cesta
				s i=0, zastavkaId=kamZastavkaId, linkaId=zastavkaKamLinkaId, spojId=zastavkaKamSpojId
				s zastavkaLb=cesty(kamZastavkaId,zastavkaKamLinkaId,zastavkaKamSpojId)
				s cesta(-$i(i))=$lb(kamZastavkaId,$lg(zastavkaLb,2),linkaId,spojId,"","")
				
				// Postavim cestu pozpatku
				s casPrijezd=""
				f{
					s zastavkaLb=cesty(zastavkaId,linkaId,spojId) 
					s zastavkaId=$lg(zastavkaLb,1) q:zastavkaId=""
					s pocetPrestupu=$lg(zastavkaLb,2)
					s linkaId=$lg(zastavkaLb,3)
					s spojId=$lg(zastavkaLb,4)
					s casOdjezd=$lg(zastavkaLb,5) // cas odjezdu ze zastavkaId
					s casPrijezdDoNaslednika=$lg(zastavkaLb,6) // prijezd do naslednika
					s datumOdjezd=$lg(zastavkaLb,7) // datum odjezdu ze zastavkaId
					
					// Cas prijezdu do naslednika
					s $li(cesta((-i)),5)=casPrijezdDoNaslednika
					
					// Zastavka
					s cesta(-$i(i))=$lb(zastavkaId,pocetPrestupu,linkaId,spojId,"",casOdjezd,datumOdjezd)
				}
				
				// Nastavim spoj a linka prvni zastavky
				s prvniZastavka=$o(cesta(""))
				s odjezdZPrvniZastavky=$lg(cesta(prvniZastavka),6)
				s $li(cesta(prvniZastavka),3)=$lg(cesta(prvniZastavka+1),3)
				s $li(cesta(prvniZastavka),4)=$lg(cesta(prvniZastavka+1),4)
								
				// Precisluju
				s i=""
				f{
					s i=$o(cesta(i)) q:i>0
					s cesta($i(j))=cesta(i)
					k cesta(i)
				}
				
				
				//i $d(vystup("Cesty",odjezdZPrvniZastavky)) continue
				m vystup("Cesty",odjezdZPrvniZastavky,$i(c))=cesta
			}
		}
		
		k ^dz
		m ^dz=cesty(kamZastavkaId)
	}
	q $$$OK
}

}
