Include (ALVALIBRARY, ALVAEDFORMS, ALVAEDREPORTS, GENERAL, ALVAISY, ALVAISY3)

Class ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikySkupinyLicenciEdit Extends %RegisteredObject
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
			s skupinaId="GROUP",skupinaNazev="Parametry"
			s itemid=1,propsOut("big",$i(cnt))=$$$BGN27(skupinaId,skupinaNazev,itemid,"","Id",$$$BigItemDataTypeInteger,"0",0,0,1,"","",1,"","","",0,0,"",0,"","","","","","","")
			s itemid=2,propsOut("big",$i(cnt))=$$$BGN27(skupinaId,skupinaNazev,itemid,"","Název",$$$BigItemDataTypeText,"",1,1,1,"","",1,"","","",0,0,"",0,"","","","","","","")
			#;
			s vetaDta=$lb()
			i id'="" {
				 k aIn,aOut
				 s myerr=$$gCisItm^JRapi(IdFa,dataDB,19,id,.aIn,.aOut) i myerr ztrap
				 s $li(vetaDta,1)=id
				 s $li(vetaDta,2)=$g(aOut("arr",id))
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
			
			#;nic
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
			s itm1Id=$lg(def,1)
			s itm2Nazev=$lg(def,2)
			i itm1Id="" {
				 f i=1:1 {
						k aIn,aOut
						s myerr=$$isCisItm^JRapi(IdFa,dataDB,19,i,.aIn,.aOut) i myerr ztrap
						i 'aOut {
							 s itm1Id=i q
						}
				 }
			}
			k aIn,aOut
			s myerr=$$sCisItm^JRapi(IdFa,dataDB,19,itm1Id,itm2Nazev,.aIn,.aOut,.usr) i myerr ztrap
	 }
	 catch (ex) { $$$CatchErrToInputErr}
	 q ret
}

}
