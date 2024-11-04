Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVyhledatPREZ Extends %RegisteredObject
{

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
		//$lb("ITEM",id sloupce,název sloupce,typ,*editable -defaultně ne nemusí se vyplňovat)   barvy fungují jen pokud se zapnou (zpomaluje načítání gridu)		 
		$$$FillParams
		s output($i(i))=$lts($lb("ITEM","Img","","I"),del)
		s output($i(i))=$lts($lb("ITEM","id","Id/Číslo"_$c(13,10)_"Zastávky","N2|### ##0.##"),del) 
		s output($i(i))=$lts($lb("ITEM","typ","Typ","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","obec","Obec","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","castObce","Část obce","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","lokalita","Lokalita","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","blizkaObec","Blízká obec","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","nazevMHD","Název pro MHD","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","GPSN","GPSN"_$c(13,10)_"severní šířka","N2|### ##0.##########"),del) 
		s output($i(i))=$lts($lb("ITEM","GPSE","GPSE"_$c(13,10)_"východní délka","N2|### ##0.##########"),del) 
		s output($i(i))=$lts($lb("ITEM","cisloCIS","Číslo CIS","N",""),del) 
		s output($i(i))=$lts($lb("ITEM","cisloSR70","Číslo SR70","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","cisloSR70M","Číslo SR70"_$c(13,10)_"mezinárodní","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","atribut","Atribut","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","provozovatel","Provozovatel","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","casovePasmo","Časové pásmo","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","smerTyp","Směr typ","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","tarZona","Tarifní zóna","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","hranicniIDS","Hraniční IDS","B",""),del) 
		s output($i(i))=$lts($lb("ITEM","tarZonaDalsi","Tarifní zóna"_$c(13,10)_"další","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","smart","SMART","B",""),del)  
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
		k arr s arr("GLB")=tmpglblst s arr("PAR","hledanyText")=$g(filtr("txbNazev"))
		d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).seznam(.sys,.arr)
		// zobrazim data
		// $lb("ITEM",id řádky,id sloupce,hodnota,RGB barva)   barvy fungují jen pokud se zapnou (spomaluje načítání gridu)
		s abcidx="" f {
			s zastavkaId="" s abcidx=$o(@tmpglblst@("IDX",abcidx),1,zastavkaId) i abcidx="" q
			s valDTA=$g(@tmpglblst@("DTA",zastavkaId))
			s idRadku=zastavkaId //_"|"_$lg(valDTA,1)_","_$lg(valDTA,2)_","_$lg(valDTA,3)_"/"_$lg(valDTA,4)
			//barva ikony
			s barvaIkony="BG"
			//autobusova
			i '$lg(valDTA,26) {
				i $lg(valDTA,14)="" s barvaIkony="BR"
			}
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"IMG",barvaIkony),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"id",zastavkaId),del)
		 	s val=$lg(valDTA,39)
		 	i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"typ",val),del)
		 	s val=$lg(valDTA,1)
		 	i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"obec",val),del)
		 	s val=$lg(valDTA,2)
		 	i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"castObce",val),del)
		 	s val=$lg(valDTA,3)
		 	i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"lokalita",val),del)
		 	s val=$lg(valDTA,4)
		 	i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"blizkaObec",val),del)
		 	s val=$lg(valDTA,13)
		 	i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"nazevMHD",val),del)
		 	s val=$lg(valDTA,19)
		 	i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"GPSN",val),del)
		 	s val=$lg(valDTA,20)
		 	i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"GPSE",val),del)
		 	s val=$lg(valDTA,14)
		 	i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"cisloCIS",val),del)
			s val=$lg(valDTA,27)
			i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"cisloSR70",val),del)
			s val=$lg(valDTA,34)
			i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"cisloSR70M",val),del)
			s val=$lts($lg(valDTA,7),";")
			i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"atribut",val),del)
			s val=$lg(valDTA,5)
			i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"provozovatel",val),del)
			s val=$lg(valDTA,6)
			i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"casovePasmo",val),del)
			s val=$lg(valDTA,8) s val=$p("jednosměrná~obousměrná","~",(val+1))
			i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"smerTyp",val),del)
			s val=$lg(valDTA,15)
			i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"tarZona",val),del)
			s val=+$lg(valDTA,16)
			i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"hranicniIDS",val),del)
			s val=$lts($lg(valDTA,17),";")
			i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"tarZonaDalsi",val),del)
			s val=+$lg(valDTA,36)
			i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"smart",val),del)
		}
		k @tmpglblst
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
		m ^||ML("OUT")=output
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
		// pracovni global
		$$$TMPGLBSET(tmpglblst) k @tmpglblst
		// načtu vstup	
		k item s idx=""
        for
        {
	        s idx=$o(^||ML("IN",idx),1,radka) q:idx=""
           	s list= $listfromstring(radka,del)
           	if $lg(list,1)="Item"{s item($lg(list,2))="" }          
        }
        // odeberu polozku
        k output
        i $d(item) {   
	        //nactu pouzite zastavky
	        k arr s arr("GLB")=tmpglblst s err=##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).pouziteZastavky(.sys,.arr) i +err zt
	        //
	        s zastavkaId="" f {
		        s zastavkaId=$o(item(zastavkaId)) i zastavkaId="" q
		        k arr d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaId,"",.arr)
		        s valDta=$g(arr("DTA"))
		        s zastavkaNazev=$lg(valDta,1)_","_$lg(valDta,2)_","_$lg(valDta,3)_"/"_$lg(valDta,4)
		        //pouzita zastavka
		        i $d(@tmpglblst@("DTA",zastavkaId)) {
			        s output($i(i))=$lts($lb("MSG","","zastávku "_zastavkaId_" / "_zastavkaNazev_" nelze odstranit, je použita na linkách !"),del)
		        }
		        //nepouzita zastavka - vymazu
		        else {
			        k arr d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).vymaz(.sys,zastavkaId,.arr)
			        s output($i(i))=$lts($lb("MSG","","zastávka "_zastavkaId_" / "_zastavkaNazev_" byla odstraněna !"),del)
		        }
	        }
        }
		m ^||ML("OUT")=output
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

}
