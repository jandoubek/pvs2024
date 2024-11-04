Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYZastavky.Forms.formISYZastavkyMain Extends %RegisteredObject
{

/// 
/// Init gridu (seznam zastávek)
/// 
ClassMethod InitFg(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	
	$$$Init
	try 
	{	
		/*    				možné formáty sloupce
 		AnoNe,	//ano ne 
        I,						  !!!	//IMG  neumí sloupec typu IMG 
        T, 		//String
        TL, 	//String link
        Tc, 	//String zarovnany na stred
        N, 		//intager
        NL,		//intager link
        Nc,		//intager zarovnany na stred
        N2|### ##0.####0,		// Double      |### ##0.####0 je volitelné nemusí být
        D,		// Date
        DT,		// Date time        
        B,		// boolean
        CBO		//Combobox
        */
		//$lb("ITEM",id sloupce,název sloupce,typ,*editable -defaultně ne nemusí se vyplňovat)   barvy fungují jen pokud se zapnou (zpomaluje načítání gridu)		 
		$$$FillParams
		s output($i(i))=$lts($lb("ITEM","Img","","I"),del)
		s output($i(i))=$lts($lb("ITEM","id","Id/Číslo"_$c(13,10)_"zastávky","NL"),del) 
		s output($i(i))=$lts($lb("ITEM","typ","Typ","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","obec","Obec","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","castObce","Část obce","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","lokalita","Lokalita","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","blizkaObec","Blízká obec","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","nazevMHD","Název pro MHD","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","GPSN","GPSN"_$c(13,10)_"severní šířka","N2|### ##0.#############"),del) 
		s output($i(i))=$lts($lb("ITEM","GPSE","GPSE"_$c(13,10)_"východní délka","N2|### ##0.#############"),del) 
		s output($i(i))=$lts($lb("ITEM","cisloCIS","Číslo CIS","N",""),del) 
		s output($i(i))=$lts($lb("ITEM","cisloSR70","Číslo SR70","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","cisloSR70M","Číslo SR70"_$c(13,10)_"mezinárodní","T",""),del)
		s output($i(i))=$lts($lb("ITEM","cisloUzel","Číslo uzlu"_$c(13,10)_"(ROPID)","N2|### ### ##0.##"),del)
		s output($i(i))=$lts($lb("ITEM","atribut","Atribut","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","provozovatel","Provozovatel","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","casovePasmo","Časové pásmo","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","smerTyp","Směr typ","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","tarZona","Tarifní zóna","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","hranicniIDS","Hraniční IDS","B",""),del) 
		s output($i(i))=$lts($lb("ITEM","tarZonaDalsi","Tarifní zóna další","T",""),del)
		s output($i(i))=$lts($lb("ITEM","tarZonaME","Tarifní zóna"_$c(13,10)_"Odbav.zař.(ME)","T",""),del) 
		s output($i(i))=$lts($lb("ITEM","tarZonaMEDalsi","Tarifní zóna další"_$c(13,10)_"Odbav.zař.(ME)","T",""),del)
		s output($i(i))=$lts($lb("ITEM","smart","SMART","B",""),del)  
		m ^||ML("OUT")=output
	}
	catch (ex){$$$CatchErrRest}
 	q ret
}

/// 
/// Load gridu (načtení jednotlivých řádek)
/// 
ClassMethod LoadFg(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{	
		$$$FillParams
		$$$TMPGLBSET(tmpglblst)
		k arr s arr("GLB")=tmpglblst
		//pribalim filter
		s idx="" f {   
			s val="" s idx=$o(^||ML("IN",idx),1,val) i idx="" q 
			i $p(val,del,1)="Filter"{
				s filterId=$p(val,del,2) s filterVal=$p(val,del,3)
				i filterVal'="" {
					i filterId="txbNazev" s arr("PAR","hledanyText")=filterVal
					i filterId="txbBlizkaObec" s $li(arr("PAR","blizkaObecLstId"),$ll($g(arr("PAR","blizkaObecLstId")))+1)=filterVal
					i filterId="txbZonaIDS" s $li(arr("PAR","zonaIDSLstId"),$ll($g(arr("PAR","zonaIDSLstId")))+1)=filterVal
					i filterId="cboTyp" s arr("PAR","typ")=$lf($lb("Vše","Lokální","Oficiální"),filterVal) i arr("PAR","typ") s arr("PAR","typ")=arr("PAR","typ")-1
					i filterId="cboDruh" s arr("PAR","druh")=$lf($lb("Vše","Autobusové","Vlakové"),filterVal) i arr("PAR","druh") s arr("PAR","druh")=arr("PAR","druh")-1
					i filterId="txbSkupinaId" s $li(arr("PAR","skupinaLstId"),$ll($g(arr("PAR","skupinaLstId")))+1)=filterVal
					i filterId="cboPouzite" s arr("PAR","pouzite")=$lf($lb("Vše","Použity","Nepoužity"),filterVal) i arr("PAR","pouzite") s arr("PAR","pouzite")=arr("PAR","pouzite")-1
					i filterId="chbRozdNazevoprCentReg" s arr("PAR","rozdilCRZ")=filterVal
					i filterId="txbLinkaId" s $list(arr("PAR","linkyId"),*+1)= filterVal
				}
			}
			i $p(val,del,1)="RowCount"{
				s arr("PAR","maxPocet")=$p(val,del,2)
			}
		}
		d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).seznam(.sys,.arr)
		s barva = ""
		k ^ps m ^ps = ^||ML("IN")
		// zobrazim data
		// $lb("ITEM",id řádky,id sloupce,hodnota,RGB barva,jméno řádku)   barvy fungují jen pokud se zapnou (spomaluje načítání gridu)
		
		s abcidx="" f {
			s zastavkaId="" s abcidx=$o(@tmpglblst@("IDX",abcidx),1,zastavkaId) i abcidx="" q
			
			s valDTA=$g(@tmpglblst@("DTA",zastavkaId))
			s idRadku=zastavkaId 
			s obec=$lg(valDTA,1) s castObce=$lg(valDTA,2) s lokalita=$lg(valDTA,3) s blizkaObec=$lg(valDTA,4)
			s name=obec_","_castObce_","_lokalita_"/"_blizkaObec
			s vlakovaZastavka=$lg(valDTA,26)
			//barva ikony BG busGreen, BR busRed, VG vlakGreen, VR vlakRed
			i 'vlakovaZastavka {
				s barvaIkony="BG"
				//neni cislo CRZ
				i $lg(valDTA,14)="" {
					s barvaIkony="BR"
				}
				//je cislo CRZ a nesedi nazev
				else {
					s idxCRZ=obec_"~"_castObce_"~"_lokalita_"~"_blizkaObec
					i '$d(^[dataDB]JRCRZ("IZ",idxCRZ)) {s barvaIkony="BR"}
				}
			}
			else {
				s barvaIkony="VG"
			}
			//autobusova
			i 'vlakovaZastavka {i $lg(valDTA,14)="" s barvaIkony="BR"} // BR VR
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"IMG",barvaIkony,barva, name),del)
		 	s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"id",zastavkaId,barva, name),del)
		 	s val=$lg(valDTA,39)
		 	i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"typ",val,barva, name),del)
		 	i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"obec",obec,barva, name),del)
		 	i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"castObce",castObce,barva, name),del)
		 	i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"lokalita",lokalita,barva, name),del)
		 	i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"blizkaObec",blizkaObec,barva, name),del)
		 	s val=$lg(valDTA,13)
		 	i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"nazevMHD",val,barva, name),del)
		 	// s val=$lg(valDTA,19)
		 	if $lg(valDTA,19)'="" { s val=+$lg(valDTA,19) } else { s val="" }
		 	i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"GPSN",val,barva, name),del)
		 	// s val=$lg(valDTA,20)
		 	if $lg(valDTA,20)'="" { s val=+$lg(valDTA,20) } else { s val="" }
		 	i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"GPSE",val,barva, name),del)
		 	s val=$lg(valDTA,14)
		 	i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"cisloCIS",val,barva, name),del)
			s val=$lg(valDTA,27)
			i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"cisloSR70",val,barva, name),del)
			s val=$lg(valDTA,34)
			i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"cisloSR70M",val,barva, name),del)
			s val=$lg(valDTA,40)
			i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"cisloUzel",val,barva, name),del)
			s val=$lts($lg(valDTA,7),";")
			i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"atribut",val,barva, name),del)
			s val=$lg(valDTA,5)
			i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"provozovatel",val,barva, name),del)
			s val=$lg(valDTA,6)
			i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"casovePasmo",val,barva, name),del)
			s val=$lg(valDTA,8) s val=$p("jednosměrná~obousměrná","~",(val+1))
			i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"smerTyp",val,barva, name),del)
			s val=$lg(valDTA,15)
			i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"tarZona",val,barva, name),del)
			s val=+$lg(valDTA,16)
			i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"hranicniIDS",val,barva, name),del)
			s val=$lts($lg(valDTA,17),";")
			i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"tarZonaDalsi",val,barva, name),del)
			s val=$lg(valDTA,30)
			i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"tarZonaME",val,barva, name),del)
			s val=$lts($lg(valDTA,31),";")
			i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"tarZonaMEDalsi",val,barva, name),del)
			s val=+$lg(valDTA,36)
			i val'="" s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"smart",val,barva, name),del)
		}
		k @tmpglblst
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

/// 
/// Uložení okna po stisku OK
/// 
ClassMethod Save(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		$$$FillParams		
		m ^||ML("OUT")=output
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

/// 
/// Odstraní položku
/// 
ClassMethod Delete(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		$$$FillParams
		// pracovni global
		$$$TMPGLBSET(tmpglblst) k @tmpglblst
		// načtu vstup	
		k item s idx=""
        for
        {
	        s idx=$o(^||ML("IN",idx),1,radka) q:idx=""
           	s list= $listfromstring(radka,del)
           	if $lg(list,1)="Item"{s item($lg(list,2))="" }          
        }
        // odeberu polozku
        k output
        i $d(item) {   
	        //nactu pouzite zastavky
	        k arr s arr("GLB")=tmpglblst s err=##class(ALVA.ISY.ISYZastavky.API.ZastavkyFce).pouziteZastavky(.sys,.arr) i +err zt
	        //
	        s cntMsg=0
	        s zastavkaId="" f {
		        s zastavkaId=$o(item(zastavkaId)) i zastavkaId="" q
		        k arr d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).nacti(.sys,zastavkaId,"",.arr)
		        s valDta=$g(arr("DTA"))
		        s zastavkaNazev=$lg(valDta,1)_","_$lg(valDta,2)_","_$lg(valDta,3)_"/"_$lg(valDta,4)
		        //pouzita zastavka
		        i $d(@tmpglblst@("DTA",zastavkaId)) {
			        i cntMsg<11 {
				        s output($i(i))=$lts($lb("MSG","","zastávku "_zastavkaId_" / "_zastavkaNazev_" nelze odstranit, je použita na linkách !"),del)
				        i $d(@tmpglblst@("DTA",zastavkaId,"skupinaLinky")) {
					        s linkaId="" f {
						        s linkaId=$o(@tmpglblst@("DTA",zastavkaId,"skupinaLinky",linkaId)) i linkaId="" q
						        s txMsg=$e(linkaId,2,7)_" skupina: "
						        s skupinaId="" f {
							        s skupinaId=$o(@tmpglblst@("DTA",zastavkaId,"skupinaLinky",linkaId,skupinaId)) i skupinaId="" q
							        s txMsg=txMsg_skupinaId_","
						        }
						        i $e(txMsg,$l(txMsg))="," s txMsg=$e(txMsg,1,$l(txMsg)-1)
						        s output($i(i))=$lts($lb("MSG","",txMsg),del)
					        }
				        }
				        i $d(@tmpglblst@("DTA",zastavkaId,"platneLinky")) {
					        s txMsg="platné linky: "
					        s linkaId="" f {
						        s linkaId=$o(@tmpglblst@("DTA",zastavkaId,"platneLinky",linkaId)) i linkaId="" q
						        s txMsg=txMsg_$e(linkaId,2,7)_","
					        }
					        i $e(txMsg,$l(txMsg))="," s txMsg=$e(txMsg,1,$l(txMsg)-1)
						    s output($i(i))=$lts($lb("MSG","",txMsg),del)
				        }
			        }
		        }
		        //nepouzita zastavka - vymazu
		        else {
			        k arr d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).vymaz(.sys,zastavkaId,.arr)
			        i cntMsg<11 {
			        	s output($i(i))=$lts($lb("MSG","","zastávka "_zastavkaId_" / "_zastavkaNazev_" byla odstraněna !"),del)
			        }
		        }
		        i cntMsg=11 {
			        s output($i(i))=$lts($lb("MSG","","..."),del)
		        }
		        s cntMsg=cntMsg+1
	        }
        }
		m ^||ML("OUT")=output
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

ClassMethod SSLConfig()
{
   s ns=$znspace
   zn "%SYS"
   s sslName="KDZ.SSL"
   if '##class(Security.SSLConfigs).Exists(sslName) {
      k sslProps
      s sslProps("CAFile")=""
      s sslProps("CAPath")=""
      s sslProps("CRLFile")=""
      s sslProps("CertificateFile")=""
      s sslProps("CipherList")="ALL:!aNULL:!eNULL:!EXP:!SSLv2"
      s sslProps("Description")=sslName
      s sslProps("Enabled")=1
      s sslProps("PrivateKeyFile")=""
      s sslProps("PrivateKeyPassword")=""
      s sslProps("PrivateKeyType")=2
      s sslProps("Protocols")=28
      s sslProps("Type")=0
      s sslProps("VerifyDepth")=9
      s sslProps("VerifyPeer")=0
      s sc=##class(Security.SSLConfigs).Create(sslName,.sslProps)
      //if $$$ISOK(sc) { w "OK" } else { w "ERROR="_$system.Status.GetErrorText(sc) }
   }
   zn ns
}

ClassMethod AktualizovatCentRegZas(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %Status
{
	// VSTUP:
	// VYSTUP:
	// out("n")=pocetUpdate
	$$$Init
	try {
		//<jb 7.10.2024> vola se z  ALVA.ISY.Task, se sys jen nutne promenne
		s IdFa=$g(sys("U","IdFa"))
    	s del=$g(sys("U","delimiter"))
    	s systemDB=$g(sys("U","SystemDB"))
    	s dataDB=$g(sys("U","DATA"))
		
		$$$TMPGLBSET(tmpglblst)
		// ----- config
		d ..SSLConfig()
		// ----- Filename
		s TempFilename=##class(%Library.File).TempFilename() i ##class(%File).Exists(TempFilename) d ##class(%File).Delete(TempFilename)
		s TempDirectory=$p(TempFilename,"\",1,$l(TempFilename,"\")-1)_"\"
		s RegZestFilename=TempDirectory_"RegZast.txt"
		// ----- HttpRequest
		s HttpRequest=##class(%Net.HttpRequest).%New()
		i '$IsObject(HttpRequest) $$$ThrowErr("request",err)
		s HttpRequest.Https=1
		s HttpRequest.SSLConfiguration="KDZ.SSL"
		//s HttpRequest.ContentCharset="Windows-1250"
		s HttpRequest.Server="www.cisjr.cz"
		s HttpRequest.Timeout=180
		// ----- Get and Save
		d HttpRequest.Get("/export/getfile.aspx?id=1544e19a-1753-4a50-b3c2-a08a79c2cdd7")
		i '$IsObject(HttpRequest.HttpResponse) $$$ThrowErr("response",err)
		s Stream=HttpRequest.HttpResponse.Data 
		s file=##class(%Stream.FileBinary).%New()
		d file.LinkToFile(TempFilename)
		s sc=file.CopyFrom(Stream)
		d file.%Save()
		// ----- Unpack
		//s zip=##class(%zip).open(TempFilename)
		//s zip.TargetDir=TempDirectory
		//d zip.unpack()
		s zip=##class(ALVA.GENERALAPI.zip).open(TempFilename)
		s zip.TargetDir=TempDirectory
		d zip.unpack()
		// ----- Read file
		k @tmpglblst
		if '##class(%File).Exists(RegZestFilename) $$$ThrowErr("RegZestFilename",err)
		s file=##class(%FileCharacterStream).%New()
		s file.Filename=RegZestFilename
		s file.TranslateTable="CP1250"
		while ('file.AtEnd) {
			s row=file.ReadLine()
			s @tmpglblst@($i(@tmpglblst))=row
		}
		//mod programu, dodelat na isy api !!!!
		s mode=$$gMode^JRapi(IdFa,dataDB)
		//zapis do databaze
		k ^[systemDB]JRCRZi k ^[systemDB]JRactIns("crz") k ^[dataDB]JRactIns("crz")
		s ^[systemDB]JRactIns("crz",dataDB)=""
		//
		s idx="" f {
			s val="" s idx=$o(@tmpglblst@(idx),1,val) i idx="" q
			s cisloCIS=$p(val,""",""",1) s:$e(cisloCIS,1)="""" cisloCIS=$e(cisloCIS,2,$l(cisloCIS)) s:$e(cisloCIS,$l(cisloCIS))="""" cisloCIS=$e(cisloCIS,1,$l(cisloCIS)-1)
			s obec=$p(val,""",""",2) s:$e(obec,1)="""" obec=$e(obec,2,$l(obec)) s:$e(obec,$l(obec))="""" obec=$e(obec,1,$l(obec)-1)
			s castObce=$p(val,""",""",3) s:$e(castObce,1)="""" castObce=$e(castObce,2,$l(castObce)) s:$e(castObce,$l(castObce))="""" castObce=$e(castObce,1,$l(castObce)-1)
			s lokalita=$p(val,""",""",4) s:$e(lokalita,1)="""" lokalita=$e(lokalita,2,$l(lokalita)) s:$e(lokalita,$l(lokalita))="""" lokalita=$e(lokalita,1,$l(lokalita)-1)
			s blizkaObec=$p(val,""",""",5) s:$e(blizkaObec,1)="""" blizkaObec=$e(blizkaObec,2,$l(blizkaObec)) s:$e(blizkaObec,$l(blizkaObec))="""" blizkaObec=$e(blizkaObec,1,$l(blizkaObec)-1)
			s stat=$p(val,""",""",6) s:$e(stat,1)="""" stat=$e(stat,2,$l(stat)) s:$e(stat,$l(stat))="""" stat=$e(stat,1,$l(stat)-1)
			//nova varianta dat
			s nDatum=$p(val,""",""",7) s:$e(nDatum,1)="""" nDatum=$e(nDatum,2,$l(nDatum)) s:$e(nDatum,$l(nDatum))="""" nDatum=$e(nDatum,1,$l(nDatum)-1)
			s nHorolog="" i nDatum s nHorolog=##class(ALVA.GENERALAPI.Date).DateToHor(nDatum)
			s nObec=$p(val,""",""",8) s:$e(nObec,1)="""" nObec=$e(nObec,2,$l(nObec)) s:$e(nObec,$l(nObec))="""" nObec=$e(nObec,1,$l(nObec)-1)
			s nCastObce=$p(val,""",""",9) s:$e(nCastObce,1)="""" nCastObce=$e(nCastObce,2,$l(nCastObce)) s:$e(nCastObce,$l(nCastObce))="""" nCastObce=$e(nCastObce,1,$l(nCastObce)-1)
			s nLokalita=$p(val,""",""",10) s:$e(nLokalita,1)="""" nLokalita=$e(nLokalita,2,$l(nLokalita)) s:$e(nLokalita,$l(nLokalita))="""" nLokalita=$e(nLokalita,1,$l(nLokalita)-1)
			s nBlizkaObec=$p(val,""",""",11) s:$e(nBlizkaObec,1)="""" nBlizkaObec=$e(nBlizkaObec,2,$l(nBlizkaObec)) s:$e(nBlizkaObec,$l(nBlizkaObec))="""" nBlizkaObec=$e(nBlizkaObec,1,$l(nBlizkaObec)-1)
			s nStat=$p(val,""",""",12) s:$e(nStat,1)="""" nStat=$e(nStat,2,$l(nStat)) s:$e(nStat,$l(nStat))="""" nStat=$e(nStat,1,$l(nStat)-1)
			//
			i nHorolog {
				s obec=nObec
				s castObce=nCastObce
				s lokalita=nLokalita
				s blizkaObec=nBlizkaObec
				s stat=nStat
			}
			//vytvoreni blizke obce pro dataDB v zavislosti na mutaci programu
 			s blizkaObecDB=""
 			i 'mode i '(stat="CZ") s blizkaObecDB="*"_stat
 			i +mode i '(stat="SK") s blizkaObecDB="*"_stat
 			i '(blizkaObec="") {
	 			i blizkaObecDB="" {
		 			s blizkaObecDB=blizkaObec
	 			}
	 			else {
		 			s blizkaObecDB=blizkaObecDB_"/"_blizkaObec
	 			}
 			}
 			//zapis do systemove databaze (zpetna kompatibilita)
			s ^[systemDB]JRCRZi(cisloCIS)=obec_"~"_castObce_"~"_lokalita_"~"_blizkaObec_"~"_stat_"~"_nHorolog
 			//zapis do aktualni databaze
 			s ^[dataDB]JRCRZi(cisloCIS)=obec_"~"_castObce_"~"_lokalita_"~"_blizkaObec_"~"_stat_"~"_nHorolog
 			k arrDta s arrDta("DTA")=$lb(obec,castObce,lokalita,blizkaObecDB,nHorolog)
 			d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyCRZ).uloz(.sys,cisloCIS,.arrDta)
 			//doplnit aktualizaci zastavek !!!
 			//s err=$$actZstCRZ^JRapi(idfa,dataDB,.arri,.arro) zt:+err "merr" s err=""
 		}
		// ----- Delete files
		i ##class(%File).Exists(TempFilename) d ##class(%File).Delete(TempFilename)
		i ##class(%File).Exists(RegZestFilename) d ##class(%File).Delete(RegZestFilename)
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

ClassMethod ZavestVseZCRZ(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %Status
{
	$$$Init
	try {
		$$$FillParams
		$$$TMPGLBSET(tmpglblst)
		s id = ""
		k arrDta
		s arrDta("GLB")=tmpglblst
		s arrDta("PAR","hledanyText") = "*" // filtr
		d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyCRZ).seznam(.sys,.arrDta)
		s abcidx = "" f {
			k valDta s abcidx = $o(@tmpglblst@("IDX",abcidx),1,valDta) i abcidx = "" q
			s $list(id,*+1) = valDta
		}
		k arrDta d ##class(ALVA.ISY.ISYZastavky.API.zastavkyCRZFce).prevodCRZDoZastavky(.sys,id,.arrDta)
		//výstup
		s arrDta("DTA")=$g(arrDta("DTA"))
		s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("MSG","","Počet zastávek v CRZ: "_+$lg(arrDta("DTA"),1)),del)
		s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("MSG","","Z toho již zavedených: "_+$lg(arrDta("DTA"),2)),del)
		s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("MSG","","Počet nově zavedených: "_+$lg(arrDta("DTA"),3)),del)

	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

}
