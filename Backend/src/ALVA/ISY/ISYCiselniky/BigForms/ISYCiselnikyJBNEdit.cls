Include (ALVALIBRARY, ALVAEDFORMS, ALVAEDREPORTS, GENERAL, ALVAISY, ALVAISY3)

Class ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikyJBNEdit Extends %RegisteredObject
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
			s id=$lg(in("Action"),4)
			//
			#dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
			#dim value As ALVA.EDFORMS.CONTROLS.BIG.ItemValue     
			s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
			//nacteni dat z databaze
			k arrDta i id d ##class(ALVA.ISY.ISYCiselniky.API.JBN).nacti(.sys,id,.arrDta)
			s valDta=$g(arrDta("DTA"))
			//
			s akce=$lg(in("Action"),2)
			if (akce=$$$FormModeAdd) { d ##class(ALVA.ISY.ISYCiselniky.API.JBN).noveID(.sys,.id,"")}
			//naplneni bigu
			s bigGroup="G1" s bigGroupName="Obecné" 
			//
			s bigItem="id" s bigItemName="Id/Číslo" s bigDataType=$$$BigItemDataTypeInteger
			s bigRequired=0 s bigAllowEdit=0 s bigValidation=1
			s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"") 
			d item.AddValue(id,"","")
			d list.Insert(item)
			//
			s bigItem="kilometry" s bigItemName="Kilometry" s bigDataType=$$$BigItemDataTypeInteger
			s bigRequired=1 s bigAllowEdit=1 s bigValidation=0
			s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"") 
			d item.AddValue($lg(valDta,2),"","")
			d list.Insert(item)
			//
			s bigItem="odmena" s bigItemName="Odměna" s bigDataType=$$$BigItemDataTypeInteger
			s bigRequired=1 s bigAllowEdit=1 s bigValidation=0
			s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"") 
			d item.AddValue($lg(valDta,3),"","")
			d list.Insert(item)
			
	 }
		catch (ex) { $$$CatchErrToInputErr}
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
			i (validationType=1) {
				 s key=""
				 f
				 {
						s item=items.GetNext(.key) i key="" q    
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
			s id="" s valDta=""
			s key="" 
			for       
			{
				s item=items.GetNext(.key) i key="" q
					s mItem=item.Id
					i mItem="id" {s id=item.FirstValueData() s $li(valDta,1)=id }
					i mItem="kilometry" s $li(valDta,2)=item.FirstValueData() 
					i mItem="odmena" s $li(valDta,3)=item.FirstValueData()
			}
			//
			k arrDta s arrDta("DTA")=valDta d ##class(ALVA.ISY.ISYCiselniky.API.JBN).uloz(.sys,id,.arrDta)
	 }
	 catch (ex) { $$$CatchErrToInputErr}
	 q ret
}

}
