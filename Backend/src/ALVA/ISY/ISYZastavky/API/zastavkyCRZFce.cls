Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYZastavky.API.zastavkyCRZFce Extends %RegisteredObject
{

ClassMethod prevodCRZDoZastavky(ByRef sys As %String, id As %String, ByRef arr As %String)
{
	//prevod zastavek z CRZ do databaze zastavek
	//
	//IN
	//
	// id=$lb(zastavkaCRZId,zastavkaCRZId,zastavkaCRZId...)
	//
	//OUT
	// arr("DTA")=$lb(pocetZastavek,pocetJizEvidovanych,pocetNovePrevedenych)
	//
	$$$FillParams
	$$$TMPGLBSET(tmpglb)
	s id=$g(id) k arr("DTA") s arr("DTA")=$lb($ll(id),"","")
	// z aktualni databaze si pripravim seznam pro sjednoceni zastavek
	s zastavkaId="" f  {
		s valDB="" s zastavkaId=$o(^[dataDB]JRZ(zastavkaId),1,valDB) i zastavkaId="" q
		s tmp=$p(valDB,"$",2) s obec=$p(tmp,",",1) s castObce=$p(tmp,",",2) s lokalita=$p(tmp,",",3)	
		s blizkaObec=$p(valDB,"$",3)
		s zastavkaCRZId=$p(valDB,"$",9)
		s idx=obec_castObce_lokalita_blizkaObec
      	i idx'="" s @tmpglb@(1,idx)=zastavkaId
      	i zastavkaCRZId'="" s @tmpglb@(2,zastavkaCRZId)=zastavkaId
    }
    //prevod zastavek do databaze
    f cnt=1:1:$ll(id) {
	    s zastavkaCRZId=$lg(id,cnt) i zastavkaCRZId="" continue
	    k arrDta d ##class(ALVA.ISY.ISYZastavky.API.ZastavkyCRZ).nacti(.sys,zastavkaCRZId,.arrDta)
	    s val=$g(arrDta("DTA"))
	    s obec=$lg(val,1) s castObce=$lg(val,2) s lokalita=$lg(val,3) s blizkaObec=$lg(val,4)
	    s idx=obec_castObce_lokalita_blizkaObec
	    i idx="" continue
	    //zastavka podle nazvu jiz zavedena
	    i $d(@tmpglb@(1,idx)) s $li(arr("DTA"),2)=$lg(arr("DTA"),2)+1 continue
	    //zastavka je podle cisla jiz zavedena
	    i $d(@tmpglb@(2,zastavkaCRZId)) s $li(arr("DTA"),2)=$lg(arr("DTA"),2)+1 continue
	    //zastavku zavedu do databaze
	    //zkusim to pod zastavkaCRZId
	    s zastavkaId="" 
	    k arrDta d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).existuje(.sys,zastavkaCRZId,.arrDta)
	    i '$g(arrDta("STT")) s zastavkaId=zastavkaCRZId
		//vlastni zapis
	    k arrDta s arrDta("DTA")=$lb(obec,castObce,lokalita,blizkaObec)
	    d ##class(ALVA.ISY.ISYZastavky.API.Zastavky).uloz(.sys,.zastavkaId,"",.arrDta)
	    i zastavkaId {
		    s @tmpglb@(1,idx)=zastavkaId
		    s @tmpglb@(2,zastavkaCRZId)=zastavkaId
	    }
	    s $li(arr("DTA"),3)=$lg(arr("DTA"),3)+1 continue
    }
	k @tmpglb
}

ClassMethod getIdZastavky(ByRef sys As %String, zastavkaCRZId As %String, ByRef arr As %String)
{
	// vrati interni id zastavky na zaklade CRZId
	//
	//IN
	// zastavkaCRZId
	//
	//OUT
	// 
	// arr("DTA")=$lb(zastavkaId)
	// 
	$$$FillParams
	k arr("DTA")
	s zastavkaId="" f  {
		s valDB="" s zastavkaId=$o(^[dataDB]JRZ(zastavkaId),1,valDB) i zastavkaId="" q
		s valZastavkaCRZId=$p(valDB,"$",9)
		i valZastavkaCRZId = zastavkaCRZId {
			s arr("DTA") = $lb(zastavkaId)
			ret
		}
    }
}

ClassMethod seznamZastavkaCRZId(ByRef sys As %String, ByRef arr As %String)
{
	// vrati pole zastavek arr("DTA",zastavkaCRZId,zastavkaId)=""
	//
	//IN
	//
	//OUT
	// 
	// arr("DTA",zastavkaCRZId,zastavkaId)=""
	//
	$$$FillParams
	k arr("DTA")
	s zastavkaId="" f  {
		s valDB="" s zastavkaId=$o(^[dataDB]JRZ(zastavkaId),1,valDB) i zastavkaId="" q
		s valZastavkaCRZId=$p(valDB,"$",9)
		i valZastavkaCRZId'="" s arr("DTA",valZastavkaCRZId,zastavkaId)=""
    }
}

}
