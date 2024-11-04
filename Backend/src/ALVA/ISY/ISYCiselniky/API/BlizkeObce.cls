Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYCiselniky.API.BlizkeObce Extends %RegisteredObject
{

ClassMethod popis()
{
	//popis vety ciselniku
	//1 popis 			/ popis / T
	//2 blizkaObec 		/ blízká obec / T
	//3 kraj 			/ kraj / T
	//4 stat 			/ stát / T
}

ClassMethod nacti(ByRef sys As %String, polozkaId As %String, ByRef arr As %String)
{
	//vrati data jedne polozky ciselniku
	//IN
	//polozkaId = id polozky
	//je-li prvni znak polozkaId * jedna se o stat, id=PT (blizka obec) id=*D (zeme) id=*SK/BA (blizka obec v zemi)
	//OUT
	//arr("DTA")=$lb(dta,dta,...) / popis v popis
	$$$FillParams
	s polozkaId=$g(polozkaId) k arr("DTA") s val=""
	i polozkaId'="" {
		s idxId="OKR" i $e(polozkaId,1)="*" s idxId="STT"
		i $d(^[dataDB]JRSET("MISTA",idxId,polozkaId)) {
			s dbVal=$g(^[dataDB]JRSET("MISTA",idxId,polozkaId))
			s $li(val,1)=$p(dbVal,"$",2)
			s $li(val,3)=$p(dbVal,"$",3)
			i idxId="OKR" {
				s $li(val,2)=polozkaId
				s $li(val,4)=""
			}
			i idxId="STT" {
				s $li(val,2)=$p(polozkaId,"/",2)
				s $li(val,4)=$tr($p(polozkaId,"/",1),"*","")
			}
		}
		s arr("DTA")=val
	}
}

ClassMethod uloz(ByRef sys As %String, ByRef polozkaId As %String, ByRef arr As %String)
{
	//zapise data polozky ciselniku do databaze
	//IN
	//polozkaId = id polozky					/ pokud neni, automaticky se prideli
	//je-li prvni znak polozkaId * jedna se o stat, id=PT (blizka obec) id=*D (zeme) id=*SK/BA (blizka obec v zemi)
	//arr("DTA")=$lb(dta,dta,...) 				/ data, popis v popis
	//OUT
	//polozkaId
	//arr("DTA")=$lb(dta,dta,...)
	//
	$$$FillParams
	s polozkaId=$g(polozkaId)
	//odstraneni indexu
	i polozkaId'="" {
		d ..obnovIndex(.sys,polozkaId,0)
	}
	//pokud neni polozkaId, tak si pridelim nove
	i polozkaId="" {
		d ..noveID(.sys,.arr)
		s polozkaId=$g(arr("ID"))
	}
	//zapis dat do databaze
	s idxId="OKR" i $e(polozkaId,1)="*" s idxId="STT"
	s val=$g(arr("DTA")) s dbVal=""
	s $p(dbVal,1)=$ZCONVERT(##class(ALVA.GENERALAPI.String).HackyACarkyFuc($lg(val,1)),"U")
	s $p(dbVal,2)=$lg(val,1)
	s $p(dbVal,3)=$lg(val,3)
	//
	s ^[dataDB]JRSET("MISTA",idxId,polozkaId)=dbVal
	//
	//zapis do indexu
	d ..obnovIndex(.sys,polozkaId,1)
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
		s err=..obnovIndex(.sys,polozkaId,0) i err zt
		s idxId="OKR" i $e(polozkaId,1)="*" s idxId="STT"
		//zrusim ji
		k ^[dataDB]JRSET("MISTA",idxId,polozkaId)
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
	s polozkaId=$g(polozkaId) k arr("STT")
	i polozkaId'="" {
		s idxId="OKR" i $e(polozkaId,1)="*" s idxId="STT"
		s arr("STT")=($d(^[dataDB]JRSET("MISTA",idxId,polozkaId))>0)
	}
}

ClassMethod seznam(ByRef sys As %String, ByRef arr As %String)
{
	//vrati cely obsah ciselniku, mozno i podle vstupniho parametru
	//IN
	//arr("GLB")=pro navrat dat
	//OUT
	//arr("DTA",polozkaId)=$lb(dta,dta,...) nebo @arr("GLB")@("DTA",polozkaId)=$lb(dta,dta,...)
	//arr("IDX",abcidx)=polozkaId nebo @arr("GLB")@("IDX",abcidx)=polozkaId	
	$$$FillParams
	s glb=$g(arr("GLB"))
	s idxId="" f {
		s idxId=$o(^[dataDB]JRSET("MISTA",idxId)) i idxId="" q
		s polozkaId="" f {
			s polozkaId=$o(^[dataDB]JRSET("MISTA",idxId,polozkaId)) i polozkaId="" q
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
}

ClassMethod noveID(ByRef sys As %String, ByRef polozkaId As %String, ByRef arr As %String)
{
	//vrati nove ID pro ciselnikovou polozku
	//IN
	//OUT
	//polozkaId
	$$$FillParams
	s val=$g(arr("DTA"))
	//okres (neni definovany stat)
	i $lg(val,4)="" {
		s polozkaId=$lg(val,2)
	}
	//stat a nebo stat/okres (je defino
	else {
		s polozkaId="*"_$lg(val,4)
		i $lg(val,3)'="" s polozkaId=polozkaId_"/"_$lg(val,3)
	}
}

ClassMethod obnovIndex(ByRef sys As %String, polozkaId As %String, par As %String)
{
	//obsluha indexoveho globalu
	//
	$$$Init
	try {
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
		catch (ex) {$$$CatchErrRest}
	 q ret
}

/// 
/// Init gridu (seznam blizkych obci)
/// 
ClassMethod InitFg(ByRef sys As %String, ByRef out As %String) As %String
{
	$$$FillParams   
	s out($i(i))=$lts($lb("ITEM","id","Id","T"),del)
	s out($i(i))=$lts($lb("ITEM","popis","popis","T"),del)
	s out($i(i))=$lts($lb("ITEM","blizkaObec","blízká obec","T"),del)	
	s out($i(i))=$lts($lb("ITEM","kraj","kraj","T"),del)	
	s out($i(i))=$lts($lb("ITEM","stat","stát","T"),del)	
	q 0
}

/// 
/// Init gridu (seznam blizkych obci)
/// 
ClassMethod LoadFg(ByRef sys As %String, ByRef out As %String) As %String
{
	$$$FillParams   
	k arrDta d ..seznam(.sys,.arrDta)
	//arr("GLB")=pro navrat dat
	//OUT
	//arr("DTA",polozkaId)=$lb(dta,dta,...) nebo @arr("GLB")@("DTA",polozkaId)=$lb(dta,dta,...)
	//arr("IDX",abcidx)=polozkaId nebo @arr("GLB")@("IDX",abcidx)=polozkaId
	s abcidx=""
	f {
		s blizkaObecId="" s abcidx=$o(arrDta("IDX",abcidx),1,blizkaObecId) i abcidx="" q
		s valDta=$g(arrDta("DTA",blizkaObecId))
		s idRadku=blizkaObecId
		s out($i(i))=$lts($lb("ITEM",idRadku,"id",blizkaObecId,"",$lg(valDta,1)),del)
		s out($i(i))=$lts($lb("ITEM",idRadku,"popis",$lg(valDta,1),"",$lg(valDta,1)),del)
		s out($i(i))=$lts($lb("ITEM",idRadku,"blizkaObec",$lg(valDta,2),"",$lg(valDta,1)),del)
		s out($i(i))=$lts($lb("ITEM",idRadku,"kraj",$lg(valDta,3),"",$lg(valDta,1)),del)
		s out($i(i))=$lts($lb("ITEM",idRadku,"stat",$lg(valDta,4),"",$lg(valDta,1)),del)
	}
	q 0
}

}
