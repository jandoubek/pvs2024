Include (ALVALIBRARY, ALVAEDFORMS, GENERAL)

Class ALVA.ISY.ISYKos.API.Kos Extends %RegisteredObject
{

ClassMethod nacti(ByRef sys As %String, id As %String, ByRef arr As %String)
{
	//
	//IN
	//id=$lb(typPolozkyId,hrl)
	//typPolozkyId = "Zas" - zastavka / "Lin" - linka / "Odj" - odjezd / "Pri" - prijezd
	//hrl - cely horlog zapisu
	//arr("GLB")=global, kam vratit data, pokud neni, vraci se v arr("DTA")
	//OUT
	//arr("DTA",...)=... nebo jsou data v @arr("GLB")
	$$$FillParams
	s id=$g(id) s typPolozkyId=$lg(id,1) s hrl=$lg(id,2)
	i (typPolozkyId'="")&(hrl'="") {
		i $g(arr("GLB"))'="" {
			m @arr("GLB")=^[dataDB]JRKos(hrl,typPolozkyId)
		}
		else {
			m arr("DTA")=^[dataDB]JRKos(hrl,typPolozkyId)
		}
	}
}

ClassMethod uloz(ByRef sys As %String, ByRef id As %String, ByRef arr As %String)
{
	//
	//IN
	//id=$lb(typPolozkyId,hrl)
	//typPolozkyId = "Zas" - zastavka / "Lin" - linka / "Odj" - odjezd / "Pri" - prijezd
	//hrl - cely horlog zapisu, pokud neni, automaticky se doplni
	//arr("DTA",...)=... ... data pro zapis do kose, na prvnim indexu je id linky, relace,...)
	//arr("GLB")=global s daty pro zapis do kose, data jsou v @arr("GLB")
	//OUT
	//id=$lb(typPolozkyId,hrl)
	//
	$$$FillParams
	s id=$g(id) s typPolozkyId=$lg(id,1) s hrl=$lg(id,2)
	i typPolozkyId'="" {
		k arrNastaveni d ..nactiNastaveni(.sys,.arrNastaveni)
		i '$lg($g(arrNastaveni("DTA")),1) {
			i 'hrl f  s hrl=$h l +^[dataDB]JRKos(hrl):1 i $t q
			i $g(arr("GLB"))'="" {
				m ^[dataDB]JRKos(hrl,typPolozkyId)=@arr("GLB")
			}
			else {
				m ^[dataDB]JRKos(hrl,typPolozkyId)=arr("DTA")
			}
		}
		s id=$lb(typPolozkyId,hrl)
	}
}

ClassMethod vymaz(ByRef sys As %String, id As %String, ByRef arr As %String)
{
	//vymaze polozku z kose
	//IN
	//id=$lb(typPolozkyId,hrl)
	//OUT
	//-
	//
	$$$FillParams
	s id=$g(id) s typPolozkyId=$lg(id,1) s hrl=$lg(id,2)
	i (typPolozkyId'="")&(hrl'="") {
		k ^[dataDB]JRKos(hrl,typPolozkyId)
	}
}

ClassMethod nactiNastaveni(ByRef sys As %String, ByRef arr As %String)
{
	//nacte nastaveni kose
	//IN
	
	//OUT
	//arr("DTA")=$lb(zakazan,pocetDnuHistorie)
	//zakazan 0 ne / 1 ano
	//pocetDnuHistorie - pocet dni pro sledovani historie, starsi zaznamy se automaticky mazou	 
	$$$FillParams
	k arr("DTA")
	s val=""
	s $li(val,1)=(+$g(^[dataDB]JRSET("Definice","KosNe")))
	s $li(val,2)=($g(^[dataDB]JRSET("Definice","KosSet")))
	s arr("DTA")=val
}

ClassMethod ulozNastaveni(ByRef sys As %String, ByRef arr As %String)
{
	//ulozi nastaveni kose
	//IN
	//arr("DTA")=$lb(dta,dta,...)
	//OUT
	$$$FillParams
	s val=$g(arr("DTA"))
	s ^[nmsp]JRSET("Definice","KosNe")=$lg(val,1)
	s ^[nmsp]JRSET("Definice","KosSet")=$lg(val,2)
}

}
