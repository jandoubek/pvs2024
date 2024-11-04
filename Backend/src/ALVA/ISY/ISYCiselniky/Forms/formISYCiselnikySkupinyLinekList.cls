Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYCiselniky.Forms.formISYCiselnikySkupinyLinekList Extends %RegisteredObject
{

ClassMethod InitFg(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	$$$FillParams
	
	try 
	{	
		k output
		s output($i(i))=$lts($lb("ITEM","skupinaId","#","N",""),del)
		s output($i(i))=$lts($lb("ITEM","nazev","Název","T",""),del)
		s output($i(i))=$lts($lb("ITEM","skupinaTyp","Typ","T",""),del)
		s output($i(i))=$lts($lb("ITEM","platiOd","Platí od","D",""),del)
		s output($i(i))=$lts($lb("ITEM","platiDo","Platí do","D",""),del)
		s output($i(i))=$lts($lb("ITEM","uzamcenoZmeny","Uzamčeno"_$c(13,10)_"změny","B",""),del)
		s output($i(i))=$lts($lb("ITEM","obsahujeLinky","Obsahuje"_$c(13,10)_"linky","B",""),del)
		s output($i(i))=$lts($lb("ITEM","obsahujeOdjezdy","Obsahuje"_$c(13,10)_"odjezdy","B",""),del)
		s output($i(i))=$lts($lb("ITEM","obsahujePrijezdy","Obsahuje"_$c(13,10)_"příjezdy","B",""),del)
		s output($i(i))=$lts($lb("ITEM","obsahujeObehy","Obsahuje"_$c(13,10)_"oběhy","B",""),del)
		
		m ^||ML("OUT")=output
	}
	catch (ex){$$$CatchErrRest}
	q ret
}

ClassMethod LoadFg(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		$$$FillParams		
		$$$TMPGLBSET(tmpglblst)
		
		k arrCisTypySkupinLinek d ##class(ALVA.ISY.ISYCiselniky.API.TypySkupinLinek).seznam(.sys,.arrCisTypySkupinLinek)
		
		k filtr m filtr=^[dataDB]JRR("SkupFiltr",userID)
		
		k arr s arr("GLB")=tmpglblst
		
		if $d(filtr("NAZEV")) { s arr("PAR","hledanyText")=$o(filtr("NAZEV","")) }
		
		d ##class(ALVA.ISY.ISYCiselniky.API.SkupinyLinek).seznam(.sys,.arr) i +err zt
		
		s abcidx="" f {
			s skupinaId="" s abcidx=$o(@tmpglblst@("IDX",abcidx),1,skupinaId) i abcidx="" q
			
			if $d(filtr("SKUPINA")) { if $o(filtr("SKUPINA",""))'="" { if skupinaId'=$o(filtr("SKUPINA","")) { continue } } }
			
			s valDta=$g(@tmpglblst@("DTA",skupinaId))
			s idRadku=skupinaId
			s name=$lg(valDta,1) 
						
			s typSkupinyLinekId=$lg(valDta,7) s typSkupinyLinekNazev=""
			i typSkupinyLinekId'="" { s typSkupinyLinekNazev=typSkupinyLinekId_" | "_$lg($g(arrCisTypySkupinLinek("DTA",typSkupinyLinekId)),1) }
			
			if $d(filtr("TYP")) {
				if $o(filtr("TYP",""))'="" { 
					if typSkupinyLinekId'=$o(filtr("TYP","")) { continue } 
					if typSkupinyLinekId="" { continue }
				}
			}
			
			s horlogOd=$lg(valDta,2) s datumOd="" i horlogOd s datumOd=##class(ALVA.GENERALAPI.Date).horToDate(horlogOd) 
			s horlogDo=$lg(valDta,3) s datumDo="" i horlogDo s datumDo=##class(ALVA.GENERALAPI.Date).horToDate(horlogDo) 
			
			if $d(filtr("DATUM_OD")) { s dOdF=$o(filtr("DATUM_OD","")) }
			if $d(filtr("DATUM_DO")) { s dDoF=$o(filtr("DATUM_DO","")) }
								
			if ($g(dOdF)'="") {
				if $g(datumOd)="" { continue }
				s datH=##class(ALVA.GENERALAPI.Date).DateToHor(datumOd)
				s dOdFH=##class(ALVA.GENERALAPI.Date).DateToHor(dOdF)                
				if (datH<dOdFH) { continue }
			}
			if $g(dDoF)'="" {
				if $g(datumDo)="" { continue }
				s datH=##class(ALVA.GENERALAPI.Date).DateToHor(datumDo)                  
				s dDoFH=##class(ALVA.GENERALAPI.Date).DateToHor(dDoF)
				if (datH>dDoFH) { continue }
			}
			
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"skupinaId",skupinaId,"",name),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"nazev",name,"",name),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"skupinaTyp",typSkupinyLinekNazev,"",name),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"platiOd",datumOd,"",name),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"platiDo",datumDo,"",name),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"uzamcenoZmeny",(+$lg(valDta,4)),"",name),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"obsahujeLinky",($o(^[dataDB]JRL(skupinaId,""))'=""),"",name),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"obsahujeOdjezdy",($o(^[dataDB]JRi("Odj",skupinaId,""))'=""),"",name),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"obsahujePrijezdy",($o(^[dataDB]JRi("Pri",skupinaId,""))'=""),"",name),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"obsahujeObehy",($d(^[dataDB]ALVA.ISY.OBH("IDX",1,skupinaId))>0),"",name),del)
		}
		k @tmpglblst
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

ClassMethod Delete(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		$$$FillParams
		
		s idx="" k item for {
			s idx=$o(^||ML("IN",idx),1,radka) q:idx=""
			s list= $listfromstring(radka,del)
			if $lg(list,1)="Item"{s item($lg(list,2))="" }
		}  
		
		k output s polozkaId="" f {
			s polozkaId=$o(item(polozkaId)) i polozkaId="" q
			k arrDta
			d ##class(ALVA.ISY.ISYCiselniky.API.SkupinyLinek).nacti(.sys,polozkaId,.arrDta)
			s nazev=$lg($g(arrDta("DTA")),1)
			k arrDta
			d ##class(ALVA.ISY.ISYCiselniky.API.SkupinyLinek).vymaz(.sys,polozkaId,"")
			s output($i(i))=$lts($lb("MSG","","položka '"_polozkaId_" / "_nazev_"' byla odstraněna"),del)      
		}
		
		m ^||ML("OUT")=output
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

ClassMethod getFiltr(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	 $$$Init
	 $$$FillParams
	 
	 try 
	 {
		k data m data=^[dataDB]JRR("SkupFiltr",userID)
		s filtrText=""
		if $o(data("SKUPINA",""))'="" { s filtrText="Skupina: "_$o(data("SKUPINA","")) }
		if $o(data("NAZEV",""))'="" { s filtrText=filtrText_" Název: "_$o(data("NAZEV","")) }
		if $o(data("TYP",""))'="" { s filtrText=filtrText_" Typ: "_$o(data("TYP",""))_" | "_$p($g(^[dataDB]JRSET("Definice","SKSKU",$o(data("TYP","")))),"~",1)  }
		if $o(data("DATUM_OD",""))'="" { s filtrText=filtrText_" Datum od: "_$o(data("DATUM_OD","")) }
		if $o(data("DATUM_DO",""))'="" { s filtrText=filtrText_" Datum do: "_$o(data("DATUM_DO","")) }
		
		s filtrText=##class(ALVA.GENERALAPI.String).Trim(filtrText)
		s output($i(i))="F"_del_filtrText
			
		m ^||ML("OUT")=output
		
	 }
	 catch (ex)  { $$$CatchErrRest }
	 q ret
}

}
