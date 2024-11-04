Class ALVA.ISY.ISYZastavky.API.ObecnyPopis Extends %RegisteredObject
{

ClassMethod popisIndexuArr()
{
	//arr("PAR")		... parametry funkce
	//arr("DTA") 		... vstupni a vystupni data funkce
	//arr("IDX")		... indexove serazeni vystupnich dat, pak je zpravidla vystup arr("DTA",id)=... a arr("IDX",abcidx)=id
	//arr("GLB")		... global, je-li nadefinovany, pak se do nej vraci data (misto promenne), obvykle indexy "DTA" a "IDX"
	//arr("STT")		... vystupni stav fce (existence polozky,...)
	//arr("MSG")		... zpravy funkce
	//arr("ERR")		... chyby funkce (ne programove)
}

}
