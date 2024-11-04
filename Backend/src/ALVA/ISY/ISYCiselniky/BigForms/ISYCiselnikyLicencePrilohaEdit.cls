Include (ALVALIBRARY, ALVAEDFORMS, ALVAEDREPORTS, GENERAL, ALVAISY, ALVAISY3)

Class ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikyLicencePrilohaEdit Extends %RegisteredObject
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
			k enumTyp
			s enumTyp(1)="Licence"
			s enumTyp(2)="Rozhodnutí"
			#;
			s skupinaId="GROUP",skupinaNazev="Parametry"
			$$$LISTFILL(enumTyp)
			s itemid=7,propsOut("big",$i(cnt))=$$$BGN27(skupinaId,skupinaNazev,itemid,"","Číslo licence",$$$BigItemDataTypeText,"",0,1,1,"","",1,"","","",0,0,"",0,"","","","","","","")
			s itemid=1,propsOut("big",$i(cnt))=$$$BGN27(skupinaId,skupinaNazev,itemid,"","Typ dokumentu",$$$BigItemDataTypeList,"",0,1,1,"",listCis,1,"","","",0,0,"",0,"","","","","","","")
			s itemid=2,propsOut("big",$i(cnt))=$$$BGN27(skupinaId,skupinaNazev,itemid,"","Číslo jednací",$$$BigItemDataTypeText,"",0,1,1,"","",1,"","","",0,0,"",0,"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz","","","","","","")
			s itemid=3,propsOut("big",$i(cnt))=$$$BGN27(skupinaId,skupinaNazev,itemid,"","Datum vydání",$$$BigItemDataTypeDate,"dd.MM.yyyy",1,0,1,"","",1,"","","",0,0,"",0,"","","","","","","")
			s itemid=4,propsOut("big",$i(cnt))=$$$BGN27(skupinaId,skupinaNazev,itemid,"","Příloha",$$$BigItemDataTypeBoolean,"",0,0,1,"","",1,"",1,"",1,0,"",0,"","","","","","","")
			s itemid=5,propsOut("big",$i(cnt))=$$$BGN27(skupinaId,skupinaNazev,itemid,"","Soubor",$$$BigItemDataTypeDialogFile,"",0,0,1,"","",1,"",1,"",1,0,"",0,"","","","","","","")
			s itemid=6,propsOut("big",$i(cnt))=$$$BGN27(skupinaId,skupinaNazev,itemid,"","Poznámka",$$$BigItemDataTypeText,"",0,0,1,"","",1,"","","",0,0,"",0,"","","","","","","")
			#;
			s vetaDta=$lb()
			s dta=$$$CTMPGLBFRM(GUID,"formISYCiselnikyLicenceEdit","bigObec")
			s $li(vetaDta,7)=$lg(dta,3)
			i id'="" {
				 s dta=$g($$$CTMPGLBFRM(GUID,"formISYCiselnikyLicenceEdit","fgSeznam","idx",id))
				 s $li(vetaDta,1)=$lg(dta,1)
				 s $li(vetaDta,2)=$lg(dta,3)
				 s $li(vetaDta,3)=$lg(dta,5)
				 s $li(vetaDta,4)=$lg(dta,4)
				 s $li(vetaDta,5)=$lg(dta,9)
				 s $li(vetaDta,6)=$lg(dta,8)
			}else{
				 s id="NOTHING"
				 s $li(vetaDta,1)=2
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
			#;
			s lic=$lg($$$CTMPGLBFRM(GUID,"formISYCiselnikyLicenceEdit","bigObec"),1)
			s jed=items.GetItem(2).FirstValueData()
			s priloha=items.GetItem(4).FirstValueData()
			s typ=items.GetItem(1).FirstValueData()
			i typ=1 {
				 s items.GetItem(2).AllowEdit=0
				 s items.GetItem(2).Required=0
				 d items.GetItem(2).UpdateStatus($$$BigStateTypeOk,"")
				 s items.GetItem(3).AllowEdit=0
			}
			i typ=2 {
				 s items.GetItem(3).AllowEdit=1
			}
			if formMode=$$$FormModeAdd {
				 i typ=2 {
						s items.GetItem(2).AllowEdit=1
						s items.GetItem(2).Required=1
				 }
				 f itemidkey=1,5,6 {
						s items.GetItem(itemidkey).AllowEdit=1
				 }
				 #;licence jen jedna
				 d items.GetItem(1).UpdateStatus($$$BigStateTypeOk,"")
				 i typ=1,$d($$$CTMPGLBFRM(GUID,"formISYCiselnikyLicenceEdit","fgSeznam","idx",lic_"#")) {
						d items.GetItem(1).UpdateStatus($$$BigStateTypeError,"Příloho typu licence je již zadána")
				 } 
				 #;licence jen jedna
				 i jed'="" d items.GetItem(2).UpdateStatus($$$BigStateTypeOk,"")
				 i typ=2,jed'="",$d($$$CTMPGLBFRM(GUID,"formISYCiselnikyLicenceEdit","fgSeznam","idx",lic_"#"_jed)) {
						d items.GetItem(2).UpdateStatus($$$BigStateTypeError,"Číslo jednací již existuje")
				 } 
			}else{
				 i priloha {
						s items.GetItem(6).AllowEdit=1
				 }else{
						s items.GetItem(5).AllowEdit=1
						s items.GetItem(6).AllowEdit=1
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
			
			s lic=$lg($$$CTMPGLBFRM(GUID,"formISYCiselnikyLicenceEdit","bigObec"),1)
			s jed=$lg(def,2)
			i id="" {
				 s id=lic_"#"_jed
			}
			s dta=$g($$$CTMPGLBFRM(GUID,"formISYCiselnikyLicenceEdit","fgSeznam","idx",id),$lb())
			s $li(dta,1)=$lg(def,1)
			s $li(dta,3)=$lg(def,2)
			s $li(dta,5)=$lg(def,3)
			s $li(dta,4)=$lg(def,4)
			s $li(dta,9)=$lg(def,5)
			s $li(dta,8)=$lg(def,6)
			s $$$CTMPGLBFRM(GUID,"formISYCiselnikyLicenceEdit","fgSeznam","idx",id)=dta
	 }
	 catch (ex) { $$$CatchErrToInputErr}
	 q ret
}

}
