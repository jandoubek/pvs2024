Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAEDREPORTS, ALVAISY)

Class ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0005 Extends %RegisteredObject
{

/// 
/// .iIndexGlobalu,.iIndexTab,.sestava,.title
/// 
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
		//parametry pro hledani
		s val=$o(filtr("nazevObsahuje","")) i val'="" s arr("PAR","hledanyText")=val
		s val=$o(filtr("dobaJizdyOd","")) i val'="" s arr("PAR","dobaJizdyOd")=val
		s val=$o(filtr("dobaJizdyDo","")) i val'="" s arr("PAR","dobaJizdyDo")=val
		s val=$o(filtr("vzdalenostOd","")) i val'="" s arr("PAR","vzdalenostOd")=(val*1000)
		s val=$o(filtr("vzdalenostDo","")) i val'="" s arr("PAR","vzdalenostDo")=(val*1000)
		//
		d ##class(ALVA.ISY.ISYZastavky.API.VzdalenostiJizdniDobyUseky).seznam(.sys,"",$name($$$CTMPGLBFRM(GUID,##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVzdalenostEdit).CTMPGLBFRMIDX(),"DTA")),.arr)
		//definice tabulky
		k ^CacheTempSS(idglb) s tiskglb=$name(^CacheTempSS(idglb,"OUT","mltab"))
		s idTab="TAB"
		s nadpis="ISYT0005"
		s title="Výpis vzdáleností"	
		s nadpis2="Výpis vzdáleností"
		s nadpis3="Výpis vzdáleností"
		s @tiskglb=idTab
 		s @tiskglb@(idTab,"STYP")="T" 		
 		s @tiskglb@(idTab,"Name")=title_" (dne: "_##class(ALVA.GENERALAPI.Date).horToDate($h)_")"
 		s @tiskglb@(idTab,"Format")="<"
 		s @tiskglb@(idTab,"Long")=""
 		// odkaz v combu
 		s @tiskglb@(idTab,"Index",idTab)=@tiskglb@(idTab,"Name")
 		// sloupce  (nazev, format, typ)
 		s n="" s f="" s t=""
 		s idx=1 s $p(n,"~",idx)="Id"							s $p(f,"~",idx)=">" s $p(t,"~",idx)="N"
 		s idx=2 s $p(n,"~",idx)="Zastávka|od"					s $p(f,"~",idx)=">" s $p(t,"~",idx)="N"
 		s idx=3 s $p(n,"~",idx)="Označník|od"					s $p(f,"~",idx)=">" s $p(t,"~",idx)="N"
 		s idx=4 s $p(n,"~",idx)="Zastávka|od, název"			s $p(f,"~",idx)="<" s $p(t,"~",idx)="T"
 		s idx=5 s $p(n,"~",idx)="Zastávka|do"					s $p(f,"~",idx)=">" s $p(t,"~",idx)="N"
 		s idx=6 s $p(n,"~",idx)="Označník|do"					s $p(f,"~",idx)=">" s $p(t,"~",idx)="N"
 		s idx=7 s $p(n,"~",idx)="Zastávka|do, název"			s $p(f,"~",idx)="<" s $p(t,"~",idx)="T"
 		s idx=8 s $p(n,"~",idx)="Datum|od"						s $p(f,"~",idx)=">" s $p(t,"~",idx)="D"
 		s idx=9 s $p(n,"~",idx)="Přesná|vzdálenost [km]"		s $p(f,"~",idx)=">" s $p(t,"~",idx)="N3"
 		s idx=10 s $p(n,"~",idx)="Tarifní|vzdálenost[km]"		s $p(f,"~",idx)=">" s $p(t,"~",idx)="N"
 		s idx=11 s $p(n,"~",idx)="Základní|doba jízdy [min]"	s $p(f,"~",idx)=">" s $p(t,"~",idx)="N"
 		//nastavím parametry sloupců
 		for cnt=1:1:$l(n,"~")
 		{ 			
 			s @tiskglb@(idTab,"SL",cnt)=$lts($lfs($p(n,"~",cnt),"|"),$c(13,10))	//názevy
 			s @tiskglb@(idTab,"SL",cnt,"Format")=$p(f,"~",cnt)					//formát
 			s @tiskglb@(idTab,"SL",cnt,"Typ")=$p(t,"~",cnt)						//typ
 		}
 		k arrCisCasPasma d ##class(ALVA.ISY.ISYCiselniky.API.CasovaPasmaJizdniDoby).seznam(.sys,.arrCisCasPasma)
 		k arrCnvCisCasPasma
 		s idx=11
 		s pasmoJizdniDobaId="" f {
	 		s val="" s pasmoJizdniDobaId=$o(arrCisCasPasma("DTA",pasmoJizdniDobaId),1,val) i pasmoJizdniDobaId="" q
	 		s pasmoJizdniDobaNazev=$lg(val,1)
	 		s n="Pásmo "_pasmoJizdniDobaNazev_"|doba jízdy [min]"
	 		s idx=idx+.01 s arrCnvCisCasPasma(pasmoJizdniDobaId)=idx
	 		s @tiskglb@(idTab,"SL",idx)=$lts($lfs(n,"|"),$c(13,10))				//název
 			s @tiskglb@(idTab,"SL",idx,"Format")=">"							//formát
 			s @tiskglb@(idTab,"SL",idx,"Typ")="N"								//typ
 		}
 		//data do tabulky pro tisk
 		// zobrazim data
		s abcidx="" f {
			s usekId="" s abcidx=$o(@tmpglblst@("IDX",abcidx),1,usekId) i abcidx="" q
			s valDta=$g(@tmpglblst@("DTA",usekId))
			s zastavkaOdId=$lg(valDta,1)
			s oznacnikOdId=$lg(valDta,2)
			s zastavkaDoId=$lg(valDta,3)
			s oznacnikDoId=$lg(valDta,4)
			s zastavkaOdNazev=""
			i zastavkaOdId {
				k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaOdId,"",.arrDta)
				s valDta=$g(arrDta("DTA"))
				s zastavkaOdNazev=$lg(valDta,1)_","_$lg(valDta,2)_","_$lg(valDta,3)_"/"_$lg(valDta,4)
			}
			s zastavkaDoNazev=""
			i zastavkaDoId {
				k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaDoId,"",.arrDta)
				s valDta=$g(arrDta("DTA"))
				s zastavkaDoNazev=$lg(valDta,1)_","_$lg(valDta,2)_","_$lg(valDta,3)_"/"_$lg(valDta,4)
			}
			s datumOd="" s presnaVzdalenost="" s tarifniVzdalenost="" s zakladniDobaJizdy="" s dobaJizdyPasmo=""
			s hrlOd=$o(@tmpglblst@("DTA",usekId,"vzdalenostDoba","DTA",""),-1)
			i hrlOd {
				s datumOd=##class(ALVA.GENERALAPI.Date).horToDate(hrlOd)
				s valDta=$g(@tmpglblst@("DTA",usekId,"vzdalenostDoba","DTA",hrlOd))
				s presnaVzdalenost=$lg(valDta,1)
				s zakladniDobaJizdy=$lg(valDta,2)
				s tarifniVzdalenost=$lg(valDta,3)
				k arrPasmoJizdniDoba
				s pasmoJizdniDobaId="" f {
					s valDta="" s pasmoJizdniDobaId=$o(@tmpglblst@("DTA",usekId,"vzdalenostDoba","DTA",hrlOd,"pasma","DTA",pasmoJizdniDobaId),1,valDta) i pasmoJizdniDobaId="" q
					s dobaJizdy=$lg(valDta,1)
					s arrPasmoJizdniDoba(pasmoJizdniDobaId)=dobaJizdy
				}
			}
			s presnaVzdalenost=$j(presnaVzdalenost/1000,0,3)
			s tarifniVzdalenost=$j(tarifniVzdalenost/1000,0,0)
			//do tabulky
 			s rd=$i(@tiskglb@(idTab,"RD")) s @tiskglb@(idTab,"RD",rd)=""
			s @tiskglb@(idTab,"Dta",rd,1)=usekId
			s @tiskglb@(idTab,"Dta",rd,2)=zastavkaOdId
			s @tiskglb@(idTab,"Dta",rd,3)=oznacnikOdId
			s @tiskglb@(idTab,"Dta",rd,4)=zastavkaOdNazev
			s @tiskglb@(idTab,"Dta",rd,5)=zastavkaDoId
			s @tiskglb@(idTab,"Dta",rd,6)=oznacnikDoId
			s @tiskglb@(idTab,"Dta",rd,7)=zastavkaDoNazev
			s @tiskglb@(idTab,"Dta",rd,8)=datumOd
			s @tiskglb@(idTab,"Dta",rd,9)=presnaVzdalenost
			s @tiskglb@(idTab,"Dta",rd,10)=tarifniVzdalenost
			s @tiskglb@(idTab,"Dta",rd,11)=zakladniDobaJizdy
			//
			s pasmoJizdniDobaId="" f {
				s dobaJizdy="" s pasmoJizdniDobaId=$o(arrPasmoJizdniDoba(pasmoJizdniDobaId),1,dobaJizdy) i pasmoJizdniDobaId="" q
				s cl=$g(arrCnvCisCasPasma(pasmoJizdniDobaId)) i 'cl continue
				s @tiskglb@(idTab,"Dta",rd,cl)=dobaJizdy
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
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s bigValue=""
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue(bigValue,"","")
      //d item.UpdateStatus($$$BigStateTypeInformation,"pro všechny zastávky zadejte ""*""") 
      d list.Insert(item)
      // === doba jizdy od
      s bigItem="dobaJizdyOd" s bigItemName = "Doba jízdy od (min)" s bigDataType = $$$BigItemDataTypeInteger
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue("","","")     
      d list.Insert(item)
      // === doba jizdy do
      s bigItem="dobaJizdyDo" s bigItemName = "Doba jízdy do (min)" s bigDataType = $$$BigItemDataTypeInteger
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue("","","")     
      d list.Insert(item)
      // === vzdalenost od
      s bigItem="vzdalenostOd" s bigItemName = "Vzdálenost od (km)" s bigDataType = $$$BigItemDataTypeInteger
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue("","","")     
      d list.Insert(item)
      // === vzdalenost do
      s bigItem="vzdalenostDo" s bigItemName = "Vzdálenost do (km)" s bigDataType = $$$BigItemDataTypeInteger
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue("","","")     
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
