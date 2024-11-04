Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYCiselniky.API.TarifniZony Extends %RegisteredObject
{

ClassMethod popis()
{
	//datovy popis vety ciselniku
	// 1 popisKratky 			/ popis krátký / T
	// 2 idsId 					/ IDS / T
	// 3 sousedniTarifniZony 	/ sousedni|tarifní zóny / T
	// 4 oblastId 				/ oblast / N
	// 5 popisDlouhy 			/ popis dlouhý / T
	// 6 mestska 				/ městská / B
	// 7 hlavniZastavkaId 		/ hlavní zastávka|zóny / ND
	// 8 odbavZarId 			/ odbav.zař.|označení (TMX) / T
	// 9 odbavZarExportZnaky 	/ odbav.zař.|export znaků (TMX) / B
	// 10 prepravniSystemId 	/ přepravní systém / N
}

ClassMethod nacti(ByRef sys As %String, polozkaId As %String, ByRef arr As %String)
{
	//vrati data jedne polozky ciselniku
	//IN
	//polozkaId
	//OUT
	//arr("DTA")=$lb(dta,dta,...) / popis v dsc
	$$$FillParams
	s polozkaId=$g(polozkaId) k arr("DTA")
	i $g(polozkaId)'="" {
		s dbVal=$g(^[dataDB]JRSET("Definice","ZON",polozkaId))
		s val=""
		s $li(val,1)=$p(dbVal,"~",1)
		s $li(val,2)=$p(dbVal,"~",2)
		s $li(val,3)=$lfs($p(dbVal,"~",3),";")
		s $li(val,4)=$p(dbVal,"~",4)
		s $li(val,5)=$p(dbVal,"~",5)
		s $li(val,6)=+$p(dbVal,"~",6)
		s $li(val,7)=$p(dbVal,"~",7)
		s $li(val,8)=$p(dbVal,"~",8)
		s $li(val,9)=+$p(dbVal,"~",9)
		s $li(val,10)=$p(dbVal,"~",10)
		s arr("DTA")=val
	}
}

ClassMethod uloz(ByRef sys As %String, ByRef polozkaId As %String, ByRef arr As %String)
{
	//zapise data polozky ciselniku do databaze
	//IN
	//polozkaId 						/ musi byt zadano ve formulari
	//arr("DTA")=$lb(dta,dta,...) 			/ data polozky, popis v dsc
	//OUT
	//polozkaId
	//arr("DTA")=$lb(dta,dta,...)
	//
	$$$FillParams
	s polozkaId=$g(polozkaId)
	//odstraneni indexu
	i polozkaId'="" {
		d ..obnovIndex(.sys,polozkaId,0)
		//zapis dat do databaze
		s val=$g(arr("DTA")) s dbVal=""
		s $p(dbVal,"~",1)=$lg(val,1)
		s $p(dbVal,"~",2)=$lg(val,2)
		s $p(dbVal,"~",3)=$lts($lg(val,3),";")
		s $p(dbVal,"~",4)=$lg(val,4)
		s $p(dbVal,"~",5)=$lg(val,5)
		s $p(dbVal,"~",6)=$lg(val,6)
		s $p(dbVal,"~",7)=$lg(val,7)
		s $p(dbVal,"~",8)=$lg(val,8)
		s $p(dbVal,"~",9)=$lg(val,8)
		s $p(dbVal,"~",10)=$lg(val,10)
		s ^[dataDB]JRSET("Definice","ZON",polozkaId)=dbval
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
	s polozkaId=$g(polozkaId)
	i polozkaId'="" {
		//vymazu ji v seznamu 
		d ..obnovIndex(.sys,polozkaId,0)
		//zrusim ji
		k ^[dataDB]JRSET("Definice","ZON",polozkaId)
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
	$$$FillParams
	k arr("STT")
	s polozkaId=$g(polozkaId)
	i polozkaId'="" {
		s arr("STT")=($d(^[dataDB]JRSET("Definice","ZON",polozkaId))>0)
	}
}

ClassMethod seznam(ByRef sys As %String, ByRef arr As %String)
{
	//vrati cely obsah ciselniku, mozno i podle vstupniho parametru
	//IN
	//arr("GLB")=global s prenasenymi daty
	//arr("PAR","parametrKlic")=parametrData
	//OUT
	//arr("DTA",polozkaId)=$lb(dta,dta,...) nebo @arr("GLB")@("DTA",polozkaId)=$lb(dta,dta,...)
	//arr("IDX",abcidx)=polozkaId nebo @arr("GLB")@("IDX",abcidx)=polozkaId
	$$$FillParams
	s glb=$g(arr("GLB"))
	s polozkaId="" f {
		s polozkaId=$o(^[dataDB]JRSET("Definice","ZON",polozkaId)) i polozkaId="" q
		k arrDTA d ..nacti(.sys,polozkaId,.arrDTA)
		s abcidx=##class(ALVA.GENERALAPI.String).gSortTxt(polozkaId)
		i glb="" {
			s arr("DTA",polozkaId)=$g(arrDTA("DTA"))
			s arr("IDX",abcidx)=polozkaId
		}
		else {
			s @glb@("DTA",polozkaId)=$g(arrDTA("DTA"))
			s @glb@("IDX",abcidx)=polozkaId
		}	
	}
}

ClassMethod noveID(ByRef sys As %String, ByRef polozkaId As %String, ByRef arr As %String)
{
	//vrati volne ID pro ciselnikovou polozku
	//IN
	//OUT
	//polozkaId
	$$$FillParams
}

ClassMethod obnovIndex(ByRef sys As %String, polozkaId As %String, par As %String)
{
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
	s out($i(i))=$lts($lb("ITEM","id","id","T"),del)
	s out($i(i))=$lts($lb("ITEM","popisKratky","popis krátký","T"),del)
	s out($i(i))=$lts($lb("ITEM","sousedniTarifniZony","sousední"_$c(13,10)_"tarifní zóny","T"),del)	
	s out($i(i))=$lts($lb("ITEM","popisDlouhy","popis dlouhý","T"),del)	
	s out($i(i))=$lts($lb("ITEM","mestska","městská do","B"),del)	
	s out($i(i))=$lts($lb("ITEM","prepravniSystemId","přepravní systém","N"),del)	
	q 0
}

/// 
/// Init gridu (skupiny linek)
/// 
ClassMethod LoadFg(ByRef sys As %String, ByRef out As %String) As %String
{
	$$$FillParams   
	k arrDta d ..seznam(.sys,.arrDta)
	s polozkaId=""
	f {
		s valDta="" s polozkaId=$o(arrDta("DTA",polozkaId),1,valDta) i polozkaId="" q
		s idRadku=polozkaId
		s out($i(i))=$lts($lb("ITEM",idRadku,"id",polozkaId,"",$lg(valDta,1)),del)
		s out($i(i))=$lts($lb("ITEM",idRadku,"popisKratky",$lg(valDta,1),"",$lg(valDta,1)),del)
		s out($i(i))=$lts($lb("ITEM",idRadku,"sousedniTarifniZony",$lts($lg(valDta,3)),";","",$lg(valDta,1)),del)
		s out($i(i))=$lts($lb("ITEM",idRadku,"popisDlouhy",$lg(valDta,5),"",$lg(valDta,1)),del)
		s out($i(i))=$lts($lb("ITEM",idRadku,"mestska",(+$lg(valDta,6)),"",$lg(valDta,1)),del)
		s out($i(i))=$lts($lb("ITEM",idRadku,"prepravniSystemId",$lg(valDta,10),"",$lg(valDta,1)),del)
	}
	q 0
}

}
