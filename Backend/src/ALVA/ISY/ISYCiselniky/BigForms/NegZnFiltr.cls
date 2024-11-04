Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAEDREPORTS)

Class ALVA.ISY.ISYCiselniky.BigForms.NegZnFiltr Extends %RegisteredObject
{

ClassMethod init(ByRef err As %String, ByRef in As %String, ByRef list As %ListOfObjects) As %String
{
	$$$Init
	
	try 
	{				
		#dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
		#dim value As ALVA.EDFORMS.CONTROLS.BIG.ItemValue
		
		s IdFa=$g(in("IdFa"))
		s dataDB=##class(ALVA.GENERALAPI.DataBase).dataDB(IdFa)
		s sysDB=##class(ALVA.GENERALAPI.DataBase).sysDB()
		s akce=$lg(in("Action"),2)
		s GUID=$g(in("GUID"))
		s user=$g(in("User"))
		s userID=$lg(user,1)
		
		// s panel=$o(in("ParamEx","P",""))
		// if ($g(panel)="") { s err="Není vyplněné [P]" ztrap }
	
		k data m data=^[dataDB]JRR("FiltrNegZn",userID)
		
		s dopravce=$o(data("dopravce",""))
		s linka=$o(data("linka",""))
		s relace=$o(data("relace",""))
		
		s group="G1" s groupName="Filtrovat podle"
		
		s polozka="SKUPINA"
		s itemName="Skupina"
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,polozka,itemName,$$$BigItemDataTypeCodebook,0,1,1,"")
		s item.MultiSelect=1
		s item.DisplayAllValues=1
		s item.CodebookType=$$$CodebookTypeSkupinyLinek
		if $d(data(polozka)) {
			s hod="" f {
				s hod=$o(data(polozka,hod)) q:hod=""
				s popis=$g(data(polozka,hod))
				d item.AddValue($g(hod),$g(popis),"")	
			}
		}
		d list.Insert(item)
		
		/*
		
		s polozka="NZ"
		s itemName="NZ"
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,polozka,itemName,$$$BigItemDataTypeCodebook,0,1,1,"")
		s item.MultiSelect=1
		s item.DisplayAllValues=1
		s item.CodebookType=$$$CodebookTypeNegZn
		if $d(data(polozka)) {
			s hod="" f {
				s hod=$o(data(polozka,hod)) q:hod=""
				s popis=$g(data(polozka,hod))
				d item.AddValue($g(hod),$g(popis),"")	
			}
		}
		d list.Insert(item)
		
		s polozka="ZAM"
		s itemName="ZAM"
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,polozka,itemName,$$$BigItemDataTypeCodebook,0,1,1,"")
		s item.MultiSelect=1
		s item.DisplayAllValues=1
		s item.CodebookType=$$$CodebookTypeZam
		// d item.UpdateParam("FiltrOsobniCisla",$$$BigItemDataTypeText,$lb("61","62","63"))
		d item.UpdateParam("FiktivniRidici",$$$BigItemDataTypeBoolean,$lb("1"))
		d item.UpdateParam("DatumPlatneK",$$$BigItemDataTypeText,$lb("09.08.2024"))
		d list.Insert(item)
		
		s polozka="LINKY"
		s itemName="Linky"
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,polozka,itemName,$$$BigItemDataTypeCodebook,0,1,1,"")
		s item.CodebookType=$$$CodebookTypeISYLinky
		d item.UpdateParam("SKUPINA",$$$BigItemDataTypeText,$lb("3","7"))
				
		d list.Insert(item)
		
		*/
	}
	catch (ex) { $$$CatchErrToInputErr }
	q ret
}

ClassMethod validate(ByRef err As %String, ByRef in As %String, ByRef list As %ListOfObjects, ByRef out As %String) As %String
{
	$$$Init	 
	try 
	{
		#dim item As ALVA.EDFORMS.CONTROLS.BIG.Item

		s IdFa=$g(in("IdFa"))
		s user=$g(in("User"))		
		s action=$g(in("Action"))
		s validationType=$lg($g(in("Param")),1)
		s validatedItem=$lg($g(in("Param")),2)
		s items=$g(in("Items"))
		
		// s panel=$o(in("ParamEx","P",""))
		// if ($g(panel)="") { s err="Není vyplněné [P]" ztrap }	

		s dataDB=##class(ALVA.GENERALAPI.DataBase).dataDB(IdFa)
		s userID=$lg(user,1)	
		s userParametr=$o(in("ParamEx","userParID",""))	
		
		k data k dV s key="" for {
			s item=items.GetNext(.key) q:key=""
			s dV(item.Id)=item.FirstValue().Data
			s dV(item.Id,"I")=item
		}
		
		if (validationType=$$$BigValidationTypeItem)&&((validatedItem="ID")) {
			/*
			s id=$g(dV(validatedItem))
			if $d(^[dataDB]JRL(id)) {
				s v=$g(^[dataDB]JRL(id))
				s popis=$p(v,"~",1)
				k item2
				s item2=dV(validatedItem,"I")
				d item2.UpdateStatus($$$BigStateTypeWarning,"Skupina ["_$g(id)_"] ["_$g(popis)_"] již existuje")
				d list.Insert(item2)
			}
			*/
		}
		else {
			s key="" for {
				s item=items.GetNext(.key) q:key=""
				d item.UpdateStatus($$$BigStateTypeInformation,"Hodnota: "_$g(dV(item.Id)))
				d list.Insert(item)
			}
		}
		
	}
	catch (ex) { $$$CatchErrToInputErr }
	q ret
}

ClassMethod save(ByRef err As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	
	try 
	{
		#dim items As %ListOfObjects
		#dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
		#dim value AS ALVA.EDFORMS.CONTROLS.BIG.ItemValue
		
		s IdFa=$g(in("IdFa"))
		s user=$g(in("User"))
		s GUID=$g(in("GUID"))
		s userID=$lg(user,1)
		s action=$g(in("Action"))
		s items=$g(in("Items"))
		
		// s panel=$o(in("ParamEx","P",""))
		// if ($g(panel)="") { s err="Není vyplněné [P]" ztrap }
		
		s akce=$lg(action,2)
		s dataDB=##class(ALVA.GENERALAPI.DataBase).dataDB(IdFa)
		
		k data s key="" for {
			s item=items.GetNext(.key) q:key=""
			s valKey="" f {
				s valItem=item.Values.GetNext(.valKey) q:valKey=""
				if valItem.Data'="" {
					s data(item.Id,valItem.Data)=valItem.Name
					s dP(item.Id,item.Name,valItem.Data)=valItem.Name
				}
			}
		}
		
		k ^[dataDB]JRR("FiltrNegZn",userID) 
		m ^[dataDB]JRR("FiltrNegZn",userID)=data		
	}
	catch (ex) { $$$CatchErrToInputErr }
	q ret
}

ClassMethod template(ByRef err As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init	 
	try 
	{
		k out
		
		s user=$g(in("User"))
		s userID=$lg(user,1)
		
		s bigPol=$lg(in("Action"),4)
		
		s IdFa=$g(in("IdFa"))
		s dataDB=##class(ALVA.GENERALAPI.DataBase).dataDB(IdFa)
		
		if ($g(bigPol)="dopravce") {
			s idCis="DOP"
			s out("listParam")=$lb($$$FormTypeBil,$$$FormModeSelection,"ISY.ISYJR","Obecny","Dopravce",0,"Dopravce")
			s out("listControlParam")=$lb($$$SelectionModeMulti)
			s out("ParamEx","ID",$g(idCis))=""
			s out("ParamEx","DEL","~")=""
		}
		
		if ($g(bigPol)="provozovna") {
			s idCis="PR"
			s out("listParam")=$lb($$$FormTypeBil,$$$FormModeSelection,"ISY.ISYJR","Obecny","Provozovna",0,"Provozovna")
			s out("listControlParam")=$lb($$$SelectionModeSingle)
			s out("ParamEx","ID",$g(idCis))=""
			s out("ParamEx","DEL","~")=""
		}
		
		if ($g(bigPol)="TL") {
			s idCis="TL"
			s out("listParam")=$lb($$$FormTypeBil,$$$FormModeSelection,"ISY.ISYJR","Obecny","Typy linek",0,"Typy linek")
			s out("listControlParam")=$lb($$$SelectionModeMulti)
			s out("ParamEx","ID",$g(idCis))=""
			s out("ParamEx","DEL","~")=""
		}
		
	}
	catch (ex)  { $$$CatchErrToInputErr }
	q ret
}

}
