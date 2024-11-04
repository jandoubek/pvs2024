Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYCiselniky.Forms.formISYCiselnikyOblastiLinekList Extends %RegisteredObject
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
		//$lb("ITEM",id sloupce,název sloupce,typ,*editable -defaultně ne nemusí se vyplňovat)   barvy fungují jen pokud se zapnou (spomaluje načítání gridu)		 
		 $$$FillParams 
		 k output
		 s output($i(i))=$lts($lb("ITEM","skupinaId","číslo","N",""),del)
		 s output($i(i))=$lts($lb("ITEM","nazev","název","T",""),del)
		 s output($i(i))=$lts($lb("ITEM","skupinaTyp","skupinaTyp","T",""),del)
		 s output($i(i))=$lts($lb("ITEM","platiOd","platí od","D",""),del)
		 s output($i(i))=$lts($lb("ITEM","platiDo","platí do","D",""),del)
		 s output($i(i))=$lts($lb("ITEM","uzamcenoZmeny","uzamčeno"_$c(13,10)_"změny","B",""),del)
		 s output($i(i))=$lts($lb("ITEM","obsahujeLinky","obsahuje"_$c(13,10)_"linky","B",""),del)
		 s output($i(i))=$lts($lb("ITEM","obsahujeOdjezdy","obsahuje"_$c(13,10)_"odjezdy","B",""),del)
		 s output($i(i))=$lts($lb("ITEM","obsahujePrijezdy","obsahuje"_$c(13,10)_"příjezdy","B",""),del)
		 s output($i(i))=$lts($lb("ITEM","obsahujeObehy","obsahuje"_$c(13,10)_"oběhy","B",""),del)
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
		// ciselnik typu skupin linek
		k arrCisTypySkupinLinek d ##class(ALVA.ISY.ISYCiselniky.API.TypySkupinLinek).seznam(.sys,.arrCisTypySkupinLinek)
		// Načtu filtr	
		// filtr(nazevkomponenty)= hodnota   a pokud jich je víc filtr(nazevkomponenty, hodnota)=""
		$$$GetFiltr
		k arr s arr("GLB")=tmpglblst s arr("PAR","hledanyText")=$g(filtr("txbNazev"))
		d ##class(ALVA.ISY.ISYCiselniky.API.SkupinyLinek).seznam(.sys,.arr) i +err zt
		// zobrazim data
		// $lb("ITEM",id řádky,id sloupce,hodnota,RGB barva) barvy fungují jen pokud se zapnou (zpomaluje načítání gridu)
		s abcidx="" f {
			s skupinaId="" s abcidx=$o(@tmpglblst@("IDX",abcidx),1,skupinaId) i abcidx="" q
			s valDta=$g(@tmpglblst@("DTA",skupinaId))
			s idRadku=skupinaId //_"|"_$lg(valDta,1)
			s name=$lg(valDta,1)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"skupinaId",skupinaId,"",name),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"nazev",name,"",name),del)
			s typSkupinyLinekId=$lg(valDta,7) s typSkupinyLinekNazev="" i typSkupinyLinekId'="" s typSkupinyLinekNazev=$lg($g(arrCisTypySkupinLinek("DTA",typSkupinyLinekId)),1)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"skupinaTyp",typSkupinyLinekNazev,"",name),del)
			s horlog=$lg(valDta,2) s datum="" i horlog s datum=##class(ALVA.GENERALAPI.Date).horToDate(horlog) 
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"platiOd",datum,"",name),del)
			s horlog=$lg(valDta,3) s datum="" i horlog s datum=##class(ALVA.GENERALAPI.Date).horToDate(horlog) 
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"platiDo",datum,"",name),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"uzamcenoZmeny",(+$lg(valDta,4)),"",name),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"obsahujeLinky",($o(^[dataDB]JRL(skupinaId,""))'=""),"",name),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"obsahujeOdjezdy",($o(^[dataDB]JRi("Odj",skupinaId,""))'=""),"",name),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"obsahujePrijezdy",($o(^[dataDB]JRi("Pri",skupinaId,""))'=""),"",name),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"obsahujeObehy",($d(^[dataDB]ALVA.ISY.OBH("IDX",1,skupinaId))>0),"",name),del)
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
		// načtu vstup	
		s idx="" k item
				for
				{
					s idx=$o(^||ML("IN",idx),1,radka) q:idx=""
						s list= $listfromstring(radka,del)
						if $lg(list,1)="Item"{s item($lg(list,2))="" }          
				}  
				// odeberu položku
				k output
				s polozkaId="" f {
					s polozkaId=$o(item(polozkaId)) i polozkaId="" q
					k arrDta
					d ##class(ALVA.ISY.ISYCiselniky.API.SkupinyLinek).nacti(.sys,polozkaId,.arrDta)
					s nazev=$lg($g(arrDta("DTA")),1)
					k arrDta
					d ##class(ALVA.ISY.ISYCiselniky.API.SkupinyLinek).vymaz(.sys,polozkaId,"")
					 s output($i(i))=$lts($lb("MSG","","položka '"_polozkaId_" / "_nazev_"' byla odstraněna"),del)      
			}  
		m ^||ML("OUT")=output
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

}
