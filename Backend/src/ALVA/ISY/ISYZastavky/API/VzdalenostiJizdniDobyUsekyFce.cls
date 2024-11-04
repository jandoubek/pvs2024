Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUsekyFce Extends %RegisteredObject
{

ClassMethod test()
{
	//d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUsekyFce).test()
	s sys("U","IdFa")="VS_CSAD"
    s sys("U","delimiter")=$c(0)
    s sys("U","SystemDB")="MLINE"
    s sys("C","User")=007
    s sys("U","DATA")="USER"
    s sys("U","MLP")=7
    s sys("U","fullName")="007"
    s sys("U","loginName")="007"
    s sys("C","GUID")=7
 	k arr s arr("PAR","casovaVariantaHorlog")=##class(ALVA.GENERALAPI.Date).DateToHor("1.1.2000")
 	d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUsekyFce).ImportLinky(.sys,$lb(1,10),.arr)
}

ClassMethod test1()
{
	//d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUsekyFce).test1()
	s sys("U","IdFa")="VS_CSAD"
    s sys("U","delimiter")=$c(0)
    s sys("U","SystemDB")="MLINE"
    s sys("C","User")=007
    s sys("U","DATA")="USER"
    s sys("U","MLP")=7
    s sys("U","fullName")="007"
    s sys("U","loginName")="007"
    s sys("C","GUID")=7
    s id=$lb("6",66454,"5000758","","5000060","")
 	k arr s arr("PAR","rozvrhPasemJizdniDoby")=$lb(2,612)
 	d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUsekyFce).VzdalenostJizdniDoba(.sys,id,"",.arr) zw arr
}

ClassMethod VzdalenostJizdniDoba(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	$$$FillParams
	//vrati vzdalenost a jizdni dobu pro usek
	//IN
	//        1                       2      3            4            5            6
	// id=$lb(vzdalenostiJizdniDobyId,horlog,zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId)
	// vzdalenostiJizdniDobyId - varianta vzdalenosti a jizdnich dob 
	// horlog - datum pro dohledani casove varianty vzdalenosti
	// zastavkaOdId,oznacnikOdId - bod od
	// zastavkaDoId,oznacnikDoId - bod do
	// dGlb = global, kde jsou data vzdalenosti nahrany zastavky tak, jak jsou ulozeny v databazi (co vraci DBDoGLB u VzdalenostiJizdniDoby) + v id nemusi byt vzdalenostiJizdniDobyId
	// arr("PAR","rozvrhPasemJizdniDoby")=$lb(rozvrhPasemJizdniDobyId,casMin) - upresneni pro dohledani podle pasem a provozu
	// rozvrhPasemJizdniDobyId - definice royvrhu pasem jizdni doby 
	// casMin - cas odjezdu pro dohledani doby jizdy dle casoveho pasma
	//
	//OUT
	//                 1                  2                    3                    4
	//  arr("DTA")=$lb(vzdalenostPresnaKm,zakladniDobaJizdyMin,dobaJizdyDlePasmaMin,vzdalenostTarifniKm)
	//  arr("STT")=0 / usek v databazi nebyl nalezen / 1 usek v databazi byl nalezen presne (zastavka+oznacnik) / 2 usek v databazi byl nalezen nepresne (chybi oznacnik)
	//
	//IN
	s id=$g(id) s dGlb=$g(dGlb) k arr("DTA") k arr("STT") s arr("STT")=0
	//
	s vzdalenostiJizdniDobyId=$lg(id,1)
	s horlog=$lg(id,2) i 'horlog s horlog=+$h
	s zastavkaOdId=$lg(id,3)
	s oznacnikOdId=+$lg(id,4)
	s zastavkaDoId=$lg(id,5)
	s oznacnikDoId=+$lg(id,6)
	//
	s val=$g(arr("PAR","rozvrhPasemJizdniDoby"))
	s rozvrhPasemJizdniDobyId=$lg(val,1)
	s casMin=$lg(val,2)
	//
	s vzdalenostKm="" s zakladniDobaJizdyMin="" s dobaJizdyDlePasmaMin=""
	//
	i dGlb="" s dGlb=$name(^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId))
	//
	//dohledam usek
	s usekId=""
	i vzdalenostiJizdniDobyId&zastavkaOdId&zastavkaDoId {
		//kompletni usek
		s usekId=$g(@dGlb@("useky","IDX",1,zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId))
		//castecny usek
		i 'usekId {
			f myIDXOd=3,2 {
				i usekId continue
				s myUsekId="" f {
					i myIDXOd=3 s myUsekId=$o(@dGlb@("useky","IDX",myIDXOd,zastavkaOdId,oznacnikOdId,myUsekId)) i (myUsekId="")!(usekId) q
					i myIDXOd=2 s myUsekId=$o(@dGlb@("useky","IDX",myIDXOd,zastavkaOdId,myUsekId)) i (myUsekId="")!(usekId) q
					f myIDXDo=5,4 {
						i (myIDXDo=5)&($d(@dGlb@("useky","IDX",myIDXDo,zastavkaDoId,oznacnikDoId,myUsekId))) s usekId=myUsekId continue
						i (myIDXDo=4)&($d(@dGlb@("useky","IDX",myIDXDo,zastavkaDoId,myUsekId))) s usekId=myUsekId continue
						
					}
				}
			}
			i usekId {s arr("STT")=2}
		}
		else {
			s arr("STT")=1
		}
	}
	i usekId {
		k arrDtaUsek d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUseky).nacti(.sys,$lb(vzdalenostiJizdniDobyId,usekId),dGlb,.arrDtaUsek)
		s myHorlog=$o(arrDtaUsek("DTA","vzdalenostDoba","DTA",horlog+.01),-1)
		//i myHorlog="" s myHorlog=$o(arrDtaUsek("DTA","vzdalenostDoba","DTA",(horlog-.01)))
		i myHorlog {
			//zakladni udaje z useku
			s val=$g(arrDtaUsek("DTA","vzdalenostDoba","DTA",myHorlog))
			s vzdalenostPresna=$lg(val,1) s zakladniDobaJizdyMin=$lg(val,2) s vzdalenostTarifni=$lg(val,3)
			s vzdalenostPresnaKm=$j(vzdalenostPresna/1000,0,3)
			s vzdalenostTarifniKm=$j(vzdalenostTarifni/1000,0,0)
			//jizdni doba podle pasma
			i (+rozvrhPasemJizdniDobyId)&(casMin'="") {
				k arrDtaRozvrh d ##class(ALVA.ISY.ISYCiselniky.API.RozvrhPasemJizdniDoby).nacti(.sys,rozvrhPasemJizdniDobyId,.arrDtaRozvrh)
				s val="" s minOd=$o(arrDtaRozvrh("DTA","rozvrh",(casMin+.01)),-1,val)
				i val'="" {
					s pasmoJizdniDobyId=$lg(val,1)
					i pasmoJizdniDobyId'="" {
						s obvyklaRychlost=$lg($g(arrDtaRozvrh("DTA","obvyklaRychlost",pasmoJizdniDobyId)),1)
						s dobaJizdyDlePasmaMin=$lg($g(arrDtaUsek("DTA","vzdalenostDoba","DTA",myHorlog,"pasma","DTA",pasmoJizdniDobyId)),1)
						//pokud neni doba a je rychlost, dopocet
						i (dobaJizdyDlePasmaMin="")&(obvyklaRychlost) {
							s dobaJizdyDlePasmaMin=$j((vzdalenostPresnaKm/obvyklaRychlost)*60,0,0)
						}
					}
				}				
			}
		}
	}
	//out
	s arr("DTA")=$lb(vzdalenostPresnaKm,zakladniDobaJizdyMin,dobaJizdyDlePasmaMin,vzdalenostTarifniKm)
}

ClassMethod ImportLinky(ByRef sys As %String, id As %String, ByRef arr As %String)
{
	//import vzdalenosti z linek
	//
	//IN
	//        1                       2
	// id=$lb(vzdalenostiJizdniDobyId,skupinaId)
	// vzdalenostiJizdniDobyId - kam zapsat vzdalenosti 
	// skupinaId - odkud vzit linky pro vytvoreni vzdalenosti
	// arr("PAR","casovaVariantaHorlog")=horlog
	// horlog - horlog pro casovou variantu vzdalenosti
	// arr("PAR","typAktualizace")= 0 vsechny useky / 1 jen chybejici useky
	//
	// nastaveni pro vypocet jizdni doby pasma podle rychlosti
	// arr("PAR","podleRychlosti")=zakladniDobaJizdyRychlost
	// arr("PAR","podleRychlosti",pasmoJizdniDobaId)=pasmoJizdniDobaRychlost
	//
	//OUT
	//
	$$$FillParams
	$$$TMPGLBSET(tmpglbvzd)
	s id=$g(id) s vzdalenostiJizdniDobyId=$lg(id,1) s skupinaId=$lg(id,2)
	s horlog=$g(arr("PAR","casovaVariantaHorlog"))
	s zakladniDobaJizdyRychlost=$g(arr("PAR","podleRychlosti"))
	//ciselniky
	k arrCisCasovaPasmaJizdniDoby d ##class(ALVA.ISY.ISYCiselniky.API.CasovaPasmaJizdniDoby).seznam(.sys,.arrCisCasovaPasmaJizdniDoby)
	//
	k arrSeznamLinek d ##class(ALVA.ISY.ISYLinky.API.Linky).seznamSkupina(.sys,skupinaId,.arrSeznamLinek)
	s linkaId="" f {
		s linkaId=$o(arrSeznamLinek("DTA",linkaId)) i linkaId="" q
		k arrTrasa d ##class(ALVA.ISY.ISYLinky.API.LinkyTrasa).nacti(.sys,$lb(skupinaId,"",linkaId),"",.arrTrasa)
		k arrSeznamSpoju d ##class(ALVA.ISY.ISYLinky.API.LinkySpoje).seznam(.sys,$lb(skupinaId,"",linkaId),"",.arrSeznamSpoju)
		s smerId="" f {
			s smerId=$o(arrSeznamSpoju("DTA",smerId)) i smerId="" q
			s parSmer=1 i smerId=1 s parSmer=-1
			s spojId="" f {
				s spojId=$o(arrSeznamSpoju("DTA",smerId,spojId)) i spojId="" q
				k arrSpoj d ##class(ALVA.ISY.ISYLinky.API.LinkySpoje).nacti(.sys,$lb(skupinaId,"",linkaId,smerId,spojId),"",.arrSpoj)
				s memZastavkaId="" s memOznacnikId="" s memCas="" s memVzdalenostTarifni="" s memVzdalenostPresna=""
				s bodId="" f {
					s val="" s bodId=$o(arrSpoj("DTA","trasa",bodId),parSmer,val) i bodId="" q
					s casPrijezd=$lg(val,1)
					s casCeka=$lg(val,2)
					s vzdalenostTarifni=$lg(val,3)
					s vzdalenostPresna=$lg(val,4)
					s oznacnikId=$lg(val,13)
					//i casPrijezd="|" continue
					i casPrijezd="<" continue
					s val=$g(arrTrasa("DTA",bodId))
					s zastavkaId=$lg(val,1) i 'zastavkaId continue
					s oznacnik=$lg(val,13)
					i 'oznacnikId  s oznacnikId=$lg(oznacnik,1) i smerId=1 s oznacnikId=$lg(oznacnik,2)
					i memCas="" {
						s memZastavkaId=zastavkaId
						s memOznacnikId=oznacnikId
						s memCas=casPrijezd+casCeka
						s memVzdalenostTarifni=+vzdalenostTarifni
						s memVzdalenostPresna=+vzdalenostPresna
						continue
					}
					//tarifni je vzdy
					s vzdalenostTarifniUsek=vzdalenostTarifni-memVzdalenostTarifni
					//presna
					i vzdalenostPresna'="" {
						 s vzdalenostPresnaUsek=vzdalenostPresna-memVzdalenostPresna
					}
					else {
						 s vzdalenostPresnaUsek=vzdalenostTarifni-memVzdalenostTarifni
					}
					s casUsek=0 i (casPrijezd'="|")&(memCas'="|") {s casUsek=casPrijezd-memCas}
					//vzdalenost a doba jizdy
					s @tmpglbvzd@(1,memZastavkaId,+memOznacnikId,zastavkaId,+oznacnikId,+vzdalenostPresnaUsek)=$g(@tmpglbvzd@(1,memZastavkaId,+memOznacnikId,zastavkaId,+oznacnikId,+vzdalenostPresnaUsek))+1
					s @tmpglbvzd@(1,memZastavkaId,+memOznacnikId,zastavkaId,+oznacnikId,+vzdalenostPresnaUsek,1,+casUsek)=$g(@tmpglbvzd@(1,memZastavkaId,+memOznacnikId,zastavkaId,+oznacnikId,+vzdalenostPresnaUsek,1,+casUsek))+1
					s @tmpglbvzd@(1,memZastavkaId,+memOznacnikId,zastavkaId,+oznacnikId,+vzdalenostPresnaUsek,2,+vzdalenostTarifniUsek)=$g(@tmpglbvzd@(1,memZastavkaId,+memOznacnikId,zastavkaId,+oznacnikId,+vzdalenostPresnaUsek,2,+vzdalenostTarifniUsek))+1
					//
					s memZastavkaId=zastavkaId
					s memOznacnikId=oznacnikId
					i casPrijezd="|" {
						s memCas=casPrijezd
					}
					else {
						s memCas=casPrijezd+casCeka
					}
					s memVzdalenostTarifni=vzdalenostTarifni
					s memVzdalenostPresna=vzdalenostPresna
				}
			}	
		}
	}
	//prepis do databaze vzdalenosti
	s zastavkaOdId="" f {
		s zastavkaOdId=$o(@tmpglbvzd@(1,zastavkaOdId)) i zastavkaOdId="" q
		s oznacnikOdId="" f {
			s oznacnikOdId=$o(@tmpglbvzd@(1,zastavkaOdId,oznacnikOdId)) i oznacnikOdId="" q
			s zastavkaDoId="" f {
				s zastavkaDoId=$o(@tmpglbvzd@(1,zastavkaOdId,oznacnikOdId,zastavkaDoId)) i zastavkaDoId="" q
				s oznacnikDoId="" f {
					s oznacnikDoId=$o(@tmpglbvzd@(1,zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId)) i oznacnikDoId="" q
					s usekId=$g(^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId,"useky","IDX",1,zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId))
					//pouze nove useky, ne aktualizace
					i (+$g(arr("PAR","typAktualizace")))&(usekId) continue
					//vyhledam data s nejvetsim poctem vyskytu
					//presne km
					k myArr s myArr=0
					s vzdalenostPresnaUsek="" f {
						s cntVzdalenostPresnaUsek="" s vzdalenostPresnaUsek=$o(@tmpglbvzd@(1,zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId,vzdalenostPresnaUsek),1,cntVzdalenostPresnaUsek) i vzdalenostPresnaUsek="" q
						i cntVzdalenostPresnaUsek>myArr {
							k myArr
							m myArr(vzdalenostPresnaUsek)=@tmpglbvzd@(1,zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId,vzdalenostPresnaUsek)
							s myArr=cntVzdalenostPresnaUsek
						}
					}
					s vzdalenostPresnaUsek=$o(myArr(""))
					i vzdalenostPresnaUsek'="" {
						s myCasUsek="" s myCntCasUsek=""
						s casUsek="" f {
							s cntCasUsek="" s casUsek=$o(myArr(vzdalenostPresnaUsek,1,casUsek),1,cntCasUsek) i casUsek="" q
							i cntCasUsek>myCntCasUsek {
								s myCasUsek=casUsek
								s myCntCasUsek=cntCasUsek
							}
						}
						s myVzdalenostTarifniUsek="" s myCntVzdalenostTarifniUsek=""
						s vzdalenostTarifniUsek="" f {
							s cntVzdalenostTarifniUsek="" s vzdalenostTarifniUsek=$o(myArr(vzdalenostPresnaUsek,2,vzdalenostTarifniUsek),1,cntVzdalenostTarifniUsek) i vzdalenostTarifniUsek="" q
							i cntVzdalenostTarifniUsek>myCntVzdalenostTarifniUsek {
								s myCntVzdalenostTarifniUsek=cntVzdalenostTarifniUsek
								s myVzdalenostTarifniUsek=vzdalenostTarifniUsek
							}
						}
					}
					//je-li nastavena rychlost pro vypocet, pak prepoctu
					i zakladniDobaJizdyRychlost {
						s myCasUsek=$j(((((vzdalenostPresnaUsek/1000)/zakladniDobaJizdyRychlost)*60)+.5),0,0)
					}
					i vzdalenostPresnaUsek'="" {
						//zapis do databaze
						k arrUsek				
						s arrUsek("DTA")=$lb(zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId)
						s arrUsek("DTA","vzdalenostDoba","DTA",horlog)=$lb(vzdalenostPresnaUsek,myCasUsek,myVzdalenostTarifniUsek)
						s pasmoJizdniDobaId="" f {
	    					s pasmoJizdniDobaId=$o(arrCisCasovaPasmaJizdniDoby("DTA",pasmoJizdniDobaId)) i pasmoJizdniDobaId="" q
	    					s pasmoJizdniDobaRychlost=$g(arr("PAR","podleRychlosti",pasmoJizdniDobaId))
	    					s myCasUsek=""
	    					i pasmoJizdniDobaRychlost {
		    					s myCasUsek=$j(((((vzdalenostPresnaUsek/1000)/pasmoJizdniDobaRychlost)*60)+.5),0,0)
	    					}
	    					s arrUsek("DTA","vzdalenostDoba","DTA",horlog,"pasma","DTA",pasmoJizdniDobaId)=$lb(myCasUsek)
						}
						d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUseky).uloz(.sys,$lb(vzdalenostiJizdniDobyId,usekId),"",.arrUsek)
					}
				}
			}
		}
	}
	k @tmpglbvzd
}

ClassMethod AktualizacePresneVzdUsekuDleGPS(ByRef sys As %String, vzdalenostiJizdniDobyId As %String, ByRef arr As %String)
{
	//aktualizace presne vzdalenosti useku podle gps souradnic a mapovych podkladu  
	//
	//IN
	//        1
	// vzdalenostiJizdniDobyId - kde aktualizovat presne vzdalenosti
	//
	//
	//OUT
	//
	$$$FillParams
	$$$TMPGLBSET(tmpglbvzd)
	//
	k arr("MSG")
	//prochazim vsechny useky
	k arrDtaInfo
	s usekId=0 f  {
		s usekId=$o(^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId,"useky","DTA",usekId)) i usekId="" q
		s arrDtaInfo(1)=$g(arrDtaInfo(1))+1
		i arrDtaInfo(1)>1000 q
		k arrDta d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUseky).nacti(.sys,$lb(vzdalenostiJizdniDobyId,usekId),"",.arrDta)
		s val=$g(arrDta("DTA"))
		s zastavkaOdId=$lg(val,1) s oznacniOdId=$lg(val,2) s zastavkaDoId=$lg(val,3) s oznacnikDoId=$lg(val,4)
		//zjistim vzdalenost useku
		k arrTmp
		d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).vzdalenostPodleGPSMapy(.sys,$lb(zastavkaOdId,oznacniOdId,zastavkaDoId,oznacnikDoId),.arrTmp)
		s vzdalenostPresna=$lg($g(arrTmp("DTA")),1)
		k arrTmp
		i vzdalenostPresna {
			s arrDtaInfo(2)=$g(arrDtaInfo(2))+1
			s horolog="" f {
				s val="" s horolog=$o(arrDta("DTA","vzdalenostDoba","DTA",horolog),1,val) i horolog="" q
				s $li(val,1)=vzdalenostPresna
				s arrDta("DTA","vzdalenostDoba","DTA",horolog)=val
			}
			d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUseky).uloz(.sys,$lb(vzdalenostiJizdniDobyId,usekId),"",.arrDta)
	 	}	
	}
	k @tmpglbvzd
	s arr("MSG",$i(arr("MSG")))="počet všech úseků = "_+$g(arrDtaInfo(1))
	s arr("MSG",$i(arr("MSG")))="počet aktualizovaných úseků = "_+$g(arrDtaInfo(2))
}

ClassMethod usekGPSSouradnice(ByRef sys As %String, id As %String, ByRef arr As %String) As %String
{
	$$$Init
	try {
		$$$FillParams
		//vrati gps souradnice useku
		//IN
		//
		// id=$lb(zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId)
		//
		//OUT
		//                
		// arr("DTA")=$lb($lb(gpse,gpsn),$lb(gpse,gpsn),nazevZastavkyOd,nazevZastavkyDo)
		//
		s id=$g(id) s zastavkaOdId=$lg(id,1) s oznacnikOdId=$lg(id,2) s zastavkaDoId=$lg(id,3) s oznacnikDoId=$lg(id,4)
		s nazevZastavkyOd="" s nazevZastavkyDo=""
		k arr("DTA")
		//
		s gpsOd=""
		i zastavkaOdId {
			k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaOdId,"",.arrDta)
			s arrDta("DTA")=$g(arrDta("DTA"))
			s nazevZastavkyOd=$lg(arrDta("DTA"),1)_","_$lg(arrDta("DTA"),2)_","_$lg(arrDta("DTA"),3)_"/"_$lg(arrDta("DTA"),4)
			i ($lg(arrDta("DTA"),19))&($lg(arrDta("DTA"),20)) s gpsOd=$lb($lg(arrDta("DTA"),20),$lg(arrDta("DTA"),19))
			i oznacnikOdId {
				k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyOznacniky).nacti(.sys,$lb(zastavkaOdId,oznacnikOdId),"",.arrDta)
				i ($lg(arrDta("DTA"),2))&($lg(arrDta("DTA"),3)) s gpsOd=$lb($lg(arrDta("DTA"),3),$lg(arrDta("DTA"),2))
			}
		}
		s gpsDo=""
		i zastavkaDoId {
			k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaDoId,"",.arrDta)
			s arrDta("DTA")=$g(arrDta("DTA"))
			s nazevZastavkyDo=$lg(arrDta("DTA"),1)_","_$lg(arrDta("DTA"),2)_","_$lg(arrDta("DTA"),3)_"/"_$lg(arrDta("DTA"),4)
			i ($lg(arrDta("DTA"),19))&($lg(arrDta("DTA"),20)) s gpsDo=$lb($lg(arrDta("DTA"),20),$lg(arrDta("DTA"),19))
			i oznacnikDoId {
				k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyOznacniky).nacti(.sys,$lb(zastavkaDoId,oznacnikDoId),"",.arrDta)
				i ($lg(arrDta("DTA"),2))&($lg(arrDta("DTA"),3)) s gpsDo("start")=$lb($lg(arrDta("DTA"),3),$lg(arrDta("DTA"),2))
			}
		}
		s arr("DTA")=$lb(gpsOd,gpsDo,nazevZastavkyOd,nazevZastavkyDo)
	}
	catch (ex){$$$CatchErrRest}
	q ret
}

ClassMethod PrecislujZastavky(ByRef sys As %String, ByRef arr As %String) As %String
{
	$$$Init
	try {
		$$$FillParams
		//precisluje zastavky
		//IN
		//
		//arr("DTA",zastavkaPuvodniId)=zastavkaNovaId
		//
		//OUT
		//
		s vzdalenostiJizdniDobyId="" f {
			s vzdalenostiJizdniDobyId=$o(^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId)) i vzdalenostiJizdniDobyId="" q
			s usekId="" f {
				s valDta="" s usekId=$o(^[dataDB]ALVA.ISY.VZD("DTA",vzdalenostiJizdniDobyId,"useky","DTA",usekId),1,valDta) i usekId="" q
				s zastavkaOdId=$lg(valDta,1) s zastavkaDoId=$lg(valDta,3)
				//musim pres api, abych zaktualizoval indexy
				i ($d(arr("DTA",zastavkaOdId)))!($d(arr("DTA",zastavkaDoId))) {
					k arrDTA
					d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUseky).nacti(.sys,$lb(vzdalenostiJizdniDobyId,usekId),"",.arrDTA)
					s arrDTA("DTA")=$g(arrDTA("DTA"))
					f idx=1,3{
						s zastavkaId=$lg(arrDTA("DTA"),idx)
						i $d(arr("DTA",zastavkaId)) {
							s $li(arrDTA("DTA"),idx)=$g(arr("DTA",zastavkaId))
						}
					}
					d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUseky).uloz(.sys,$lb(vzdalenostiJizdniDobyId,usekId),"",.arrDTA)
				}
			}
		}
	}
	catch (ex){$$$CatchErrRest}
	q ret
}

}
