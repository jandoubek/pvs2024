Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYCiselniky.API.DopravciProvozovny Extends %RegisteredObject
{

ClassMethod test()
{
	//d ##class(ALVA.ISY.ISYCiselniky.API.DopravciProvozovny).test()
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
	//k arr d ..nacti(.sys,$lb(13,10),.arr) w ! zw arr w !
	//d ..uloz(.sys,$lb(13,10),.arr)
	//k arr d ..nacti(.sys,$lb(13,10),.arr) w ! zw arr w !
	//k arr d ..existuje(.sys,$lb(13,10),.arr) w ! zw arr w !
	k arr d ..seznam(.sys,13,.arr) w ! zw arr w !
}

ClassMethod popis()
{
	//popis vety ciselniku
	//1 sidlo							/sídlo/název /T
	//2 ulice							/ulice,číslo /T
	//3 telefon							/telefon /T
	//4 divize							/divize /T
	//5 fax								/ičo pro JDF /T
	//6 nazev pro MHD					/nazev pro MHD (zkraceny) /T
	//7 telefon radiobus				/telefon pro objednání spoje na zavolaní /T
	//8 ID provozovny v CISu 			/id provozovny v číselníku CIS (pro export do gtelu) /T
}

ClassMethod nacti(ByRef sys As %String, polozkaId As %String, ByRef arr As %String)
{
	//vrati data polozky z ciselniku
	//IN
	//polozkaId = $lb(firmaId,provozId)
	//OUT
	//arr("DTA")=$lb(dta,dta,...) / popis v popis
	$$$FillParams
	s polozkaId=$g(polozkaId) k arr("DTA") s val=""
	s firmaId=$lg(polozkaId,1)
	s provozId=$lg(polozkaId,2)
	i (firmaId'="")&(provozId'="") {
		s valDB=$g(^[dataDB]JRSET("DOP",firmaId,provozId))
		s arr("DTA")=$lfs(valDB,"~")
	}
}

ClassMethod uloz(ByRef sys As %String, ByRef polozkaId As %String, ByRef arr As %String)
{
	//zapise data polozky ciselniku do databaze
	//IN
	//polozkaId = $lb(firmaId,provozId)
	//arr("DTA")=$lb(dta,dta,...) 				/ data, popis v popis
	//OUT
	//polozkaId
	//arr("DTA")=$lb(dta,dta,...)
	//
	$$$FillParams
	s polozkaId=$g(polozkaId)
	s firmaId=$lg(polozkaId,1)
	s provozId=$lg(polozkaId,2)
	i (firmaId'="")&(provozId'="") {
		s ^[dataDB]JRSET("DOP",firmaId,provozId)=$lts($g(arr("DTA")),"~")
	}
}

ClassMethod vymaz(ByRef sys As %String, polozkaId As %String, ByRef arr As %String)
{
	//vymaze polozku z ciselniku
	//IN
	//polozkaId = $lb(firmaId,provozId)
	//OUT
	//-
	//
	$$$FillParams
	s polozkaId=$g(polozkaId)
	s firmaId=$lg(polozkaId,1)
	s provozId=$lg(polozkaId,2)
	i (firmaId'="")&(provozId'="") {
		k ^[dataDB]JRSET("DOP",firmaId,provozId)
	}
}

ClassMethod existuje(ByRef sys As %String, polozkaId As %String, ByRef arr As %String)
{
	//zjisti, zda polozkaId v ciselniku existuje v databazi
	//IN
	//polozkaId = $lb(firmaId,provozId)
	//OUT
	//arr("STT")=0 neexistuje / >0 existuje
	$$$FillParams
	s polozkaId=$g(polozkaId) k arr("STT")
	s firmaId=$lg(polozkaId,1)
	s provozId=$lg(polozkaId,2)
	i (firmaId'="")&(provozId'="") {
		s arr("STT")=($d(^[dataDB]JRSET("DOP",firmaId,provozId))>0)
	}
}

ClassMethod seznam(ByRef sys As %String, polozkaId As %String, ByRef arr As %String)
{
	//vrati cely obsah ciselniku - provozovny pro jednu provozovnu
	//IN
	//arr("GLB")=pro navrat dat
	//polozkaId = firmaId
	//OUT
	//arr("DTA",provozId)=$lb(dta,dta,...) nebo @arr("GLB")@("DTA",polozkaId)=$lb(dta,dta,...)
	//arr("IDX",abcidx)=polozkaId nebo @arr("GLB")@("IDX",abcidx)=polozkaId	
	$$$FillParams
	s glb=$g(arr("GLB"))
	s firmaId=polozkaId
	i firmaId'="" {
		s provozId="" f {
			s provozId=$o(^[dataDB]JRSET("DOP",firmaId,provozId)) i provozId="" q
			k arrDTA d ..nacti(.sys,$lb(firmaId,provozId),.arrDTA) s arrDTA("DTA")=$g(arrDTA("DTA"))
			s sidlo=$lg(arrDTA("DTA"),1)
			s abcidx=##class(ALVA.GENERALAPI.String).gSortTxt(sidlo_"|"_provozId)
			i glb="" {
				s arr("DTA",provozId)=$g(arrDTA("DTA"))
				s arr("IDX",abcidx)=provozId
			}
			else {
				s @glb@("DTA",provozId)=$g(arrDTA("DTA"))
				s @glb@("IDX",abcidx)=provozId
			}
		}
	}
}

}
