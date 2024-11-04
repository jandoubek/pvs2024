Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY, ALVAEDREPORTS)

Class ALVA.ISY.ISYCiselniky.Forms.formISYCiselnikyObecny Extends %RegisteredObject
{

ClassMethod Load(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		$$$FillParams			
		s idx="" for {
					s idx=$o(^||ML("IN",idx),1,radka) i idx="" q
						s list= $listfromstring(radka,del)
						i $lg(list,1)="IdCis"{s IdCis=($lg(list,2)) }      
				}     		
		k output 
				if (IdCis=$$$CodebookTypeISYBlizkeObce){} 
		m ^||ML("OUT")=output
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

ClassMethod InitFg(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{				 
		$$$FillParams	
		s idx ="" 
				for {
					s idx=$o(^||ML("IN",idx),1,radka) i idx="" q
						s list=$listfromstring(radka,del)
						if $lg(list,1)="IdCis" { s IdCis=($lg(list,2)) }      
				} 
				if ($g(IdCis)="") {s err= "nepřišlo id číselníku" ztrap }
				
				k ^dz s ^dz("InitFg")=$lb(IdCis)
				
				if (IdCis=$$$CodebookTypeISYBlizkeObce) { d ##class(ALVA.ISY.ISYCiselniky.API.BlizkeObce).InitFg(.sys,.output) } 
				if (IdCis=$$$CodebookTypeISYSkupinyZastavekProSlevu) {d ##class(ALVA.ISY.ISYCiselniky.API.SkupinyZastavekProSlevu).InitFg(.sys,.output) } 
				if (IdCis=$$$CodebookTypeISYTarifniZony) {d ##class(ALVA.ISY.ISYCiselniky.API.TarifniZony).InitFg(.sys,.output) } 
				if (IdCis=$$$CodebookTypeISYLinky) {d ##class(ALVA.ISY.ISYCiselniky.API.Linky).InitFg(.sys,.output) } 
				
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
		
		s idx ="" for {
					s idx=$o(^||ML("IN",idx),1,radka) i idx="" q
						s list= $listfromstring(radka,del)
						if $lg(list,1)="IdCis"{s IdCis=($lg(list,2)) }      
				} 
				if ($g(IdCis)=""){s err= "nepřišlo id číselníku" ztrap}
				
				k ^dz s ^dz("LoadFg")=$lb(IdCis)
				
				if (IdCis=$$$CodebookTypeISYBlizkeObce) {d ##class(ALVA.ISY.ISYCiselniky.API.BlizkeObce).LoadFg(.sys,.output) } 
				if (IdCis=$$$CodebookTypeISYSkupinyZastavekProSlevu) {d ##class(ALVA.ISY.ISYCiselniky.API.SkupinyZastavekProSlevu).LoadFg(.sys,.output) }  
				if (IdCis=$$$CodebookTypeISYTarifniZony) {d ##class(ALVA.ISY.ISYCiselniky.API.TarifniZony).LoadFg(.sys,.output) } 
				if (IdCis=$$$CodebookTypeISYLinky) {d ##class(ALVA.ISY.ISYCiselniky.API.Linky).LoadFg(.sys,.output) } 
				
		m ^||ML("OUT")=output
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

ClassMethod Save(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		$$$FillParams		
		s idx ="" for {
					s idx=$o(^||ML("IN",idx),1,radka) i idx="" q
						s list= $listfromstring(radka,del)
						i $lg(list,1)="IdCis"{s IdCis=($lg(list,2)) }      
				}     
				k output		
		m ^||ML("OUT")=output
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
		s idx ="" s IdCis=""
				for
				{
					s idx=$o(^||ML("IN",idx),1,radka) q:idx=""
						s list= $listfromstring(radka,del)
						if $lg(list,1)="IdCis"{s IdCis=($lg(list,2)) }      
						if $lg(list,1)="Item"{s item($lg(list,2))="" }                  	
				} 
				if ($g(IdCis)=""){s err= "nepřišlo id číselníku" ztrap}        
				k output
				s polozkaId="" f {
					s polozkaId=$o(item(polozkaId)) i polozkaId="" q
					if (IdCis=$$$CodebookTypeISYBlizkeObce)
					{
						d ##class(ALVA.ISY.ISYCiselniky.API.BlizkeObce).vymaz(.sys,polozkaId,"")
						s output($i(i))=$lts($lb("MSG","","položka '"_polozkaId_"' byla odstraněna"),del)      
					} 
					if (IdCis=$$$CodebookTypeISYSkupinyZastavekProSlevu)
					{
						k arrDta
						d ##class(ALVA.ISY.ISYCiselniky.API.SkupinyZastavekProSlevu).nacti(.sys,polozkaId,.arrDta)
						s nazev=$lg($g(arrDta("DTA")),1)
						k arrDta
						d ##class(ALVA.ISY.ISYCiselniky.API.SkupinyZastavekProSlevu).vymaz(.sys,polozkaId,"")
						s output($i(i))=$lts($lb("MSG","","položka '"_polozkaId_" / "_nazev_"' byla odstraněna"),del)      
					} 
					if (IdCis=$$$CodebookTypeISYTarifniZony)
					{
						k arrDta
						d ##class(ALVA.ISY.ISYCiselniky.API.TarifniZony).nacti(.sys,polozkaId,.arrDta)
						s popisKratky=$lg($g(arrDta("DTA")),1)
						k arrDta
						d ##class(ALVA.ISY.ISYCiselniky.API.TarifniZony).vymaz(.sys,polozkaId,"")
						s output($i(i))=$lts($lb("MSG","","položka '"_polozkaId_" / "_popisKratky_"' byla odstraněna"),del)     
					} 
				} 
		m ^||ML("OUT")=output
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

}
