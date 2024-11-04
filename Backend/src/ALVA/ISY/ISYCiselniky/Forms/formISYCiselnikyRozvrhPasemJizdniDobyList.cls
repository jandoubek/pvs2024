Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYCiselniky.Forms.formISYCiselnikyRozvrhPasemJizdniDobyList Extends %RegisteredObject
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
		s output($i(i))=$lts($lb("TITLE","Rozvrh pásem jízdní doby"),del) 
		s output($i(i))=$lts($lb("ITEM","zkratka","Zkratka","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","popis","Popis","T",""),del) 
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
		d ##class(ALVA.ISY.ISYCiselniky.API.RozvrhPasemJizdniDoby).seznam(.sys,.arr) i +err zt
		// zobrazim data
		// $lb("ITEM",id řádky,id sloupce,hodnota,RGB barva) barvy fungují jen pokud se zapnou (zpomaluje načítání gridu)
		s abcidx="" f {
			s rozvrhPasemJizdniDobyId="" s abcidx=$o(@tmpglblst@("IDX",abcidx),1,rozvrhPasemJizdniDobyId) i abcidx="" q
			s valDta=$g(@tmpglblst@("DTA",rozvrhPasemJizdniDobyId))
			s idRadku=rozvrhPasemJizdniDobyId
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"zkratka",$lg(valDta,1)),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"popis",$lg(valDta,2)),del)
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
		s idx ="" k item
				for
				{
					s idx=$o(^||ML("IN",idx),1,radka) q:idx=""
						s list= $listfromstring(radka,del)
						if $lg(list,1)="Item"{s item($lg(list,2))="" }          
				}  
				// odeberu položku
				k output
				s rozvrhPasemJizdniDobyId="" f {
					s rozvrhPasemJizdniDobyId=$o(item(rozvrhPasemJizdniDobyId)) i rozvrhPasemJizdniDobyId="" q
					k arrDta d ##class(ALVA.ISY.ISYCiselniky.API.RozvrhPasemJizdniDoby).nacti(.sys,rozvrhPasemJizdniDobyId,.arrDta)
					s zkratka=$lg($g(arrDta("DTA")),1)
					k arrDta d ##class(ALVA.ISY.ISYCiselniky.API.RozvrhPasemJizdniDoby).vymaz(.sys,rozvrhPasemJizdniDobyId,.arrDta)
					s output($i(i))=$lts($lb("MSG","","Rozvrh jízdních dob "_zkratka_"' byl odstraněna."),del)
				}
		m ^||ML("OUT")=output
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

}
