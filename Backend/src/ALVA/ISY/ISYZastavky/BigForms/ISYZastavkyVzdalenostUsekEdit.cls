Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY, ALVAEDREPORTS)

Class ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyVzdalenostUsekEdit Extends %RegisteredObject
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
	  //nactu data
	  s usekId=$g($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","ID"))
	  s valDta=$g($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA"))
	  s zastavkaOdId=$lg(valDta,1)
	  s oznacnikOdId=$lg(valDta,2)
	  s zastavkaDoId=$lg(valDta,3)
	  s oznacnikDoId=$lg(valDta,4)
     s vzdalenostPodleMapy=$lg(valDta,5)
     s trvaniPodleMapy = $lg(valDta,6)
	  s zastavkaOdNazev="" i zastavkaOdId {
		  k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaOdId,"",.arrDta)
		  s valDta=$g(arrDta("DTA"))
		  s zastavkaOdNazev=$lg(valDta,1)_","_$lg(valDta,2)_","_$lg(valDta,3)_"/"_$lg(valDta,4)
	  }
	  s zastavkaDoNazev="" i zastavkaDoId {
		  k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaDoId,"",.arrDta)
		  s valDta=$g(arrDta("DTA"))
		  s zastavkaDoNazev=$lg(valDta,1)_","_$lg(valDta,2)_","_$lg(valDta,3)_"/"_$lg(valDta,4)
	  }
	  //
      s bigGroup="G1" s bigGroupName="Obecné"
      // === id jen zobrazim
      s bigItem="id" s bigItemName = "Id" s bigDataType = $$$BigItemDataTypeInteger
      s bigRequired=0 s bigAllowEdit=0 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue(usekId,"","")
      d list.Insert(item)
      // === zastavka od
      s bigItem="zastavkaOdId" s bigItemName = "Zastávka od" s bigDataType = $$$BigItemDataTypeCodebook
      s bigRequired=1 s bigAllowEdit=1 s bigValidation=1
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      s item.CodebookType=$$$CodebookTypeZastavky
      d item.AddValue(zastavkaOdId,zastavkaOdNazev,"")
      s item.MultiSelect = 0
      d list.Insert(item)
      // === oznacnik od
      s bigItem="oznacnikOdId" s bigItemName = "Označník od" s bigDataType = $$$BigItemDataTypeList
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=1
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddListItem("0//bez označníku",0)		               
	  i zastavkaOdId {
		  k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyOznacniky).seznam(.sys,zastavkaOdId,"",.arrDta)
		  s oznacnikId="" f {
			  s valDta="" s oznacnikId=$o(arrDta("DTA",oznacnikId),1,valDta) i oznacnikId="" q
			  s nastupiste=$lg($g(valDta),1)
			  s popis=$lg($g(valDta),4)
			  d item.AddListItem(oznacnikId_"/"_nastupiste_"/"_popis,oznacnikId)		               
		  }
	  }
      d item.AddValue((+oznacnikOdId),"","")
      d list.Insert(item)
      // === zastavka do
      s bigItem="zastavkaDoId" s bigItemName = "Zastávka do" s bigDataType = $$$BigItemDataTypeCodebook
      s bigRequired=1 s bigAllowEdit=1 s bigValidation=1
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      s item.CodebookType=$$$CodebookTypeZastavky
      d item.AddValue(zastavkaDoId,zastavkaDoNazev,"")
       s item.MultiSelect = 0
      d list.Insert(item)
      // === oznacnik do
      s bigItem="oznacnikDoId" s bigItemName = "Označník do" s bigDataType = $$$BigItemDataTypeList
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=1
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddListItem("0//bez označníku",0)		               
	  i zastavkaOdId {
		  k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyOznacniky).seznam(.sys,zastavkaDoId,"",.arrDta)
		  s oznacnikId="" f {
			  s valDta="" s oznacnikId=$o(arrDta("DTA",oznacnikId),1,valDta) i oznacnikId="" q
			  s nastupiste=$lg($g(valDta),1)
			  s popis=$lg($g(valDta),4)
			  d item.AddListItem(oznacnikId_"/"_nastupiste_"/"_popis,oznacnikId)		               
		  }
	  }
      d item.AddValue((+oznacnikDoId),"","")
      d list.Insert(item)
      
      // vypocet default
      i (vzdalenostPodleMapy="")||(trvaniPodleMapy="") {
         k arrDta s id = $lb(zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId)
         d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).vratVzdalenostZastavekNeboOznacniku(.sys,.id,.arrDta)
         s vzdalenostPodleMapy = $lg($g(arrDta("DTA")),1)
         s trvaniPodleMapy = $lg($g(arrDta("DTA")),2)
      }
      
      // === vzdalenost
      s bigItem="vzdalenost" s bigItemName = "Vzdálenost podle map (m)" s bigDataType = $$$BigItemDataTypeInteger
      s bigRequired=0 s bigAllowEdit=0 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue(vzdalenostPodleMapy,"","")
      d list.Insert(item)
      // === trvani
      s bigItem="trvani" s bigItemName = "Doba jízdy podle map (min)" s bigDataType = $$$BigItemDataTypeInteger
      s bigRequired=0 s bigAllowEdit=0 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue(trvaniPodleMapy,"","")
      d list.Insert(item)
   }
    catch (ex) {$$$CatchErrToInputErr}
   q ret
}

/// validate BIG
ClassMethod Validate(ByRef err As %String, ByRef in As %String, ByRef list As %ListOfObjects) As %String
{
   $$$Init
    try
    {
      #dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
      #dim referenceItem As ALVA.EDFORMS.CONTROLS.BIG.Item
	  $$$FillSysParamsBig(in)
	  s actionId=$lg(in("Action"),2) s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
      s validationType=$lg($g(in("Param")),1)
      s validatedItem=$lg($g(in("Param")),2)
      s items=$g(in("Items"))
      i (validationType=1) {
         s key=""
         f
         {
            s item=items.GetNext(.key) i key="" q
            i (item.Id = validatedItem)
            {
               s stt=$$$BigStateTypeOk s info=""
               i item.Id="zastavkaOdId" {
	               s zastavkaId=item.FirstValue().Data
	               //nacteni oznacniku
	               s referenceItem=items.GetItem("oznacnikOdId")
	               d referenceItem.ListItems.Clear()
	               d referenceItem.Values.Clear()
	               d referenceItem.AddListItem("0//bez označníku",0)		               
	               i zastavkaId {
		               k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyOznacniky).seznam(.sys,zastavkaId,"",.arrDta)
		               s oznacnikId="" f {
			               s valDta="" s oznacnikId=$o(arrDta("DTA",oznacnikId),1,valDta) i oznacnikId="" q
			               s nastupiste=$lg($g(valDta),1)
			               s popis=$lg($g(valDta),4)
			               d referenceItem.AddListItem(oznacnikId_"/"_nastupiste_"/"_popis,oznacnikId)		               
		               }
	               }
	               d referenceItem.AddValue(0,"","")
	               d list.Insert(referenceItem)


                  //test, jestli ma nactene souradnice, pokud ne, zobrazime info
                  k arrDta
                  d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaId,"",.arrDta)
                  s arrDta = $g(arrDta("DTA"))
                  s DoGPSN = $lg(arrDta,19)
                  s DoGPSE = $lg(arrDta,20)
                  i (DoGPSN="")||(DoGPSE="") {
                     s stt = $$$BigStateTypeInformation
                     s info = "Zastávka nemá uložené souřadnice. Úsek se je pokusi načíst pomocí čísla CIS."
                  }
                 

                  // Aktualizace vzdalenosti
                  // nacteni id zastavek a oznacniku
                  s referenceItem=items.GetItem("zastavkaOdId") s zastavkaOdId=referenceItem.FirstValue().Data
                  s referenceItem=items.GetItem("oznacnikOdId") s oznacnikOdId=referenceItem.FirstValue().Data
                  s referenceItem=items.GetItem("zastavkaDoId") s zastavkaDoId=referenceItem.FirstValue().Data
                  s referenceItem=items.GetItem("oznacnikDoId") s oznacnikDoId=referenceItem.FirstValue().Data

                  // kontrola na existujici index
                  s dGlb = $name($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"DTA"))
                  s existujiciUsekId = ""
                  i (zastavkaOdId'="")&&(oznacnikOdId'="")&&(zastavkaDoId'="")&&(oznacnikDoId'="") {
                     s existujiciUsekId = $g(@dGlb@("useky","IDX",1,zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId))
                  }
                  s refInfo = ""
                  s referenceItem=items.GetItem("id") 
                  i existujiciUsekId'=""{
                     s refinfo = "Úsek pro dané zastávky a označníky již existuje. Id: "_existujiciUsekId
                  }
                  d referenceItem.UpdateStatus($$$BigStateTypeInformation,refInfo)
                  d list.Insert(referenceItem)
                  ///

                  k arrDta s id = $lb(zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId)
                  d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).vratVzdalenostZastavekNeboOznacniku(.sys,.id,.arrDta)
                  s vzdalenost = $lg($g(arrDta("DTA")),1)
                  s trvani = $lg($g(arrDta("DTA")),2)
                  // nastaveni vzdalenosti
                  s referenceItemVzdalenost=items.GetItem("vzdalenost")
                  d referenceItemVzdalenost.Values.Clear()
                  d referenceItemVzdalenost.AddValue(vzdalenost,"","")
                  d list.Insert(referenceItemVzdalenost)
                  // nastaveni trvani
                  s referenceItemTrvani=items.GetItem("trvani")
                  d referenceItemTrvani.Values.Clear()
                  d referenceItemTrvani.AddValue(trvani,"","")
                  d list.Insert(referenceItemTrvani)

                  s valDta = $lb(zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId,vzdalenost,trvani)
                  s $$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA")=valDta
                  
               }
               i item.Id="zastavkaDoId" {
	               s zastavkaDoId=item.FirstValue().Data
	               //nacteni oznacniku
	               s referenceItem=items.GetItem("oznacnikDoId")
	               d referenceItem.ListItems.Clear()
	               d referenceItem.Values.Clear()
	               d referenceItem.AddListItem("0//bez označníku",0)		               
	               i zastavkaDoId {
		               k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyOznacniky).seznam(.sys,zastavkaDoId,"",.arrDta)
		               s oznacnikId="" f {
			               s valDta="" s oznacnikId=$o(arrDta("DTA",oznacnikId),1,valDta) i oznacnikId="" q
			               s nastupiste=$lg($g(valDta),1)
			               s popis=$lg($g(valDta),4)
			               d referenceItem.AddListItem(oznacnikId_"/"_nastupiste_"/"_popis,oznacnikId)		               
		               }
	               }
	               d referenceItem.AddValue(0,"","")
	               d list.Insert(referenceItem)

                  //test, jestli ma nactene souradnice, pokud ne, zobrazime info
                  k arrDta
                  d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaDoId,"",.arrDta)
                  s arrDta = $g(arrDta("DTA"))
                  s DoGPSN = $lg(arrDta,19)
                  s DoGPSE = $lg(arrDta,20)
                  i (DoGPSN="")||(DoGPSE="") {
                     s stt = $$$BigStateTypeInformation
                     s info = "Zastávka nemá uložené souřadnice. Úsek se je pokusi načíst pomocí čísla CIS."
                  }

                  // Aktualizace vzdalenosti
                  // nacteni id zastavek a oznacniku
                  s referenceItem=items.GetItem("zastavkaOdId") s zastavkaOdId=referenceItem.FirstValue().Data
                  s referenceItem=items.GetItem("oznacnikOdId") s oznacnikOdId=referenceItem.FirstValue().Data
                  s referenceItem=items.GetItem("zastavkaDoId") s zastavkaDoId=referenceItem.FirstValue().Data
                  s referenceItem=items.GetItem("oznacnikDoId") s oznacnikDoId=referenceItem.FirstValue().Data

                  // kontrola na existujici index
                  s dGlb = $name($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"DTA"))
                  s existujiciUsekId = ""
                  i (zastavkaOdId'="")&&(oznacnikOdId'="")&&(zastavkaDoId'="")&&(oznacnikDoId'="") {
                     s existujiciUsekId = $g(@dGlb@("useky","IDX",1,zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId))
                  }
                  s refInfo = ""
                  s referenceItem=items.GetItem("id") 
                  i existujiciUsekId'=""{
                     s refinfo = "Úsek pro dané zastávky a označníky již existuje. Id: "_existujiciUsekId
                  }
                  d referenceItem.UpdateStatus($$$BigStateTypeInformation,refInfo)
                  d list.Insert(referenceItem)
                  ///

                  k arrDta s id = $lb(zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId)
                  d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).vratVzdalenostZastavekNeboOznacniku(.sys,.id,.arrDta)
                  s vzdalenost = $lg($g(arrDta("DTA")),1)
                  s trvani = $lg($g(arrDta("DTA")),2)
                  // nastaveni vzdalenosti
                  s referenceItemVzdalenost=items.GetItem("vzdalenost")
                  d referenceItemVzdalenost.Values.Clear()
                  d referenceItemVzdalenost.AddValue(vzdalenost,"","")
                  d list.Insert(referenceItemVzdalenost)
                  // nastaveni trvani
                  s referenceItemTrvani=items.GetItem("trvani")
                  d referenceItemTrvani.Values.Clear()
                  d referenceItemTrvani.AddValue(trvani,"","")
                  d list.Insert(referenceItemTrvani)

                  s valDta = $lb(zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId,vzdalenost,trvani)
                  s $$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA")=valDta
                  
               }
              
               // nacitani vzdalenosti
               i item.Id="oznacnikOdId" {
	               // Aktualizace vzdalenosti
                  // nacteni id zastavek a oznacniku
                  s referenceItem=items.GetItem("zastavkaOdId") s zastavkaOdId=referenceItem.FirstValue().Data
                  s referenceItem=items.GetItem("oznacnikOdId") s oznacnikOdId=referenceItem.FirstValue().Data
                  s referenceItem=items.GetItem("zastavkaDoId") s zastavkaDoId=referenceItem.FirstValue().Data
                  s referenceItem=items.GetItem("oznacnikDoId") s oznacnikDoId=referenceItem.FirstValue().Data

                  // kontrola na existujici index
                  s dGlb = $name($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"DTA"))
                  s existujiciUsekId = ""
                  i (zastavkaOdId'="")&&(oznacnikOdId'="")&&(zastavkaDoId'="")&&(oznacnikDoId'="") {
                     s existujiciUsekId = $g(@dGlb@("useky","IDX",1,zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId))
                  }
                  s refInfo = ""
                  s referenceItem=items.GetItem("id") 
                  i existujiciUsekId'=""{
                     s refinfo = "Úsek pro dané zastávky a označníky již existuje. Id: "_existujiciUsekId
                  }
                  d referenceItem.UpdateStatus($$$BigStateTypeInformation,refInfo)
                  d list.Insert(referenceItem)
                  ///

                  k arrDta s id = $lb(zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId)
                  d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).vratVzdalenostZastavekNeboOznacniku(.sys,.id,.arrDta)
                  s vzdalenost = $lg($g(arrDta("DTA")),1)
                  s trvani = $lg($g(arrDta("DTA")),2)
                  // nastaveni vzdalenosti
                  s referenceItemVzdalenost=items.GetItem("vzdalenost")
                  d referenceItemVzdalenost.Values.Clear()
                  d referenceItemVzdalenost.AddValue(vzdalenost,"","")
                  d list.Insert(referenceItemVzdalenost)
                  // nastaveni trvani
                  s referenceItemTrvani=items.GetItem("trvani")
                  d referenceItemTrvani.Values.Clear()
                  d referenceItemTrvani.AddValue(trvani,"","")
                  d list.Insert(referenceItemTrvani)

                  s valDta = $lb(zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId,vzdalenost,trvani)
                  s $$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA")=valDta
               }
                // nacitani vzdalenosti
               i item.Id="oznacnikDoId" {
	               // Aktualizace vzdalenosti
                  // nacteni id zastavek a oznacniku
                  s referenceItem=items.GetItem("zastavkaOdId") s zastavkaOdId=referenceItem.FirstValue().Data
                  s referenceItem=items.GetItem("oznacnikOdId") s oznacnikOdId=referenceItem.FirstValue().Data
                  s referenceItem=items.GetItem("zastavkaDoId") s zastavkaDoId=referenceItem.FirstValue().Data
                  s referenceItem=items.GetItem("oznacnikDoId") s oznacnikDoId=referenceItem.FirstValue().Data

                  // kontrola na existujici index
                  s dGlb = $name($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"DTA"))
                  s existujiciUsekId = ""
                  i (zastavkaOdId'="")&&(oznacnikOdId'="")&&(zastavkaDoId'="")&&(oznacnikDoId'="") {
                     s existujiciUsekId = $g(@dGlb@("useky","IDX",1,zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId))
                  }
                  s refInfo = ""
                  s referenceItem=items.GetItem("id") 
                  i existujiciUsekId'=""{
                     s refinfo = "Úsek pro dané zastávky a označníky již existuje. Id: "_existujiciUsekId
                  }
                  d referenceItem.UpdateStatus($$$BigStateTypeInformation,refInfo)
                  d list.Insert(referenceItem)
                  ///


                  k arrDta s id = $lb(zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId)
                  d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).vratVzdalenostZastavekNeboOznacniku(.sys,.id,.arrDta)
                  s vzdalenost = $lg($g(arrDta("DTA")),1)
                  s trvani = $lg($g(arrDta("DTA")),2)
                  // nastaveni vzdalenosti
                  s referenceItemVzdalenost=items.GetItem("vzdalenost")
                  d referenceItemVzdalenost.Values.Clear()
                  d referenceItemVzdalenost.AddValue(vzdalenost,"","")
                  d list.Insert(referenceItemVzdalenost)
                  // nastaveni trvani
                  s referenceItemTrvani=items.GetItem("trvani")
                  d referenceItemTrvani.Values.Clear()
                  d referenceItemTrvani.AddValue(trvani,"","")
                  d list.Insert(referenceItemTrvani)

                  s valDta = $lb(zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId,vzdalenost,trvani)
                  s $$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA")=valDta
                  
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
      //
      s action=$g(in("Action"))
      s items=$g(in("Items"))
      s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
	  //data na formulari
	  s valDta=""
      s key="" f {
	      s item=items.GetNext(.key) i key="" q
          s mItem=item.Id s val=item.FirstValueData()
          i mItem="zastavkaOdId" {s $li(valDta,1)=$p(val,"|",1)}
          i mItem="oznacnikOdId" {s $li(valDta,2)=val}
          i mItem="zastavkaDoId" {s $li(valDta,3)=$p(val,"|",1)}
          i mItem="oznacnikDoId" {s $li(valDta,4)=val}
          i mItem="vzdalenost"   {s $li(valDta,5)=val}
          i mItem="trvani"       {s $li(valDta,6)=val}
      }
      s $$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA")=valDta
      
      // ulozeni do datove vety useku
      s usekId=$g($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","ID"))
      k arrDta  m arrDta("DTA") = @$name($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA"))

      s arrDta("DTA")= valDta
      
      d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUseky).uloz(.sys,$lb("",usekId),$name($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"DTA")),.arrDta)
   }
   catch (ex) { $$$CatchErrToInputErr}
   q ret
}

}
