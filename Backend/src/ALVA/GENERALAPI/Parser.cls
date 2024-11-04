Class ALVA.GENERALAPI.Parser Extends %RegisteredObject
{

/// 
/// Z globálu  na vstupu in vytvoří jenoúrovňový globál složením jednotlivých klíčů za sebe
/// 
ClassMethod glbToOneKeyGlb(in, nazev, deli, out)
{
	
	//d ##class(ALVA.GENERALAPI.Parser).glbToOneKeyGlb(nm,"","","^[""as""]kopec")
	// *
	// in - string vstupní globál npř:  "^[""as""]kopec(123,125,""kkk"")"   
	// nazev - prefix klíče (slouží pro rekurzi  nevyplňovat !!!!!!  nebo zadat "" )
	//deli - oddělovač úrovní globálú
	//*
	//out -název proměné (globálu) pro výstupní pole
	//	
	// kontrola vstupů
	if ($g(in)=""){ztrap "ER01 Nebyl zaslán vstup in"}
	if ($g(deli)=""){s deli = $c(0)}	
	//první hodnota
	if ((nazev = "")&&(($d(@in)=1)||($d(@in)=11))){s @out=$g(@in)}
    s klic=""
   	for
    {
           s klic=$o(@in@(klic)) q:klic=""                  
           s val = $g(@in@(klic))      
           if (($d(@in@(klic))=1)!($d(@in@(klic))=11))
           {
	           if ($g(nazev)=""){s @out@(klic)= val}
	           else{s @out@(nazev_deli_klic)= val}
	       } 
           if $d(@in@(klic))>1
           {	          
	           if ($g(nazev)=""){s klcIn= klic}
	           else{s klcIn =nazev_deli_klic}
	           if (in["(") {s vstglb =$e(in,0,$l(in)-1)_","""_klic_""")"}
	           else{s vstglb =in _"("""_klic_""")"}
               d ..glbToOneKeyGlb(vstglb,klcIn,deli,out)
            }            
     }
}

/// 
/// Ze vstupního pole in vytvoří z5 globál 
/// 
ClassMethod oneKeyGlbToGlb(in, deli, out)
{
	
	//d ##class(ALVA.GENERALAPI.Parser).oneKeyGlbToGlb("^[""as""]kopec","","^[""as""]kope")
	//*
	// in - string vstupní globál npř:  "^[""as""]kopec(123,125,""kkk"")"   
	//deli - oddělovač úrovní globálú
	//*
	//out -název proměné (globálu) pro výstupní pole
	//	
	k @"out"
	//	
	// kontrola vstupů
	if ($g(in)=""){ztrap "ER01 Nebyl zaslán vstup in"}
	if ($g(deli)=""){s deli = $c(0)}
	//	
    s @out =$g(@in) 
	//
 	s klic=""
   	for
    {
           s klic=$o(@in@(klic)) Q:klic=""                                         
           s glb =    "out("""_$replace(klic,deli,""",""")_""")"
           s @glb = $g(@in@(klic))           
    }   
    m @out = @"out"
}

}
