Include (ALVALIBRARY, ALVAEDFORMS, GENERAL)

Class ALVA.ISY.ISYCiselniky.TEMPLATES.Big Extends %RegisteredObject
{

ClassMethod LoadItems(ByRef in As %String, ByRef out As %String) As %Status
{
	 $$$InitializeMethodEx("ALVAEDFORMS")
	 s sc=$$$OK  
	 try 
	 {
			s action=$g(in("Action"))
			s ActionID=$lg(action,1)   
			#dim items As %ListOfObjects
			s items=##class(%ListOfObjects).%New()    
			
			if (ActionID="ISYZastavkyZastavkaEditObec") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyZastavkaEdit).InitObec(.err,.in,.items) }
			elseif (ActionID="ISYCiselnikySkupinyLinekEdit") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikySkupinyLinekEdit).Init(.err,.in,.items) }
			elseif (ActionID="ISYCiselnikyRozvrhPasemJizdniDobyEdit") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikyRozvrhPasemJizdniDobyEdit).Init(.err,.in,.items) }     
			elseif (ActionID="ISYCiselnikyOblastiLinekEdit") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikyOblastiLinekEdit).Init(.err,.in,.items) }
			elseif (ActionID="LinkyTiskMHDNadpisy") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.LinkyTiskMHDNadpisy).init(.err,.in,.items) }     
			elseif (ActionID="ISYCiselnikySkupinyLicenciEdit") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikySkupinyLicenciEdit).Init(.err,.in,.items) }     
			elseif (ActionID="ISYCiselnikyLicenceEdit") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikyLicenceEdit).Init(.err,.in,.items) }     
			elseif (ActionID="ISYCiselnikyLicencePrilohaEdit") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikyLicencePrilohaEdit).Init(.err,.in,.items) }     
			
			elseif (ActionID="formISYCiselnikyJBNEdit") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikyJBNEdit).Init(.err,.in,.items) }
			
			elseif (ActionID="NegZn") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.NegZn).init(.err,.in,.items) }
			elseif (ActionID="NegZnFiltr") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.NegZnFiltr).init(.err,.in,.items) }
			elseif (ActionID="SkupPrecis") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.SkupPrecis).init(.err,.in,.items) }
			elseif (ActionID="SkupFiltr") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.SkupFiltr).init(.err,.in,.items) }
			
			if (err'="") { ztrap }           
			s out("Status")=$lb($$$BigStateTypeOk,"",0)
			s out("Items")=items 
	 }
	 catch ex 
	 {
			s sc=ex.DisplayString()
			s err=$$$GetStack
			s sc=$$$ERROR($$$GeneralError,err)
	 }
	 k ^||tempALVAEDFORMS(workID)
	 quit sc
}

ClassMethod SaveItems(ByRef in As %String, ByRef out As %String)
{
	 $$$InitializeMethodEx("ALVAEDFORMS")
	 s sc=$$$OK  
	 try 
	 {
			s action=$g(in("Action"))
			s ActionID=$lg(action,1)
			
			if (ActionID="ISYZastavkyZastavkaEditObec") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyZastavkaEdit).SaveObec(.err,.in) }
			elseif (ActionID="ISYCiselnikySkupinyLinekEdit") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikySkupinyLinekEdit).Save(.err,.in,.out) }
			elseif (ActionID="ISYCiselnikyRozvrhPasemJizdniDobyEdit") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikyRozvrhPasemJizdniDobyEdit).Save(.err,.in,.out) }      
			elseif (ActionID="ISYCiselnikyOblastiLinekEdit") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikyOblastiLinekEdit).Save(.err,.in,.out) }
			elseif (ActionID="LinkyTiskMHDNadpisy") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.LinkyTiskMHDNadpisy).save(.err,.in,.out) }
			elseif (ActionID="ISYCiselnikySkupinyLicenciEdit") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikySkupinyLicenciEdit).Save(.err,.in,.out) }
			elseif (ActionID="ISYCiselnikyLicenceEdit") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikyLicenceEdit).Save(.err,.in,.out) }     
			elseif (ActionID="ISYCiselnikyLicencePrilohaEdit") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikyLicencePrilohaEdit).Save(.err,.in,.out) }     
			
			elseif (ActionID="formISYCiselnikyJBNEdit") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikyJBNEdit).Save(.err,.in,.out) }     
			
			elseif (ActionID="NegZn") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.NegZn).save(.err,.in,.out) }     
			elseif (ActionID="NegZnFiltr") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.NegZnFiltr).save(.err,.in,.out) }  
			elseif (ActionID="SkupPrecis") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.SkupPrecis).save(.err,.in,.items) }
			elseif (ActionID="SkupFiltr") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.SkupFiltr).save(.err,.in,.items) }
			
			if (err'="") { ztrap }     
			s out("Status")=$lb($$$BigStateTypeOk,"",0,1)
	 }
	 catch ex 
	 {
			s err=$$$GetStack
			s sc=$$$ERROR($$$GeneralError,err)
	 }
	 k ^||tempALVAEDFORMS(workID)
	 quit sc
}

ClassMethod ValidateItems(ByRef in As %String, ByRef out As %String) As %Status
{
	 $$$InitializeMethodEx("ALVAEDFORMS")
	 s sc=$$$OK  
	 try 
	 {  
			#dim newItems As %ListOfObjects  
			s action=$g(in("Action")) s ActionID=$lg(action,1)
			s newItems=##class(%ListOfObjects).%New()
			s refresh=1
			s cancel=0
			s stt=$$$BigStateTypeOk
			s info=""
			k out 
			
			if (ActionID="ISYZastavkyZastavkaEditObec") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyZastavkaEdit).ValidateObec(.err,.in,.newItems) }  
			elseif (ActionID="ISYCiselnikySkupinyLinekEdit") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikySkupinyLinekEdit).Validate(.err,.in,.newItems) }
			elseif (ActionID="ISYCiselnikyRozvrhPasemJizdniDobyEdit") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikyRozvrhPasemJizdniDobyEdit).Validate(.err,.in,.newItems) }
			elseif (ActionID="ISYCiselnikyOblastiLinekEdit") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikyOblastiLinekEdit).Validate(.err,.in,.newItems) }
			elseif (ActionID="LinkyTiskMHDNadpisy") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.LinkyTiskMHDNadpisy).validate(.err,.in,.newItems) }
			elseif (ActionID="ISYCiselnikySkupinyLicenciEdit") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikySkupinyLicenciEdit).Validate(.err,.in,.newItems) }
			elseif (ActionID="ISYCiselnikyLicenceEdit") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikyLicenceEdit).Validate(.err,.in,.newItems) }
			elseif (ActionID="ISYCiselnikyLicencePrilohaEdit") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikyLicencePrilohaEdit).Validate(.err,.in,.newItems) }
			
			elseif (ActionID="formISYCiselnikyJBNEdit") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.ISYCiselnikyJBNEdit).Validate(.err,.in,.newItems) }
			
			elseif (ActionID="NegZn") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.NegZn).validate(.err,.in,.newItems) }
			elseif (ActionID="NegZnFiltr") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.NegZnFiltr).validate(.err,.in,.newItems) }
			elseif (ActionID="SkupPrecis") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.SkupPrecis).validate(.err,.in,.newItems) }
			elseif (ActionID="SkupFiltr") { d ##class(ALVA.ISY.ISYCiselniky.BigForms.SkupFiltr).validate(.err,.in,.newItems) }
			
			if (err'=""){ztrap}     
			s zobrInfo=1
			s clear=+$g(out("clear"))
			s idPol=$g(out("idPol"))
			s out("Status")=$lb(stt,info,zobrInfo,refresh,cancel,clear)
			s out("Items")=newItems
			s out("Param")=$lb(idPol)
	 }
	 catch ex 
	 {
			s sc=ex.DisplayString()
			s err=$$$GetStack
			s sc=$$$ERROR($$$GeneralError,err)
	 }  
	 k ^||tempALVAEDFORMS(workID)
	 quit sc
}

/*
/// Nacte sablonu
ClassMethod LoadTemplate(ByRef in As %String, ByRef out As %String) As %Status
{
	 $$$InitializeMethodEx("ALVAEDFORMS")
	 s sc=$$$OK
	 
	 try 
	 {
			s IdFa=$g(in("IdFa"))
			s user=$g(in("User"))
			s action=$g(in("Action")) s ActionID=$lg(action,1)
			s actionId=$lg(action,1)
			s itemId=$lg(action,4)
			
			s out("listParam")=$lb($$$FormTypeNone,$$$FormModeNone,"","","")
			s out("listControlParam")=$lb($$$SelectionModeSingle)
						
			if (ActionID="MZDY2VypocetPridatMP") { k out d ##class(ALVA.MZDY2.BigForms.MZDY2VypocetPridatMP).template(.err,.in,.out)  }
			if (ActionID="MZDY2ElektroStravenkyNastaveni") { k out d ##class(ALVA.MZDY2.BigForms.MZDY2ElektroStravenkyNastaveni).template(.err,.in,.out)  }
			if (ActionID="MZDY2VykazPraceNastaveni") { k out d ##class(ALVA.MZDY2.BigForms.MZDY2VykazPraceNastaveni).template(.err,.in,.out)  }
			if (err'="") { ztrap }
						
			s out("Status")=$lb($$$BigStateTypeOk,"",0)
			s out("Param")=$g(out("listParam"))
			s out("Param","control")=$g(out("listControlParam"))
	 } catch ex 
	 {
			s err=$$$GetStack
			s sc=$$$ERROR($$$GeneralError,err)
	 }
	 
	 k ^||tempALVAEDFORMS(workID)
	 quit sc
}
*/
}
