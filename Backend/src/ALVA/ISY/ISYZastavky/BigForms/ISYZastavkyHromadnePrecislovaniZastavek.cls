Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyHromadnePrecislovaniZastavek Extends %RegisteredObject
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
	  //vyhledani koeficientu
	  s minimum=""
	  s zastavkaId="" f {
		  s zastavkaId=$o(^[dataDB]JRZ(zastavkaId)) i zastavkaId="" q
		  i (zastavkaId#1) {
			  i minimum="" s minimum=(zastavkaId#1) continue
			  i (zastavkaId#1)<minimum s minimum=(zastavkaId#1)
		  }
	  }
	  s koeficient=0
	  i minimum {
		  f cnt=1:1 {
			  s koeficient=1
			  f idx=1:1:cnt {
				  s koeficient=(koeficient*10)
			  }
			  i '((minimum*koeficient)#1) q
		  }
	  }
	  #dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
      #dim value As ALVA.EDFORMS.CONTROLS.BIG.ItemValue
      s bigGroup="G1" s bigGroupName="Hromadné přečíslování všech zastávek."
      // zpusob precislovani zastavek
      s bigItem="precislovatTypId" s bigItemName="Způsob přečíslování zastávek" s bigDataType=$$$BigItemDataTypeList
      s bigRequired=1 s bigAllowEdit=1 s bigValidation=1
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"") 
	  d item.AddListItem("Jako číslo zastávky použít číslo CIS",1)
	  d item.AddListItem("Stávající číslo zastávky vynásobit koeficientem",2)
	  d item.AddListItem("Číslo zastávky přidělit od 1 dále",3)
	  s precislovatTypVal=1 i koeficient s precislovatTypVal=2
	  d item.AddValue(precislovatTypVal,"","")
	  d list.Insert(item)
	  //koeficient
	  s bigItem="koeficient" s bigItemName="Koeficient" s bigDataType=$$$BigItemDataTypeInteger
      s bigRequired=0 s bigAllowEdit=0 s bigValidation=1 i precislovatTypVal=2 s bigRequired=1 s bigAllowEdit=1
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue(koeficient,"","")
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
	  $$$FillSysParamsBig(in)
	  
	  #dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
      #dim item2 As ALVA.EDFORMS.CONTROLS.BIG.Item
      #dim referenceItem As ALVA.EDFORMS.CONTROLS.BIG.Item
      
	  s actionId=$lg(in("Action"),2) s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
      s validationType=$lg($g(in("Param")),1)
      s validatedItem=$lg($g(in("Param")),2)
      s items=$g(in("Items"))
      //      
      if (validationType=1) {
         s key=""
         f {
            s item=items.GetNext(.key) q:key=""
            i (item.Id = validatedItem) {
	           s stt=$$$BigStateTypeOk s info=""
               i item.Id="precislovatTypId" {
	               s precislovatTypId=item.FirstValue().Data   
	               f {
		               s item2=items.GetNext(.key2) i key2="" q
		               i item2.Id="precislovatTypId" continue 	   
			           s item2.AllowEdit=0
			           s item2.Required=0
			           i item2.Id="koeficient" {
				           i precislovatTypId=2 {
					           s item2.AllowEdit=1
			           		   s item2.Required=1
			           	   }
			           }
			           d list.Insert(item2)  	
		       	   }          	                 
               }
            }
         }
      }     
   }
   catch (ex) { $$$CatchErrToInputErr  }
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
      k arrVal
      s key="" f {
	      s item=items.GetNext(.key) q:key=""
          s ItemId=item.Id
          s val=item.FirstValueData()
          s arrVal(ItemId)=val
      }
      s precislovatTypId=$g(arrVal("precislovatTypId"))
      s koeficient=$g(arrVal("koeficient"))
      
      //precislovani zastavek
      
      //tabulka pro precislovani
      s wrk=$i(^CacheTempJB) k ^CacheTempJB(wrk)
      
	  //vychozi cislo pro zastavky mimo registr
 	  s czo=+$g(^[dataDB]JRSET("Definice","ZST","CIS")) i czo s czo=5000000
	  //
 	  m ^CacheTempJB(wrk,"z")=^[dataDB]JRZ k ^[dataDB]JRZ
	  //
 	  s zastavkaId="" f {
	 	  
	 	  s val="" s zastavkaId=$o(^CacheTempJB(wrk,"z",zastavkaId),1,val) i zastavkaId="" q
	 	  
	 	  //cislo podle registru, vlakova zastavka neni v crz, dam je nakonec (vymazu crz, dostane nove)
 		  s crzId=+$p(val,"$",9) i +$p(val,"$",17) s crzId=""
 		  
 		  //nove cislo zastavky dle crz
 		  i precislovatTypId=1 {
	 		  s newZastavkaId=crzId
	 		  //pokud pod cislem zastavky uz nejaka je, dam nove
	 		  i newZastavkaId {
		 		  i $d(^[dataDB]JRZ(newZastavkaId)) s newZastavkaId=""
	 		  }
	 		  //neni cislo v crz
 		  	  i 'newZastavkaId {
	 		  	  f newZastavkaId=czo:1 i '$d(^[dataDB]JRZ(newZastavkaId)) q
 		  	  }
 		  }
 		  //nove cislo zastavky koeficientem
 		  i precislovatTypId=2 {
	 		  s newZastavkaId=(zastavkaId*koeficient)
 		  }
 		  
 		  //nove cislo zastavky od 1
 		  i precislovatTypId=3 {
	 		  s newZastavkaId=$i(^CacheTempJB(wrk,"i"))
 		  }
		  
		  //zastavka do databaze
		  m ^[dataDB]JRZ(newZastavkaId)=^CacheTempJB(wrk,"z",zastavkaId)
		  
		  //rozdilne cislo do tabulky
 		  i zastavkaId'=newZastavkaId {s ^CacheTempJB(wrk,"CZ_TAB",zastavkaId)=newZastavkaId}
 	  }
 	  k ^CacheTempJB(wrk,"z")
 	  
      // zaloha tabulky
      m ^[dataDB]JRZctr($h)=^CacheTempJB(wrk,"CZ_TAB")
      
	  // uprava v ostatnich datech
 	  s sc=$$rnZstLin^JRapiZst1(IdFa,dataDB,wrk,"","") i +sc zt				// precislovani zastavek v linkach
 	  s sc=$$rnZstLinAPL^JRapiZst1(IdFa,dataDB,wrk,"","") i +sc zt			// precislovani zastavek v archivu platnych linek
 	  s sc=$$rnZstOdj^JRapiZst1(IdFa,dataDB,wrk,"","") i +sc zt				// precislovani zastavek v relacich
 	  s sc=$$rnZstZro^JRapiZst1(IdFa,dataDB,wrk,"","") i +sc zt				// precislovani zastavek v zast. s rozpisem
 	  s sc=$$rnZstTkm^JRapiZst1(IdFa,dataDB,wrk,"","") i +sc zt				// precislovani zastavek ve stare tab.vzdalenosti
	  
	  // precislovani zastavek v udrzbe zastavek
 	  k arr m arr=^CacheTempJB(wrk,"CZ_TAB")
 	  s sc=$$cnvZUPzdZst^JRapi(IdFa,dataDB,userID,.arr,"","",(userID_"|"_loginName_"|"_userName))
	  
	  //precislovani v AD
 	  s sc=##class(ALVA.ADMAIN.MLAPI).rnZst(IdFa,dataDB,"^CacheTempJB("_wrk_",""CZ_TAB"",","","") i +sc zt
	  
	  //precislovani v ISYBUSU
 	  k arrDTA m arrDTA("DTA")=^CacheTempJB(wrk,"CZ_TAB") d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUsekyFce).PrecislujZastavky(.sys,.arrDTA)
 	  k arrDTA m arrDTA("DTA")=^CacheTempJB(wrk,"CZ_TAB") d ##class(ALVA.ISY.ISYNavaznosti.API.SkupinyNavaznostiUzlyFce).PrecislujZastavky(.sys,.arrDTA) 
 	  //jeste obehy
 	  
   }
   catch (ex)
    {
       $$$CatchErrToInputErr
    }
   q ret
}

ClassMethod test()
{
	//d ##class(ALVA.ISY.ISYZastavky.BigForms.ISYZastavkyHromadnePrecislovaniZastavek).test()
	
	 s dataDB="user"
	//vyhledani koeficientu
	  s minimum=""
	  s zastavkaId="" f {
		  s zastavkaId=$o(^[dataDB]JRZ(zastavkaId)) i zastavkaId="" q
		  i (zastavkaId#1) {
			  i minimum="" s minimum=(zastavkaId#1) continue
			  i (zastavkaId#1)<minimum s minimum=(zastavkaId#1)
		  }
	  }
	  s koeficient=0
	  i minimum {
		  f cnt=1:1 {
			  s koeficient=1
			  f idx=1:1:cnt {
				  s koeficient=(koeficient*10)
			  }
			  i '((minimum*koeficient)#1) q
		  }
	  }
	  w !,koeficient
}

}
