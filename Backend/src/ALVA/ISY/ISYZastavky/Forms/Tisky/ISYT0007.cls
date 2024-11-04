Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAEDREPORTS, ALVAISY)

Class ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0007 Extends %RegisteredObject
{

ClassMethod Print(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{
      $$$FillParams
		// vstup nacitame z globalu formulare ZastavkyOznaceniList
		s lbItems=""
		
      	s dGlb=$name($$$CTMPGLBFRM(GUID,$$$isyFormZastavkyOznaceniList,"DTA"))
     
      	s zastavkaId="" f {
	      	k valDTA s zastavkaId =$o(@dGlb@("DTA","zastavky",zastavkaId),1,valDTA) i zastavkaId="" q
	      	s pocet=$g(@dGlb@("DTA","pocetTisku",zastavkaId))
			s $list(lbItems,*+1) = zastavkaId_"|"_pocet
      	}

		// load
		k input,output s input("classname")=$classname()
      	s input("login")=loginName
	   	s sc=##class(ALVA.ISY.ISYZastavky.Utils).BigDataLoad(.sys,.input,.output) //$$$ThrowStatus(sc)
	   	
		k bigData m bigData=output
		// data
      	s sablona = ""
		s bigItem="Sablona" if $d(bigData(bigItem)) s sablona=bigData(bigItem).GetAt(1).Data
		// vystup
		s data=$lts(lbItems,"#")
		s popis="Označení zastávek"
		s ^||ML("OUT",$i(^||ML("OUT")))=sablona_"~"_data_"~"_popis
	}
	catch (ex) 
	{
		$$$CatchErrRest
	}
	q ret
}

/// init BIG
ClassMethod Init(ByRef err As %String, ByRef in As %String, ByRef list As %ListOfObjects) As %String
{
   $$$Init
	try
	{
		$$$FillSysParamsBig(in)
		#dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
		// load
		k input,output s input("classname")=$classname(),input("login")=loginName
		d ##class(ALVA.ISY.ISYZastavky.Utils).BigDataLoad(.sys,.input,.output) //$$$THROWERROR(sc,err)
		k bigData m bigData=output
		// ciselniky
		k ^||ISYZastavkyCisInput,^||ISYZastavkyCisOutput
		s ^||ISYZastavkyCisInput("Local","Sablony")=$lb($lb(),$$$YES,"",0) s ^||ISYZastavkyCisInput("Local","Sablony","input","id")="OZNACENI_ZASTAVEK" //"ISYZASTAVKY" //
		d ##class(ALVA.ISY.ISYZastavky.Utils).GetCiselniky(.sys,$name(^||ISYZastavkyCisInput),$name(^||ISYZastavkyCisOutput)) //$$$THROWERROR(sc,err)
		// ========================================================================================
		s bigGroup="G001" s bigGroupName="Filtr"
		// ========================================================================================
		s bigItem="Sablona" s bigItemName="Šablona" s bigDataType=$$$BigItemDataTypeList s bigRequired=1 s bigAllowEdit=1 s bigValidation=0 s bigFormat=""
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,bigFormat)
		d ##class(ALVA.ISY.ISYZastavky.Utils).BigAddListItems(.item,$name(^||ISYZastavkyCisOutput("Local","Sablony")))
		d item.AddValue("","","") if $d(bigData(bigItem)) s item.Values=bigData(bigItem)
		d list.Insert(item)
		// ========================================================================================
	}
	catch (ex) {
		$$$CatchErrRest
	}
	q ret
}

/// validate BIG
ClassMethod Validate(ByRef err As %String, ByRef in As %String, ByRef list As %ListOfObjects) As %String
{
   $$$Init
	try
	{
		$$$FillSysParamsBig(in)
		#dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
		#dim itemWork As ALVA.EDFORMS.CONTROLS.BIG.Item
		#dim items As %ListOfObjects
		// init
		s validationType=$lg($g(in("Param")),1)
		s validatedItem=$lg($g(in("Param")),2)
		s items=$g(in("Items"))
      	// validate
		if (validationType=1) {
			s key=""
			for {
				s item=items.GetNext(.key) if key="" q
				if (item.Id=validatedItem) {
					s stt=$$$BigStateTypeOk s info=""
					// ========================================================================================
					// Filtr
					// ========================================================================================

					// ========================================================================================
					d item.UpdateStatus(stt,info)
					d list.Insert(item)
				}
			}
		}
	}
	catch (ex) {
		$$$CatchErrRest
	}
	q ret
}

ClassMethod Save(ByRef err As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try
	{
		$$$FillSysParamsBig(in)
		#dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
		#dim items As %ListOfObjects
		#dim value As ALVA.EDFORMS.CONTROLS.BIG.ItemValue
		// init
		s items=$g(in("Items"))
		// save
		k input,output s input("classname")=$classname(),input("login")=loginName,input("items")=items
		s sc=##class(ALVA.ISY.ISYZastavky.Utils).BigDataSave(.sys,.input,.output) //$$$THROWERROR(sc,err)
	}
	catch (ex) {
		$$$CatchErrRest
	}
	q ret
}

}
