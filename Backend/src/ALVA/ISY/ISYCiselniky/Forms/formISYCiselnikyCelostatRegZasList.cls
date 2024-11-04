Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYCiselniky.Forms.formISYCiselnikyCelostatRegZasList Extends %RegisteredObject
{

/// 
/// Init gridu (seznam zastávek)
/// 
ClassMethod InitFg(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{	
		/*    				možné formáty sloupce
		AnoNe,	//ano ne 
				I,						  !!!	//IMG  neumí sloupec typu IMG 
				T, 		//String
				TL, 	//String link
				Tc, 	//String zarovnany na stred
				N, 		//intager
				NL,		//intager link
				Nc,		//intager zarovnany na stred
				N2|### ##0.####0,		// Double      |### ##0.####0 je volitelné nemusí být
				D,		// Date
				DT,		// Date time        
				B,		// boolean
				CBO		//Combobox
				*/
		//$lb("ITEM",id sloupce,název sloupce,typ,*editable -defaultně ne nemusí se vyplňovat)   barvy fungují jen pokud se zapnou (spomaluje načítání gridu)		 
		 $$$FillParams 
		 k output
		 s output($i(i))=$lts($lb("ITEM","obec","Obec","T",""),del)
		 s output($i(i))=$lts($lb("ITEM","castObce","Část obce","T",""),del)
		 s output($i(i))=$lts($lb("ITEM","lokalita","Lokalita","T",""),del)
		 s output($i(i))=$lts($lb("ITEM","blizkaObec","Blízká obec","T",""),del)
		 s output($i(i))=$lts($lb("ITEM","cisloRegistr","Centrální registr","N",""),del)
		 m ^||ML("OUT")=output
	}
	catch (ex){$$$CatchErrRest}
	q ret
}

/// 
/// Load gridu (načtení jednotlivých řádek)
/// 
ClassMethod LoadFg(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		$$$FillParams
		$$$TMPGLBSET(tmpglblst)
		//
		k arrDta s arrDta("GLB")=tmpglblst s zobrazitZaznamu=""
		//pribalim filter
		s idx="" f {   
			s val="" s idx=$o(^||ML("IN",idx),1,val) i idx="" q 
			i $p(val,del,1)="Filter"{
				s filterId=$p(val,del,2) s filterVal=$p(val,del,3)
				i filterVal'="" {
					i filterId="txbNazev" s arrDta("PAR","hledanyText")=filterVal
					i filterId="txbBlizkaObec" s $li(arrDta("PAR","blizkaObecLstId"),$ll($g(arrDta("PAR","blizkaObecLstId")))+1)=filterVal
					i filterId="intDocCount" s zobrazitZaznamu=filterVal					
				}
			} 
		} 
		//u původného se volalo   ALVA.JRZAST.IO.fndZstCRZ
		d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyCRZ).seznam(.sys,.arrDta)
		//
		//arr("DTA",id)=$lb(dta,dta,...) nebo @arr("GLB")@("DTA",id)=$lb(dta,dta,...)
		//arr("IDX",abcidx)=id nebo @arr("GLB")@("IDX",abcidx)=id
		//
		s pocetZaznamu=0
		s abcidx="" f {
			s cisloRegistr="" s abcidx=$o(@tmpglblst@("IDX",abcidx),1,cisloRegistr) i (abcidx="")!(pocetZaznamu'<zobrazitZaznamu) q
			s val=$g(@tmpglblst@("DTA",cisloRegistr))
			s idRadku=cisloRegistr
			s name=$lg(val,1)_","_$lg(val,2)_","_$lg(val,3)_"/"_$lg(val,4)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"obec",$lg(val,1),"",name),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"castObce",$lg(val,2),"",name),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"lokalita",$lg(val,3),"",name),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"blizkaObec",$lg(val,4),"",name),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"cisloRegistr",cisloRegistr,"",name),del)
			s pocetZaznamu=$i(pocetZaznamu)
		}
		
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

/// 
/// Zavede zastávky z centrálního registru do DB
/// 
ClassMethod ZavedstZastavkuDoDB(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		$$$FillParams
		//načtu vstup
		s idx="" s id=""
				for
				{
					s idx=$o(^||ML("IN",idx),1,radka) i idx="" q
						s val=$listfromstring(radka,del)
						i $lg(val,1)="Zas"{
							s $li(id,$ll(id)+1)=$lg(val,2)
							}          
				}
				k arrDta d ##class(ALVA.ISY.ISYZastavky.API.zastavkyCRZFce).prevodCRZDoZastavky(.sys,id,.arrDta)
		//výstup
		s arrDta("DTA")=$g(arrDta("DTA"))
		s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("MSG","","Počet označených zastávek pro převod: "_+$lg(arrDta("DTA"),1)),del)
		s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("MSG","","Počet dohledaných a nezavedených: "_+$lg(arrDta("DTA"),2)),del)
		s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("MSG","","Počet nově zavedených: "_+$lg(arrDta("DTA"),3)),del)
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

}
