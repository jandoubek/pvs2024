Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYOmezeni.API.Obecne Extends %RegisteredObject
{

ClassMethod datumoveOmezeniText(ByRef sys As %String, ByRef arr As %String)
{
	//vygeneruje textovy popis pro datumove omezeni
	//IN
	//arr("PAR","dlouhodobeOmezeniId")=dlouhodobeOmezeniId
	//arr("PAR","datumoveOmezeni",omezeniId,hrlOd)=$lb(hrlDo)
	//kde omezeniId = 11 / jede jen ,12 / jede take ,13 /jede ,14 / jede v sudych tydnech ,15 / jede v lichych tydnech ,22 / nejede 
	//OUT
	//arr("DTA")=text
	$$$FillParams
	k arr("DTA") s arr("DTA")=""
	s dlouhodobeOmezeniId=$g(arr("PAR","dlouhodobeOmezeniId"))
	i dlouhodobeOmezeniId=4 s arr("DTA")="su"
	i dlouhodobeOmezeniId=5 s arr("DTA")="li" 
	s omezeniId="" f {
		s omezeniId=$o(arr("PAR","datumoveOmezeni",omezeniId)) i omezeniId="" q
		i arr("DTA")'="" s arr("DTA")=arr("DTA")_", "
		i omezeniId=11 s arr("DTA")=arr("DTA")_"jede jen "
		i omezeniId=12 s arr("DTA")=arr("DTA")_"jede také "
		i omezeniId=13 s arr("DTA")=arr("DTA")_"jede "
		i omezeniId=14 s arr("DTA")=arr("DTA")_"jede jen v su. "
		i omezeniId=15 s arr("DTA")=arr("DTA")_"jede jen v li. "
		i omezeniId=22 s arr("DTA")=arr("DTA")_"nejede "
		s omezeniHorlogOd="" f {
			s val="" s omezeniHorlogOd=$o(arr("PAR","datumoveOmezeni",omezeniId,omezeniHorlogOd),1,val) i omezeniHorlogOd="" q
			s omezeniHorlogDo=$lg(val,1)
			i omezeniHorlogOd=omezeniHorlogDo s omezeniHorlogDo=0
			i omezeniHorlogDo {
				s arr("DTA")=arr("DTA")_##class(ALVA.GENERALAPI.Date).horToDate(omezeniHorlogOd)_" - "_##class(ALVA.GENERALAPI.Date).horToDate(omezeniHorlogDo)_", "
			}
			else {
				s arr("DTA")=arr("DTA")_##class(ALVA.GENERALAPI.Date).horToDate(omezeniHorlogOd)_", "
			}
		}
		i $e(arr("DTA"),($l(arr("DTA"))-1),$l(arr("DTA")))=", " {s arr("DTA")=$e(arr("DTA"),1,$l(arr("DTA"))-2)}
	}
}

ClassMethod jsouTotozneDatumoveVety(ByRef arr As %String)
{
	//IN
	//arr("PAR","DV1")=prvni veta s tatumy
	//arr("PAR","DV2")=druha veta s datumy
	//OUT
	//arr("STT")=0/1 1=totozne
	s DT1=$g(arr("PAR","DV1"))
	s DT2=$g(arr("PAR","DV2"))
	//
	i (DT1=DT2) s arr("STT")=1 q
	i ($l(DT1,"#")'=$l(DT2,"#")) s arr("STT")=0 q
	//
	s arr("STT")=1
	f cnt=1:1:$l(DT1,"#") {
		i 'arr("STT") q
		s datumOd1=$p($p(DT1,"#",cnt),":",1)
		s datumDo1=$p($p(DT1,"#",cnt),":",2) i datumDo1="" s datumDo1=datumOd1
		s datumOd2=$p($p(DT2,"#",cnt),":",1)
		s datumDo2=$p($p(DT2,"#",cnt),":",2) i datumDo2="" s datumDo2=datumOd2
		i (##class(ALVA.GENERALAPI.Date).DateToHor(datumOd1)'=##class(ALVA.GENERALAPI.Date).DateToHor(datumOd2)) s arr("STT")=0
		i (##class(ALVA.GENERALAPI.Date).DateToHor(datumDo1)'=##class(ALVA.GENERALAPI.Date).DateToHor(datumDo2)) s arr("STT")=0
	}
}

}
