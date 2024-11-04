Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit Extends %RegisteredObject
{

/// 
/// index do pracovniho globalu
/// 
ClassMethod CTMPGLBFRMIDX() As %String
{
	q $p($THIS,"ALVA.ISY.",2)
}

/// 
/// načte data 
/// 
ClassMethod Load(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		$$$FillParams	
		// načtu vstup	
		s idx ="" s ID=""
        f
        {
	        s idx=$o(^||ML("IN",idx),1,radka) i idx="" q
           	s list= $listfromstring(radka,del)
           	i $lg(list,1)="ID" { s ID=($lg(list,2)) }          
        }
        //
        k $$$CTMPGLBFRM(GUID,..CTMPGLBFRMIDX()) k output
        i ID {
			s $$$CTMPGLBFRM(GUID,..CTMPGLBFRMIDX(),"ID")=ID
			d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDoby).DBDoGLB(.sys,ID,$name($$$CTMPGLBFRM(GUID,..CTMPGLBFRMIDX(),"DTA")))
		}
		m ^||ML("OUT")=output
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

/// 
/// Uložení okna po stisku OK
/// 
ClassMethod Save(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{
		$$$FillParams
		s ID=$g($$$CTMPGLBFRM(GUID,..CTMPGLBFRMIDX(),"ID"))
		d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDoby).GLBDoDB(.sys,ID,$name($$$CTMPGLBFRM(GUID,..CTMPGLBFRMIDX(),"DTA")))
		k $$$CTMPGLBFRM(GUID,..CTMPGLBFRMIDX()) 
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

/// 
/// Init gridu (seznam zastávek)
/// 
ClassMethod InitFg(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	
	$$$Init
	try 
	{	
		/*    				možné formáty sloupce
 		AnoNe,	//ano ne 
        I,						  !!!	//IMG  neumí sloupec typu IMG 
        T, 		//String
        TL, 	//String link
        Tc, 	//String zarovnany na stred
        N, 		//intager
        NL,		//intager link
        Nc,		//intager zarovnany na stred
        N2|### ##0.####0,		// Double      |### ##0.####0 je volitelné nemusí být
        D,		// Date
        DT,		// Date time        
        B,		// boolean
        CBO		//Combobox
        */
		//$lb("ITEM",id sloupce,název sloupce,typ,*editable -defaultně ne nemusí se vyplňovat)   barvy fungují jen pokud se zapnou (spomaluje načítání gridu)		 
		 $$$FillParams
		 s output($i(i))=$lts($lb("ITEM","usekId","Id","N"),del)
		 s output($i(i))=$lts($lb("ITEM","zastavkaOdId","Zastávka od","N2|### ### ##0.##"),del)
		 s output($i(i))=$lts($lb("ITEM","oznacnikOdId","Označník od","N"),del)
		 s output($i(i))=$lts($lb("ITEM","zastavkaOdNazev","Zastávka od, název","T"),del)
		 s output($i(i))=$lts($lb("ITEM","zastavkaDoId","Zastávka do","N2|### ### ##0.##"),del)
		 s output($i(i))=$lts($lb("ITEM","oznacnikDoId","Označník do","N"),del)
		 s output($i(i))=$lts($lb("ITEM","zastavkaDoNazev","Zastávka do, název","T"),del)
		 s output($i(i))=$lts($lb("ITEM","datumOd","Datum od","D"),del)
		 s output($i(i))=$lts($lb("ITEM","vzdalenostPodleMapy","Vzdálenost podle mapy [m]","N2"),del)
		 s output($i(i))=$lts($lb("ITEM","trvaniPodleMapy","Trvání podle mapy [m]","N2"),del)
		 s output($i(i))=$lts($lb("ITEM","vzdalenostPresna","Přesná vzdálenost [km]","N2|### ##0.###"),del)
		 s output($i(i))=$lts($lb("ITEM","vzdalenostTarifni","Tarifní vzdálenost [km]","N"),del)
		 s output($i(i))=$lts($lb("ITEM","zakladniDobaJizdy","Základní"_$c(13,10)_"doba jízdy [min]","N"),del)
		 s output($i(i))=$lts($lb("ITEM","dobaJizdyPasmo","Doba jízdy"_$c(13,10)_"dle pásem [min]","T"),del)
		 m ^||ML("OUT")=output
	}
	catch (ex){$$$CatchErrRest}
 	q ret
}

/// 
/// Load gridu (načtení jednotlivých řádek)
/// 
ClassMethod LoadFg(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		$$$FillParams
		$$$TMPGLBSET(tmpglblst)
		// Načtu filtr	
		// filtr(nazevkomponenty)= hodnota   a pokud jich je víc filtr(nazevkomponenty, hodnota)=""
		$$$GetFiltr
		k arr
		s arr("GLB")=tmpglblst
		s arr("PAR","hledanyText")=$g(filtr("txbNazev"))
		s arr("PAR","vzdalenostOd")=$g(filtr("nudVzdalenostOd")) i arr("PAR","vzdalenostOd")'="" s arr("PAR","vzdalenostOd")=(arr("PAR","vzdalenostOd")*1000)
		s arr("PAR","vzdalenostDo")=$g(filtr("nudVzdalenostDo")) i arr("PAR","vzdalenostDo")'="" s arr("PAR","vzdalenostDo")=(arr("PAR","vzdalenostDo")*1000)
		s arr("PAR","dobaJizdyOd")=$g(filtr("nudDobaOd"))
		s arr("PAR","dobaJizdyDo")=$g(filtr("nudDobaDo"))
		d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUseky).seznam(.sys,"",$name($$$CTMPGLBFRM(GUID,..CTMPGLBFRMIDX(),"DTA")),.arr)
		// zobrazim data
		s abcidx="" f {
			s usekId="" s abcidx=$o(@tmpglblst@("IDX",abcidx),1,usekId) i abcidx="" q
			s valDta=$g(@tmpglblst@("DTA",usekId))
			s zastavkaOdId=$lg(valDta,1)
			s oznacniOdId=$lg(valDta,2)
			s zastavkaDoId=$lg(valDta,3)
			s oznacnikDoId=$lg(valDta,4)
			s vzdalenostPodleMapy = $lg(valDta,5)
			s trvaniPodleMapy = $lg(valDta,6)
			s zastavkaOdNazev=""
			i zastavkaOdId {
				k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).nactiNazev(.sys,zastavkaOdId,.arrDta)
				s valDta=$g(arrDta("DTA"))
				s zastavkaOdNazev=$lg(valDta,1)_","_$lg(valDta,2)_","_$lg(valDta,3)_"/"_$lg(valDta,4)
			}
			s zastavkaDoNazev=""
			i zastavkaDoId {
				k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).nactiNazev(.sys,zastavkaDoId,.arrDta)
				s valDta=$g(arrDta("DTA"))
				s zastavkaDoNazev=$lg(valDta,1)_","_$lg(valDta,2)_","_$lg(valDta,3)_"/"_$lg(valDta,4)
			}
			s datumOd="" s vzdalenostPresna="" s vzdalenostTarifni="" s zakladniDobaJizdy="" s dobaJizdyPasmo=""
			s hrlOd=$o(@tmpglblst@("DTA",usekId,"vzdalenostDoba","DTA",""),-1)
			i hrlOd {
				s datumOd=##class(ALVA.GENERALAPI.Date).horToDate(hrlOd)
				s valDta=$g(@tmpglblst@("DTA",usekId,"vzdalenostDoba","DTA",hrlOd))
				s vzdalenostPresna=$lg(valDta,1)
				s zakladniDobaJizdy=$lg(valDta,2)
				s vzdalenostTarifni=$lg(valDta,3)
				s pasmoJizdniDobaId="" f {
					s valDta="" s pasmoJizdniDobaId=$o(@tmpglblst@("DTA",usekId,"vzdalenostDoba","DTA",hrlOd,"pasma","DTA",pasmoJizdniDobaId),1,valDta) i pasmoJizdniDobaId="" q
					s dobaJizdy=$lg(valDta,1)
					i dobaJizdyPasmo'="" { s dobaJizdyPasmo=dobaJizdyPasmo_";"}
					s dobaJizdyPasmo=dobaJizdyPasmo_pasmoJizdniDobaId_"="_dobaJizdy
				}
			}
			s vzdalenostPresna=$j((vzdalenostPresna/1000),0,3)
			s vzdalenostTarifni=(vzdalenostTarifni/1000)
			s idRadku=usekId
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"usekId",usekId),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"zastavkaOdId",zastavkaOdId),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"oznacnikOdId",oznacniOdId),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"zastavkaOdNazev",zastavkaOdNazev),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"zastavkaDoId",zastavkaDoId),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"oznacnikDoId",oznacnikDoId),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"zastavkaDoNazev",zastavkaDoNazev),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"datumOd",datumOd),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"vzdalenostPodleMapy",vzdalenostPodleMapy),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"trvaniPodleMapy",trvaniPodleMapy),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"vzdalenostPresna",vzdalenostPresna),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"vzdalenostTarifni",vzdalenostTarifni),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"zakladniDobaJizdy",zakladniDobaJizdy),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"dobaJizdyPasmo",dobaJizdyPasmo),del)
		}
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

/// 
/// Odstraní položku
/// 
ClassMethod Delete(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		$$$FillParams	
		// načtu vstup	
		s idx =""
        for
        {
	        s idx=$o(^||ML("IN",idx),1,radka) q:idx=""
           	s list= $listfromstring(radka,del)
           	if $lg(list,1)="Item"{s item($lg(list,2))="" }          
        }  
        k output
        // odeberu položku
        s cntUsek=0
        s output($i(i))=$lts($lb("MSG","","Odtraněn úsek:"),del)
        s usekId="" f {
	        s usekId=$o(item(usekId)) i usekId="" q
	        i cntUsek<10 {
		        k arrDta d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUseky).nacti(.sys,$lb("",usekId),$name($$$CTMPGLBFRM(GUID,..CTMPGLBFRMIDX(),"DTA")),.arrDta)
	        	s valDta=$g(arrDta("DTA"))
				s zastavkaOdId=$lg(valDta,1) s oznacniOdId=$lg(valDta,2)
				s zastavkaDoId=$lg(valDta,3) s oznacnikDoId=$lg(valDta,4)
				s zastavkaOdNazev=""
				i zastavkaOdId {
					k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaOdId,"",.arrDta)
					s valDta=$g(arrDta("DTA"))
					s zastavkaOdNazev=$lg(valDta,1)_","_$lg(valDta,2)_","_$lg(valDta,3)_"/"_$lg(valDta,4)
				}
				s zastavkaDoNazev=""
				i zastavkaDoId {
					k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaDoId,"",.arrDta)
					s valDta=$g(arrDta("DTA"))
					s zastavkaDoNazev=$lg(valDta,1)_","_$lg(valDta,2)_","_$lg(valDta,3)_"/"_$lg(valDta,4)
				}	
		        s output($i(i))=$lts($lb("MSG","",zastavkaOdNazev_" - "_zastavkaDoNazev),del)
	        }
	        i cntUsek=10 {
		           s output($i(i))=$lts($lb("MSG","","..."),del)
	        }
	        d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUseky).vymaz(.sys,$lb("",usekId),$name($$$CTMPGLBFRM(GUID,..CTMPGLBFRMIDX(),"DTA")),"")
	        s cntUsek=$i(cntUsek)
        }
		m ^||ML("OUT")=output
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

}
