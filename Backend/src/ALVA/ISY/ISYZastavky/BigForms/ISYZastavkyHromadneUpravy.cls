Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY, ALVAEDREPORTS)

Class ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyHromadneUpravy Extends %RegisteredObject
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
      s hrlOd=$o(in("ParamEx","IDEditPol",""))
      */
      //zjistim pocet oznacenych zastavek pro upravu
      s pocetZastavek=0 s zastavkaId="" f {
	      s zastavkaId=$o(in("ParamEx","Zastavka",zastavkaId)) i zastavkaId="" q
	      s pocetZastavek=pocetZastavek+1
      }
      s bigGroup="G1" s bigGroupName="Hromadná úprava vlastností na vybraných zastávkách."
      s bigItem="pocetZastavek" s bigItemName="Počet vybraných zastávek pro úpravu" s bigDataType=$$$BigItemDataTypeInteger
      s bigRequired=0 s bigAllowEdit=0 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue(pocetZastavek,"","")
      i 'pocetZastavek d item.UpdateStatus($$$BigStateTypeError,"Nejsou vybrány zastávky pro úpravu !")
      d list.Insert(item)
      // seznam polozek k hromadne uprave zastavek
      s bigItem="upravaId" s bigItemName="Upravit vlastnost" s bigDataType=$$$BigItemDataTypeList
      s bigRequired=1 s bigAllowEdit=1 s bigValidation=1
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"") 
	  //polozky pro hromadnou upravu =====
	  d item.AddListItem("Atribut na znamení nebo požádání","G106")
	  d item.AddListItem("Název podle registru","G101")
	  d item.AddListItem("Číslo podle registru","G107")
	  d item.AddListItem("Odbav.zař, číslo","G102")
	  d item.AddListItem("Odbav.zař, rádius","G103")
	  d item.AddListItem("Provozovatel","G104")
	  d item.AddListItem("SMART","G105")
	  d item.AddListItem("Tarifní zóna","G108")
	  d list.Insert(item)
	  //==================================
	  //nazev podle registru
	  s bigGroup="G101" s bigGroupName="Název podle registru"
	  s bigItem="nazevDleCRZ" s bigItemName="Aktualizovat název podle registru" s bigDataType=$$$BigItemDataTypeBoolean
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue("","","")
      s item.Hidden=1
      d list.Insert(item)
      //odbav.zar, cislo
	  s bigGroup="G102" s bigGroupName="Odbav.zař, číslo"
	  // seznam polozek k hromadne uprave zastavek
      s bigItem="odbZaCisloZastBezCRZ" s bigItemName="U zastávek, které nejsou spárovány s CRZ" s bigDataType=$$$BigItemDataTypeList
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"") 
	  d item.AddListItem("Číslo odbav.zař. neaktualizovat",1)
	  d item.AddListItem("Číslo odbav.zař. vymazat",2)
	  d item.AddValue(1)
	  s item.Hidden=1
      d list.Insert(item)
      s bigItem="odbZaCisloZastSCRZ" s bigItemName="U zastávek, které jsou spárovány s CRZ" s bigDataType=$$$BigItemDataTypeList
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"") 
	  d item.AddListItem("Číslo odbav.zař. neaktualizovat",1)
	  d item.AddListItem("Číslo odbav.zař. aktualizovat",2)
	  d item.AddValue(1)
	  s item.Hidden=1
      d list.Insert(item)
	  //odbav.zar, radius
	  s bigGroup="G103" s bigGroupName="Odbav.zař, rádius"
      s bigItem="odbZaRadius" s bigItemName="Odbav.zař. rádius[m]" s bigDataType=$$$BigItemDataTypeInteger
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue("","","")
      s item.Hidden=1
      d list.Insert(item)
      //provozovatel
      s bigGroup="G104" s bigGroupName="Provozovatel"
      s bigItem="provozovatel" s bigItemName="Provozovatel" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue("","","")
      s item.Hidden=1
      d list.Insert(item)
      //smart
      s bigGroup="G105" s bigGroupName="SMART"
      s bigItem="smart" s bigItemName="SMART zastávka" s bigDataType=$$$BigItemDataTypeBoolean
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue("","","")
      s item.Hidden=1
      d list.Insert(item)
      //atribut na znameni
      s bigGroup="G106" s bigGroupName="Atribut na znamení nebo požádání"
      s bigItem="atributNaZnameni" s bigItemName="Atribut na znamení nebo požádání" s bigDataType=$$$BigItemDataTypeBoolean
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue("","","")
      s item.Hidden=1
      d list.Insert(item)
      //doplnit cislo podle registru
	  s bigGroup="G107" s bigGroupName="Číslo podle registru"
	  s bigItem="cisloDleCRZ" s bigItemName="Doplnit číslo podle registru" s bigDataType=$$$BigItemDataTypeBoolean
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue("","","")
      s item.Hidden=1
      s item.StatusMessage="Doplní ""číslo CIS"" u zastávek, kde není evidované."
      d list.Insert(item)
      //tarifni zona
      // === tarifni zona
      s bigGroup="G108" s bigGroupName="Tarifní zóna"
      s bigItem="tarifniZona" s bigItemName="Tarifní zóna" s bigDataType=$$$BigItemDataTypeCodebook
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      s item.CodebookType=$$$CodebookTypeISYTarifniZony
      d item.AddValue("","","")
      s item.Hidden=1
      d list.Insert(item)
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
      #dim item2 As ALVA.EDFORMS.CONTROLS.BIG.Item
      #dim referenceItem As ALVA.EDFORMS.CONTROLS.BIG.Item
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
               i item.Id="upravaId" {
	               s upravaId=item.FirstValue().Data   
	               f {
		               s item2=items.GetNext(.key2) i key2="" q
		               i item2.Id="pocetZastavek" continue
		         	   i item2.Id="upravaId" continue      	   
			           s item2.Hidden=1
			           s item2.Required=0
			           i item2.GroupId=upravaId {
				           i item2.Id="odbZaCisloZastBezCRZ" s item2.Required=1
				           i item2.Id="odbZaCisloZastSCRZ" s item2.Required=1
				           s item2.Hidden=0
			           }
			           d list.Insert(item2)  	
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
	  $$$FillSysParamsBig(in) 
      #dim items As %ListOfObjects
      #dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
      #dim value AS ALVA.EDFORMS.CONTROLS.BIG.ItemValue     
      s action=$g(in("Action"))
      s items=$g(in("Items"))
      s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
      s key="" k arrVal
      f {
	      s item=items.GetNext(.key) q:key=""
          s ItemId=item.Id
          s val=item.FirstValueData()
          s arrVal(ItemId)=val
      }
      s zastavkaId="" f {
	      s zastavkaId=$o(in("ParamEx","Zastavka",zastavkaId)) i zastavkaId="" q
	      //nactu data zastavky
	      k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaId,"",.arrDta)
	      s arrDta("DTA")=$g(arrDta("DTA"))
	      //zmena hodnoty
	      //nazev podle registru
	      i $g(arrVal("upravaId"))="G101" {
		      //je to povolene
		      i $g(arrVal("nazevDleCRZ")) {
			      s zastavkaCRZID=$lg(arrDta("DTA"),14)
			      i zastavkaCRZID {
				      k arrTmpDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyCRZ).nacti(.sys,.zastavkaCRZID,.arrTmpDta)
				      s valTmp=$g(arrTmpDta("DTA"))
				      i (($lg(valTmp,1)'="")!($lg(valTmp,2)'="")!($lg(valTmp,3)'="")!($lg(valTmp,4)'="")) {
					      s $li(arrDta("DTA"),1)=$lg(valTmp,1)
					      s $li(arrDta("DTA"),2)=$lg(valTmp,2)
					      s $li(arrDta("DTA"),3)=$lg(valTmp,3)
					      s $li(arrDta("DTA"),4)=$lg(valTmp,4)
					      s horologOd=$lg(valTmp,5) i 'horologOd s horologOd=+$h
					      //zmena s datumem k zastavce
						  k arrTmpChangeDta
						  s arrTmpChangeDta("DTA")=$lb($lg(valTmp,1),$lg(valTmp,2),$lg(valTmp,3),$lg(valTmp,4),$lg(arrDta("DTA"),13))
						  d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyCasoveVariatyUdaju).uloz(.sys,$lb(zastavkaId,1,horologOd),"",.arrTmpChangeDta)
						  k arrTmpChangeDta
				      }
			      }
		      }
	      }
	      //odbav.zarizeni, cislo
	      i $g(arrVal("upravaId"))="G102" {
		      s zastavkaCRZID=$lg(arrDta("DTA"),14)
		      //je zadano cislo dle CRZ
		      i zastavkaCRZID {
			      //neaktualizovat
			      i $g(arrVal("odbZaCisloZastSCRZ"))=1 {
				      
				  }
			      //aktulizovat
			      i $g(arrVal("odbZaCisloZastSCRZ"))=2 {
				      s koefODB=+$g(^[dataDB]JRSET("Definice","ZST","CIS_INC")) i 'koefODB s koefODB=10  //!!!!! predelat na api
				      s $li(arrDta("DTA"),12)=(zastavkaCRZID*koefODB)
				  }
		      }
		      //neni cislo dle CRZ
		      else {
			      //neaktualizovat
			      i $g(arrVal("odbZaCisloZastBezCRZ"))=1 {
				      
				  }
			      //vymazat
			      i $g(arrVal("odbZaCisloZastBezCRZ"))=2 {
				      s $li(arrDta("DTA"),12)=""
				  }
		      }
	      }
	      //odbav.zar, radius
	      i $g(arrVal("upravaId"))="G103" {
		      s $li(arrDta("DTA"),23)=$g(arrVal("odbZaRadius"))
	      }
	      //provozovatel
	      i $g(arrVal("upravaId"))="G104" {
		      s $li(arrDta("DTA"),5)=$g(arrVal("provozovatel"))
	      }
	      //smart
	      i $g(arrVal("upravaId"))="G105" {
		      s $li(arrDta("DTA"),36)=$g(arrVal("smart"))
	      } 
	      //atribut na znameni nebo pozadani
	      i $g(arrVal("upravaId"))="G106" {
		      s valLst=$lg($g(arrDta("DTA")),7)
		      k tmpArr f cnt=1:1:$ll(valLst) s atributId=$lg(valLst,cnt) i atributId'="" s tmpArr(atributId)=""
		      i +$g(arrVal("atributNaZnameni")) {
			      s tmpArr("x")=""
		      }
		      else {
			      k tmpArr("x")
		      }
		      s valLst=""
		      s atributId="" f {
			      s atributId=$o(tmpArr(atributId)) i atributId="" q
			      s $li(valLst,*+1)=atributId
		      }
		      s $li(arrDta("DTA"),7)=valLst
	      }
	      //doplnit cislo CIS
	      i $g(arrVal("upravaId"))="G107" {
		      s zastavkaCRZID=$lg(arrDta("DTA"),14)
		      s zastavkaVlakova=$lg(arrDta("DTA"),26)
		      i ('zastavkaVlakova)&('zastavkaCRZID) {
			      s obec=$lg(arrDta("DTA"),1)
			      s castObce=$lg(arrDta("DTA"),2)
			      s lokalita=$lg(arrDta("DTA"),3)
			      s blizkaObec=$lg(arrDta("DTA"),4)
			      k tmpArr s tmpArr("DTA")=$lb(obec,castObce,lokalita,blizkaObec)
			      d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyCRZ).vyhledejIdPodleNazvu(.sys,.zastavkaCRZID,.tmpArr)
			      i zastavkaCRZID {
				      s $li(arrDta("DTA"),14)=zastavkaCRZID
			      }
		      }
	      }
	      //tarifni zona
	      i $g(arrVal("upravaId"))="G108" {
		      s $li(arrDta("DTA"),15)=$g(arrVal("tarifniZona"))
	      }
	      //zapis zastavky
	      d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).uloz(.sys,zastavkaId,"",.arrDta)
      }
  }
   catch (ex){$$$CatchErrToInputErr}
   q ret
}

}
