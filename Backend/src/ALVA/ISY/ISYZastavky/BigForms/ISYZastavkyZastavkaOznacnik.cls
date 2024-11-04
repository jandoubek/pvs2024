Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyZastavkaOznacnik Extends %RegisteredObject
{

/// init BIG
ClassMethod Init(ByRef err As %String, ByRef in As %String, ByRef list As %ListOfObjects) As %String
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
  	  //
  	  s oznacnikId=$o(in("ParamEx","IDEditPol",""))
  	  /*
      s userParametr = $o(in("ParamEx","ID",""))
      s listId = $lfs(userParametr,"|")
      s agd = $lg(listId,1)
      s idp = $lg(listId,2)
      s userParametr = $o(in("ParamEx","Edit",""))
      s listId = $lfs(userParametr,"|")
      s email = $lg(listId,4)
      */
	  //nactu data
	  s valDta="" k arrDta

      k arrDtaZastavka d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,"",$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),.arrDtaZastavka)
		s zastGPSN=$lg($g(arrDtaZastavka("DTA")),19)
		s zastGPSE=$lg($g(arrDtaZastavka("DTA")),20)

	  i oznacnikId {
		  d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyOznacniky).nacti(.sys,$lb("",oznacnikId),$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),.arrDta)
		  s valDta=$g(arrDta("DTA"))
	  }
	  //nova, prednastavim GPS od zastavky
	  else {
		  s $li(valDta,2)=zastGPSN
		  s $li(valDta,3)=zastGPSE
	  }
	  //
      s bigGroup="G1" s bigGroupName="Obecné"
      // === cislo/id oznacniku
      s bigItem="id" s bigItemName = "Id/Číslo označníku" s bigDataType = $$$BigItemDataTypeInteger
      s bigRequired=1 s bigAllowEdit=1 s bigValidation=1 i actionMode=4 s bigAllowEdit=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue(oznacnikId,"","")
      s item.MinValue = 1
      d list.Insert(item)
      // === popis
      s bigItem="popis" s bigItemName="Popis" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,4)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === nastupiste
      s bigItem="nastupiste" s bigItemName="Nástupiště" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,1)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      //
      s bigGroup="G2" s bigGroupName="Poloha"
      /*
      // === GPSN
      s bigItem="GPSN" s bigItemName="GPSN severní šířka" s bigDataType=$$$BigItemDataTypeDecimal
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,2)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === GPSE
      s bigItem="GPSE" s bigItemName="GPSE východní délka" s bigDataType=$$$BigItemDataTypeDecimal
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,3)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      */
      // === GPSN
      s bigItem="GPSN" s bigItemName="GPSN severní šířka" s bigDataType=$$$BigItemDataTypeDecimal
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=1
      s val=$lg(valDta,2) i val'="" s val=+val
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"### ##0.#############")
      s item.Selectable =1      
      s item.SelectableFormID = "User"
      d item.AddValue($g(val),"","")
      d item.AddValue($lg(valDta,3),"","")
      d item.AddValue(zastGPSN,"","")
      d item.AddValue(zastGPSE,"","")
      d list.Insert(item)
      // === GPSE
      s bigItem="GPSE" s bigItemName="GPSE východní délka" s bigDataType=$$$BigItemDataTypeDecimal
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=1
      s val=$lg(valDta,3) i val'="" s val=+val
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"### ##0.#############")
      s item.Selectable =1
      s item.SelectableFormID = "User"
      d item.AddValue($g(val),"","")
      d item.AddValue($lg(valDta,2),"","")
      d item.AddValue(zastGPSN,"","")
      d item.AddValue(zastGPSE,"","")
      d list.Insert(item)
      //
      s bigGroup="G3" s bigGroupName="Další"
      // === provozovatel
      s bigItem="provozovatel" s bigItemName="Provozovatel" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,5)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === smart
      s bigItem="smart" s bigItemName="SMART" s bigDataType=$$$BigItemDataTypeBoolean
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,7)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      //
      s bigGroup="G4" s bigGroupName="Odbavovací zařízení - název"
      // === nazev tisk a display
      s bigItem="odbZaNazTiskDisplay" s bigItemName="Odbav.zař. název tisk a display" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,14)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
	  // === nazev lcd
      s bigItem="odbZaNazLCD" s bigItemName="Odbav.zař. název LCD" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,15)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
	  // === nazev predni tablo
      s bigItem="odbZaNazPredniTablo" s bigItemName="Odbav.zař. název přední tablo" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,16)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === nazev bocni tablo
      s bigItem="odbZaNazBocniTablo" s bigItemName="Odbav.zař. název boční tablo" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,17)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === nazev vnitrni tablo
      s bigItem="odbZaNazVnitrniTablo" s bigItemName="Odbav.zař. název vnitřní tablo" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,18)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
	  // === nazev MHD lcd
      s bigItem="odbZaNazMHDLCD" s bigItemName="Odbav.zař. název  MHD, LCD" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,19)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
	  // === nazev MHD predni tablo
      s bigItem="odbZaNazMHDPredniTablo" s bigItemName="Odbav.zař. název  MHD, přední tablo" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,20)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === nazev MHD bocni tablo
      s bigItem="odbZaNazMHDBocniTablo" s bigItemName="Odbav.zař. název MHD, boční tablo" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,21)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === nazev MHD vnitrni tablo
      s bigItem="odbZaNazMHDVnitrniTablo" s bigItemName="Odbav.zař. název MHD, vnitřní tablo" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,22)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      //
      s bigGroup="G5" s bigGroupName="Odbavovací zařízení - další"
      //=== parametr pro hlasic
      s bigItem="odbZaHlasic" s bigItemName="Parametr pro hlásič" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,23)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === radius
      s bigItem="odbZaRadius" s bigItemName="Rádius" s bigDataType=$$$BigItemDataTypeInteger
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,6)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      //
      s bigGroup="G6" s bigGroupName="Odbavovací zařízení - Telmax"
      //=== 
      s bigItem="odbZaTLMXNeGpsGTEL" s bigItemName="Neukládat souřadnice do GTEL" s bigDataType=$$$BigItemDataTypeBoolean
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,24)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      //
      s bigGroup="G7" s bigGroupName="Odbavovací zařízení - Mikroelektronika"
      // === radius priblizeni
      s bigItem="odbZaRadiusPriblizeni" s bigItemName="Rádius přiblížení (ME)" s bigDataType=$$$BigItemDataTypeInteger
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,8)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === radius prijezd
      s bigItem="odbZaRadiusPrijezd" s bigItemName="Rádius příjezd (ME)" s bigDataType=$$$BigItemDataTypeInteger
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,9)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === radius odjezd
      s bigItem="odbZaRadiusOdjezd" s bigItemName="Rádius odjezd (ME)" s bigDataType=$$$BigItemDataTypeInteger
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,10)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === radius opusteni
      s bigItem="odbZaRadiusOpusteni" s bigItemName="Rádius opuštění (ME)" s bigDataType=$$$BigItemDataTypeInteger
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,11)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === nazev display
      s bigItem="odbZaBodNazDisplay" s bigItemName="Název bodu pro display (ME,nd)" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,12)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === nazev tisk
      s bigItem="odbZaBodNazTisk" s bigItemName="Název bodu pro tisk (ME,np)" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,13)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
      // === nazev sloupku pro display
      s bigItem="odbZaSlpNazDisplay" s bigItemName="Název sloupku pro displej (ME,snd)" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s val=$lg(valDta,25)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(val),"","")
      d list.Insert(item)
   }
    catch (ex)
    {
       $$$CatchErrToInputErr
    }
   q ret
}

/// validate BIG
ClassMethod Validate(ByRef err As %String, ByRef in As %String, ByRef list As %ListOfObjects) As %String
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
      k arrDtaZastavka d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,"",$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),.arrDtaZastavka)
		s zastGPSN=$lg($g(arrDtaZastavka("DTA")),19)
		s zastGPSE=$lg($g(arrDtaZastavka("DTA")),20)
      if (validationType=1)
      {
         s key=""
         for
         {
            s item=items.GetNext(.key) q:key=""
            if (item.Id = validatedItem)
            {
              s stt=$$$BigStateTypeOk s info=""
              i item.Id="id" {
	              s id=item.FirstValue().Data
	              k arr d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyOznacniky).existuje(.sys,$lb("",id),$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),.arr)
	              i +$g(arr("STT")) {
		              s stt=$$$BigStateTypeError
              	   	  s info="označník s id/číslem "_id_" již existuje"
	              }
              }
              i item.Id="GPSN" {
                  s GPSN = item.FirstValue().Data
                  //naplním ještě položku druhé souřadnice   
                  k arrDtaZastavka d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,"",$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),.arrDtaZastavka)
		            s zastGPSN=$lg($g(arrDtaZastavka("DTA")),19)
		            s zastGPSE=$lg($g(arrDtaZastavka("DTA")),20)

                  s referenceItem=items.GetItem("GPSE")
                  s GPSE = ""
                  if (item.Values.Count() >= 2) s GPSE = item.Values.GetAt(2).Data 	
                  i GPSE = "" s GPSE = referenceItem.Values.GetAt(1).Data 	
                  d referenceItem.Values.Clear()
                  d referenceItem.AddValue(GPSE,"","")
                  d referenceItem.AddValue(GPSN,"","")
                  d referenceItem.AddValue(zastGPSN,"","")
                  d referenceItem.AddValue(zastGPSE,"","")
                  d list.Insert(referenceItem)  


                  d item.Values.Clear()
                  d item.AddValue(GPSN,"","")
                  d item.AddValue(GPSE,"","")
                  d item.AddValue(zastGPSN,"","")
                  d item.AddValue(zastGPSE,"","")
               }
 			   elseif item.Id="GPSE" 
               {	             
	               s GPSE = item.FirstValue().Data
	         	   //naplním ještě položku druhé souřadnice   

                  k arrDtaZastavka d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,"",$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),.arrDtaZastavka)
		            s zastGPSN=$lg($g(arrDtaZastavka("DTA")),19)
		            s zastGPSE=$lg($g(arrDtaZastavka("DTA")),20)      	   

                  s referenceItem=items.GetItem("GPSN")
                  s GPSN = ""
                  if (item.Values.Count() >= 2) s GPSN = item.Values.GetAt(2).Data 	
                  i GPSN = "" s GPSN = referenceItem.Values.GetAt(1).Data 
                  d referenceItem.Values.Clear()
                  d referenceItem.AddValue(GPSN,"","")
                  d referenceItem.AddValue(GPSE,"","")
                  d referenceItem.AddValue(zastGPSN,"","")
                  d referenceItem.AddValue(zastGPSE,"","")
                  d list.Insert(referenceItem)

                  d item.Values.Clear()
                  d item.AddValue(GPSE,"","")
                  d item.AddValue(GPSN,"","")
                  d item.AddValue(zastGPSN,"","")
                  d item.AddValue(zastGPSE,"","")
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
ClassMethod Save(ByRef err As %String, ByRef in As %String, ByRef out As %String) As %String
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
      //
      s oznacnikId="" s valDta=""
      //data na formulari
      s key="" f {
         s item=items.GetNext(.key) i key="" q
         s mItem=item.Id
         i mItem="id" {s oznacnikId=item.FirstValueData()}
         i mItem="nastupiste" {s $li(valDta,1)=item.FirstValueData()}
         i mItem="GPSN" {s $li(valDta,2)=item.FirstValueData()}
         i mItem="GPSE" {s $li(valDta,3)=item.FirstValueData()}
         i mItem="popis" {s $li(valDta,4)=item.FirstValueData()}
         i mItem="provozovatel" {s $li(valDta,5)=item.FirstValueData()}
         i mItem="odbZaRadius" {s $li(valDta,6)=item.FirstValueData()}
         i mItem="smart" {s $li(valDta,7)=item.FirstValueData()}
         i mItem="odbZaRadiusPriblizeni" {s $li(valDta,8)=item.FirstValueData()}
         i mItem="odbZaRadiusPrijezd" {s $li(valDta,9)=item.FirstValueData()}
         i mItem="odbZaRadiusOdjezd" {s $li(valDta,10)=item.FirstValueData()}
         i mItem="odbZaRadiusOpusteni" {s $li(valDta,11)=item.FirstValueData()}
         i mItem="odbZaBodNazDisplay" {s $li(valDta,12)=item.FirstValueData()}
         i mItem="odbZaBodNazTisk" {s $li(valDta,13)=item.FirstValueData()}
         i mItem="odbZaNazTiskDisplay" {s $li(valDta,14)=item.FirstValueData()}
         i mItem="odbZaNazLCD" {s $li(valDta,15)=item.FirstValueData()}
         i mItem="odbZaNazPredniTablo" {s $li(valDta,16)=item.FirstValueData()}
         i mItem="odbZaNazBocniTablo" {s $li(valDta,17)=item.FirstValueData()}
         i mItem="odbZaNazVnitrniTablo" {s $li(valDta,18)=item.FirstValueData()}
         i mItem="odbZaNazMHDLCD" {s $li(valDta,19)=item.FirstValueData()}
         i mItem="odbZaNazMHDPredniTablo" {s $li(valDta,20)=item.FirstValueData()}
         i mItem="odbZaNazMHDBocniTablo" {s $li(valDta,21)=item.FirstValueData()}
         i mItem="odbZaNazMHDVnitrniTablo" {s $li(valDta,22)=item.FirstValueData()}
         i mItem="odbZaHlasic" {s $li(valDta,23)=item.FirstValueData()}
         i mItem="odbZaTLMXNeGpsGTEL" {s $li(valDta,24)=item.FirstValueData()}
         i mItem="odbZaSlpNazDisplay" {s $li(valDta,25)=item.FirstValueData()}
      }
      //ulozeni dat do databaze
 	  k arrDta s arrDta("DTA")=valDta
      d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyOznacniky).uloz(.sys,$lb("",oznacnikId),$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkaEdit,"DTA")),.arrDta)
      k arrDta
   }
   catch (ex)
    {
       $$$CatchErrToInputErr
    }
   q ret
}

}
