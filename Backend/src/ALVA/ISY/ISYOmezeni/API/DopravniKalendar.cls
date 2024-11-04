Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYOmezeni.API.DopravniKalendar Extends %RegisteredObject
{

ClassMethod test()
{
	//d ##class(ALVA.ISY.ISYOmezeni.API.DopravniKalendar).test()
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
	s arr("PAR","RRRR",2022)=""
	d ..nacti(.sys,.arr)
	zw arr
}

ClassMethod nacti(ByRef sys As %String, ByRef arr As %String)
{
	//IN
	//arr("PAR","horlogOdDo")=$lb(horOd,hrlDo)	... obdobi pro vytvoreni kalendare od - do
	//arr("PAR","RRRR",rrrr)=""					... obdobi pro vytvoreni kalendare rrrr
	//arr("GLB")= global, kam naplnit data, pojud neni, pak do arr("DTA")
	//OUT
	//arr("DTA",horlog,statId)=$lb(dta,dta,...)
	//i statId = 0 CZ / 1 SK					... stat pro kalendar 0 CZ / 1 SK
	//1 denTyden								... 1 Po / 2 Ut / 3 St / 4 Ct / 5 Pa / 6 So / 7 Ne
	//2 tydeniPlatnostLstId						... 1,2,3,4,5,6,7,X,+
	//3 jeSvatek								... 0 / 1
	//4 sudyLichy								... 0 lichy / 1 sudy 
	$$$FillParams
	//mode ... 0=CZ,1=SK
		//s mode=$$gMode^JRapi(idfa,nmsp)
	s glb=$g(arr("GLB"))
	//podle arr("PAR","horlogOdDo") si doplnim roky
	i $d(arr("PAR","horlogOdDo")) {
		s val=$g(arr("PAR","horlogOdDo"))
		s hrlOd=$lg(val,1) s hrlDo=$lg(val,2)
		i (hrlOd&hrlDo) {
			s rrrrOd=$p(##class(ALVA.GENERALAPI.Date).horToDate(hrlOd),".",3)
			s rrrrDo=$p(##class(ALVA.GENERALAPI.Date).horToDate(hrlDo),".",3)
			f rrrr=rrrrOd:1:rrrrDo s arr("PAR","RRRR",rrrr)=""
		}	
	}
	//pro roky a statId naplnim svatky
	s rrrr="" f {
		s rrrr=$o(arr("PAR","RRRR",rrrr)) i rrrr="" q
		s hrlVelikonocniPondeli=..VelikonocniPondeli(.sys,rrrr)
		k arrSvatky
		//ceske svatky
		s statId=0
		s arrSvatky(statId)="1.01:1.05:8.05:5.07:6.07:28.09:28.10:17.11:24.12:25.12:26.12"
		i rrrr=1999 s arrSvatky(statId)="1.01:1.05:8.05:5.07:6.07:28.10:24.12:25.12:26.12"
		//slovenske svatky
		s statId=1
		s arrSvatky(statId)="1.01:6.01:1.05:8.05:5.07:29.08:1.09:15.09:1.11:17.11:24.12:25.12:26.12"
		//pole svatku
		s statId="" f {
			s statId=$o(arrSvatky(statId)) i statId="" q
			s mySvatky=$g(arrSvatky(statId))
			f cnt=1:1:$l(mySvatky,":") {
				s tmpVal=$p(mySvatky,":",cnt)
				i tmpVal="" continue
				s arrSvatky(statId,##class(ALVA.GENERALAPI.Date).DateToHor(tmpVal_"."_rrrr))=""
			}
			//doplnim velikonoce
			s arrSvatky(statId,hrlVelikonocniPondeli)=""
			//velky patek 
			i (statId=0)&(rrrr>2015) s arrSvatky(statId,hrlVelikonocniPondeli-3)=""
			i (statId=1) s arrSvatky(statId,hrlVelikonocniPondeli-3)=""
			//SK maji jednorazovy svatek 30.10.2018 
			i (statId=1)&(rrrr=2018) s arrSvatky(statId,##class(ALVA.GENERALAPI.Date).DateToHor("30.10.2018"))=""
		}
		//
		s hrlOd=##class(ALVA.GENERALAPI.Date).DateToHor("01.01."_rrrr)
		s hrlDo=##class(ALVA.GENERALAPI.Date).DateToHor("31.12."_rrrr)
		s suLi="" s suLiP=""
		//prvni nedele po ctvrtku na preklapeni sudy-lichy
		s jeCt=0 s suLiHrlNe=0
		f hrl=hrlOd:1 {
			i suLiHrlNe q
			i (hrl+3#7+1)=4 s jeCt=1
			i 'jeCt continue
			i (hrl+3#7+1)=7 s suLiHrlNe=hrl
		} 		
		//kalendar pro rok
		f hrl=hrlOd:1:hrlDo {
			s denTyden=(hrl+3#7+1)
			// sudy-lichy tyden
			i ('suLiP) { s suLi=0 i (denTyden=7)&(hrl'<suLiHrlNe) s suLiP=1 }
			else { s suLi=1 i denTyden=7 s suLiP=0 }
			//
			s tydenniPlatnostTxt=denTyden
			i denTyden<6 { s tydenniPlatnostTxt=tydenniPlatnostTxt_"X" }
			i denTyden=7 { s tydenniPlatnostTxt=tydenniPlatnostTxt_"+" }
			f statId=0,1 {
				s jeSvatek=($d(arrSvatky(statId,hrl))>0)
				s statTydenniPlatnostTxt=tydenniPlatnostTxt
				i jeSvatek {
					s statTydenniPlatnostTxt=$tr(statTydenniPlatnostTxt,"X","")
					i (statTydenniPlatnostTxt'["+") {s statTydenniPlatnostTxt=statTydenniPlatnostTxt_"+"}
				}
				s tydenniPlatnostLst="" f cnt=1:1:$l(statTydenniPlatnostTxt) s $li(tydenniPlatnostLst,cnt)=$e(statTydenniPlatnostTxt,cnt)
				i glb'="" {
					s @glb@(hrl,statId)=$lb(denTyden,tydenniPlatnostLst,jeSvatek,suLi)
				}
				else {
					s arr("DTA",hrl,statId)=$lb(denTyden,tydenniPlatnostLst,jeSvatek,suLi)
				}
			}
		}
	}
}

ClassMethod VelikonocniPondeli(ByRef sys As %String, rrrr As %String) As %String
{
 // vraci horlog velikonocniho pondeli
 S M=23,N=3 S:rrrr>1799 N=4 S:rrrr>1899 N=N+1,M=24 S:rrrr>2099 N=N+1
 S A=rrrr#19,B=rrrr#4,C=rrrr#7,D=A*19+M#30,E=B*2+(C*4)+(D*6)+N#7,den=D+E+22
 i den'>31 s a=den+1,a=$e("00",1,2-$l(a))_a_".03" s:den=31 a="01.04"_"."_rrrr  q ##class(ALVA.GENERALAPI.Date).DateToHor(a)
 S den=den-31 s:den=26 den=den-7 s:den=25&(D=28)&(A>10) den=den-1
 s a=den+1
 s a=$e("00",1,2-$l(a))_a_".04"_"."_rrrr
 q ##class(ALVA.GENERALAPI.Date).DateToHor(a)
}

}
