Class ALVA.GENERALAPI.FIRMA.MENY Extends %RegisteredObject
{

/// seznam povolených měn pro idfa<BR>
/// (původní funkce:$$CurrencyListMyRead^ALVAPOKLADNAapi(idfa,out,sysnmsp))<BR>
/// VSTUP:<BR>
/// idfa    ... povinná<BR>
/// sysnmsp ... není-li zadáno, bere se "MLINE"<BR>
/// VÝSTUP:<BR>
/// out("arr",mena) = mena~popis<BR>
/// out("dta",1)	= popis číselníku<BR>
/// out("dta",2)	= typ číselníku<BR>
/// out("dta",3)	= 0...jednoúrovňový / 1...víceúrovňový<BR>
/// out("dta",4)	= 0...číselník nelze editovat / 1...číselník lze editovat<BR>
ClassMethod PovoleneMeny(idfa, out, sysnmsp) As %String
{
	s err=""
	try {
		i idfa="" s err="idfa" ztrap
		i $g(sysnmsp)="" s sysnmsp=##class(ALVA.EDISON.Main).GetSystemDB()
		k out
		k inpC
		s err=$$gCis^MlJFapi(idfa,sysnmsp,"","POKL","MENY",.inpC,.out) i err ztrap
	} catch(ex) {
		s err=ex.DisplayString()
	}
	q:'$g(err) "" q err
}

/// kurzovní lístek pro jednu měnu/povolené měny ke dni<BR>
/// (původní funkce:$$ExchangeRateRead^ALVAPOKLADNAapiC(idfa,nmsp,hrl,vmena,prvzad,out)<BR>
/// VSTUP:<BR>
/// idfa   ... povinná<BR>
/// nmsp   ... není-li zadáno, bere se podle idfa<BR>
/// hrl    ... není-li zadán, bere se +$h<BR>
/// vmena  ... není-li zadán kód měny, vrací se všechny uložené měny<BR>
/// prvzad ... pokud je 1 a kurz.lístek pro daný den neexistuje, najde se první zadaný zpětně od hrl<BR>
/// VÝSTUP:<BR>
/// out("Datum")		   = datum kurz.lístku, který je vracen<BR>
/// out("Mena",mena,"Kurz")= kurz (při požadavku kurzu k 1 jednotce valuty je třeba vydělit množstvím)<BR>
/// out("Mena",mena,"Mnoz")= množství jednotek, ke kterému je kurz vztažený<BR>
ClassMethod KurzListek(idfa, nmsp, hrl, vmena, prvzad, out) As %String
{
	s err=""
	try
	{
		i idfa="" s err="idfa" ztrap
		if (nmsp="")
		{
			// sys
			k loadedInfo
			d ##class(ALVA.EDISON.Main).GetApplicationInfo(-1,.loadedInfo,idfa)
			// loadedInfo(0)=namespace
			// loadedInfo(1)=datovyZdroj [1=Edison,2=Mline,3=Helios]
			s nmsp=$g(loadedInfo(0)) if nmsp="" s err="nmsp=" ztrap
		}
		if (hrl="")
		{
			s hrl=+$h
		}
		s prvzad=+$g(prvzad)
		k out
		i '$d(^[nmsp]PO(idfa)) s err="Chybí nastavení pravidel pro kurzovní lístek (Nástroje/Nastavení)." ztrap
		s hrli=hrl
		s den=((hrli-4)#7)+1
		s vikend=$s(den=6:1,den=7:1,1:0)
		i vikend s patek=$S(den=7:hrli-2,6:hrli-1)
		//
		s denni=+$g(^[nmsp]PO(idfa,"SET","KURZY","DENNI"))
		i denni=1 {
			s typ="D"
			i '$d(^[nmsp]POK(idfa,"KURZ",typ,hrli)),vikend {
				i $d(^[nmsp]POK(idfa,"KURZ",typ,patek)) s hrli=patek
			}
		}else{
			s typ="P"
			s datum=$tr($zd(hrl\1,4,,4,,,,,""),"/",".")
			s rok=$p(datum,".",3),mes=$P(datum,".",2)
			s hrli=rok*100+mes
		}
		//neni-li zadany kurz, zkusime najit prvni zadany dozadu
		i prvzad,vmena'="",'$d(^[nmsp]POK(idfa,"KURZ",typ,hrli,vmena)) {
			s i=hrli
			f {
				s i=$o(^[nmsp]POK(idfa,"KURZ",typ,i),-1) q:i=""
				s hrli=i
				i $g(^[nmsp]POK(idfa,"KURZ",typ,hrli,vmena))'="" q
			}
		}
		i prvzad,vmena="",'$d(^[nmsp]POK(idfa,"KURZ",typ,hrli)) {
			s i=$O(^[nmsp]POK(idfa,"KURZ",typ,hrli),-1)
			i i'="" s hrli=i
		}
		//naplníme výstupní proměnnou
		i (vmena="CZK")
		{
			s out("Mena","CZK","Kurz")=1
			s out("Mena","CZK","Mnoz")=1
		}
		else
		{
			s mena=""
			f {
				s v=""
				s mena=$o(^[nmsp]POK(idfa,"KURZ",typ,hrli,mena),1,v) q:mena=""
				i vmena'="",vmena'=mena continue
				s kurz=$P(v,"~",1)
				s mnoz=$P(v,"~",2) i +mnoz=0 s mnoz=1
				s out("Mena",mena,"Kurz")=kurz
				s out("Mena",mena,"Mnoz")=mnoz
			}
		}
		s datK=""
		if (denni=1)
		{
			s datK=$tr($zd(hrli\1,4,,4,,,,,""),"/",".")
		}
		else
		{
			if ((mes=$e(hrli,5,6))&(rok=$e(hrli,1,4)))
			{
				s datK=datum
			}
			else
			{
				s datK="1."_($e(hrli,5,6))_"."_($e(hrli,1,4))
			}
		}
		i '$d(out) s err="Neznámý kurz měny '"_vmena_"' k datu "_datK_"." ztrap
		s out("Datum")=datK
	} catch(ex) {
		s err=ex.DisplayString()
	}
	q:'$g(err) "" q err
}

}
