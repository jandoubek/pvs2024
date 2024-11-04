Include ALVALIBRARY

Class ALVA.GENERALAPI.Email [ Abstract ]
{

// Created by XK 2020-05-19

ClassMethod Send(ByRef in As %String, ByRef out As %String) As %Status
{
	// VSTUP:
	// in("smtpIdfa")=SMTP Idfa (pokud uvedeno, nacita nastaveni SMTP z firmy jako defaultni)
	// in("smtpServer")=SMTP Server !
	// in("smtpPort")=SMTP Port (default 25)
	// in("smtpUN")=SMTP Uzivatelske jmeno (jen pokud SMTP server vyzaduje prihlaseni)
	// in("smtpPW")=SMTP Uzivatelske heslo (jen pokud SMTP server vyzaduje prihlaseni)
	// in("smtpMechanismList")=SMTP Mechanismy [mechanismus,] (CRAM-MD5,LOGIN,PLAIN)
	// in("smtpSSLConfiguration")=SMTP SSL konfigurace
	// in("smtpFrom")=SMTP Odesilatel !
	// in("smtpTo",n)=SMTP Prijemci !
	// in("smtpToSeparately")=SMTP Prijemci oddelene [0/1] (default 0) (nelze pouzit s CC a BCC)
	// in("smtpCc",n)=SMTP Prijemci v kopii
	// in("smtpBcc",n)=SMTP Prijemci ve skryte kopii
	// in("smtpSubject")=SMTP Predmet emailu !
	// in("smtpMessage")=SMTP Text emailu !
	// in("smtpIsBinary")=SMTP Zprava je binarni [0/1] (default 0)
	// in("smtpIsHTML")=SMTP Zprava je HTML [0/1] (default 0)
	// in("smtpAttachFile",n)=SMTP Prilohy - soubory
	// in("smtpAttachStream",file,n)=SMTP Prilohy - stream
	
	// VYSTUP:
	// out("smtpStatus")=$lb(SMTP uspech [0/1],SMTP informace)
	// out("smtpStatus",prijemce)=$lb(SMTP uspech [0/1],SMTP informace) (pokud prijemci oddelene (in("smtpToSeparately")=1))
	
	s ret=$$$OK
	s err=""
	try {
		// init
		k out s out("smtpStatus")=$lb(0,"")
		// firma
		if $g(in("smtpIdfa"))'="" {
			k inputFirma,outputFirma
			s sc=$$isIdFa^MlJFapi(in("smtpIdfa"),"MLINE",.inputFirma,.outputFirma) if sc s err=sc ztrap
			if $g(outputFirma) {
				k inputFirma,outputFirma
				s sc=$$gIdFa^MlJFapi(in("smtpIdfa"),"MLINE",.inputFirma,.outputFirma) if sc s err=sc ztrap
				if '$d(in("smtpServer")) s in("smtpServer")=$g(outputFirma("dta",27)) if in("smtpServer")="" s out("smtpStatus")=$lb(0,"Není zadán SMTP server!") q
				if '$d(in("smtpPort")) s in("smtpPort")=+$g(outputFirma("dta",42)) if 'in("smtpPort") s out("smtpStatus")=$lb(0,"Není zadán SMTP port!") q
				if '$d(in("smtpUN")) s in("smtpUN")=$g(outputFirma("dta",28))
				if '$d(in("smtpPW")) s in("smtpPW")=$g(outputFirma("dta",29))
				if '$d(in("smtpSSLConfiguration")) s in("smtpSSLConfiguration")=$g(outputFirma("dta",63))
				if '$d(in("smtpFrom")) s in("smtpFrom")=$g(outputFirma("dta",26)) if in("smtpServer")="" s out("smtpStatus")=$lb(0,"Není zadán odesílatel!") q
			}
		}
		// vstup
		s smtpServer=$g(in("smtpServer")) if smtpServer="" s err="smtpServer" ztrap
		s smtpPort=+$g(in("smtpPort")) if 'smtpPort s smtpPort=25
		s smtpUN=$g(in("smtpUN"))
		s smtpPW=$g(in("smtpPW"))
		s smtpMechanismList=$g(in("smtpMechanismList"))
		s smtpSSLConfiguration=$g(in("smtpSSLConfiguration"))
		s smtpFrom=$g(in("smtpFrom")) if smtpFrom="" s err="smtpFrom" ztrap
		m smtpTo=in("smtpTo") if $o(smtpTo(""))="" s err="smtpTo" ztrap
		s smtpToSeparately=''$g(in("smtpToSeparately"))
		m smtpCc=in("smtpCc")
		m smtpBcc=in("smtpBcc")
		s smtpSubject=$g(in("smtpSubject")) if smtpSubject="" s err="smtpSubject" ztrap
		s smtpMessage=$g(in("smtpMessage")) if smtpMessage="" s err="smtpMessage" ztrap
		s smtpIsBinary=''$g(in("smtpIsBinary"))
		s smtpIsHTML=''$g(in("smtpIsHTML"))
		m smtpAttachFile=in("smtpAttachFile")
		m smtpAttachStream=in("smtpAttachStream")
		// server
		s netSMTP=##class(%Net.SMTP).%New()
		s netSMTP.smtpserver=smtpServer
		s netSMTP.port=smtpPort
		if smtpUN'="" {
			s netAuthenticator=##class(%Net.Authenticator).%New()
			s netAuthenticator.UserName=smtpUN
			s netAuthenticator.Password=smtpPW
			if smtpMechanismList'="" s netAuthenticator.MechanismList=smtpMechanismList
			s netSMTP.authenticator=netAuthenticator
			s netSMTP.AuthFrom=netAuthenticator.UserName
			if smtpSSLConfiguration'="" {
				if smtpPort=587 s netSMTP.UseSTARTTLS=1 // KZ 20240206 doplnena podminka na port 587, protoze 465 nepouziva STARTTLS
				s netSMTP.SSLConfiguration=smtpSSLConfiguration
			}
		}
		// mail
		s netMailMessage=##class(%Net.MailMessage).%New()
		s netMailMessage.From=smtpFrom
		s netMailMessage.Subject=smtpSubject
		s netMailMessage.IsBinary=smtpIsBinary
		s netMailMessage.IsHTML=smtpIsHTML
		d netMailMessage.TextData.Write(smtpMessage)
		// prilohy - file
		s smtpAttachFileId=""
		for {
			s smtpAttachFileId=$o(smtpAttachFile(smtpAttachFileId),1,smtpAttachFileVal) if smtpAttachFileId="" q
			if smtpAttachFileVal'="" d netMailMessage.AttachFile(##class(%File).GetDirectory(smtpAttachFileVal),##class(%File).GetFilename(smtpAttachFileVal))
		}
		// prilohy - stream
		s smtpAttachStreamId=""
		for {
			s smtpAttachStreamId=$o(smtpAttachStream(smtpAttachStreamId)) if smtpAttachStreamId="" q
			s stream=##class(%Stream.TmpBinary).%New()
			s streamId=""
			for {
				s streamId=$o(smtpAttachStream(smtpAttachStreamId,streamId),1,streamVal) if streamId="" q
				d stream.Write(streamVal)
			}
			d netMailMessage.AttachStream(stream,smtpAttachStreamId,1)
		}
		// odeslani zprav
		s smtpStatus=$lb(1,"")
		// prijemcum oddelene
		if smtpToSeparately {
			s smtpToId=""
			for {
				s smtpToId=$o(smtpTo(smtpToId),1,smtpToVal) if smtpToId="" q
				d netMailMessage.To.Clear()
				d netMailMessage.To.Insert(smtpToVal)
				// poslani mailu
				s sc=netSMTP.Send(netMailMessage)
				s smtpStatus(smtpToVal)=$lb(1,"")
				if $$$ISERR(sc) {
					s smtpStatus=$lb(0,$li(smtpStatus,2)_$SYSTEM.Status.GetErrorText(sc)_$c(13,10))
					s smtpStatus(smtpToVal)=$lb(0,$SYSTEM.Status.GetErrorText(sc))
				}
			}
		}
		// prijemcum dohromady
		if 'smtpToSeparately {
			// prijemci
			s smtpToId=""
			for {
				s smtpToId=$o(smtpTo(smtpToId),1,smtpToVal) if smtpToId="" q
				d netMailMessage.To.Insert(smtpToVal)
			}
			// kopie (Carbon Copy)
			s smtpCcId=""
			for {
				s smtpCcId=$o(smtpCc(smtpCcId),1,smtpCcVal) if smtpCcId="" q
				d netMailMessage.Cc.Insert(smtpCcVal)
			}
			// skryte kopie (Blind Carbon Copy)
			s smtpBccId=""
			for {
				s smtpBccId=$o(smtpBcc(smtpBccId),1,smtpBccVal) if smtpBccId="" q
				d netMailMessage.Bcc.Insert(smtpBccVal)
			}
			// poslani mailu
			s sc=netSMTP.Send(netMailMessage)
			if $$$ISERR(sc) s smtpStatus=$lb(0,$SYSTEM.Status.GetErrorText(sc))
		}
		// vystup
		m out("smtpStatus")=smtpStatus
	}
	catch (ex) {
		s ret=$$$ERROR($$$GeneralError,err_ex.DisplayString())
	}
	q ret
}

ClassMethod SendTestFromCache() As %String
{
	s ret=$$$OK
	s err=""
	try {
		// test
		k input,output
		s input("smtpServer")="exchange.m-line.cz"
		s input("smtpPort")=25
		s input("smtpUN")=""
		s input("smtpPW")=""
		s input("smtpMechanismList")="CRAM-MD5,LOGIN,PLAIN"
		s input("smtpSSLConfiguration")=""
		s input("smtpFrom")="mail@m-line.cz"
		s input("smtpTo",$i(input("smtpTo")))="jiri.krhanek@m-line.cz"
		s input("smtpToSeparately")=0
		s input("smtpSubject")="TEST"
		s input("smtpMessage")="Začátek zprávy"_$c(13,10)_"Konec zprávy"
		s input("smtpIsBinary")=0
		s input("smtpIsHTML")=0
		s sc=..Send(.input,.output) if $$$ISERR(sc) s err=$SYSTEM.Status.GetErrorText(sc) ztrap
		zw output
	}
	catch (ex) {
		s ret=err_ex.DisplayString()
	}
	q ret
}

ClassMethod SendFromEdison(ByRef sys As %String) As %String
{
	// VSTUP:
	// ^||ML("IN",x)=smtpFrom
	// ^||ML("IN",x)=smtpTo (;)
	// ^||ML("IN",x)=smtpCC (;)
	// ^||ML("IN",x)=smtpSubject
	// ^||ML("IN",x)=smtpAttachFile (;)
	// ^||ML("IN",x)=smtpMechanismList (,)
	// ^||ML("IN",x)=smtpIsHTML [0/1]
	// ^||ML("IN",x)=smtpIsBinary [0/1]
	// ^||ML("IN",x)=smtpToSeparately [0/1]
	// ^||ML("IN",x)=smtpMessage
	
	// VYSTUP:
	// ^||ML("OUT",n)=status
	 $$$FillParams
	s ret=$$$OK
	s err=""
	try
	{	
		// vstup
		s smtpFrom=$g(^||ML("IN",$i(i))) 
		s smtpTo=$g(^||ML("IN",$i(i))) if smtpTo="" s err="smtpTo" ztrap
		s smtpCC=$g(^||ML("IN",$i(i)))
		s smtpSubject=$g(^||ML("IN",$i(i))) if smtpSubject="" s err="smtpSubject" ztrap
		s smtpAttachFile=$g(^||ML("IN",$i(i)))
		s smtpMechanismList=$g(^||ML("IN",$i(i)))
		s smtpIsHTML=+$g(^||ML("IN",$i(i)))
		s smtpIsBinary=+$g(^||ML("IN",$i(i)))
		s smtpToSeparately=+$g(^||ML("IN",$i(i)))
		s smtpMessage=$g(^||ML("IN",$i(i))) if smtpMessage="" s err="smtpMessage" ztrap
		// načtu nastavení smtp
		s ret=$$gIdFa^MlJFapi(IdFa,systemDB,.aIn,.idfaParams)		
      	if +ret s err="Chyba ve fci gIdFa^MlJFapi ["_ret_"]"      	
		s smtpServer=$g(idfaParams("dta",27))
      	s smtpPort=+$g(idfaParams("dta",42))
      	s smtpUN=$g(idfaParams("dta",28))
      	s smtpPW=$g(idfaParams("dta",29))
      	s from=$g(idfaParams("dta",26))
      	s enableSsl=+$g(idfaParams("dta",43))	  
      	s smtpSSLConfiguration=$g(idfaParams("dta",63))	       	
      	if smtpFrom="" s smtpFrom=from  if smtpFrom="" s err="smtpFrom" ztrap
		// test
		k input,output
		s input("smtpServer")=smtpServer
		s input("smtpPort")=smtpPort
		s input("smtpUN")=smtpUN
		s input("smtpPW")=smtpPW
		s input("smtpMechanismList")=smtpMechanismList
		s input("smtpSSLConfiguration")=smtpSSLConfiguration
		s input("smtpFrom")=smtpFrom
		if smtpTo'="" for f=1:1:$l(smtpTo,";") s input("smtpTo",$i(input("smtpTo")))=$p(smtpTo,";",f)
		if smtpCC'="" for f=1:1:$l(smtpCC,";") s input("smtpCc",$i(input("smtpCc")))=$p(smtpCC,";",f)
		s input("smtpToSeparately")=smtpToSeparately
		s input("smtpSubject")=smtpSubject
		s input("smtpMessage")=smtpMessage
		s input("smtpIsBinary")=smtpIsBinary
		s input("smtpIsHTML")=smtpIsHTML		
		if smtpAttachFile'="" for f=1:1:$l(smtpAttachFile,";") s input("smtpAttachFile",$i(input("smtpAttachFile")))=$p(smtpAttachFile,";",f)	
		s sc=..Send(.input,.output) if $$$ISERR(sc) s err=$lg($g(output("smtpStatus")),1)_"; Info="_$lg($g(output("smtpStatus")),2) ztrap	
		// vystup
		s ^||ML("OUT",$i(o))="[ALL] Success="_+$lg($g(output("smtpStatus")),1)_"; Info="_$lg($g(output("smtpStatus")),2)
		s prijemceId=""
		for 
		{
			s prijemceId=$o(output("smtpStatus",prijemceId),1,prijemceVal) if prijemceId="" q
			s ^||ML("OUT",$i(o))="["_prijemceId_"] Success="_+$lg($g(prijemceVal),1)_"; Info="_$lg($g(prijemceVal),2)
		}
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

ClassMethod SendTestFromEdison(ByRef sys As %String) As %String
{
	// VSTUP:
	// ^||ML("IN",x)=smtpServer
	// ^||ML("IN",x)=smtpPort
	// ^||ML("IN",x)=smtpSSLConfiguration
	// ^||ML("IN",x)=smtpUN
	// ^||ML("IN",x)=smtpPW
	// ^||ML("IN",x)=smtpFrom
	// ^||ML("IN",x)=smtpTo (;)
	// ^||ML("IN",x)=smtpSubject
	// ^||ML("IN",x)=smtpAttachFile (;)
	// ^||ML("IN",x)=smtpMechanismList (,)
	// ^||ML("IN",x)=smtpIsHTML [0/1]
	// ^||ML("IN",x)=smtpIsBinary [0/1]
	// ^||ML("IN",x)=smtpToSeparately [0/1]
	// ^||ML("IN",x)=smtpMessage
	
	// VYSTUP:
	// ^||ML("OUT",n)=status
	
	s ret=$$$OK
	s err=""
	try {
		// vstup
		s smtpServer=$g(^||ML("IN",$i(i))) if smtpServer="" s err="smtpServer" ztrap
		s smtpPort=$g(^||ML("IN",$i(i))) if smtpPort="" s err="smtpPort" ztrap
		s smtpSSLConfiguration=$g(^||ML("IN",$i(i)))
		s smtpUN=$g(^||ML("IN",$i(i)))
		s smtpPW=$g(^||ML("IN",$i(i)))
		s smtpFrom=$g(^||ML("IN",$i(i))) if smtpFrom="" s err="smtpFrom" ztrap
		s smtpTo=$g(^||ML("IN",$i(i))) if smtpTo="" s err="smtpTo" ztrap
		s smtpSubject=$g(^||ML("IN",$i(i))) if smtpSubject="" s err="smtpSubject" ztrap
		s smtpAttachFile=$g(^||ML("IN",$i(i)))
		s smtpMechanismList=$g(^||ML("IN",$i(i)))
		s smtpIsHTML=+$g(^||ML("IN",$i(i)))
		s smtpIsBinary=+$g(^||ML("IN",$i(i)))
		s smtpToSeparately=+$g(^||ML("IN",$i(i)))
		s smtpMessage=$g(^||ML("IN",$i(i))) if smtpMessage="" s err="smtpMessage" ztrap
		// test
		k input,output
		s input("smtpServer")=smtpServer
		s input("smtpPort")=smtpPort
		s input("smtpUN")=smtpUN
		s input("smtpPW")=smtpPW
		s input("smtpMechanismList")=smtpMechanismList
		s input("smtpSSLConfiguration")=smtpSSLConfiguration
		s input("smtpFrom")=smtpFrom
		if smtpTo'="" for f=1:1:$l(smtpTo,";") s input("smtpTo",$i(input("smtpTo")))=$p(smtpTo,";",f)
		s input("smtpToSeparately")=smtpToSeparately
		s input("smtpSubject")=smtpSubject
		s input("smtpMessage")=smtpMessage
		s input("smtpIsBinary")=smtpIsBinary
		s input("smtpIsHTML")=smtpIsHTML
		if smtpAttachFile'="" for f=1:1:$l(smtpAttachFile,";") s input("smtpAttachFile",$i(input("smtpAttachFile")))=$p(smtpAttachFile,";",f)
		s sc=..Send(.input,.output) if $$$ISERR(sc) s err=$SYSTEM.Status.GetErrorText(sc) ztrap
		// vystup
		s ^||ML("OUT",$i(o))="[ALL] Success="_+$lg($g(output("smtpStatus")),1)_"; Info="_$lg($g(output("smtpStatus")),2)
		s prijemceId=""
		for {
			s prijemceId=$o(output("smtpStatus",prijemceId),1,prijemceVal) if prijemceId="" q
			s ^||ML("OUT",$i(o))="["_prijemceId_"] Success="_+$lg($g(prijemceVal),1)_"; Info="_$lg($g(prijemceVal),2)
		}
	}
	catch (ex) {
		s ret=err_ex.DisplayString()
		s ^||ML("ERR")=ret
	}
	q ret
}

ClassMethod SMTPNacistZFirmy(ByRef sys As %String) As %String
{
	// VSTUP:
	// ^||ML("IN",x)=firma
	
	// VYSTUP:
	// ^||ML("OUT",x)=server
	// ^||ML("OUT",x)=port
	// ^||ML("OUT",x)=jmeno
	// ^||ML("OUT",x)=heslo
	// ^||ML("OUT",x)=ssl [0/1]
	// ^||ML("OUT",x)=sslKonfigurace
	// ^||ML("OUT",x)=od
	
	s ret=$$$OK
	s err=""
	try {
		// vstup
		s firma=$g(^||ML("IN",$i(i))) if firma="" s err="firma" ztrap
		// firma
		k inputFirma,outputFirma
		s sc=$$isIdFa^MlJFapi(firma,"MLINE",.inputFirma,.outputFirma) if sc s err=sc ztrap
		if $g(outputFirma) {
			k inputFirma,outputFirma
			s sc=$$gIdFa^MlJFapi(firma,"MLINE",.inputFirma,.outputFirma) if sc s err=sc ztrap
		}
		// vystup
		s ^||ML("OUT",$i(o))=$g(outputFirma("dta",27))
		s ^||ML("OUT",$i(o))=+$g(outputFirma("dta",42))
		s ^||ML("OUT",$i(o))=$g(outputFirma("dta",28))
		s ^||ML("OUT",$i(o))=$g(outputFirma("dta",29))
		s ^||ML("OUT",$i(o))=+$g(outputFirma("dta",43))
		s ^||ML("OUT",$i(o))=$g(outputFirma("dta",63))
		s ^||ML("OUT",$i(o))=$g(outputFirma("dta",26))
	}
	catch (ex) {
		s ret=err_ex.DisplayString()
		s ^||ML("ERR")=ret
	}
	q ret
}

}
