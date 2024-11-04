Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostUsekEdit Extends %RegisteredObject
{

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
		k output
		s usekId="" s idx =""
        f
        {
	        s idx=$o(^||ML("IN",idx),1,radka) i idx="" q
           	s list=$listfromstring(radka,del)
           	i $lg(list,1)="ID"{s usekId=($lg(list,2)) }          
        } 
        k $$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek")
        s $$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","ID")=usekId
        i usekId {
	        m $$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA")=$$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"DTA","useky","DTA",usekId)
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
		k output
		s usekId=$g($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","ID"))

		k arrDta m arrDta("DTA")=$$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA")
		d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUseky).uloz(.sys,$lb("",usekId),$name($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"DTA")),.arrDta)
		k $$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek")
		m ^||ML("OUT")=output
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
		 k output
		 s output($i(i))=$lts($lb("ITEM","datumOd","Datum od","D"),del)	
		 s output($i(i))=$lts($lb("ITEM","vzdalenostPresna","Vzdálenost"_$c(13,10)_"přesná [Km]","N2|### ##0.###"),del)
		 s output($i(i))=$lts($lb("ITEM","vzdalenostTarifni","Vzdálenost"_$c(13,10)_"tarifní [Km]","N"),del)
		 s output($i(i))=$lts($lb("ITEM","zakladniDobaJizdy","Základní doba"_$c(13,10)_"jízdy [min]","N"),del)
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
		//zobrazim data
		//data editovaneho useku jsou v:
		//$$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","ID")
		//$$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA")
		s hrlOd="" f {
			s valDta="" s hrlOd=$o($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA","vzdalenostDoba","DTA",hrlOd),-1,valDta) i hrlOd="" q
			s vzdalenostPresna=$lg(valDta,1) s zakladniDobaJizdy=$lg(valDta,2) s vzdalenostTarifni=$lg(valDta,3)
			//prevod m -> km
			s vzdalenostPresna=(vzdalenostPresna/1000)
			s vzdalenostTarifni=(vzdalenostTarifni\1000)
			//
			s dobaJizdyPasmo=""
			s pasmoJizdniDobaId="" f {
				s valDta="" s pasmoJizdniDobaId=$o($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA","vzdalenostDoba","DTA",hrlOd,"pasma","DTA",pasmoJizdniDobaId),1,valDta) i pasmoJizdniDobaId="" q
				s dobaJizdy=$lg(valDta,1)
				i dobaJizdyPasmo'="" s dobaJizdyPasmo=dobaJizdyPasmo_";"
				s dobaJizdyPasmo=dobaJizdyPasmo_pasmoJizdniDobaId_"="_dobaJizdy
			}
			s datumOd=##class(ALVA.GENERALAPI.Date).horToDate(hrlOd)
			s idRadku=hrlOd
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"datumOd",datumOd),del)
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
        // odeberu položku
        k output
		s hrlOd="" f {
			s hrlOd=$o(item(hrlOd)) i hrlOd="" q
			s datumOd=##class(ALVA.GENERALAPI.Date).horToDate(hrlOd)
			k $$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA","vzdalenostDoba","DTA",hrlOd)
			s output($i(i))=$lts($lb("MSG","","Časová varinta vzdálenosti "_datumOd_"' byla odstraněna."),del)
		}
		m ^||ML("OUT")=output
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

/// 
/// Vrátí data pro body na mapě
/// 
ClassMethod GetDataUseku(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		$$$FillParams
		s valDta=$g($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA"))
	  	s zastavkaOdId=$lg(valDta,1)
	  	s oznacnikOdId=$lg(valDta,2)
	  	s zastavkaDoId=$lg(valDta,3)
	  	s oznacnikDoId=$lg(valDta,4)
		k arrDta d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUsekyFce).usekGPSSouradnice(.sys,$lb(zastavkaOdId,oznacniOdId,zastavkaDoId,oznacnikDoId),.arrDta)
		s valDta=$g(arrDta("DTA"))
		s gpsOd=$lg(valDta,1) s gpsDo=$lg(valDta,2) s nazevZastavkyOd=$lg(valDta,3) s nazevZastavkyDo=$lg(valDta,4)
		if ($lg(gpsOd,1)'="") {s ^||ML("OUT",$i(^||ML("OUT")))="GPS"_del_zastavkaOdId_del_$lg(gpsOd,1)_del_$lg(gpsOd,2)_del_""_del_nazevZastavkyOd}
		if ($lg(gpsDo,1)'="") {s ^||ML("OUT",$i(^||ML("OUT")))="GPS"_del_zastavkaDoId_del_$lg(gpsDo,1)_del_$lg(gpsDo,2)_del_""_del_nazevZastavkyDo}
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

/// 
/// načte text do stavového řádku
/// 
ClassMethod GetSR(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		
		$$$FillParams	
		// načtu vstup	
		k output
		s usekId="" s idx =""
        f
        {
	        s idx=$o(^||ML("IN",idx),1,radka) i idx="" q
           	s list=$listfromstring(radka,del)
           	i $lg(list,1)="ID"{s usekId=($lg(list,2)) }          
        }
        s valDta=$g($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA"))
	  	s zastavkaOdId=$lg(valDta,1)
	  	s oznacnikOdId=$lg(valDta,2)
	  	s zastavkaDoId=$lg(valDta,3)
	  	s oznacnikDoId=$lg(valDta,4)
	  	s zastavkaOdNazev="" i zastavkaOdId {
		  	k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaOdId,"",.arrDta)
		  	s valDta=$g(arrDta("DTA"))
		  	s zastavkaOdNazev=$lg(valDta,1)_","_$lg(valDta,2)_","_$lg(valDta,3)_"/"_$lg(valDta,4)
	  	}
	  	s zastavkaDoNazev="" i zastavkaDoId {
		  	k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaDoId,"",.arrDta)
		  	s valDta=$g(arrDta("DTA"))
		  	s zastavkaDoNazev=$lg(valDta,1)_","_$lg(valDta,2)_","_$lg(valDta,3)_"/"_$lg(valDta,4)
	  	}
	  	s datumOd="" s vzdalenost="" s zakladniDobaJizdy=""
	  	s hrlOd=$o($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA","vzdalenostDoba","DTA",""),-1)
      	i hrlOd {
	      s datumOd=##class(ALVA.GENERALAPI.Date).horToDate(hrlOd)
	      s valDta=$g($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA","vzdalenostDoba","DTA",hrlOd))
		  s vzdalenost=$lg(valDta,1)
		  s zakladniDobaJizdy=$lg(valDta,2)
        }
        s titulek="Úsek | "_zastavkaOdNazev_" - "_zastavkaDoNazev_" | "
        i hrlOd s titulek=titulek_"od "_datumOd_", vzdálenost[m]="_vzdalenost_", doba jízdy[min]="_zakladniDobaJizdy
      	s ^||ML("OUT",$i(i))="txt"_del_titulek
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

}
