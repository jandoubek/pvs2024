Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYLinky.API.LinkyFce Extends %RegisteredObject
{

ClassMethod cisloLinkyDoIndexu(cisloLinky As %String) As %String
{
 //konverze cisla linky do indexu linky
 s cisloLinky=$g(cisloLinky) q $e("0000000",1,7-$l(cisloLinky))_cisloLinky
}

ClassMethod indexNaCisloLinky(indexLinky As %String) As %String
{
 //konverze indexu linky na cislo
 q $e(indexLinky,2,7)
}

}
