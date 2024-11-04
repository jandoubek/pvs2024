Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY, ALVAEDREPORTS)

Class ALVA.ISY.ISYZastavky.Reportgen.API Extends %RegisteredObject
{

ClassMethod GetSeznamSad(idfa As %String, nmsp As %String, glb As %String) As %String
{
  s i=0
  s @glb@($i(i)) = "SADA~OZNACENI_ZASTAVEK~Označení zastávek"
  q 0
}

ClassMethod GetSadu(in As %String, glb As %String) As %String
{
 //GetSadu(idfa As %String, nmsp As %String, SadaId As %String, glb As %String) As %String
 s idfa=in("IdFaOrig")
 s nmsp=in("db")
 s sysDB = in("sysDB")
 s SadaId=in("SadaId")
 s JazykId=in("JazykId")
 //	
 i (SadaId="OZNACENI_ZASTAVEK") { s err=##class(ALVA.ISY.ISYZastavky.Reportgen.OznaceniZastavek).getSadu(idfa,nmsp,glb)}
 q 0
}

ClassMethod GetSeznamRGSablon(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
 //
 s $zt="err" s err=""
 s mlp=$g(sys("U","MLP"))
 s idfa=$g(sys("U","IdFa"))
 s db=$g(sys("U","DATA"))
 s sysDB=$g(sys("U","SystemDB"))
 //===========================================
 //in("par",1)=SadaID
 //out("arr",1,cnt)=SablonaID_"~"_SablonaNazev
 //===========================================
 f myIdFa=idfa,"MLINE" {
	 s id="" f {
		 s id=$o(^[sysDB]AlvaReportGenerator("STROM",myIdFa,"SESTAVY",id)) i id="" q
	 	 i $g(in("par",1))'="" i $g(in("par",1))'=$g(^[sysDB]AlvaReportGenerator("STROM",myIdFa,"SESTAVY",id,"Sada")) continue
		 s nazevSablony=$g(^[sysDB]AlvaReportGenerator("STROM",myIdFa,"SESTAVY",id))
		 s out("arr",1,$i(out("arr",1)))=id_"~"_nazevSablony
   	 }
 }
 ;; ======================================================================================================
 q 0
err
 ;;Chybka occured
 s $zt=""
 q 1_" "_$ze_" "_$g(err)
}

ClassMethod GetData(ByRef in As %String, ByRef sys As %String, glb As %String) As %String
{
 //
 s idfa=$g(in("IdFaOrig"))
 s nmsp=$g(in("db"))
 s SadaId=$g(in("SadaId"))
 s ValueId=$g(in("ValueId"))
 s JazykId=$g(in("JazykId"))
 //
 s err=0
 // 
 i (SadaId="OZNACENI_ZASTAVEK") { s err=##class(ALVA.ISY.ISYZastavky.Reportgen.OznaceniZastavek).getData(idfa,nmsp,ValueId,.sys,glb)}
 q err
}

ClassMethod ExportReportToGlb()
{
    // TODO
 //d ##class(ALVA.JRREPORTGEN.Api).ExportReportToGlb()
 //s enmsp=##class(ALVA.EDISON.Main).GetSystemDB() zn enmsp
 //k ^AlvaReportGeneratorTransferJR
 //f idt="OBLASTI","SESTAVY" d
 //.s ids="" f  s ids=$o(^AlvaReportGenerator("STROM","MLINE",idt,ids)) q:ids=""  d
 //..i ($p(ids,"-",1)="MLINE")&($p(ids,"-",2)="JR") d
 ///...m ^AlvaReportGeneratorTransferJR("STROM","MLINE",idt,ids)=^AlvaReportGenerator("STROM","MLINE",idt,ids)
 // zapis na disk
 //k arrglb s arrglb("^AlvaReportGeneratorTransferJR.gbl")=""
 //s err=##class(%Library.Global).Export(enmsp,.arrglb,"\\192.168.16.1\u\Edison\Release\GLB\AlvaReportGeneratorTransferJR.gof",7)
}

ClassMethod TransferReportToGlb()
{
 //d ##class(ALVA.JRREPORTGEN.Api).TransferReportToGlb()
 // zruseni sestav pro JR 
 //f idt="OBLASTI","SESTAVY" d
 //.s ids="" f  s ids=$o(^AlvaReportGenerator("STROM","MLINE",idt,ids)) q:ids=""  d
 //..i ($p(ids,"-",1)="MLINE")&($p(ids,"-",2)="JR") d
 //...i $d(^AlvaReportGeneratorTransferJR("STROM","MLINE",idt,ids)) k ^AlvaReportGenerator("STROM","MLINE",idt,ids)
 //f idt="OBLASTI","SESTAVY" d
 //.s ids="" f  s ids=$o(^AlvaReportGeneratorTransferJR("STROM","MLINE",idt,ids)) q:ids=""  d
 //..i ($p(ids,"-",1)="MLINE")&($p(ids,"-",2)="JR") d
 //...m ^AlvaReportGenerator("STROM","MLINE",idt,ids)=^AlvaReportGeneratorTransferJR("STROM","MLINE",idt,ids)
 //k ^AlvaReportGeneratorTransferJR
}

}
