Include (ALVALIBRARY, ALVAEDFORMS, ALVAEDREPORTS, GENERAL, ALVAISY, ALVAISY3)

Class ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikyLicenceEdit Extends %RegisteredObject
{

/// init BIG
ClassMethod Init(ByRef err As %String, ByRef in As %String, ByRef items As %ListOfObjects) As %String
{
	 $$$Init
	 try
	 {
			#dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
			#dim value As ALVA.EDFORMS.CONTROLS.BIG.ItemValue
			#;
			s items=##class(%ListOfObjects).%New()
			#;
			s IdFa=$g(in("IdFa"))
			s user=$g(in("User"))
			s action=$g(in("Action"))
			s actionId=$lg(action,1)
			s formMode=$lg(action,2)
			#;s id=$lg(action,3)
			#;oprava DZ modifikace JK
			s id=$lg(action,4)
			s systemDB=##class(ALVA.EDISON.Main).GetSystemDB()
			s dataDB=##class(ALVA.GENERALAPI.DataBase).dataDB(IdFa)
			s usr=$LTS(user,"|")
			s GUID=$g(in("GUID"))
			#;
			k vstup,vystup
			s myerr=$$gCis^JRapi(IdFa,dataDB,19,.vstup,.vystup) i myerr ztrap
			k enumSkupinaLicence
			s key=""
			f {
				 s key=$o(vystup("arr",key),1,nazev) q:key=""
				 s enumSkupinaLicence(key)=nazev
			}
			s enumSkupinaLicence(0)="Neurčeno"
			#; 
			s skupinaId="GROUP",skupinaNazev="Parametry"
			s itemid=1,propsOut("big",$i(cnt))=$$$BGN27(skupinaId,skupinaNazev,itemid,"","ID",$$$BigItemDataTypeText,"",0,0,1,"","",1,"","","",0,0,"",1,"","","","","","","")
			s itemid=2,propsOut("big",$i(cnt))=$$$BGN27(skupinaId,skupinaNazev,itemid,"","Datum poslední aktualizace",$$$BigItemDataTypeDate,"dd.MM.yyyy",0,0,1,"","",1,"","","",0,0,"",0,"","","","","","","")
			s itemid=3,propsOut("big",$i(cnt))=$$$BGN27(skupinaId,skupinaNazev,itemid,"","Číslo licence",$$$BigItemDataTypeText,"",0,0,1,"","",1,"","","",0,0,"",0,"0123456789","","","","","","")
			$$$LISTFILL(enumSkupinaLicence)
			s itemid=4,propsOut("big",$i(cnt))=$$$BGN27(skupinaId,skupinaNazev,itemid,"","Skupina licencí",$$$BigItemDataTypeList,"",1,0,1,"",listCis,1,"","","",0,0,"",0,"","","","","","","")
			s itemid=8,propsOut("big",$i(cnt))=$$$BGN27(skupinaId,skupinaNazev,itemid,"","Číslo jednací",$$$BigItemDataTypeText,"",1,1,1,"","",1,"","","",0,0,"",0,"","","","","","","")
			s itemid=5,propsOut("big",$i(cnt))=$$$BGN27(skupinaId,skupinaNazev,itemid,"","Vydal",$$$BigItemDataTypeText,"",1,0,1,"","",1,"","","",0,0,"",0,"","","","","","","")
			s itemid=6,propsOut("big",$i(cnt))=$$$BGN27(skupinaId,skupinaNazev,itemid,"","Datum vydání",$$$BigItemDataTypeDate,"dd.MM.yyyy",1,0,1,"","",1,"","","",0,0,"",0,"","","","","","","")
			s itemid=7,propsOut("big",$i(cnt))=$$$BGN27(skupinaId,skupinaNazev,itemid,"","Platí do",$$$BigItemDataTypeDate,"dd.MM.yyyy",1,0,1,"","",1,"","","",0,0,"",0,"","","","","","","")
			#;
			s vetaDta=$lb()
			i id'="" {
				 s vetaDta=$$$CTMPGLBFRM(GUID,"formISYCiselnikyLicenceEdit","bigObec")
			}else{
				 s id="NOTHING"
			}
			$$$FILLBIG(propsOut,vetaDta)
	 }
	 catch (ex) { $$$CatchErrToInputErr}
	 q ret
}

/// validate BIG
ClassMethod Validate(ByRef err As %String, ByRef in As %String, ByRef newItems As %ListOfObjects) As %String
{
	 $$$Init  
	 try
	 {   
			#dim items As ALVA.EDFORMS.CONTROLS.BIG.ListOfItems
			#dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
			#dim referenceItem As ALVA.EDFORMS.CONTROLS.BIG.Item
			
			s IdFa=$g(in("IdFa"))
			s user=$g(in("User"))
			s usr=$LTS(user,"|")
			s action=$g(in("Action"))
			s actionId=$lg(action,1)
			s formMode=$lg(action,2)
			#;s id=$lg(action,3)
			#;oprava DZ modifikace JK
			s id=$lg(action,4)
			s validationType=$lg($g(in("Param")),1)
			s validatedItem=$lg($g(in("Param")),2)
			s items=$g(in("Items"))
			s systemDB=##class(ALVA.EDISON.Main).GetSystemDB()
			s dataDB=##class(ALVA.GENERALAPI.DataBase).dataDB(IdFa)
			s usr=$LTS(user,"|")
			s GUID=$g(in("GUID"))
			
			#dim newvalue As ALVA.EDFORMS.CONTROLS.BIG.ItemValue
			s newItems=##class(%ListOfObjects).%New()
		
			s key=""
			for {
				 s item=items.GetNext(.key) q:key=""
				 d newItems.Insert(item)
			}
			s licence=items.GetItem(3).FirstValueData()
			if formMode'=$$$FormModeEdit {
				 s items.GetItem(3).AllowEdit=1
			}else{
				 s items.GetItem(3).AllowEdit=0
			}
			i ($l(licence)<1)!($l(licence)>6)!'licence {
				 d items.GetItem(3).UpdateStatus($$$BigStateTypeError,"Chybné číslo licence")
			}else{
				 d items.GetItem(3).UpdateStatus($$$BigStateTypeOk,"")
			}
			if formMode'=$$$FormModeEdit,licence {
				 k inL,outL
				 s myerr=$$isLic^JRapi(IdFa,dataDB,licence,.inL,.outL) i myerr ztrap
				 i $g(outL) {
						d items.GetItem(3).UpdateStatus($$$BigStateTypeError,"Licence již existuje")
				 }
				 
			}     
	 }
	 catch (ex) { $$$CatchErrToInputErr}
	 q ret
}

/// save BIG
ClassMethod Save(ByRef err As %String, ByRef in As %String, ByRef out As %ListOfObjects) As %String
{
	 $$$Init  
	 try
	 {   
			#dim items As %ListOfObjects
			#dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
			#;
			s D=$c(0)
			s IdFa=$g(in("IdFa"))
			s user=$g(in("User"))
			s action=$g(in("Action"))
			s items=$g(in("Items"))
			s actionId=$lg(action,1)
			s formMode=$lg(action,2)
			#;s id=$lg(action,3)
			#;oprava DZ modifikace JK
			s id=$lg(action,4)
			s temporaryIndex=$o(in("ParamEx","TemporaryIndex",""))
			s typObjektu=$o(in("ParamEx","TypObjektu",""))
			s systemDB=##class(ALVA.EDISON.Main).GetSystemDB()
			s dataDB=##class(ALVA.GENERALAPI.DataBase).dataDB(IdFa)
			s usr=$LTS(user,"|")
			s GUID=$g(in("GUID"))
			#;
			$$$FILLSYS(sys,IdFa,user)
			$$$FILLDEF(def,",")
			s $$$CTMPGLBFRM(GUID,"formISYCiselnikyLicenceEdit","bigObec")=def
	 }
	 catch (ex) { $$$CatchErrToInputErr}
	 q ret
}

}
