Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYZastavky.Forms.formISYZastavkyVyhledavac [ Abstract ]
{

ClassMethod InitGrid(ByRef sys As %String) As %Status
{
	
	s ret=$$$OK
	s err=""
	try 
	{		 
		$$$FillParams	
		
		s skupinaLinek=^||ML("IN","SkupiaLinek") i skupinaLinek="" q
		s zastavkaZ=^||ML("IN","ZastavkaZ") i zastavkaZ="" q
		s zastavkaDo=^||ML("IN","ZastavkaDo") i zastavkaDo="" q
		s datum=^||ML("IN","Datum") i datum="" q
		s maxCekaniMinut=^||ML("IN","MaxCekaniMinut")
		s datumHrl=$zdh($tr(datum,".","/"),4)
		s cas=^||ML("IN","Cas")
		s prestupy=^||ML("IN","Prestupy")
		
		
		
		
	 	k arr
	 	s arr("PAR","skupinaId")=skupinaLinek
		s arr("PAR","horlogOdDo")=$lb(datumHrl-1,datumHrl+1)
		s arr("GLB")="^ALVA.ISY.Vyhledavac"
		d ##class(ALVA.ISY.ISYZastavky.API.Vyhledavac).NaplnitData(.sys,.arr)
		
		s p("Datum")=datumHrl
		s p("CasOdjezd")=$zth(cas,2)
		s p("Prestupy")=prestupy
		s p("MaxCekaniMinut")=maxCekaniMinut
		d ##class(ALVA.ISY.ISYZastavky.API.Vyhledavac).Hledej2(zastavkaZ,zastavkaDo,.p,.v)
		m cesty=v("Cesty")
		
		i $d(cesty)>1{
			/*
				^||ML("OUT","Spojeni",1,"Attrs")=$lb(zastavkaDo,zastavkaZ,jizdaOd,jizdaDo,dobaJizdy)
				^||ML("OUT","Spojeni",1,"Zastavka",1)=$lb(linka,spoj,zastavka,casOdjezd,casPrijezd,prestup)
			*/
			s c=""
			f{
				s c=$o(cesty(c)) q:c=""
				s cc=""
				f{
					s cc=$o(cesty(c,cc)) q:cc=""
					k cesta
					m cesta=cesty(c,cc)
					
					k spoje
					k spojeIndex
					s casOd=""
					s casDo=""
					
					s s=$i(s)
					
					s i="" f{
						s i=$o(cesta(i)) q:i=""
						
						s zastavka=$lg(cesta(i),1)
						s prestupy=$lg(cesta(i),2)
						s linkaId=$lg(cesta(i),3)
						s spojId=$lg(cesta(i),4)
						s casPrijezd=$zt($lg(cesta(i),5),2)
						s casOdjezd=$zt($lg(cesta(i),6),2)
						s datumOdjezd=$tr($zd($lg(cesta(i),7),4),"/",".")
						
						k arrDtaZastavka
						d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavka,"",.arrDtaZastavka)
						s zastavkaNazev=$lg(arrDtaZastavka("DTA"),1)_","_$lg(arrDtaZastavka("DTA"),2)_","_$lg(arrDtaZastavka("DTA"),3)_"/"_$lg(arrDtaZastavka("DTA"),4)
						s gpsN=$lg(arrDtaZastavka("DTA"),19)
						s gpsE=$lg(arrDtaZastavka("DTA"),20)
						
						i casPrijezd="00:00" s casPrijezd=""
						i casOdjezd="00:00" s casOdjezd=""
						
						s ^||ML("OUT","Spojeni",s,"Zastavka",i,"Attrs")=$lb(linkaId,spojId,zastavkaNazev_" ("_zastavka_")",casPrijezd,casOdjezd,datumOdjezd,gpsN,gpsE)
						
						i casOd="" s casOd=casOdjezd
						s casDo=casPrijezd
						
						s k=linkaId_"/"_spojId
						i '$d(spoje(k)) s spojeIndex($i(spojeIndex))=k
						s spoje(k,i)=$lb(linkaId,spojId,zastavkaNazev,zastavka,casOdjezd,casPrijezd)
						
					}
					
					s spojeniPopis=""
					s i=""
					f{
						s i=$o(spojeIndex(i)) q:i=""
						s ls=spojeIndex(i)
						s zasPrvni=$o(spoje(ls,""))
						s zasPosledni=$o(spoje(ls,""),-1)
						
						s odjezd=$lg(spoje(ls,zasPrvni),5)
						i i>1 s odjezd=$lg(spoje(spojeIndex(i-1),$o(spoje(spojeIndex(i-1),""),-1)),5) 
						s zastavkaZ1=$lg(spoje(ls,zasPrvni),3)
						
						s prijezd=$lg(spoje(ls,zasPosledni),6)
						s zastavkaDo1=$lg(spoje(ls,zasPosledni),3)
						
						s spojPopis=ls_"~  "_odjezd_" "_zastavkaZ1_"~  "_prijezd_" "_zastavkaDo1
						
						s spojeniPopis=spojeniPopis_spojPopis_"~"
					}
					
					
					k arrDtaZastavka
					d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaZ,"",.arrDtaZastavka)
					s zastavkaZNazev=$lg(arrDtaZastavka("DTA"),1)_","_$lg(arrDtaZastavka("DTA"),2)_","_$lg(arrDtaZastavka("DTA"),3)_"/"_$lg(arrDtaZastavka("DTA"),4)
					
					k arrDtaZastavka
					d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaDo,"",.arrDtaZastavka)
					s zastavkaDoNazev=$lg(arrDtaZastavka("DTA"),1)_","_$lg(arrDtaZastavka("DTA"),2)_","_$lg(arrDtaZastavka("DTA"),3)_"/"_$lg(arrDtaZastavka("DTA"),4)
					
					s celkovaDobaJizdy=$zth(casDo,2)-$zth(cas,2)
					m ^||ML("OUT","Spojeni",celkovaDobaJizdy+s,"Zastavka")=^||ML("OUT","Spojeni",s,"Zastavka")
					s ^||ML("OUT","Spojeni",celkovaDobaJizdy+s,"Attrs")=$lb(spojeniPopis)
					k ^||ML("OUT","Spojeni",s)
				}
			}
			
		}
	}
	catch (ex) 
	{
		s ret=$$$ERROR($$$GeneralError,$SYSTEM.Status.GetErrorText(ret)_err_ex.DisplayString())
		s ^||ML("ERR")=$SYSTEM.Status.GetErrorText(ret)
	}
	q ret
}

}
