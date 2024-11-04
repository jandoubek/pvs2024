Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYZastavky.API.ZastavkyFce Extends %RegisteredObject
{

ClassMethod test()
{
	//d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).test()
	s sys("U","IdFa")="VS_CSAD"
    s sys("U","delimiter")=$c(0)
    s sys("U","SystemDB")="MLINE"
    s sys("C","User")=007
    s sys("U","DATA")="USER"
    s sys("U","MLP")=7
    s sys("U","fullName")="007"
    s sys("U","loginName")="007"
    s sys("C","GUID")=7
 	k arr
	//d ..nactiGPS(.sys,$lb(27934,3),.arr) zw arr
	//s arr("GLB")="^||w"
	//d ..zastavkyZeSkupiny(.sys,$lb(10),.arr) zw arr
	d ..pouziteZastavky(.sys,.arr) zw arr
}

ClassMethod nactiNazev(ByRef sys As %String, zastavkaId As %String, ByRef arr As %String) As %String
{
	$$$Init
	
		$$$FillParams
		//vrati nazev zastavky
		//IN
		//
		// zastavkaId
		//
		//OUT
		//                
		// arr("DTA")=$lb(obec,castObce,lokalita,blizkaObec)
		//
		k arr("DTA") s arr("DTA")=""
		//
		i zastavkaId {
			s valDB=$g(^[dataDB]JRZ(zastavkaId))
			//nazev pro autobusovou zastávku
			i '$p(valDB,"$",17) {
				s $li(arr("DTA"),1)=$p($p(valDB,"$",2),",",1)
 				s $li(arr("DTA"),2)=$p($p(valDB,"$",2),",",2)
 				s $li(arr("DTA"),3)=$p($p(valDB,"$",2),",",3)
			}
			//nazev vlakovou zastavku - jen jeden text, nerozdeluje se na casti
 			i +$p(valDB,"$",17) {
				s $li(arr("DTA"),1)=$p(valDB,"$",2)
				s $li(arr("DTA"),2)=""
				s $li(arr("DTA"),3)="" 
 			}
 			s $li(arr("DTA"),4)=$p(valDB,"$",3)
 			
		}
	q ret
}

ClassMethod zastavkyZeSkupiny(ByRef sys As %String, skupinaLstId As %String, ByRef arr As %String) As %String
{
	$$$Init
	
		$$$FillParams
		//vrati zastavkaId pouzitych zastavek
		//IN
		// skupinaLstId=$lb(skupinaId,skupinaId,...)
		// arr("GLB")=global pro vystupni data, pokud neni, pak je vystup do arr("DTA",...) 
		// arr("PAR","linkyId") = $lb(linkaId, linkaId)	
		//
		//OUT
		// arr("DTA",zastavkaId,"skupinaLinky",linkaId,skupinaId)="" nebo @arr("GLB")@("DTA",zastavkaId,"skupinaLinky",LinkaId,skupinaId)=""
		//
		s skupinaLstId=$g(skupinaLstId) s glb=$g(arr("GLB"))
		i glb'="" {k @glb@("DTA")} else {k arr("DTA")}
		s linkyId = $g(arr("PAR","linkyId")) s linkyIdConv = ""
		// converze linek z inputu do spravneho formatu v DB
		i linkyId'= "" {
			f i=1:1:$ll(linkyId) {
				s linkaId = $lg(linkyId,i)
				s $list(linkyIdConv, *+1) = $$cnvLinInd^JRapi(linkaId)
			}
		}
		//
		// pouzite zastavky - linky
		
 		f cnt=1:1:$ll(skupinaLstId) {
	 		s skupinaId=$lg(skupinaLstId,cnt) i skupinaId="" continue
	 		i skupinaId["tmp" continue
 	 		s linkaId="" f {
	 	 		s linkaId=$o(^[dataDB]JRL(skupinaId,linkaId)) i linkaId="" q
				// Pokud je parametr filtru na konkretni linky
				i (linkyIdConv'= "")&&('$lf(linkyIdConv,linkaId)) continue
	 	 		s bodId="" f {
		 	 		s valDB="" s bodId=$o(^[dataDB]JRL(skupinaId,linkaId,"J",bodId),1,valDB) i bodId="" q
		 	 		s zastavkaId=+valDB
		 	 		i zastavkaId {
			 	 		i glb'="" {s @glb@("DTA",zastavkaId,"skupinaLinky",linkaId,skupinaId)=""} else {s arr("DTA",zastavkaId,"skupinaLinky",linkaId,skupinaId)=""}
			 	 	}
 	 	 		}
 	 		}
 		}
	
	q ret
}

ClassMethod pouziteZastavky(ByRef sys As %String, ByRef arr As %String) As %String
{
	$$$Init
	
		$$$FillParams
		//vrati zastavkaId pouzitych zastavek
		//IN
		// arr("GLB")=global pro vystupni data, pokud neni, pak je vystup do arr("DTA",...) 
		//
		//OUT
		// arr("DTA",zastavkaId,"skupinaLinky",linkaId,skupinaId)="" nebo @glb@("DTA",zastavkaId,"skupinaLinky",linkaId,skupinaId)=""
		// arr("DTA",zastavkaId,"platneLinky",linkaId,hrlKey)="" nebo @glb@("DTA",zastavkaId,"platneLinky",linkaId,hrlKey)=""
		//
		s glb=$g(arr("GLB"))
		i glb'="" {k @glb@("DTA")} else {k arr("DTA")}
		//
		// pouzite zastavky - linky
		s skupinaLstId="" s skupinaId="" f {
	 		s skupinaId=$o(^[dataDB]JRL(skupinaId)) i skupinaId="" q
	 		i skupinaId["tmp" continue
	 		s $li(skupinaLstId,*+1)=skupinaId
 		}
 		k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).zastavkyZeSkupiny(.sys,skupinaLstId,.arrDta)
		i glb'="" {m @glb@("DTA")=arrDta("DTA")} else {m arr("DTA")=arrDta("DTA")}
		k arrDta
		//
		// vyhledam pouzite zastavky - linky v archivu linek
 		s linkaId="" f {
	 		s linkaId=$o(^[dataDB]JRAPL(linkaId)) i linkaId="" q
	 		s hrlKey="" f {
		 		s hrlKey=$o(^[dataDB]JRAPL(linkaId,hrlKey)) i hrlKey="" q
		 		s bodId="" f {
			 		s valDB="" s bodId=$o(^[dataDB]JRAPL(linkaId,hrlKey,"arr","J",bodId),1,valDB) i bodId="" q
			 		s zastavkaId=+valDB
	 	 	 		i zastavkaId {
			 	 		i glb'="" {s @glb@("DTA",zastavkaId,"platneLinky",linkaId,hrlKey)=""} else {s arr("DTA",zastavkaId,"platneLinky",linkaId,hrlKey)=""}
			 	 	}
		 		}
	 		}
		}
 q ret
}

ClassMethod nactiGPS(ByRef sys As %String, id As %String, ByRef arr As %String) As %String
{
	$$$Init
	
		$$$FillParams
		//vrati souradnice zastavky
		//IN
		//
		// id=$lb(zastavkaId,oznacnikId)
		//
		//OUT
		//                
		// arr("DTA")=$lb(gpsN,spsE)
		//
		s id=$g(id) s zastavkaId=$lg(id,1) s oznacnikId=$lg(id,2)
		k arr("DTA") s arr("DTA")=$lb("","")
		//
		i zastavkaId {
			k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaId,"",.arrDta)
			s arrDta("DTA")=$g(arrDta("DTA")) s gpsN=$lg(arrDta("DTA"),19) s gpsE=$lg(arrDta("DTA"),20)
			i (gpsN)&(gpsE) s arr("DTA")=$lb(gpsN,gpsE)
			i oznacnikId {
				k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyOznacniky).nacti(.sys,$lb(zastavkaId,oznacnikId),"",.arrDta)
				s arrDta("DTA")=$g(arrDta("DTA")) s gpsN=$lg(arrDta("DTA"),2) s gpsE=$lg(arrDta("DTA"),3)
				i (gpsN)&(gpsE) s arr("DTA")=$lb(gpsN,gpsE)
			}
		}

	q ret
}

ClassMethod getPrejezd(ByRef sys As %String, zasOdId As %String, zasDoId As %String, ByRef arr As %String) As %String
{
	$$$Init
	s systemDB=$g(sys("U","SystemDB"),"MLINE")
	
		
		// w ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).getPrejezd(,28040,27904,.arr)
		
		// vrati vzdalenost a cas jizdy mezi zastavkami podle mapovych podkladu
		//OUT
		//                
		// arr("DTA")=$lb(vzdalenost,dobajizdy)
		//
		// vzdalenost - v metrech
		// dobajizdy - v minutach
		
		// Udelam request
		/*
        s httprequest=##class(%Net.HttpRequest).%New()
	    s httprequest.Server=$p($lg($g(^[systemDB]EDISON("System","WebMLINE","Settings"),$lb()),1),":",1) //"185.111.99.174"
	    i httprequest.Server="" s httprequest.Server="185.111.99.174"
	    s httprequest.Port=57772
	    s httprequest.Timeout=5
	    
	    d httprequest.SetParam("zasOd", zasOdId)
	    d httprequest.SetParam("zasDo", zasDoId)
	   	
	    $$$ThrowOnError(httprequest.Get("/alwa/registry/zastavky/prejezd"))
	    
	    #dim httpresponse as %Net.HttpResponse=httprequest.HttpResponse
	   	i httpresponse.StatusCode=200{
		   	if $isobject(httpresponse.Data){
			   	s data={}.%FromJSON(httpresponse.Data.Read(httpresponse.ContentLength))
		   	}
		   	else{
			   	s data={}.%FromJSON(httpresponse.Data)
		   	}
			
			s arr("DTA")=$lb($j(+data.delkaM,0,0),$j(+data.casS/60,0,0))
		 } else{
		    s arr("DTA")=$lb(-1,-1)
	    }
	    */
	    
	    k in								
		s in("zasOdId")=zasOdId  	// cis id zastavka od 
		s in("zasDoId")=zasDoId 	// cis id zastavka do 
		
		s sc=##class(ALVA.ISY.ISYCloud.Client.Zastavky).Prejezd(.sys,.in,.out)
		i sc=$$$OK{
			s arr("DTA")=out("prejezd")
		}
		else{
			 s arr("DTA")=$lb(-1,-1)
		}
	q ret
}

ClassMethod getVzdalenost(ByRef sys As %String, zasId As %String, misto As %String, ByRef arr As %String) As %String
{
	$$$Init
	s systemDB=$g(sys("U","SystemDB"),"MLINE")
	
		
	// 	w ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).getVzdalenost(,28040,"Praha",.arr)
	// 	IN
	//
	//
	// vrati vzdalenost a cas jizdy mezi zastavkou a mistem na mape
	//	OUT
	//                
	// 	arr("DTA")=$lb(vzdalenost,dobajizdy)
	//
	// 	vzdalenost - v metrech
	// 	doba jizdy - v minutach
	
	// Udelam request
	/*
    s httprequest=##class(%Net.HttpRequest).%New()
    s httprequest.Server=$p($lg($g(^[systemDB]EDISON("System","WebMLINE","Settings"),$lb()),1),":",1) //"185.111.99.174"
    i httprequest.Server="" s httprequest.Server="185.111.99.174"
    s httprequest.Port=57772
    s httprequest.Timeout=5
    
    d httprequest.SetParam("zas", zasId)
    d httprequest.SetParam("misto", misto)
   	
    $$$ThrowOnError(httprequest.Get("/alwa/registry/zastavky/vzdalenostMista"))
    
    #dim httpresponse as %Net.HttpResponse=httprequest.HttpResponse
    i httpresponse.StatusCode=200{
	   	if $isobject(httpresponse.Data){
		   	s data={}.%FromJSON(httpresponse.Data.Read(httpresponse.ContentLength))
	   	}
	   	else{
		   	s data={}.%FromJSON(httpresponse.Data)
	   	}
		
		s arr("DTA")=$lb($j(+data.delkaM,0,0),$j(+data.casS/60,0,0))
    } else{
	    s arr("DTA")=$lb(-1,-1)
    }
    */
    
   	k in								
	s in("zasId")=zasId  
	s in("misto")=misto 

	s sc=##class(ALVA.ISY.ISYCloud.Client.Zastavky).VzdalenostMista(.sys,.in,.out)
	i sc=$$$OK{
		s arr("DTA")=out("vzdalenost")
	}
	else{
		 s arr("DTA")=$lb(-1,-1)
	}

	q ret
}

ClassMethod getSouradnice(ByRef sys As %String, zasId As %String, ByRef arr As %String) As %String
{
	$$$Init
	s systemDB=$g(sys("U","SystemDB"),"MLINE")
	
		
		// d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).getPrejezd(,28040,27904,.arr)
		
		// vrati vzdalenost a cas jizdy mezi zastavkami podle mapovych podkladu
		//OUT
		//                
		// arr("DTA")=$lb(vzdalenost,dobajizdy)
		//
		// vzdalenost - v metrech
		// dobajizdy - v minutach
		
		// Udelam request
		/*
        s httprequest=##class(%Net.HttpRequest).%New()
	    s httprequest.Server=$p($lg($g(^[systemDB]EDISON("System","WebMLINE","Settings"),$lb()),1),":",1) //"185.111.99.174"
	    i httprequest.Server="" s httprequest.Server="185.111.99.174"
	    s httprequest.Port=57772
	    s httprequest.Timeout=5
	    
	    d httprequest.SetParam("zas", zasId)
	    	   	
	    $$$ThrowOnError(httprequest.Get("/alwa/registry/zastavky/souradnice"))
	    
	    #dim httpresponse as %Net.HttpResponse=httprequest.HttpResponse
	   	
	   	if $isobject(httpresponse.Data){
		   	s data={}.%FromJSON(httpresponse.Data.Read(httpresponse.ContentLength))
	   	}
	   	else{
		   	s data={}.%FromJSON(httpresponse.Data)
	   	}

        s arr("DTA")=$lb(+data.lon,+data.lat)
        */
	
	k in								
	s in("zasId")=zasId  
	s sc=##class(ALVA.ISY.ISYCloud.Client.Zastavky).Souradnice(.sys,.in,.out)
	i sc=$$$OK{
		s arr("DTA")=out("souradnice")
	}
	else{
		 s arr("DTA")=$lb(-1,-1)
	}
	
	q ret
}

ClassMethod vzdalenostPodleGPSMapy(ByRef sys As %String, id As %String, ByRef arr As %String) As %String
{
	$$$Init
	$$$FillParams

	//vrati vzdalenost a cas jizdy mezi zastavkami podle mapovych podkladu
	//IN
	//
	// 	id=$lb(zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId)
	// 	arr("PAR","typ")= 0/car_fast,1/car_fast_traffic,2/car_short,3/foot_fast,4/bike_road,5/bike_mountain
	//	arr("PAR","zdrojDat")= AD = 0, MHD = 1
	//
	//OUT
	//                
	// arr("DTA")=$lb(vzdalenost,dobajizdy)
	//
	// vzdalenost - v metrech
	// dobajizdy - v minutach
	//
	s id=$g(id) s zastavkaOdId=$lg(id,1) s oznacnikOdId=$lg(id,2) s zastavkaDoId=$lg(id,3) s oznacnikDoId=$lg(id,4)
	k arr("DTA")
	s zdrojDat = $g(arr("PAR","zdrojDat"))

	s zastavkaOdIdCis = "" s zastavkaDoIdCis = ""
	i zdrojDat = 1 {
		s zastavkaOdIdCis = $g(^[dataDB]ALVA.MHD.ZST(IdFa,1,"DTA",zastavkaOdId,"DTA",1,"CisloCIS"))
		s zastavkaDoIdCis = $g(^[dataDB]ALVA.MHD.ZST(IdFa,1,"DTA",zastavkaDoId,"DTA",1,"CisloCIS"))
	}
	// PS: prozatim nechavam v else, kde neni MHD budu automaticky pocitat ze je AD
	else {
		// DZ
		k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaOdId,"",.arrDta)
		s arrDta("DTA")=$g(arrDta("DTA")) s zastavkaOdIdCis=$lg(arrDta("DTA"),14)
		
		k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaDoId,"",.arrDta)
		s arrDta("DTA")=$g(arrDta("DTA")) s zastavkaDoIdCis=$lg(arrDta("DTA"),14)

	}
	i (zastavkaOdIdCis="")!(zastavkaDoIdCis="") s arr("DTA") = $lb(-1,-1) q  // chybi cisove udaje
	i (zastavkaOdIdCis = zastavkaDoIdCis) s arr("DTA") = $lb(0, 0) q		// jde o stejnou zastavku

	
	d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).getPrejezd(.sys,zastavkaOdIdCis,zastavkaDoIdCis,.arr)
	q 
	
	//
	k gpsIn,gpsOut s dobaJizdy="" s vzdalenost=""  s arr("DTA")=$lb(vzdalenost,dobaJizdy)
	//
	k arrDta d ..nactiGPS(.sys,$lb(zastavkaOdId,oznacnikOdId),.arrDta)
	s arrDta("DTA")=$g(arrDta("DTA")) s gpsN=$lg(arrDta("DTA"),1) s gpsE=$lg(arrDta("DTA"),2)
	i (gpsN&gpsE) s gpsIn("start")=$lb(gpsE,gpsN)
	//
	k arrDta d ..nactiGPS(.sys,$lb(zastavkaDoId,oznacnikDoId),.arrDta)
	s arrDta("DTA")=$g(arrDta("DTA")) s gpsN=$lg(arrDta("DTA"),1) s gpsE=$lg(arrDta("DTA"),2)
	i (gpsN&gpsE) s gpsIn("end")=$lb(gpsE,gpsN)
	//
	k arrDta
	i ($d(gpsIn("start")))&($d(gpsIn("end"))) {
		/*
		/// in("start")=$lb(longitude,latitude)
		/// in("end")=$lb(longitude,latitude)
		s typ=+$g(arr("PAR","typ"))
		s gpsIn("routeType")=$s(typ=0:"car_fast",typ=1:"car_fast_traffic",typ=2:"car_short",typ=3:"foot_fast",typ=4:"bike_road",typ=5:"bike_mountain",1:"car_fast")
		s ret=##class(ALWA.MAPY.API.Routing).Route(.gpsIn,.gpsOut)
		i ret {
			s vzdalenost=$g(gpsOut("length"))
			s dobaJizdy=$j(($g(gpsOut("duration"))/60),0,0)
			s arr("DTA")=$lb(vzdalenost,dobaJizdy)
		}
		*/
		
		k in								
		s in("souradniceOd")=gpsIn("start")  
		s in("souradniceDo")=gpsIn("end")  
		s sc=##class(ALVA.ISY.ISYCloud.Client.Zastavky).VzdalenostSouradnic(.sys,.in,.out)
		i sc=$$$OK{
			s arr("DTA")=out("vzdalenost")
		}
		else{
			 s arr("DTA")=$lb(-1,-1)
		}
	}
	
	q ret
}

ClassMethod vzdalenostPodleGPSPrimo(ByRef sys As %String, id As %String, ByRef arr As %String) As %String
{
	$$$Init
	
		$$$FillParams
		//vrati vzdalenost a cas jizdy mezi zastavkami vzduchem
		//IN
		//
		// id=$lb(zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId)
		//
		//OUT
		//                
		// arr("DTA")=$lb(vzdalenost)
		//
		// vzdalenost - v metrech
		//
		s id=$g(id) s zastavkaOdId=$lg(id,1) s oznacnikOdId=$lg(id,2) s zastavkaDoId=$lg(id,3) s oznacnikDoId=$lg(id,4)
		k arr("DTA")
		//
		k gpsIn,gpsOut s vzdalenost=""  s arr("DTA")=$lb(vzdalenost)
		//
		k arrDta d ..nactiGPS(.sys,$lb(zastavkaOdId,oznacnikOdId),.arrDta)
		s arrDta("DTA")=$g(arrDta("DTA")) s gpsN=$lg(arrDta("DTA"),1) s gpsE=$lg(arrDta("DTA"),2)
		i (gpsN&gpsE) s gpsIn("start")=$lb(gpsE,gpsN)
		//
		k arrDta d ..nactiGPS(.sys,$lb(zastavkaDoId,oznacnikDoId),.arrDta)
		s arrDta("DTA")=$g(arrDta("DTA")) s gpsN=$lg(arrDta("DTA"),1) s gpsE=$lg(arrDta("DTA"),2)
		i (gpsN&gpsE) s gpsIn("end")=$lb(gpsE,gpsN)
		//
		k arrDta
		i ($d(gpsIn("start")))&($d(gpsIn("end"))) {
			s vzdalenost=##class(ALVA.GENERALAPI.GPS).VzdalenostGPS($lg(gpsIn("start"),2),$lg(gpsIn("start"),1),$lg(gpsIn("end"),2),$lg(gpsIn("end"),1))
			s arr("DTA")=$lb(vzdalenost)
		}
	
	
	q ret
}

ClassMethod getObecZastavky(ByRef sys As %String, id As %String, ByRef arr As %String) As %String
{
	$$$Init
	
	$$$FillParams
	//	IN
	//
	// 	id=$lb(zastavkaId)
	//	arrDta("PAR","zdrojDat")  AD = 0, MHD = 1
	//
	//	OUT
	//                
	// 	arr("DTA")=$lb(obec)
	s zastavkaId = $lg(id, 1) k arr("DTA")
	k arrDta s arrDta("PAR","zdrojDat") = $g(arr("PAR","zdrojDat"))
	d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaId,"",.arrDta)
	s arrDta("DTA")=$g(arrDta("DTA")) s obec=$lg(arrDta("DTA"),1)
	s arr("DTA") = $lb(obec)
	
	q ret
}

ClassMethod vratVzdalenostZastavekNeboOznacniku(ByRef sys As %String, id As %String, ByRef arr As %String)
{
	//	IN
	// 	
	//	id = $lb(zastavkaOdId,oznacnikOdId,zastavkaDoId,oznacnikDoId)
	//
	//	OUT
	//	
	//	arr("DTA") = $lb(vzdalenost,trvani)

	$$$FillParams
	s zastavkaOdId = $lg(id, 1) s oznacnikOdId = $lg(id, 2)  s zastavkaDoId = $lg(id, 3) s oznacnikDoId = $lg(id, 4)

	k arr("DTA")
	// pokud jedna ze zastavek neni zadana, vracime default hodnotu
	i (zastavkaOdId = "")||(zastavkaDoId = "")  s arr("DTA") = $lb(0) ret
	s DoGPSN = "" s DoGPSE = ""
	if (oznacnikDoId '= 0) {
	// nacist souradnice 
		k arrDta
		d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyOznacniky).nacti(.sys,$lb(zastavkaDoId,oznacnikDoId),"",.arrDta)
		s arrDta = $g(arrDta("DTA"))
		s DoGPSN = $lg(arrDta,2)
		s DoGPSE = $lg(arrDta,3)
	}

	if (oznacnikDoId = 0)||(DoGPSN = "")||(DoGPSE = "") {
	// nacist souradnice 
		k arrDta
		d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaDoId,"",.arrDta)
		s arrDta = $g(arrDta("DTA"))
		s CIS = $lg(arrDta,14)
		s DoGPSN = $lg(arrDta,19)
		s DoGPSE = $lg(arrDta,20)

		// u zastavky nejsou kompletni souradnice, nacteme je pomoci CIS
		if (DoGPSN = "")||(DoGPSE = "") {
			k arrDta s arrDta("zasId") =  CIS
			d ##class(ALVA.ISY.ISYCloud.Client.Zastavky).Souradnice(.sys,.arrDta,.out)
			s out = $g(out("souradnice"))
			s DoGPSN = $lg(out,2)
			s DoGPSE = $lg(out,1)
		}

	}
	s OdGPSE = ""  s OdGPSN = ""
	if oznacnikOdId '= 0 {
		k arrDta
		d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyOznacniky).nacti(.sys,$lb(zastavkaOdId,oznacnikOdId),"",.arrDta)
		s arrDta =  $g(arrDta("DTA"))
		s OdGPSN = $lg(arrDta,2)
		s OdGPSE = $lg(arrDta,3)
	}
	if (oznacnikOdId = 0)||(OdGPSN= "")||(OdGPSE = "") {
		k arrDta
		d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaOdId,"",.arrDta)
		s arrDta =  $g(arrDta("DTA"))
		s CIS = $lg(arrDta,14)
		s OdGPSN = $lg(arrDta,19)
		s OdGPSE = $lg(arrDta,20)

		// u zastavky nejsou kompletni souradnice, nacteme je pomoci CIS
		if (OdGPSN = "")||(OdGPSE = "") {
			k arrDta s arrDta("zasId") =  CIS
			d ##class(ALVA.ISY.ISYCloud.Client.Zastavky).Souradnice(.sys,.arrDta,.out)
			s out = $g(out("souradnice"))
			s OdGPSN = $lg(out,2)
			s OdGPSE = $lg(out,1)
		}
	}
	// pretypovani souradnic pokud jsou ulozeny v jinem formatu
	s OdGPSE = $REPLACE(OdGPSE,",",".")
	s OdGPSN = $REPLACE(OdGPSN,",",".")
	s DoGPSE = $REPLACE(DoGPSE,",",".")
	s DoGPSN = $REPLACE(DoGPSN,",",".")
	
	// nacist vzdalenost
	k arrDta
	s arrDta("souradniceOd") = OdGPSE_","_OdGPSN s arrDta("souradniceDo") = DoGPSE_","_DoGPSN
	d ##class(ALVA.ISY.ISYCloud.Client.Zastavky).VzdalenostSouradnic(.sys,.arrDta,.out)
	s vzdalenost = $lg($g(out("vzdalenost")),1)
	s trvani = $lg($g(out("vzdalenost")),2)
	s arr("DTA") = $lb(vzdalenost,trvani)
}

ClassMethod getPocetTisku(ByRef sys As %String, zastavkaId As %String, ByRef arr As %String) As %String
{
	$$$Init
	
	$$$FillParams
	//	IN
	//
	// 	id=$lb(zastavkaId)
	//
	//	OUT
	//                
	// 	arr("DTA")=$lb(pocetTisku)
	//
	// 	Funkce vrati pocet tisku:
	//			1 jednosmerna bez oznacniku
	//			2 obousmerna bez oznacniku
	//			N pocet oznacniku pokud ma jakekoliv definovane
	
	k arr("DTA")
	s pocetOznacniku = 0 s pocetTisku = 1
	k arrDta
	d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaId,"",.arrDta)
	s arrDta = $g(arrDta("DTA"))
	s obousmerna = $lg(arrDta, 8)
	if obousmerna s pocetTisku = 2

	k arrDta
	d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyOznacniky).seznam(.sys,zastavkaId,"",.arrDta)
	s oznacnikId = "" f {
		s oznacnikId = $o(arrDta("DTA",oznacnikId)) i oznacnikId = "" q
		s pocetOznacniku = pocetOznacniku + 1
	}
	i pocetOznacniku s pocetTisku = pocetOznacniku
	s arr("DTA") = $lb(pocetTisku)
}

ClassMethod getIdZastavky(ByRef sys As %String, id As %String, ByRef arr As %String) As %String
{
	$$$Init
	
	$$$FillParams
	//	IN
	//
	// 	id=$lb(NazevObce,CastObce,Nazev)
	//
	//	OUT
	//                
	// 	arr("DTA")=zastavkaId
	//
	

	s NazevObce = $lg(id,1) s CastObce = $lg(id,2) s Nazev = $lg(id,3)
	s NazevObce = $ZCONVERT(##class(ALVA.GENERALAPI.String).HackyACarkyFuc(NazevObce),"U")
	s CastObce = $ZCONVERT(##class(ALVA.GENERALAPI.String).HackyACarkyFuc(CastObce),"U")
	s Nazev = $ZCONVERT(##class(ALVA.GENERALAPI.String).HackyACarkyFuc(Nazev),"U")
	k arr("DTA")
	$$$TMPGLBSET(tmbglb)
	k arrDta s arrDta("GLB") = tmbglb
	d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).seznam(.sys,.arrDta)

	s zastavkaId="" f {
			s valDB="" s zastavkaId=$o(^[dataDB]JRZ(zastavkaId),1,valDB) i zastavkaId="" q
			s nazevU=$p($p(valDB,"$",2),",",1) s nazev=$p($p(valDB,"$",2),",",2) s lokalita=$p($p(valDB,"$",2),",",3)
			s nazevU = $ZCONVERT(##class(ALVA.GENERALAPI.String).HackyACarkyFuc(nazevU),"U")
			s nazev = $ZCONVERT(##class(ALVA.GENERALAPI.String).HackyACarkyFuc(nazev),"U")
			s lokalita = $ZCONVERT(##class(ALVA.GENERALAPI.String).HackyACarkyFuc(lokalita),"U")
			i (nazevU = NazevObce)&&(CastObce=nazev)&&(lokalita=Nazev)  {
				s arr("DTA") = zastavkaId ret
			}
	}
}

ClassMethod getNazevProObehy(ByRef sys As %String, id As %String, ByRef arr As %String) As %String
{
	$$$Init
	
	$$$FillParams
	//	IN
	//	arr("PAR") = data zastavky
	// 	id=$lb(NazevObce,CastObce,Nazev)
	//
	//	OUT
	//                
	// 	arr("DTA")= "nazev zastavky"
	//
	//  Fce vraci nazev pro zastavku pro obehy. Ta se lisi na zaklade zdroje dat
	//	$lg(arrDta("DTA"),1)_","_$lg(arrDta("DTA"),2)_","_$lg(arrDta("DTA"),3)_"/"_$lg(arrDta("DTA"),4)

	s zdrojDat = $g(arr("PAR","zdrojDat"))
	m arrDta("DTA") = arr("DTA")

	s nazev = ""
	// AD
	i zdrojDat = 0 {
		s nazev = $lg(arrDta("DTA"),1)_","_$lg(arrDta("DTA"),2)_","_$lg(arrDta("DTA"),3)_"/"_$lg(arrDta("DTA"),4)
	}
	//MHD
	i zdrojDat = 1 {
		s nazev = $lg(arrDta("DTA"),14)_","_$lg(arrDta("DTA"),1)_","_$lg(arrDta("DTA"),2)_","_$lg(arrDta("DTA"),3)_"/"_$lg(arrDta("DTA"),4)
	}

	s arr("DTA","Nazev") = nazev
}

}
