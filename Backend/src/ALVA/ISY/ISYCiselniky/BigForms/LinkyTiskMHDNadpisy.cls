Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYCiselniky.BigForms.LinkyTiskMHDNadpisy Extends %RegisteredObject
{

ClassMethod gDB(ByRef db As %String) As %String
{
	k db
	
	s gr=1 s grT="Rozvržení 1"
	s db($i(i))=$lb(gr,grT,"R1_SMO1","Pracovní dny  (SMO1)")
	s db($i(i))=$lb(gr,grT,"R1_SMO2","Soboty (SMO2)")
	s db($i(i))=$lb(gr,grT,"R1_SMO3","Neděle, svátky (SMO3)")
	
	s gr=2 s grT="Rozvržení 2"
	s db($i(i))=$lb(gr,grT,"R2_SMO1","Pracovní dny mimo prázdniny (SMO1)")
	s db($i(i))=$lb(gr,grT,"R2_SMO2","Pracovní dny o prázdninách (SMO2)")
	s db($i(i))=$lb(gr,grT,"R2_SMO3","Soboty, neděle, svátky (SMO3)")
	
	s gr=3 s grT="Rozvržení 3"
	s db($i(i))=$lb(gr,grT,"R3_SMO1","Pracovní dny (SMO1)")
	s db($i(i))=$lb(gr,grT,"R3_SMO2","Soboty, neděle, svátky (SMO2)")
	
	s gr=4 s grT="Rozvržení 4"
	s db($i(i))=$lb(gr,grT,"R4_SMO1","Pracovní dny mimo prázdniny (SMO1) ")
	s db($i(i))=$lb(gr,grT,"R4_SMO2","Pracovní dny o prázdninách (SMO2)")
	s db($i(i))=$lb(gr,grT,"R4_SMO3","Soboty (SMO3)")
	s db($i(i))=$lb(gr,grT,"R4_SMO4","Neděle, svátky (SMO4)")
}

ClassMethod init(ByRef err As %String, ByRef in As %String, ByRef list As %ListOfObjects) As %String
{
	$$$Init
	
	try 
	{				
		#dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
		#dim value As ALVA.EDFORMS.CONTROLS.BIG.ItemValue
		
		s IdFa=$g(in("IdFa"))
		s dataDB=##class(ALVA.GENERALAPI.DataBase).dataDB(IdFa)
		s akce=$lg(in("Action"),2)
		s GUID=$g(in("GUID"))
		s user=$g(in("User"))
		s userID=$lg(user,1)
		
		s kod=$o(in("ParamEx","KOD",""))
		
		if $g(kod)'="" {
			k data m data=^[dataDB]JRSET("LinkyTiskMHDNadpisy",kod)
		}
		
		s group="0"
		s groupName="Základní údaje"
		
		s polozka="KOD"
		s itemName="Kód"
		s aE=1 if $g(kod)'="" { s aE=0 }
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,polozka,itemName,$$$BigItemDataTypeText,1,aE,1,"")
		d item.AddValue($g(data(polozka)),"","")
		
		s polozka="POP"
		s itemName="Popis"
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,polozka,itemName,$$$BigItemDataTypeText,0,1,1,"")
		d item.AddValue($g(data(polozka)),"","")
		d list.Insert(item)
		
		//
		
		k db d ..gDB(.db)
		
		s r="" f {
			s r=$o(db(r)) q:r=""
			s v=$g(db(r))
			
			s group=$lg(v,1)
			s groupName=$lg(v,2)
			s polozka=$lg(v,3)
			s itemName=$lg(v,4)
			
			s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,polozka,itemName,$$$BigItemDataTypeText,0,1,1,"")
			s item.Selectable=1
			d item.AddValue($g(data(polozka)),"","")
			d list.Insert(item)
		}
				
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

		s refresh=1
		s cancel=0
		s dataDB=##class(ALVA.GENERALAPI.DataBase).dataDB(IdFa)
		s userID=$lg(user,1)	
		s userParametr=$o(in("ParamEx","userParID",""))	
		
		k data k dV s key="" for {
			s item=items.GetNext(.key) q:key=""
			s dV(item.Id)=item.FirstValue().Data
			s dV(item.Id,"I")=item
		}
		
		if (validationType=$$$BigValidationTypeItem)&&((validatedItem="KOD")) {
			s kod=$g(dV(validatedItem))
			if $d(^[dataDB]JRSET("LinkyTiskMHDNadpisy",kod)) {
				k item2
				s item2=dV(validatedItem,"I")
				d item2.UpdateStatus($$$BigStateTypeError,"Zadejte jiný kód, kód ["_$g(kod)_"] již existuje")
				d list.Insert(item2)
			}
		}
		else {
			s key="" for {
				s item=items.GetNext(.key) q:key=""
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
		
		s kod=$o(in("ParamEx","KOD",""))		
		
		s dataDB=##class(ALVA.GENERALAPI.DataBase).dataDB(IdFa)
		
		k param
		k data s key="" for {
			s item=items.GetNext(.key) q:key=""
			s valKey="" f {
				s valItem=item.Values.GetNext(.valKey) q:valKey=""
				if valItem.Data'="" {
					// s data(item.Id,valItem.Data)=valItem.Name
					s data(item.Id)=valItem.Data
				}
			}
		}
		
		if $g(kod)="" { s kod=$g(data("KOD")) }		
		
		if $g(kod)'="" {
			k ^[dataDB]JRSET("LinkyTiskMHDNadpisy",kod)
			m ^[dataDB]JRSET("LinkyTiskMHDNadpisy",kod)=data
		}
	}
	catch (ex) { $$$CatchErrToInputErr }
	q ret
}

}
