Include ALVATM

Class ALVA.ISY.Task Extends %SYS.Task.Definition
{

/// Nazev ulohy
Parameter TaskName = "ISYBUS";

/// ID firmy
Property IdFa As %String;

/// Typ ulohy
Property Type As %Integer;

/// Testovaci metoda
ClassMethod Test()
{
	//d ##class(ALVA.ISY.Task).Test()
	
	s test=##class(ALVA.ISY.Task).%New()
	s test.IdFa="VS_CSAD"
	s test.Type=83
	s err=test.OnTask()
}

/// Updatovaci metoda
Method OnTask() As %Status
{
    s err=""
    //import celostatniho registru zastavek
    if ..Type=$$$TaskTypeALVAISYImportZastavekCRZ {
	    d ##class(ALVA.TM.Task).UpdateTask("",..IdFa,..Type,$$$TaskStateRunning,"",$h)
        k arr d ##class(ALVA.EDISON.Main).GetApplicationInfo(-1,.arr,..IdFa) s dataDB=$g(arr(0)) k arr
        k sys
        s sys("U","IdFa")=..IdFa
        s sys("U","delimiter")=$c(0)
        s sys("U","SystemDB")=##class(ALVA.EDISON.Main).GetSystemDB()
        s sys("U","DATA")=dataDB
        d ##class(ALVA.ISY.ISYZastavky.Forms.formISYZastavkyMain).AktualizovatCentRegZas(.sys,"","")
        d ##class(ALVA.TM.Task).UpdateTask("",..IdFa,..Type,$s('err:$$$TaskStateOK,1:$$$TaskStateError),err,"")
    }
    
    quit $$$OK
}

}
