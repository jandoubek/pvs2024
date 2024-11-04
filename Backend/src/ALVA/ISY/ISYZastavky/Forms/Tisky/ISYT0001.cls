Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAEDREPORTS, ALVAISY)

Class ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0001 Extends %RegisteredObject
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
		s val=$o(filtr("provozuje","")) i val'="" s arr("PAR","provozuje")=val
		s id="" f {
			s id=$o(filtr("blizkaObecId",id)) i id="" q
			s $li(arr("PAR","blizkaObecLstId"),*+1)=id
		}
		s id="" f {
			s id=$o(filtr("zonaIDSId",id)) i id="" q
			s $li(arr("PAR","zonaIDSLstId"),*+1)=id
		}
		s id="" f {
			s id=$o(filtr("skupinaLstId",id)) i id="" q
			s $li(arr("PAR","skupinaLstId"),*+1)=id
		}
		d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).seznam(.sys,.arr)
		//definice tabulky
		k ^CacheTempSS(idglb) s tiskglb=$name(^CacheTempSS(idglb,"OUT","mltab"))
		s idTab="TAB"
		s nadpis="ISYT0001"
		s title="Základní údaje zastávek"	
		s nadpis2="Základní údaje zastávek"
		s nadpis3="Základní údaje zastávek"
		s @tiskglb=idTab
 		s @tiskglb@(idTab,"STYP")="T" 		
 		s @tiskglb@(idTab,"Name")=title_" (dne: "_##class(ALVA.GENERALAPI.Date).horToDate($h)_")"
 		s @tiskglb@(idTab,"Format")="<"
 		s @tiskglb@(idTab,"Long")=""
 		// odkaz v combu
 		s @tiskglb@(idTab,"Index",idTab)=@tiskglb@(idTab,"Name")
 		k arrItem d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).popis(.arrItem) 
 		s PripravaDat(1)="Číslo|Id"
 		s PripravaDat(2)=">"
 		s PripravaDat(3)="N"
	 	s cnt="" f {
		 	s val="" s cnt=$o(arrItem(cnt),1,val) i cnt="" q
		 	s $p(PripravaDat(1),"~",(cnt+1))=$lg(val,2)
		 	s $p(PripravaDat(2),"~",(cnt+1))=$s($lg(val,3)["N":">",1:"<")
 			s $p(PripravaDat(3),"~",(cnt+1))=$lg(val,3)
	 	}	
 		//nastavím parametry sloupců
 		for cnt=1:1:$l($g(PripravaDat(1)),"~")
 		{ 			
 			s @tiskglb@(idTab,"SL",cnt)=$lts($lfs($p($g(PripravaDat(1)),"~",cnt),"|"),$c(13,10))	//názevy
 			s @tiskglb@(idTab,"SL",cnt,"Format")=$p($g(PripravaDat(2)),"~",cnt)						//formát
 			s @tiskglb@(idTab,"SL",cnt,"Typ")=$p($g(PripravaDat(3)),"~",cnt)						//typ
 		}
 		//data do tabulky
 		s abcidx="" f {
	 		s zastavkaId="" s abcidx=$o(@tmpglblst@("IDX",abcidx),1,zastavkaId) i abcidx="" q
			s valDta=$g(@tmpglblst@("DTA",zastavkaId))
			s rd=$i(@tiskglb@(idTab,"RD")) s @tiskglb@(idTab,"RD",rd)=""
			s @tiskglb@(idTab,"Dta",rd,1)=zastavkaId
			s cnt="" f {
			 	s cnt=$o(arrItem(cnt)) i cnt="" q
			 	s val=$lg(valDta,cnt)
			 	i cnt=7 s val=$lts(val,",") i $e(val,$l(val))="," s val=$e(val,1,$l(val)-1)
			 	i cnt=17 s val=$lts(val,",") i $e(val,$l(val))="," s val=$e(val,1,$l(val)-1)
			 	i cnt=31 s val=$lts(val,",") i $e(val,$l(val))="," s val=$e(val,1,$l(val)-1)
			 	s sl=cnt+1
			 	s @tiskglb@(idTab,"Dta",rd,sl)=val
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
      s bigValue=""
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue(bigValue,"","")
      d item.UpdateStatus($$$BigStateTypeInformation,"pro všechny zastávky zadejte ""*""") 
      d list.Insert(item)
      // blizka obec
      s bigItem="blizkaObecId" s bigItemName="Blízká obec " s bigDataType=$$$BigItemDataTypeCodebook
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s bigValue=""
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      s item.CodebookType=$$$CodebookTypeISYBlizkeObce
      s item.MultiSelect=1
      d item.AddValue(bigValue,"","")
      d list.Insert(item)
      // tarifni zona
      s bigItem="zonaIDSId" s bigItemName="Tarifní zóna" s bigDataType=$$$BigItemDataTypeCodebook
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s bigValue=""
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      s item.CodebookType=$$$CodebookTypeISYTarifniZony
      s item.MultiSelect=1
	  d item.AddValue(bigValue,"","")
      d list.Insert(item)
      // provozovatel
      s bigItem="provozovatel" s bigItemName="Provozovatel" s bigDataType=$$$BigItemDataTypeText
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s bigValue=""
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      d item.AddValue($g(bigValue),"","")
      d list.Insert(item)
	  // skupinaLstId
      s bigItem="skupinaLstId" s bigItemName="Skupina Linek" s bigDataType=$$$BigItemDataTypeCodebook
      s bigRequired=0 s bigAllowEdit=1 s bigValidation=0
      s bigValue=""
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      s item.CodebookType=$$$CodebookTypeSkupinyLinek
      s item.MultiSelect=0
	  d item.AddValue(bigValue,"","")
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
