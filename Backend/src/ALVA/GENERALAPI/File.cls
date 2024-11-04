Include GENERAL

Class ALVA.GENERALAPI.File Extends %RegisteredObject
{

ClassMethod TxtFile2Global(ByRef FullFileName As %String, ByRef GlobalName As %String, ByRef CodePage As %String)
{
	// d ##class(ALVA.GENERALAPI.File).TxtFile2Global("\\Azor\ftp\stanislav.kaska\pokus.txt","^||CSV")

	k @GlobalName
	s Stream=##class(%FileCharacterStream).%New()
 	d Stream.LinkToFile(FullFileName)
 	d Stream.TranslateTableSet("RAW")
 	if $g(CodePage)'="" { d Stream.TranslateTableSet(CodePage) }
 	while 'Stream.AtEnd  {
 		s @GlobalName@($i(@GlobalName))=Stream.ReadLine()
 	}
 	d Stream.%Close()
 	k Stream
}

ClassMethod ImportTxtFile2Glb(ByRef koncovka As %String, ByRef adresar As %String, ByRef glb As %String, ByRef kodovani As %String) As %String
{
	// Import souborů z adresáře, podle koncovky, do globálu
	// w ##class(ALVA.GENERALAPI.File).ImportTxtFile2Glb("CSV","\\Azor\ftp\stanislav.kaska\RidiciImportCSV\","^MZDY.RIDICI")
	
	$$$Init
	try 
	{
		if $g(adresar)="" quit
		if $g(koncovka)="" quit
		
		k soubory
		s rset=##class(%ResultSet).%New()
		s rset.ClassName="%File"
		s rset.QueryName="FileSet"
		s konL=$zconvert(koncovka,"L")
		s konU=$zconvert(konL,"U")
		d rset.Execute(adresar,"*."_koncovka_";*."_konL_";*."_konU,0)
		while (rset.Next(.sc)) {
			if ($$$ISOK(sc)) {
				s soubor=rset.Data("Name")  
				s soubory($i(i))=soubor
			}
		}
		d rset.Close()
		
		k ^||DATA
		s h=$h 
		s adrDat=$zdate($p(h,",",1),3)_"_"_$replace($ztime($p(h,",",2),1),":","-")
		
		s i="" for {
			s i=$o(soubory(i)) q:i=""
			s soubor=$g(soubory(i))
			s cesta=$replace(soubor,"."_koncovka,".WRK")
			s cesta=$replace(soubor,"."_konL,".WRK")
			s cesta=$replace(soubor,"."_konU,".WRK")
			d ##class(%Library.File).Rename(soubor,cesta,.stav)
			
			k ^||CSV
			d ##class(ALVA.GENERALAPI.File).TxtFile2Global(cesta,"^||CSV",kodovani)
			
			m ^||DATA(i,"data")=^||CSV
			s ^||DATA(i,"soubor")=soubor
			
			s souborOld=cesta
			s souborNew=$replace(cesta,".WRK",".DONE")
			d ##class(%Library.File).Rename(souborOld,souborNew,.stav)
			
			s nazevSouboru=$p(souborNew,"\",$l(souborNew,"\"))
			s cestaSouboru=$p(souborNew,"\",1,$l(souborNew,"\")-1)
			
			s souborN=cestaSouboru_"\"_adrDat_"\"_nazevSouboru
			d ##class(%Library.File).CreateDirectory(cestaSouboru_"\"_adrDat_"\",.stav)
			d ##class(%Library.File).CopyFile(souborNew,souborN,1,.stav)
			d ##class(%Library.File).Delete(souborNew,.stav)
		}
		
		k @glb
		m @glb=^||DATA
		
		k ^||DATA
		k ^||CSV
	}
	catch (ex) 
	{
		$$$CatchErrToInputErr
	}
	q ret
}

ClassMethod ReadCSV(file As %String, deli As %String, infoLine As %Boolean, glb As %String) As %Status
{
	s ret=$$$OK
	s err=""
	try {
		k @glb
		s propsCount=0,rowIdx=0
		if '##class(%File).Exists(file) s err="File ["_file_"] doesn't exist!" ztrap
		s stream=##class(%FileCharacterStream).%New()
		s stream.Filename=file
		while 'stream.AtEnd {
			s row=stream.ReadLine()
			if $i(rowIdx)=1 {
				s propsCount=$l(row,deli)
				if infoLine s @glb@("info")=$lfs(row,deli) continue
			}
			s row=$lfs(row,deli) if $ll(row)'=propsCount s err="Invalid count of arguments in line ["_rowIdx_"]!"
			s @glb@("rec",$i(@glb@("rec")))=row
		}
	}
	catch (ex) {
		s ret=$$$ERROR($$$GeneralError,err_ex.DisplayString())
	}
	q ret
}

ClassMethod ReadXML(file As %String, glb As %String) As %Status
{
    s ret=$$$OK
	s err=""
	try {
		k @glb
		s sc=##class(ALVA.GENERALAPI.ParserXML).ReadFile(file,1,glb) if 'sc s err=$system.Status.GetErrorText(sc) ztrap
	}
	catch (ex) {
		s ret=$$$ERROR($$$GeneralError,err_ex.DisplayString())
	}
	q ret
}

}
