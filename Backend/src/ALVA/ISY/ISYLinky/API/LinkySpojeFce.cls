Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYLinky.API.LinkySpojeFce Extends %RegisteredObject
{

ClassMethod test()
{
	//d ##class(ALVA.ISY.ISYLinky.API.LinkySpojeFce).test()
	s sys("U","IdFa")="VS_CSAD"
		s sys("U","delimiter")=$c(0)
		s sys("U","SystemDB")="MLINE"
		s sys("C","User")=007
		s sys("U","DATA")="USER"
		s sys("U","MLP")=7
		s sys("U","fullName")="007"
		s sys("U","loginName")="007"
		s sys("C","GUID")=7
	//k arr d ..vymazNepotrebneTrasy(.sys,$lb(9,"",060605),"",.arr)
	k tmpArr
	s tmpArr("PAR","smer")=-1
	s tmpArr("PAR","maximalniPocet")=+$g(^["USER"]JRSET("Definice","Kms","Filtr"),10)
	s tmpArr("PAR","maximalniFiltr")=+$g(^["USER"]JRSET("Definice","Kms","MaxFiltr"))
	s tmpArr("PAR","skladatDoSebe")=+$g(^["USER"]JRSET("Definice","Kms","Pack"))
	d ##class(ALVA.ISY.ISYLinky.API.LinkySpojeFce).vypocitejKilometrickeSloupce(.sys,$lb(9,"",060605),"",.tmpArr)
	k tmpArr
}

ClassMethod vymazNepotrebneTrasy(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//vymaze nepotrebne trasy na lince
	//IN
	//id = $lb(skupinaId,aplId,linkaId)
	//nebo dGlb = global, kde jsou data linky tak, jak jsou ulozeny v databazi, pak se data nacitaji z nej
	//OUT
	//
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb)
	s skupinaId=$lg(id,1) s aplId=$lg(id,2) s linkaId=$lg(id,3)
	i linkaId'="" s linkaId=##class(ALVA.ISY.ISYLinky.API.LinkyFce).cisloLinkyDoIndexu(linkaId)
	//neni-li datovy global a je-li zastavkaId, pak nacitam data z databaze
	i (dGlb="")&(skupinaId) {s dGlb=$name(^[dataDB]JRL(skupinaId,linkaId))}
	i (dGlb="")&(aplId) {s dGlb=$name(^[dataDB]JRAPL(linkaId,aplId,"arr"))}
	//
	k arrTrasaId
	f smerIdx="T","Z" {
		s spojId="" f {
			s valDB="" s spojId=$o(@dGlb@(smerIdx,spojId),1,valDB) i (spojId="") q
			s arrTrasaId(+$p($p(valDB,"#",1),":",3))=""
		}
	}
	s trasaId="" f {
		s trasaId=$o(@dGlb@("W",trasaId)) i trasaId="" q
		i trasaId#1 continue
		i $d(arrTrasaId(trasaId)) continue
		f iTrasaId=trasaId:.01 {
			i '$d(@dGlb@("W",iTrasaId)) q
			k @dGlb@("W",iTrasaId)
		}
	}
}

ClassMethod vypocitejKilometrickeSloupce(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//vypocita kilometricke sloupce
	//IN
	//id = $lb(skupinaId,aplId,linkaId)
	//nebo dGlb = global, kde jsou data linky tak, jak jsou ulozeny v databazi, pak se data nacitaji z nej
	//arr("PAR","smer")=-1 spolecne / 0 jen tam / 1 jen zpet
	//arr("PAR","maximalniPocet")=maximalni pocet kilometrickych sloupcu
	//arr("PAR","maximalniFiltr")=0/1 zapnout maximalni filtr pro vypocet sloupcu
	//arr("PAR","skladatDoSebe")=0/1 priznak pro skladani kil.sloupcu do sebe
	//OUT
	//
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb)
	s skupinaId=$lg(id,1) s aplId=$lg(id,2) s linkaId=$lg(id,3)
	i linkaId'="" s linkaId=##class(ALVA.ISY.ISYLinky.API.LinkyFce).cisloLinkyDoIndexu(linkaId)
	//neni-li datovy global a je-li zastavkaId, pak nacitam data z databaze
	i (dGlb="")&(skupinaId) {s dGlb=$name(^[dataDB]JRL(skupinaId,linkaId))}
	i (dGlb="")&(aplId) {s dGlb=$name(^[dataDB]JRAPL(linkaId,aplId,"arr"))}
	//parametry od linky
	s kmxli=+$g(@dGlb@("PATCH","Kms","Filtr"),10)
	s kmfli=+$g(@dGlb@("PATCH","Kms","MaxFiltr"))
	//
	//pripravim KMS ze spoju
	//
	k arrKMS
	k arrLSp d ##class(ALVA.ISY.ISYLinky.API.LinkySpoje).seznam(.sys,id,dGlb,.arrLSp)
	s smerId="" f {
		s smerId=$o(arrLSp("DTA",smerId)) i smerId="" q
		i ($g(arr("PAR","smer"))=0)&(smerId'=0) continue
		i ($g(arr("PAR","smer"))=1)&(smerId'=1) continue
		s spojId="" f {
			s spojId=$o(arrLSp("DTA",smerId,spojId)) i spojId="" q
			k arrSp d ##class(ALVA.ISY.ISYLinky.API.LinkySpoje).nacti(.sys,$lb(skupinaId,aplId,linkaId,smerId,spojId),dGlb,.arrSp)
			s arrSp("DTA")=$g(arrSp("DTA"))
			s KMS=""
			s bodOdId=$lg(arrSp("DTA"),1) s bodDoId=$lg(arrSp("DTA"),2)
			i smerId=1 { s bodOdId=$lg(arrSp("DTA"),2) s bodDoId=$lg(arrSp("DTA"),1)}
			s val=$g(arrSp("DTA","trasa",bodOdId))
			s predchoziVzdalenost=($lg(val,3)/1000)
			f bodId=bodOdId:1:bodDoId {
				s val=$g(arrSp("DTA","trasa",bodId))
				s casPrijezdu=$lg(val,1)
				s vzdalenost=($lg(val,3)/1000)
				i casPrijezdu="<" s $p(KMS,":",bodId)=-1 continue
				s vzdalenostKMS=vzdalenost-predchoziVzdalenost
				i vzdalenostKMS<0 s vzdalenostKMS=vzdalenostKMS*(-1)
				s $p(KMS,":",bodId)=vzdalenostKMS
				s predchoziVzdalenost=vzdalenost
			}
			s jeKMS=0 s cnt="" f {
				s val="" s cnt=$o(arrKMS(cnt),1,val) i (cnt="")!(jeKMS) q
				s jeKMS=(KMS=val)
			}
			i (jeKMS=0)&($tr(KMS,": ","")'="") {
				s arrKMS($i(arrKMS))=KMS
			}
		}
	}
	//prvni filtr, jeden je obsazen ve druhem
	s cnt="" f {
		s KMS="" s cnt=$o(arrKMS(cnt),1,KMS) i cnt="" q
		s delkaKMS=$l(KMS,":")
		s oCnt="" f {
			s oKMS="" s oCnt=$o(arrKMS(oCnt),1,oKMS) i oCnt="" q
			i cnt=oCnt continue
			s delkaoKMS=$l(oKMS,":")
			i delkaoKMS>delkaKMS continue
			//zacatek
			f zacatekoKMS=1:1 { i $p(oKMS,":",zacatekoKMS)'="" q }
			i $p(KMS,":",zacatekoKMS)'=-1 s zacatekoKMS=zacatekoKMS+1
			s stejne=1
			f idx=zacatekoKMS:1:delkaoKMS {
				i $p(KMS,":",idx)=$p(oKMS,":",idx) continue
				s stejne=0
			}
			i stejne {
				k arrKMS(oCnt)
				s arrKMS=arrKMS-1
			}
		}
	}
	//nascitani km
	s cnt="" f {
		s KMS="" s cnt=$o(arrKMS(cnt),1,KMS) i cnt="" q
		s delkaKMS=$l(KMS,":")
		s nKMS="" s vzdalenost=0
		f idx=1:1:delkaKMS {
			s val=$p(KMS,":",idx)
			i (val="")!(val=-1) s nKMS=nKMS_val_":" continue
			s vzdalenost=vzdalenost+val
			s nKMS=nKMS_val_":"
		}
		i $e(nKMS,$l(nKMS))=":" s nKMS=$e(nKMS,1,($l(nKMS)-1))
		s arrKMS(cnt)=nKMS
		
	}
	//maximalni filtr - KMS je obsazen ve druhem a nevadi <
	i $g(arr("PAR","maximalniFiltr")) {
		s cnt="" f {
			s KMS="" s cnt=$o(arrKMS(cnt),1,KMS) i (cnt="")!($g(arrKMS)'>$g(arr("PAR","maximalniPocet"))) q
			s delkaKMS=$l(KMS,":")
			s oCnt="" f {
				s oKMS="" s oCnt=$o(arrKMS(oCnt),1,oKMS) i oCnt="" q
				i cnt=oCnt continue
				i ($g(arrKMS)'>$g(arr("PAR","maximalniPocet"))) q
				s delkaoKMS=$l(oKMS,":")
				i delkaoKMS>delkaKMS continue
				//zacatek
				f zacatekoKMS=1:1 { i $p(oKMS,":",zacatekoKMS)'="" q }
				s zacatekoKMS=zacatekoKMS+1
				s stejne=1
				f idx=zacatekoKMS:1:delkaoKMS {
					i $p(KMS,":",idx)=$p(oKMS,":",idx) continue
					i $p(oKMS,":",idx)=-1 q
					s stejne=0
				}
				i stejne {
					k arrKMS(oCnt)
					s arrKMS=$g(arrKMS)-1
				}
			}	
		}
	}
	//seskladani kms k sobe
	i $g(arr("PAR","skladatDoSebe")) {
		s cnt="" f {
			s KMS="" s cnt=$o(arrKMS(cnt),1,KMS) i (cnt="")!($g(arrKMS)'>$g(arr("PAR","maximalniPocet"))) q
			f zacatekKMS=1:1 { i $p(KMS,":",zacatekKMS)'="" q }
			s delkaKMS=$l(KMS,":")
			s jeVlozen=0
			s oCnt="" f {
				s oKMS="" s oCnt=$o(arrKMS(oCnt),1,oKMS) i (oCnt="")!(jeVlozen) q
				i cnt=oCnt continue
				s lzeVlozit=1
				f idx=zacatekKMS:1:delkaKMS {
					i $p(oKMS,":",idx)'="" s lzeVlozit=0
				}
				i 'lzeVlozit continue
				f idx=zacatekKMS:1:delkaKMS {
					s $p(oKMS,":",idx)=$p(KMS,":",idx)
				}
				s arrKMS(oCnt)=oKMS
				k arrKMS(cnt)
				s arrKMS=$g(arrKMS)-1
				s jeVlozen=1
			}	
		}
	}
	//filtr podle nastaveni u linky
	i (kmfli)&($g(arrKMS)>kmxli) {
		// pripravim pole arrFltr(vychoziPozice)=pocet kms
		// 				  arrFltr(vychoziPozice,delka,pocetJJS(<),cntSloupce)=""
		k arrFltr
		s cnt="" f {
			s KMS="" s cnt=$o(arrKMS(cnt),1,KMS) i (cnt="") q
			s vychoziPozice=0 s delka=0 s pocetJJS=0
			f idx=1:1:$l(KMS,":") {
				i ($p(KMS,":",idx)'="")&('vychoziPozice) s vychoziPozice=idx
				i ($p(KMS,":",isx)'="") s delka=delka+1
				i ($p(KMS,":",idx)=-1) s pocetJJS=pocetJJS+1
			}
			s arrFltr(vychoziPozice)=$g(arrFltr(vychoziPozice))+1
			s arrFltr(vychoziPozice,delka,pocetJJS,cnt)=""
		}
		//odmazani nadbytecnych sloupcu
		f idx=1:1:($g(arrKMS)-kmxli) {
			//dohledam vychoziPozice, kde je nejvice KMS
			s maxVychoziPozice="" s maxPocet=0
			s vychoziPozice="" f {
				s vychoziPozice=$o(arrFltr(vychoziPozice)) i vychoziPozice="" q
				i $g(arrFltr(vychoziPozice))>maxPocet {
					s maxVychoziPozice=vychoziPozice
					s maxPocet=arrFltr(vychoziPozice)
				}
			}
			i maxVychoziPozice="" q
			//vymazu jeden sloupec pod maxVychoziPozice, nejkratsi, nejvetsi pocet <
			s delka=$o(arrFltr(maxVychoziPozice,"")) i delka="" q
			s pocetJJS=$o(arrFltr(maxVychoziPozice,delka,""),-1) i pocetJJS="" q
			s cnt=$o(arrFltr(maxVychoziPozice,delka,pocetJJS,"")) i cnt="" q
			k arrKMS(cnt)
			k arrFltr(maxVychoziPozice,delka,pocetJJS,cnt)
			s arrFltr(maxVychoziPozice)=$g(arrFltr(maxVychoziPozice))-1
			i arrFltr(maxVychoziPozice) k arrFltr(maxVychoziPozice)
		}
		k arrFltr
	}
	i $g(arr("PAR","smer"))=-1 k @dGlb@("K")
	i $g(arr("PAR","smer"))=0 k @dGlb@("PATCH","KmsSmer","T")
	i $g(arr("PAR","smer"))=1 k @dGlb@("PATCH","KmsSmer","Z")
	s cnt="" f {
		s KMS="" s cnt=$o(arrKMS(cnt),1,KMS) i cnt="" q
		i $g(arr("PAR","smer"))=-1 s @dGlb@("K",$i(@dGlb@("K")))=KMS
		i $g(arr("PAR","smer"))=0 s @dGlb@("PATCH","KmsSmer","T",$i(@dGlb@("PATCH","KmsSmer","T")))=KMS
		i $g(arr("PAR","smer"))=1 s @dGlb@("PATCH","KmsSmer","Z",$i(@dGlb@("PATCH","KmsSmer","Z")))=KMS
	}
}

ClassMethod korekceNZ(ByRef sys As %String, id As %String, dGlb As %String, ByRef arr As %String)
{
	//kontrola cisla NZ, jeji korekce
	//IN
	//id = $lb(skupinaId,aplId,linkaId,smerId,spojId)
	//arr("PAR","puvodniNZ")=puvodni NZ
	//arr("PAR","puvodniNZ","DPL")=povodniDPL
	//arr("PAR","puvodniNZ",11)=puvodniOmezeni
	//arr("PAR","puvodniNZ",..)=puvodniOmezeni
	//nebo dGlb = global, kde jsou data linky tak, jak jsou ulozeny v databazi, pak se data nacitaji z nej
	//OUT
	//
	$$$FillParams
	s id=$g(id) s dGlb=$g(dGlb)
	s skupinaId=$lg(id,1) s aplId=$lg(id,2) s linkaId=$lg(id,3) s smerId=$lg(id,4) s spojId=$lg(id,5)
	i linkaId'="" s linkaId=##class(ALVA.ISY.ISYLinky.API.LinkyFce).cisloLinkyDoIndexu(linkaId)
	//neni-li datovy global a je-li zastavkaId, pak nacitam data z databaze
	i (dGlb="")&(skupinaId) {s dGlb=$name(^[dataDB]JRL(skupinaId,linkaId))}
	i (dGlb="")&(aplId) {s dGlb=$name(^[dataDB]JRAPL(linkaId,aplId,"arr"))}
	s smerIdx=$e("TZ",smerId+1)
	// neni definovano omezeni
	s neniNZ=1
	i '($p($p($g(@dGlb@(smerIdx,spojId)),"#",1),":",8)=1) s neniNZ=0
	f omezeniId=11,12,13,14,15,22 {i $d(@dGlb@(smerIdx,spojId,omezeniId)) s neniNZ=0}
	i neniNZ { s $p(@dGlb@(smerIdx,spojId),"#",7)="" q }
	//nezmenilo se omezeni
	s totoznaNZ=1
	//dlouhodoba
	i '($g(arr("PAR","puvodniNZ","DPL"))=$p($p($g(@dGlb@(smerIdx,spojId)),"#",1),":",8)) s totoznaNZ=0
	//omezeni
	f omezeniId=11,12,13,14,15,22 {
		k tmpArr
		s tmpArr("PAR","DV1")=$g(arr("PAR","puvodniNZ",omezeniId))
		s tmpArr("PAR","DV2")=$p($g(@dGlb@(smerIdx,spojId,omezeniId)),"@",2)
		d ##class(ALVA.ISY.ISYOmezeni.API.Obecne).jsouTotozneDatumoveVety(.tmpArr)
		i '$g(tmpArr("STT")) s totoznaNZ=0
		k tmpArr
	}
	// neni negativni znacka
	i $p(@dGlb@(smerIdx,spojId),"#",7)="" s totoznaNZ=0
	i totoznaNZ q
	// kontrola na ciselnik znacek
	s cisloNZ=""
	i skupinaId {
		s idxNZ="" f {
			s idxNZ=$o(^[dataDB]JRSET("Cis","InPlatDef",skupinaId,idxNZ)) i (idxNZ="")!(cisloNZ) q
			s totoznaNZ=1
			s valDTA1=+$p($p($g(@dGlb@(smerIdx,spojId)),"#",1),":",8)
			s valDTA2=+$g(^[dataDB]JRSET("Cis","InPlatDef",skupinaId,idxNZ,"DPL"))
			i '(valDTA1=valDTA2) s totoznaNZ=0
			f omezeniId=11,12,13,14,15,22 {
				k tmpArr
				s tmpArr("PAR","DV1")=$g(^[dataDB]JRSET("Cis","InPlatDef",skupinaId,idxNZ,omezeniId))
				s tmpArr("PAR","DV2")=$p($g(@dGlb@(smerIdx,spojId,omezeniId)),"@",2)
				d ##class(ALVA.ISY.ISYOmezeni.API.Obecne).jsouTotozneDatumoveVety(.tmpArr)
				i '$g(tmpArr("STT")) s totoznaNZ=0
				k tmpArr
			}
			i totoznaNZ s cisloNZ=idxNZ
		}
	}
	i cisloNZ s $p(@dGlb@(smerIdx,spojId),"#",7)=cisloNZ q
	// kontrola na ciselnik znacek - je tot. cislo a nesedi dat.?
	s cisloNZ=$p(@dGlb@(smerIdx,spojId),"#",7)
	i (cisloNZ'="")&(skupinaId) {
		i ($d(^[dataDB]JRSET("Cis","InPlatDef",skupinaId,cisloNZ))) {s $p(@dGlb@(smerIdx,spojId),"#",7)=""}
	}
	// nova negativni znacka
	// totozna s nekterym spojem
	k arrNZ s arrNZ=""
	f actSmerIdx="T","Z" {
		s actSpojId="" f {
			s actSpojId=$o(@dGlb@(actSmerIdx,actSpojId)) i (actSpojId="")!(arrNZ) q
			i actSpojId=spojId continue
			s totoznaNZ=1
			s valDTA1=+$p($p($g(@dGlb@(smerIdx,spojId)),"#",1),":",8)
			s valDTA2=+$p($p($g(@dGlb@(actSmerIdx,actSpojId)),"#",1),":",8)
			i '(valDTA1=valDTA2) s totoznaNZ=0 continue
			f omezeniId=11,12,13,14,15,22 {
				k tmpArr
				s tmpArr("PAR","DV1")=$p($g(@dGlb@(smerIdx,spojId,omezeniId)),"@",2)
				s tmpArr("PAR","DV2")=$p($g(@dGlb@(actSmerIdx,actSpojId,omezeniId)),"@",2)
				d ##class(ALVA.ISY.ISYOmezeni.API.Obecne).jsouTotozneDatumoveVety(.tmpArr)
				i '$g(tmpArr("STT")) s totoznaNZ=0
				k tmpArr
			}
			s tmpCisloNZ=$p($g(@dGlb@(actSmerIdx,actSpojId)),"#",7)
			i tmpCisloNZ="" continue
			s arrNZ(tmpCisloNZ)=""
			i totoznaNZ {
				i skupinaId {
					i ('$d(^[dataDB]JRSET("Cis","InPlatDef",skupinaId,tmpCisloNZ))) {s cisloNZ=tmpCisloNZ}
				}
			}
		}
	}
	// nasla se u totozneho spoje
	i cisloNZ s $p(@dGlb@(smerIdx,spojId),"#",7)=cisloNZ q
	// nove prideleni
	s NZOd=$p($g(^[dataDB]JRSET("Cis","InPlatODDO")),"~",1)
	s NZDo=$p($g(^[dataDB]JRSET("Cis","InPlatODDO")),"~",2)
	s quit=0
	f omezeniIdNZ=NZOd:1 {
		i (quit) q
		i (omezeniIdNZ>NZDo) q
		i $d(arrNZ(omezeniIdNZ)) continue
		i skupinaId {
			i $d(^[dataDB]JRSET("Cis","InPlatDef",skupinaId,omezeniIdNZ)) continue
		}
		s $p(@dGlb@(smerIdx,spojId),"#",7)=omezeniIdNZ
		s quit=1
	}
}

}
