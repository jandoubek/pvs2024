Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY, ALVAISY3)

Class ALVA.ISY.ISYCiselniky.Forms.formISYCiselnikyJBNList Extends %RegisteredObject
{

ClassMethod InitFg(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
#;      možné formáty sloupce
#;      AnoNe,   //ano ne 
#;        I,                   !!! //IMG  neumí sloupec typu IMG 
#;        T,     //String
#;        TL,    //String link
#;        Tc,    //String zarovnany na stred
#;        N,     //integer
#;        NL,    //integer link
#;        Nc,    //integer zarovnany na stred
#;        N2|### ##0.####0,     // Double      |### ##0.####0 je volitelné nemusí být
#;        D,     // Date
#;        DT,    // Date time        
#;        B,     // boolean
#;        CBO    //Combobox
#;        
#;      $lb("ITEM",id sloupce,název sloupce,typ,*editable -defaultně ne nemusí se vyplňovat)   barvy fungují jen pokud se zapnou (spomaluje načítání gridu)     

	 $$$Init
	 try 
	 {
				
			$$$FillParams 
			k output
			s output($i(i))=$lts($lb("ITEM","id","Id","N",""),del)
			s output($i(i))=$lts($lb("ITEM","kilometry","Kilometry","N",""),del)
			s output($i(i))=$lts($lb("ITEM","odmena","Odměna","N",""),del)
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
				s cisloLicence=""
				s index=""
				f  {
						s index=$o(^||ML("IN",index),1,param) q:index=""
				}

				k arrDta
				d ##class(ALVA.ISY.ISYCiselniky.API.JBN).seznam(.sys,.arrDta)
				s id=""
				f {
						k valDta s id=$o(arrDta("DTA",id),1,valDta) i id = "" q
						s idRadku=id
						s kilometry = $lg(valDta,2)
						s odmena = $lg(valDta,3)
						s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"id",id,"",id),del)
						s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"kilometry",kilometry,"",id),del)
						s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"odmena",odmena,"",id),del)
			}
	 }
	 catch (ex) {$$$CatchErrRest}
	 q ret
}

/// 
/// Uložení okna po stisku OK
/// 
ClassMethod Save(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	 $$$Init
	 try 
	 {      
			$$$FillParams           
			m ^||ML("OUT")=output
	 }
	 catch (ex) {$$$CatchErrRest}
	 q ret
}

/// 
/// Odstraní položku
/// 
ClassMethod Delete(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	 $$$Init
	 try 
	 {      
			$$$FillParams
			#;
			s idx="" 
			k item
				for
				{
					 s idx=$o(^||ML("IN",idx),1,radka) q:idx=""
					 s list=$listfromstring(radka,del)
					 if $lg(list,1)="Item" {
							s item($lg(list,2))="" 
					 }          
				}  
				k output
				s polozkaId="" 
				f {
					 s polozkaId=$o(item(polozkaId)) q:polozkaId=""
					 k arrDta d ##class(ALVA.ISY.ISYCiselniky.API.JBN).vymaz(.sys,polozkaId,.arrDta)
					 s output($i(i))=$lts($lb("MSG","","položka '"_polozkaId_"' byla odstraněna"),del)      
			 }  
			m ^||ML("OUT")=output
	 }
	 catch (ex) {$$$CatchErrRest}
	 q ret
}

}
