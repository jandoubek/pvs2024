Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY, ALVAISY3)

Class ALVA.ISY.ISYCiselniky.Forms.formISYCiselnikyLicenceList Extends %RegisteredObject
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
			s output($i(i))=$lts($lb("ITEM","licence","Licence","T",""),del)
			s output($i(i))=$lts($lb("ITEM","platido","Platí do","D",""),del)
			s output($i(i))=$lts($lb("ITEM","vydal","Vydal","T",""),del)
			s output($i(i))=$lts($lb("ITEM","vydanadne","Vydána dne ","D",""),del)
			s output($i(i))=$lts($lb("ITEM","jednacicislo","Jednací číslo","T",""),del)
			s output($i(i))=$lts($lb("ITEM","cislarozhodnuti","Čísla rozhodnutí","T",""),del)
			s output($i(i))=$lts($lb("ITEM","skupinalicenci","Skupina licencí","T",""),del)
			s output($i(i))=$lts($lb("ITEM","aktualizovano","Aktualizováno","D",""),del)
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
				 s param=$g(param)
				 i $p(param,del,1)="Filter",$p(param,del,2)="txbCisloLicence" s cisloZacina=$p(param,del,3)
			}

			#;skupiny licenci
			k vstup,vystup
			s err=$$gCis^JRapi(IdFa,dataDB,19,.vstup,.skupinylicenci) i err ztrap
			k vstup,vystup
			s err=$$lLic^JRapi(IdFa,dataDB,"",.vstup,.vystup) i err ztrap
			s id=""
			f {
				 s id=$o(vystup("arr",1,id)) q:id=""
				 i $l(cisloZacina),$e($e(id,2,7),1,$l(cisloZacina))'=cisloZacina continue
				 s err=$$gLic^JRapi(IdFa,dataDB,id,.vstupL,.vystupL) i err ztrap
				 #;
				 s cislarozhodnuti=""
				 s idr=""
				 f {
						s idr=$o(vystupL("arr",3,idr)) q:idr=""
						s rozhodnuti=$g(vystupL("arr",3,idr,"dta",1))
						i rozhodnuti'="" {
							 s cislarozhodnuti=cislarozhodnuti_$s(cislarozhodnuti'="":", ",1:"")_rozhodnuti
						}
				 }
				 #;
				 s idRadku=id
				 s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"licence",$e(id,2,7),"",id),del)
				 s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"platido",vystupL("dta",5),"",id),del)
				 s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"vydal",vystupL("dta",3),"",id),del)
				 s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"vydanadne",vystupL("dta",4),"",id),del)
				 s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"jednacicislo",vystupL("dta",2),"",id),del)
				 s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"cislarozhodnuti",cislarozhodnuti,"",id),del)
				 s idsl=vystupL("dta",6)
				 s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"skupinalicenci",$s(idsl'="":$g(skupinylicenci("arr",idsl)),1:""),"",id),del)
				 s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"aktualizovano",vystupL("dta",1),"",id),del)
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
					 s err=$$dLic^JRapi(IdFa,dataDB,polozkaId,.aIn,.aOut,.usr) i err ztrap
					 s output($i(i))=$lts($lb("MSG","","položka '"_polozkaId_" / "_$e(polozkaId,2,7)_"' byla odstraněna"),del)      
			 }  
			m ^||ML("OUT")=output
	 }
	 catch (ex) {$$$CatchErrRest}
	 q ret
}

}
