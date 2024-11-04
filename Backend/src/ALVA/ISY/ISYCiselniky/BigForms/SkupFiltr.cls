Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAEDREPORTS)

Class ALVA.ISY.ISYCiselniky.BigForms.SkupFiltr Extends %RegisteredObject
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
		s akce=$lg(in("Action"),2)
		s GUID=$g(in("GUID"))
		s user=$g(in("User"))
		s userID=$lg(user,1)
		
		k data m data=^[dataDB]JRR("SkupFiltr",userID)
		
		s group="G1" s groupName="Filtrovat podle"
		
		s polozka="SKUPINA"
		s itemName="Číslo (ID)"
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,polozka,itemName,$$$BigItemDataTypeInteger,0,1,1,"")				
		d item.AddValue($o(data(polozka,"")),"","")	
		d list.Insert(item)
		
		s polozka="NAZEV"
		s itemName="Název"
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,polozka,itemName,$$$BigItemDataTypeText,0,1,1,"")				
		d item.AddValue($o(data(polozka,"")),"","")	
		d list.Insert(item)
		
		s polozka="TYP"
		s itemName="Typ"
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,polozka,itemName,$$$BigItemDataTypeList,0,1,1,"")				
		s id="" f {
			s id=$o(^[dataDB]JRSET("Definice","SKSKU",id)) q:id=""
			s v=$g(^[dataDB]JRSET("Definice","SKSKU",id))
			s kod=$p(v,"~",2)
			s naz=$p(v,"~",1)
			d item.AddListItem(id_" | "_$g(naz),id)
		}
		d item.AddListItem("","")
		d item.AddValue($o(data(polozka,"")),"","")
		d list.Insert(item)
		
		s group="G2" s groupName="Platnost"
		
		s polozka="DATUM_OD"
		s itemName="Datum od"
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,polozka,itemName,$$$BigItemDataTypeDate,0,1,1,"")				
		d item.AddValue($o(data(polozka,"")),"","")	
		d list.Insert(item)
		
		s polozka="DATUM_DO"
		s itemName="Datum do"
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,polozka,itemName,$$$BigItemDataTypeDate,0,1,1,"")				
		d item.AddValue($o(data(polozka,"")),"","")	
		d list.Insert(item)
		
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
		
		if (validationType=$$$BigValidationTypeItem)&&((validatedItem="SKUPINA_ID_NEW")) {
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
		
		s dataDB=##class(ALVA.GENERALAPI.DataBase).dataDB(IdFa)
		
		k param
		k data s key="" for {
			s item=items.GetNext(.key) q:key=""
			s valKey="" f {
				s valItem=item.Values.GetNext(.valKey) q:valKey=""
				if valItem.Data'="" {
					s data(item.Id,valItem.Data)=valItem.Name
				}
			}
		}		
		
		k ^[dataDB]JRR("SkupFiltr",userID)
		m ^[dataDB]JRR("SkupFiltr",userID)=data
	}
	catch (ex) { $$$CatchErrToInputErr }
	q ret
}

}
