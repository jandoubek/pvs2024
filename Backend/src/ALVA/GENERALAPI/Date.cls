Class ALVA.GENERALAPI.Date Extends %RegisteredObject
{

/// počet měsíců mezi dvěma obdobíma 
ClassMethod pocMesObdOdDo(ByRef obdOd As %String, ByRef obdDo As %String) As %String
{
	// w ##class(ALVA.GENERALAPI.Date).pocMesObdOdDo("201807","201906")
	s mesic=0
	f obd=obdOd:1:obdDo {
		if ##class(ALVA.GENERALAPI.Date).validObd(obd) {
			s mesic=mesic+1
		}
	}
	s mesic=mesic-1
	if mesic<0 q 0
	q mesic
}

/// je období validní
ClassMethod validObd(ByRef obd As %String) As %String
{
	// w ##class(ALVA.GENERALAPI.Date).validObd("201813")
	if $l(obd)'=6 q 0
	s r=obd\100
	if (r<1900)!(r>2100) q 0
	s m=obd#100
	if (m<1)!(m>12) q 0
	q 1
}

/// vrací zda je vstup horolog
ClassMethod isHor(ByRef input As %String) As %String
{
	// w ##class(ALVA.GENERALAPI.Date).isHor("25.01.2019")
	s ret = 0
	try
	{
		s datum = ..horToDate(input)
		if (..ValDat(datum)){s ret = 1}
	}
	catch{s ret =0}
	q ret
}

/// validace data ve formátu DD.MM.RRRR
ClassMethod ValDat(ByRef datum As %String) As %String
{
	// w ##class(ALVA.GENERALAPI.Date).ValDat("25.01.2019")

	s den=+$p($g(datum),".",1)
	s mesic=+$p($g(datum),".",2)
	s rok=+$p($g(datum),".",3)

	s ret=1

	if ($g(den)<1)||($g(den)>31) { s ret= 0 }
	if ($g(mesic)<1)||($g(mesic)>12) { s ret= 0 }
	if ($g(rok)<1900) { s ret= 0 }
	
	// přestupný rok
	if (($g(rok)#4=0)&&($g(rok)#100'=0))||($g(rok)#400=0) {
		if ($g(mesic)=2)&&($g(den)>29) { s ret= 0 }
	}
	else {
		if ($g(mesic)=2)&&($g(den)>28) { s ret= 0 }
	}

 	q ret
}

/// připočítata k datu měsíce - vrací datum
ClassMethod DatumPlusMesice(ByRef datum As %String, ByRef mesice As %String) As %String
{
	// w ##class(ALVA.GENERALAPI.Date).DatumPlusMesice("25.1.2019",24)
	if $g(datum)="" q ""
	s rokP=+($g(mesice)/12)\1
	s mesicP=+$g(mesice)-(rokP*12)
	s mesic=+$p($g(datum),".",2)+mesicP
	s rokP2=0 if $g(mesic)>12 { s rokP2=+($g(mesic)/12)\1 }
	s rok=+$p($g(datum),".",3)+rokP+rokP2
	s mesic=$g(mesic)-(rokP2*12)
	s rok=##class(ALVA.GENERALAPI.String).formatStr($g(rok),"P",4,"0")
	s mesic=##class(ALVA.GENERALAPI.String).formatStr($g(mesic),"P",2,"0")
	s obdPPD=rok_mesic
	s ppd=##class(ALVA.GENERALAPI.Date).PocetDniVMesici(+$g(obdPPD))
	s den=+$p($g(datum),".",1)
	if $g(den)>$g(ppd) { s den=ppd }
	s den=##class(ALVA.GENERALAPI.String).formatStr($g(den),"P",2,"0")
	s mesic=##class(ALVA.GENERALAPI.String).formatStr($g(mesic),"P",2,"0")
	s ret=den_"."_mesic_"."_rok
 	q ret
}

/// zjistí zda je den v měsíci
ClassMethod SpravnyDenVMesici(ByRef obdobi As %String, ByRef den As %String) As %String
{
	// w ##class(ALVA.GENERALAPI.Date).SpravnyDenVMesici("201811",31)
	s ret=1
	s pocetDniVMesici=##class(ALVA.GENERALAPI.Date).PocetDniVMesici(obdobi)
	if $g(den)>$g(pocetDniVMesici) { s ret=0 }
	if $g(den)<0 { s ret=0 }
 	q ret
}

/// vrátí počet dní v měsící
ClassMethod PocetDniVMesici(ByRef obdobi As %String) As %String
{
	// w ##class(ALVA.GENERALAPI.Date).PocetDniVMesici("201902")
	s ret=0
	if $g(obdobi)'="" {
		s rok=+$e(obdobi,1,4)
		s mesic=+$e(obdobi,5,6)
 		s ret=$p("31:28:31:30:31:30:31:31:30:31:30:31",":",+mesic)
 		if (+mesic=2) {
	 		if (((rok#4=0)&(rok#100'=0))!(rok#400=0)) {
	 			s ret=ret+1
	 		}
 		}
	}
 	q ret
}

/// 
/// vrátí den v roce - neni-li vyplněn denH (horolog) vezme se aktuální den
/// 
ClassMethod DenVRoce(ByRef denH As %String) As %String
{
	// w ##class(ALVA.GENERALAPI.Date).DenVRoce()
	if $g(denH)="" { s denH=$p($h,",",1) }
	s den=$zdate(denH,8)
	s prvniDen=$e(den,1,4)_"0101"
	s prvniDenH=$zdateh(prvniDen,8)
	s denVRoce=denH-prvniDenH
	q denVRoce
}

/// 
/// vrátí týden v roce - neni-li vyplněn denH (horolog) vezme se aktuální den
/// 
ClassMethod TydenVRoce(ByRef denH As %String) As %String
{
	// w ##class(ALVA.GENERALAPI.Date).TydenVRoce()
	if $g(denH)="" { s denH=$p($h,",",1) }
	s denVRoce=##class(ALVA.GENERALAPI.Date).DenVRoce(denH)
	s tydenVRoce=denVRoce\7
	s zb=(denVRoce/7)-tydenVRoce
	if +zb>0 { s tydenVRoce=tydenVRoce+1 }
	q tydenVRoce
}

/// 
/// převede horolog na Datum
/// 
ClassMethod horToDate(ByRef horolog As %String) As %String
{
	// w ##class(ALVA.GENERALAPI.Date).horToDate($h)
	if (+$g(horolog)>0) { q $replace($zdate(horolog,4,,4),"/",".") }
	q ""
}

/// 
/// převede na Datum
/// 
ClassMethod toDate(ByRef den As %String, ByRef mesic As %String, ByRef rok As %String) As %String
{
	s datum = ""
	if ((den'="")&&(mesic'="")&&(rok'=""))
	{
		s den = ##class(ALVA.GENERALAPI.String).formatStr(den,"R",2,"0")
		s mesic =##class(ALVA.GENERALAPI.String).formatStr(mesic,"R",2,"0")
		s datum = den_"."_mesic_"."_rok
	}
	q datum
}

/// 
/// převede horolog na Rok
/// 
ClassMethod horToRok(ByRef horolog As %String) As %String
{
	if (horolog'="")
	{
 		q $p($zdate(horolog,4),"/",3)
	}
	q ""
}

/// 
/// převede horolog na Time
/// 
ClassMethod horToTime(ByRef horolog As %String) As %String
{
	if (horolog'="")
	{
 		q $ztime($p(horolog,",",2))
	}
	q ""
}

/// 
/// převede horolog na Time
/// 
ClassMethod TimeToHor(ByRef time As %String) As %String
{
	if (time'="")
	{
 		q $zth(time)
	}
	q ""
}

/// 
/// převede horolog na Index
/// 
ClassMethod horToIndex(ByRef horolog As %String) As %String
{
	//w ##class(ALVA.GENERALAPI.Date).horToIndex($h)
	// w $zdth("05/16/2023 00:10:00") je 66610,600 ... bude se spatne indexovat! KZ 16.5.2023
	if (horolog'="")
	{
 		q +$tr(horolog,",","")
	}
	q 0
}

/// 
/// převede horolog na Datetime
/// 
ClassMethod horToDateTime(ByRef horolog As %String, format) As %String
{
	//w ##class(ALVA.GENERALAPI.Date).horToDateTime($h)
	if (horolog'="")
	{
 		i +$g(format)=0 q $replace($zdate(horolog,4),"/",".")_" "_$ztime($p(horolog,",",2))	// 09.03.2023 12:34:18
 		i +$g(format)=1 q $zdate(horolog,3)_" "_$ztime($p(horolog,",",2))					// 2023-03-09 12:34:18
	}
	q ""
}

/// 
/// převede Datetime na horolog
/// 
ClassMethod DateTimeToHor(ByRef datetime As %String) As %String
{
	//w ##class(ALVA.GENERALAPI.Date).DateTimeToHor("16.10.2019 09:44:38")

	if (datetime'="")
	{
		s date=$p(datetime," ",1),time=$p(datetime," ",2)
		s dateH=..DateToHor(date),timeH=..TimeToHor(time)
		q +dateH_","_+timeH
	}
	q ""
}

/// 
/// převede horolog na den v týdnu slovně
/// 
ClassMethod horToDayInWeekCZ(ByRef horolog As %String) As %String
{
 	s index=$zdate(horolog,10)
 	q ..dayInWeekCZ(index)
}

ClassMethod dayInWeekCZ(index As %Integer) As %String
{
 	if index = "0" { q "neděle" }
 	elseif index = "1" { q "pondělí" }
 	elseif index = "2" { q "úterý" }
 	elseif index = "3" { q "středa" }
 	elseif index = "4" { q "čtvrtek" }
 	elseif index = "5" { q "pátek" }
 	elseif index = "6" { q "sobota" }
 	q ""
}

/// 
/// převede horolog na Typ dne
/// >= 5 svátek (5 svátek v pracovní den)
/// 4 neděle
/// 3 sobota
/// 1 pracovní den
/// 
ClassMethod horToDayType(ByRef horolog As %String) As %String
{
	// >= 5 svátek
	// 4 neděle
	// 3 sobota
	// 1 pracovní den
	s datum = ..horToDate(horolog)
	s rok = $p(datum,".",3)
	s mesic =+$p(datum,".",2)
	s den =+$p(datum,".",1)
	s pomocna = $$get^BLBXx(rok,mesic)
	s typ = $e(pomocna,den)
	q typ
}

ClassMethod datPracDen(ByRef d As %String) As %String
{
	// w ##class(ALVA.GENERALAPI.Date).datPracDen("22.04.2023")
	s h=..DateToHor(d)
	s t=..horToDayType(h)
	i t=1 { s p=1 }
	q +$g(p)
}

/// 
/// zistí zda je horolog pracovní den
/// 
ClassMethod isHorPracDay(ByRef horolog As %String) As %String
{
	// d ##class(ALVA.GENERALAPI.Date).isHorPracDay($h)
	s vystup = 1
	s index=..horToDayType(horolog)
	if (index'=1){s vystup=0}
	q vystup
}

/// 
/// převede horolog na období
/// 
ClassMethod horToObd(ByRef horolog As %String) As %String
{
	if +$g(horolog)<=0 { q "" }
	q $replace($e($zdate(horolog,3),1,7),"-","")
}

/// 
/// převede datum na horolog
/// 
ClassMethod DateToHor(ByRef dat As %String) As %String
{
	// w ##class(ALVA.GENERALAPI.Date).DateToHor("2019-04-18")
	i (dat = "") {q ""}
	s hor=0
	i dat?6n s dat=(dat*100)+1
 	i dat?8n s hor=$zdateh(dat,8)
 	i dat?1.2n1"."1.2n1"."4n s dat=$tr(dat,".","/")
 	i dat?1.2n1"/"1.2n1"/"4n s hor=$zdateh(dat,4,,,,,,,-1,1)
 	i dat?4n1"-"2n1"-"2n s hor=$zdateh(dat,3)
 	q hor
}

/// 
/// převede datum na období
/// 
ClassMethod DateToObd(ByRef dat As %String) As %String
{
	i (dat = "") {q ""}
	q ..horToObd(..DateToHor(dat))
}

/// 
/// převede datum na RRRRMMDD
/// 
ClassMethod DateToRRRRMMDD(ByRef dat As %String, ByRef oddelovac As %String) As %String
{
	if (dat = "") {q ""}
	if ('(dat?1.2n1"."1.2n1"."2.4n)) {q ""}
	s rok = $p(dat,".",3)

	if '(rok'?.1"-"1.2n)
	{
 	 	s p=1
 	  	if (rok<0) {s p=-1}
 	  	if ((rok*p)<50) { s rok = (2000+(rok*p))*p}
 		else{s rok = (1900+(rok*p))*p}
	}
	s vystup= rok*10000+($p(dat,".",2)*100)+$p(dat,".")
	if ($g(oddelovac)'=""){s vystup = $e(vystup,1,4)_oddelovac_ $e(vystup,5,6)_oddelovac_ $e(vystup,7,8)}
	q vystup
}

/// 
/// převede H na RRRR-MM-DD_HH-mm-SS
/// 
ClassMethod horToDatumCas(ByRef h As %String) As %String
{
	// w ##class(ALVA.GENERALAPI.Date).horToDatumCas($h)
	
	s date=$zdate($p($h,",",1),3)
	s rok=$p(date,"-",1)
	s mes=$p(date,"-",2)
	s den=$p(date,"-",3)
	
	s time=$ztime($p($h,",",2))
	s hod=$p(time,":",1)
	s min=$p(time,":",2)
	s sec=$p(time,":",3)

	q rok_"-"_mes_"-"_den_"_"_hod_"-"_min_"-"_sec
}

/// 
/// převede datum MM.DD.RRRR na MMDDRRR
/// 
ClassMethod DateToDDMMRRRR(ByRef date As %String) As %String
{
	// w ##class(ALVA.GENERALAPI.Date).DateToDDMMRRRR("5.2.2021")
	
	s d=$p(date,".",1)
	s m=$p(date,".",2)
	s r=$p(date,".",3)
	
	if d="" q ""
	if m="" q ""
	if r="" q ""
	
	s dd=##class(ALVA.GENERALAPI.String).formatStr(d,"P",2,"0")
	s mm=##class(ALVA.GENERALAPI.String).formatStr(m,"P",2,"0"	)

	q dd_mm_r
}

/// 
/// převede datum MM.DD.RRRR na MMDDRRR
/// 
ClassMethod DateToDDMMRR(ByRef date As %String) As %String
{
	// w ##class(ALVA.GENERALAPI.Date).DateToDDMMRR("5.2.2021")
	
	s d=$p(date,".",1)
	s m=$p(date,".",2)
	s r=$e($p(date,".",3),3,4)
	
	if d="" q ""
	if m="" q ""
	if r="" q ""
	
	s dd=##class(ALVA.GENERALAPI.String).formatStr(d,"P",2,"0")
	s mm=##class(ALVA.GENERALAPI.String).formatStr(m,"P",2,"0"	)
	s rr=##class(ALVA.GENERALAPI.String).formatStr(r,"P",2,"0"	)

	q dd_mm_r
}

ClassMethod DateSQL2CZ(ByRef d As %String, ByRef sep As %String) As %String
{
	// w ##class(ALVA.GENERALAPI.Date).DateSQL2CZ("2018-12-31")
	if $g(sep)="" { s sep="-" }
	q $p(d,sep,3)_"."_$p(d,sep,2)_"."_$p(d,sep,1)
}

}
