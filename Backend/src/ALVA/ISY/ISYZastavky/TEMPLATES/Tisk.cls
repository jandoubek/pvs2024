Include (ALVALIBRARY, ALVAEDFORMS, GENERAL)

Class ALVA.ISY.ISYZastavky.TEMPLATES.Tisk Extends %RegisteredObject
{

/// 
/// Vrací data pro naplnění contextovéhomenu tlačítka print
/// 
ClassMethod LoadMenuItems(ByRef sys As %String) As %Status
{
	$$$Init
	try 
	{	
		$$$FillParams				
		s idx="" 
        for
        {
	        s idx=$o(^||ML("IN",idx),1,val) q:idx="" 
	        i $p(val,del,1)="Id" s id=$p(val,del,2)
        }
        if id = "formISYZastavkyMain.btnTisk" d ##class(ALVA.ISY.ISYZastavky.Forms.Tisky.MenuItems).FormISYZastavkyMainBtnTisk(.sys)	 
        if id = "formISYZastavkyVzdalenostEdit.cbtTisk" d ##class(ALVA.ISY.ISYZastavky.Forms.Tisky.MenuItems).FormISYZastavkyVzdalenostEditBtnTisk(.sys)
		if id = "formISYZastavkyMain.btnTisk2" d ##class(ALVA.ISY.ISYZastavky.Forms.Tisky.MenuItems).FormISYZastavkyInfoBtnTisk(.sys)	 
	}
	catch (ex) {$$$CatchErrRest}
	quit ret
}

/// 
/// Zavolá sestavení tabulky a vrací data pro tisk tabulky
/// 
ClassMethod LoadTable(ByRef sys As %String) As %Status
{
	$$$Init
	try 
	{	
		$$$FillParams				
		s idx="" 
        for
        {
	        s idx=$o(^||ML("IN",idx),1,val) q:idx="" 
	        i $p(val,del,1)="Id" s id=$p(val,del,2)
	        i $p(val,del,1)="Filtr" s filtr($p(val,del,2),$p(val,del,3))=""
	        i $p(val,del,1)="Param" s param($p(val,del,2),$p(val,del,3))=""
        } 
        s idx=##class(ALVA.TISK.Main).GetNewGlobalIndex()        
        if (id = "formISYZastavkyMain.ISYT0001") {d ##class(ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0001).LoadTable(.sys,.filtr,.param,idx,.idTab,.nadpis,.title,.nadpis2,.nadpis3)}
        if (id = "formISYZastavkyMain.ISYT0002") {d ##class(ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0002).LoadTable(.sys,.filtr,.param,idx,.idTab,.nadpis,.title,.nadpis2,.nadpis3)}
        if (id = "formISYZastavkyMain.ISYT0003") {d ##class(ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0003).LoadTable(.sys,.filtr,.param,idx,.idTab,.nadpis,.title,.nadpis2,.nadpis3)}
		if (id = "formISYZastavkyVzdalenostEdit.ISYT0005") {d ##class(ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0005).LoadTable(.sys,.filtr,.param,idx,.idTab,.nadpis,.title,.nadpis2,.nadpis3)}
        if (id = "formISYZastavkyMain.ISYT0006") {d ##class(ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0006).LoadTable(.sys,.filtr,.param,idx,.idTab,.nadpis,.title,.nadpis2,.nadpis3)}
		if (id = "formISYZastavkyMain.ISYT0008") {d ##class(ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0008).LoadTable(.sys,.filtr,.param,idx,.idTab,.nadpis,.title,.nadpis2,.nadpis3)}
		// povinný výstup
		s ^||ML("OUT",($i(i)))=$lts($lb("iIndexGlobalu",$g(idx)),del)
		s ^||ML("OUT",($i(i)))=$lts($lb("iIndexTab",$g(idTab)),del)
		s ^||ML("OUT",($i(i)))=$lts($lb("nadpis",$g(nadpis)),del)
		s ^||ML("OUT",($i(i)))=$lts($lb("nadpis2",$g(nadpis2)),del)
		s ^||ML("OUT",($i(i)))=$lts($lb("nadpis3",$g(nadpis3)),del)
		s ^||ML("OUT",($i(i)))=$lts($lb("title",$g(title)),del)
		s ^||ML("OUT",($i(i)))=$lts($lb("title2",$g(title2)),del)
	}
	catch (ex) {$$$CatchErrRest}
	quit ret
}

ClassMethod LoadItems(ByRef in As %String, ByRef out As %String) As %Status
{
	$$$InitializeMethodEx("ALVAEDFORMS")
	s sc=$$$OK	
	try 
	{	
		s idfa=$g(in("IdFa"))
		s nmsp=##class(ALVA.GENERALAPI.DataBase).dataDB(idfa)
		if nmsp="" s err="chybí nmsp pro IdFa="_idfa ztrap
		s sysnmsp=##class(ALVA.GENERALAPI.DataBase).sysDB()
		s user=$g(in("User")) s mlp=$lg(user,1) s loginName=$lg(user,2) s fullName=$lg(user,3)
		s action=$g(in("Action"))
		s ActionID=$lg(action,1)
		s ObjID=$lg(action,3)		
		#dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
		#dim value As ALVA.EDFORMS.CONTROLS.BIG.ItemValue			
		#dim items As %ListOfObjects
		s items=##class(%ListOfObjects).%New()		
		// 	
		if (ActionID="formISYZastavkyMain.ISYT0001") { d ##class(ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0001).Init(.err,.in,.items) }
		if (ActionID="formISYZastavkyMain.ISYT0002") { d ##class(ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0002).Init(.err,.in,.items) }
		if (ActionID="formISYZastavkyMain.ISYT0003") { d ##class(ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0003).Init(.err,.in,.items) }
		if (ActionID="formISYZastavkyVzdalenostEdit.ISYT0005") { d ##class(ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0005).Init(.err,.in,.items) }
		if (ActionID="formISYZastavkyMain.ISYT0006") { d ##class(ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0006).Init(.err,.in,.items) }
		if (ActionID="formISYZastavkyMain.ISYT0008") { d ##class(ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0008).Init(.err,.in,.items) }
		
		//
		if (err'="") { ztrap }				
		s out("Status")=$lb($$$BigStateTypeOk,"",0)
		s out("Items")=items			
	}
	catch ex 
	{
		s sc=ex.DisplayString()
		s err=$$$GetStack
		s sc=$$$ERROR($$$GeneralError,err)
	}
	k ^||tempALVAEDFORMS(workID)
	quit sc
}

/// Ulozi polozky
ClassMethod SaveItems(ByRef in As %String, ByRef out As %String)
{
	$$$InitializeMethodEx("ALVAEDFORMS")
	s sc=$$$OK	
	try 
	{
		#dim items As %ListOfObjects
		#dim item As ALVA.EDFORMS.CONTROLS.BIG.Item		
		#dim value As ALVA.EDFORMS.CONTROLS.BIG.ItemValue
		s items=$g(in("Items"))
		s key=""
         for
         {
            s item=items.GetNext(.key) q:key=""           
            s keyV=""
			for
			{
				s value=item.Values.GetNext(.keyV) q:keyV=""
				i value.Data="" continue
				s out("ParamEx",item.Id,value.Data)=""
			}           	 
         }	      
		s out("Status")=$lb($$$BigStateTypeOk,"",0,1)
	}
	catch ex 
	{
		s err=$$$GetStack
		s sc=$$$ERROR($$$GeneralError,err)
	}
	k ^||tempALVAEDFORMS(workID)
	quit sc
}

/// Overi polozky
ClassMethod ValidateItems(ByRef in As %String, ByRef out As %String) As %Status
{
	$$$InitializeMethodEx("ALVAEDFORMS")
	s sc=$$$OK	
	try 
	{
		#dim items As ALVA.EDFORMS.CONTROLS.BIG.ListOfItems
		#dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
		#dim newItems As %ListOfObjects
		#dim referenceItem As ALVA.EDFORMS.CONTROLS.BIG.Item	
		s idfa=$g(in("IdFa"))
		s user=$g(in("User")) s mlp=$lg(user,1) s loginName=$lg(user,2) s fullName=$lg(user,3)
		s action=$g(in("Action")) s ActionID=$lg(action,1)
		s validationType=$lg($g(in("Param")),1)
		s validatedItem=$lg($g(in("Param")),2)
		s items=$g(in("Items"))
		k arr d ##class(ALVA.EDISON.Main).GetApplicationInfo(-1,.arr,idfa) s nmsp=$g(arr(0)) k arr
		s newItems=##class(%ListOfObjects).%New()
		s refresh=1
		s cancel=0
		s stt=$$$BigStateTypeOk
		s info=""
		k out				
		// 
		if (ActionID="formISYZastavkyMain.ISYT0001") { d ##class(ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0001).Validate(.err,.in,.newItems) }
		if (ActionID="formISYZastavkyMain.ISYT0002") { d ##class(ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0002).Validate(.err,.in,.newItems) }
		if (ActionID="formISYZastavkyMain.ISYT0003") { d ##class(ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0003).Validate(.err,.in,.newItems) }
		if (ActionID="formISYZastavkyMain.ISYT0006") { d ##class(ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0006).Validate(.err,.in,.newItems) }
		if (ActionID="formISYZastavkyMain.ISYT0008") { d ##class(ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0008).Validate(.err,.in,.newItems) }
		//
		if (err'=""){ztrap}		
		s zobrInfo=1
		s clear=+$g(out("clear"))
		s idPol=$g(out("idPol"))
		s out("Status")=$lb(stt,info,zobrInfo,refresh,cancel,clear)
		s out("Items")=newItems
		s out("Param")=$lb(idPol)
	}
	catch ex 
	{
		s sc=ex.DisplayString()
		s err=$$$GetStack
		s sc=$$$ERROR($$$GeneralError,err)
	}	
	k ^||tempALVAEDFORMS(workID)
	quit sc
}

}
