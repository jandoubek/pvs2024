Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYCiselniky.API.Dopravci Extends %RegisteredObject
{

ClassMethod test()
{
	//d ##class(ALVA.ISY.ISYCiselniky.API.Dopravci).test()
	s sys("U","IdFa")="VS_CSAD"
		s sys("U","delimiter")=$c(0)
		s sys("U","SystemDB")="MLINE"
		s sys("C","User")=007
		s sys("U","DATA")="USER"
		s sys("U","MLP")=7
		s sys("U","fullName")="007"
		s sys("U","loginName")="007"
		s sys("C","GUID")=7
		//
	//k arr d ..nacti(.sys,13,.arr) w ! zw arr w !
	//d ..uloz(.sys,13,.arr)
	//k arr d ..nacti(.sys,13,.arr) w ! zw arr w !
	//k arr d ..existuje(.sys,13,.arr) w ! zw arr w !
	k arr d ..seznam(.sys,.arr) w ! zw arr w !
}

ClassMethod popis()
{
	//popis vety ciselniku
	//1 sidlo					/sídlo/název /T
	//2 ulice					/ulice,číslo /T
	//3 telefon					/telefon /T
	//4 fax						/fax /T
	//5 icoJDF					/ičo pro JDF /T
	//6 dicJDF					/dič pro JDF /T
	//7 obchodniNazevJDF		/obchodní název pro JDF /T
	//8 fyzickaOsobaJDF			/jméno fyzické osoby pro JDF /T
	//9 druhFirmyJDF			/druh firmy pro JDF (1 pravnicka / 2 fyzicka) /N 
	//10 sidloJDF				/sídlo pro JDF /T
	//11 telefonDispecinkJDF	/telefon na dispečink pro JDF /T
	//12 telefonInformaceJDF	/telefon na informace pro JDF /T
	//13 emailJDF				/email pro JDF /T
	//14 nazevMHD				/krátký název pro MHD /T
	//15 www					/www adresa /T
}

ClassMethod nacti(ByRef sys As %String, polozkaId As %String, ByRef arr As %String)
{
	//vrati data polozky z ciselniku
	//IN
	//polozkaId = firmaId
	//OUT
	//arr("DTA")=$lb(dta,dta,...) / popis v popis
	$$$FillParams
	s polozkaId=$g(polozkaId) k arr("DTA") s val=""
	i polozkaId'="" {
		s valDB=$g(^[dataDB]JRSET("DOP",polozkaId))
		s arr("DTA")=$lfs(valDB,"~")
	}
}

ClassMethod uloz(ByRef sys As %String, ByRef polozkaId As %String, ByRef arr As %String)
{
	//zapise data polozky ciselniku do databaze
	//IN
	//polozkaId = firmaId
	//arr("DTA")=$lb(dta,dta,...) 				/ data, popis v popis
	//OUT
	//polozkaId
	//arr("DTA")=$lb(dta,dta,...)
	//
	$$$FillParams
	s polozkaId=$g(polozkaId)
	i polozkaId'="" {
		s ^[dataDB]JRSET("DOP",polozkaId)=$lts($g(arr("DTA")),"~")
	}
}

ClassMethod vymaz(ByRef sys As %String, polozkaId As %String, ByRef arr As %String)
{
	//vymaze polozku z ciselniku
	//IN
	//polozkaId = firmaId
	//OUT
	//-
	//
	$$$FillParams
	s polozkaId=$g(polozkaId)
	i polozkaId'="" {
		k ^[dataDB]JRSET("DOP",polozkaId)
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
		s arr("STT")=($d(^[dataDB]JRSET("DOP",polozkaId))>0)
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
	s polozkaId="" f {
		s polozkaId=$o(^[dataDB]JRSET("DOP",polozkaId)) i polozkaId="" q
		k arrDTA d ..nacti(.sys,polozkaId,.arrDTA) s arrDTA("DTA")=$g(arrDTA("DTA"))
		s sidlo=$lg(arrDTA("DTA"),1)
		s abcidx=##class(ALVA.GENERALAPI.String).gSortTxt(sidlo_"|"_polozkaId)
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

/// 
/// Init gridu (seznam dopravcu)
/// 
ClassMethod InitFg(ByRef sys As %String, ByRef out As %String) As %String
{
	$$$FillParams   
	s out($i(i))=$lts($lb("ITEM","id","Id","T"),del)
	s out($i(i))=$lts($lb("ITEM","sidlo","Sídlo/Název","T"),del)
	s out($i(i))=$lts($lb("ITEM","ulice","Ulice, číslo","T"),del)	
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
		s polozkaId="" s abcidx=$o(arrDta("IDX",abcidx),1,polozkaId) i abcidx="" q
		s valDta=$g(arrDta("DTA",polozkaId))
		s idRadku=polozkaId
		s out($i(i))=$lts($lb("ITEM",polozkaId,"id",polozkaId,"",$lg(valDta,1)),del)
		s out($i(i))=$lts($lb("ITEM",polozkaId,"sidlo",$lg(valDta,1),"",$lg(valDta,1)),del)
		s out($i(i))=$lts($lb("ITEM",polozkaId,"ulice",$lg(valDta,2),"",$lg(valDta,1)),del)
	}
	q 0
}

}
