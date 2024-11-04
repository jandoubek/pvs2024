Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYCiselniky.API.SkupinyLinek Extends %RegisteredObject
{

ClassMethod popis()
{
	//datovy popis vety ciselniku
	//1 nazev 				/ nazev / T
	//2 platiOd 			/ platí od horlog / D
	//3 platiDo 			/ platí do horlog / D
	//4 zamekZmena 			/ uzamčená / B
	//5 zamekKopirovani 	/ uzamčená,kopírování / B
	//6 pouzitNZ 			/ použít neg.značky / B
	//7 skupinaTypId 		/ typ skupiny / N
}

ClassMethod nacti(ByRef sys As %String, polozkaId As %String, ByRef arr As %String)
{
	//vrati data jedne polozky ciselniku
	//IN
	//polozkaId
	//OUT
	//arr("DTA")=$lb(dta,dta,...) / popis v dsc
	m sys=^||ML("SYS")
	$$$FillParams
	s polozkaId=$g(polozkaId) k arr("DTA")
	i $g(polozkaId)'="" {
		s dbVal=$g(^[dataDB]JRL(polozkaId))
		f cnt=2,3 i $p(dbVal,"~",cnt) s $p(dbVal,"~",cnt)=##class(ALVA.GENERALAPI.Date).DateToHor($p(dbVal,"~",cnt))
		s val=$lfs(dbVal,"~")
		s arr("DTA")=val
	}
}

ClassMethod uloz(ByRef sys As %String, ByRef polozkaId As %String, ByRef arr As %String)
{
	//zapise data polozky ciselniku do databaze
	//IN
	//polozkaId 							/ musi byt zadano ve formulari
	//arr("DTA")=$lb(dta,dta,...) 			/ data polozky, popis v dsc
	//OUT
	//polozkaId
	//arr("DTA")=$lb(dta,dta,...)
	//
	$$$FillParams
	s polozkaId=$g(polozkaId)
	i polozkaId'="" {
		//odstraneni indexu
		d ..obnovIndex(.sys,polozkaId,0)
		//zapis dat do databaze
		s val=$g(arr("DTA")) s dbVal=$lts(val,"~")
		f cnt=2,3 i $p(dbVal,"~",cnt) s $p(dbVal,"~",cnt)=##class(ALVA.GENERALAPI.Date).horToDate($p(dbVal,"~",cnt))
		s ^[dataDB]JRL(polozkaId)=dbVal
		d ..obnovIndex(.sys,polozkaId,1)
	}
}

ClassMethod vymaz(ByRef sys As %String, polozkaId As %String, ByRef arr As %String)
{
	//vymaze polozku z ciselniku
	//IN
	//polozkaId
	//OUT
	//-
	//
	$$$FillParams
	$$$TMPGLBSET(tmpglbkos)
	s polozkaId=$g(polozkaId)
	i polozkaId'="" {
		//nastaveni kose
		k arrDta d ##class(ALVA.ISY.ISYKos.API.Kos).nactiNastaveni(.sys,.arrDta)
		s kosPovolen=($lg($g(arrDta("DTA")),1)=0)
		//vymazu ji v seznamu 
		d ..obnovIndex(.sys,polozkaId,0)
		//presun linek a relaci do kose
		i kosPovolen {
			s hrl=$h
			//linky
			i $o(^[dataDB]JRL(polozkaId,""))'="" {
				k @tmpglbkos m @tmpglbkos=^[dataDB]JRL(polozkaId)
				k arrDta s arrDta("GLB")=tmpglbkos
				d ##class(ALVA.ISY.ISYKos.API.Kos).uloz(.sys,$lb("Lin",hrl),.arrDta) 
			}
			//odjezdy
			i $o(^[dataDB]JRi("Odj",polozkaId,""))'="" {
				k @tmpglbkos m @tmpglbkos=^[dataDB]JRi("Odj",polozkaId)
				k arrDta s arrDta("GLB")=tmpglbkos
				d ##class(ALVA.ISY.ISYKos.API.Kos).uloz(.sys,$lb("Odj",hrl),.arrDta) 
			}
			//prijezdy
			i $o(^[dataDB]JRi("Pri",polozkaId,""))'="" {
				k @tmpglbkos m @tmpglbkos=^[dataDB]JRi("Pri",polozkaId)
				k arrDta s arrDta("GLB")=tmpglbkos
				d ##class(ALVA.ISY.ISYKos.API.Kos).uloz(.sys,$lb("Pri",hrl),.arrDta) 
			}
			//obehy
			k arrLst s arrLst("PAR","skupinaId")=polozkaId d ##class(ALVA.ISY.ISYObehy.API.SkupinyObehu).seznam(.sys,.arrLst)
			s skupinaObehuId="" f {
				s skupinaObehuId=$o(arrLst("DTA",skupinaObehuId)) i skupinaObehuId="" q
				d ##class(ALVA.ISY.ISYObehy.API.SkupinyObehu).vymaz(.sys,skupinaObehuId)
			}
		}
		//zruseni ciselniku negativnich znacek !!!
		k ^[dataDB]JRSET("Cis","InPlatDef",polozkaId)
		//zrusim ji
		k ^[dataDB]JRL(polozkaId)
		//sherlock
	}
}

ClassMethod existuje(ByRef sys As %String, polozkaId As %String, ByRef arr As %String)
{
	//zjisti, zda polozkaId v ciselniku existuje v databazi
	//IN
	//polozkaId
	//OUT
	//arr("STT")=0 neexistuje / >0 existuje
	m sys=^||ML("SYS")
	$$$FillParams
	// k ^dz
	// m ^dz=polozkaId
	s polozkaId=$g(polozkaId)
	k arr("STT")
	i polozkaId'="" {
		s arr("STT")=($d(^[dataDB]JRL(polozkaId))>0)
	}
}

ClassMethod seznam(ByRef sys As %String, ByRef arr As %String)
{
	//vrati obsah ciselniku, mozno i podle vstupniho parametru
	//IN
	//arr("GLB")=global s prenasenymi daty
	//arr("PAR","hledanyText")=hledany text
	//OUT
	//arr("DTA",polozkaId)=$lb(dta,dta,...) nebo @arr("GLB")@("DTA",polozkaId)=$lb(dta,dta,...)
	//arr("IDX",abcidx)=polozkaId nebo @arr("GLB")@("IDX",abcidx)=polozkaId
	$$$FillParams
	s glb=$g(arr("GLB"))
	s hledanyText=$g(arr("PAR","hledanyText"))
	k hledanyTextArr
	f cnt=1:1:$l(hledanyText,",") {
		s txt=$p(hledanyText,",",cnt) i txt'="" s hledanyTextArr(txt)=$ZCONVERT(##class(ALVA.GENERALAPI.String).HackyACarkyFuc(txt),"U")
	}
	s polozkaId="" f {
		s polozkaId=$o(^[dataDB]JRL(polozkaId)) i polozkaId="" q
		i polozkaId["tmp" continue
		k arrDTA d ..nacti(.sys,polozkaId,.arrDTA)
		s nazev=$lg($g(arrDTA("DTA")),1)
		s nazevU=$ZCONVERT(##class(ALVA.GENERALAPI.String).HackyACarkyFuc(nazev),"U")
		s vyhovuje=1
		i $d(hledanyTextArr) {
			s vyhovuje=0
			s txt="" f {
				s txtU="" s txt=$o(hledanyTextArr(txt),1,txtU) i txt="" q
				i vyhovuje q
				i nazevU[txtU s vyhovuje=1
			}
		}
		i vyhovuje {
			s nazev=$e(nazev,1,200)
			s abcidx=##class(ALVA.GENERALAPI.String).gSortTxt(nazev_polozkaId)
			i glb="" {
				s arr("DTA",polozkaId)=$g(arrDTA("DTA"))
				s arr("IDX",abcidx)=polozkaId
			}
			else {
				s @glb@("DTA",polozkaId)=$g(arrDTA("DTA"))
				s @glb@("IDX",abcidx)=polozkaId
			}	
		}
		k ^ps m ^ps = @glb
	}
}

ClassMethod noveID(ByRef sys As %String, ByRef polozkaId As %String, ByRef arr As %String)
{
	//vrati volne ID pro ciselnikovou polozku
	//IN
	//OUT
	//polozkaId
	$$$FillParams
	s polozkaId=""
	//nactu si, k cemu ma pristup
	k arrPristupovaPrava d ##class(ALVA.ISY.ISYCiselniky.API.SkupinyLinek).pristupovaPrava(IdFa,userID,.arrPristupovaPrava)
	//vyhledani volne skupiny - pro pristupova prava
	i $o(arrPristupovaPrava("arr",""))'="" {
		s skupinaId="" f {
			s skupinaId=$o(arrPristupovaPrava("arr",skupinaId)) i (skupinaId="")!(polozkaId) q
			i '$d(^[dataDB]JRL(skupinaId)) s polozkaId=skupinaId
		}
	}
	//vyhledani volne skupiny - pro cely rozsah
	else {
		f skupinaId=1:1:999 {
			i '$d(^[dataDB]JRL(skupinaId)) s polozkaId=skupinaId q
		}
	}
}

ClassMethod obnovIndex(ByRef sys As %String, polozkaId As %String, par As %String)
{
	//obsluha indexoveho globalu
	//
	$$$FillParams
	i polozkaId {
		s val=""
		//zapis indexu
		i +par {
		}
	//vymazani indexu
		i 'par {
		}
	}
}

/// 
/// Init gridu (skupiny linek)
/// 
ClassMethod InitFg(ByRef sys As %String, ByRef out As %String) As %String
{
	$$$FillParams   
	s out($i(i))=$lts($lb("ITEM","skupinaId","id/číslo","N"),del)
	s out($i(i))=$lts($lb("ITEM","nazev","název","T"),del)
	s out($i(i))=$lts($lb("ITEM","skupinaTyp","typ skupiny","T"),del)	
	s out($i(i))=$lts($lb("ITEM","platiOd","platí od","D"),del)	
	s out($i(i))=$lts($lb("ITEM","platiDo","platí do","D"),del)	
	s out($i(i))=$lts($lb("ITEM","uzamcenoZmeny","uzamčená proti změnám","B"),del)	
	s out($i(i))=$lts($lb("ITEM","uzamcenoKopirovani","uzamčená proti kopírování","B"),del)	
	q 0
}

/// 
/// Init gridu (skupiny linek)
/// 
ClassMethod LoadFg(ByRef sys As %String, ByRef out As %String) As %String
{
	$$$FillParams   
	k arrCisTypySkupinLinek d ##class(ALVA.ISY.ISYCiselniky.API.TypySkupinLinek).nacti(.sys,.arrCisTypySkupinLinek)
	k arrDta d ..seznam(.sys,.arrDta)
	s polozkaId="" s barva=""
	f {
		s valDta="" s polozkaId=$o(arrDta("DTA",polozkaId),1,valDta) i polozkaId="" q
		s idRadku=polozkaId
		s nazev=$lg(valDta,1)
		s skupinaTypId=$lg(valDta,7) s skupinaTypNazev=""
		i skupinaTypId s skupinaTypNazev=$lg($g(arrCisTypySkupinLinek("DTA",skupinaTypId)),1)
		s out($i(i))=$lts($lb("ITEM",idRadku,"skupinaId",polozkaId,barva,nazev),del)
		s out($i(i))=$lts($lb("ITEM",idRadku,"nazev",nazev,barva,nazev),del)
		s out($i(i))=$lts($lb("ITEM",idRadku,"skupinaTyp",skupinaTypNazev,barva,nazev),del)
		s horlog=$lg(valDta,2) s datum="" i horlog s datum=##class(ALVA.GENERALAPI.Date).horToDate(horlog) 
		s out($i(i))=$lts($lb("ITEM",idRadku,"platiOd",datum,barva,nazev),del)
		s horlog=$lg(valDta,2) s datum="" i horlog s datum=##class(ALVA.GENERALAPI.Date).horToDate(horlog) 
		s out($i(i))=$lts($lb("ITEM",idRadku,"platiDo",datum,barva,nazev),del)
		s out($i(i))=$lts($lb("ITEM",idRadku,"uzamcenoZmeny",$lg(valDta,4),barva,nazev),del)
		s out($i(i))=$lts($lb("ITEM",idRadku,"uzamcenoKopirovani",$lg(valDta,5),barva,nazev),del)
	}
	q 0
}

ClassMethod pristupovaPrava(idfa As %String, mlp As %String, ByRef arr As %String)
{
 //d ##class(ALVA.ISY.ISYCiselniky.API.SkupinyLinek).pristupovaPrava("VS_CSAD",191,.arr)
 k arr,arri,arro 
 s arri("idfa")=idfa 
 s arri("mlp")=mlp
 s arri("afo")=2
 s err=##class(ALVA.USERS.Api).GetFunkcniOmezeniUzivatele(.arri,.arro)
 s wrk=arro("index")
 m arr("arr")=^CacheTempUSERSApi(wrk,"JRS") k ^CacheTempUSERSApi(wrk)
}

}
