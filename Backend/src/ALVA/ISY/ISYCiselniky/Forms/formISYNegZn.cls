Include GENERAL

Class ALVA.ISY.ISYCiselniky.Forms.formISYNegZn Extends %RegisteredObject
{

ClassMethod init(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{
		$$$FillParams
		
		s output($i(i))=$lts($lb("ITEM","SKU","Skupina","T"),del)
		s output($i(i))=$lts($lb("ITEM","ID","Negativní"_$c(13,10)_"značka","T"),del)
		s output($i(i))=$lts($lb("ITEM","POP","Popis","T"),del)
		s output($i(i))=$lts($lb("ITEM","VYZ","Význam","T"),del)
		
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
		
		s codebook=+$g(input("CODEBOOK"))
		
		s dataDB=##class(ALVA.GENERALAPI.DataBase).dataDB(IdFa)
			
		k filtr m filtr=^[dataDB]JRR("FiltrNegZn",userID)
		if codebook { k filtr }
				
		k cisPolNZ d ##class(ALVA.ISY.ISYJR.API.CIS).gC(IdFa,3,.cisPolNZ)
		s cisPolNZ("DPL")=$lb("dlouhodobá platnost","Dlouhodobá platnost")
			
		k d m d=^[dataDB]JRSET("Cis","InPlatDef")
		s skup="" f {
			s skup=$o(d(skup)) q:skup=""
			
			if $d(filtr("SKUPINA")) { if $d(filtr("SKUPINA",skup))=0 { continue } } 
			
			s nz="" f {
				s nz=$o(d(skup,nz)) q:nz=""
				s n=$g(d(skup,nz))
				
				k t k p k pol m pol=d(skup,nz)
				s pol="" f {
					s pol=$o(pol(pol)) q:pol=""
					s v=$g(pol(pol))
					k t s t=v
					s t=$replace(t,":","-")
					s t=$replace(t,"#",",")
					s pc=$g(cisPolNZ(pol))					
					if pol="DPL" {
						if t="1" { s t="bez omezení" }
						if t="4" { s t="sudý týden" }
						if t="5" { s t="lichý týden" }
					}
					if $g(t)'="" {
						if $g(p)="" { s p=$lg(pc,2)_": "_$g(t) }
						else { s p=$g(p)_$c(13,10)_$lg(pc,2)_": "_$g(t) } 
					}
				}
				
				s idx=skup_"/"_nz
				
				s output($i(i))=$lts($lb("ITEM",idx,"ID",$g(nz)),del)
				s output($i(i))=$lts($lb("ITEM",idx,"SKU",$g(skup)),del)
				s output($i(i))=$lts($lb("ITEM",idx,"POP",$g(n)),del)
				s output($i(i))=$lts($lb("ITEM",idx,"VYZ",$g(p)),del)
			}
		}
		
		m ^||ML("OUT")=output
	}
	catch (ex) { $$$CatchErrRest }
	q ret
}

ClassMethod prunikDatumovychIntervalu(ByRef pol1 As %String, ByRef pol2 As %String, ByRef vstup As %String) As %String
{
	s prunik=0
	k arrH f pol=pol1,pol2 {
		s val="" f {
			s val=$o(vstup(pol,val)) i val="" q
			s d1=$p(val,"-",1) s d2=$p(val,"-",2) i d2="" s d2=d1
			s d1H=##class(ALVA.GENERALAPI.Date).DateTimeToHor(d1)
			s d2H=##class(ALVA.GENERALAPI.Date).DateTimeToHor(d2)
			f H=d1H:1:d2H s arrH(pol,H)=""
		}
	}
	s H="" f {
		s H=$o(arrH(pol1,H)) i (H="")!(prunik) q
		i $d(arrH(pol2,H)) s prunik=1
	}
	q prunik
}

ClassMethod del(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try {
		$$$FillParams 
		$$$InputParams
		
		s i=0 s idx=""  for {
			s idx=$o(^||ML("IN",idx),1,radka) q:idx=""
			s list=$lfs(radka,del)
			if $lg(list,1)="ID" {
				s v=$lg(list,2)
				s i=i+1
				s idS(i,"SKUP")=$p(v,"/",1)
				s idS(i,"NZ")=$p(v,"/",2)
			}
		}
		
		if $d(idS)=0 { s err="Není vyplněné [ID]" ztrap }
		
		s i="" f {
			s i=$o(idS(i)) q:i=""
			s skup=$g(idS(i,"SKUP"))
			s nz=$g(idS(i,"NZ"))
			s p=$g(^[dataDB]JRSET("Cis","InPlatDef",skup,nz))
			k ^[dataDB]JRSET("Cis","InPlatDef",skup,nz)
			s output($i(r))="MSG"_del_del_"["_$g(skup)_"] ["_$g(nz)_"] "_$g(p)
		}
		
		m ^||ML("OUT")=output		
	}
	catch (ex) { $$$CatchErrRest }
	q ret
}

ClassMethod getFiltr(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{
		$$$FillParams
		$$$InputParams
		
		s codebook=+$g(input("CODEBOOK"))		
		
		k data m data=^[dataDB]JRR("FiltrNegZn",userID)
		if codebook { k data }
		
		s pol="" f {
			s pol=$o(data(pol)) q:pol=""
			s hodT="" s hod="" f {
				s hod=$o(data(pol,hod)) q:hod=""
				if hodT="" { s hodT=hod }
				else { s hodT=hodT_", "_hod }
			}
			s dT(pol)=hodT
		}		
		
		s filtrText=""
		if $g(dT("SKUPINA"))'="" { s filtrText="Skupina: "_$g(dT("SKUPINA")) }
		
		s filtrText=##class(ALVA.GENERALAPI.String).Trim(filtrText)
		s output($i(i))="F"_del_filtrText
		
		m ^||ML("OUT")=output
	}
	catch (ex)  { $$$CatchErrRest }
	q ret
}

ClassMethod getStruk(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	// ALVA.ISY.ISYCiselniky.Forms.formISYNegZn.getStruk
	
	$$$Init
	try 
	{
		$$$FillParams
		$$$InputParams
		
		s id=$g(input("ID"))
		
		if $g(id)'="" {
			s skup=$p(id,"/",1)
			s nz=$p(id,"/",2)
			
			s output($i(r))="SKUPINA"_del_skup
			s output($i(r))="NZ"_del_nz
			
			k d m d=^[dataDB]JRSET("Cis","InPlatDef",skup,nz)
			s p=$g(d)
			s output($i(r))="POP"_del_p
			
			// dpl
			s dpl=+$g(d("DPL"))
			s output($i(r))="DPL"_del_dpl
			
			// jen 
			s v=$g(d("11")) f i=1:1:$l(v,"#") {
				s d=$p(v,"#",i) if $g(d)'="" {
					s jen(d)=""
					s output($i(r))="JEN"_del_d
				}
			}
				
			// take
			s v=$g(d("12")) f i=1:1:$l(v,"#") {
				s d=$p(v,"#",i) if $g(d)'="" {
					s take(d)=""
					s output($i(r))="TAKE"_del_d
				}
			}
		
			// interval
		
			// jede
			s v=$g(d("13"))
			s v=$replace(v,":","-")
			f i=1:1:$l(v,"#") {
				s d=$p(v,"#",i)
				if $g(d)'="" {
					if $g(d)'["-" { s d=d_"-"_d }
					s jede(d)="" 
					s output($i(r))="JEDE"_del_d
				}
			}
		
			// sude
			s v=$g(d("14"))
			s v=$replace(v,":","-")
			f i=1:1:$l(v,"#") {
				s d=$p(v,"#",i) if $g(d)'="" {
					s sude(d)=""
					s output($i(r))="SUDE"_del_d
				}
			}
		
			// liche
			s v=$g(d("15"))
			s v=$replace(v,":","-")
			f i=1:1:$l(v,"#") {
				s d=$p(v,"#",i) if $g(d)'="" {
					s liche(d)=""
					s output($i(r))="LICHE"_del_d
				}
			}
		
			// nejede
			s v=$g(d("22"))
			s v=$replace(v,":","-")
			f i=1:1:$l(v,"#") {
				s d=$p(v,"#",i)
				if $g(d)'="" {
					if $g(d)'["-" { s d=d_"-"_d }
					s nejede(d)=""
					s output($i(r))="NEJEDE"_del_d
				}
			}
		}
		
		m ^||ML("OUT")=output
	}
	catch (ex)  { $$$CatchErrRest }
	q ret
}

}
