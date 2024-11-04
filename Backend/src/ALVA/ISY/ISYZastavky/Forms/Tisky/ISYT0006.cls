Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAEDREPORTS, ALVAISY)

Class ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0006 Extends %RegisteredObject
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
		
		//vyhledani zastavek
		d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).seznam(.sys,.arr)
		
		//vyhledani linek
		s skupinaId="" f {
			s skupinaId=$o(filtr("skupinaProLinLstId",skupinaId)) i skupinaId="" q
			s linkaId="" f {
				s linkaId=$o(^[dataDB]JRL(skupinaId,linkaId)) i linkaId="" q
				k arrTrs s sc=$$gTrsLin^JRapi(IdFa,dataDB,skupinaId,linkaId,"",.arrTrs) i sc zt
				s tc="" f {
					s tc=$o(arrTrs("arr",tc)) i tc="" q
					s zastavkaId=+$g(arrTrs("arr",tc,"dta",1))
					i $d(@tmpglblst@("DTA",zastavkaId)) {
						s @tmpglblst@("DTA",zastavkaId,"linky",skupinaId,linkaId)=""
					}
				}	
			}
		}
		
		//filtr("skupinaProLinLstId",id)
		//definice tabulky
		k ^CacheTempSS(idglb) s tiskglb=$name(^CacheTempSS(idglb,"OUT","mltab"))
		s idTab="TAB"
		s nadpis="ISYT0006"
		s title="Přehled linek pro zastávku"	
		s nadpis2="Přehled linek pro zastávku"
		s nadpis3="Přehled linek pro zastávku"
		s @tiskglb=idTab
 		s @tiskglb@(idTab,"STYP")="T" 		
 		s @tiskglb@(idTab,"Name")=title_" (dne: "_##class(ALVA.GENERALAPI.Date).horToDate($h)_")"
 		s @tiskglb@(idTab,"Format")="<"
 		s @tiskglb@(idTab,"Long")=""
 		// odkaz v combu
 		s @tiskglb@(idTab,"Index",idTab)=@tiskglb@(idTab,"Name")
 		k arrItem
 		s arrItem(1)=$lb("Číslo/Id","N")
 		s arrItem(2)=$lb("Obec","T")
 		s arrItem(3)=$lb("Část obce","T")
 		s arrItem(4)=$lb("Lokalita","T")
 		s arrItem(5)=$lb("Blízká obec","T")
 		s arrItem(6)=$lb("Zóna","T")
 		s arrItem(7)=$lb("Skupina","N")
 		s arrItem(8)=$lb("Linky","T")
 		s arrItem(9)=$lb("Linky IDS","T")
	 	s cnt="" f {
		 	s val="" s cnt=$o(arrItem(cnt),1,val) i cnt="" q
		 	s @tiskglb@(idTab,"SL",cnt)=$lg($g(arrItem(cnt)),1)								//název
 			s @tiskglb@(idTab,"SL",cnt,"Format")=$s($lg($g(arrItem(cnt)),2)="N":">",1:"<")	//formát
 			s @tiskglb@(idTab,"SL",cnt,"Typ")=$lg($g(arrItem(cnt)),2)						//typ
	 	}	
 		//data do tabulky
 		s abcidx="" f {
	 		s zastavkaId="" s abcidx=$o(@tmpglblst@("IDX",abcidx),1,zastavkaId) i abcidx="" q
			s valDta=$g(@tmpglblst@("DTA",zastavkaId))
			s skupinaId="" f {
				s skupinaId=$o(@tmpglblst@("DTA",zastavkaId,"linky",skupinaId)) i skupinaId="" q
				s linkaTx="" s linkaIDSTx=""
				s linkaId="" f {
					s linkaId=$o(@tmpglblst@("DTA",zastavkaId,"linky",skupinaId,linkaId)) i linkaId="" q
					s cisloLinkyIDS="" s cisloLinkyDleLicence = $$cnvIndLin^JRapi(linkaId)
					s val=$p($g(^[dataDB]JRL(skupinaId,linkaId,"PATCH","cisIDS")),"~",1,3)
					i +val {
						s cisloLinkyIDS=$p(val,"~",2)
						i cisloLinkyIDS="" {
							s cisloLinkyIDS=$e(cisloLinkyDleLicence,4,6)
						}
					}
					i linkaTx'="" s linkaTx=linkaTx_","
					s linkaTx=linkaTx_$$cnvIndLin^JRapi(linkaId)
					//
					i cisloLinkyIDS'="" {
						i linkaIDSTx'="" s linkaIDSTx=linkaIDSTx_","
						s linkaIDSTx=linkaIDSTx_cisloLinkyIDS
					}
				}
				s rd=$i(@tiskglb@(idTab,"RD")) s @tiskglb@(idTab,"RD",rd)=rd
			
				s @tiskglb@(idTab,"Dta",rd,1)=zastavkaId
				s @tiskglb@(idTab,"Dta",rd,2)=$lg(valDta,1)
				s @tiskglb@(idTab,"Dta",rd,3)=$lg(valDta,2)
				s @tiskglb@(idTab,"Dta",rd,4)=$lg(valDta,3)
				s @tiskglb@(idTab,"Dta",rd,5)=$lg(valDta,4)
				s @tiskglb@(idTab,"Dta",rd,6)=$lg(valDta,15)
				s @tiskglb@(idTab,"Dta",rd,7)=skupinaId
				s @tiskglb@(idTab,"Dta",rd,8)=linkaTx
				s @tiskglb@(idTab,"Dta",rd,9)=linkaIDSTx
				
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
	  s bigGroup="G1" s bigGroupName="Nastavení pro výběr zastávek"     
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
      //
      s bigGroup="G2" s bigGroupName="Nastavení pro výběr linek"
      // skupinaLstId
      s bigItem="skupinaProLinLstId" s bigItemName="Linky vypsat ze skupiny" s bigDataType=$$$BigItemDataTypeCodebook
      s bigRequired=1 s bigAllowEdit=1 s bigValidation=0
      s bigValue=""
      s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,bigGroup,bigGroupName,bigItem,bigItemName,bigDataType,bigRequired,bigAllowEdit,bigValidation,"")
      s item.CodebookType=$$$CodebookTypeSkupinyLinek
      s item.MultiSelect=1
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
