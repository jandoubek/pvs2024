Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY, ALVAEDREPORTS)

Class ALVA.ISY.ISYCiselniky.Forms.formISYLinkyTiskMHDNadpisy Extends %RegisteredObject
{

ClassMethod init(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{
		$$$FillParams
		$$$InputParams

		s output($i(i))=$lts($lb("ITEM","K","Kód","T"),del)
		s output($i(i))=$lts($lb("ITEM","P","Popis","T"),del)		
		
		m ^||ML("OUT")=output
	}
	catch (ex)  { $$$CatchErrRest }
	q ret
}

ClassMethod refresh(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try
	{
		$$$FillParams
		$$$InputParams
		
		s dataDB=##class(ALVA.GENERALAPI.DataBase).dataDB(IdFa)
		
		k data m data=^[dataDB]JRSET("LinkyTiskMHDNadpisy")
				
		s kod="" f {
			s kod=$o(data(kod)) q:kod=""
			s v=$g(data(kod,"KOD"))
			s n=$g(data(kod,"POP"))
			
			s idx=kod
			s output($i(i))=$lts($lb("ITEM",idx,"K",$g(kod)),del)
			s output($i(i))=$lts($lb("ITEM",idx,"P",$g(n)),del)			
		}
		
		m ^||ML("OUT")=output
	}
	catch (ex) { $$$CatchErrRest }
	q ret
}

ClassMethod del(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	
	try {
		$$$FillParams 
		
		s idx=""  for {
			s idx=$o(^||ML("IN",idx),1,radka) q:idx=""
			s list=$lfs(radka,del)
			if $lg(list,1)="ID" { s idS($lg(list,2))="" }
		}
		
		if $o(idS(""))="" { s err="Není vyplněné [ID]" ztrap }		
				
		s id="" f {		 
			s id=$o(idS(id)) q:id=""
			k ^[dataDB]JRSET("LinkyTiskMHDNadpisy",id)
			s ^||ML("OUT",$i(i))="MSG"_del_del_"Byl smazán záznam ["_id_"]"
		}
	
	}
	catch (ex) { $$$CatchErrRest }
	q ret
}

}
