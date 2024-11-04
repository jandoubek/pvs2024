Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY, ALVAEDREPORTS)

Class ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyZastavkaEdit Extends %RegisteredObject
{

/// init BIG
ClassMethod InitObec(ByRef err As %String, ByRef in As %String, ByRef list As %ListOfObjects) As %String
{

   $$$Init
    try
    {
	  //systemove promenne
	  $$$FillSysParamsBig(in)
	  s actionId=$lg(in("Action"),2) s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
	  //
	  #dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
      #dim value As ALVA.EDFORMS.CONTROLS.BIG.ItemValue     
      /*
      //priklad cteni uzivatelskych parametru
      s userParametr = $o(in("ParamEx","ID",""))
      s listId = $lfs(userParametr,"|")
      s agd = $lg(listId,1)
      s idp = $lg(listId,2)
      s userParametr = $o(in("ParamEx","Edit",""))
      s listId = $lfs(userParametr,"|")
      */
      //nacteni dat z databaze
      k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,"",$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),.arrDta)
	  //naplneni bigu
      s bigGroup="G1" s bigGroupName="Obecné"
      // === cislo/id zastavky
      s bigItem="id" s bigItemName = "Id/Číslo zastávky" s bigDataType = $$$BigItemDataTypeInteger
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=1
      i actionMode=4 s bigAllowEdit=0	//u editu nepovolim editaci
      s val=$g($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"ID"))
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      i 'val {
	      d item.UpdateStatus($$$BigStateTypeInformation,"bude automaticky doplněno při zápisu do databáze")
      }
      d list.Insert(item)
      //=== typ zastavky
      s bigItem="typ" s bigItemName="Typ" s bigDataType=$$$BigItemDataTypeList
      s bigRequired=1 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),39)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"") 
	  d item.AddValue(val,"","")
	  k arrCis d ##class(ALVA.ISY.ISYCiselniky.API.TypyZastavek).seznam(.sys,.arrCis)
	  s polozkaId="" f {
		  s dtaCis="" s polozkaId=$o(arrCis("DTA",polozkaId),1,dtaCis) i polozkaId="" q
		  s nazev=$lg(dtaCis,1)
		  d item.AddListItem(nazev,polozkaId)
	  }
      d list.Insert(item)
      // === vlakova
      s bigItem="vlakova" s bigItemName="Vlaková" s bigDataType=$$$BigItemDataTypeBoolean
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=1
      s val=$lg($g(arrDta("DTA")),26)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      //
      s bigGroup="G2" s bigGroupName="Název"
      // === obec
      s bigItem="obec" s bigItemName="Obec" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=1 s bigAllowEdit=1 s bigValidation=1
      s val=$lg($g(arrDta("DTA")),1)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      s item.Selectable =1
      s item.SelectableFormID="User"
      d list.Insert(item)
      // === cast obce
      s bigItem="castObce" s bigItemName="Část obce" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=1
      s val=$lg($g(arrDta("DTA")),2)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === lokalita
      s bigItem="lokalita" s bigItemName="Lokalita" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=1
      s val=$lg($g(arrDta("DTA")),3)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === blizka obec
      s bigItem="blizkaObec" s bigItemName="Blízká obec" s bigDataType=$$$BigItemDataTypeCodebook
      s bigRequired=(+$lg($g(arrDta("DTA")),26)=0) s bigAllowEdit=1 s bigValidation=1
      s val=$lg($g(arrDta("DTA")),4)  
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      s item.CodebookType=$$$CodebookTypeISYBlizkeObce
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === nazev MHD
      s bigItem="nazevMHD" s bigItemName="Název pro MHD" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),13)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      //
      s bigGroup="G3" s bigGroupName="Poloha"
      // === GPSN
      s bigItem="GPSN" s bigItemName="GPSN severní šířka" s bigDataType=$$$BigItemDataTypeDecimal
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=1
      // s val=$lg($g(arrDta("DTA")),19)
      if $lg($g(arrDta("DTA")),19)'="" { s val=+$lg($g(arrDta("DTA")),19) } else { s val="" }
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"### ##0.#############")
      s item.Selectable=1   
      s item.SelectableFormID = "User"
      d item.AddValue($g(val),"","")
      d item.AddValue($lg($g(arrDta("DTA")),20),"","")
      d list.Insert(item)
      // === GPSE
      s bigItem="GPSE" s bigItemName="GPSE východní délka" s bigDataType=$$$BigItemDataTypeDecimal
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=1
      // s val=$lg($g(arrDta("DTA")),20)
      if $lg($g(arrDta("DTA")),20)'="" { s val=+$lg($g(arrDta("DTA")),20) } else { s val="" }
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"### ##0.#############")
      s item.Selectable =1
      s item.SelectableFormID = "User"
      d item.AddValue($g(val),"","")
      d item.AddValue($lg($g(arrDta("DTA")),19),"","")
      d list.Insert(item)
      //
      s bigGroup="G4" s bigGroupName="Další"
      // === cislo CIS
      s bigItem="cisloCIS" s bigItemName="Číslo CIS" s bigDataType=$$$BigItemDataTypeInteger
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=1
      s val=$lg($g(arrDta("DTA")),14)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      i val {
	      k arrIsCRZ d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyCRZ).existuje(.sys,val,.arrIsCRZ)
	      i '$g(arrIsCRZ("STT")) {
		      s item.StatusId=$$$BigStateTypeWarning
		      s item.StatusMessage="neexistující zastávka v CIS"
	      }
	      else {
		      k arrDtaCRZ d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyCRZ).nacti(.sys,val,.arrDtaCRZ) s arrDtaCRZ("DTA")=$g(arrDtaCRZ("DTA"))
		      s item.StatusId=$$$BigStateTypeInformation
		      s item.StatusMessage="v CIS: "_$lg(arrDtaCRZ("DTA"),1)_","_$lg(arrDtaCRZ("DTA"),2)_","_$lg(arrDtaCRZ("DTA"),3)_"/"_$lg(arrDtaCRZ("DTA"),4)
	      }
      }
      d list.Insert(item)
      // === cislo SR70
      s bigItem="cisloSR70" s bigItemName="Číslo SR70" s bigDataType=$$$BigItemDataTypeDecimal
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),27)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"#,##0")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === cislo SR70Mezinarodni
      s bigItem="cisloSR70M" s bigItemName="Číslo SR70 mezinárodní" s bigDataType=$$$BigItemDataTypeDecimal
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),34)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"#,##0")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === cislo odbavovaciZarizeni
      s bigItem="odbZaCislo" s bigItemName="Číslo pro odbav.zař." s bigDataType=$$$BigItemDataTypeDecimal
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),12)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"#,##0")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === cislo uzlu ROPID
      s bigItem="cisloUzel" s bigItemName="Číslo uzlu (ROPID)" s bigDataType=$$$BigItemDataTypeInteger
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),40)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === provozovatel
      s bigItem="provozovatel" s bigItemName="Provozovatel" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),5)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === casove pasmo
      s bigItem="casovePasmo" s bigItemName="Časové pásmo" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),6)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === smer
      s bigItem="smerTyp" s bigItemName="Směr typ" s bigDataType=$$$BigItemDataTypeList
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),8)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
	  d item.AddListItem("jednosměrná",0)
      d item.AddListItem("obousměrná",1)
      d list.Insert(item)
      // === vyznamna
      s bigItem="vyznamna" s bigItemName="Významná" s bigDataType=$$$BigItemDataTypeBoolean
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),28)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === smart
      s bigItem="smart" s bigItemName="SMART" s bigDataType=$$$BigItemDataTypeBoolean
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),36)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      //
      s bigGroup="G5" s bigGroupName="Tarifní zóna"
      // === tarifni zona
      s bigItem="tarZona" s bigItemName="Tarifní zóna" s bigDataType=$$$BigItemDataTypeCodebook
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),15)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      s item.CodebookType=$$$CodebookTypeISYTarifniZony
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === hranicni ids
      s bigItem="hranicniIDS" s bigItemName="Hraniční IDS" s bigDataType=$$$BigItemDataTypeBoolean
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),16)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === tarifni zony dalsi
      s bigItem="tarZonaDalsi" s bigItemName="Tarifní zóna další" s bigDataType=$$$BigItemDataTypeCodebook
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      s item.CodebookType=$$$CodebookTypeISYTarifniZony
      s item.MultiSelect=1
      f cntVal=1:1:$ll($lg($g(arrDta("DTA")),17)) {
	      s val=$lg($lg($g(arrDta("DTA")),17),cntVal)
	      i val="" continue
	      d item.AddValue($g(val),"","")
      }
      d list.Insert(item)
      // === odbav.zar. tarifni zona
      s bigItem="odbZaTarZona" s bigItemName="Odbav.zař. tarifní zóna (ME)" s bigDataType=$$$BigItemDataTypeCodebook
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),30)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      s item.CodebookType=$$$CodebookTypeISYTarifniZony
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === odbav.zar. tarifni zony dalsi
      s bigItem="odbZaTarZonaDalsi" s bigItemName="Odbav.zař. tarifní zóna další (ME)" s bigDataType=$$$BigItemDataTypeCodebook
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      s item.CodebookType=$$$CodebookTypeISYTarifniZony
      s item.MultiSelect=1
      f cntVal=1:1:$ll($lg($g(arrDta("DTA")),31)) {
	      s val=$lg($lg($g(arrDta("DTA")),31),cntVal)
	      i val="" continue
	      d item.AddValue($g(val),"","")
      }
      d list.Insert(item)
   }
    catch (ex)
    {
       $$$CatchErrToInputErr
    }
   q ret
}

/// validate BIG
ClassMethod ValidateObec(ByRef err As %String, ByRef in As %String, ByRef list As %ListOfObjects) As %String
{
	$$$Init
	try
	{
		#dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
		#dim item2 As ALVA.EDFORMS.CONTROLS.BIG.Item
		$$$FillSysParamsBig(in)
		s actionId=$lg(in("Action"),2) s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
		s validationType=$lg($g(in("Param")),1)
		s validatedItem=$lg($g(in("Param")),2)
		s items=$g(in("Items"))
		//      
		s userParametr = $o(in("ParamEx","ID",""))
		//
		i (validationType=1) {
			s validateCisloCIS=0
         i actionMode=3 s validateCisloCIS = 1 // pri nove zastavce vzdy overujeme cisloCIS
			s key=""
			for {
				s item=items.GetNext(.key) i key="" q
				i (item.Id = validatedItem) {
					i item.Id="id" {
						d item.UpdateStatus($$$BigStateTypeOk,"")
						s id=item.FirstValue().Data
						i 'id {
							d item.UpdateStatus($$$BigStateTypeInformation,"bude automaticky doplněno při zápisu do databáze")
						}
						else {
							k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).existuje(.sys,id,.arrDta)
							i $g(arrDta("STT")) {
								k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,id,"",.arrDta) s arrDta("DTA")=$g(arrDta("DTA"))
								d item.UpdateStatus($$$BigStateTypeError,"již obsazeno - "_$lg(arrDta("DTA"),1)_","_$lg(arrDta("DTA"),2)_","_$lg(arrDta("DTA"),3)_"/"_$lg(arrDta("DTA"),4))
							}
						}
						d list.Insert(item)
					}
					elseif item.Id="vlakova" {
						s item2=items.GetItem("blizkaObec")
						d item2.UpdateStatus($$$BigStateTypeOk,"")
						s item2.Required=(+item.FirstValue().Data=0)
						i item2.Required {
							i item2.FirstValue().Data="" {
								d item2.UpdateStatus($$$BigStateTypeError,"Není zadána hodnota")
							}
						}
						d list.Insert(item2)
					}
					elseif item.Id="GPSN" {
						s GPSN=item.FirstValue().Data
						s GPSE="" i (item.Values.Count()=2) s GPSE=item.Values.GetAt(2).Data  
						d list.Insert(item)
						//naplním ještě položku druhé souřadnice         	   
						s key2=""
						for
						{
							s item2=items.GetNext(.key2) i key2="" q	
							i item2.Id="GPSE"
							{
								d item2.Values.Clear()
								d item2.AddValue(GPSE,"","")
								d item2.AddValue(GPSN,"","")
								d list.Insert(item2) 
								//zapis do db
								k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,"",$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),.arrDta)
								s valDta=$g(arrDta("DTA"))
								s $li(valDta,19)=GPSN
								s $li(valDta,20)=GPSE
								s arrDta("DTA")=valDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).uloz(.sys,"",$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),.arrDta)
								k arrDta
								q
							}	         	   
						}          	                   
					}
					elseif item.Id="GPSE" {	             
						s GPSE = $REPLACE(item.FirstValue().Data,".",",")
						s GPSN="" i (item.Values.Count()=2) s GPSN=item.Values.GetAt(2).Data

						d list.Insert(item)
						//naplním ještě položku druhé souřadnice         	   
						s key2=""
						for
						{
							s item2=items.GetNext(.key2) i key2="" q	
							i item2.Id="GPSN"
							{
								d item2.Values.Clear()
								d item2.AddValue(GPSN,"","")
								d item2.AddValue(GPSE,"","")
								d list.Insert(item2)
								//zapis do db
								k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,"",$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),.arrDta)
								s valDta=$g(arrDta("DTA"))
								s $li(valDta,19)=GPSN
								s $li(valDta,20)=GPSE
								s arrDta("DTA")=valDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).uloz(.sys,"",$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),.arrDta)
								k arrDta
								q
							}	         	   
						}
					}
					elseif item.Id="cisloCIS" {
						s validateCisloCIS=1
					}
					elseif item.Id="obec" {
						s cisloCIS="" i item.Values.Count()>0 s cisloCIS=item.Values.GetAt(1).Key
						//prislo cislo cis - aktualizace udaju
						i cisloCIS {   
							k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyCRZ).nacti(.sys,cisloCIS,.arrDta)
							s arrDta("DTA")=$g(arrDta("DTA"))
							s item2=items.GetItem("obec") d item2.Values.Clear() d item2.AddValue($lg(arrDta("DTA"),1),"","") d item2.UpdateStatus($$$BigStateTypeOk,"") d list.Insert(item2)
							s item2=items.GetItem("castObce") d item2.Values.Clear() d item2.AddValue($lg(arrDta("DTA"),2),"","") d list.Insert(item2)
							s item2=items.GetItem("lokalita") d item2.Values.Clear() d item2.AddValue($lg(arrDta("DTA"),3),"","") d list.Insert(item2)
							s item2=items.GetItem("blizkaObec") d item2.Values.Clear() d item2.AddValue($lg(arrDta("DTA"),4),"","") d item2.UpdateStatus($$$BigStateTypeOk,"") d list.Insert(item2)
							s item2=items.GetItem("cisloCIS") d item2.Values.Clear() d item2.AddValue(cisloCIS,"","") d list.Insert(item2)
							s item2=items.GetItem("id")
							i item2.FirstValue().Data="" {
								k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).existuje(.sys,cisloCIS,.arrDta)
								i '$g(arrDta("STT")) {
									d item2.Values.Clear()
									d item2.AddValue(cisloCIS,"","")
									d item2.UpdateStatus($$$BigStateTypeOk,"")
									d list.Insert(item2) 
								}
							}
							k arrDta    	   
						}
						s validateCisloCIS=1
					}
					elseif item.Id="castObce" {
						s validateCisloCIS=1
					}
					elseif item.Id="lokalita" {
						s validateCisloCIS=1
					}
					elseif item.Id="blizkaObec" {
						s validateCisloCIS=1
					}
				}
			}
			i validateCisloCIS {
				
				s item=items.GetItem("cisloCIS")
				
				s item2=items.GetItem("obec") s obec=item2.FirstValue().Data
				s item2=items.GetItem("castObce") s castObce=item2.FirstValue().Data
				s item2=items.GetItem("lokalita") s lokalita=item2.FirstValue().Data
				s item2=items.GetItem("blizkaObec") s blizkaObec=item2.FirstValue().Data
						
				d item.UpdateStatus($$$BigStateTypeOk,"")
				s cisId=item.FirstValue().Data
				i cisId {
					k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyCRZ).existuje(.sys,cisId,.arrDta)
		      		i '$g(arrDta("STT")) {
			    		d item.UpdateStatus($$$BigStateTypeWarning,"neexistující zastávka v CIS")
	      			}
                  elseif actionMode=3{
                     k arrDta 
                     d ##class(ALVA.ISY.ISYZastavky.API.zastavkyCRZFce).getIdZastavky(.sys,cisId,.arrDta)
                     i $d(arrDta("DTA"))  d item.UpdateStatus($$$BigStateTypeError,"zastávka s tímto CIS je již zavedená")
                  }
	      			else {
			    		k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyCRZ).nacti(.sys,cisId,.arrDta) s arrDta("DTA")=$g(arrDta("DTA"))
			    		s stateId=$$$BigStateTypeInformation
			    		i obec'=$lg(arrDta("DTA"),1) s stateId=$$$BigStateTypeWarning
			    		i castObce'=$lg(arrDta("DTA"),2) s stateId=$$$BigStateTypeWarning
			    		i lokalita'=$lg(arrDta("DTA"),3) s stateId=$$$BigStateTypeWarning
			    		i blizkaObec'=$lg(arrDta("DTA"),4) s stateId=$$$BigStateTypeWarning
			    		d item.UpdateStatus(stateId,"v CIS: "_$lg(arrDta("DTA"),1)_","_$lg(arrDta("DTA"),2)_","_$lg(arrDta("DTA"),3)_"/"_$lg(arrDta("DTA"),4))
	      			}
				}
				d list.Insert(item) 					
			}
		}         
	}
	catch (ex) { $$$CatchErrToInputErr }
	q ret
}

/// save BIG
ClassMethod SaveObec(ByRef err As %String, ByRef in As %String, ByRef out As %String) As %String
{
   $$$Init
    try
    {
      #dim items As %ListOfObjects
      #dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
      #dim value AS ALVA.EDFORMS.CONTROLS.BIG.ItemValue     
      $$$FillSysParamsBig(in)
      s action=$g(in("Action"))
      s items=$g(in("Items"))
      s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
      //nacteni dat z databaze
      k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,"",$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),.arrDta)
      s valDta=$g(arrDta("DTA"))
      //data na formulari
      s key="" f {
	      s item=items.GetNext(.key) i key="" q
         s mItem=item.Id
         i mItem="id" {s $$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"ID")=item.FirstValueData()}
         i mItem="typ" {s $li(valDta,39)=item.FirstValueData()}
         i mItem="vlakova" {s $li(valDta,26)=item.FirstValueData()}
         i mItem="obec" {s $li(valDta,1)=item.FirstValueData()}
         i mItem="castObce" {s $li(valDta,2)=item.FirstValueData()}
         i mItem="lokalita" {s $li(valDta,3)=item.FirstValueData()}
         i mItem="blizkaObec" {s $li(valDta,4)=item.FirstValueData()}
      	i mItem="nazevMHD" {s $li(valDta,13)=item.FirstValueData()}
         i mItem="GPSN" {s $li(valDta,19)=item.FirstValueData()}
         i mItem="GPSE" {s $li(valDta,20)=item.FirstValueData()}
         i mItem="cisloCIS" {s $li(valDta,14)=item.FirstValueData()}
         i mItem="cisloSR70" {s $li(valDta,27)=item.FirstValueData()}
         i mItem="cisloSR70M" {s $li(valDta,34)=item.FirstValueData()}
      	i mItem="odbZaCislo" {s $li(valDta,12)=item.FirstValueData()}
      	i mItem="provozovatel" {s $li(valDta,5)=item.FirstValueData()}
      	i mItem="casovePasmo" {s $li(valDta,6)=item.FirstValueData()}
      	i mItem="smerTyp" {s $li(valDta,8)=item.FirstValueData()}
      	i mItem="vyznamna" {s $li(valDta,28)=item.FirstValueData()}
         i mItem="smart" {s $li(valDta,36)=item.FirstValueData()}
      	i mItem="tarZona" {s $li(valDta,15)=item.FirstValueData()}
         i mItem="hranicniIDS" {s $li(valDta,16)=item.FirstValueData()}
      	i mItem="tarZonaDalsi" {
	      	  s lstVal=""
	      	  s valkey="" f {
		      	  s valitem=item.Values.GetNext(.valkey) i valkey="" q
				  s val=valitem.Data
				  i val'="" {
					i lstVal'="" s lstVal=lstVal_"~"
					s lstVal=lstVal_val	  
				  }		
			  }
			  s $li(valDta,17)=$lfs(lstVal,"~")  	  	  
	      }
      	  i mItem="odbZaTarZona" {s $li(valDta,30)=item.FirstValueData()}
      	  i mItem="odbZaTarZonaDalsi" {
	      	  s lstVal=""
	      	  s valkey="" f {
		      	  s valitem=item.Values.GetNext(.valkey) i valkey="" q
				  s val=valitem.Data
				  i val'="" {
					i lstVal'="" s lstVal=lstVal_"~"
					s lstVal=lstVal_val	  
				  }		
			  }
			  s $li(valDta,31)=$lfs(lstVal,"~")  	  	  
	      }
	      i mItem="cisloUzel" {s $li(valDta,40)=item.FirstValueData()}
      }
      k arrDta s arrDta("DTA")=valDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).uloz(.sys,"",$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),.arrDta)
   }
   catch (ex)
    {
       $$$CatchErrToInputErr
    }
   q ret
}

/// init BIG
ClassMethod InitAtrib(ByRef err As %String, ByRef in As %String, ByRef list As %ListOfObjects) As %String
{

   $$$Init
    try
    { //systemove promenne
	  $$$FillSysParamsBig(in)
	  s actionId=$lg(in("Action"),2) s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
	  //
      #dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
      #dim value As ALVA.EDFORMS.CONTROLS.BIG.ItemValue     
      //
      /*
      s userParametr = $o(in("ParamEx","ID",""))
      s listId = $lfs(userParametr,"|")
      s agd = $lg(listId,1)
      s idp = $lg(listId,2)
      s userParametr = $o(in("ParamEx","Edit",""))
      s listId = $lfs(userParametr,"|")
      s email = $lg(listId,4)
      */
	  //
	  //nacteni dat z databaze
      k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,"",$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),.arrDta)
      //
      s bigGroup="G1" s bigGroupName="Atributy zastávky"
      // === atributy
      k arrCis d ##class(ALVA.ISY.ISYCiselniky.API.AtributyZastavkySpoje).seznam(.sys,.arrCis)
      s valLst=$lg($g(arrDta("DTA")),7)
      s polozkaId="" f {
	      s polozkaVal="" s polozkaId=$o(arrCis("DTA",polozkaId),1,polozkaVal) i polozkaId="" q
	      s atributId=$lg(polozkaVal,3) i atributId="" continue
	      s atributNazev=$lg(polozkaVal,7)
	      s val=($lf(valLst,atributId)>0)
	      s bigItem=atributId s bigItemName=atributId_" / "_$replace(atributNazev,"|"," ") s bigDataType=$$$BigItemDataTypeBoolean
      	  s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      	  s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      	  d item.AddValue($g(val),"","")
      	  d list.Insert(item)
      }
   }
    catch (ex)
    {
       $$$CatchErrToInputErr
    }
   q ret
}

/// validate BIG
ClassMethod ValidateAtrib(ByRef err As %String, ByRef in As %String, ByRef list As %ListOfObjects) As %String
{
   $$$Init
    try
    {
       #dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
       $$$FillSysParamsBig(in)
	   s actionId=$lg(in("Action"),2) s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
       s validationType=$lg($g(in("Param")),1)
       s validatedItem=$lg($g(in("Param")),2)
       s items=$g(in("Items"))
       //
       /*
       s userParametr = $o(in("ParamEx","ID",""))
       s listId = $lfs(userParametr,"|")
       s agd = $lg(listId,1)
       s idp = $lg(listId,2)
       s userParametr = $o(in("ParamEx","Edit",""))
       s listId = $lfs(userParametr,"|")
       s Lastemail = $lg(listId,4)   
       */
       i (validationType=1) {
         s key=""
         f
         {
            s item=items.GetNext(.key) i key="" q
            i (item.Id = validatedItem)
            {
               s stt=$$$BigStateTypeOk s info=""
               //obslouzeni
               d item.UpdateStatus(stt,info)             
               d list.Insert(item)        
            }
         }
      }    
   }
    catch (ex) { $$$CatchErrToInputErr }
   q ret
}

/// save BIG
ClassMethod SaveAtrib(ByRef err As %String, ByRef in As %String, ByRef out As %String) As %String
{
   $$$Init
    try
    {
      $$$FillSysParamsBig(in)
      s action=$g(in("Action"))
      s items=$g(in("Items"))
      s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
      //data na formulari
      s lstVal=""
      s key="" f {
	      s item=items.GetNext(.key) i key="" q
          s mItem=item.Id s val=item.FirstValueData()
          i val {
	          s $li(lstVal,$ll(lstVal)+1)=mItem
          }
      }
      //nacteni dat z databaze
      k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,"",$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),.arrDta)
      s valDta=$g(arrDta("DTA")) s $li(valDta,7)=lstVal s arrDta("DTA")=valDta
      //ulozeni dat do databaze
      d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).uloz(.sys,"",$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),.arrDta)
      k arrDta
   }
   catch (ex)
    {
       $$$CatchErrToInputErr
    }
   q ret
}

/// init BIG
ClassMethod InitOdbav(ByRef err As %String, ByRef in As %String, ByRef list As %ListOfObjects) As %String
{
   $$$Init
    try
    {
      //systemove promenne
	  $$$FillSysParamsBig(in)
	  s actionId=$lg(in("Action"),2) s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
	  //
	  #dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
      #dim value As ALVA.EDFORMS.CONTROLS.BIG.ItemValue     
      /*
      s userParametr = $o(in("ParamEx","ID",""))
      s listId = $lfs(userParametr,"|")
      s agd = $lg(listId,1)
      s idp = $lg(listId,2)
      s userParametr = $o(in("ParamEx","Edit",""))
      s listId = $lfs(userParametr,"|")
      s email = $lg(listId,4)
      */
	  //nacteni dat z databaze
      k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,"",$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),.arrDta)
	  //
	  s bigGroup="G1" s bigGroupName="Název"
      // === nazev kratky
      s bigItem="odbZaNazKratky" s bigItemName="Odbav.zař. název krátký" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),9)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === nazev dlouhy
      s bigItem="odbZaNazDlouhy" s bigItemName="Odbav.zař. název dlouhý" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),10)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === nazev tisk a display
      s bigItem="odbZaNazTiskDisplay" s bigItemName="Odbav.zař. název tisk a display" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),25)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
	  // === nazev lcd
      s bigItem="odbZaNazLCD" s bigItemName="Odbav.zař. název LCD" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),24)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
	  // === nazev predni tablo
      s bigItem="odbZaNazPredniTablo" s bigItemName="Odbav.zař. název přední tablo" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),18)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === nazev bocni tablo
      s bigItem="odbZaNazBocniTablo" s bigItemName="Odbav.zař. název boční tablo" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),11)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === nazev vnitrni tablo
      s bigItem="odbZaNazVnitrniTablo" s bigItemName="Odbav.zař. název vnitřní tablo" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),29)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
	  // === nazev MHD lcd
      s bigItem="odbZaNazMHDLCD" s bigItemName="Odbav.zař. název  MHD, LCD" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),38)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
	  // === nazev MHD predni tablo
      s bigItem="odbZaNazMHDPredniTablo" s bigItemName="Odbav.zař. název  MHD, přední tablo" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),35)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === nazev MHD bocni tablo
      s bigItem="odbZaNazMHDBocniTablo" s bigItemName="Odbav.zař. název MHD, boční tablo" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),32)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === nazev MHD vnitrni tablo
      s bigItem="odbZaNazMHDVnitrniTablo" s bigItemName="Odbav.zař. název MHD, vnitřní tablo" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),33)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      //
	  s bigGroup="G2" s bigGroupName="Další"
	  // === skupina pro slevu
      s bigItem="odbZaSkuSleva" s bigItemName="Odbav.zař. skupina pro slevu" s bigDataType=$$$BigItemDataTypeCodebook
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),22)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      s item.CodebookType=$$$CodebookTypeISYSkupinyZastavekProSlevu
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      //=== parametr pro hlasic
      s bigItem="odbZaHlasic" s bigItemName="Parametr pro hlásič" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),21)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === radius
      s bigItem="odbZaRadius" s bigItemName="Rádius" s bigDataType=$$$BigItemDataTypeInteger
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg($g(arrDta("DTA")),23)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      //
   }
    catch (ex)
    {
       $$$CatchErrToInputErr
    }
   q ret
}

/// validate BIG
ClassMethod ValidateOdbav(ByRef err As %String, ByRef in As %String, ByRef list As %ListOfObjects) As %String
{

   $$$Init
    try
    {
      #dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
      //
      s IdFa=$g(in("IdFa"))
      s user=$g(in("User"))
      s action=$g(in("Action"))
      s actionMode=$lg(in("Action"),2)
      s validationType=$lg($g(in("Param")),1)
      s validatedItem=$lg($g(in("Param")),2)
      s items=$g(in("Items"))
      // 
      /*     
      s userID =$lg(user,1)
      s userParametr = $o(in("ParamEx","ID",""))
      s listId = $lfs(userParametr,"|")
      s agd = $lg(listId,1)
      s idp = $lg(listId,2)
      s userParametr = $o(in("ParamEx","Edit",""))
      s listId = $lfs(userParametr,"|")
      s Lastemail = $lg(listId,4)   
      */
      if (validationType=1)
      {
         s key=""
         for
         {
            s item=items.GetNext(.key) q:key=""
            if (item.Id = validatedItem)
            {
               s evId = item.FirstValue().Data  
               s stt=$$$BigStateTypeOk
               s info=""
            
               d item.UpdateStatus(stt,info)             
               d list.Insert(item)        
            }
         }
      }     
   }
    catch (ex) { $$$CatchErrToInputErr }
   q ret
}

/// save BIG
ClassMethod SaveOdbav(ByRef err As %String, ByRef in As %String, ByRef out As %String) As %String
{
   $$$Init
    try
    {
      #dim items As %ListOfObjects
      #dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
      #dim value AS ALVA.EDFORMS.CONTROLS.BIG.ItemValue     
      $$$FillSysParamsBig(in)
      s action=$g(in("Action"))
      s items=$g(in("Items"))
      s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
      //nactu data z databaze
      k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,"",$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),.arrDta)
      s valDta=$g(arrDta("DTA"))
      //data na formulari
      s key="" f {
	      s item=items.GetNext(.key) i key="" q
          s mItem=item.Id
          i mItem="odbZaNazKratky" {s $li(valDta,9)=item.FirstValueData()}
          i mItem="odbZaNazDlouhy" {s $li(valDta,10)=item.FirstValueData()}
          i mItem="odbZaNazLCD" {s $li(valDta,24)=item.FirstValueData()}
          i mItem="odbZaNazTiskDisplay" {s $li(valDta,25)=item.FirstValueData()}
          i mItem="odbZaNazPredniTablo" {s $li(valDta,18)=item.FirstValueData()}
      	  i mItem="odbZaNazBocniTablo" {s $li(valDta,11)=item.FirstValueData()}
		  i mItem="odbZaNazVnitrniTablo" {s $li(valDta,29)=item.FirstValueData()}
		  i mItem="odbZaNazMHDLCD" {s $li(valDta,38)=item.FirstValueData()}
		  i mItem="odbZaNazMHDPredniTablo" {s $li(valDta,35)=item.FirstValueData()}
		  i mItem="odbZaNazMHDBocniTablo" {s $li(valDta,32)=item.FirstValueData()}
		  i mItem="odbZaNazMHDVnitrniTablo" {s $li(valDta,33)=item.FirstValueData()}
		  i mItem="odbZaSkuSleva" {s $li(valDta,22)=item.FirstValueData()}
		  i mItem="odbZaHlasic" {s $li(valDta,21)=item.FirstValueData()}
		  i mItem="odbZaRadius" {s $li(valDta,23)=item.FirstValueData()}
      }
 	  s arrDta("DTA")=valDta
      //ulozeni dat do databaze 
      d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).uloz(.sys,"",$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),.arrDta)
      k arrDta
   }
   catch (ex)
    {
       $$$CatchErrToInputErr
    }
   q ret
}

/// init BIG
ClassMethod InitHistorie(ByRef err As %String, ByRef in As %String, ByRef list As %ListOfObjects) As %String
{
   $$$Init
    try
    {
	  //systemove promenne
	  $$$FillSysParamsBig(in)
	  s actionId=$lg(in("Action"),2) s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
	  //
	  #dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
      #dim value As ALVA.EDFORMS.CONTROLS.BIG.ItemValue     
  	  //vstupni parametry
  	  s udajId=1 s horolog=""
      s IDEditPol=$o(in("ParamEx","IDEditPol",""))
      i IDEditPol'="" {
	      s udajId=$p(IDEditPol,"|",1) s horolog=$p(IDEditPol,"|",2)
      }
      s bigGroupUdajId="U|"_udajId
 	  //datovy global
      s dGlb=$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA"))
      //ciselniky
      k arrCisCasoveVariantyUdajuZastavek d ##class(ALVA.ISY.ISYCiselniky.API.CasoveVariantyUdajuZastavek).seznam(.sys,.arrCisCasoveVariantyUdajuZastavek)
      //data polozky
      k arrDta
      i (udajId&horolog) {k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyCasoveVariatyUdaju).nacti(.sys,$lb("",udajId,horolog),dGlb,.arrDta)}
      s arrDta("DTA")=$g(arrDta("DTA"))
      s bigGroup="G1" s bigGroupName="Časové varianty údajů zastávek"
      // seznam polozek k hromadne uprave zastavek
      s bigItem="udajId" s bigItemName="Údaj" s bigDataType=$$$BigItemDataTypeList
      s bigRequired=1 s bigAllowEdit=1 s bigValidation=1
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"") 
	  //editovatelne udaje =====
	  s udajId="" f {
		s val="" s udajId=$o(arrCisCasoveVariantyUdajuZastavek("DTA",udajId),1,val) i udajId="" q
		s nazev=$lg(val,1)
		d item.AddListItem(nazev,"U|"_udajId)
	  }
	  
	  d item.AddValue(bigGroupUdajId,"","")
	  d list.Insert(item)
	  //
	  s bigItem="datumOd" s bigItemName = "Platí od" s bigDataType = $$$BigItemDataTypeDate
      s bigRequired=1 s bigAllowEdit=1 s bigValidation=1
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      s val="" i horolog s val=##class(ALVA.GENERALAPI.Date).horToDate(horolog)
      d item.AddValue(val,"","")
      d list.Insert(item)
	  //==================================
	  //nazev zastavky  
	  s bigGroup="U|"_1 s bigGroupName="Název zastávky"
	  // === vybrat z registru
	  s bigItem="idCRZ" s bigItemName="Vyberte název z celostátního registru" s bigDataType=$$$BigItemDataTypeCodebook
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=1
      s val="" 
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      s item.CodebookType=$$$CodebookTypeCelostatRegistrZastavek
      d item.AddValue(val,"","")
      d list.Insert(item)
	  // === obec
      s bigItem="obec" s bigItemName="Obec" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=1 s bigAllowEdit=1 s bigValidation=1
      s val="" i (bigGroup=bigGroupUdajId) s val=$lg(arrDta("DTA"),1)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      //s item.Selectable =1
      //s item.SelectableFormID="User"
      s item.Hidden=(bigGroup'=bigGroupUdajId)
      d list.Insert(item)
      // === cast obce
      s bigItem="castObce" s bigItemName="Část obce" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val="" i (bigGroup=bigGroupUdajId) s val=$lg(arrDta("DTA"),2)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      s item.Hidden=(bigGroup'=bigGroupUdajId)
      d list.Insert(item)
      // === lokalita
      s bigItem="lokalita" s bigItemName="Lokalita" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val="" i (bigGroup=bigGroupUdajId) s val=$lg(arrDta("DTA"),3)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      s item.Hidden=(bigGroup'=bigGroupUdajId)
      d list.Insert(item)
      // === blizka obec
      s bigItem="blizkaObec" s bigItemName="Blízká obec" s bigDataType=$$$BigItemDataTypeCodebook
      s bigRequired=1 s bigAllowEdit=1 s bigValidation=0
      s val="" i (bigGroup=bigGroupUdajId) s val=$lg(arrDta("DTA"),4)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      s item.CodebookType=$$$CodebookTypeISYBlizkeObce
      d item.AddValue($g(val),"","")
      s item.Hidden=(bigGroup'=bigGroupUdajId)
      d list.Insert(item)
      // === nazev MHD
      s bigItem="nazevMHD" s bigItemName="Název pro MHD" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val="" i (bigGroup=bigGroupUdajId) s val=$lg($g(arrDta("DTA")),5)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      s item.Hidden=(bigGroup'=bigGroupUdajId)
      d list.Insert(item)
   }
    catch (ex)
    {
       $$$CatchErrToInputErr
    }
   q ret
}

/// validate BIG
ClassMethod ValidateHistorie(ByRef err As %String, ByRef in As %String, ByRef list As %ListOfObjects) As %String
{
   $$$Init
    try
    {
      #dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
      #dim item2 As ALVA.EDFORMS.CONTROLS.BIG.Item
      #dim referenceItem As ALVA.EDFORMS.CONTROLS.BIG.Item
      $$$FillSysParamsBig(in)
	  s actionId=$lg(in("Action"),2) s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
      s validationType=$lg($g(in("Param")),1)
      s validatedItem=$lg($g(in("Param")),2)
      s items=$g(in("Items"))
      //      
      if (validationType=1)
      {
         s key=""
         for
         {
            s item=items.GetNext(.key) q:key=""
            i (item.Id = validatedItem)
            {
	           s stt=$$$BigStateTypeOk s info=""
               i item.Id="udajId" {
	               s udajId=item.FirstValue().Data   
	               f {
		               s item2=items.GetNext(.key2) i key2="" q
		         	   i item2.Id="udajId" continue      	   
		         	   i item2.Id="datumOd" continue
			           s item2.Hidden=(item2.GroupId'=udajId)
			           d list.Insert(item2)  	
		       		}          	                 
               }
               i item.Id="idCRZ" {
	               //aktualizace dat v bigu
	               s zastavkaId=+item.FirstValue().Data
	               i zastavkaId {
		               k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyCRZ).nacti(.sys,zastavkaId,.arrDta) s arrDta("DTA")=$g(arrDta("DTA"))
		               s obec=$lg(arrDta("DTA"),1)
		               s castObce=$lg(arrDta("DTA"),2)
		               s lokalita=$lg(arrDta("DTA"),3)
		               s blizkaObec=$lg(arrDta("DTA"),4)
		               d item.Values.Clear()
		               s referenceItem=items.GetItem("obec") d referenceItem.Values.Clear() d referenceItem.AddValue(obec,"","") d referenceItem.UpdateStatus($$$BigStateTypeOk,"") d list.Insert(referenceItem)
		               s referenceItem=items.GetItem("castObce") d referenceItem.Values.Clear() d referenceItem.AddValue(castObce,"","") d referenceItem.UpdateStatus($$$BigStateTypeOk,"") d list.Insert(referenceItem)
		               s referenceItem=items.GetItem("lokalita") d referenceItem.Values.Clear() d referenceItem.AddValue(lokalita,"","") d referenceItem.UpdateStatus($$$BigStateTypeOk,"") d list.Insert(referenceItem)
		               s referenceItem=items.GetItem("blizkaObec") d referenceItem.Values.Clear() d referenceItem.AddValue(blizkaObec,"","") d referenceItem.UpdateStatus($$$BigStateTypeOk,"") d list.Insert(referenceItem)
	               }
               }
               d item.UpdateStatus(stt,info)             
               d list.Insert(item)        
            }
         }
      }     
   }
   catch (ex) { $$$CatchErrToInputErr }
   q ret
}

/// save BIG
ClassMethod SaveHistorie(ByRef err As %String, ByRef in As %String, ByRef out As %String) As %String
{
   $$$Init
    try
    {
	  $$$FillSysParamsBig(in) 
      #dim items As %ListOfObjects
      #dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
      #dim value AS ALVA.EDFORMS.CONTROLS.BIG.ItemValue
      s action=$g(in("Action"))
      s items=$g(in("Items"))
      s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
      //
      s dGlb=$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA"))
      //
      s key="" k arrVal
      f {
	      s item=items.GetNext(.key) q:key=""
          s ItemId=item.Id
          s val=item.FirstValueData()
          s arrVal(ItemId)=val
      }
      s udajId=$p($g(arrVal("udajId")),"|",2) s hrl=##class(ALVA.GENERALAPI.Date).DateToHor($g(arrVal("datumOd")))
      i udajId=1 {
	      s val=""
	      s $li(val,1)=$g(arrVal("obec"))
	      s $li(val,2)=$g(arrVal("castObce"))
	      s $li(val,3)=$g(arrVal("lokalita"))
	      s $li(val,4)=$g(arrVal("blizkaObec"))
	      s $li(val,5)=$g(arrVal("nazevMHD"))
      }
	  //zapis udaju do zastavky
	  k arrDta s arrDta("DTA")=val d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyCasoveVariatyUdaju).uloz(.sys,$lb("",udajId,hrl),dGlb,.arrDta)
	  //pokud je zapis do budoucna, udelam aktualizaci udaju zastavky, pak se zavola activate
	  i (hrl'<(+$h)) {
		   k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,"",$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),.arrDta)
      	   s valDta=$g(arrDta("DTA"))
      	   s $li(valDta,1)=$g(arrVal("obec"))
      	   s $li(valDta,2)=$g(arrVal("castObce"))
      	   s $li(valDta,3)=$g(arrVal("lokalita"))
      	   s $li(valDta,4)=$g(arrVal("blizkaObec"))
      	   s $li(valDta,13)=$g(arrVal("nazevMHD"))
      	   s arrDta("DTA")=valDta
      	   d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).uloz(.sys,"",$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),.arrDta)
	  }
  }
   catch (ex){$$$CatchErrToInputErr}
   q ret
}

}
