Include (ALVALIBRARY, ALVAEDFORMS, GENERAL)

Class ALVA.ISY.ISYKos.API.KosFce Extends %RegisteredObject
{

ClassMethod hromadneVymazPodleNastaveni(ByRef sys As %String, id As %String, ByRef arr As %String) As %String
{
	//hromadne vymazani podle nastaveni (povoleno a pocet dnu)
	//IN
	//OUT
	//
	$$$Init
	try 
	{	
		$$$FillParams
		k arrNastaveni d ##class(ALVA.ISY.ISYKos.API.Kos).nactiNastaveni(.sys,.arrNastaveni)
		i '$lg($g(arrNastaveni("DTA")),1) {
			s pocetDnuHistorie=$lg($g(arrNastaveni("DTA")),2)
			i pocetDnuHistorie {
				s hrl=($h-pocetDnuHistorie)
				f  {
					s hrl=$o(^[dataDB]JRKos(hrl),-1) i hrl="" q
					k ^[dataDB]JRKos(hrl)
				}
			}
		}	
	}
	catch (ex){$$$CatchErrRest}
	q ret
}

}
