Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAEDREPORTS)

Class ALVA.ISY.ISYCiselniky.BigForms.SkupPrecis Extends %RegisteredObject
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
		
		s skupOld=$o(in("ParamEx","SKUP",""))
		
		s group="G1" s groupName="Nastavení"
		
		s polozka="SKUPINA_ID_OLD"
		s itemName="Původní číslo skupiny"
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,polozka,itemName,$$$BigItemDataTypeInteger,1,0,1,"")
		s n=$p($g(^[dataDB]JRL(skupOld)),"~",1)
		d item.UpdateStatus($$$BigStateTypeInformation,n)
		d item.AddValue($g(skupOld),"","")
		
		d list.Insert(item)
		
		s polozka="SKUPINA_ID_NEW"
		s itemName="Nové číslo skupiny"
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,polozka,itemName,$$$BigItemDataTypeInteger,1,1,1,"")
		d item.AddValue("","","")
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
		
		// s panel=$o(in("ParamEx","P",""))
		// if ($g(panel)="") { s err="Není vyplněné [P]" ztrap }	

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
			s id=$g(dV(validatedItem))
			if $d(^[dataDB]JRL(id)) {
				s v=$g(^[dataDB]JRL(id))
				s popis=$p(v,"~",1)
				k item2
				s item2=dV(validatedItem,"I")
				d item2.UpdateStatus($$$BigStateTypeWarning,"Skupina ["_$g(id)_"] ["_$g(popis)_"] již existuje")
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
		
		// s panel=$o(in("ParamEx","P",""))
		// if ($g(panel)="") { s err="Není vyplněné [P]" ztrap }
		
		s dataDB=##class(ALVA.GENERALAPI.DataBase).dataDB(IdFa)
		
		k param
		k data s key="" for {
			s item=items.GetNext(.key) q:key=""
			s valKey="" f {
				s valItem=item.Values.GetNext(.valKey) q:valKey=""
				if valItem.Data'="" {
					// s data(item.Id,valItem.Data)=valItem.Name
					s data(item.Id)=valItem.Data
					s param($i(i))=item.Id_"~"_valItem.Data
				}
			}
		}		
		
		// SKUPINA_ID_OLD
		// SKUPINA_ID_NEW
		
		k sys m sys=^||ML("SYS") 
		
		m ^||ML("IN")=param
		d ##class(ALVA.JRMAIN.Skupiny).PrecislovatSkupinu(.sys,.in,.out)
		
		k data m data=^||ML("OUT") k ^||ML("OUT")
		
		// s ^||ML("OUT",$i(igl))="PRECISLOVANO~"_stt
		// s ^||ML("OUT",$i(igl))="SKUPINA_ID~"_0_"-"_idtyp_"-"_backsku 	
		// s ^||ML("OUT",$i(igl))="MSG~"_msg
		
		s r="" f {
			s r=$o(data(r)) q:r=""
			s v=$g(data(r))
			s p=$p(v,"~",1)
			if $g(p)="PRECISLOVANO" {
				s precislovano=+$p(v,"~",2)
				if precislovano=1 { s msg($i(m))="Přečíslování proběhlo" }
				else { s msg($i(m))="Přečíslování neproběhlo úspěšně" }
			}
			if $g(p)="SKUPINA_ID" {
				s id=$p(v,"~",2)
				// s msg($i(m))="Info: "_id
			}
			if $g(p)="MSG" {
				s msg($i(m))=$p(v,"~",2)
			}
		}
		
		k ^[dataDB]JRR("SkupPrecis",userID)
		m ^[dataDB]JRR("SkupPrecis",userID)=msg
	}
	catch (ex) { $$$CatchErrToInputErr }
	q ret
}

ClassMethod getReport(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	// ALVA.ISY.ISYCiselniky.BigForms.SkupPrecis.getReport
	
	$$$Init
	try 
	{
		$$$FillParams
		$$$InputParams
		
		s dataDB=##class(ALVA.GENERALAPI.DataBase).dataDB(IdFa)
		
		k data m data=^[dataDB]JRR("SkupPrecis",userID)
		s id="" f {
			s id=$o(data(id)) q:id=""
			s output($i(i))="REPORT"_del_$g(data(id)) 
		}
		
		m ^||ML("OUT")=output
	}
	catch (ex) { $$$CatchErrRest }
	q ret
}

}
