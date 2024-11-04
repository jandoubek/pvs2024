Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAEDREPORTS, ALVAISY, JRapi)

Class ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0008 Extends %RegisteredObject
{

ClassMethod LoadTable(ByRef sys As %String, ByRef filtr As %String, ByRef param As %String, ByRef idglb As %String, ByRef idTab As %String, ByRef nadpis As %String, ByRef title As %String, ByRef nadpis2 As %String, ByRef nadpis3 As %String) As %Status
{
	$$$Init
	try 
	{	
		// filtr(jmenopolozkyzBigu,hodnota)=""		
		// param(name,hodnota)=""	
		$$$FillParams
		$$$TMPGLBSET(tmpglblst)
		k arr s arr("GLB")=tmpglblst 
        s arr("PAR","hledanyText")="*"
		d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).seznam(.sys,.arr)
		
        //definice tabulky
		k ^CacheTempSS(idglb) s tiskglb=$name(^CacheTempSS(idglb,"OUT","mltab"))
		s idTab="TAB"
		s nadpis="ISYT0008"
		s title="Kontrola duplicity"	
		s nadpis2="Kontrola duplicity"
		s nadpis3="Kontrola duplicity"
		s @tiskglb=idTab
 		s @tiskglb@(idTab,"STYP")="T" 		
 		s @tiskglb@(idTab,"Name")=title_" (dne: "_##class(ALVA.GENERALAPI.Date).horToDate($h)_")"
 		s @tiskglb@(idTab,"Format")="<"
 		s @tiskglb@(idTab,"Long")=""
 		
      //nastavím parametry sloupců
      s @tiskglb@(idTab,"SL",1)= "ID slouceni"	            //názevy
 		s @tiskglb@(idTab,"SL",1,"Format")= ">"				    //formát
 		s @tiskglb@(idTab,"SL",1,"Typ")="N"					    //typ
      s @tiskglb@(idTab,"SL",2)= "CRZ ID"	                    //názevy
 		s @tiskglb@(idTab,"SL",2,"Format")= ">"			        //formát
 		s @tiskglb@(idTab,"SL",2,"Typ")="N"					    //typ
      s @tiskglb@(idTab,"SL",3)= "Obec"	                    //názevy
 		s @tiskglb@(idTab,"SL",3,"Format")= "<"				    //formát
 		s @tiskglb@(idTab,"SL",3,"Typ")= "T"				    //typ
      s @tiskglb@(idTab,"SL",4)= "Část obce"	                //názevy
 		s @tiskglb@(idTab,"SL",4,"Format")= "<"				    //formát
 		s @tiskglb@(idTab,"SL",4,"Typ")="T"					    //typ
      s @tiskglb@(idTab,"SL",5)= "Lokalita"	                //názevy
 		s @tiskglb@(idTab,"SL",5,"Format")= "<"				    //formát
 		s @tiskglb@(idTab,"SL",5,"Typ")="T"				        //typ
      s @tiskglb@(idTab,"SL",6)= "Blízká obec"	            //názevy
 		s @tiskglb@(idTab,"SL",6,"Format")= "<"				    //formát
 		s @tiskglb@(idTab,"SL",6,"Typ")="T"					    //typ
      s @tiskglb@(idTab,"SL",7)= "Řetězec pro sloučení"	    //názevy
 		s @tiskglb@(idTab,"SL",7,"Format")= "<"				    //formát
 		s @tiskglb@(idTab,"SL",7,"Typ")="T"					    //typ
      s @tiskglb@(idTab,"SL",8)= "Linky"	                    //názevy
 		s @tiskglb@(idTab,"SL",8,"Format")= "<"		            //formát
 		s @tiskglb@(idTab,"SL",8,"Typ")="T"					    //typ
      s @tiskglb@(idTab,"SL",9)= "Zast Id"	                 //názevy
 		s @tiskglb@(idTab,"SL",9,"Format")= ">"		            //formát
 		s @tiskglb@(idTab,"SL",9,"Typ")="N"					    //typ


       

        #; s arr(1)=$lb("obec","obec","T")
        #; s arr(2)=$lb("castObce","část obce","T")
        #; s arr(3)=$lb("lokalita","lokalita","T")
        #; s arr(4)=$lb("blizkaObec","blízká|obec","T")
        #; s arr(5)=$lb("provozovatel","provozovatel","T")
        #; s arr(6)=$lb("casovePasmo","časové|pásmo","T")
        #; s arr(7)=$lb("atribut","atribut","T")
        #; s arr(8)=$lb("smerTyp","směr typ","N")
        #; s arr(9)=$lb("odbZaNazKratky","odbav.zař.|název krátký","T")
        #; s arr(10)=$lb("odbZaNazDlouhy","odbav.zař.|název dlouhý","T")
        #; s arr(11)=$lb("odbZaNazBocniTablo","odbav.zař.|název boční tablo","T")
        #; s arr(12)=$lb("odbZaCislo","odbav.zař.|číslo","N")
        #; s arr(13)=$lb("nazevMHD","název pro MHD","T")
        #; s arr(14)=$lb("cisloCRZ","číslo|CRZ(CIS)","N")

        k sjednoceni    //sjednoceni("CRZ",crz)      //sjednoceno("Nazev",nazev) //sjednoceni("ID",idSjednoceni)
                       

        k ^ps 
        s idSjednoceniIndex = ""
        s abcidx="" f {
	 		s zastavkaId="" s abcidx=$o(@tmpglblst@("IDX",abcidx),1,zastavkaId) i abcidx="" q
            s valDta=$g(@tmpglblst@("DTA",zastavkaId))
            // CRZ
            s cisloCRZ = $lg(valDta,14)
            i cisloCRZ = "" continue
            i '$d(sjednoceni("CRZ",cisloCRZ)) s sjednoceni("CRZ",cisloCRZ) = $i(idSjednoceniIndex)
            s idSjednoceni = $g(sjednoceni("CRZ",cisloCRZ))
            s $list(sjednoceni("ID",idSjednoceni),*+1) = zastavkaId
            // NAZEV
            s zastavkaOdNazev=$lg(valDta,1)_","_$lg(valDta,2)_","_$lg(valDta,3)_"/"_$lg(valDta,4)
            s nazev =  $$cnvBezDiaUp^JRapi(zastavkaOdNazev)
            i '$d(sjednoceni("Nazev",nazev)) s sjednoceni("Nazev",nazev) = $i(idSjednoceniIndex)
            s idSjednoceni = $g(sjednoceni("Nazev",nazev))
            s $list(sjednoceni("IDZ",idSjednoceni),*+1) = zastavkaId
        }

         s idSjednoceni="" f {
	 		k zastIds s idSjednoceni=$o(sjednoceni("ID",idSjednoceni),1,zastIds) i idSjednoceni="" q
            i $ll(zastIds) < 2 continue // neni duplicita
            f count=1:1:$ll(zastIds) {
                s zastavkaId = $lg(zastIds,count)
                s rd=$i(@tiskglb@(idTab,"RD")) s @tiskglb@(idTab,"RD",rd)=""
                k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaId,"",.arrDta) 
                k valDta s valDta = arrDta("DTA")
                s @tiskglb@(idTab,"Dta",rd,1)=idSjednoceni
                s cisloCRZ = $lg(valDta,14) s @tiskglb@(idTab,"Dta",rd,2)=cisloCRZ
                s obec = $lg(valDta,1) s @tiskglb@(idTab,"Dta",rd,3)=obec
                s castObce = $lg(valDta,2) s @tiskglb@(idTab,"Dta",rd,4)=castObce
                s lokalita = $lg(valDta,3) s @tiskglb@(idTab,"Dta",rd,5)=lokalita
                s blizkaObec = $lg(valDta,4) s @tiskglb@(idTab,"Dta",rd,6)=blizkaObec
                s @tiskglb@(idTab,"Dta",rd,7)=cisloCRZ
                
                s @tiskglb@(idTab,"Dta",rd,9)=zastavkaId

               s linky = ""
               $$$TMPGLBSET(linkytmpglb)
               k arrDta s arrDta("GLB") = linkytmpglb
               d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).pouziteZastavky(.sys,.arrDta)
               s linkaId = "" f {
                  s linkaId = $o(@linkytmpglb@("DTA",zastavkaId,"skupinaLinky",linkaId)) i linkaId = "" q
                  s skupinaId = "" f {
                     s skupinaId =  $o(@linkytmpglb@("DTA",zastavkaId,"skupinaLinky",linkaId,skupinaId)) i skupinaId = "" q
                     s $list(linky,*+1) = skupinaId_"/"_$e(linkaId,2,7)
                  }
               }
               s @tiskglb@(idTab,"Dta",rd,8)= $lts(linky)
            }
        }
        s idSjednoceni="" f {
	 		k zastIds s idSjednoceni=$o(sjednoceni("IDZ",idSjednoceni),1,zastIds) i idSjednoceni="" q
            i $ll(zastIds) < 2 continue // neni duplicita
            f count=1:1:$ll(zastIds) {
                s zastavkaId = $lg(zastIds,count)
                s rd=$i(@tiskglb@(idTab,"RD")) s @tiskglb@(idTab,"RD",rd)=""
                k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaId,"",.arrDta) 
                k valDta s valDta = arrDta("DTA")
                s @tiskglb@(idTab,"Dta",rd,1)=idSjednoceni
                s cisloCRZ = $lg(valDta,14) s @tiskglb@(idTab,"Dta",rd,2)=cisloCRZ
                s obec = $lg(valDta,1) s @tiskglb@(idTab,"Dta",rd,3)=obec
                s castObce = $lg(valDta,2) s @tiskglb@(idTab,"Dta",rd,4)=castObce
                s lokalita = $lg(valDta,3) s @tiskglb@(idTab,"Dta",rd,5)=lokalita
                s blizkaObec = $lg(valDta,4) s @tiskglb@(idTab,"Dta",rd,6)=blizkaObec
                s zastavkaOdNazev=obec_","_castObce_","_lokalita_"/"_blizkaObec
                s @tiskglb@(idTab,"Dta",rd,7)=zastavkaOdNazev
                s @tiskglb@(idTab,"Dta",rd,9)=zastavkaId

               s linky = ""
               $$$TMPGLBSET(linkytmpglb)
               k arrDta s arrDta("GLB") = linkytmpglb
               d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).pouziteZastavky(.sys,.arrDta)
               s linkaId = "" f {
                  s linkaId = $o(@linkytmpglb@("DTA",zastavkaId,"skupinaLinky",linkaId)) i linkaId = "" q
                  s skupinaId = "" f {
                     s skupinaId =  $o(@linkytmpglb@("DTA",zastavkaId,"skupinaLinky",linkaId,skupinaId)) i skupinaId = "" q
                     s $list(linky,*+1) = skupinaId_"/"_$e(linkaId,2,7)
                  }
               }
               s @tiskglb@(idTab,"Dta",rd,8)= $lts(linky)
            }
        }
		//font
    	s @tiskglb@("dosFont")="0"
 		s @tiskglb@("defFont")="<f='7pt-Courier'>"		
		k @tmpglblst
	}
	catch (ex) {$$$CatchErrRest}
	quit ret
}

/// init BIG
ClassMethod Init(ByRef err As %String, ByRef in As %String, ByRef list As %ListOfObjects) As %String
{
   $$$Init
    try
    { 
      s actionId=$lg(in("Action"),2) s actionMode=$lg(in("Action"),2) // [3=add,4=edit,5=view]
	  //
	  #dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
      #dim value As ALVA.EDFORMS.CONTROLS.BIG.ItemValue  
	  //vytvorim big
	  s bigGroup="G1" s bigGroupName="Obecné nastavení"     
	  // nazev obsahuje
      s bigItem="nazevObsahuje" s bigItemName="Název zastávky obsahuje " s bigDataType=$$$BigItemDataTypeText
      s bigRequired=1 s bigAllowEdit=1 s bigValidation=0
      s bigValue="*"
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue(bigValue,"","")
      d item.UpdateStatus($$$BigStateTypeInformation,"pro všechny zastávky zadejte ""*""") 
      d list.Insert(item)
      
   }
   catch (ex) {$$$CatchErrToInputErr}
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
      s IdFa=$g(in("IdFa"))
      s user=$g(in("User"))
      s action=$g(in("Action"))
      s actionMode=$lg(in("Action"),2)
      s validationType=$lg($g(in("Param")),1)
      s validatedItem=$lg($g(in("Param")),2)
      s items=$g(in("Items"))
      if (validationType=1)
      {
         s key=""
         for
         {
            s item=items.GetNext(.key) q:key=""
            if (item.Id = validatedItem)
            {
	           s stt=$$$BigStateTypeOk
               s info=""
	           i item.Id="" {s val=item.FirstValue().Data }
               d item.UpdateStatus(stt,info)             
               d list.Insert(item)        
            }
         }
      }     
   }
    catch (ex) { $$$CatchErrToInputErr }
   q ret
}

}
