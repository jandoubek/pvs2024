Include (ALVALIBRARY, ALVAEDFORMS, GENERAL)

Class ALVA.ISY.ISYZastavky.Forms.Tisky.MenuItems Extends %RegisteredObject
{

ClassMethod FormISYZastavkyMainBtnTisk(ByRef sys As %String) As %Status
{
	$$$Init
	try 
	{
		// viditelnost tlačítka -	$lb("Visible", ...)    ... - 0/1  
		//* druh tlačítka -	$lb("TypTlacitka", ...)     ... - $$$TiskTypeBtnPrint (ikonka tiskárny)/ $$$TiskTypeBtnPrintList(ikona dvou gridů pod sebou)
		//* polozka menu - $lb("Item", pozice, jmeno,ikona,text,lzeKliknout,zobrazitFiltr)    
		//					- pozice     		... - libovolný počet úrovní oddělený '.' předek musí existovat, musí jít od nuly jedná se index ve visualku
		//					- jmeno     		... - název tlačítka, slouží k identifikaci při tisku sestavy
		//					- ikona      		... - $$$TiskIkonaWindowTable/ $$$TiskIkonaWindow         ...po dohodě lze doplnit
		//					- text        		... - Zobrazovaný text položky menu
		//					- lzekliknout   ... - zda se na kliknutí na položku má volat metoda pro tisk
		//					- zobrazitFiltr	... - zda se má před tiskem sestavy zobrazit filtr
		// polozka menu - $lb("Separ", pozice)  
		//					- pozice     		... - libovolný počet úrovní oddělený '.' předek musí existovat
	
		
	
		$$$FillParams	
		s ^||ML("OUT",($i(i)))=$lts($lb("Visible",1),del)
		s ^||ML("OUT",($i(i)))=$lts($lb("TypTlacitka",$$$TiskTypeBtnPrint),del)			
		s ^||ML("OUT",($i(i)))=$lts($lb("Item","0","ISYT0001",$$$TiskIkonaWindowTable,"Údaje zastávek [ISYT0001]",1,1),del)	
		s ^||ML("OUT",($i(i)))=$lts($lb("Item","1","ISYT0002",$$$TiskIkonaWindowTable,"Údaje označníků [ISYT0002]",1,1),del)		
		s ^||ML("OUT",($i(i)))=$lts($lb("Item","2","ISYT0006",$$$TiskIkonaWindowTable,"Přehled linek pro zastávku [ISYT0006]",1,1),del)		
		s ^||ML("OUT",($i(i)))=$lts($lb("Item","3","ISYT0008",$$$TiskIkonaWindowTable,"Kontrola duplicity [ISYT0008]",1,1),del)	
	}
	catch (ex) {$$$CatchErrRest}
	quit ret
}

ClassMethod FormISYZastavkyVzdalenostEditBtnTisk(ByRef sys As %String) As %Status
{
	$$$Init
	try 
	{
		// viditelnost tlačítka -	$lb("Visible", ...)    ... - 0/1  
		//* druh tlačítka -	$lb("TypTlacitka", ...)     ... - $$$TiskTypeBtnPrint (ikonka tiskárny)/ $$$TiskTypeBtnPrintList(ikona dvou gridů pod sebou)
		//* polozka menu - $lb("Item", pozice, jmeno,ikona,text,lzeKliknout,zobrazitFiltr)    
		//					- pozice     		... - libovolný počet úrovní oddělený '.' předek musí existovat, musí jít od nuly jedná se index ve visualku
		//					- jmeno     		... - název tlačítka, slouží k identifikaci při tisku sestavy
		//					- ikona      		... - $$$TiskIkonaWindowTable/ $$$TiskIkonaWindow         ...po dohodě lze doplnit
		//					- text        		... - Zobrazovaný text položky menu
		//					- lzekliknout   ... - zda se na kliknutí na položku má volat metoda pro tisk
		//					- zobrazitFiltr	... - zda se má před tiskem sestavy zobrazit filtr
		// polozka menu - $lb("Separ", pozice)  
		//					- pozice     		... - libovolný počet úrovní oddělený '.' předek musí existovat
	
		
	
		$$$FillParams	
		s ^||ML("OUT",($i(i)))=$lts($lb("Visible",1),del)
		s ^||ML("OUT",($i(i)))=$lts($lb("TypTlacitka",$$$TiskTypeBtnPrint),del)			
		s ^||ML("OUT",($i(i)))=$lts($lb("Item","0","ISYT0005",$$$TiskIkonaWindowTable,"Údaje vzdáleností [ISYT0005]",1,1),del)	
	}
	catch (ex) {$$$CatchErrRest}
	quit ret
}

ClassMethod FormISYZastavkyInfoBtnTisk(ByRef sys As %String) As %Status
{
	$$$Init
	try 
	{
		// viditelnost tlačítka -	$lb("Visible", ...)    ... - 0/1  
		//* druh tlačítka -	$lb("TypTlacitka", ...)     ... - $$$TiskTypeBtnPrint (ikonka tiskárny)/ $$$TiskTypeBtnPrintList(ikona dvou gridů pod sebou)
		//* polozka menu - $lb("Item", pozice, jmeno,ikona,text,lzeKliknout,zobrazitFiltr)    
		//					- pozice     		... - libovolný počet úrovní oddělený '.' předek musí existovat, musí jít od nuly jedná se index ve visualku
		//					- jmeno     		... - název tlačítka, slouží k identifikaci při tisku sestavy
		//					- ikona      		... - $$$TiskIkonaWindowTable/ $$$TiskIkonaWindow         ...po dohodě lze doplnit
		//					- text        		... - Zobrazovaný text položky menu
		//					- lzekliknout   ... - zda se na kliknutí na položku má volat metoda pro tisk
		//					- zobrazitFiltr	... - zda se má před tiskem sestavy zobrazit filtr
		// polozka menu - $lb("Separ", pozice)  
		//					- pozice     		... - libovolný počet úrovní oddělený '.' předek musí existovat
	
		$$$FillParams	
		s ^||ML("OUT",($i(i)))=$lts($lb("Visible",1),del)
		s ^||ML("OUT",($i(i)))=$lts($lb("TypTlacitka",$$$TiskTypeBtnPrintList),del)			
		s ^||ML("OUT",($i(i)))=$lts($lb("Item","0","ISYT0003",$$$TiskIkonaWindow,"Přehled linek pro zastávku [ISYT0003]",1,1),del)	
	}
	catch (ex) {$$$CatchErrRest}
	quit ret
}

}
