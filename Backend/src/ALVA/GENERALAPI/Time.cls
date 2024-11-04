Class ALVA.GENERALAPI.Time [ Abstract ]
{

/// 
/// konverze min na hh:mm, min muzou byt > 1440
/// 
ClassMethod MinToHHMM(min As %String, p As %String) As %String
{
	//w ##class(ALVA.GENERALAPI.Time).MinToHHMM(320)
	i ($g(min)="")&&(+$g(p)=1) { q "" }
	s min=$g(min) s par=0 i min<0 s par=1 s min=(min*(-1))
	s hhmm=$tr($j((min+.5\1)\60+((min+.5\1)#60/100),0,2),".",":")
	i par s hhmm="-"_hhmm
	q hhmm
}

/// 
/// konverze hh:mm na min, min muzou byt > 1440
/// 
ClassMethod HHMMToMin(hhmm As %String) As %String
{
	//w ##class(KDZ.BASE.API.Time).HHMMToMin("3:50")
	s hhmm=$g(hhmm) s hod=$p(hhmm,":",1) s min=$p(hhmm,":",2) s par=0 i hod<0 s par=1 s hod=(hod*(-1))
	s min=((hod*60)+min) i par s min=min*(-1)
	q min
}

/// 
/// konverze min na hh.dd kde dd je desetinne vyjadreni hodin (hh.dd 1.5 je hh:mm 1:30)
/// 
ClassMethod MinToHHDD(min As %String) As %String
{
	//w ##class(KDZ.BASE.API.Time).MinToHHDD(320)
	s min=$g(min) s par=0 i min<0 s par=1 s min=(min*(-1))
	s hhdd=(min\60+(min#60/60+.005\.01/100))
	i par=1 s hhdd=hhdd*(-1)
	q hhdd
}

/// 
/// konverze hh.dd na min kde dd je desetinne vyjadreni hodin (hh.dd 1.5 je hh:mm 1:30)
/// 
ClassMethod HHDDToMin(hhdd As %String) As %String
{
	//w ##class(KDZ.BASE.API.Time).HHDDToMin(2.5)
	s hhdd=$g(hhdd) s hod=hhdd\1 s dd=hhdd#1 s par=0 i hod<0 s par=1 s hod=(hod*(-1))
	s min=((hod*60)+(60*dd)) i par s min=min*(-1)
	q min
}

ClassMethod CasMeziHHMM(od As %String, do As %String) As %String
{
	// w ##class(ALVA.GENERALAPI.Time).CasMeziHHMM("6:45","14:20")
	s mOd=+##class(ALVA.GENERALAPI.Time).HHMMToMin(od)
	s mDo=+##class(ALVA.GENERALAPI.Time).HHMMToMin(do)
	s m=mDo-mOd if m<0 { s hhmm="" }
	else { s hhmm=##class(ALVA.GENERALAPI.Time).MinToHHMM(m) }
	q $g(hhmm)
}

/// 
/// formatuje 7:45 na 07:45
/// 
ClassMethod Format(time As %String) As %String
{
	// w ##class(ALVA.GENERALAPI.Time).Format("7:45")
	s time=$tr(time," ","")
	q $tr($j(+time,2)_":"_$j($p(time,":",2),2)," ","0")
}

}
