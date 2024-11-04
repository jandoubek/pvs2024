Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY, ALVAISY3)

Class ALVA.ISY.ISYCiselniky.Forms.formISYCiselnikyLicenceEdit Extends %RegisteredObject
{

ClassMethod ReadToTemporary(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	 $$$Init
	 try 
	 {     
			$$$FillParams     
			k $$$CTMPGLBFRM(GUID,"formISYCiselnikyLicenceEdit")
			s idx ="" 
			s ID=""
			f {
				 s idx=$o(^||ML("IN",idx),1,radka) q:idx=""
				 s list=$listfromstring(radka,del)
				 i $lg(list,1)="ID" {
						s ID=$lg(list,2) 
				 }          
			}
			s veta=$lb()
			i ID {
				 k aIn,aOut         
				 s err=$$gLic^JRapi(IdFa,dataDB,ID,.aIn,.aOut) i err ztrap
				 s $li(veta,1)=ID   
				 s $li(veta,2)=aOut("dta",1)   
				 s $li(veta,3)=$e(ID,2,7)   
				 s $li(veta,4)=aOut("dta",6)   
				 s $li(veta,5)=aOut("dta",3)   
				 s $li(veta,6)=aOut("dta",4)   
				 s $li(veta,7)=aOut("dta",5)   
				 s $li(veta,8)=aOut("dta",2)   
				 #;
				 k aInF,aOutF         
				 s aInF("Lic")=ID
				 s err=..PrilohaLicenceListToOut(.sys,.aInF,.aOutF) i err ztrap
				 i $d(aOutF(1,ID,"data","def")) {
						s vetaf=aOutF(1,ID,"data","def")
				 }else{
						s vetaf=$lb(1,ID,"",0,"","","","")
				 }
				 s $$$CTMPGLBFRM(GUID,"formISYCiselnikyLicenceEdit","fgSeznam","idx",ID_"#")=vetaf     
				 s cnt=""
				 f {
						s cnt=$o(aOut("arr",3,cnt)) q:cnt=""
						s jed=aOut("arr",3,cnt,"dta",1)
						i $d(aOutF(2,ID,jed,"data","def")) {
							 s vetaf=aOutF(2,ID,jed,"data","def")
						}else{
							 s vetaf=$lb(2,ID,jed,0,"","","","")
						}
						s $li(vetaf,5)=aOut("arr",3,cnt,"dta",2)
						s $$$CTMPGLBFRM(GUID,"formISYCiselnikyLicenceEdit","fgSeznam","idx",ID_"#"_jed)=vetaf     
				 } 
			}
			s $$$CTMPGLBFRM(GUID,"formISYCiselnikyLicenceEdit","ID")=ID
			s $$$CTMPGLBFRM(GUID,"formISYCiselnikyLicenceEdit","bigObec")=veta
	 }
	 catch (ex) {$$$CatchErrRest}
	 q ret
}

/// 
/// Uložení okna po stisku OK
/// 
ClassMethod WriteFromTemporary(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	 $$$Init
	 try 
	 {      
			$$$FillParams
			s usr=userID_"|"_loginName_"|"_userName 
			s veta=$$$CTMPGLBFRM(GUID,"formISYCiselnikyLicenceEdit","bigObec")
			s lic=$lg(veta,1)
			i 'lic {
				 s lic=+$lg(veta,3)
				 s lic=$$cnvCsLin^JRapi(lic)
			}
			k aIn,aOut
			s aIn("dta",1)=$li(veta,2)   
			s aIn("dta",2)=$li(veta,8)   
			s aIn("dta",3)=$li(veta,5)   
			s aIn("dta",4)=$li(veta,6)   
			s aIn("dta",5)=$li(veta,7)   
			s aIn("dta",6)=$li(veta,4)   
			s cnt=0
			s id=""
			f {
				 s id=$o($$$CTMPGLBFRM(GUID,"formISYCiselnikyLicenceEdit","fgSeznam","idx",id),1,vetaf) q:id=""
				 s typ=$lg(vetaf,1)
				 s jed=$lg(vetaf,3)
				 s poz=$lg(vetaf,8)
				 s filesaved=$lg(vetaf,4)
				 i typ=2 {
						s aIn("arr",3,$i(cnt),"dta",1)=jed
						s aIn("arr",3,cnt,"dta",2)=$lg(vetaf,5)
				 }
				 i 'filesaved {
						i typ=1 {
							 k ^[dataDB]JRlicf("L",lic)
						}elseif typ=2 {
							 k ^[dataDB]JRlicf("J",lic,jed)
						}
				 }else{
						i typ=1 {
							 s veta=^[dataDB]JRlicf("L",lic)
							 i poz'=$p(veta,"~",3) s ^[dataDB]JRlicf("L",lic)=$h_"~"_usr_"~"_poz
						}elseif typ=2 {
							 s veta=^[dataDB]JRlicf("J",lic,jed)
							 i poz'=$p(veta,"~",3) s ^[dataDB]JRlicf("J",lic,jed)=$h_"~"_usr_"~"_poz
						}
				 }  
			}
			s err=$$sLic^JRapi(IdFa,dataDB,lic,.aIn,.aOut,usr) i err ztrap
	 }
	 catch (ex) {$$$CatchErrRest}
	 q ret
}

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
			s output($i(i))=$lts($lb("ITEM","typ","Typ dokumentu","T",""),del)
			s output($i(i))=$lts($lb("ITEM","cislojednaci","Číslo jednací","T",""),del)
			s output($i(i))=$lts($lb("ITEM","datum","Datum vydání","D",""),del)
			s output($i(i))=$lts($lb("ITEM","poznamka","Poznámka","T",""),del)
			s output($i(i))=$lts($lb("ITEM","priloha","Příloha","B",""),del)
			s output($i(i))=$lts($lb("ITEM","file","Vstupní soubor","T",""),del)
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
			s id=""
			f {
				 s id=$o($$$CTMPGLBFRM(GUID,"formISYCiselnikyLicenceEdit","fgSeznam","idx",id),1,dta) q:id=""
				 s idRadku=id
				 s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"typ",$case($lg(dta,1),1:"Licence",2:"Rozhodnutí",:""),"",id),del)
				 s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"cislojednaci",$lg(dta,3),"",id),del)
				 s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"datum",$lg(dta,5),"",id),del)
				 s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"poznamka",$lg(dta,8),"",id),del)
				 s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"priloha",+$lg(dta,4),"",id),del)
				 s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"file",$lg(dta,9),"",id),del)
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
					 k $$$CTMPGLBFRM(GUID,"formISYCiselnikyLicenceEdit","fgSeznam","idx",polozkaId)
					 s output($i(i))=$lts($lb("MSG","","položka '"_polozkaId_"' byla odstraněna"),del)      
			 }  
			m ^||ML("OUT")=output
	 }
	 catch (ex) {$$$CatchErrRest}
	 q ret
}

ClassMethod PrilohaLicenceListToOut(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	 $$$Init
	 try {
			$$$FillParams
			k out
			s licv=$g(in("Lic"))
			s index=""
			s lic=""
			f {
				 s veta=""
				 s lic=$o(^[dataDB]JRlicf("L",lic),1,veta) q:lic=""
				 i licv'="",lic'=licv continue
				 s out(1,lic,"data","def")=$lb(1,lic,"",1,"",$$$ND($p(veta,"~",1)),$p(veta,"~",2),$p(veta,"~",3))
			}
			s lic=""
			f {
				 s lic=$o(^[dataDB]JRlicf("J",lic)) q:lic=""
				 i licv'="",lic'=licv continue
				 s jed=""
				 f {
						s veta=""
						s jed=$o(^[dataDB]JRlicf("J",lic,jed),1,veta) q:jed=""
						s out(2,lic,jed,"data","def")=$lb(2,lic,jed,1,"",$$$ND($p(veta,"~",1)),$p(veta,"~",2),$p(veta,"~",3))
				 }
			} 
	 }catch (ex) {
			$$$CatchErrRest
	 }
	 q ret
}

ClassMethod PrilohaLicenceToCache(ByRef sys As %String) As %String
{
	 $$$Init
	 try {
			$$$FillParams
			s usr=userID_"|"_loginName_"|"_userName  
			s index=""
			f {
				 s index=$o(^||ML("IN",index),1,param) q:index=""
				 s param=$g(param)
				 i $p(param,del,1)="ID" {
						s ID=$p(param,del,2)
						s lic=$p(ID,"#",1)
						s jed=$p(ID,"#",2)
				 }
				 i $p(param,del,1)="guid" s guid=$p(param,del,2)

			}
			s poz=$lg($g($$$CTMPGLBFRM(GUID,"formISYCiselnikyLicenceEdit","fgSeznam","idx",ID)),8)
			
			i jed="" {
				 k ^[dataDB]JRlicf("L",lic)
				 s ^[dataDB]JRlicf("L",lic)=$h_"~"_usr_"~"_poz
				 m ^[dataDB]JRlicf("L",lic,"D")=^CacheTempMLSrvBytes($s(guid'="":guid,1:$j))
			}else{
				 k ^[dataDB]JRlicf("J",lic,jed)
				 s ^[dataDB]JRlicf("J",lic,jed)=$h_"~"_usr_"~"_poz
				 m ^[dataDB]JRlicf("J",lic,jed,"D")=^CacheTempMLSrvBytes($s(guid'="":guid,1:$j))
			}
	 }catch (ex) {
			$$$CatchErrRest
	 }
	 q ret
}

ClassMethod PrilohaLicenceFromCache(ByRef sys As %String) As %String
{
	 $$$Init
	 try {
			$$$FillParams
			s usr=userID_"|"_loginName_"|"_userName  
			s jed=""
			s index=""
			f {
				 s index=$o(^||ML("IN",index),1,param) q:index=""
				 s param=$g(param)
				 i $p(param,del,1)="ID" {
						s ID=$p(param,del,2)
						s lic=$p(ID,"#",1)
						s jed=$p(ID,"#",2)
				 }
			}
			s guid=$SYSTEM.Util.CreateGUID()
			k ^CacheTempMLSrvBytes(guid)
			i jed="" {
				 m ^CacheTempMLSrvBytes(guid)=^[dataDB]JRlicf("L",lic,"D")
			}else{
				 m ^CacheTempMLSrvBytes(guid)=^[dataDB]JRlicf("J",lic,jed,"D")
			}
			i '$d(^CacheTempMLSrvBytes(guid)) s guid=""
			s ^||ML("OUT",1)=guid
	 }catch (ex) {
			$$$CatchErrRest
	 }
	 q ret
}

ClassMethod PrilohaLicenceListNewFilesFromTemporary(ByRef sys As %String) As %String
{
	 $$$Init
	 try {
			$$$FillParams
			s veta=$$$CTMPGLBFRM(GUID,"formISYCiselnikyLicenceEdit","bigObec")
			s lic=$lg(veta,1)
			s index=""
			s id=""
			f {
				 s id=$o($$$CTMPGLBFRM(GUID,"formISYCiselnikyLicenceEdit","fgSeznam","idx",id),1,vetaf) q:id=""
				 s jed=$lg(vetaf,3)
				 s ffn=$lg(vetaf,9)
				 i ffn'="" {
						s ^||ML("OUT",$i(index))=lic_"#"_jed_del_ffn
				 }
			}
	 }catch (ex) {
			$$$CatchErrRest
	 }
	 q ret
}

}
