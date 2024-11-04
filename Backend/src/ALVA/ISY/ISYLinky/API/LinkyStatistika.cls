Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYLinky.API.LinkyStatistika Extends %RegisteredObject
{

ClassMethod test()
{
	//d ##class(ALVA.ISY.ISYLinky.API.LinkyStatistika).test()
	s sys("U","IdFa")="VS_CSAD"
		s sys("U","delimiter")=$c(0)
		s sys("U","SystemDB")="MLINE"
		s sys("C","User")=007
		s sys("U","DATA")="USER"
		s sys("U","MLP")=7
		s sys("U","fullName")="007"
		s sys("U","loginName")="007"
		s sys("C","GUID")=7
		s hrlOd=##class(ALVA.GENERALAPI.Date).DateToHor("30.8.2020")
		s hrlDo=##class(ALVA.GENERALAPI.Date).DateToHor("31.10.2020")
	k arr
	s arr("PAR","horlogOdDo")=$lb(hrlOd,hrlDo)
	s arr("PAR","platnostLin")=1
	s arr("GLB")="^wwwj"
	d ..jede(.sys,$lb(1,"",823130),,.arr)
	zw arr
}

ClassMethod statId(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//vrati statId pro linku 0 CZ / 1 SK
	//id = $lb(skupinaId,aplId,linkaId)
	//nebo dGlb = global, kde jsou data linky tak, jak jsou ulozeny v databazi, pak se data nacitaji z nej
	//OUT
	//arr("DTA")=statId
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb) k arr("DTA")
	s skupinaId=$lg(id,1) s aplId=$lg(id,2) s linkaId=$lg(id,3)
	i linkaId'="" s linkaId=##class(ALVA.ISY.ISYLinky.API.LinkyFce).cisloLinkyDoIndexu(linkaId)
	//neni-li datovy global, pak nacitam data z databaze
	i (dGlb="")&(skupinaId) {s dGlb=$name(^[dataDB]JRL(skupinaId,linkaId))}
	i (dGlb="")&(aplId) {s dGlb=$name(^[dataDB]JRAPL(linkaId,aplId,"arr"))}
	//podle nastaveni programu
	s arr("DTA")=+$g(^[dataDB]JRSET("COME","REC"))
	//podle linky
	//doplnit az bude definovano
}

ClassMethod jede(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//vrati rozpis spoju, jak jedou v obdobi
	//IN
	//id = $lb(skupinaId,aplId,linkaId)
	//nebo dGlb = global, kde jsou data linky tak, jak jsou ulozeny v databazi, pak se data nacitaji z nej
	//arr("PAR","horlogOdDo")=$lb(hrlOd,hrlDo) ... datum pro vypocet statistiky
	//arr("PAR","platnostLin")= 0 / 1 ... uvazovat platnost linky od-do - pokud je parametr definovany, prepisuje default. hodnotu v programu 
	//
	//arr("GLB")= global, kam naplnit data
	//@arr("GLB")@("CAL",...)=... dopravni kalendar, pokud neni, pak se vytvori
	//@arr("GLB")@("DTA",smerId,spojId))=$lb(jede,hrlOd,bitMap)
	//OUT
	//arr("DTA",...)=$lb(dta,dta,...)
	$$$FillParams
	$$$TMPGLBSET(tmpglbcal)
	s id=$g(id) s dGlb=$g(dGlb) s glb=$g(arr("GLB")) k @glb@("DTA")
	s skupinaId=$lg(id,1) s aplId=$lg(id,2) s linkaId=$lg(id,3)
	i linkaId'="" s linkaId=##class(ALVA.ISY.ISYLinky.API.LinkyFce).cisloLinkyDoIndexu(linkaId)
	//neni-li datovy global a je-li zastavkaId, pak nacitam data z databaze
	i (dGlb="")&(skupinaId) {s dGlb=$name(^[dataDB]JRL(skupinaId,linkaId))}
	i (dGlb="")&(aplId) {s dGlb=$name(^[dataDB]JRAPL(linkaId,aplId,"arr"))}
	//
	s val=$g(arr("PAR","horlogOdDo")) s hrlOd=$lg(val,1) s hrlDo=$lg(val,2)
	s platnostLin=$g(arr("PAR","platnostLin"))
	//
	//statId - podle programu, do budoucna mozna podle skupiny a podle linky
	k arrDta d ..statId(.sys,id,dGlb,.arrDta) s statId=$g(arrDta("DTA"))
	//dopravni kalendar
	i '$d(@glb@("CAL")) {
		k arrDta
		s arrDta("PAR","horlogOdDo")=$g(arr("PAR","horlogOdDo"))
		s arrDta("GLB")=$name(@glb@("CAL")) 
		d ##class(ALVA.ISY.ISYOmezeni.API.DopravniKalendar).nacti(.sys,.arrDta)
	}
	//data linky
	k arrDta d ##class(ALVA.ISY.ISYLinky.API.Linky).nacti(.sys,$lb(skupinaId,aplId,linkaId),dGlb,.arrDta)
	s hrlPlatiOd=$lg($lg($g(arrDta("DTA")),7),1)
	s hrlPlatiDo=$lg($lg($g(arrDta("DTA")),7),2)
	//seznam spoju
	k arrLstSp d ##class(ALVA.ISY.ISYLinky.API.LinkySpoje).seznam(.sys,"",dGlb,.arrLstSp)
	s smerId="" f {
		s smerId=$o(arrLstSp("DTA",smerId)) i smerId="" q
		s spojId="" f {
			s spojId=$o(arrLstSp("DTA",smerId,spojId)) i spojId="" q
			//nactu platnost spoje
			k arrPlatnostSpoje d ##class(ALVA.ISY.ISYLinky.API.LinkySpoje).nactiPlatnost(.sys,$lb(skupinaId,aplId,linkaId,smerId,spojId),dGlb,.arrPlatnostSpoje)
			s tydenniPlatnostLst=$lg($g(arrPlatnostSpoje("DTA")),1)
			s dlouhodobeOmezeniId=$lg($g(arrPlatnostSpoje("DTA")),2)
			s spojJede=0 s spojHrlOd=hrlOd s spojBitMap=""
			//arr("DTA","datumoveOmezeni",omezeniId,hrl)=""
			f hrl=hrlOd:1:hrlDo {
				//veta kalendare
				s valKalendarDen=$g(@glb@("CAL",hrl,statId))
				s jede=0
				//jede jen
				s nasel=0
				i ('nasel)&($d(arrPlatnostSpoje("DTA","datumoveOmezeni",11,hrl))) {s jede=1 s nasel=1}
				i ('nasel)&($d(arrPlatnostSpoje("DTA","datumoveOmezeni",11)))&('$d(arrPlatnostSpoje("DTA","datumoveOmezeni",11,hrl))) {s jede=0 s nasel=1}
				//jede take
				i ('nasel)&($d(arrPlatnostSpoje("DTA","datumoveOmezeni",12,hrl))) {s jede=1 s nasel=1}
				//nejede
				i ('nasel)&($d(arrPlatnostSpoje("DTA","datumoveOmezeni",22,hrl))) {s jede=0 s nasel=1}
				//jede
				i ('nasel)&($d(arrPlatnostSpoje("DTA","datumoveOmezeni",13)))&('$d(arrPlatnostSpoje("DTA","datumoveOmezeni",13,hrl))) {
					s jede=0 s nasel=1
					//CHAPS - POKUD JE PLATNOST SU NEBO LI, TAK SE TO SLUCUJE S JEDE
					i (dlouhodobeOmezeniId=4)!(dlouhodobeOmezeniId=5) i (dlouhodobeOmezeniId=+$e("54",$lg(valKalendarDen,4)+1)) s nasel=0
				
				}
				//jede jen v sudych tydnech
				i ('nasel)&($d(arrPlatnostSpoje("DTA","datumoveOmezeni",14)))&('$d(arrPlatnostSpoje("DTA","datumoveOmezeni",14,hrl))) {s jede=0 s nasel=1}
				//jede jen v lichych tydnech
				i ('nasel)&($d(arrPlatnostSpoje("DTA","datumoveOmezeni",15)))&('$d(arrPlatnostSpoje("DTA","datumoveOmezeni",15,hrl))) {s jede=0 s nasel=1}
				//kontrola tydenniho omeeni
				i ('nasel) {
					s jede=1
					i $ll(tydenniPlatnostLst) {
						s jede=0
						s denPlatnostLst=$lg(valKalendarDen,2)
						f cnt=1:1:$ll(tydenniPlatnostLst) {
							s tydenniPlatnostId=$lg(tydenniPlatnostLst,cnt)
							i $lf(denPlatnostLst,tydenniPlatnostId) s jede=1
						}
					}
					//pokud jede, pak jeste kontrola dlouhodobeho omezeni
					i jede {
						i $d(arrPlatnostSpoje("DTA","datumoveOmezeni",14)) s dlouhodobeOmezeniId=4
						i $d(arrPlatnostSpoje("DTA","datumoveOmezeni",15)) s dlouhodobeOmezeniId=5
						i (dlouhodobeOmezeniId=4)!(dlouhodobeOmezeniId=5) {
							// CHAPS - POKUD JE JEDE, TAK SE TO SLUCUJE SE SU,LI
							i '($d(arrPlatnostSpoje("DTA","datumoveOmezeni",13))&($d(arrPlatnostSpoje("DTA","datumoveOmezeni",13,hrl)))) {
								i '(dlouhodobeOmezeniId=+$e("54",$lg(valKalendarDen,4)+1)) s jede=0
							}
						}	
					}
				}
				//kontrola na platnost linky
				i platnostLin i hrlPlatiOd i hrl<hrlPlatiOd s jede=0
				i platnostLin i hrlPlatiDo i hrl>hrlPlatiDo s jede=0
				//
				s spojJede=spojJede+jede
				s $e(spojBitMap,(hrl-spojHrlOd+1))=+jede
			}
			s @glb@("DTA",smerId,spojId)=$lb(spojJede,spojHrlOd,spojBitMap)
		}
	}
}

}
