Include (ALVALIBRARY, ALVAIMPORT, ALVAEDFORMS, ALVAEDREPORTS)

Class ALVA.ISY.ISYZastavky.Import2.MLAPI Extends %RegisteredObject
{

/// ------------------ POPIS ------------------
/// Vrati sablony agendy
/// ------------------ VSTUP ------------------
/// in("IdFa")=idfa
/// ------------------ VYSTUP -----------------
/// out("Data","Template",template,"Attrs")=$lb(name[String])
/// out("Data","Template",template,"Param",paramIndex)=[ALVA.EDFORMS.CONTROLS.BIG.Item]
ClassMethod GetTemplates(ByRef in As %String, ByRef out As %String) As %Status
{
	s out("Data","Template","T1","Attrs")=$lb("Import označníků")
	k item
	s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,"G1","Obecné","P1","Způsob importu označníků",$$$BigItemDataTypeList,1,1,0,"")
	d item.AddListItem(0_" | "_"zavést pouze nové označníky",0) 
	d item.AddListItem(1_" | "_"zavést nové a aktualizovat stávající označníky",1) 
	s out("Data","Template","T1","Param",1)=item
	//
	s out("Data","Template","T2","Attrs")=$lb("Import zastávek")
	k item
	s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,"G1","Parametry","P1","Oddělovač zón v poli ""Tarifní zóna další"" a ""Odbav.zař. tarifní zóna další(ME)"" ",$$$BigItemDataTypeText,1,1,0,"")	
	d item.AddValue(",","","")
	s out("Data","Template","T2","Param",1)=item
	q $$$OK
}

ClassMethod GetProps(ByRef in As %String, ByRef out As %String) As %Status
{
	s template=in("Template")
	//
	i template="T1" {
		s out("Data","Template","T1","Prop","P0","Attrs")=$lb("Id/Číslo zastávky EDISON",$$$BigItemDataTypeInteger)
		s out("Data","Template","T1","Prop","P0.1","Attrs")=$lb("Id/Číslo zastávky CIS",$$$BigItemDataTypeInteger)
		s out("Data","Template","T1","Prop","P1","Attrs")=$lb("Id/Číslo označníku",$$$BigItemDataTypeInteger)
		s out("Data","Template","T1","Prop","P2","Attrs")=$lb("Nástupiště",$$$BigItemDataTypeText)
		s out("Data","Template","T1","Prop","P3","Attrs")=$lb("GPSN severní šířka",$$$BigItemDataTypeDecimal,,"D2")
        s out("Data","Template","T1","Prop","P4","Attrs")=$lb("GPSE východní délka",$$$BigItemDataTypeDecimal,,"D2")
        s out("Data","Template","T1","Prop","P5","Attrs")=$lb("Popis",$$$BigItemDataTypeText)
        s out("Data","Template","T1","Prop","P6","Attrs")=$lb("Provozovatel",$$$BigItemDataTypeText)
        s out("Data","Template","T1","Prop","P7","Attrs")=$lb("Rádius",$$$BigItemDataTypeInteger)
        s out("Data","Template","T1","Prop","P8","Attrs")=$lb("SMART",$$$BigItemDataTypeInteger)
        s out("Data","Template","T1","Prop","P9","Attrs")=$lb("Odbav.zař.(ME) rádius přiblížení",$$$BigItemDataTypeInteger)
        s out("Data","Template","T1","Prop","P10","Attrs")=$lb("Odbav.zař.(ME) rádius příjezd",$$$BigItemDataTypeInteger)
		s out("Data","Template","T1","Prop","P11","Attrs")=$lb("Odbav.zař.(ME) rádius odjezd",$$$BigItemDataTypeInteger)
		s out("Data","Template","T1","Prop","P12","Attrs")=$lb("Odbav.zař.(ME) rádius opuštění",$$$BigItemDataTypeInteger)
        s out("Data","Template","T1","Prop","P13","Attrs")=$lb("Odbav.zař.(ME) název display",$$$BigItemDataTypeText)
        s out("Data","Template","T1","Prop","P14","Attrs")=$lb("Odbav.zař.(ME) název tisk",$$$BigItemDataTypeText)
        s out("Data","Template","T1","Prop","P15","Attrs")=$lb("Odbav.zař. název tisk a display",$$$BigItemDataTypeText)
        s out("Data","Template","T1","Prop","P16","Attrs")=$lb("Odbav.zař. název LCD",$$$BigItemDataTypeText)
        s out("Data","Template","T1","Prop","P17","Attrs")=$lb("Odbav.zař. název přední tablo",$$$BigItemDataTypeText)
        s out("Data","Template","T1","Prop","P18","Attrs")=$lb("Odbav.zař. název boční tablo",$$$BigItemDataTypeText)
        s out("Data","Template","T1","Prop","P19","Attrs")=$lb("Odbav.zař. název vnitřní tablo",$$$BigItemDataTypeText)
		s out("Data","Template","T1","Prop","P20","Attrs")=$lb("Odbav.zař. název  MHD, LCD",$$$BigItemDataTypeText)
		s out("Data","Template","T1","Prop","P21","Attrs")=$lb("Odbav.zař. název  MHD, přední tablo",$$$BigItemDataTypeText)
        s out("Data","Template","T1","Prop","P22","Attrs")=$lb("Odbav.zař. název MHD, boční tablo",$$$BigItemDataTypeText)
		s out("Data","Template","T1","Prop","P23","Attrs")=$lb("Odbav.zař. název MHD, vnitřní tablo",$$$BigItemDataTypeText)
        s out("Data","Template","T1","Prop","P24","Attrs")=$lb("Parametr pro hlásič",$$$BigItemDataTypeText)
        s out("Data","Template","T1","Prop","P25","Attrs")=$lb("Neukládat souřadnice do GTEL",$$$BigItemDataTypeInteger)
	}
	i template="T2" {
		s out("Data","Template","T2","Prop","P0","Attrs")=$lb("Id/Číslo zastávky EDISON",$$$BigItemDataTypeInteger)
		s out("Data","Template","T2","Prop","P0.1","Attrs")=$lb("Id/Číslo zastávky CIS",$$$BigItemDataTypeInteger)
		s out("Data","Template","T2","Prop","P1","Attrs")=$lb("Obec",$$$BigItemDataTypeText)
		s out("Data","Template","T2","Prop","P2","Attrs")=$lb("Část obce",$$$BigItemDataTypeText)
		s out("Data","Template","T2","Prop","P3","Attrs")=$lb("Lokalita",$$$BigItemDataTypeText)
		s out("Data","Template","T2","Prop","P4","Attrs")=$lb("Blízká obec",$$$BigItemDataTypeText)
		s out("Data","Template","T2","Prop","P5","Attrs")=$lb("Provozovatel",$$$BigItemDataTypeText)
		s out("Data","Template","T2","Prop","P9","Attrs")=$lb("Odbav.zař. - název krátký",$$$BigItemDataTypeText)
		s out("Data","Template","T2","Prop","P10","Attrs")=$lb("Odbav.zař. - název dlouhý",$$$BigItemDataTypeText)
		s out("Data","Template","T2","Prop","P11","Attrs")=$lb("Odbav.zař. - název boční tablo",$$$BigItemDataTypeText)
		s out("Data","Template","T2","Prop","P12","Attrs")=$lb("Odbav.zař. - číslo",$$$BigItemDataTypeInteger)
		s out("Data","Template","T2","Prop","P13","Attrs")=$lb("Název pro MHD",$$$BigItemDataTypeText)
		s out("Data","Template","T2","Prop","P15","Attrs")=$lb("Tarifní zóna",$$$BigItemDataTypeText)
        s out("Data","Template","T2","Prop","P16","Attrs")=$lb("Hraniční IDS",$$$BigItemDataTypeInteger)
        s out("Data","Template","T2","Prop","P17","Attrs")=$lb("Tarifní zóna další",$$$BigItemDataTypeText)
		s out("Data","Template","T2","Prop","P18","Attrs")=$lb("Odbav.zař. - název přední tablo",$$$BigItemDataTypeText)
		s out("Data","Template","T2","Prop","P19","Attrs")=$lb("GPSN severní šířka",$$$BigItemDataTypeDecimal,,"D2")
        s out("Data","Template","T2","Prop","P20","Attrs")=$lb("GPSE východní délka",$$$BigItemDataTypeDecimal,,"D2")
        s out("Data","Template","T2","Prop","P21","Attrs")=$lb("Odbav.zař. - hlásič",$$$BigItemDataTypeText)
        s out("Data","Template","T2","Prop","P23","Attrs")=$lb("Odbav.zař. - rádius",$$$BigItemDataTypeInteger)
        s out("Data","Template","T2","Prop","P24","Attrs")=$lb("Odbav.zař. - název LCD",$$$BigItemDataTypeText)
        s out("Data","Template","T2","Prop","P25","Attrs")=$lb("Odbav.zař. - název tisk a display",$$$BigItemDataTypeText)
        s out("Data","Template","T2","Prop","P29","Attrs")=$lb("Odbav.zař. - název vnitřní tablo",$$$BigItemDataTypeText)
        s out("Data","Template","T2","Prop","P30","Attrs")=$lb("Odbav.zař. - tarifní zóna (ME)",$$$BigItemDataTypeText)
        s out("Data","Template","T2","Prop","P31","Attrs")=$lb("Odbav.zař. - tarifní zóna další (ME)",$$$BigItemDataTypeText)
        s out("Data","Template","T2","Prop","P32","Attrs")=$lb("Odbav.zař. - název MHD, boční tablo",$$$BigItemDataTypeText)
        s out("Data","Template","T2","Prop","P33","Attrs")=$lb("Odbav.zař. - název MHD, vnitřní tablo",$$$BigItemDataTypeText)
        s out("Data","Template","T2","Prop","P35","Attrs")=$lb("Odbav.zař. - název  MHD, přední tablo",$$$BigItemDataTypeText)
        s out("Data","Template","T2","Prop","P38","Attrs")=$lb("Odbav.zař. - název  MHD,LCD",$$$BigItemDataTypeText)
	}
	//
	q $$$OK
}

/// ---------- POPIS -----------
/// Validace dat
/// ---------- VSTUP -----------
/// in("IdFa")=IdFa
/// in("Template")=id typu sablony
/// ------------------ VYSTUP -----------------
/// out("Status)=$lb(state,text)
/// ----------------------------
ClassMethod ValidateData(ByRef in As %String, ByRef out As %String) As %Status
{
	$$$InitImport
	try{ 
		
		/*
			- Data jsou ulozena v globalu ^CacheTempIMPORTDATA pod guid
			- S kazdou validaci je automaticky ulozena dalsi verze dat
			- Struktura dat:
				- ^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop",propId,"DisplayValue")=zobrazena hodnota
				- ^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop",propId,"DataValue")=hodnota v tagu
				- ^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Status")=$lb(state,text) ... stav polozky ve sloupci status
		*/
		// ==================================================================================================================
		// projdu data a prekontroluju data, ma-li položka nastaven $$$BigStateTypeWarning, nebude v Save nahrána do databáze
		// ==================================================================================================================
		s outinfo=""
		// status z automaticke validace
		s out("Status")=in("Status")
		s template=in("Template")
		m sys=^||ML("SYS")
		// overuji posledni verzi dat
		s version=$o(^CacheTempIMPORTDATA(guid,"Data","Version",""),-1)
		// pokud nejaka data vubec jsou
		i version="" s out("Status")=$lb($$$BigStateTypeError,"Nebyla načtena žádná data") q
		// projdu radky
		//
		i template="T1" 
        {
	        // nacteni parametru z bigu pred importem dat
      		k in1,params
      		s in1("template")=template
      		d ##class(ALVA.IMPORT.API.TemplateParam).LoadTemp(.in1,.params)
      		s aktualizaceOznId=$g(params("P1","Value")) //0 jen nove / 1 vse
      		s outinfo="Způsob importu označníků: "
      		i 'aktualizaceOznId s outinfo=outinfo_"zavést pouze nové označníky"
      		i +aktualizaceOznId s outinfo=outinfo_"zavést nové a aktualizovat stávající označníky"
      		// pole pro konverzi zastavek CRZId -> MLIId
	        k tmpArrKonverzeIdZas d ##class(ALVA.ISY.ISYZastavky.API.zastavkyCRZFce).seznamZastavkaCRZId(.sys,.tmpArrKonverzeIdZas) 
			s fileLineIndex=""
         	f {
            	s fileLineIndex=$o(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex))  i fileLineIndex="" q
            	s lineStatus=^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Status")
				s zastavkaId=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P0","DataValue"))
            	s zastavkaCRZId=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P0.1","DataValue"))
				s oznacnikId=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P1","DataValue"))
				s nastupiste=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P2","DataValue"))
	         	s GPSN=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P3","DataValue"))
	         	s GPSE=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P4","DataValue"))
            	s popis=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P5","DataValue"))
	         	s provozovatel=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P6","DataValue"))
	         	s odbZaRadius=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P7","DataValue"))
            	s smart=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P8","DataValue"))
	         	s odbZaRadiusPriblizeni=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P9","DataValue"))
	         	s odbZaRadiusPrijezd=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P10","DataValue"))
            	s odbZaRadiusOdjezd=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P11","DataValue"))
	         	s odbZaRadiusOpusteni=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P12","DataValue"))
	         	s odbZaNazDisplay=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P13","DataValue"))
            	s odbZaNazTisk=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P14","DataValue"))
	         	s odbZaNazTiskDisplay=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P15","DataValue"))
            	s odbZaNazLCD=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P16","DataValue"))
	         	s odbZaNazPredniTablo=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P17","DataValue"))
	         	s odbZaNazBocniTablo=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P18","DataValue"))
            	s odbZaNazVnitrniTablo=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P19","DataValue"))
	         	s odbZaNazMHDLCD=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P20","DataValue"))
	         	s odbZaNazMHDPredniTablo=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P21","DataValue"))
            	s odbZaNazMHDBocniTablo=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P22","DataValue"))
	         	s odbZaNazMHDVnitrniTablo=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P23","DataValue"))
	         	s odbZaHlasic=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P24","DataValue"))
            	s odbZaTLMXNeGpsGTEL=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P25","DataValue"))
            	
            	s lineStatus=$lb($$$BigStateTypeOk,"",3)
				// kontrola zda vstup obsahuje nutne parametry pro identifikaci sloupku
            	i 'oznacnikId {
	            	s lineStatus=$lb($$$BigStateTypeError,"Chybí datová položka Id/Číslo označníku",3)
            	}
				elseif ('zastavkaId) && ('zastavkaCRZId) {
					s lineStatus=$lb($$$BigStateTypeError,"Chybí datová položka Id/Číslo zastavky EDISON/CIS",3)
				}

				// najdeme interni id zastavky z id podle CRZ
				elseif ('zastavkaId) && (zastavkaCRZId) {
					s zastavkaId=$o(tmpArrKonverzeIdZas("DTA",zastavkaCRZId,""))
					i 'zastavkaId {
						s lineStatus=$lb($$$BigStateTypeWarning,"Zastávka s Id/Číslo zastávky CIS "_zastavkaCRZId_" není evidována.",3)
					}
					else {
						s lineStatus=$lb($$$BigStateTypeInformation,"Zastávka s Id/Číslo zastávky CIS "_zastavkaCRZId_" spárována s Id/Číslo zastávky EDISON "_zastavkaId_".",3)
					}
				}
				
				//kontrola zda zastavka existuje
				elseif zastavkaId {
					k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).existuje(.sys,zastavkaId,.arrDta)
					i $g(arrDta("STT")) = 0 {
						 s lineStatus=$lb($$$BigStateTypeWarning,"Zastávka s Id/Číslo zastavky EDISON "_zastavkaId_" neni evidována, označník nebude importován/aktualizován.",3)
					}
				}
			
				// kontrola zda sloupek existuje a neaktualizujeme
				s sloupekExistuje = 0
				i (zastavkaId) && (oznacnikId) {
					k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyOznacniky).existuje(.sys,$lb(zastavkaId, oznacnikId),"",.arrDta)
					s sloupekExistuje=$g(arrDta("STT"))
				}
				i ('aktualizaceOznId) && (sloupekExistuje) {
					s lineStatus=$lb($$$BigStateTypeWarning,"Označník je již evidován, nebude importován.",3)
				}
				
				// kontrolujeme, zda v tomto radku nebyl nalezen error
            	s ^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Status")=lineStatus
	        	i $lg(lineStatus,1)=$$$BigStateTypeError{
            	   	s out("Status")=$lb($$$BigStateTypeError,"Ve vstupních datech byly nalezeny chyby !")
            	}
         	}
         	s out("Info")=outinfo
		}
		//
		i template="T2" 
        {
	        // nacteni parametru z bigu pred importem dat
      		k in1,params
      		s in1("template")=template
      		d ##class(ALVA.IMPORT.API.TemplateParam).LoadTemp(.in1,.params)
      		s oddZona=$g(params("P1","Value"))
      		s outinfo="Oddělovač zón v poli ""Tarifní zóna další"" a ""Odbav.zař. tarifní zóna další(ME)"" : "_oddZona
      		// pole pro konverzi zastavek CRZId -> MLIId
	        k tmpArrKonverzeIdZas d ##class(ALVA.ISY.ISYZastavky.API.zastavkyCRZFce).seznamZastavkaCRZId(.sys,.tmpArrKonverzeIdZas) 
	        //
			s fileLineIndex=""
         	f {
            	s fileLineIndex=$o(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex))  i fileLineIndex="" q
            	s lineStatus=^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Status")
				s zastavkaId=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P0","DataValue"))
            	s zastavkaCRZId=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P0.1","DataValue"))
            
            	s lineStatus=$lb($$$BigStateTypeOk,"",3)
            	
				// kontrola zda vstup obsahuje nutne parametry pro identifikaci zastavky
				i ('zastavkaId) && ('zastavkaCRZId) {
					s lineStatus=$lb($$$BigStateTypeError,"chybí datová položka Id/Číslo zastavky EDISON/CIS !",3)
				}
				// najdeme interni id zastavky z id podle CRZ
				i ('zastavkaId) && (zastavkaCRZId) {
					s zastavkaId=$o(tmpArrKonverzeIdZas("DTA",zastavkaCRZId,""))
					i 'zastavkaId {
						//s lineStatus=$lb($$$BigStateTypeWarning,"zast. s Id/Číslo zastávky CIS "_zastavkaCRZId_" není evidována, data nebudou aktualizována !",3)
						s lineStatus=$lb($$$BigStateTypeError,"zast. s Id/Číslo zastávky CIS "_zastavkaCRZId_" není evidována !",3)
					}
					else {
						//s lineStatus=$lb($$$BigStateTypeInformation,"zast. s Id/Číslo zastávky CIS "_zastavkaCRZId_" spárována s Id/Číslo zastávky EDISON "_zastavkaId,3)
						s lineStatus=$lb($$$BigStateTypeInformation,"zastávka spárována",3)
					}
				}
				
				//kontrola zda zastavka existuje
				i zastavkaId {
					k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).existuje(.sys,zastavkaId,.arrDta)
					i $g(arrDta("STT")) = 0 {
						 //s lineStatus=$lb($$$BigStateTypeWarning,"zast. s Id/Číslo zastavky EDISON "_zastavkaId_" neni evidována, data nebudou aktualizována !",3)
						 s lineStatus=$lb($$$BigStateTypeError,"zast. s Id/Číslo zastavky EDISON "_zastavkaId_" neni evidována !",3)
					}
				}
				// kontrolujeme, zda v tomto radku nebyl nalezen error
            	s ^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Status")=lineStatus
	        	i $lg(lineStatus,1)=$$$BigStateTypeError{
            	   	s out("Status")=$lb($$$BigStateTypeError,"Ve vstupních datech byly nalezeny chyby !")
            	}
         	}
         	s out("Info")=outinfo
		}
		
	} catch ex{
		s out("err")=err
		s out("Status")=$lb($$$BigStateTypeError,"")
		$$$CatchErr
	}
	q ret
}

/// ---------- POPIS -----------
/// Ulozeni dat
/// ---------- VSTUP -----------
/// in("IdFa")=IdFa
/// in("Template")=id typu sablony
/// ------------------ VYSTUP -----------------
/// out("Status)=$lb(state,text)
/// ----------------------------
ClassMethod SaveData(ByRef in As %String, ByRef out As %String) As %Status
{
	$$$InitImport
	try{ 
	
		s out("Status")=$lb($$$BigStateTypeOk,"")
		s template=in("Template")
		m sys=^||ML("SYS")
      	//import oznacniku
        if template="T1" {
			s version=$o(^CacheTempIMPORTDATA(guid,"Data","Version",""),-1)
	        //nacteni parametru z bigu pred importem dat	
      		k in1,params
      		s in1("template")=template
      		d ##class(ALVA.IMPORT.API.TemplateParam).LoadTemp(.in1,.params)
      		s aktualizaceOznId=$g(params("P1","Value")) //0 jen nove / 1 vse
      		// pole pro konverzi zastavek CRZId -> MLIId
	        k tmpArrKonverzeIdZas d ##class(ALVA.ISY.ISYZastavky.API.zastavkyCRZFce).seznamZastavkaCRZId(.sys,.tmpArrKonverzeIdZas) 
			// cteni dat
			s pocetZapisu=0
	        s fileLineIndex="" f {
	         	s fileLineIndex=$o(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex))  i fileLineIndex="" q
            	s lineStatus=^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Status")
				s zastavkaId=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P0","DataValue"))
				s zastavkaCRZId=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P0.1","DataValue"))
            	s oznacnikId=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P1","DataValue"))
            	
            	// neni zastavka
            	i ('zastavkaId) && ('zastavkaCRZId) continue
            	
            	// neni oznacnikId
            	i oznacnikId="" continue
            	
				// odvozeni zastavkaId podle zastavkaCRZId
				i ('zastavkaId) && (zastavkaCRZId) {
					s zastavkaId=$o(tmpArrKonverzeIdZas("DTA",zastavkaCRZId,""))
				}
				//neni zastavkaId
				i zastavkaId="" continue
				
				//kontrola zda zastavka pod zastavkaId existuje
				k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).existuje(.sys,zastavkaId,.arrDta)
				i $g(arrDta("STT")) = 0  continue
				
				// kontrola zda sloupek existuje a neaktualizujeme
				s sloupekExistuje = 0
				k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyOznacniky).existuje(.sys,$lb(zastavkaId, oznacnikId),"",.arrDta)
				s sloupekExistuje=$g(arrDta("STT"))
				i ('aktualizaceOznId)&(sloupekExistuje) continue
				
				// aktualizace udaju
				k arrDta k id s id = $lb(zastavkaId, oznacnikId)
				d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyOznacniky).nacti(.sys,id,"",.arrDta) s arrDta("DTA")=$g(arrDta("DTA"))
				
				f idProp=2:1:25 {
					s idxProp="6/"_template_"/P"_idProp
					s idxDta=(idProp-1)
					i $d(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop",idxProp,"DataValue")) {
						s $li(arrDta("DTA"),idxDta)=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop",idxProp,"DataValue"))
					}
	        	}
	        	
	        	d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyOznacniky).uloz(.sys,id,"",.arrDta)
	        	s pocetZapisu=pocetZapisu+1
	        	
	        }
	        s out("Info")="Bylo aktualizováno "_pocetZapisu_" označníků."
        }
        
        //import zastavek
        if template="T2" {
			s version=$o(^CacheTempIMPORTDATA(guid,"Data","Version",""),-1)
	        //nacteni parametru z bigu pred importem dat	
      		k in1,params
      		s in1("template")=template
      		d ##class(ALVA.IMPORT.API.TemplateParam).LoadTemp(.in1,.params)
      		s oddZona=$g(params("P1","Value"))
      		// pole pro konverzi zastavek CRZId -> MLIId
	        k tmpArrKonverzeIdZas d ##class(ALVA.ISY.ISYZastavky.API.zastavkyCRZFce).seznamZastavkaCRZId(.sys,.tmpArrKonverzeIdZas) 
			// cteni dat
			s pocetZapisu=0
	        s fileLineIndex="" f {
	         	s fileLineIndex=$o(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex))  i fileLineIndex="" q
            	s lineStatus=^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Status")
				s zastavkaId=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P0","DataValue"))
				s zastavkaCRZId=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop","6/"_template_"/P0.1","DataValue"))
            	
            	// neni zastavka
            	i ('zastavkaId) && ('zastavkaCRZId) continue
            	
				// odvozeni zastavkaId podle zastavkaCRZId
				i ('zastavkaId) && (zastavkaCRZId) {
					s zastavkaId=$o(tmpArrKonverzeIdZas("DTA",zastavkaCRZId,""))
				}
				//neni zastavkaId
				i zastavkaId="" continue
				
				//kontrola zda zastavka pod zastavkaId existuje
				k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).existuje(.sys,zastavkaId,.arrDta)
				i $g(arrDta("STT")) = 0  continue
				
				// aktualizace udaju
				k arrDta
				d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaId,"",.arrDta) s arrDta("DTA")=$g(arrDta("DTA"))
				
				f idProp=1,2,3,4,5,9,10,11,12,13,15,16,17,18,19,20,21,23,24,25,29,30,31,32,33,35,38 {
					s idxProp="6/"_template_"/P"_idProp
					s idxDta=idProp
					s val=$g(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop",idxProp,"DataValue"))
					i $d(^CacheTempIMPORTDATA(guid,"Data","Version",version,"Line",fileLineIndex,"Prop",idxProp,"DataValue")) {
						//uprava dat
						//kontrola blizke obce na ciselnik, doplneni
						i idProp=4 {
							i val'="" {
								k isItm s sc=$$isCisItm^JRapi(IdFa,dataDB,2,val,"",.isItm) i sc zt
								i '$g(isItm) {
									s sc=$$sCisItm^JRapi(IdFa,dataDB,2,val,val,"","","") i sc zt
								}
							}
						}
						//kontrola zony na ciselnik, doplneni
						i idProp=15 {
							i val'="" {
								k isItm s sc=$$isCisItm^JRapi(IdFa,dataDB,3,val,"",.isItm) i sc zt
								i '$g(isItm) {
									s sc=$$sCisItm^JRapi(IdFa,dataDB,3,val,val,"","","") i sc zt
								}
							}
						}
						i idProp=16 s val=(val'=0)
						//kontrola zony na ciselnik, doplneni
						i idProp=17 {
							s:(oddZona'="") val=$tr(val,oddZona,",")
							f cnt=1:1:$l(val,",") {
								s id=$p(val,",",cnt)
								i id'="" {
									k isItm s sc=$$isCisItm^JRapi(IdFa,dataDB,3,id,"",.isItm) i sc zt
									i '$g(isItm) {
										s sc=$$sCisItm^JRapi(IdFa,dataDB,3,id,id,"","","") i sc zt
									}
								}
							}
							s val=$lfs(val,",")
						}
						//kontrola zony na ciselnik, doplneni
						i idProp=30 {
							i val'="" {
								k isItm s sc=$$isCisItm^JRapi(IdFa,dataDB,3,val,"",.isItm) i sc zt
								i '$g(isItm) {
									s sc=$$sCisItm^JRapi(IdFa,dataDB,3,val,val,"","","") i sc zt
								}
							}
						}						
						//kontrola zony na ciselnik, doplneni
						i idProp=31 {
							s:(oddZona'="") val=$tr(val,oddZona,",")
							f cnt=1:1:$l(val,",") {
								s id=$p(val,",",cnt)
								i id'="" {
									k isItm s sc=$$isCisItm^JRapi(IdFa,dataDB,3,id,"",.isItm) i sc zt
									i '$g(isItm) {
										s sc=$$sCisItm^JRapi(IdFa,dataDB,3,id,id,"","","") i sc zt
									}
								}
							}
							s val=$lfs(val,",")
						}
						s $li(arrDta("DTA"),idxDta)=val
					}
				}
	        	d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).uloz(.sys,zastavkaId,"",.arrDta)
	        	s pocetZapisu=pocetZapisu+1
	        }
	        s out("Info")="Bylo aktualizováno "_pocetZapisu_" zastávek."
        }
	} catch ex{
		s out("err")=err
		s out("Status")=$lb($$$BigStateTypeError,"")
		$$$CatchErr
	}
	q ret
}

}
