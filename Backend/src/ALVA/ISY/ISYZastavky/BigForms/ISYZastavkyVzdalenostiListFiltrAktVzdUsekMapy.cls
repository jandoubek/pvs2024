Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY, ALVAEDREPORTS)

Class ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyVzdalenostiListFiltrAktVzdUsekMapy Extends %RegisteredObject
{

Parameter FiltrId = "ISY0008";

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
	  // === skupina vzdalenosti, kam nacit vzdalenosti
      s bigItem="vzdalenostiJizdniDobyId" s bigItemName="Přesne vzdálenosti aktualizovat v evidenci" s bigDataType=$$$BigItemDataTypeList
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
      //ulozim data filtru
      for 
      {
	      s item=items.GetNext(.key) i key="" q
          s mItem=item.Id
          s $$$CTMPGLBFRM(GUID,..CTMPGLBFRMIDX(),"DTA",mItem)=item.FirstValueData()
          s $$$GLBBIGMEM(userID,..#FiltrId,"DTA",mItem)=item.FirstValueData()
      }
   }
   catch (ex) { $$$CatchErrToInputErr}
   q ret
}

}
