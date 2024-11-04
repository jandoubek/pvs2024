Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYCiselniky.Forms.formISYCiselnikySkupinyLicenciList Extends %RegisteredObject
{

/// 
/// Init gridu (seznam zastávek)
/// 
ClassMethod InitFg(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
#;      možné formáty sloupce
#;      AnoNe,   //ano ne 
#;        I,                   !!! //IMG  neumí sloupec typu IMG 
#;        T,     //String
#;        TL,    //String link
#;        Tc,    //String zarovnany na stred
#;        N,     //intager
#;        NL,    //intager link
#;        Nc,    //intager zarovnany na stred
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
			s output($i(i))=$lts($lb("ITEM","skupinaId","Id","N",""),del)
			s output($i(i))=$lts($lb("ITEM","nazev","Název","T",""),del)
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
			k vstup,vystup
			s err=$$gCis^JRapi(IdFa,dataDB,19,.vstup,.vystup) i err ztrap
			s id=""
			f {
				 s id=$o(vystup("arr",id),1,nazev) q:id=""
				 s idRadku=id
				 s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"skupinaId",id,"",nazev),del)
				 s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"nazev",nazev,"",nazev),del)
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
			s usr=userID_"|"_loginName_"|"_userName  
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
					 k aIn,aOut
					 s err=$$gCisItm^JRapi(IdFa,dataDB,19,polozkaId,.aIn,.aOut) i err ztrap
					 s nazev=$g(aOut("arr",polozkaId))
					 s err=$$dCisItm^JRapi(IdFa,dataDB,19,polozkaId,.aIn,.aOut,.usr) i err ztrap
					 s output($i(i))=$lts($lb("MSG","","položka '"_polozkaId_" / "_nazev_"' byla odstraněna"),del)      
			 }  
			m ^||ML("OUT")=output
	 }
	 catch (ex) {$$$CatchErrRest}
	 q ret
}

}
