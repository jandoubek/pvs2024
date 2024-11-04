Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYLinky.API.Linky Extends %RegisteredObject
{

ClassMethod test()
{
	//d ##class(ALVA.ISY.ISYLinky.API.Linky).test()
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
	//
	#; k arr d ..nacti(.sys,$lb(9,"",00003022),,.arr) w ! zw arr w !
	#; d ..uloz(.sys,$lb(9,"",823130),,.arr)
	k arr d ..nacti(.sys,$lb(6,"","0230009"),,.arr) w ! zw arr w !
	#; k arr d ..vymaz(.sys,$lb(9,,"0000113"),.arr) w ! zw arr w !
}

ClassMethod popis()
{
	// zakladni udaje linky
	// arr("DTA")=$lb(dta,dta,...)
	//  1 cisloDleLicence			/ cislo linky dle licence / T
	//  2 cisloIds					/ cislo linky v IDS	/ T
	//  3 cisloMhd					/ cislo linky pro MHD / T
	//  4 nazevLinky				/ nazev linky / LST - T /$lb($lb(castNazev,castNazev,...),$lb(tiskKam,tiskKam,...))
	//  5 druhLinky				    / druh linky / N / ciselnik DruhyLinek
	//  6 typLinky					/ typ linky  / N /(0 obyc / 1 objizdkova / 2 navrh)
	//  7 platnost					/ platnost linky / HRL / $lb(hrlOd,hrlDo)
	//  8 kodDopravyCis				/ kod dopravy dle CIS / N / ciselnik
	//  9 qr						/ text pro qr kod / T
	// 10 poznNadLinku				/ poznamka nad linku pro tisk / T
	// 11 pozPodDopravce			/ poznamka pod dopravce pro tisk / T
}

ClassMethod DBDoGLB(ByRef sys As %String, id As %String, dGlb As %String)
{
	//zapise data linky do pracovniho globalu
	//id = $lb(skupinaId,aplId,linkaId)
	//dGlb = global, kam se zapisou data linky tak, jak jsou ulozeny v databazi
	//
	//@dGlb=data linky tak, jak jsou ulozeny v databazi
	$$$FillParams
	//
	s id=$g(id) s dGlb=$g(dGlb)
	s skupinaId=$lg(id,1) s aplId=$lg(id,2) s linkaId=$lg(id,3)
	i (dGlb'="") {
		i ((skupinaId'="")&(linkaId'="")) { k @dGlb m @dGlb=^[dataDB]JRL(skupinaId,linkaId) }
		i ((aplId'="")&(linkaId'="")) { k @dGlb m @dGlb=^[dataDB]JRLAPL(linkaId,aplId,"arr") }
	}
}

ClassMethod GLBDoDB(ByRef sys As %String, ByRef id As %String, dGlb As %String)
{
	//ulozi data linky z pracovniho globalu do databaze
	//id = $lb(skupinaId,aplId,linkaId)
	//dGlb = global, kde jsou data linky tak, jak jsou ulozeny v databazi
	//@dGlb=data linky tak, jak jsou ulozeny v databazi
	//
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb)
	s skupinaId=$lg(id,1) s aplId=$lg(id,2) s linkaId=$lg(id,3)
	i linkaId'="" {
		d ..obnovIndex(.sys,id,0)
		i skupinaId'="" k ^[dataDB]JRL(skupinaId,linkaId) m ^[dataDB]JRL(skupinaId,linkaId)=@dGlb
		i aplId'="" k ^[dataDB]JRLAPL(linkaId,aplId,"arr") m ^[dataDB]JRLAPL(linkaId,aplId,"arr")=@dGlb
		d ..obnovIndex(.sys,id,1)
	}
}

ClassMethod existuje(ByRef sys As %String, ByRef id As %String, ByRef arr As %String)
{
	//zjisti, zda linka existuje v databazi
	//IN
	//id =$lb(skupinaId,aplId,linkaId)
	//OUT
	//arr("STT")=0 neexistuje / >0 existuje
	$$$FillParams
	s id=$g(id)
	s skupinaId=$lg(id,1) s aplId=$lg(id,2) s linkaId=$lg(id,3)
	k arr("STT") 
	i (skupinaId)&(linkaId'="") {s arr("STT")=($d(^[dataDB]JRL(skupinaId,linkaId))>0)}
	i (aplId)&(linkaId'="") {s arr("STT")=($d(^[dataDB]JRLAPL(linkaId,aplId,"arr"))>0)}
}

ClassMethod nacti(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//vrati zakladni data linky
	//IN
	//id = $lb(skupinaId,aplId,linkaId)
	//nebo dGlb = global, kde jsou data linky tak, jak jsou ulozeny v databazi, pak se data nacitaji z nej
	//OUT
	//arr("DTA")=$lb(dta,dta,...) // popis v popis
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb) k arr("DTA")
	s skupinaId=$lg(id,1) s aplId=$lg(id,2) s linkaId=$lg(id,3)
	i linkaId'="" s linkaId=##class(ALVA.ISY.ISYLinky.API.LinkyFce).cisloLinkyDoIndexu(linkaId)
	//neni-li datovy global a je-li nastaveno id, pak nacitam data z databaze
	i (dGlb="")&(skupinaId) {s dGlb=$name(^[dataDB]JRL(skupinaId,linkaId))}
	i (dGlb="")&(aplId) {s dGlb=$name(^[dataDB]JRAPL(linkaId,aplId,"arr"))}
	s valDB=""
	s val=""
	s $li(val,1)=##class(ALVA.ISY.ISYLinky.API.LinkyFce).indexNaCisloLinky(linkaId)
	s $li(val,2)=$p($g(@dGlb@("PATCH","cisIDS")),"~",2)
	s $li(val,3)=$p($g(@dGlb@("MhD","SeT_MhD")),"~",1)
	s nazevLst="" s tiskLst=""
	s cnt=0 f {
		s cnt=$o(@dGlb@("I",cnt)) i cnt="" q
		s nazevCast=$g(@dGlb@("I",cnt)) s kamTisk=1
		f idx=1:1:3 {
			s valTvar=$g(@dGlb@("I",0,idx))
			i $p(valTvar,":",cnt)=cnt s kamTisk=idx-1	
		}
		s $li(nazevLst,cnt)=nazevCast
		s $li(tiskLst,cnt)=kamTisk
	}
	s $li(val,4)=$lb(nazevLst,tiskLst)
	s $li(val,5)=(($p($g(@dGlb@("I")),"#",1))\10)+1
	s $li(val,6)=(+$g(@dGlb@("PATCH","OBJ")))
	s valDB=$g(@dGlb@("PATCH","Plati"))
	s hrlOd="" s datumOd=$p($p(valDB,":",1),"~",1) i datumOd s hrlOd=##class(ALVA.GENERALAPI.Date).DateToHor(datumOd)
	s hrlDo="" s datumDo=$p($p(valDB,":",1),"~",2) i datumDo s hrlDo=##class(ALVA.GENERALAPI.Date).DateToHor(datumDo)
	s $li(val,7)=$lb(hrlOd,hrlDo)
	s $li(val,8)=$g(@dGlb@("PATCH","KodDopravyCIS"))
	s $li(val,9)=$g(@dGlb@("PATCH","QR_CODE"))
	s $li(val,10)=$g(@dGlb@("PATCH","Head"))
	s $li(val,11)=$g(@dGlb@("PATCH","PoznPodDopr"))
	s arr("DTA")=val
}

ClassMethod uloz(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//ulozi zakladni data linky
	//IN
	//id = $lb(skupinaId,aplId,linkaId)
	//nebo dGlb = global, kde jsou data linky tak, jak jsou ulozeny v databazi, pak se data zapisuji do nej
	//arr("DTA")=$lb(dta,dta) / popis v popis
	//OUT
	//
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb)
	s skupinaId=$lg(id,1) s aplId=$lg(id,2) s linkaId=$lg(id,3)
	i linkaId'="" s linkaId=##class(ALVA.ISY.ISYLinky.API.LinkyFce).cisloLinkyDoIndexu(linkaId)
	//neni-li datovy global a je-li id, pak nacitam data z databaze
	i (dGlb="")&(skupinaId) {s dGlb=$name(^[dataDB]JRL(skupinaId,linkaId))}
	i (dGlb="")&(aplId) {s dGlb=$name(^[dataDB]JRAPL(linkaId,aplId,"arr"))}
	s val=$g(arr("DTA"))
	s $p(@dGlb@("PATCH","cisIDS"),"~",2)=$lg(val,2)
	s $p(@dGlb@("MhD","SeT_MhD"),"~",1)=$lg(val,3)
	s tmpVal=$lg(val,4) s nazevLst=$lg(tmpVal,1) s tiskLst=$lg(tmpVal,2)
	s cnt="" f {
		s cnt=$o(@dGlb@("I",cnt)) i cnt="" q
		k @dGlb@("I",cnt)
	}
	f cnt=1:1:$ll(nazevLst) {
		s @dGlb@("I",cnt)=$lg(nazevLst,cnt)
		s $p(@dGlb@("I",0,($lg(tiskLst,cnt)+1)),":",cnt)=cnt		
	}
	s $p(@dGlb@("I"),"#",1)=(($lg(val,5)-1)*10)
	s @dGlb@("PATCH","OBJ")=$lg(val,6)
	s tmpVal=$lg(val,7) s hrlOd=$lg(tmpVal,1) s hrlDo=$lg(tmpVal,2)
	s datumOd="" i hrlOd s datumOd=##class(ALVA.GENERALAPI.Date).horToDate(hrlOd)
	s datumDo="" i hrlDo s datumDo=##class(ALVA.GENERALAPI.Date).horToDate(hrlDo)
	s $p(@dGlb@("PATCH","Plati"),":",1)=datumOd_"~"_datumDo
	s @dGlb@("PATCH","KodDopravyCIS")=$lg(val,8)
	s @dGlb@("PATCH","QR_CODE")=$lg(val,9)
	s @dGlb@("PATCH","Head")=$lg(val,10)
	s @dGlb@("PATCH","PoznPodDopr")=$lg(val,11)
}

ClassMethod vymaz(ByRef sys As %String, id As %String, ByRef arr As %String)
{
	//vymaze skupinu obehu z databaze, zapis do kose
	//IN
	//id = $lb(skupinaId,aplId,linkaId)
	//OUT
	//-
	//
	$$$FillParams
	s id=$g(id) s dGlb=""
	s skupinaId=$lg(id,1) s aplId=$lg(id,2) s linkaId=$lg(id,3)
	i linkaId'="" s linkaId=##class(ALVA.ISY.ISYLinky.API.LinkyFce).cisloLinkyDoIndexu(linkaId)
	i (skupinaId) {s dGlb=$name(^[dataDB]JRL(skupinaId,linkaId))}
	i (aplId) {s dGlb=$name(^[dataDB]JRAPL(linkaId,aplId,"arr"))}
	i dGlb'="" {
	//vymazu ji v seznamu
	d ..obnovIndex(.sys,id,0)
	//zapisu ji do kose
	k arrDTA m arrDTA("DTA",linkaId)=@dGlb s id=$lb("Lin",$h) d ##class(ALVA.ISY.ISYKos.API.Kos).uloz(.sys,id,.arrDTA)	
	//zrusim ji
	k @dGlb
	//sherlok !!!
	}
}

ClassMethod seznamSkupina(ByRef sys As %String, skupinaId As %String, ByRef arr As %String)
{
	//vrati seznam linek ve skupine
	//IN
	//skupinaId
	//arr("PAR","cisloLinky")=zadany text pro hledani
	//arr("PAR","dopravceId")=$lb(firmaId,provozovna1Id,provozovna2Id,provozovna3Id,provozovna4Id), jsou-li vsechny provozovnaXId="" pak vsechny provozovozovny dopravce
	//arr("PAR","zastavkaId")=zastavkaId
	//OUT
	//arr("DTA",linkaId)=""
	$$$FillParams
	s id=$g(id) k arr("DTA")
		s skupinaId=$g(skupinaId)
		s cisloLinky=$g(arr("PAR","cisloLinky")) s cisloLinky=$tr(cisloLinky,"*","")
		s dopravceDta=$lts($g(arr("PAR","dopravceId")),"~")
		s zastavkaId=$g(arr("PAR","zastavkaId"))
		k arrDopravce
		i $p(dopravceDta,"~",1)'="" {
			s jeProvoz=0
			f cnt=2:1:5 {
				i $p(dopravceDta,"~",cnt)'="" {
					s arrDopravce($p(dopravceDta,"~",1)_"~"_$p(dopravceDta,"~",cnt))=""
					s jeProvoz=1
				}
			}
			i 'jeProvoz { s arrDopravce($p(dopravceDta,"~",1)_"~")="" }
		}
	i skupinaId {
		s linkaId="" f {
			s linkaId=$o(^[dataDB]JRL(skupinaId,linkaId)) i linkaId="" q	
			i cisloLinky'="" { i $e($e(linkaId,2,7),1,$l(cisloLinky))'=cisloLinky continue }
			i zastavkaId {
				s nasel=0
				s bodId="" f {
					s valDB="" s bodId=$o(^[dataDB]JRL(skupinaId,linkaId,"J",bodId),1,valDB) i (bodId="")!(nasel) q 
					i (+valDB)=(+zastavkaId) s nasel=1
				}
				i 'nasel continue
			}
			i $d(arrDopravce) {
				s nasel=0
				f smer="T","Z" {
					s spojId="" f {
						s valDB="" s spojId=$o(^[dataDB]JRL(skupinaId,linkaId,smer,spojId),1,valDB) i (spojId="")!(nasel) q
						s dopravceLinkaId=$tr($p($p($p(valDB,"#",1),":",10),"$",2),"/","~")
						s dopravceId="" f {
							s dopravceId=$o(arrDopravce(dopravceId)) i dopravceId="" q
							i dopravceLinkaId=dopravceId s nasel=1
							i ($p(dopravceId,"~",2)="" )&($p(dopravceId,"~",1)=$p(dopravceLinkaId,"~",1)) s nasel=1
						}
						s dopravceLinkaId=$tr($p($p(valDB,"#",2),"~",1),":","~")
						s dopravceId="" f {
							s dopravceId=$o(arrDopravce(dopravceId)) i (dopravceId="")!(nasel) q
							i dopravceLinkaId=dopravceId s nasel=1
							i ($p(dopravceId,"~",2)="" )&($p(dopravceId,"~",1)=$p(dopravceLinkaId,"~",1)) s nasel=1
						}
						s dopravceLinkaId=$tr($p($p(valDB,"#",2),"~",2),":","~")
						s dopravceId="" f {
							s dopravceId=$o(arrDopravce(dopravceId)) i (dopravceId="")!(nasel) q
							i dopravceLinkaId=dopravceId s nasel=1
							i ($p(dopravceId,"~",2)="" )&($p(dopravceId,"~",1)=$p(dopravceLinkaId,"~",1)) s nasel=1
						}
						s dopravceLinkaId= $tr($p($p(valDB,"#",2),"~",6),":","~")
						s dopravceId="" f {
							s dopravceId=$o(arrDopravce(dopravceId)) i (dopravceId="")!(nasel) q
							i dopravceLinkaId=dopravceId s nasel=1
							i ($p(dopravceId,"~",2)="" )&($p(dopravceId,"~",1)=$p(dopravceLinkaId,"~",1)) s nasel=1
						}
						s dopravceLinkaId=$tr($p($p(valDB,"#",2),"~",8),":","~")
						s dopravceId="" f {
							s dopravceId=$o(arrDopravce(dopravceId)) i (dopravceId="")!(nasel) q
							i dopravceLinkaId=dopravceId s nasel=1
							i ($p(dopravceId,"~",2)="" )&($p(dopravceId,"~",1)=$p(dopravceLinkaId,"~",1)) s nasel=1
						}
						
					}
				}
				i 'nasel continue
			}
			s arr("DTA",linkaId)=""			
		}
	}
}

ClassMethod seznamEvidovaneLinky(ByRef sys As %String, ByRef arr As %String)
{
	//vrati seznam linek ve skupinach
	//IN
	//arr("PAR","cisloLinky")=zadany text pro hledani
	//arr("PAR","dopravceId")=$lb(firmaId,provozovnaId)
	//arr("PAR","zastavkaId")=zastavkaId
	//arr("PAR","linkaId",linkaId)=""
	//OUT
	//arr("DTA",linkaId,skupinaId)=""
	$$$FillParams
	k arr("DTA")
		s cisloLinky=$g(arr("PAR","cisloLinky")) s cisloLinky=$tr(cisloLinky,"*","")
		s dopravceId=$lts($g(arr("PAR","dopravceId")),"~")
		s zastavkaId=$g(arr("PAR","zastavkaId"))
		s skupinaId="" f {
			s skupinaId=$o(^[dataDB]JRL(skupinaId)) i skupinaId="" q
			i skupinaId["tmp" continue
			s linkaId="" f {
				s linkaId=$o(^[dataDB]JRL(skupinaId,linkaId)) i linkaId="" q	
				i $d(arr("PAR","linkaId")) i '$d(arr("PAR","linkaId",linkaId)) continue
			i cisloLinky'="" { i $e($e(linkaId,2,7),1,$l(cisloLinky))'=cisloLinky continue }
			i zastavkaId {
				s nasel=0
				s bodId="" f {
					s valDB="" s bodId=$o(^[dataDB]JRL(skupinaId,linkaId,"J",bodId),1,valDB) i (bodId="")!(nasel) q 
					i (+valDB)=(+zastavkaId) s nasel=1
				}
				i 'nasel continue
			}
			i (dopravceId'="") {
				s nasel=0
				f smer="T","Z" {
					s spojId="" f {
						s valDB="" s spojId=$o(^[dataDB]JRL(skupinaId,linkaId,smer,spojId),1,valDB) i (spojId="")!(nasel) q
						i dopravceId=$tr($p($p($p(valDB,"#",1),":",10),"$",2),"/","~") i firmaId=$p(val,"~",1) s nasel=1
						i dopravceId=$tr($p($p(valDB,"#",2),"~",1),":","~") i firmaId=$p(val,"~",1) s nasel=1
						i dopravceId=$tr($p($p(valDB,"#",2),"~",2),":","~") i firmaId=$p(val,"~",1) s nasel=1
						i dopravceId=$tr($p($p(valDB,"#",2),"~",6),":","~") i firmaId=$p(val,"~",1) s nasel=1
						i dopravceId=$tr($p($p(valDB,"#",2),"~",8),":","~") i firmaId=$p(val,"~",1) s nasel=1					
					}
				}
				i 'nasel continue
			}
			s arr("DTA",linkaId,skupinaId)=""			
		}
	}
}

ClassMethod seznamArchivLinek(ByRef sys As %String, ByRef arr As %String)
{
	//vrati seznam linek ve archivu
	//IN
	//skupin
	//arr("PAR","cisloLinky")=zadany text pro hledani
	//arr("PAR","dopravceId")=$lb(firmaId,provozovnaId)
	//arr("PAR","zastavkaId")=zastavkaId
	//arr("PAR","linkaId",linkaId)=""
	//OUT
	//arr("DTA",linkaId,aplId)=""
	$$$FillParams
	k arr("DTA")
		s cisloLinky=$g(arr("PAR","cisloLinky")) s cisloLinky=$tr(cisloLinky,"*","")
		s dopravceId=$lts($g(arr("PAR","dopravceId")),"~")
		s zastavkaId=$g(arr("PAR","zastavkaId"))
		//
		s linkaId="" f {
			s linkaId=$o(^[dataDB]JRAPL(linkaId)) i linkaId="" q
			i $d(arr("PAR","linkaId")) i '$d(arr("PAR","linkaId",linkaId)) continue
		i cisloLinky'="" { i $e($e(linkaId,2,7),1,$l(cisloLinky))'=cisloLinky continue }
			s aplId="" f {
				s aplId=$o(^[dataDB]JRAPL(linkaId,aplId)) i aplId="" q
				//^[dataDB]JRAPL(linkaId,aplId,"arr")   
				i zastavkaId {
				s nasel=0
				s bodId="" f {
					s valDB="" s bodId=$o(^[dataDB]JRAPL(linkaId,aplId,"arr","J",bodId),1,valDB) i (bodId="")!(nasel) q 
					i (+valDB)=(+zastavkaId) s nasel=1
				}
				i 'nasel continue
			}
			i (dopravceId'="") {
				s nasel=0
				f smer="T","Z" {
					s spojId="" f {
						s valDB="" s spojId=$o(^[dataDB]JRAPL(linkaId,aplId,"arr",smer,spojId),1,valDB) i (spojId="")!(nasel) q
						i dopravceId=$tr($p($p($p(valDB,"#",1),":",10),"$",2),"/","~") i firmaId=$p(val,"~",1) s nasel=1
						i dopravceId=$tr($p($p(valDB,"#",2),"~",1),":","~") i firmaId=$p(val,"~",1) s nasel=1
						i dopravceId=$tr($p($p(valDB,"#",2),"~",2),":","~") i firmaId=$p(val,"~",1) s nasel=1
						i dopravceId=$tr($p($p(valDB,"#",2),"~",6),":","~") i firmaId=$p(val,"~",1) s nasel=1
						i dopravceId=$tr($p($p(valDB,"#",2),"~",8),":","~") i firmaId=$p(val,"~",1) s nasel=1					
					}
				}
				i 'nasel continue
			}
			s arr("DTA",linkaId,aplId)=""			
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
