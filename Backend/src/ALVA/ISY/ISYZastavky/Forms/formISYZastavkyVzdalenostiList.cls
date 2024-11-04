Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostiList Extends %RegisteredObject
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
		d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDoby).seznam(.sys,.arr) i +err zt
		// zobrazim data
		// $lb("ITEM",id řádky,id sloupce,hodnota,RGB barva) barvy fungují jen pokud se zapnou (zpomaluje načítání gridu)
		s abcidx="" f {
			s vzdalenostiJizdniDobyId="" s abcidx=$o(@tmpglblst@("IDX",abcidx),1,vzdalenostiJizdniDobyId) i abcidx="" q
			s valDta=$g(@tmpglblst@("DTA",vzdalenostiJizdniDobyId))
			s idRadku=vzdalenostiJizdniDobyId
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
        s vzdalenostiJizdniDobyId="" f {
	        s vzdalenostiJizdniDobyId=$o(item(vzdalenostiJizdniDobyId)) i vzdalenostiJizdniDobyId="" q
	        k arrDta d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDoby).nacti(.sys,vzdalenostiJizdniDobyId,"",.arrDta)
	        s zkratka=$lg($g(arrDta("DTA")),1)
	        k arrDta d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDoby).vymaz(.sys,vzdalenostiJizdniDobyId,.arrDta)
	        s output($i(i))=$lts($lb("MSG","","Definice vzdáleností "_zkratka_"' byla odstraněna."),del)
        }
		m ^||ML("OUT")=output
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

/// 
/// provede impord dat z jízdních řádů
/// 
ClassMethod ImportDatZJizdnichRadu(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		$$$FillParams
		//nactu udaje z BIG filtru
		s vzdalenostiJizdniDobyId="" s skupinaId="" k arr
		s CTMPGLBFRMIDX=##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyVzdalenostiLisFiltrImportDatZJR).CTMPGLBFRMIDX()
		s bigItem="" f {
			s bigItem=$o($$$CTMPGLBFRM(GUID,CTMPGLBFRMIDX,"DTA",bigItem)) i bigItem="" q
			i bigItem="skupinaId" { s skupinaId=$g($$$CTMPGLBFRM(GUID,CTMPGLBFRMIDX,"DTA",bigItem)) }
			i bigItem="vzdalenostiJizdniDobyId" { s vzdalenostiJizdniDobyId=$g($$$CTMPGLBFRM(GUID,CTMPGLBFRMIDX,"DTA",bigItem)) }
			i bigItem="datumCasVar" { 
				s val=$g($$$CTMPGLBFRM(GUID,CTMPGLBFRMIDX,"DTA",bigItem))
				s arr("PAR","casovaVariantaHorlog")=##class(ALVA.GENERALAPI.Date).DateToHor(val)
			}
			i bigItem="typAktualizace" { 
				s arr("PAR","typAktualizace")=$g($$$CTMPGLBFRM(GUID,CTMPGLBFRMIDX,"DTA",bigItem))
			}
			i bigItem="zakladniDobaJizdyRychlost" {
				s val=$g($$$CTMPGLBFRM(GUID,CTMPGLBFRMIDX,"DTA",bigItem))
				i val s arr("PAR","podleRychlosti")=val
			}
			i bigItem["pasmoDobaJizdyRychlost" {
				s pasmoJizdniDobaId=$p(bigItem,"|",2)
				s val=$g($$$CTMPGLBFRM(GUID,CTMPGLBFRMIDX,"DTA",bigItem))
				i val s arr("PAR","podleRychlosti",pasmoJizdniDobaId)=val
			}
		}
		//import dat
		d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUsekyFce).ImportLinky(.sys,$lb(vzdalenostiJizdniDobyId,skupinaId),.arr)
		m ^||ML("OUT")=output
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

/// 
/// aktualizace vzdalenosti useku podle mapovych podkladu 
/// 
ClassMethod AktualizaceVzdUsekuDleMap(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		$$$FillParams
		//nactu udaje z BIG filtru
		s vzdalenostiJizdniDobyId="" s skupinaId="" k arr
		s CTMPGLBFRMIDX=##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyVzdalenostiListFiltrAktVzdUsekMapy).CTMPGLBFRMIDX()
		s bigItem="" f {
			s bigItem=$o($$$CTMPGLBFRM(GUID,CTMPGLBFRMIDX,"DTA",bigItem)) i bigItem="" q
			i bigItem="vzdalenostiJizdniDobyId" { s vzdalenostiJizdniDobyId=$g($$$CTMPGLBFRM(GUID,CTMPGLBFRMIDX,"DTA",bigItem)) }
		}
		//aktualizace useku
		k arr d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUsekyFce).AktualizacePresneVzdUsekuDleGPS(.sys,vzdalenostiJizdniDobyId,.arr)
		s idx="" f {
			s msg="" s idx=$o(arr("MSG",idx),1,msg) i idx="" q
			s ^||ML("OUT",$i(^||ML("OUT")))="MSG"_del_del_msg
		}
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

}
