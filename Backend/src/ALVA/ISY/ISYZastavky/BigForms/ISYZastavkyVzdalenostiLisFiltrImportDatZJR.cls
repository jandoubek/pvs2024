Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY, ALVAEDREPORTS)

Class ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyVzdalenostiLisFiltrImportDatZJR Extends %RegisteredObject
{

Parameter FiltrId = "ISY0006";

ClassMethod CTMPGLBFRMIDX() As %String
{
	q $p($THIS,"ALVA.ISY.",2)
}

/// init BIG
ClassMethod Init(ByRef err As %String, ByRef in As %String, ByRef list As %ListOfObjects) As %String
{
   $$$Init
    try
    { 
      //
      $$$FillSysParamsBig(in)
   	  s actionId=$lg(in("Action"),2) s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
	  //
	  #dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
      #dim value As ALVA.EDFORMS.CONTROLS.BIG.ItemValue 
      //
      k $$$CTMPGLBFRM(GUID,..CTMPGLBFRMIDX())
	  //vytvorim big
	  s bigGroup="G1" s bigGroupName="Obecné nastavení"     
	  // === skupina linek ze ktere se budou nacitat vzdalenosti
      s bigItem="skupinaId" s bigItemName="Vzdálenosti načíst z linek ze skupiny" s bigDataType=$$$BigItemDataTypeCodebook
      s bigRequired=1 s bigAllowEdit=1 s bigValidation=0
      s skupinaId=$g($$$GLBBIGMEM(userID,..#FiltrId,"DTA",bigItem))
      s skupinaNazev="" i skupinaId k arrCisDta d ##class(ALVA.ISY.ISYCiselniky.API.SkupinyLinek).nacti(.sys,skupinaId,.arrCisDta) s skupinaNazev=$lg($g(arrCisDta("DTA")),1)
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      s item.CodebookType=$$$CodebookTypeSkupinyLinek
      d item.AddValue(skupinaId,skupinaNazev,"")
      d list.Insert(item)
	  // === skupina vzdalenosti, kam nacit vzdalenosti
      s bigItem="vzdalenostiJizdniDobyId" s bigItemName="Vzdálenosti zapsat do evidence" s bigDataType=$$$BigItemDataTypeList
      s bigRequired=1 s bigAllowEdit=1 s bigValidation=0
      s vzdalenostiJizdniDobyId=$g($$$GLBBIGMEM(userID,..#FiltrId,"DTA",bigItem))
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"") 
	  d item.AddValue(vzdalenostiJizdniDobyId,"","")
	  k arrCis d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDoby).seznam(.sys,.arrCis)
	  s abcidx="" f {
		  s vzdalenostiJizdniDobyId="" s abcidx=$o(arrCis("IDX",abcidx),1,vzdalenostiJizdniDobyId) i abcidx="" q
		  s val=$g(arrCis("DTA",vzdalenostiJizdniDobyId))
		  s zkratka=$lg(val,1) s popis=$lg(val,2)
		  d item.AddListItem(zkratka,vzdalenostiJizdniDobyId)
	  }
	  d list.Insert(item)
	  // === casova varianta
      s bigItem="datumCasVar" s bigItemName="Časová varianta vzdáleností a jízdních dob" s bigDataType=$$$BigItemDataTypeDate
      s bigRequired=1 s bigAllowEdit=1 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      s val=$g($$$GLBBIGMEM(userID,..#FiltrId,"DTA",bigItem))
      d item.AddValue(val,"","")
      d list.Insert(item)
      // === typ aktualizace
	  s bigGroup="G2" s bigGroupName="Parametry importu"     
      s bigItem="typAktualizace" s bigItemName="Typ aktualizace dat" s bigDataType=$$$BigItemDataTypeList
      s bigRequired=1 s bigAllowEdit=1 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddListItem("aktualizovat všechny úseky",0)
      d item.AddListItem("doplnit chybějící úseky ",1)
      s val=$g($$$GLBBIGMEM(userID,..#FiltrId,"DTA",bigItem))
      d item.AddValue(val,"","")
      d list.Insert(item)
      //=== zakladni doby podle rychlosti
	  s bigGroup="G3" s bigGroupName="Výpocet jízdní doby podle rychlosti"
      s bigItem="zakladniDobaJizdyRychlost" s bigItemName = "Vypočítat základní dobu jízdy podle rychlosti (km/h)" s bigDataType = $$$BigItemDataTypeInteger
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      s val=$g($$$GLBBIGMEM(userID,..#FiltrId,"DTA",bigItem))
      d item.AddValue(val,"","")
      d list.Insert(item)
      //=== zakladni doby pasem podle rychlosti
      k arrCis d ##class(ALVA.ISY.ISYCiselniky.API.CasovaPasmaJizdniDoby).seznam(.sys,.arrCis)
      s pasmoJizdniDobaId="" f {
	      s pasmoJizdniDobaId=$o(arrCis("DTA",pasmoJizdniDobaId)) i pasmoJizdniDobaId="" q
	      s nazev=$lg($g(arrCis("DTA",pasmoJizdniDobaId)),1)
	      s bigItem="pasmoDobaJizdyRychlost|"_pasmoJizdniDobaId s bigItemName = "Vypočítat dobu jízdy pásma """_pasmoJizdniDobaId_"/"_nazev_""" podle rychlosti (km/h)" s bigDataType = $$$BigItemDataTypeInteger
      	  s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      	  s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      	  s val=$g($$$GLBBIGMEM(userID,..#FiltrId,"DTA",bigItem))
      	  d item.AddValue(val,"","")
      	  d list.Insert(item)
      }
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
      //
      s IdFa=$g(in("IdFa"))
      s user=$g(in("User"))
      s action=$g(in("Action"))
      s actionMode=$lg(in("Action"),2)
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
            if (item.Id = validatedItem)
            {
	           s stt=$$$BigStateTypeOk
               s info=""
	           i item.Id="" {s val=item.FirstValue().Data }
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
      s valDta=""
      //data na formulari
      s key=""
      k $$$GLBBIGMEM(userID,..#FiltrId)
      k $$$CTMPGLBFRM(GUID,..CTMPGLBFRMIDX())
      for 
      {
	      s item=items.GetNext(.key) i key="" q
          s mItem=item.Id
          s $$$CTMPGLBFRM(GUID,..CTMPGLBFRMIDX(),"DTA",mItem)=item.FirstValueData()
          s $$$GLBBIGMEM(userID,..#FiltrId,"DTA",mItem)=item.FirstValueData()
      }   
      //ulozim data filtru
   }
   catch (ex) { $$$CatchErrToInputErr}
   q ret
}

}
