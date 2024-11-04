Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYZastavky.Forms.formISYZastavkyOznaceniList Extends %RegisteredObject
{

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
		s dGlb=$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkyOznaceniList,"DTA"))
		k @dGlb

		s output($i(i))=$lts($lb("ITEM","Img","","I"),del)
		s output($i(i))=$lts($lb("ITEM","id","Id/Číslo"_$c(13,10)_"zastávky","N2|### ### ##0.##"),del) 
		s output($i(i))=$lts($lb("ITEM","typ","Typ","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","obec","Obec","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","castObce","Část obce","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","lokalita","Lokalita","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","blizkaObec","Blízká obec","T",""),del) 
        s output($i(i))=$lts($lb("ITEM","pocetTisku","Počet Tisků","T",""),del) 
		
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
        s dGlb=$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkyOznaceniList,"DTA"))
		s idx="" f {   
			s val="" s idx=$o(^||ML("IN",idx),1,val) i idx="" q 
		}
		
		s zastavkaId="" f {
			s zastavkaId =$o(@dGlb@("DTA","zastavky",zastavkaId),1,valDTA) i zastavkaId="" q
			s idRadku=zastavkaId 
			s obec=$lg(valDTA,1) s castObce=$lg(valDTA,2) s lokalita=$lg(valDTA,3) s blizkaObec=$lg(valDTA,4)
			s name=obec_","_castObce_","_lokalita_"/"_blizkaObec

            // nahrajeme uzivatelem zvoleny pocet tisku. Pokud neni, nahrajeme defualtni
            s pocetTisku = $g(@dGlb@("DTA","pocetTisku",zastavkaId))
            i pocetTisku = "" {
                k arrDta
                d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).getPocetTisku(.sys,zastavkaId,.arrDta)
                s pocetTisku = $lg($g(arrDta("DTA")),1)
                s @dGlb@("DTA","pocetTisku",zastavkaId)=pocetTisku
            }

			s vlakovaZastavka=$lg(valDTA,26)
			s barva = ""
			//barva ikony BG busGreen, BR busRed, VG vlakGreen, VR vlakRed
			i 'vlakovaZastavka {
				s barvaIkony="BG"
				//neni cislo CRZ
				i $lg(valDTA,14)="" {
					s barvaIkony="BR"
				}
				//je cislo CRZ a nesedi nazev
				else {
					s idxCRZ=obec_"~"_castObce_"~"_lokalita_"~"_blizkaObec
					i '$d(^[dataDB]JRCRZ("IZ",idxCRZ)) {s barvaIkony="BR"}
				}
			}
			else {
				s barvaIkony="VG"
			}
            
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"IMG",barvaIkony,barva, name),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"id",zastavkaId,barva, name),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"typ",val,barva, name),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"obec",obec,barva, name),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"castObce",castObce,barva, name),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"lokalita",lokalita,barva, name),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"blizkaObec",blizkaObec,barva, name),del)
            s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"pocetTisku",pocetTisku,barva, name),del)
		 	
		}
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
        s dGlb=$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkyOznaceniList,"DTA"))
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
	        s zastavkaId="" f {
		        s zastavkaId=$o(item(zastavkaId)) i zastavkaId="" q
		        k @dGlb@("DTA","zastavky",zastavkaId)
	        }
        }
		m ^||ML("OUT")=output
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

ClassMethod Update(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		$$$FillParams
        s dGlb=$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkyOznaceniList,"DTA"))
		// pracovni global
		$$$TMPGLBSET(tmpglblst) k @tmpglblst
		// načtu vstup	
		k item //doplnim zastavky +
		s idx="" f {
			s valIn="" s idx=$o(^||ML("IN",idx),1,valIn) i idx="" q
			i $p(valIn,del,1)="ZAS"{
				s zastavkaId=$p(valIn,del,2)
				s item(zastavkaId) = ""
			}
		}
        // pridame polozku
        k output
        i $d(item) {   
	        s zastavkaId="" f {
		        s zastavkaId=$o(item(zastavkaId)) i zastavkaId="" q
		        // pokud jeste neni v seznamu, nacteme a ulozime
				i '$d(@dGlb@("DTA","zastavky",zastavkaId)) {
					k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaId,"",.arrDta)
					s arrDta = $g(arrDta("DTA"))
					s @dGlb@("DTA","zastavky",zastavkaId) = arrDta
				}
	        }
        }
		m ^||ML("OUT")=output
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

ClassMethod ZvetsitPocetTiskuZastavky(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
    $$$Init
	try 
	{		 
		$$$FillParams
        s dGlb=$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkyOznaceniList,"DTA"))
		
		s idx="" f {
			s idx=$o(^||ML("IN",idx),1,radka) q:idx=""
           	s list= $listfromstring(radka,del)
			if $lg(list,1)="Item" s item($lg(list,2)) = ""
		}

		s zastavkaId = "" f {
			s zastavkaId = $o(item(zastavkaId)) i zastavkaId = "" q
			// nahrajeme uzivatelem zvoleny pocet tisku. Pokud neni, nahrajeme defualtni
			s pocetTisku = $g(@dGlb@("DTA","pocetTisku",zastavkaId))
			i pocetTisku = "" {
				k arrDta
				d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).getPocetTisku(.sys,zastavkaId,.arrDta)
				s pocetTisku = $lg($g(arrDta("DTA")),1)
			}
			s @dGlb@("DTA","pocetTisku",zastavkaId) = pocetTisku + 1
		}

    }
    catch (ex) {$$$CatchErrRest}
	q ret
}

ClassMethod ZmensitPocetTiskuZastavky(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
    $$$Init
	try 
	{		 
		$$$FillParams
        s dGlb=$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkyOznaceniList,"DTA"))
		
		// načtu vstup	
		s idx="" f {
			s idx=$o(^||ML("IN",idx),1,radka) q:idx=""
           	s list= $listfromstring(radka,del)
			if $lg(list,1)="Item" s item($lg(list,2)) = ""
		}
       
		s zastavkaId = "" f {
				s zastavkaId = $o(item(zastavkaId)) i zastavkaId = "" q
				// nahrajeme uzivatelem zvoleny pocet tisku. Pokud neni, nahrajeme defualtni
				s pocetTisku = $g(@dGlb@("DTA","pocetTisku",zastavkaId))
				i pocetTisku = "" {
					k arrDta
					d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).getPocetTisku(.sys,zastavkaId,.arrDta)
					s pocetTisku = $lg($g(arrDta("DTA")),1)
				}
				// pocet tisku zdola omezen nulou
				s pocetTisku = pocetTisku - 1 i pocetTisku < 0 s pocetTisku = 0
				s @dGlb@("DTA","pocetTisku",zastavkaId) = pocetTisku
		}
    }
    catch (ex) {$$$CatchErrRest}
	q ret
}

}
