Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY, ALVAEDREPORTS)

Class ALVA.ISY.ISYZastavky.Reportgen.OznaceniZastavek Extends %RegisteredObject
{

ClassMethod getSadu(idfa As %String, nmsp As %String, glb As %String) As %String
{
  s @glb@("POPIS") = "označení zastávek"
  // ----------------------------------------------
  s @glb@("FIELDS", "VALUE") 			   ="hodnota, pro niz se sestava vola"
  //
  s @glb@("TABLES", "ZAST_OZNACENI")="Označení zastávek"
  s @glb@("TABLES", "ZAST_OZNACENI", "COLS", 1)="ZAST_NAZEV#Zastávka název#S"
  //
  q 0
}

ClassMethod getData(idfa As %String, nmsp As %String, ValueId As %String, ByRef sys As %String, glb As %String) As %String
{
 s err="" s $zt="err"	
 s i=0
 s @glb@($i(i)) ="FIELD~VALUE~"_ValueId
 s db=$g(sys("U","DATA"))
 s fullName=$g(sys("U","fullName"))
 ;; ----------------------------------------------
 if ValueId'="" {
	k arrLstZast
	f cnt=1:1:$l(ValueId,"#") {
		s zastavkaId=$p($p(ValueId,"#",cnt),"|",1)
		s pocet=$p($p(ValueId,"#",cnt),"|",2)
		i zastavkaId'="" {
			s sc=$$gZst^JRapi(idfa,nmsp,zastavkaId,"",.arrDta)
			s zastavkaNaz=$g(arrDta("dta",1))_","_$g(arrDta("dta",2))_","_$g(arrDta("dta",3))
			i $e(zastavkaNaz,$l(zastavkaNaz))="," s zastavkaNaz=$e(zastavkaNaz,1,$l(zastavkaNaz)-1)
			i $e(zastavkaNaz,$l(zastavkaNaz))="," s zastavkaNaz=$e(zastavkaNaz,1,$l(zastavkaNaz)-1)
			s arrLstZast(##class(ALVA.GENERALAPI.String).gSortTxt(zastavkaNaz))=$lb(zastavkaNaz,pocet)
		}
	}
	s @glb@($i(@glb))="TABLE_START~ZAST_OZNACENI"
	s idx="" f {
		s val="" s idx=$o(arrLstZast(idx),1,val) i idx="" q
		s zastavkaNaz=$lg(val,1)
		s pocet=$lg(val,2) i 'pocet s pocet=1
		f cnt=1:1:pocet {
			s @glb@($i(@glb))="ROW_START~"
    		s @glb@($i(@glb))="CELL~ZAST_NAZEV~"_zastavkaNaz_"~"_0 			
			s @glb@($i(@glb))="ROW_END"
		}
	}
	s @glb@($i(@glb))="TABLE_END"
 }
 q 0
err
 s $zt=""
 q 1
}

/*
ClassMethod GetValueID(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
 s $zt="err" s err="" s ^||ML("ERR")=""
 d ##class(ALVA.JRMAIN.Main).GetOdd(.odd)
#; -----------------------------------------------------------------------
#; obecne parametry
 s mlp=$g(sys("U","MLP"))
 s idfa=$g(sys("U","IdFa"))
 s nmsp=$g(sys("U","DATA"))
#; -----------------------------------------------------------------------
#; in parametry
 s id="" k arrid
 s ind="" f {
	 s ind=$o(^||ML("IN",ind)) i ind="" q
 	 s val=$g(^||ML("IN",ind))
 	 i $p(val,"~",1)="LINKA" {
	 	 s id=$p(val,"~",2)
	 	 i id'="" s arrid(id)=""
 	 }
 }
#; -----------------------------------------------------------------------
#; vytvoreni ValueID
 s wrk=$$gWrkALVAJR^JRapi() k ^||wrk.ALVA.JR(wrk)
 s id="" f {
	  s id=$o(arrid(id)) i id="" q
      i $p(id,"|",2)'="l" continue
      s sku=$p(id,"|",1)
      s lin=$p(id,"|",3)
 	  k arrtrs s err=$$gTrsLin^JRapi(idfa,nmsp,sku,lin,"",.arrtrs) zt:+err "merr" s err=""
      k arrlsp s err=$$lSpLin^JRapi(idfa,nmsp,sku,lin,"",.arrlsp) zt:+err "merr" s err=""
      s sm="" f {
	      s sm=$o(arrlsp("arr",sm)) i sm="" q
 		  s sp="" f {
	 		   s sp=$o(arrlsp("arr",sm,sp)) i sp="" q
 			   k arrsp s err=$$gSpLin^JRapi(idfa,nmsp,sku,lin,sm,sp,"",.arrsp) zt:+err "merr" s err=""
 			   s zstod=+$g(arrtrs("arr",+$g(arrsp("dta",1)),"dta",1)) k arrzst s err=$$gZst^JRapi(idfa,nmsp,zstod,"",.arrzst) zt:+err "merr" s err=""
 			   s zstod=$$upN^JRapi($g(arrzst("dta",1))_","_$g(arrzst("dta",2))_","_$g(arrzst("dta",3))) s:zstod="" zstod=" "
 			   s zstdo=+$g(arrtrs("arr",+$g(arrsp("dta",2)),"dta",1)) k arrzst s err=$$gZst^JRapi(idfa,nmsp,zstdo,"",.arrzst) zt:+err "merr" s err=""
 			   s zstdo=$$upN^JRapi($g(arrzst("dta",1))_","_$g(arrzst("dta",2))_","_$g(arrzst("dta",3))) s:zstdo="" zstdo=" "
 			   i $tr(zstdo," ","")="" continue
 			   s ^||wrk.ALVA.JR(wrk,id,zstdo)=""
 		  }
     }
 }
 s id="" f {
	 s id=$o(^||wrk.ALVA.JR(wrk,id)) i id="" q
	 s zstdo="" f {
		 s zstdo=$o(^||wrk.ALVA.JR(wrk,id,zstdo)) i zstdo="" q
		 s ^||ML("OUT",$i(^||ML("OUT")))="ValueID~"_id_"|"_zstdo_"~"_$e($p(id,"|",3),2,7)_" "_zstdo
	 }
 }
#; -----------------------------------------------------------------------
 q 1
err
#; chyba
 s $zt=""
 s ^||ML("ERR")=$ze_" "_$g(err)        
 q $ze_" "_$g(err)
}
*/
}
