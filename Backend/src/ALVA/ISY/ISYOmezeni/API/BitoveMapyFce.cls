Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYOmezeni.API.BitoveMapyFce Extends %RegisteredObject
{

ClassMethod omezeniZBitoveMapy(ByRef sys As %String, ByRef arr As %String)
{
	//vygeneruje omezeni z bitove mapy
	//IN
	//arr("PAR","bitovaMapa")=$lb(horlogOd,horlogDo,bitovaMapa)
	//arr("PAR","bitovaMapaProOmezeni",omezeniId)=bitovaMapa
	//kde omezeniId = 1,2,3,4,5,6,7,X,+,su
	//OUT
	//arr("DTA")=$lb(tydenniOmezeniLstId)
	//arr("DTA","datumoveOmezeni",omezeniId,hrlOd)=$lb(hrlDo)
	//kde omezeniId = 11 / jede jen ,12 / jede take ,13 /jede ,14 / jede v sudych tydnech ,15 / jede v lichych tydnech ,22 / nejede 
	
	$$$FillParams
	//pracovni global
	$$$TMPGLBSET(tmpglb)
	k arr("DTA")
	s val=$g(arr("PAR","bitovaMapa")) s horlogOd=$lg(val,1) s horlogDo=$lg(val,2) s bitovaMapa=$lg(val,3)
	//doplnim jede vzdy a nejede
	s cntday=0 f hrl=horlogOd:1:horlogDo {
		s cntday=cntday+1
		s $e(arr("PAR","bitovaMapaProOmezeni","*"),cntday)=1
		s $e(arr("PAR","bitovaMapaProOmezeni","-"),cntday)=0
	}
	//kontrola, zda alespon jednou jede
	s pass=0 f cnt=1:1:$l(bitovaMapa) i +$e(bitovaMapa,cnt) s pass=1
	//nejede
	i 'pass s arr("DTA")=$lb($lb("")) s arr("DTA","datumoveOmezeni",22,horlogOd)=$lb(horlogDo) q
	//projedu zakladni platnosti a zjistim prekryti (co muzu pouzit)
	s passOmezeniId=""
	f omezeniId=1,2,3,4,5,6,7,"X","+" {
		s cBitovaMapa=$g(arr("PAR","bitovaMapaProOmezeni",omezeniId))
		k arrDta d ..compareBmp(bitovaMapa,cBitovaMapa,.arrDta)
		//shoduje se nejake jede 
		i $g(arrDta("dta",3)) s passOmezeniId=passOmezeniId_omezeniId
		k arrDta
	}
	//rozdeleni passOmezeniId podle moznych kombinaci a vytvoreni kombinaci tydenniho omezeni
	k arrcmbid
	i passOmezeniId'="" {
		i passOmezeniId["X" {
		s tmp="X" f omezeniId="6","7","+" i passOmezeniId[omezeniId s tmp=tmp_omezeniId
		s passOmezeniId=$tr(passOmezeniId,"X","")
		i ((tmp["+")&(tmp["7")) {
			k arrDta d ..mkComb($tr(tmp,"7",""),.arrDta) m arrcmbid=arrDta k arrDta
			k arrDta d ..mkComb($tr(tmp,"+",""),.arrDta) m arrcmbid=arrDta k arrDta
		}
		else {
			k arrDta d ..mkComb(tmp,.arrDta) m arrcmbid=arrDta k arrDta
		}
	}
	i ((passOmezeniId["+")&(passOmezeniId["7")) {
		k arrDta d ..mkComb($tr(passOmezeniId,"7",""),.arrDta) m arrcmbid=arrDta k arrDta
		k arrDta d ..mkComb($tr(passOmezeniId,"+",""),.arrDta) m arrcmbid=arrDta k arrDta
	}
	else {
		k arrDta d ..mkComb(passOmezeniId,.arrDta) m arrcmbid=arrDta k arrDta
	} 
	f id="*","-" s arrcmbid(id)=""
	//projedu vsechny mozne varianty znacek a vypocitam datumova omezeni
	s myid="" f {
		s myid=$o(arrcmbid(myid)) i myid="" q
			//pro znacky vypocitam vyslednou bitovou mapu
			s cBitovaMapa=$g(arr("PAR","bitovaMapaProOmezeni","-"))
			f cnt=1:1:$l(myid) {
				s omezeniId=$e(myid,cnt)
				d ..addBmp(.cBitovaMapa,arr("PAR","bitovaMapaProOmezeni",omezeniId))
			}
			//vyslednou bitovou mapu porovnam se spojem
			k arrDta d ..compareBmp(bitovaMapa,cBitovaMapa,.arrDta)
			//jede jen
			i myid="-" {
				s tmpBitovaMapa=arrDta("dta",6)
				k myarr d ..convertIntevalHrl(2,tmpBitovaMapa,horlogOd,1,.myarr)
				s cntvar=$i(@tmpglb)
				s @tmpglb@(cntvar,"dta",1)=""
				i $g(myarr) {
					m @tmpglb@(cntvar,"arr",1,11)=myarr
					s @tmpglb@(cntvar,"par",1)=($g(@tmpglb@(cntvar,"par",1))+myarr+1)
				}
				k myarr 
			}
			else {
				//jede + jede take
				s cntvar=$i(@tmpglb)
				s @tmpglb@(cntvar,"dta",1)=$tr(myid,"*","")
				s tmpBitovaMapa=arrDta("dta",6)
				d ..mkInteval(1,.tmpBitovaMapa)
				//jede
				k myarr d ..convertIntevalHrl(1,tmpBitovaMapa,horlogOd,0,.myarr)
				i $g(myarr) {
					m @tmpglb@(cntvar,"arr",1,13)=myarr
					s @tmpglb@(cntvar,"par",1)=($g(@tmpglb@(cntvar,"par",1))+myarr+1)
				}
				k myarr
				//jede take
				k myarr d ..convertIntevalHrl(2,tmpBitovaMapa,horlogOd,1,.myarr)
				i $g(myarr) {
					m @tmpglb@(cntvar,"arr",1,12)=myarr
					s @tmpglb@(cntvar,"par",1)=($g(@tmpglb@(cntvar,"par",1))+myarr+1)
				}
				k myarr
				//nejede + jede take
				s cntvar=$i(@tmpglb)
				s @tmpglb@(cntvar,"dta",1)=$tr(myid,"*","")
				s tmpBitovaMapa=arrDta("dta",6)
				d ..mkInteval(3,.tmpBitovaMapa)
				//nejede
				k myarr d ..convertIntevalHrl(3,tmpBitovaMapa,horlogOd,0,.myarr)
				i $g(myarr) {
					m @tmpglb@(cntvar,"arr",1,22)=myarr
					s @tmpglb@(cntvar,"par",1)=($g(@tmpglb@(cntvar,"par",1))+myarr+1)
				}
				k myarr
				 //jede take
				k myarr d ..convertIntevalHrl(2,tmpBitovaMapa,horlogOd,1,.myarr)
				i $g(myarr) {
					m @tmpglb@(cntvar,"arr",1,12)=myarr
					s @tmpglb@(cntvar,"par",1)=($g(@tmpglb@(cntvar,"par",1))+myarr+1)
				}
				k myarr
			}
		}
		k tmpArr
		s cntvar="" f {
			s cntvar=$o(@tmpglb@(cntvar)) i cntvar="" q
			s lenhrl=+$g(@tmpglb@(cntvar,"par",1))
			s lentpl=+$l(@tmpglb@(cntvar,"dta",1))
			s tmpArr(lenhrl,lentpl)=cntvar
		}
		//vyberu nejkratsi variantu
		s cntvar=""
		s lenhrl=$o(tmpArr("")) i lenhrl'="" s lentpl=$o(tmpArr(lenhrl,"")) s cntvar=$g(tmpArr(lenhrl,lentpl))
		i cntvar'="" {
			s tydenniPlatnost=$g(@tmpglb@(cntvar,"dta",1))
			s tydenniPlatnostLstId="" f cnt=1:1:$l(tydenniPlatnost) s $li(tydenniPlatnostLstId,cnt)=$e(tydenniPlatnost,cnt)
			s arr("DTA")=$lb(tydenniPlatnostLstId)
			s omezeniId="" f {
				s omezeniId=$o(@tmpglb@(cntvar,"arr",1,omezeniId)) i omezeniId="" q
				s omezeniHorlogOd="" f {
					s omezeniHorlogDo="" s omezeniHorlogOd=$o(@tmpglb@(cntvar,"arr",1,omezeniId,omezeniHorlogOd),1,omezeniHorlogDo) i omezeniHorlogOd="" q
					s arr("DTA","datumoveOmezeni",omezeniId,omezeniHorlogOd)=$lb(omezeniHorlogDo)
				}
			}
		}
		k @tmpglb 
	}
}

ClassMethod mkInteval(typ, bitovaMapa)
{
 //slouceni intervalu daneho typu do bitovaMapa
 s cnt=1 f {
	 i cnt>$l(bitovaMapa) q
	 i $e(bitovaMapa,cnt)=typ {
		 s nextcnt=cnt s quit=0
		 f partcnt=(cnt+1):1 {
			 i partcnt>$l(bitovaMapa) q
			 i quit q
			 i $e(bitovaMapa,partcnt)=typ s nextcnt=partcnt continue  	//dalsi stejneho typu, posun intervalu
			 i $e(bitovaMapa,partcnt)=0 continue					   	//nejede nevadi, je maskovano tydeni platnosti
			 s quit=1 q										   			//narazil jsem na jiny typ, konec
		 }
		 f partcnt=cnt:1:nextcnt s $e(bitovaMapa,partcnt)=typ
		 s cnt=nextcnt
	 }
	 s cnt=cnt+1
 }
}

ClassMethod convertIntevalHrl(typ, bitovaMapa, hrl, par, arr)
{
 //prevod intervalu na intervaly - horlog
 //typ 			... typ dne pro vyhledani a prevod
 //bitovaMapa	... bitova mapa
 //hrl			... horlog prvniho dne
 //par			... 0 spojovat intervaly / 1 jednotlive dny
 //arr			... vysledne pole hrl - arr(hrlod)=hrldo a arr=pocet datumu
 s cnt=1 f {
	 i cnt>$l(bitovaMapa) q
	 i $e(bitovaMapa,cnt)=typ {
		 //jednotlive dny
		 i +par {
			 s arr(hrl+cnt-1)=(hrl+cnt-1) s arr=$g(arr)+1
		 }
		 //intervaly
		 else {
			 s quit=0
			 s nextcnt=cnt
			 f partcnt=(cnt+1):1 {
				 i partcnt>$l(bitovaMapa) q
				 i quit q
				 i $e(bitovaMapa,partcnt)=typ s nextcnt=partcnt continue  		//nasleduje dalsi stejneho typu, posun intervalu
				 s quit=1 continue												//narazil jsem na jiny typ, konec
			 }
			 s arr(hrl+cnt-1)=(hrl+nextcnt-1)
			 i cnt=nextcnt s arr=$g(arr)+1
			 i cnt'=nextcnt s arr=$g(arr)+2
			 s cnt=nextcnt
		 }
	 }
	 s cnt=cnt+1
 }
}

ClassMethod addBmp(bitovaMapa, addbitovaMapa)
{
 //slouci bitove mapy do bitovaMapa prida addbitovaMapa
 f i=1:1:$l(bitovaMapa) i +$e(addbitovaMapa,i) s $e(bitovaMapa,i)=+$e(addbitovaMapa,i)
}

ClassMethod compareBmp(bitovaMapa, cBitovaMapa, out)
{
 //porovnani bitovych map
 k out
 //pocet prvku
 s out("dta",1)=$l(bitovaMapa)
 s $p(out("dta",6),"0",out("dta",1))=0
 //porovnani bitovych map
 //bitovaMapa je hlavni bitmapa (platnost spoje)
 //cBitovaMapa je porovnavana bitmapa (navrh platnosti)
 //out("dta",1)=pocet vsech dnu
 //out("dta",2)=pocet vsech totoznych dnu
 //out("dta",3)=pocet totoznych dnu jede
 //out("dta",4)=pocet dnu, kdy je potreba doplnit jizdu
 //out("dta",5)=pocet dnu, kdy je potreba zrusit jizdu
 //out("dta",6)=maska porovnani bitove mapy, nove znaky 2 doplnit jizdu ... jede take a 3 zrusit jizdu
 f i=1:1:out("dta",1) {
		i ($e(bitovaMapa,i)=$e(cBitovaMapa,i)) s $e(out("dta",6),i)=$e(bitovaMapa,i) s out("dta",2)=$g(out("dta",2))+1			//totozny den
		i ($e(bitovaMapa,i)=$e(cBitovaMapa,i))&($e(bitovaMapa,i)=1) s out("dta",3)=$g(out("dta",3))+1							//totozny den jede
		i ($e(bitovaMapa,i)'=$e(cBitovaMapa,i))&($e(bitovaMapa,i)=1) s $e(out("dta",6),i)=2 s out("dta",4)=$g(out("dta",4))+1 	//doplnit jizdu
		i ($e(bitovaMapa,i)'=$e(cBitovaMapa,i))&($e(bitovaMapa,i)=0) s $e(out("dta",6),i)=3 s out("dta",5)=$g(out("dta",5))+1 	//zrusit jizdu
 }
 q
}

ClassMethod mkComb(val, out)
{
 //vytvoreni kombinaci vsech prvku
 //val=mozne znacky
 //out(kombinace) 
 k out
 s val=$g(val) k out s len=$l(val) s txf="" s txt=""
 f i=1:1:len s txf=txf_i s txt=txt_$e(val,i)
 //
 f i1=1:1:len {
	 s out($tr(i1,txf,txt))=""
		 f i2=i1:1:len {
			 i len<2 continue
				 i i1=i2 continue
				 s out($tr(i1_i2,txf,txt))=""
				 f i3=i2:1:len {
					 i len<3 continue
						 i i2=i3 continue
						 s out($tr(i1_i2_i3,txf,txt))=""
						 f i4=i3:1:len {
							 i len<4 continue
								 i i3=i4 continue
								 s out($tr(i1_i2_i3_i4,txf,txt))=""
								 f i5=i4:1:len {
									 i len<5 continue
										 i i4=i5 continue
										 s out($tr(i1_i2_i3_i4_i5,txf,txt))=""
										 f i6=i5:1:len {
											 i len<6 continue
											 i i5=i6 continue
											 s out($tr(i1_i2_i3_i4_i5_i6,txf,txt))=""
											 f i7=i6:1:len {
												 i len<7 continue
												 i i6=i6 continue
												 s out($tr(i1_i2_i3_i4_i5_i6_i7,txf,txt))=""
												 f i8=i7:1:len {
													 i len<8 continue
															 i i7=i8 continue
														 s out($tr(i1_i2_i3_i4_i5_i6_i7_i8,txf,txt))=""
												 }
											 }
									 }
							 }
						 }
				 } 
		 }
 }
}

}
