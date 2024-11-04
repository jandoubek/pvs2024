Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYZastavky.Forms.formISYZastavkyZastavkaEdit Extends %RegisteredObject
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
		s idx ="" s ID=""
        f
        {
	        s idx=$o(^||ML("IN",idx),1,radka) i idx="" q
           	s list= $listfromstring(radka,del)
           	i $lg(list,1)="ID"{s ID=($p($lg(list,2),"|",1)) }          
        }
        k $$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit)
        //zastavka existuje
		i ID'="" {
			s $$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"ID")=ID
			d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).DBDoGLB(.sys,ID,$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")))
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
		d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).GLBDoDB(.sys,$g($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"ID")),$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")))
		k $$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit)
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

/// 
/// Init gridu (seznam oznacniku)
/// 
ClassMethod InitFgOznacniky(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{	
		$$$FillParams
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
		//oznacnikId (cislo oznacniku)
		s output($i(i))=$lts($lb("ITEM","id","Id/Číslo","N"),del)
		s output($i(i))=$lts($lb("ITEM","popis","Popis","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","nastupiste","Nástupiště","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","GPSN","GPSN"_$c(13,10)_"severní šířka","N2|### ##0.#############",""),del) 
		s output($i(i))=$lts($lb("ITEM","GPSE","GPSE"_$c(13,10)_"východní délka","N2|### ##0.#############",""),del) 
		s output($i(i))=$lts($lb("ITEM","provozovatel","Provozovatel","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","smart","SMART","B",""),del)
		s output($i(i))=$lts($lb("ITEM","odbZaNazTiskDisplay","Odbav.zař."_$c(13,10)_"název tisk a display","T",""),del)
		s output($i(i))=$lts($lb("ITEM","odbZaNazLCD","Odbav.zař."_$c(13,10)_"název LCD","T",""),del)
		s output($i(i))=$lts($lb("ITEM","odbZaNazPredniTablo","Odbav.zař."_$c(13,10)_"název přední tablo","T",""),del)
		s output($i(i))=$lts($lb("ITEM","odbZaNazBocniTablo","Odbav.zař."_$c(13,10)_"název boční tablo","T",""),del)
		s output($i(i))=$lts($lb("ITEM","odbZaNazVnitrniTablo","Odbav.zař."_$c(13,10)_"název vnitřní tablo","T",""),del)
		s output($i(i))=$lts($lb("ITEM","odbZaNazMHDLCD","Odbav.zař."_$c(13,10)_"název  MHD, LCD","T",""),del)
		s output($i(i))=$lts($lb("ITEM","odbZaNazMHDPredniTablo","Odbav.zař."_$c(13,10)_"název  MHD, přední tablo","T",""),del)
		s output($i(i))=$lts($lb("ITEM","odbZaNazMHDBocniTablo","Odbav.zař."_$c(13,10)_"název MHD, boční tablo","T",""),del)
		s output($i(i))=$lts($lb("ITEM","odbZaNazMHDVnitrniTablo","Odbav.zař."_$c(13,10)_"název MHD, vnitřní tablo","T",""),del)
		s output($i(i))=$lts($lb("ITEM","odbZaHlasic","Odbav.zař."_$c(13,10)_"hlásič","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","odbZaRadius","Odbav.zař."_$c(13,10)_"rádius","N",""),del) 
		s output($i(i))=$lts($lb("ITEM","odbZaRadiusPriblizeni","Odbav.zař.ME"_$c(13,10)_"rádius přiblížení","N",""),del) 
		s output($i(i))=$lts($lb("ITEM","odbZaRadiusPrijezd","Odbav.zař.ME"_$c(13,10)_"rádius příjezd","N",""),del) 
		s output($i(i))=$lts($lb("ITEM","odbZaRadiusOdjezd","Odbav.zař.ME"_$c(13,10)_"rádius odjezd","N",""),del) 
		s output($i(i))=$lts($lb("ITEM","odbZaRadiusOpusteni","Odbav.zař.ME"_$c(13,10)_"rádius opuštění","N",""),del) 
		s output($i(i))=$lts($lb("ITEM","odbZaBodNazDisplay","Odbav.zař.ME"_$c(13,10)_"název bodu pro display","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","odbZaBodNazTisk","Odbav.zař.ME"_$c(13,10)_"název bodu pro tisk","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","odbZaNazDisplay","Odbav.zař.ME"_$c(13,10)_"název pro display ","T",""),del) 
		m ^||ML("OUT")=output 
	}
	catch (ex){$$$CatchErrRest}
 	q ret
}

/// 
/// Load gridu (načtení jednotlivých řádek)
/// 
ClassMethod LoadFgOznacniky(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		$$$FillParams
		// Načtu filtr	
		// filtr(nazevkomponenty)= hodnota   a pokud jich je víc filtr(nazevkomponenty, hodnota)=""
		$$$GetFiltr
		k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyOznacniky).seznam(.sys,"",$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),.arrDta)
		s oznacnikId="" f {
			s valDta="" s oznacnikId=$o(arrDta("DTA",oznacnikId),1,valDta) i oznacnikId="" q
			s idRadku=oznacnikId
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"id",oznacnikId),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"nastupiste",$lg(valDta,1)),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"GPSN",$s($lg(valDta,2)'="":+$lg(valDta,2),1:"")),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"GPSE",$s($lg(valDta,3)'="":+$lg(valDta,3),1:"")),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"popis",$lg(valDta,4)),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"provozovatel",$lg(valDta,5)),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"smart",+$lg(valDta,7)),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"odbZaNazTiskDisplay",$lg(valDta,14)),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"odbZaNazLCD",$lg(valDta,15)),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"odbZaNazPredniTablo",$lg(valDta,16)),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"odbZaNazBocniTablo",$lg(valDta,17)),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"odbZaNazVnitrniTablo",$lg(valDta,18)),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"odbZaNazMHDLCD",$lg(valDta,19)),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"odbZaNazMHDPredniTablo",$lg(valDta,20)),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"odbZaNazMHDBocniTablo",$lg(valDta,21)),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"odbZaNazMHDVnitrniTablo",$lg(valDta,22)),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"odbZaHlasic",$lg(valDta,23)),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"odbZaRadius",$lg(valDta,6)),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"odbZaRadiusPriblizeni",$lg(valDta,8)),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"odbZaRadiusPrijezd",$lg(valDta,9)),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"odbZaRadiusOdjezd",$lg(valDta,10)),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"odbZaRadiusOpusteni",$lg(valDta,11)),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"odbZaBodNazDisplay",$lg(valDta,12)),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"odbZaBodNazTisk",$lg(valDta,13)),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"odbZaNazDisplay",$lg(valDta,25)),del)
		}
	
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

/// 
/// Odstraní položku označníku
/// 
ClassMethod DeleteOznacnik(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		$$$FillParams	
		// načtu vstup	
		k item s idx =""
        for
        {
	        s idx=$o(^||ML("IN",idx),1,radka) q:idx=""
           	s list= $listfromstring(radka,del)
           	if $lg(list,1)="Item"{s item($lg(list,2))="" }          
        }  
        // odeberu polozku
        k output
  		s oznacnikId="" for {
	  		s oznacnikId=$o(item(oznacnikId)) i oznacnikId="" q
	  		d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyOznacniky).vymaz(.sys,$lb("",oznacnikId),$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),"")
	  		s output($i(i))=$lts($lb("MSG","","Označník s id/číslem "_oznacnikId_" byl odstraněn."),del)
  		}
		m ^||ML("OUT")=output
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

/// 
/// Odstraní položku historie
/// 
ClassMethod DeleteHistorie(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		$$$FillParams
		//ciselniky
      	k arrCisCasoveVariantyUdajuZastavek d ##class(ALVA.ISY.ISYCiselniky.API.CasoveVariantyUdajuZastavek).seznam(.sys,.arrCisCasoveVariantyUdajuZastavek)
		// načtu vstup	
		k item s idx =""
        for
        {
	        s idx=$o(^||ML("IN",idx),1,radka) q:idx=""
           	s list= $listfromstring(radka,del)
           	if $lg(list,1)="Item"{s item($lg(list,2))="" }          
        }  
        // odeberu polozky
        k output
  		s id="" f {
	  		s id=$o(item(id)) i id="" q
	  		s udajId=$p(id,"|",1) s horolog=$p(id,"|",2)
	  		d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyCasoveVariatyUdaju).vymaz(.sys,$lb("",udajId,horolog),$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),"")
	  		s udajTx=$lg($g(arrCisCasoveVariantyUdajuZastavek("DTA",udajId)),1)
	  		s output($i(i))=$lts($lb("MSG","","Časová var. údaje "_udajTx_" z "_##class(ALVA.GENERALAPI.Date).horToDate(horolog)_" byla odstraněna."),del)
  		}
		m ^||ML("OUT")=output
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

/// 
/// Init gridu
/// 
ClassMethod InitFgSoubory(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{	
		$$$FillParams
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
		//oznacnikId (cislo oznacniku)
		
		s output($i(i))=$lts($lb("ITEM","firma","Firma","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","nazev","Název","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","aktUz","Aktualizoval","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","aktDt","Aktualizováno","DT",""),del) 
		m ^||ML("OUT")=output 
	}
	catch (ex){$$$CatchErrRest}
 	q ret
}

/// 
/// Load gridu (načtení jednotlivých řádek)
/// 
ClassMethod LoadFgSoubory(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		$$$FillParams
		// Načtu filtr	
		// filtr(nazevkomponenty)= hodnota   a pokud jich je víc filtr(nazevkomponenty, hodnota)=""
		$$$GetFiltr
		
       // ^["MLINE"]KZ.TEST.CIS.FILES("Cis",cis,"IdFa",IdFa,"File")=$lb($h_posledni_update)
       // ^["MLINE"]KZ.TEST.CIS.FILES("Cis",cis,"IdFa",IdFa,"File",key)=$lb($h,name,size,type,modified,user(email))
       // ^["MLINE"]KZ.TEST.CIS.FILES("Cis",cis,"IdFa",IdFa,"File",key,"RAW",idx)=raw_data
       
       s zCis=^||ML("IN",1)
       
       s idRadku=$i(idRadku)
       s key="" s idfa=""
       i zCis'="" {
	       f {
		       s idfa=$o(^["MLINE"]ALVA.ISY.ZAS.SOUBORY("Cis",zCis,"IdFa",idfa)) q:idfa=""
	       	   f {
		       	   s key=$o(^["MLINE"]ALVA.ISY.ZAS.SOUBORY("Cis",zCis,"IdFa",idfa,"File",key)) q:key=""
		       	   s veta=^["MLINE"]ALVA.ISY.ZAS.SOUBORY("Cis",zCis,"IdFa",idfa,"File",key)
		       
		       	   s idRadku=zCis_"~"_idfa_"~"_key
		       	   s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"firma",idfa),del)
		       	   s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"nazev",$lg(veta,2)),del)	
		       	   s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"aktUz",$lg(veta,6)),del)	
		       	   s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"aktDt",$tr($zdt($lg(veta,1),4),"/",".")),del)	
	       	   }
       		}
       	}
	}
	
	catch (ex) {
		$$$CatchErrRest
		}
	q ret
}

/// 
/// Init gridu
/// 
ClassMethod InitFgHistorie(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{	
		$$$FillParams
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
		//oznacnikId (cislo oznacniku)
		//
		s output($i(i))=$lts($lb("ITEM","udajTx","Údaj","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","platiOd","Platí od","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","hodnota","Hodnota","T",""),del) 
		//
		m ^||ML("OUT")=output 
	}
	catch (ex){$$$CatchErrRest}
 	q ret
}

/// 
/// Load gridu (načtení jednotlivých řádek)
/// 
ClassMethod LoadFgHistorie(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		$$$FillParams
		// Načtu filtr	
		// filtr(nazevkomponenty)= hodnota   a pokud jich je víc filtr(nazevkomponenty, hodnota)=""
		$$$GetFiltr
		s dGlb=$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA"))
		//ciselniky
		k arrCisCasoveVariantyUdajuZastavek d ##class(ALVA.ISY.ISYCiselniky.API.CasoveVariantyUdajuZastavek).seznam(.sys,.arrCisCasoveVariantyUdajuZastavek)
		k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyCasoveVariatyUdaju).seznam(.sys,"",dGlb,.arrDta)
		s udajId="" f {
			s udajId=$o(arrDta("DTA",udajId)) i udajId="" q
			s udajTx=$lg($g(arrCisCasoveVariantyUdajuZastavek("DTA",udajId)),1)
			s hrl="" f {
				s valDta="" s hrl=$o(arrDta("DTA",udajId,hrl),-1,valDta) i hrl="" q
				s datum=##class(ALVA.GENERALAPI.Date).horToDate(hrl)
				s idRadku=udajId_"|"_hrl
				s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"udajTx",udajTx),del)	
	    		s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"platiOd",datum),del)	
	    		s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"hodnota",$lts(valDta,";")),del)	
			}
		}
	}
	catch (ex) {
		$$$CatchErrRest
		}
	q ret
}

ClassMethod NacistSouradnice(ByRef sys As %String)
{
	//  Funkce najde souradnice zastavky a posle je do .NETU kde se zobrazi uzivali a ten odsouhlasi, jestli je zmenit
	//	Pokud zvoli ANO, vola se obdobna funkce NacistAlozitSouradnice ktera je rovnou zapise do bigu.


	$$$Init
	try 
	{		 
		$$$FillParams
				
		s dGlb=$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA"))
		k arrDTA d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,"",dGlb,.arrDTA)
		s arrDTA("DTA")=$g(arrDTA("DTA")) s cisId=$lg(arrDTA("DTA"),14)
		i cisId {
			d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).getSouradnice(.sys,cisId,.arr)
			s lon=$lg(arr("DTA"),1)
			s lat=$lg(arr("DTA"),2)

			s ^||ML("OUT",$i(^||ML("OUT"))) = lat
			s ^||ML("OUT",$i(^||ML("OUT"))) = lon
		}
	}
	catch (ex) {
		$$$CatchErrRest
		}
	q ret
}

ClassMethod NacistAlozitSouradnice(ByRef sys As %String)
{
	$$$Init
	try 
	{		 
		$$$FillParams
				
		s dGlb=$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA"))
		k arrDTA d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,"",dGlb,.arrDTA)
		s arrDTA("DTA")=$g(arrDTA("DTA")) s cisId=$lg(arrDTA("DTA"),14)
		i cisId {
			d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).getSouradnice(.sys,cisId,.arr)
			s lon=$lg(arr("DTA"),1)
			s lat=$lg(arr("DTA"),2)
			s $li(arrDTA("DTA"),19)=lat
			s $li(arrDTA("DTA"),20)=lon
			d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).uloz(.sys,"",dGlb,.arrDTA)
		}
	}
	catch (ex) {
		$$$CatchErrRest
		}
	q ret
}

ClassMethod VratDataSouradnikuAZastavky(ByRef sys As %String)
{
	// 	funkce vrati id vsech souradniku, jejich souradnice, nazev a souradnice zastavky
	//	Pouziva se pro hromadne upravy 

	$$$Init
	try 
	{	
		$$$FillParams
		s dGlb=$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA"))

		k arrDTA d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,"",dGlb,.arrDTA)
		s zastNazev=$lg(arrDTA("DTA"),1)_","_$lg(arrDTA("DTA"),2)_","_$lg(arrDTA("DTA"),3)

		
		
		s zasGPSN = $lg($g(arrDTA("DTA")),19)
		s zasGPSE = $lg($g(arrDTA("DTA")),20)

		s ^||ML("OUT",$i(^||ML("OUT"))) = $lts($lb(zastNazev,zasGPSN,zasGPSE),del)
		
		k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyOznacniky).seznam(.sys,"",dGlb,.arrDta)
		s oznacnikId="" f {
			s valDta="" s oznacnikId=$o(arrDta("DTA",oznacnikId),1,valDta) i oznacnikId="" q
			s GPSN = $lg(valDta,2)
			s GPSE = $lg(valDta,3)
			s ^||ML("OUT",$i(^||ML("OUT"))) = $lts($lb(oznacnikId,GPSN,GPSE),del)
		}
	}
	catch (ex){$$$CatchErrRest}
 	q ret
}

ClassMethod HromadnyEditOznacniku(ByRef sys As %String)
{
	// 	funkce dostane oznacniky a snovymi souradnicemi. Ty ulozi

	$$$Init
	try 
	{	
		$$$FillParams

		k oznacnikDta s oznacniky = ""

		// načtu vstup	
		s idx =""
        f
        {
	        s idx=$o(^||ML("IN",idx),1,radka) i idx="" q
           	s list= $listfromstring(radka,del)
           	s oznacnikId= $p($lg(list,1),del,1)
			s GPSN = $p($lg(list,2),del,1)
			s GPSE = $p($lg(list,3),del,1)
			s oznacnikDta(oznacnikId) = $lb(GPSN,GPSE)
        }

		s dGlb=$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA"))
		
		s oznacnikId="" f {
			k valDta  s oznacnikId =  $o(oznacnikDta(oznacnikId),1,valDta) i oznacnikId="" q
			s GPSN = $lg(valDta,1)
			s GPSE = $lg(valDta,2)
			k dta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyOznacniky).nacti(.sys,$lb("",oznacnikId),dGlb,.dta)
			s dta = $g(dta("DTA"))
			s $list(dta,2) = $decimal($replace(GPSN,",","."),15)
			s $list(dta,3) = $decimal($replace(GPSE,",","."),15)
			k arrDta s arrDta("DTA") = dta
			d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyOznacniky).uloz(.sys,$lb("",oznacnikId),dGlb,.arrDta)
		}

	}
	catch (ex){$$$CatchErrRest}
 	q ret
}

}
