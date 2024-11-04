Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAEDREPORTS)

Class ALVA.ISY.ISYCiselniky.BigForms.NegZn Extends %RegisteredObject
{

ClassMethod init(ByRef err As %String, ByRef in As %String, ByRef list As %ListOfObjects) As %String
{
	$$$Init
	
	try 
	{				
		#dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
		#dim value As ALVA.EDFORMS.CONTROLS.BIG.ItemValue
		
		s IdFa=$g(in("IdFa"))
		s dataDB=##class(ALVA.GENERALAPI.DataBase).dataDB(IdFa)
		s akce=$lg(in("Action"),2)
		s GUID=$g(in("GUID"))
		s user=$g(in("User"))
		s userID=$lg(user,1)
		
		s id=$o(in("ParamEx","ID",""))
		
		if $g(id)'="" {
			s skup=$p(id,"/",1)
			s nz=$p(id,"/",2)
			
			k d m d=^[dataDB]JRSET("Cis","InPlatDef",skup,nz)
			s p=$g(d)
		
			s skupPop=$p(^[dataDB]JRL(skup),"~",1)
			
			// dpl
			s dlo=+$g(d("DPL"))
			
			// jen 
			s v=$g(d("11")) f i=1:1:$l(v,"#") { s d=$p(v,"#",i) if $g(d)'="" { s jen(d)="" } }
				
			// take
			s v=$g(d("12")) f i=1:1:$l(v,"#") { s d=$p(v,"#",i) if $g(d)'="" { s take(d)="" } }
		
			// interval
		
			// jede
			s v=$g(d("13"))
			s v=$replace(v,":","-")
			f i=1:1:$l(v,"#") {
				s d=$p(v,"#",i)
				if $g(d)'="" {
					if $g(d)'["-" { s d=d_"-"_d }
					s jede(d)="" 
				}
			}
		
			// sude
			s v=$g(d("14"))
			s v=$replace(v,":","-")
			f i=1:1:$l(v,"#") { s d=$p(v,"#",i) if $g(d)'="" { s sude(d)="" } }
		
			// liche
			s v=$g(d("15"))
			s v=$replace(v,":","-")
			f i=1:1:$l(v,"#") { s d=$p(v,"#",i) if $g(d)'="" { s liche(d)="" } }
		
			// nejede
			s v=$g(d("22"))
			s v=$replace(v,":","-")
			f i=1:1:$l(v,"#") {
				s d=$p(v,"#",i)
				if $g(d)'="" {
					if $g(d)'["-" { s d=d_"-"_d }
					s nejede(d)=""
				}
			}
		}
		

		s aE=1 if $g(id)'="" { s aE=0 }
		
		s group="G0" s groupName="Základní údaje"
		
		s polozka="SKUP"
		s itemName="Skupina"
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,polozka,itemName,$$$BigItemDataTypeCodebook,1,aE,1,"")
		s item.DisplayAllValues=1
		s item.CodebookType=$$$CodebookTypeSkupinyLinek
		d item.AddValue($g(skup),$g(skupPop),"")	
		d list.Insert(item)
		
		s polozka="NZ"
		s itemName="Negativní značka"		
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,polozka,itemName,$$$BigItemDataTypeText,1,aE,1,"")
		d item.AddValue($g(nz),"","")
		d list.Insert(item)
		
		s polozka="POP"
		s itemName="Popis"
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,polozka,itemName,$$$BigItemDataTypeText,0,1,1,"")
		d item.AddValue($g(p),"","")
		d list.Insert(item)
		
		s group="G1" s groupName="Platnosti"
		
		s item="pla_dlo"
		s itemName="Dlouhodobá"
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,item,itemName,$$$BigItemDataTypeList,0,1,1,"")
		d item.AddListItem("1 | bez omezení ",1)
		d item.AddListItem("4 | sudý týden",4)
		d item.AddListItem("5 | lichý týden",5)
		d item.AddValue($g(dpl),"","")
		d list.Insert(item)
		
		s item="pla_jede_jen"
		s itemName="Jede jen"
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,item,itemName,$$$BigItemDataTypeDate,0,1,1,"")
		s item.MultiSelect=1
		s item.DisplayAllValues=1
		s d="" f {
			s d=$o(jen(d)) q:d=""
			d item.AddValue($g(d),"","")
		}
		d list.Insert(item)
		
		s item="pla_jede_take"
		s itemName="Jede také"
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,item,itemName,$$$BigItemDataTypeDate,0,1,1,"")
		s item.MultiSelect=1
		s item.DisplayAllValues=1
		s d="" f {
			s d=$o(take(d)) q:d=""
			d item.AddValue($g(d),"","")
		}
		d list.Insert(item)
		
		s item="pla_jede"
		s itemName="Jede"
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,item,itemName,$$$BigItemDataTypeDateInterval,0,1,1,"")
		s item.MultiSelect=1
		s item.DisplayAllValues=1
		s d="" f {
			s d=$o(jede(d)) q:d=""
			d item.AddValue($g(d),"","")
		}
		d list.Insert(item)
		
		s item="pla_jede_sude"
		s itemName="Jede sudé "
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,item,itemName,$$$BigItemDataTypeDateInterval,0,1,1,"")
		s item.MultiSelect=1
		s item.DisplayAllValues=1
		s d="" f {
			s d=$o(sude(d)) q:d=""
			d item.AddValue($g(d),"","")
		}
		d list.Insert(item)
		
		s item="pla_jede_liche"
		s itemName="Jede liché"
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,item,itemName,$$$BigItemDataTypeDateInterval,0,1,1,"")
		s item.MultiSelect=1
		s item.DisplayAllValues=1
		s d="" f {
			s d=$o(liche(d)) q:d=""
			d item.AddValue($g(d),"","")
		}
		d list.Insert(item)
		
		s item="pla_nejede"
		s itemName="Nejede"
		s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).CreateItem(.err,group,groupName,item,itemName,$$$BigItemDataTypeDateInterval,0,1,1,"")
		s item.MultiSelect=1
		s item.DisplayAllValues=1
		s d="" f {
			s d=$o(nejede(d)) q:d=""
			d item.AddValue($g(d),"","")
		}
		d list.Insert(item)
				
	}
	catch (ex) { $$$CatchErrToInputErr }
	q ret
}

ClassMethod validate(ByRef err As %String, ByRef in As %String, ByRef list As %ListOfObjects, ByRef out As %String) As %String
{
	$$$Init	 
	try 
	{
		#dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
		#dim item2 As ALVA.EDFORMS.CONTROLS.BIG.Item

		s IdFa=$g(in("IdFa"))
		s user=$g(in("User"))
		s action=$g(in("Action"))
		s validationType=$lg($g(in("Param")),1)
		s validatedItem=$lg($g(in("Param")),2)
		s items=$g(in("Items"))

		s refresh=1
		s cancel=0
		s dataDB=##class(ALVA.GENERALAPI.DataBase).dataDB(IdFa)
		s userID=$lg(user,1)	
		s userParametr=$o(in("ParamEx","userParID",""))	
		
		s action=$g(in("Action"))
		s akce=$lg(action,2)
		
		k data k dV s key="" for {
			s item=items.GetNext(.key) q:key=""
			s dV(item.Id)=item.FirstValue().Data
			s dV(item.Id,"I")=item
		}
			
		k dM s key="" for {
			s item=items.GetNext(.key) q:key=""
			s valKey="" f {
				s valItem=item.Values.GetNext(.valKey) q:valKey=""
				if valItem.Data'="" {
					s dM(item.Id,valItem.Data)=valItem.Name
				}
			}
		}
		
		if (validationType=$$$BigValidationTypeItem)&&(($e(validatedItem,1,3)="pla")) {
			s id=$g(dV(validatedItem))
			d ..valNZ(validatedItem,.dM,.info)
			k sort s pol="" f{
				s pol=$o(info(pol)) q:pol=""
				s text=$g(info(pol))
				s sort(..gS(pol),"P")=pol
				s sort(..gS(pol),"I")=$g(text)
				s text=$g(info(pol))
			}
			s s="" f {
				s s=$o(sort(s)) q:s=""
				s text=$g(sort(s,"I"))
				s pol=$g(sort(s,"P"))
				k item2
				s item2=dV(pol,"I")
				if $g(text)'="" {
					d item2.UpdateStatus($$$BigStateTypeError,$g(text))
				}
				else {
					d item2.UpdateStatus($$$BigStateTypeOk,"")
				}
				d list.Insert(item2)
			}
		}
		elseif (validationType=$$$BigValidationTypeItem)&&((validatedItem="cas_odjezdu")||(validatedItem="linka")||(validatedItem="spoj")) {
			f pol="cas_odjezdu","linka","spoj" {
				if pol=validatedItem { continue }
				k item2
				s item2=dV(pol,"I")
				d item2.UpdateStatus($$$BigStateTypeOk,"")
				d list.Insert(item2)
			}
			s casT=$g(dV("cas_odjezdu"))
			s linkaT=$g(dV("linka"))
			s spojS=$g(dV("spoj"))
			if ($g(casT)'="")&&($g(linkaT)'="")&&($g(spojS)'="") {
				s casS=##class(ALVA.GENERALAPI.Time).HHMMToMin(casT)
				s linkaS="0"_$g(linkaT)
				if ($g(casS)'=$g(cas))||($g(linkaS)'=$g(linka))||($g(spojS)'=$g(spoj)) {
					if $d(^[dataDB]JRi(rel,skup,id,"Data",zas,casS,linkaS,spojS)) {
						k item2
						s item2=dV(validatedItem,"I")
						s text="Kombinace čas ["_$g(casT)_"] linka ["_$g(linkaT)_"] spoj ["_$g(spojS)_"] již existuje"
						d item2.UpdateStatus($$$BigStateTypeError,$g(text))
						d list.Insert(item2)
					}
				}
			}
		}
		else {
			s key="" for {
				s item=items.GetNext(.key) q:key=""
				d list.Insert(item)
			}
		}
	}
	catch (ex) { $$$CatchErrToInputErr }
	q ret
}

ClassMethod gS(ByRef pol As %String)
{
	s p("pla_tyd")=1
	s p("pla_dlo")=2
	s p("pla_jede_jen")=3
	s p("pla_jede_take")=4
	s p("pla_jede")=5
	s p("pla_jede_sude")=6
	s p("pla_jede_liche")=7
	s p("pla_nejede")=8
	
	if $g(pol)'="" { s id=$g(p(pol)) }
	q $g(id)
}

ClassMethod valNZ(ByRef pol As %String, ByRef vstup As %String, ByRef vystup As %String)
{
	// pol="pla_jede_jen" - položka se validuje
	//
	// vstup - data ostatních položek
	// vstup("pla_jede","27.11.2023")=""
	// vstup("pla_nejede","26.11.2023-28.11.2023")=""
	//
	// vystup - informace k validaci
	// vystup("pla_jede")="Neni pozné zadat datum, který je součástí nejede"
	//
	// PRAVIDLA
	// tydenni platnost 1234567X+
	// neze kombinovat X a 12345
	// neze kombinovat 7 a +
	//
	// dlouhodoba + datumove omezeni
	// 1 jede od-do
	// 2 jede také
	// 3 jede jen
	// 4 nejede od-do
	// 5 liche tydny
	// 6 sude tydny
	// 7 liche tydny od-do
	// 8 sude tydny od-do
	//
	// 3 jede jen - ne intervaly, jen samostatne datumy, nelze kombinovat s zadnou tydenni platnosti a 1,2,3,4,5,6,7,8
	// jede take - ne intervaly
	// nelze kombinovat 5,6,7,8
	// nelze kombinovat 5,6,7
	// nelze kombinovat 5,6,8
	// nelze kombinovat 5,6
	// nelze kombinovat 5,7
	// nelze kombinovat 5,8
	// nelze kombinovat 5,7,8
	// nelze kombinovat 6,7,8
	// nelze kombinovat 6,7
	// nelze kombinovat 6,8
	// nelze kombinovat 7,8
	// nelze kombinovat 1,7
	// nelze kombinovat 1,8
	// nelze kombinovat 1,7,8
	//
	//hromadna kontrola polozek
	f tPol="pla_dlo","pla_jede_jen","pla_jede_take","pla_jede","pla_jede_liche","pla_jede_sude","pla_nejede" {
		s info=""
		i $o(vstup(tPol,""))'="" {
			i tPol="pla_tyd" {
				i ($d(vstup("pla_tyd","7"))&$d(vstup("pla_tyd","+"))) s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace 7 a +"
				i ($d(vstup("pla_tyd","1"))&$d(vstup("pla_tyd","X"))) s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace 1 a X"
				i ($d(vstup("pla_tyd","2"))&$d(vstup("pla_tyd","X"))) s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace 2 a X"
				i ($d(vstup("pla_tyd","3"))&$d(vstup("pla_tyd","X"))) s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace 3 a X"
				i ($d(vstup("pla_tyd","4"))&$d(vstup("pla_tyd","X"))) s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace 4 a X"
				i ($d(vstup("pla_tyd","5"))&$d(vstup("pla_tyd","X"))) s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace 5 a X"
				i $o(vstup("pla_jede_jen",""))'="" s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace týdení platnosti a jede jen"
			}	
			i tPol="pla_dlo" {
				i ($d(vstup(tPol,4))) {
					i $o(vstup("pla_jede_jen",""))'="" s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace sudý týden a jede jen"
					i $o(vstup("pla_jede_liche",""))'="" s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace sudý týden a jede liché"
					i $o(vstup("pla_jede_sude",""))'="" s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace sudý týden a jede sudé"
				}
				i $d(vstup(tPol,5)) {
					i $o(vstup("pla_jede_jen",""))'="" s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace lichý týden a jede jen"
					i $o(vstup("pla_jede_liche",""))'="" s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace lichý týden a jede liché"
					i $o(vstup("pla_jede_sude",""))'="" s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace lichý týden a jede sudé"
				}
			}
			i tPol="pla_jede_jen" {
				i $o(vstup("pla_tyd",""))'="" s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace jede jen a týdenní platnost"
				i $o(vstup("pla_dlo",""))>1 s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace jede jen a dlouhodoba platnost"
				i $o(vstup("pla_jede_take",""))'="" s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace jede jen a jede také"
				i $o(vstup("pla_jede",""))'="" s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace jede jen a jede"
				i $o(vstup("pla_nejede",""))'="" s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace jede jen a nejede"
				i $o(vstup("pla_jede_liche",""))'="" s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace jede jen a jede liché"
				i $o(vstup("pla_jede_sude",""))'="" s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace jede jen a jede sudé"
			}
			i tPol="pla_jede_take" {
				i $o(vstup("pla_jede_jen",""))'="" s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace jede také a jede jen"
			}
			i tPol="pla_jede" {
				i $o(vstup("pla_jede_jen",""))'="" s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace jede a jede jen"
				i $o(vstup("pla_jede_liche",""))'="" s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace jede a jede liché"
				i $o(vstup("pla_jede_sude",""))'="" s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace jede a jede sudé"
				//kontrola na prekryti intervalu
				i $o(vstup("pla_nejede",""))'="" {
					i ..prunikDatumovychIntervalu("pla_jede","pla_nejede",.vstup) {
						s:info'="" info=info_$c(13,10) s info=info_"průnik datumů pro jede a nejede"
					}
				}
			}
			i tPol="pla_nejede" {
				i $o(vstup("pla_jede_jen",""))'="" s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace nejede a jede jen"
				i $o(vstup("pla_jede",""))'="" {
					i ..prunikDatumovychIntervalu("pla_nejede","pla_jede",.vstup) {
						s:info'="" info=info_$c(13,10) s info=info_"průnik datumů pro nejede a jede"
					}
				}
			}
			i tPol="pla_jede_liche" {
				i $o(vstup("pla_jede_jen",""))'="" s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace jede liché a jede jen"
				i $o(vstup("pla_jede_sude",""))'="" s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace jede liché a jede sudé"			
			}
			i tPol="pla_jede_sude" {
				i $o(vstup("pla_jede_jen",""))'="" s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace jede sudé a jede jen"
				i $o(vstup("pla_jede_liche",""))'="" s:info'="" info=info_$c(13,10) s info=info_"nepovolená kombinace jede sudé a jede liché"
			}
		}
		s vystup(tPol)=info
	}
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

ClassMethod save(ByRef err As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	
	try 
	{
		#dim items As %ListOfObjects
		#dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
		#dim value AS ALVA.EDFORMS.CONTROLS.BIG.ItemValue
		
		s IdFa=$g(in("IdFa"))
		s user=$g(in("User"))
		s GUID=$g(in("GUID"))
		s userID=$lg(user,1)
		s action=$g(in("Action"))
		s items=$g(in("Items"))
		
		s dataDB=##class(ALVA.GENERALAPI.DataBase).dataDB(IdFa)
		
		s id=$o(in("ParamEx","ID",""))		
		if $g(id)'="" {
			s skup=$p(id,"/",1)
			s nz=$p(id,"/",2)
		}
		
		k param
		k data s key="" for {
			s item=items.GetNext(.key) q:key=""
			s valKey="" f {
				s valItem=item.Values.GetNext(.valKey) q:valKey=""
				if valItem.Data'="" {
					s data(item.Id,valItem.Data)=valItem.Name
					// s data(item.Id)=valItem.Data
				}
			}
		}
		
		s cisCB("pla_dlo")="DPL"
		s cisDB("pla_jede_jen")="11"
				s cisDB("pla_jede_take")="12"
				s cisDB("pla_jede")="13"
				s cisDB("pla_jede_sude")="14"
				s cisDB("pla_jede_liche")="15"
				s cisDB("pla_nejede")="22"
		
		if $g(skup)="" { s skup=$o(data("SKUP","")) }		
		if $g(nz)="" { s nz=$o(data("NZ","")) }
		
		if ($g(skup)'="")&&($g(nz)'="") {
			k ^[dataDB]JRSET("Cis","InPlatDef",skup,nz)
			s pol="" f {
				s pol=$o(data(pol)) q:pol=""
				if $e(pol,1,3)="pla" {
					s h="" f {
						s h=$o(data(pol,h)) q:h=""
						s h=$replace(h,"-",":")
						s polDB=cisDB(pol)
						if $g(db(polDB))="" { s db(polDB)=h }
						else { s db(polDB)=$g(db(polDB))_"#"_h }
					}
				}
			}
			s db=$o(data("POP",""))
			m ^[dataDB]JRSET("Cis","InPlatDef",skup,nz)=db
		}
	}
	catch (ex) { $$$CatchErrToInputErr }
	q ret
}

}
