Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYLinky.API.LinkyTrasa Extends %RegisteredObject
{

ClassMethod test()
{
	//d ##class(ALVA.ISY.ISYLinky.API.LinkyTrasa).test()
	s sys("U","IdFa")="CK_SCHWAN"
	s sys("U","delimiter")=$c(0)
	s sys("U","SystemDB")="MLINE"
	s sys("C","User")=007
	s sys("U","DATA")="USER"
	s sys("U","MLP")=7
	s sys("U","fullName")="007"
	s sys("U","loginName")="007"
	s sys("C","GUID")=7
	k arr
	s arr("PAR","nactiGPS")=1
	d ..nacti(.sys,$lb(6,"","0230009"),"",.arr) w ! zw arr
	#; d ..uloz(.sys,$lb(9,"",823130),"",.arr)
	#; d ..nacti(.sys,$lb(9,"",823130),"",.arr) w ! zw arr
}

ClassMethod popis()
{
		// arr("DTA",bodId)=val			/zakladni body
		//
		// 1 zastavkaId					/ zastávka id/číslo / ND
		// 2 atribut					/ atributy - $lb(atributId,atributId,...) / LST-T
		// 3 -					        / nepouzito
		// 4 nastupiste					/ nástupiště - $lb(nastupisteTam,nastupisteZpet) / LST-T
		// 5 mhdId 						/ dosah MHD / T
		// 6 tiskOdrazit				/ odrazit / T
		// 7 mhdTarifId					/ tarifní pásmo MHD / N
		// 8 trasaMHD					/ předpis pro tisk trasy MHD tam - $lb(trasaMHDTam,trasaMHDZpet) / LST-B
		// 9 casMHDTam					/ předpis pro čas u tisk trasy MHD tam - $lb(casMHDTam,casMHDZpet) / LST-N
		// 10 tarZona					/ tarifní zóna - $lb(tarZonaId,tarZonaId,...) / LST
		// 11 zakladniTrasaMHD			/ předpis pro tisk základní trasy MHD - $lb(zakladniTrasaMHDTam,zakladniTrasaMHDZpet) LST-B
		// 12 odbZaTarZona				/ odbav.zař.|tarifní zóna (ME) - $lb(tarZonaId,tarZonaId,...) / LST-T
		// 13 oznacnik		  			/ označník zastávky tam - $lb(oznacnikIdTam,oznacnikIdZpet)/ LST-N
		// 14 povelBuseId				/ povel BUSE / T
		// 15 jedePresPoznME			/ příznak jede přes pro poznámku do odbav.ME / N
		// 16 DSZonyProUznaniBoduSZME	/ DS zóny pro uznání bodu sys/zon (ME) / N
		// 17 zonaProUznaniBoduSZME		/ zóna pro uznání bodu sys/zon (ME) / T
		//
		// arr("DTA",bodId,"vzdalenost",bodIdDo)=$lb(dta,dta,...)	//vzdalenosti mezi body 
		//	
		// 1 vzdalenostTarifni			/ tarifni vzdalenost [m]
		// 2 vzdalenostPresna			/ presna vzdalenost	 [m]
		// 3 vzdalenostTarifniProOdbZ	/ tarifno vzdalenost pro odbavovaci zazizeni [m]
		//
		// arr("DTA",bodId,"meziBody",bodIdDo,cnt)=$lb(dta,dta,...)	//mezibody
		//
		// 1 TYP
		// 2 DELTAS
		// 3 IdSA
		// 4 IdK
		// 5 IdM
		// 6 SmerZaK
		// 7 IdBTI
		// 8 IdHRI
		// 9 IdZRJI
		// 10 ZONYAR  $lb($lb(z1,z2,zn),vzdalenostM),$lb($lb(z1,z2,zn),vzdalenostM),...)
		// 11 FZALL
		// 
		// TYP  1  bod na trase		TYP,DELTAS,IdSA,IdBTI
		//      2  majak       		TYP,DELTAS,IdSA,IdK,IdM,SmerZaK
		//      3  hrana       		TYP,DELTAS,IdSA,IdHRI
		//      4  zpresneni      	TYP,DELTAS,IdSA,IdZRJI
		//      5  fiktivni zona  	TYP,FZALL + rozpis zon a vzdalenost
		//
		// + podle nastaveneho parametru arr("PAR","doplnGPS")=0/1
		// arr("DTA",bodId,"gps")=$lb($lb(gpsNTam,gpsETam),$lb(gpsNZpet,gpsEZpet))
}

ClassMethod nacti(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//vrati data trasy linky
	//IN
	//id = $lb(skupinaId,aplId,linkaId)
	//nebo dGlb = global, kde jsou data linky tak, jak jsou ulozeny v databazi, pak se data nacitaji z nej
	//arr("PAR","nactiGPS")=0/1
	//OUT
	//arr("DTA",...)=$lb(dta,dta,...) / popis v popis
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb) k arr("DTA")
	s skupinaId=$lg(id,1) s aplId=$lg(id,2) s linkaId=$lg(id,3)
	i linkaId'="" s linkaId=##class(ALVA.ISY.ISYLinky.API.LinkyFce).cisloLinkyDoIndexu(linkaId)
	//neni-li datovy global a je-li zastavkaId, pak nacitam data z databaze
	i (dGlb="")&(skupinaId) {s dGlb=$name(^[dataDB]JRL(skupinaId,linkaId))}
	i (dGlb="")&(aplId) {s dGlb=$name(^[dataDB]JRAPL(linkaId,aplId,"arr"))}
	s valDB="" s val=""
	i dGlb'="" {
		s bodId="" f {
			s valDB="" s bodId=$o(@dGlb@("J",bodId),1,valDB) i bodId="" q
			s $li(val,1)=$p($p(valDB,"#",1),":",1)
			s valTmp=$p($p(valDB,"#",1),":",2)
			s valLst="" f cnt=1:1:$l(valTmp) s $li(valLst,($ll(valLst)+1))=$e(valTmp,cnt)
			s $li(val,2)=valLst
			s $li(val,3)=$p(valDB,"#",2)
			s $li(val,4)=$lfs($p(valDB,"#",3),":")
			s $li(val,5)=$p(valDB,"#",4)
			s $li(val,6)=$p(valDB,"#",5)
			s $li(val,7)=$p(valDB,"#",6)
			s $li(val,8)=$lfs($p(valDB,"#",7),":")
			s $li(val,9)=$lfs($p(valDB,"#",8),":")
			s $li(val,10)=$lfs($p(valDB,"#",9),",")
			s $li(val,11)=$lfs($p(valDB,"#",10),":")
			s $li(val,12)=$lfs($p(valDB,"#",11),",")
			s $li(val,13)=$lfs($p(valDB,"#",12),":")
			s $li(val,14)=$p(valDB,"#",13)
			s $li(val,15)=$p(valDB,"#",14)
			s $li(val,16)=$p(valDB,"#",15)
			s $li(val,17)=$p(valDB,"#",16)
			s arr("DTA",bodId)=val
			//doplneni gps souradnic
			i +$g(arr("PAR","nactiGPS")) {
				s gpsTam=$lb("","") s gpsZpet=$lb("","")
				s zastavkaId=$lg(val,1) s oznacnik=$lg(val,13) s oznacnikIdTam=$lg(oznacnik,1) s oznacnikIdZpet=$lg(oznacnik,2)
				k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).nactiGPS(.sys,$lb(zastavkaId,oznacnikIdTam),.arrDta)
				s arrDta("DTA")=$g(arrDta("DTA")) s gpsN=$lg(arrDta("DTA"),1) s gpsE=$lg(arrDta("DTA"),2)
				i (gpsN&gpsE) s gpsTam=$lb(gpsN,gpsE) s gpsZpet=gpsTam
				//ruzne oznacniky 
				i oznacnikIdTam'=oznacnikIdZpet {
					k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).nactiGPS(.sys,$lb(zastavkaId,oznacnikIdZpet),.arrDta)
					s arrDta("DTA")=$g(arrDta("DTA")) s gpsN=$lg(arrDta("DTA"),1) s gpsE=$lg(arrDta("DTA"),2)
					i (gpsN&gpsE) s gpsZpet=$lb(gpsN,gpsE)
				}
				s arr("DTA",bodId,"gps")=$lb(gpsTam,gpsZpet)
			}
			s bodIdDo="" f {
				s valDB="" s bodIdDo=$o(@dGlb@("J",bodId,bodIdDo),1,valDB) i bodIdDo="" q
				s val=$lfs(valDB,":") f cnt=1:1:$ll(val) i $lg(val,cnt)'="" s $li(val,cnt)=($lg(val,cnt)*1000)
				s arr("DTA",bodId,"vzdalenost",bodIdDo)=val
				s idxDB="" f {
					s valDB="" s idxDB=$o(@dGlb@("J",bodId,bodIdDo,"bd",idxDB),1,valDB) i idxDB="" q
					s val=$lfs(valDB,"~")
					s partVal=$lfs($lg(val,10),"|")
					f cnt=1:1:$ll(partVal) {
						s tmpVal=$lg(partVal,cnt)
						i tmpVal="" continue
						s $li(partVal,cnt)=$lb($lfs($p(tmpVal,"^",1),";"),($p(tmpVal,"^",2)*1000))
					}
					s $li(val,10)=partVal
					s arr("DTA",bodId,"meziBody",bodIdDo,idxDB)=val
				}
			}
		}
	}
}

ClassMethod uloz(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//ulozi data trasy linky
	//IN
	//id = $lb(skupinaId,aplId,linkaId)
	//nebo dGlb = global, kde jsou data linky tak, jak jsou ulozeny v databazi, pak se data zapisi z nej
	//OUT
	//arr("DTA",...)=$lb(dta,dta,...) / popis v popis
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb)
	s skupinaId=$lg(id,1) s aplId=$lg(id,2) s linkaId=$lg(id,3)
	i linkaId'="" s linkaId=##class(ALVA.ISY.ISYLinky.API.LinkyFce).cisloLinkyDoIndexu(linkaId)
	//neni-li datovy global a je-li skupinaId, pak nacitam data z databaze
	i (dGlb="")&(skupinaId) {s dGlb=$name(^[dataDB]JRL(skupinaId,linkaId))}
	i (dGlb="")&(aplId) {s dGlb=$name(^[dataDB]JRAPL(linkaId,aplId,"arr"))}
	i dGlb'="" {
		k @dGlb@("J")
		s bodId="" f {
			s val="" s bodId=$o(arr("DTA",bodId),1,val) i bodId="" q
			s valDB=""
			s tmpVal=""
			s $p(tmpVal,":",1)=$lg(val,1)
			s $p(tmpVal,":",2)=$lts($lg(val,2),"")
			s $p(valDB,"#",1)=tmpVal
			s $p(valDB,"#",2)=$lg(val,3)
			s $p(valDB,"#",3)=$lts($lg(val,4),":")
			s $p(valDB,"#",4)=$lg(val,5)
			s $p(valDB,"#",5)=$lg(val,6)
			s $p(valDB,"#",6)=$lg(val,7)
			s $p(valDB,"#",7)=$lts($lg(val,8),":")
			s $p(valDB,"#",8)=$lts($lg(val,9),":")
			s $p(valDB,"#",9)=$lts($lg(val,10),",")
			s $p(valDB,"#",10)=$lts($lg(val,11),":")
			s $p(valDB,"#",11)=$lts($lg(val,12),",")
			s $p(valDB,"#",12)=$lts($lg(val,13),":")
			s $p(valDB,"#",13)=$lg(val,14)
			s $p(valDB,"#",14)=$lg(val,15)
			s $p(valDB,"#",15)=$lg(val,16)
			s $p(valDB,"#",16)=$lg(val,17)
			s @dGlb@("J",bodId)=valDB
			s @dGlb@("J")=bodId
			s bodIdDo="" f {
				s val="" s bodIdDo=$o(arr("DTA",bodId,"vzdalenost",bodIdDo),1,val) i bodIdDo="" q
				s valDB=val f cnt=1:1:$ll(valDB) i $lg(valDB,cnt)'="" s $li(valDB,cnt)=$lg(valDB,cnt)/1000
				s valDB=$lts(valDB,":")
				s @dGlb@("J",bodId,bodIdDo)=valDB
			}
			s bodIdDo="" f {
				s bodIdDo=$o(arr("DTA",bodId,"meziBody",bodIdDo)) i bodIdDo="" q
				s idxDB="" f {
					s val="" s idxDB=$o(arr("DTA",bodId,"meziBody",bodIdDo,idxDB),1,val) i bodIdDo="" q
					s valDB=$lts(val,"~")
					s partVal=$lts($p(valDB,"~",10),"|")
					f cnt=1:1:$l(partVal,"|") {
						s tmpVal=$p(partVal,"|",cnt)
						i tmpVal="" continue
						s tmpVal=$lts($lg(tmpVal,1),";")_"^"_($lg(tmpVal,2)/1000)
						s $p(partVal,"|",cnt)=tmpVal
					}
					s $p(valDB,"~",10)=partVal
					s @dGlb@("J",bodId,bodIdDo,"bd",idxDB)=valDB
				}
			}
		}
	}
}

}
