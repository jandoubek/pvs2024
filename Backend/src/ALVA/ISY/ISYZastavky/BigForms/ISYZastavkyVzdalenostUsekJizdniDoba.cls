Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyVzdalenostUsekJizdniDoba Extends %RegisteredObject
{

/// init BIG
ClassMethod Init(ByRef err As %String, ByRef in As %String, ByRef list As %ListOfObjects) As %String
{

   $$$Init
   try
   {
	   //systemove promenne
	   $$$FillSysParamsBig(in)
	   s actionId=$lg(in("Action"),2) s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
	   //
	   #dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
      #dim value As ALVA.EDFORMS.CONTROLS.BIG.ItemValue     
  	  //
  	  /*
      s userParametr = $o(in("ParamEx","ID",""))
      s listId = $lfs(userParametr,"|")
      s agd = $lg(listId,1)
      s idp = $lg(listId,2)
      s userParametr = $o(in("ParamEx","Edit",""))
      s listId = $lfs(userParametr,"|")
      s email = $lg(listId,4)
      */
      s hrlOd=$o(in("ParamEx","IDEditPol",""))
      s valDta="" s vzdalenostPresna="" s vzdalenostTarifni="" s zakladniDobaJizdy="" s datumOd=""
      i hrlOd {
	      s datumOd=##class(ALVA.GENERALAPI.Date).horToDate(hrlOd)
	      s valDta=$g($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA","vzdalenostDoba","DTA",hrlOd))
		   s vzdalenostPresna=$lg(valDta,1)
		   s zakladniDobaJizdy=$lg(valDta,2)
		   s vzdalenostTarifni=$lg(valDta,3)
      }
      //udaj neni, zkusim prednastavit podle map
      else {
	      i ##class(ALWA.MAPY.API.Routing).Available() {
		      s valDta=$g($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA"))
         	  s zastavkaOdId=$lg(valDta,1)
         	  s oznacnikOdId=$lg(valDta,2)
         	  s zastavkaDoId=$lg(valDta,3)
	          s oznacnikDoId=$lg(valDta,4)
     	      s vzdalenostPresna = $lg(valDta,5)
         	  s zakladniDobaJizdy = $lg(valDta,6)
         	  i ((vzdalenostPresna="")||(zakladniDobaJizdy=""))&&(zastavkaOdId'="")&&(zastavkaDoId'="") { 
            	  k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).vzdalenostPodleGPSMapy(.sys,$lb(zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId),.arrDta)
	          	  s vzdalenostPresna=$lg($g(arrDta("DTA")),1)
            	  s zakladniDobaJizdy=$lg($g(arrDta("DTA")),2)
         	  }
		  	s vzdalenostTarifni=(((vzdalenostPresna/1000)+0.999)\1)*1000
	      }
      }
      // prevod jednotek m -> km
      s vzdalenostPresna=vzdalenostPresna/1000
      s vzdalenostTarifni=vzdalenostTarifni/1000
      //
      s bigGroup="G1" s bigGroupName="Obecné"
      // datumOd 
      s bigItem="datumOd" s bigItemName = "Datum od" s bigDataType = $$$BigItemDataTypeDate
      s bigRequired=1 s bigAllowEdit=1 s bigValidation=1
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue(datumOd,"","")
      d list.Insert(item)
      // vzdalenost presna
      s bigItem="vzdalenostPresna" s bigItemName="Přesná vzdálenost [Km]" s bigDataType = $$$BigItemDataTypeDecimal
      s bigRequired=1 s bigAllowEdit=1 s bigValidation=1 s format="### ##0.###"
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,format)
      d item.AddValue(vzdalenostPresna,"","")
      d list.Insert(item)
      // vzdalenost tarifni
      s bigItem="vzdalenostTarifni" s bigItemName="Tarifní vzdálenost [Km]" s bigDataType = $$$BigItemDataTypeInteger
      s bigRequired=1 s bigAllowEdit=1 s bigValidation=1
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue((vzdalenostTarifni),"","")
      d list.Insert(item)
      // zakladniDobaJizdy
      s bigItem="zakladniDobaJizdy" s bigItemName="Základní doba jízdy [min]" s bigDataType = $$$BigItemDataTypeInteger
      s bigRequired=1 s bigAllowEdit=1 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue(zakladniDobaJizdy,"","")
      d list.Insert(item)
      s bigGroup="G2" s bigGroupName="Doba jízdy v pásmu"
      k arrCisCasovaPasmaDobaJizdy d ##class(ALVA.ISY.ISYCiselniky.API.CasovaPasmaJizdniDoby).seznam(.sys,.arrCisCasovaPasmaDobaJizdy)
      s pasmoJizdniDobyId="" f {
	      s valDta="" s pasmoJizdniDobyId=$o(arrCisCasovaPasmaDobaJizdy("DTA",pasmoJizdniDobyId),1,valDta) i pasmoJizdniDobyId="" q
	      s bigItem="pasmoJizdniDoba|"_pasmoJizdniDobyId s bigItemName=pasmoJizdniDobyId_"/"_$lg(valDta,1)_" [min]" s bigDataType = $$$BigItemDataTypeInteger
	      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      	  s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      	  s dobaJizdy="" i hrlOd { s dobaJizdy=$lg($g($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA","vzdalenostDoba","DTA",hrlOd,"pasma","DTA",pasmoJizdniDobyId)),1) }
      	  d item.AddValue(dobaJizdy	,"","")
      	  d list.Insert(item)
      }
   }
    catch (ex)
    {
       $$$CatchErrToInputErr
    }
   q ret
}

/// validate BIG
ClassMethod Validate(ByRef err As %String, ByRef in As %String, ByRef list As %ListOfObjects) As %String
{

   $$$Init
    try
    {
      #dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
      #dim referenceItem As ALVA.EDFORMS.CONTROLS.BIG.Item
	  $$$FillSysParamsBig(in)
	  s actionId=$lg(in("Action"),2) s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
      s validationType=$lg($g(in("Param")),1)
      s validatedItem=$lg($g(in("Param")),2)
      s items=$g(in("Items"))
      //      
      if (validationType=1)
      {
         s key=""
         for
         {
            s item=items.GetNext(.key) q:key=""
            i (item.Id = validatedItem)
            {
	           s stt=$$$BigStateTypeOk s info=""
               i item.Id="vzdalenostPresna" {
	               s vzdalenostPresna = item.FirstValue().Data
	               i ##class(ALWA.MAPY.API.Routing).Available() {
		               s valDta=$g($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA"))
	  	  	  	   	   s zastavkaOdId=$lg(valDta,1)
	      	  	       s oznacnikOdId=$lg(valDta,2)
	      	  	       s zastavkaDoId=$lg(valDta,3)
	      	  	       s oznacnikDoId=$lg(valDta,4)
                      s vzdalenostPresna = $lg(valDta,5)
         	          s zakladniDobaJizdy = $lg(valDta,6)
                      s vzdalenostMapy = ""
                      s zakladniDobaJizdyMapy = ""
                      i (zastavkaOdId'="")&&(zastavkaDoId'="") {
                            k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).vzdalenostPodleGPSMapy(.sys,$lb(zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId),.arrDta)
		  	  	                s vzdalenostMapy=$lg($g(arrDta("DTA")),1)
		  	  	                s zakladniDobaJizdyMapy=$lg($g(arrDta("DTA")),2)
                      }
		  	  	         i (vzdalenostPresna*1000)'=vzdalenostMapy {
			  	  	       s stt=$$$BigStateTypeInformation
		  	  	       	   s info="dle mapových podkladů "_vzdalenostMapy_" m / "_zakladniDobaJizdyMapy_" min"
		  	  	       }
	      	   	   }
               }
               d item.UpdateStatus(stt,info)             
               d list.Insert(item)        
            }
         }
      }     
   }
    catch (ex) { $$$CatchErrToInputErr }
   q ret
}

/// save BIG
ClassMethod Save(ByRef err As %String, ByRef in As %String, ByRef out As %String) As %String
{
   $$$Init
    try
    {
      #dim items As %ListOfObjects
      #dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
      #dim value AS ALVA.EDFORMS.CONTROLS.BIG.ItemValue     
      $$$FillSysParamsBig(in)
      s action=$g(in("Action"))
      s items=$g(in("Items"))
      s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
      s hrlOd="" s valDta="" k arrCasovaPasmaDobaJizdy
      s key=""
      for 
       {
         s item=items.GetNext(.key) q:key=""
         s mItem=item.Id
         s val=item.FirstValueData()
         i mItem="datumOd" {s hrlOd=##class(ALVA.GENERALAPI.Date).DateToHor(val)}
         i mItem="vzdalenostPresna" {s $li(valDta,1)=(val*1000)}
         i mItem="zakladniDobaJizdy" {s $li(valDta,2)=val}
         i mItem="vzdalenostTarifni" {s $li(valDta,3)=(val*1000)}
         i mItem["pasmoJizdniDoba" {
	         i val'="" {
		         s pasmoJizdniDobyId=$p(mItem,"|",2)
	             s arrCasovaPasmaDobaJizdy(pasmoJizdniDobyId)=$lb(val)
	        }
	     }      
      }
      //zapis do databaze
      k $$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA","vzdalenostDoba","DTA",hrlOd)
      s $$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA","vzdalenostDoba","DTA",hrlOd)=valDta
      m $$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"EDI","usek","DTA","vzdalenostDoba","DTA",hrlOd,"pasma","DTA")=arrCasovaPasmaDobaJizdy
   }
   catch (ex)
    {
       $$$CatchErrToInputErr
    }
   q ret
}

}
