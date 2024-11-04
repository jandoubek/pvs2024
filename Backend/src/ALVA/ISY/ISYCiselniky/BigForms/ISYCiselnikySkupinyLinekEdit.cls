Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikySkupinyLinekEdit Extends %RegisteredObject
{

/// init BIG
ClassMethod Init(ByRef err As %String, ByRef in As %String, ByRef list As %ListOfObjects) As %String
{

	 $$$Init
		try
		{   
		//systemove promenne
		$$$FillSysParamsBig(in)
		s IdFa=$g(sys("U","IdFa")) s userId=$g(sys("U","MLP"))
		s actionId=$lg(in("Action"),2) s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
		s skupinaId=$o(in("ParamEx","IDEditPol","")) s skupinaId=$p(skupinaId,"|",1)
		//
		#dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
			#dim value As ALVA.EDFORMS.CONTROLS.BIG.ItemValue     
			s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
			//nacteni dat z databaze
			k arrDta i skupinaId d ##class(ALVA.ISY.ISYCiselniky.API.SkupinyLinek).nacti(.sys,skupinaId,.arrDta)
			s valDta=$g(arrDta("DTA"))
			//
		s akce=$lg(in("Action"),2)
		if (akce=$$$FormModeAdd) { d ##class(ALVA.ISY.ISYCiselniky.API.SkupinyLinek).noveID(.sys,.skupinaId,"")}
		//naplneni bigu
			s bigGroup="G1" s bigGroupName="Obecné" 
			//
			s bigItem="skupinaId" s bigItemName="Id/Číslo" s bigDataType=$$$BigItemDataTypeInteger
			s bigRequired=1 s bigAllowEdit=1 s bigValidation=1 i actionMode=4 s bigAllowEdit=0
			s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"") 
		s item.MinValue=1
		s item.MaxValue=999
		d item.AddValue(skupinaId,"","")
			d list.Insert(item)
			//
			s bigItem="nazev" s bigItemName="Název" s bigDataType=$$$BigItemDataTypeText
			s bigRequired=1 s bigAllowEdit=1 s bigValidation=0
			s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"") 
		d item.AddValue($lg(valDta,1),"","")
		s item.DeniedInputChars="~"
			d list.Insert(item)
			//
			s bigItem="datumOd" s bigItemName="Platí od" s bigDataType=$$$BigItemDataTypeDate
			s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
			s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"") 
			s datum="" i $lg(valDta,2) s datum=##class(ALVA.GENERALAPI.Date).horToDate($lg(valDta,2))
		d item.AddValue(datum,"","")
			d list.Insert(item)
			//
			s bigItem="datumDo" s bigItemName="Platí do" s bigDataType=$$$BigItemDataTypeDate
			s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
			s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"") 
			s datum="" i $lg(valDta,3) s datum=##class(ALVA.GENERALAPI.Date).horToDate($lg(valDta,3))
		d item.AddValue(datum,"","")
			d list.Insert(item)
			//
			s bigItem="zamekZmena" s bigItemName="Uzamčeno proti změnám" s bigDataType=$$$BigItemDataTypeBoolean
			s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
			s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"") 
		d item.AddValue(+$lg(valDta,4),"","")
			d list.Insert(item)
			//
			// ciselnik typu skupin linek
		k arrCisTypySkupinLinek d ##class(ALVA.ISY.ISYCiselniky.API.TypySkupinLinek).seznam(.sys,.arrCisTypySkupinLinek)
			s bigItem="skupinaTypId" s bigItemName="Typ skupiny" s bigDataType=$$$BigItemDataTypeList
			s bigRequired=1 s bigAllowEdit=1 s bigValidation=0
			s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"") 
			d item.AddValue($lg(valDta,7),"","")
		s polozkaId="" f {
			s dtaCis="" s polozkaId=$o(arrCisTypySkupinLinek("DTA",polozkaId),1,dtaCis) i polozkaId="" q
			s nazev=$lg(dtaCis,1)
			d item.AddListItem(nazev,polozkaId)
		}
			d list.Insert(item)
			k arrCisTypySkupinLinek
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
						i (item.Id = validatedItem)
						{	            
							 s stt=$$$BigStateTypeOk s info=""
							 
							 i item.Id="skupinaId" {
								 s id=item.FirstValue().Data
								 k arr d ##class(ALVA.ISY.ISYCiselniky.API.SkupinyLinek).existuje(.sys,id,.arr)
								 i +$g(arr("STT")) {
									 s stt=$$$BigStateTypeError
										 s info="skupina linek s id/číslem "_id_" již existuje"
								 }
								 i (id<1)!(id>999) {
									 s stt=$$$BigStateTypeError
										 s info="zadejte údaj v rozsahu 1-999"
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
			s skupinaId="" s valDta=""
			s key="" 
			for       
			{
				s item=items.GetNext(.key) i key="" q
					s mItem=item.Id
					i mItem="skupinaId" {s skupinaId=item.FirstValueData()}
					i mItem="nazev" {s $li(valDta,1)=item.FirstValueData()}   
					i mItem="datumOd" {s $li(valDta,2)="" s datum=item.FirstValueData() i datum s $li(valDta,2)=##class(ALVA.GENERALAPI.Date).DateToHor(datum)}   
					i mItem="datumDo" {s $li(valDta,3)="" s datum=item.FirstValueData() i datum s $li(valDta,3)=##class(ALVA.GENERALAPI.Date).DateToHor(datum)}
					i mItem="zamekZmena" {s $li(valDta,4)=(+item.FirstValueData())}
					i mItem="skupinaTypId" {s $li(valDta,7)=item.FirstValueData()}         
			}
			s $li(valDta,5)=0	//zamekKopirovani
			s $li(valDta,6)=1 //pouzitNZ
			//
			k arrDta s arrDta("DTA")=valDta d ##class(ALVA.ISY.ISYCiselniky.API.SkupinyLinek).uloz(.sys,skupinaId,.arrDta)
	 }
	 catch (ex) { $$$CatchErrToInputErr}
	 q ret
}

}
