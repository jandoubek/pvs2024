Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyVzdalenostiEdit Extends %RegisteredObject
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
      s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
      //nacteni dat z databaze
      k arrDta d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDoby).nacti(.sys,"",$name($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"DTA")),.arrDta)
      s valDta=$g(arrDta("DTA"))
	  //naplneni bigu
      s bigGroup="G1" s bigGroupName="Obecné"
      // === id jen zobrazim
      s bigItem="id" s bigItemName = "Id" s bigDataType = $$$BigItemDataTypeInteger
      s bigRequired=0 s bigAllowEdit=0 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"ID")),"","")     
      d list.Insert(item)
      //=== zkratka
      s bigItem="zkratka" s bigItemName="Zkratka" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=1 s bigAllowEdit=1 s bigValidation=1 i actionMode=4 s bigAllowEdit=1
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"") 
	  d item.AddValue($lg(valDta,1),"","")
      d list.Insert(item)
      //=== nazev
      s bigItem="popis" s bigItemName="Popis" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"") 
	  d item.AddValue($lg(valDta,2),"","")
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
      //      
      s vzdalenostiJizdniDobyId=$g($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"ID"))
      //
      i (validationType=1) {
         s key=""
         f
         {
            s item=items.GetNext(.key) i key="" q    
            i (item.Id = validatedItem)
            {	            
               s stt=$$$BigStateTypeOk s info=""               	
               i item.Id="zkratka" {
	               s valItem = item.FirstValue().Data
	          	   i valItem'="" {
		          	   i $d(^[dataDB]ALVA.ISY.VZD("IDX",2,valItem)) {
			          	   i ($g(^[dataDB]ALVA.ISY.VZD("IDX",2,valItem))'=vzdalenostiJizdniDobyId) {
				          	   s stt=$$$BigStateTypeError
               		   	   	   s info="Definice vzdáleností a jízdních dob se zkratkou "_valItem_" již existuje !"
			          	   }
	               	   }
	          	   }
               }                 
               d item.UpdateStatus(stt,info)             
               d list.Insert(item)                
            }            
         }
      }     
   }
   catch (ex) { $$$CatchErrToInputErr  }
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
      //
      $$$FillSysParamsBig(in)
      s action=$g(in("Action"))
      s items=$g(in("Items"))
      s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
      //data na formulari
      s valDta=""
      s key="" f {
	      s item=items.GetNext(.key) i key="" q
          s mItem=item.Id
          i mItem="zkratka" {s $li(valDta,1)=item.FirstValueData()}
          i mItem="popis" {s $li(valDta,2)=item.FirstValueData()}   
      }
      k arrDta s arrDta("DTA")=valDta d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDoby).uloz(.sys,"",$name($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"DTA")),.arrDta)
   }
   catch (ex)
    {
       $$$CatchErrToInputErr
    }
   q ret
}

}
