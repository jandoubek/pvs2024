Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYCiselniky.API.Linky Extends %RegisteredObject
{

ClassMethod InitFg(ByRef sys As %String, ByRef out As %String) As %String
{
	$$$FillParams
	
	s out($i(i))=$lts($lb("ITEM","S","Skupina","T"),del)
	s out($i(i))=$lts($lb("ITEM","I","Linka","T"),del)
	s out($i(i))=$lts($lb("ITEM","N","Název","T"),del)
	s out($i(i))=$lts($lb("ITEM","P","Platnost","T"),del)	
	
	q 0
}

ClassMethod LoadFg(ByRef sys As %String, ByRef out As %String) As %String
{
	$$$FillParams
	
	s idx="" for {
		s idx=$o(^||ML("IN",idx),1,radka) i idx="" q
				s list=$listfromstring(radka,del)
				if $lg(list,1)="SKUPINA" { if $lg(list,2)'="" { s skupF($lg(list,2))="" } }      
		}
		
	k cisA d ##class(ALVA.ISY.ISYJR.API.CIS).gC(IdFa,2,.cisA)
	
	s skup="" f {
		s skup=$o(^[dataDB]JRL(skup)) q:skup=""
		if $e(skup,1,3)="tmp" { continue }
		if $d(skupF) { if $d(skupF(skup))=0 { continue } }
		s id="" f {
			s id=$o(^[dataDB]JRL($g(skup),id)) q:id=""
			k dP m dP=^[dataDB]JRL($g(skup),id,"I")					
			s p=##class(ALVA.ISY.ISYJR.Forms.formISYJRMain).gPopL(.dP)
			s plati=$g(^[dataDB]JRL($g(skup),id,"PATCH","Plati"))
			s od=$p(plati,"~",1)	
			s do=$p(plati,"~",2)
			s upr=od_" "_do	
			s linka=$e(id,2,7)
			s idx=linka
			s out($i(i))=$lts($lb("ITEM",idx,"S",skup),del)
			s out($i(i))=$lts($lb("ITEM",idx,"I",linka),del)
			s out($i(i))=$lts($lb("ITEM",idx,"N",p),del)
			s out($i(i))=$lts($lb("ITEM",idx,"P",upr),del)
		}
	}
	
	q 0
}

}
