Include (ALVAEDFORMS, ALVAEDREPORTS)

Class ALVA.GENERALAPI.FIRMA.DPH Extends %RegisteredObject
{

/*
 vstup:
 	IdFa	idfa vystavovatele dokladu
 	datpl	datum plneni DD.MM.RRRR
 	Ic		Ic zakaznika
 			pokud je zadane tak se testuje, zda je zakaznik firma ve skupine
 
 vystup:
 	out("CenDPH")=1		ANO firma ma centralni odvod DPH
 	potom ...
		out("CenDPH","DanKod")	danovy kod
        out("CenDPH","Dic")		skupinove Dic
        out("CenDPH","Datum")	datum registrace
 	
 	je-li zadane Ic zakaznika
 	out("CenDPH","IcoSk")=1		ANO je to firma ve skupine CenDPH
 	out("CenDPH","SazbaDPH")	sazba pro vystaveni danoveho dokladu
 */
ClassMethod CenDPH(IdFa, datpl, Ic, ByRef out As %String) As %String
{
	s sc=$$$OK
	k out  s out("CenDPH")=0		//vychozi stav
	try {
		S sysbase=##class(ALVA.EDISON.Main).GetSystemDB()
		S horpl=$$datnum^ALVAESfset(datpl)
		K in  S in("datzdp")=horpl
		s errX=$$gIdFa^MlJFapi(IdFa,sysbase,.in,.o)
		If +errX'=0 s sc=$$$ERROR($$$GeneralError,$P(errX,"~",2)) $$$ThrowOnError(sc)
		//
		//kontrola je zda je provedena inicializace CenDPH
		If +$g(o("dta",38))=1 {
			S datumCenDPH=$g(o("dta",39))
			//
			//kontrola zda je zadany datum od kdy plati CenDPH
			If datumCenDPH'="" {
				S horCenDPH=$$datnum^ALVAESfset(datumCenDPH)
				//
				//porovna se datum plneni na datum registrace CenDPH
			    If horCenDPH=horpl!(horCenDPH<horpl) {
            		s out("CenDPH")=1
               		s out("CenDPH","DanKod")=$g(o("dta",40))
               		s out("CenDPH","Dic")=$g(o("dta",41))
               		s out("CenDPH","Datum")=datumCenDPH
               		//je zadane Ic - ted se provede kontrola Ic zakaznika na firmy ve skupine
               		If $g(Ic)'="" {
	               		s out("CenDPH","IcoSk")=0
	               		k o  s errX=$$gSkRegDphIdFa^MlJFapi(IdFa,sysbase,"",.o) 
	               		If +errX'=0 s sc=$$$ERROR($$$GeneralError,$P(errX,"~",2)) $$$ThrowOnError(sc)
	               		//kontroluji se jednotlive idfa ve skupine
	               		s idfa="" For {
                  			s idfa=$o(o("arr",idfa)) Q:idfa=""
                  			s horCenDPHIc=$g(o("arr",idfa,"dta",1))
                  			//pro kazde idfa se porovnava datum registrace na datum plneni
                  			If horCenDPHIc=horpl!(horCenDPHIc<horpl) {
	                  			k in,oo
	                  			s in("datzdpl")=horpl
                  				s errX=$$gIdFa^MlJFapi(idfa,sysbase,.in,.oo) 
                  				If +errX'=0 s sc=$$$ERROR($$$GeneralError,$P(errX,"~",2)) $$$ThrowOnError(sc)
                  				s ico=$g(oo("dta",7))
                  				//podle idfa se nacte Ic a to se porovna na Ic zakaznika
                  				If ico'=""&(+ico=+Ic) {
                  					s out("CenDPH","IcoSk")=1
                  					s out("CenDPH","SazbaDPH")=0
                  				}
                  			}
	               		}
               		}
			    }
			}
		}
	}
	 catch ex { 
	 	s sc=ex.AsStatus()
	 	}
	q sc
}

/// výpočet DPH v idfa ke dni pro typ sazby a typ dokladu ze základu/ceny celkem<BR>
/// (původní funkce:$$vypocetDPH^ALVAPRODEJapi(idfa,datum,typDokl,typSazby,zaklad,celkem,out))<BR>
/// VSTUP:<BR>
/// idfa								   ... povinná<BR>
/// datum [dd.MM.yyyy]					   ... není-li zadáno, bere se systémové datum<BR>
/// typDokl [P=příjem/V=výdej]			   ... není-li zadáno, bere se "P"<BR>
/// typSazby [0=bez/1=zákl/2=sníž/3=sníž2] ... není-li zadáno, bere se 0<BR>
/// zaklad								   ... je-li zadán +základ=0, výstupy základ+daň se počítají z hodnoty celkem<BR>
/// celkem								   ... je-li zadán +základ'=0, vstup celkem je ignorován, a výstupy celkem+daň se počítají z hodnoty základ<BR>
/// fakturace [0=ne/1=ano]				   ... není-li zadáno, bere se 0, pro fakturace=1 je ignorováno nastavení ve firmě pro připočtení zaokrouhlení DPH k základu
/// VÝSTUP:<BR>
/// out("zaklad")=základ<BR>
/// out("dan")	 =daň<BR>
/// out("celkem")=celkem<BR>
/// out("zaokr") =zaokrouhlení<BR>
ClassMethod vypocetDPHtypSazby(idfa, datum, typDokl, typSazby, zaklad, celkem, out, fakturace)
{
	s err=""
	try {	
		s sysnmsp=##class(ALVA.EDISON.Main).GetSystemDB()
		k out
		s hrl=""
		i (datum'="") s hrl=$zdh($tr(datum,".","/"),4,,,,,,,-1)
		i hrl="" s hrl=$h
		s typDoc=typDokl
		if typDoc="" s typDoc="P"
		s typSazby=+typSazby
		s zaklad=+zaklad
		s celkem=+celkem
		s fakturace=+$g(fakturace)
		s procSazby=0
		s dan=0
		s zaokr=0
		if (+typSazby>0)
		{
			// procSazby dle hrl
	 		k arr
	 		s err=$$gDanSzb^MlJFapi(idfa,sysnmsp,hrl,"",.arr)	 	
	 		 i err ztrap
	 		// out("dta",1)=zakladni sazba
	 		// out("dta",2)=snizena sazba 1 (puvodni)
 	 		// out("dta",3)=snizena sazba 2
 	 		if typSazby=1 s procSazby=+$g(arr("dta",1))
 	 		if typSazby=2 s procSazby=+$g(arr("dta",2))
 	 		if typSazby=3 s procSazby=+$g(arr("dta",3))
		}
		k outDPH
		s err=##class(ALVA.GENERALAPI.FIRMA.DPH).vypocetDPHprocSazby(idfa,typDoc,procSazby,zaklad,celkem,.outDPH,fakturace,hrl) i err ztrap
		s zaklad=+$g(outDPH("zaklad"))
		s celkem=+$g(outDPH("celkem"))
		s dan=+$g(outDPH("dan"))
		s zaokr=+$g(outDPH("zaokr"))
		s out("zaklad")=zaklad
		s out("dan")=dan
		s out("celkem")=celkem
		s out("zaokr")=zaokr
	}catch(ex){
		s err=err_"/"_ex.DisplayString()
	}
	q:'$g(err) "" q err
}

/// výpočet DPH v idfa pro %sazby a typ dokladu ze základu/ceny celkem<BR>
/// (původní funkce:$$spoctiDPH^ALVAPRODEJapi(idfa,typDokl,procSazby,zaklad,celkem,out))<BR>
/// VSTUP:<BR>
/// idfa								   ... povinná<BR>
/// datum [dd.MM.yyyy]					   ... není-li zadáno, bere se systémové datum<BR>
/// typDokl [P=příjem/V=výdej]			   ... není-li zadáno, bere se "P"<BR>
/// procSazby							   ... není-li zadáno, bere se 0<BR>
/// zaklad								   ... je-li zadán +základ=0, výstupy základ+daň se počítají z hodnoty celkem<BR>
/// celkem								   ... je-li zadán +základ'=0, vstup celkem je ignorován, a výstupy celkem+daň se počítají z hodnoty základ<BR>
/// fakturace [0=ne/1=ano]				   ... není-li zadáno, bere se 0, pro fakturace=1 je ignorováno nastavení ve firmě pro připočtení zaokrouhlení DPH k základu
/// VÝSTUP:<BR>
/// out("zaklad")=základ<BR>
/// out("dan")	 =daň<BR>
/// out("celkem")=celkem<BR>
/// out("zaokr") =zaokrouhlení<BR>
ClassMethod vypocetDPHprocSazby(idfa, typDokl, procSazby, zaklad, celkem, out, fakturace, hrl)
{
	s ix=0
	s err=""
	try {
		s sysnmsp=##class(ALVA.EDISON.Main).GetSystemDB()
		k out
		if typDokl="" s typDokl="P"
		s hrl=+$g(hrl,$h) // pokud není posláno, ber dnes
		s pocDesMist=2
		s zaokrSamost=0
		//nastavení z firmy
	 	k arr
 	 	s err=$$gIdFa^MlJFapi(idfa,sysnmsp,"",.arr) zt:+err "merr" s err=""
 	 	// 35  = dph, vypocet zaokrouhlovat na 0 halere / 1 koruny
	 	// 36  = dph, zaokrouhlovani vykazovat jako samostatnou polozku 0 ano / 1 ne
	 	if ((+$g(arr("dta",35))=1)&(typDokl="P")) s pocDesMist=0	//zaokrouhlení DPH pouze u příjmu
	 	if ((+$g(arr("dta",36))=0)&(typDokl="P")) s zaokrSamost=1	//zaokrouhlení DPH pouze u příjmu
	 	if fakturace=1 s zaokrSamost=1	//zaokrouhlení DPH pro fakturaci se nikdy k základu nepřipočítává
		s zaokr=0
		if (+zaklad'=0)
		{
			//spočítej a zaokrouhli daň
			s dan=$fn((zaklad/100*procSazby),"",2)
			s danZ=$fn(dan,"",pocDesMist)
			if (zaokrSamost=1)
			{
				//vykázat samostatně
				s zaokr=dan-danZ
			}
			else
			{
				//přičíst k základu
				s zaklad=zaklad+dan-danZ
			}
			//spočítej celkem
			if (+celkem'=0){s zaokr= celkem-zaklad-danZ}
			else{s celkem=zaklad+danZ+zaokr}
			s dan=danZ
			s out("zaklad")=zaklad
			s out("dan")=dan
			s out("celkem")=celkem
			s out("zaokr")=zaokr
		}
		else
		{
	        //koeficient
	        s koef=procSazby/(100+procSazby)
	        //nezaokrouhlit od 1.1.2019 s koef=$fn(koef,"",4)
	        if (hrl<65014) {s koef=$fn(koef,"",4)}
			//spočítej a zaokrouhli daň
			s dan=$fn((koef*celkem),"",2)
			s danZ=$fn(dan,"",pocDesMist)
			if (zaokrSamost=1)
			{
				//vykázat samostatně
				s zaokr=dan-danZ
			}
			else
			{
				//přičíst k základu
				s zaklad=zaklad+dan-danZ
			}
			//spočítej základ
			s zaklad=celkem-danZ-zaokr-zaklad
			s dan=danZ
			s out("zaklad")=zaklad
			s out("dan")=dan
			s out("celkem")=celkem
			s out("zaokr")=zaokr
		}
	}catch(ex){
		s err=err_"/"_ex.DisplayString()
	}
	q:'$g(err) "" q err
}

}
