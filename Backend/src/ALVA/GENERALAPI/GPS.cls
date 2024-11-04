Class ALVA.GENERALAPI.GPS [ Abstract ]
{

ClassMethod DegToRad(uhel As %String) As %String
{
  q uhel*$zpi/180
}

ClassMethod RadToDeg(uhel As %String) As %String
{
  q uhel*57.296
}

ClassMethod VzdalenostGPS(lat1 As %String, lon1 As %String, lat2 As %String, lon2 As %String) As %String
{
	//w ##class(ALVA.GENERALAPI.GPS).VzdalenostGPS(50.128328,14.493012,50.126062,14.443097)
	//vypocet vzdalenosti dvou mist na kouli v metrech
	//lat=zem.sirka
	//lon=zem.delka
	s lat1=..DegToRad(lat1)
    s lon1=..DegToRad(lon1)
    s lat2=..DegToRad(lat2)
    s lon2=..DegToRad(lon2)
    q (6371*$zarccos(($zsin(lat1)*$zsin(lat2))+($zcos(lat1)*$zcos(lat2)*$zcos(lon2-lon1))))*1000
}

ClassMethod AzimutGPS(lat1 As %String, lon1 As %String, lat2 As %String, lon2 As %String) As %String
{
	//w ##class(ALVA.GENERALAPI.GPS).AzimutGPS(50.128328,14.493012,50.126062,14.443097)
	//vypocet azimutu dvou mist na kouli ve stupnich
	//lat=zem.sirka
	//lon=zem.delka
	s lat1=..DegToRad(lat1)
    s lon1=..DegToRad(lon1)
    s lat2=..DegToRad(lat2)
    s lon2=..DegToRad(lon2)
	//azimut -  musime rozlisovat, ktery z obou bodu je pocatecni a ktery koncovy, staci hlidat pouze zemepisnou sirku
	//
	//BOD 1 lezi severneji nez BOD 2, tj. lat1>lat2:
	//AZIMUT = 180+arctg{sin(D2-D1)*cos(S2)/[sin(S2)*cos(S1)-cos(S2)*sin(S1)*cos(D2-D1)]}
	//
	//BOD 1 lezi jizneji nez BOD 2, tj. lat1<lat2:
	//AZIMUT = arctg{sin(D2-D1)*cos(S2)/[sin(S2)*cos(S1)-cos(S2)*sin(S1)*cos(D2-D1)]}
	//
	//Vyjde-li azimut záporný, přičteme 360°
	//
	s azm=0
	i lat1>lat2 {
		s azm=1+($zarctan($zsin(lon2-lon1)*$zcos(lat2)/($zsin(lat2)*$zcos(lat1)-$zcos(lat2)*$zsin(lat1)*$zcos(lon2-lon1))))
	}
	else {
		s azm=$zarctan($zsin(lon2-lon1)*$zcos(lat2)/($zsin(lat2)*$zcos(lat1)-$zcos(lat2)*$zsin(lat1)*$zcos(lon2-lon1)))
	}
	i azm<0 s azm=azm+(2*$zpi)
	q ..RadToDeg(azm)
}

}
