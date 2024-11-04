Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAEDREPORTS, ALVAISY)

Class ALVA.ISY.ISYZastavky.Forms.Tisky.ISYT0003 Extends %RegisteredObject
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
		
		m input("id")=param("SelectedItems")
		s selectedZastavky = "" s skupinaLinek = ""
		s zastId = "" f {
			s zastId = $o(input("id",zastId)) i zastId = "" q
			s $list(selectedZastavky, *+1) = zastId
		}
		//vyhledani linek
		s skupinaId="" f {
			s skupinaId=$o(filtr("skupinaLinek",skupinaId)) i skupinaId="" q
			s $list(skupinaLinek,*+1) = skupinaId
			s linkaId="" f {
				s linkaId=$o(^[dataDB]JRL(skupinaId,linkaId)) i linkaId="" q
				k arrTrs s sc=$$gTrsLin^JRapi(IdFa,dataDB,skupinaId,linkaId,"",.arrTrs) i sc zt
				s tc="" f {
					s tc=$o(arrTrs("arr",tc)) i tc="" q
					s zastavkaId=+$g(arrTrs("arr",tc,"dta",1))
					i $lf(selectedZastavky,zastavkaId) s @tmpglblst@("DTA",zastavkaId,"linky",skupinaId,linkaId)=""
				}	
			}
		}
		
		
		//definice tabulky
		k ^CacheTempSS(idglb) s tiskglb=$name(^CacheTempSS(idglb,"OUT","mltab"))
		s idTab="TAB"
		s nadpis="ISYT0003"
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
 		
		
		//vyhledani zastavek
		k arr s arr("GLB")=tmpglblst 
		s arr("PAR","hledanyText")="*"
		s arr("PAR","skupinaLstId") = skupinaLinek
		d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).seznam(.sys,.arr)
		
		//data do tabulky
 		s abcidx="" f {
	 		s zastavkaId="" s abcidx=$o(@tmpglblst@("IDX",abcidx),1,zastavkaId) i abcidx="" q
			i '$lf(selectedZastavky,zastavkaId) continue
			s valDta=$g(@tmpglblst@("DTA",zastavkaId))
			s skupinaId="" f {
				s skupinaId=$o(@tmpglblst@("DTA",zastavkaId,"linky",skupinaId)) i skupinaId="" q
				s linkaTx="" s linkaIDSTx=""
				s linkaId="" f {
					s linkaId=$o(@tmpglblst@("DTA",zastavkaId,"linky",skupinaId,linkaId)) i linkaId="" q
					s cisloLinkyIDS=""
					s val=$p($g(^[dataDB]JRL(skupinaId,linkaId,"PATCH","cisIDS")),"~",1,3)
					i +val {
						s cisloLinkyIDS=$p(val,"~",2) s cisloLinkyDleLicence = $$cnvIndLin^JRapi(linkaId)
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
	  s bigGroup="G1" s bigGroupName="Obecné nastavení"     
	  // nazev obsahuje
      s bigItem="skupinaLinek" s bigItemName="Skupina Linek" s bigDataType=$$$BigItemDataTypeCodebook
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
