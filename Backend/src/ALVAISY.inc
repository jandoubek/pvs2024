ROUTINE ALVAISY [Type=INC]
/// =======
/// globaly
/// =======
#define GLBBIGMEM ^[dataDB]ALVA.ISY.BIG.MEM
#define CTMPGLB ^CacheTempALVA.ISY
#define CTMPGLBFRM ^CacheTempALVA.ISY.FRM
#define TMPGLBPS ^CacheTempUserISYOBEHYPS
#define TMPGLBSET(%GLB) s %GLB="^||w.ISY("_$i(^||w.ISY)_")" k @%GLB
///
#define FillSysParamsBig(%IN) ##continue
		 s IdFa=$g(%IN("IdFa")) ##continue
		 s GUID=$g(%IN("GUID")) ##continue
		 s user=$g(%IN("User")) ##continue
		 s userID=$lg(user,1) ##continue
		 s loginName=$lg(user,2) ##continue
		 s userName=$lg(user,3) ##continue
		 k tmpArr d ##class(ALVA.EDISON.Main).GetApplicationInfo(-1,.tmpArr,IdFa) s dataDB=$g(tmpArr(0)) k tmpArr ##continue
		 s systemDB=##class(ALVA.EDISON.Main).GetSystemDB() ##continue
		 s del=##class(ALVA.EDISON.Main).GetDelimiter() ##continue
		 s sys("U","IdFa")=IdFa ##continue
		 s sys("U","delimiter")=del ##continue
		 s sys("U","SystemDB")=systemDB ##continue
		 s sys("U","DATA")=dataDB ##continue
		 s sys("U","MLP")=userID ##continue
		 s sys("U","fullName")=userName ##continue
		 s sys("U","loginName")=loginName ##continue
		 s sys("C","GUID")=GUID 
///
#define isyFormZastavkaEdit "ISYZastavky.Forms.formISYZastavkyZastavkaEdit"
#define isyFormZastavkyOznaceniList "ISYZastavky.Forms.formISYZastavkyOznaceniList"
#define vytvorSys(%IDFA) ##continue
		 k tmpArr d ##class(ALVA.EDISON.Main).GetApplicationInfo(-1,.tmpArr,%IDFA) s dataDB=$g(tmpArr(0)) k tmpArr ##continue
		 s sys("U","IdFa")="VS_CSAD" ##continue
		 s sys("U","delimiter")=##class(ALVA.EDISON.Main).GetDelimiter() ##continue
		 s sys("U","SystemDB")=##class(ALVA.EDISON.Main).GetSystemDB() ##continue
		 s sys("U","DATA")=dataDB ##continue
		 s sys("U","MLP")=155 ##continue
		 s sys("U","fullName")="test" ##continue
		 s sys("U","loginName")="t" ##continue
		 s sys("C","GUID")="GUID-1234-4567-7890" 
///

