Include (ALVALIBRARY, ALVAEDFORMS, GENERAL)

Class ALVA.ISY.ISYZastavky.API.ZastavkyImportSoubor Extends %RegisteredObject
{

ClassMethod importKladno()
{
	//d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyImportSoubor).importKladno()
	
	s IdFa="KL_CSADMHD" s dataDB="KL_CSADMHD" s del=$c(0)
	s IdFa="VS_CSAD" s dataDB="USER" s del=$c(0)
	
	k sys
	s sys("U","IdFa")=IdFa
    s sys("U","delimiter")=del
    s sys("U","SystemDB")="MLINE"
    s sys("U","DATA")=dataDB
    s sys("U","MLP")=1
    s sys("U","fullName")="a"
    s sys("U","loginName")="a"
    
	s file="\\cloud3\U\CacheIns\AD\kladno\zastavky_pro_edison.csv" s fileIdx=1
	s glb="^||wi" k @glb
	
	d ..iCSVFile(file,fileIdx,";",glb)
	
	//zastavky
	s fileIdx=1 s rowIdx=1 f {
		s rowIdx=$o(@glb@(fileIdx,rowIdx)) i rowIdx="" q
		s zastavkaId=$g(@glb@(fileIdx,rowIdx,"d",1))
		s zastavkaCIS=$g(@glb@(fileIdx,rowIdx,"d",2))
		s nazev=$g(@glb@(fileIdx,rowIdx,"d",3)) s obec=$p(nazev,",",1) s castObce=$p(nazev,",",2) s lokalita=$p(nazev,",",3)
		s ozTisk=$g(@glb@(fileIdx,rowIdx,"d",4))
		s oz=$g(@glb@(fileIdx,rowIdx,"d",5))
		s ozTabloCelni=$g(@glb@(fileIdx,rowIdx,"d",6))
		s ozTabloCelniMHD=$g(@glb@(fileIdx,rowIdx,"d",7))
		s ozTabloBocni=$g(@glb@(fileIdx,rowIdx,"d",8))
		s ozTabloBocniMHD=$g(@glb@(fileIdx,rowIdx,"d",9))
		s ozTabloVnitrni=$g(@glb@(fileIdx,rowIdx,"d",10))
		s ozTabloVnitrniMHD=$g(@glb@(fileIdx,rowIdx,"d",11))
		s ozLCD=$g(@glb@(fileIdx,rowIdx,"d",12))
		s ozLCDMHD=$g(@glb@(fileIdx,rowIdx,"d",13))
		s hlasic=$g(@glb@(fileIdx,rowIdx,"d",14))
		s nacestna=($g(@glb@(fileIdx,rowIdx,"d",15))["Ano")
		s naZnameni=($g(@glb@(fileIdx,rowIdx,"d",16))["Ano")
		s mhd=($g(@glb@(fileIdx,rowIdx,"d",17))["Ano")
		s oblast=$g(@glb@(fileIdx,rowIdx,"d",18))
		s vlak=($g(@glb@(fileIdx,rowIdx,"d",19))["Ano")
		s metroA=($g(@glb@(fileIdx,rowIdx,"d",20))["Ano")
		s metroB=($g(@glb@(fileIdx,rowIdx,"d",21))["Ano")
		s metroC=($g(@glb@(fileIdx,rowIdx,"d",22))["Ano")
		s zpp=($g(@glb@(fileIdx,rowIdx,"d",23))["Ano")
		s blo=$g(@glb@(fileIdx,rowIdx,"d",24))
		s stat=$g(@glb@(fileIdx,rowIdx,"d",25))
		
		i 'zastavkaId continue
		
		k arrDta
		
		s $li(arrDta("DTA"),1)=obec
		s $li(arrDta("DTA"),2)=castObce
		s $li(arrDta("DTA"),3)=lokalita
		s $li(arrDta("DTA"),4)=blo
		s $li(arrDta("DTA"),14)=zastavkaCIS
		
		s atribut=""
		i vlak s:atribut'="" atribut=atribut_"," s atribut=atribut_"L"
		i naZnameni s:atribut'="" atribut=atribut_"," s atribut=atribut_"x"
		i metroA s:atribut'="" atribut=atribut_"," s atribut=atribut_"e"
		i metroB s:atribut'="" atribut=atribut_"," s atribut=atribut_"f"
		i metroC s:atribut'="" atribut=atribut_"," s atribut=atribut_"g"
		
		s $li(arrDta("DTA"),7)=$lfs(atribut,",")
		s $li(arrDta("DTA"),28)=nacestna
		s $li(arrDta("DTA"),9)=oz
		s $li(arrDta("DTA"),10)=oz
		s $li(arrDta("DTA"),25)=ozTisk
		s $li(arrDta("DTA"),18)=ozTabloCelni
		s $li(arrDta("DTA"),35)=ozTabloCelniMHD
		s $li(arrDta("DTA"),11)=ozTabloBocni
		s $li(arrDta("DTA"),32)=ozTabloBocniMHD
		s $li(arrDta("DTA"),29)=ozTabloVnitrni
		s $li(arrDta("DTA"),33)=ozTabloVnitrniMHD
		s $li(arrDta("DTA"),24)=ozLCD
		s $li(arrDta("DTA"),38)=ozLCDMHD
		s $li(arrDta("DTA"),21)=hlasic
		
		
		d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).uloz(.sys,zastavkaId,"",.arrDta)
		
	}
}

ClassMethod iCSVFile(file As %String, fileIdx As %String, del As %String, glb As %String)
{
   //===================================================
   //import csv souboru s oddelovacem a zapis do globalu
   //===================================================
   //
   k @glb@(fileIdx)
   if ##class(%File).Exists(file) {
      s stream=##class(%FileCharacterStream).%New()
      s stream.Filename=file
      d stream.TranslateTableSet("CP1250")
      s row=""
      while 'stream.AtEnd {
         s row=stream.ReadLine()
         s rowidx=$i(@glb@(fileIdx))
         f cnt=1:1:$l(row,del) {
	         s @glb@(fileIdx,rowidx,"d",cnt)=$p(row,del,cnt)
         }
      }
   }
   else {
      w !,"soubor "_file_" neexistuje !" 
   }
}

}
