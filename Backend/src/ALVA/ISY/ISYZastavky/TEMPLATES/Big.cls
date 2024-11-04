Include (ALVALIBRARY, ALVAEDFORMS, GENERAL)

Class ALVA.ISY.ISYZastavky.TEMPLATES.Big Extends %RegisteredObject
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
		// Okno 	formISYZastavkyZastavkaEdit
		if (ActionID="ISYZastavkyZastavkaEditObec") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyZastavkaEdit).InitObec(.err,.in,.items) }
		//
		elseif (ActionID="ISYZastavkyZastavkaEditAtrib") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyZastavkaEdit).InitAtrib(.err,.in,.items) }
		//
		elseif (ActionID="ISYZastavkyZastavkaEditOdbav") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyZastavkaEdit).InitOdbav(.err,.in,.items) }
		// Okno 	ISYZastavkyZastavkaOznacnik (adaptor)
		elseif (ActionID="ISYZastavkyZastavkaOznacnik") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyZastavkaOznacnik).Init(.err,.in,.items) }
		// Okno formISYZastavkyVzdalenostEdit
		elseif (ActionID="ISYZastavkyVzdalenostiEdit") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyVzdalenostiEdit).Init(.err,.in,.items) }
		// Okno formISYZastavkyVzdalenostUsekEdit
		elseif (ActionID="ISYZastavkyVzdalenostUsekEdit") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyVzdalenostUsekEdit).Init(.err,.in,.items) }
		// Okno 	ISYZastavkyVzdalenostUsekJizdniDoba (adaptor)
		elseif (ActionID="ISYZastavkyVzdalenostUsekJizdniDoba") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyVzdalenostUsekJizdniDoba).Init(.err,.in,.items) }
		// Okno 	ISYZastavkyVzdalenostiList (filtr)
		elseif (ActionID="FiltrImportDatZJR") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyVzdalenostiLisFiltrImportDatZJR).Init(.err,.in,.items) }
		// Okno 	ISYZastavkyVzdalenostiList (filtr)
		elseif (ActionID="AktualizaceVzdUsekuDleMap") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyVzdalenostiListFiltrAktVzdUsekMapy).Init(.err,.in,.items) }
		// Okno 	ISYZastavkyHromadneUpravy (adaptor)
		elseif (ActionID="ISYZastavkyHromadneUpravy") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyHromadneUpravy).Init(.err,.in,.items) }
		//
		elseif (ActionID="ISYZastavkyEditHistorie") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyZastavkaEdit).InitHistorie(.err,.in,.items) }
		//
		elseif (ActionID="formISYZastavkyOznaceniList.ISYT0007") { d ##class(ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0007).Init(.err,.in,.items) }
		//  Okno 	HromadnePrecislovaniZastavek
		elseif (ActionID="ISYZastavkyHromadnePrecislovaniZastavek") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyHromadnePrecislovaniZastavek).Init(.err,.in,.items) }

		//
		if (err'="") {s err = err_". Chyba v :"_ActionID ztrap }				
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

/// Ulozi polozky
ClassMethod SaveItems(ByRef in As %String, ByRef out As %String)
{
	$$$InitializeMethodEx("ALVAEDFORMS")
	s sc=$$$OK	
	try 
	{
		s action=$g(in("Action"))
		
		s ActionID=$lg(action,1)
		
		// Okno 	formISYZastavkyZastavkaEdit
		if (ActionID="ISYZastavkyZastavkaEditObec") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyZastavkaEdit).SaveObec(.err,.in) }
		//
		elseif (ActionID="ISYZastavkyZastavkaEditAtrib") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyZastavkaEdit).SaveAtrib(.err,.in,.out) }
		//
		elseif (ActionID="ISYZastavkyZastavkaEditOdbav") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyZastavkaEdit).SaveOdbav(.err,.in,.out) }
		// Okno 	ISYZastavkyZastavkaOznacnik (adaptor)
		elseif (ActionID="ISYZastavkyZastavkaOznacnik") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyZastavkaOznacnik).Save(.err,.in,.out) }
		// Okno formISYZastavkyVzdalenostEdit
		elseif (ActionID="ISYZastavkyVzdalenostiEdit") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyVzdalenostiEdit).Save(.err,.in,.out) }
		// Okno formISYZastavkyVzdalenostUsekEdit
		elseif (ActionID="ISYZastavkyVzdalenostUsekEdit") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyVzdalenostUsekEdit).Save(.err,.in,.out) }
		// Okno 	ISYZastavkyVzdalenostUsekJizdniDoba (adaptor)
		elseif (ActionID="ISYZastavkyVzdalenostUsekJizdniDoba") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyVzdalenostUsekJizdniDoba).Save(.err,.in,.out) }
		// Okno 	ISYZastavkyVzdalenostiList (filtr)
		elseif (ActionID="FiltrImportDatZJR") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyVzdalenostiLisFiltrImportDatZJR).Save(.err,.in,.out) }
		// Okno 	ISYZastavkyVzdalenostiList (filtr)
		elseif (ActionID="AktualizaceVzdUsekuDleMap") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyVzdalenostiListFiltrAktVzdUsekMapy).Save(.err,.in,.out) }
		// Okno 	ISYZastavkyHromadneUpravy (adaptor)
		elseif (ActionID="ISYZastavkyHromadneUpravy") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyHromadneUpravy).Save(.err,.in,.out) }		
		//
		elseif (ActionID="ISYZastavkyEditHistorie") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyZastavkaEdit).SaveHistorie(.err,.in,.out) }
		//
		elseif (ActionID="formISYZastavkyOznaceniList.ISYT0007") { d ##class(ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0007).Save(.err,.in,.out) }
		//
		elseif (ActionID="ISYZastavkyHromadnePrecislovaniZastavek") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyHromadnePrecislovaniZastavek).Save(.err,.in,.out) }
		//  Okno 	HromadnePrecislovaniZastavek
		if (err'="") {s err = err_". Chyba v :"_ActionID  ztrap }		
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

/// Overi polozky
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
		// Okno 	formISYZastavkyZastavkaEdit
		if (ActionID="ISYZastavkyZastavkaEditObec") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyZastavkaEdit).ValidateObec(.err,.in,.newItems) }	
		//
		elseif (ActionID="ISYZastavkyZastavkaEditAtrib") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyZastavkaEdit).ValidateAtrib(.err,.in,.newItems) }
		//
		elseif (ActionID="ISYZastavkyZastavkaEditOdbav") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyZastavkaEdit).ValidateOdbav(.err,.in,.newItems) }	
		// Okno 	ISYZastavkyZastavkaOznacnik (adaptor)
		elseif (ActionID="ISYZastavkyZastavkaOznacnik") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyZastavkaOznacnik).Validate(.err,.in,.newItems) }	
		// Okno formISYZastavkyVzdalenostEdit
		elseif (ActionID="ISYZastavkyVzdalenostiEdit") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyVzdalenostiEdit).Validate(.err,.in,.newItems) }	
		// Okno formISYZastavkyVzdalenostUsekEdit
		elseif (ActionID="ISYZastavkyVzdalenostUsekEdit") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyVzdalenostUsekEdit).Validate(.err,.in,.newItems) }	
		// Okno 	ISYZastavkyVzdalenostUsekJizdniDoba (adaptor)
		elseif (ActionID="ISYZastavkyVzdalenostUsekJizdniDoba") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyVzdalenostUsekJizdniDoba).Validate(.err,.in,.newItems) }	
		// Okno 	ISYZastavkyVzdalenostiList (filtr)
		elseif (ActionID="FiltrImportDatZJR") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyVzdalenostiLisFiltrImportDatZJR).Validate(.err,.in,.newItems) }
		// Okno 	ISYZastavkyVzdalenostiList (filtr)
		elseif (ActionID="AktualizaceVzdUsekuDleMap") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyVzdalenostiListFiltrAktVzdUsekMapy).Validate(.err,.in,.newItems) }
		// Okno 	ISYZastavkyHromadneUpravy (adaptor)
		elseif (ActionID="ISYZastavkyHromadneUpravy") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyHromadneUpravy).Validate(.err,.in,.newItems) }		
		//
		elseif (ActionID="ISYZastavkyEditHistorie") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyZastavkaEdit).ValidateHistorie(.err,.in,.newItems) }
		//
		elseif (ActionID="formISYZastavkyOznaceniList.ISYT0007") { d ##class(ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0007).Validate(.err,.in,.newItems) }
		// Okno 	HromadnePrecislovaniZastavek
		elseif (ActionID="ISYZastavkyHromadnePrecislovaniZastavek") { d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyHromadnePrecislovaniZastavek).Validate(.err,.in,.newItems) }
		//
		if (err'=""){s err = err_". Chyba v :"_ActionID ztrap}		
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
