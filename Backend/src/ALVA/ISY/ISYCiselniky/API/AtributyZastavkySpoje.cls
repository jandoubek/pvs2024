Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYCiselniky.API.AtributyZastavkySpoje Extends %RegisteredObject
{

ClassMethod popis()
{
	//datovy popis vety zastavky
	// 1 zkratkaId 							/ zkratka / T
	// 2 TypAtributu 						/ typ / T										//typ atributu (1 tiskovy / 2 provozni / 3 dopravni znacka dle vyhlasky)
	// 3 idProZastavku 						/ id pro zastávku / T							//(pri sjednoceni ciselniku nahradit prepinacem 0/1, kdy nabizet)
	// 4 idProZastavkuVTraseLinky 			/ id pro zastávku v trase linky / T 			//(pri sjednoceni ciselniku nahradit prepinacem 0/1, kdy nabizet)
	// 5 idProZastavkuVTraseSpoje 			/ id pro zastávku v trase spoje / T		        //(pri sjednoceni ciselniku nahradit prepinacem 0/1, kdy nabizet)
	// 6 proSpoj / příznak použití pro spoj / B",0,"")							
	// 7 nazev / název / T",0,"")
	// 8 JDFId / id v JDF / T",0,"")
}

ClassMethod nacti(ByRef sys As %String, polozkaId As %String, ByRef arr As %String)
{
	//vrati data jedne polozky ciselniku
	//IN
	//polozkaId = id polozky
	//OUT
	//arr("DTA")=$lb(dta,dta,...) / popis v popis
	$$$FillParams
	s polozkaId=$g(polozkaId) k arr("DTA")
	i (polozkaId) {
		
	}
}

ClassMethod uloz(ByRef sys As %String, ByRef polozkaId As %String, ByRef arr As %String)
{
	//zapise data polozky ciselniku do databaze
	//IN
	//polozkaId = id polozky
	//arr("DTA")=$lb(dta,dta,...) 			/ data zastavky, popis v dsc
	//OUT
	//polozkaId ()
	//arr("DTA")=$lb(dta,dta,...)
	//
	$$$FillParams
	s polozkaId=$g(polozkaId)
	//odstraneni indexu
	i +$g(polozkaId) {
		d ..obnovIndex(.sys,polozkaId,0)
	}
	//pokud neni polozkaId, tak si pridelim nove
	i '$g(polozkaId) {
	}
	//zapis dat do databaze
	s val=$g(arr("DTA"))
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
	$$$Init
	try 
	{	
		$$$FillParams
		
		i polozkaId {
			//vymazu ji v seznamu 
			d ..obnovIndex(.sys,polozkaId,0)
			//zrusim ji
			//sherlock
		}		
	}
	catch (ex){$$$CatchErrRest}
	q ret
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
	i +$g(polozkaId) {
	}
}

ClassMethod seznam(ByRef sys As %String, ByRef arr As %String)
{
	//vrati cely obsah ciselniku, mozno i podle vstupniho parametru
	//IN
	//OUT
	//arr("DTA",polozkaId)=$lb(dta,dta,...)
	$$$FillParams
	s glb=$g(arr("GLB"))
	//
	k arr("DTA")
	//pro tisk do trasy linky
	s arr("DTA", 1)=$lb("TPJ", 1,"",  "P", "",  "",  "podtrženo s příjezdem a odjezdem","")
	s arr("DTA", 2)=$lb("TJ",  1,"",  "J", "",  "",  "s příjezdem a odjezdem","")
	s arr("DTA", 3)=$lb("TT",  1,"",  "T", "",  "",  "tučně","")
	s arr("DTA", 4)=$lb("TP",  1,"",  "p", "",  "",  "podtrženo","")
	s arr("DTA", 5)=$lb("TO",  1,"",  "o", "",  "",  "podtrženo nad i pod","")
	s arr("DTA", 6)=$lb("TS",  1,"",  "S", "",  "",  "tisk stanoviště","")
	s arr("DTA", 7)=$lb("TSP", 1,"",  "<", "",  "",  "souhrn, příjezdová zastávka","")
	s arr("DTA", 8)=$lb("TPO", 1,"",  ">", "",  "",  "souhrn, odjezdová zastávka","")
	s arr("DTA", 9)=$lb("PX",  2,"",  "",  "X", "",  "střídání řidičů","")
	s arr("DTA",10)=$lb("PN",  2,"",  "E", "E", "",  "nácestná zastávka","")
	s arr("DTA",11)=$lb("PC",  2,"",  "H", "H", "",  "cílová zastávka pro tablo","")
	s arr("DTA",12)=$lb("PP",  2,"",  "",  "P", "",  "provozní přerušení","")
	s arr("DTA",13)=$lb("PZ",  2,"",  "",  "Z", "",  "detekovat zónu při průjezdu","")
	s arr("DTA",14)=$lb("PK",  2,"",  "",  "K", "",  "kontrolní bod","")
	s arr("DTA",15)=$lb("PD",  2,"",  "",  "W", "",  "nástup všemi dveřmi","")
	s arr("DTA",16)=$lb("DMM", 3,"",  "",  "",  "1", "spoj je možné použít jen s místenkou","#")
	s arr("DTA",17)=$lb("DMN", 3,"",  "",  "",  "1", "k jízdence je možné zakoupit místenku","R")
	s arr("DTA",18)=$lb("DOB", 3,"",  "",  "r", "1", "obsluhuje / jede jen na objednání","T")
	s arr("DTA",19)=$lb("DPO", 3,"",  "",  "i", "1", "obsluhuje / jede jen podmínečně","!")
	s arr("DTA",20)=$lb("DP",  3,"",  "G", "G", "",  "nepovolen nástup cest. pro přepravu do shodně označ. zast.","§")
	s arr("DTA",21)=$lb("DP1", 3,"",  "a", "a", "",  "nepovolen nástup cest. pro přepravu do shodně označ. zast.","A")
	s arr("DTA",22)=$lb("DP2", 3,"",  "b", "b", "",  "nepovolen nástup cest. pro přepravu do shodně označ. zast.","B")
	s arr("DTA",23)=$lb("DP3", 3,"",  "c", "c", "",  "nepovolen nástup cest. pro přepravu do shodně označ. zast.","C")
	s arr("DTA",24)=$lb("DX",  3,"x", "x", "x", "",  "na znamení nebo požádání","x")
	s arr("DTA",25)=$lb("DX1", 3,"",  "y", "",  "",  "na znamení nebo požádání od 22:00","x")
	s arr("DTA",26)=$lb("DX2", 3,"",  "z", "",  "",  "na znamení nebo požádání v pracovní dny od 22:00, o víkendech celodenně","x")
	s arr("DTA",27)=$lb("DV",  3,"",  "V", "V", "",  "jen pro výstup","(")
	s arr("DTA",28)=$lb("DN",  3,"",  "N", "N", "",  "jen pro nástup",")")
	s arr("DTA",29)=$lb("DCLO",3,"",  "C", "",  "",  "na hraničním přechodu není zřízena zastávka pro výstup a nástup cestujících","$")
	s arr("DTA",30)=$lb("DPK", 3,"",  "",  "",  "1", "spoj přepravuje jízdní kola","O")
	s arr("DTA",31)=$lb("DPZ", 3,"",  "",  "",  "1", "spoj přepravuje cestovní zavazadla","[")
	s arr("DTA",31)=$lb("DR",  3,"R", "",  "",  "1", "možnost občerstvení","%")
	s arr("DTA",33)=$lb("DCB", 3,"",  "",  "",  "1", "spoj s částečně bezbariérově přístupným vozidlem, nutná dopomoc průvodce","{")
	s arr("DTA",34)=$lb("DB",  3,"B", "",  "",  "1", "bezbariérově přístupné","@")
	s arr("DTA",35)=$lb("DTP", 3,"TP","",  "",  "",  "určený terminál s poskytováním pomoc osobám se zdravotním postižením a osobám se sníženou pohyblivostí","t")
	s arr("DTA",36)=$lb("DZP", 3,"ZP","",  "",  "",  "zastávka upravená pro osoby s těžkým zrakovým postižením","}")
	s arr("DTA",37)=$lb("DWC", 3,"W", "",  "",  "",  "veřejné WC v objektu zastávky","W")
	s arr("DTA",38)=$lb("DBWC",3,"BW","",  "",  "",  "veřejné WC s bezbariérovým přístupem v objektu zastávky","w")
	s arr("DTA",39)=$lb("DA",  3,"A", "A", "",  "",  "zastávka s možností přestupu na linkovou dopravu","b")
	s arr("DTA",40)=$lb("DL",  3,"L", "L", "L", "",  "zastávka s možností přestupu na železniční dopravu","v")
	s arr("DTA",41)=$lb("DMHD",3,"",  "",  "",  "",  "zastávka s možností přestupu na městskou hromadnou dopravu","~")
	s arr("DTA",42)=$lb("DM",  3,"",  "",  "",  "",  "zastávka s možností přestupu na metro","U")
	s arr("DTA",43)=$lb("DMA", 3,"e", "e", "e", "",  "zastávka s možností přestupu na metro, trasu A","U")
	s arr("DTA",44)=$lb("DMB", 3,"f", "f", "f", "",  "zastávka s možností přestupu na metro, trasu B","U")
	s arr("DTA",45)=$lb("DMC", 3,"g", "g", "g", "",  "zastávka s možností přestupu na metro, trasu C","U")
	s arr("DTA",46)=$lb("DMD", 3,"",  "",  "h", "",  "zastávka s možností přestupu na metro, trasu D","U")
	s arr("DTA",47)=$lb("DD",  3,"D", "D", "D", "",  "zastávka u přístaviště osobní lodní dopravy","S")
	s arr("DTA",48)=$lb("DO",  3,"O", "O", "O", "",  "zastávka u veřejného letiště","J")
	s arr("DTA",49)=$lb("DPR", 3,"PR","",  "",  "",  "zastávka u parkoviště systému Park and ride","P")
	s arr("DTA",50)=$lb("DI",  3,"",  "",  "",  "1", "spoj je v systému integrované dopravy","I")
	s arr("DTA",51)=$lb("DSO", 3,"",  "",  "",  "1", "spoj se samoobslužným způsobem odbavování cestujících","s")
	s arr("DTA",52)=$lb("DIN", 3,"",  "",  "",  "1", "bezdrátové připojení k internetu","")
	s arr("DTA",53)=$lb("DSP", 3,"",  "",  "",  "1", "přípojka 230V","")
	s arr("DTA",54)=$lb("DXN", 2,"",  "", "",  "n",  "neoznamovat x (na znameni nebo požádání)","")
	s arr("DTA",55)=$lb("DXZ", 2,"",  "", "",  "u",  "zastavit při x (na znamení nebo požádání)","")
}

ClassMethod noveID(ByRef sys As %String, ByRef polozkaId As %String, ByRef arr As %String)
{
	//vrati volne ID pro atribut
	//IN
	//OUT
	//polozkaId = nove Id
	$$$FillParams
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

}
