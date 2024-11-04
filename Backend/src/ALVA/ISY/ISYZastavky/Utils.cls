Include (ALVALIBRARY, ALVAEDFORMS, GENERAL)

Class ALVA.ISY.ISYZastavky.Utils Extends %RegisteredObject
{

ClassMethod GetCiselniky(ByRef sys As %String, inGLB As %String, outGLB As %String) As %Status
{
	// VSTUP:
	// inGLB(typ,ciselnik)=$lb($lb(pridanePolozky),hodnota[0=klic/1=hodnotaPodleOddelovaceAPoradi],oddelovac,poradi)
	// inGLB(typ,ciselnik,"input")=input
	// inGLB(typ,ciselnik,"params")=params
	// ... kde typ = [Temp/Cis/Codebook/Local]
	
	// VYSTUP:
	// outGLB(typ,ciselnik,key)=val
	// ... kde typ = [Temp/Cis/Codebook/Local]

	s ret=$$$OK
	s err=""
	try {
        // TODO osetrit errory
		//if inGLB="" $$$ERROR("inGLB",err)
		// if outGLB="" $$$ERROR("outGLB",err)
		// ciselniky
		s typ=""
		for {
			s typ=$o(@inGLB@(typ)) if typ="" q
			s cis=""
			for {
				s cis=$o(@inGLB@(typ,cis),1,lb) if cis="" q
				// init
				k inputCis,outputCis m inputCis=@inGLB@(typ,cis,"input")
				// ================================================================================
				if cis="Sablony" {
						s sc=##class(ALVA.ISY.ISYZastavky.Utils).SeznamSablon(.sys,.inputCis,.outputCis) //$$$THROWERROR(sc,err)
						s arrId=""
						for {
							s arrId=$o(outputCis("arr",1,arrId),1,arrVal) if arrId="" q
							s @outGLB@(typ,cis,$p(arrVal,"~",1))=$p(arrVal,"~",2)
						}
					}
			}
            // ================================================================================
            // temp
            s lbTemp=$li(lb,1) for f=1:1:$ll(lbTemp) s add=$lg(lbTemp,f) if add'="" s @outGLB@(typ,cis,$p(add,"|",1))=$p(add,"|",2)
            // kill
            s killId=""
            for {
                s killId=$o(@inGLB@(typ,cis,"kill",killId)) if killId="" q
                k @outGLB@(typ,cis,killId)
            }
            // upravy
            s key=""
            for {
                s key=$o(@outGLB@(typ,cis,key)) if key="" q
                if $li(lb,2)=$$$NO { s @outGLB@(typ,cis,key)="" }
                else { s deli=$lg(lb,3),poradi=+$lg(lb,4) if (deli'="")&&(poradi) s @outGLB@(typ,cis,key)=$p(@outGLB@(typ,cis,key),deli,poradi) }
            }
		}
	}
    catch (ex) {$$$CatchErrRest}
	quit ret
}

ClassMethod BigDataLoad(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %Status
{
	// VSTUP:
	// in("classname")=nazev tridy !
	// in("login")=uzivatel
	// in("big")=big
	
	// VYSTUP:
	// out(itemId)=values
	
	s ret=$$$OK
	s err=""
	try {
        $$$FillParams
		// init
		#dim values As %ListOfObjects
		#dim value As ALVA.EDFORMS.CONTROLS.BIG.ItemValue
		// vstup
		s classname=$g(in("classname")) //if classname="" $$$ERROR("classname",err)
		s login=$g(in("login")) if login="" s login="<ALL>"
		s big=$g(in("big")) if big="" s big="<MAIN>"
		// load
		s itemId=""
		for {
			s itemId=$o(^[$g(sys("U","DATA"),$g(^||ML("SYS","U","DATA"),"USER"))]ALVA.ISY.Zastavky(IdFa,"class",classname,"users",login,"big",big,itemId)) if itemId="" q
			s values=##class(%ListOfObjects).%New()
			s val=""
			for {
				s val=$o(^[$g(sys("U","DATA"),$g(^||ML("SYS","U","DATA"),"USER"))]ALVA.ISY.Zastavky(IdFa,"class",classname,"users",login,"big",big,itemId,val),1,lbVal) if val="" q
				s value=##class(ALVA.EDFORMS.CONTROLS.BIG.ItemValue).%New()
				s value.Data=$lg(lbVal,1)
				s value.Name=$lg(lbVal,2)
				s value.Key=$lg(lbVal,3)
				d values.Insert(value)
			}
			s out(itemId)=values
		}
	}
	catch (ex) {$$$CatchErrRest}
	quit ret
}

ClassMethod SeznamSablon(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	// VSTUP:
	//in("id")=SadaID
	// VYSTUP:
 	//out("arr",1,cnt)=SablonaID_"~"_SablonaNazev
    $$$FillParams
	s ret=$$$OK
	s err=""
	k out
	try {
		k myin,myout
		s myin("par",1)=$g(in("id"))
		s err=##class(ALVA.ISY.ISYZastavky.Reportgen.API).GetSeznamRGSablon(.sys,.myin,.myout) i +err zt
		m out=myout
	}
	catch (ex) {$$$CatchErrRest}
	quit ret
}

ClassMethod BigAddListItems(ByRef item As ALVA.EDFORMS.CONTROLS.BIG.Item, cis As %String) As %Status
{
	s ret=$$$OK
	s err=""
	try {
		d item.ListItems.Clear()
		if $d(@cis@($c(9))) {
			s listId="" s listVal=@cis@($c(9))
			if listId'=$c(9) {
				if (listVal'="")&&($lv(listVal)) { d item.AddListItem($li(listVal,2),$li(listVal,1)) }
				else { d item.AddListItem(listId_$case(listVal,"":"",:" | "_listVal),listId) }
			}
		}
		s listId=""
		for {
			s listId=$o(@cis@(listId),1,listVal) if listId="" q
			if listId'=$c(9) {
				if (listVal'="")&&($lv(listVal)) { d item.AddListItem($li(listVal,2),$li(listVal,1)) }
				else { d item.AddListItem(listId_$case(listVal,"":"",:" | "_listVal),listId) }
			}
		}
	}
	catch (ex) {$$$CatchErrRest}
	quit ret
}

ClassMethod BigDataSave(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %Status
{
	// VSTUP:
	// in("classname")=trida !
	// in("login")=uzivatel
	// in("big")=big
	// in("items")=polozky bigu
	
	// VYSTUP:
	
	s ret=$$$OK
	s err=""
	try {
        
        $$$FillParams
		// init
		#dim items As %ListOfObjects
		#dim item As ALVA.EDFORMS.CONTROLS.BIG.Item
		#dim value As ALVA.EDFORMS.CONTROLS.BIG.ItemValue
		// vstup
		s classname=$g(in("classname")) //if classname="" $$$THROWERROR("classname",err)
		s login=$g(in("login")) if login="" s login="<ALL>"
		s big=$g(in("big")) if big="" s big="<MAIN>"
		s items=$g(in("items"))
		// save
		k save
		s key=""
		for {
			s item=items.GetNext(.key) if key="" q
			s val=""
			for {
				s value=item.Values.GetNext(.val) if val="" q
				s save(item.Id,val)=$lb(value.Data,value.Name,value.Key)
			}
		}
		k ^[$g(sys("U","DATA"),$g(^||ML("SYS","U","DATA"),"USER"))]ALVA.ISY.Zastavky(IdFa,"class",classname,"users",login,"big",big)
		m ^[$g(sys("U","DATA"),$g(^||ML("SYS","U","DATA"),"USER"))]ALVA.ISY.Zastavky(IdFa,"class",classname,"users",login,"big",big)=save
	}
	catch (ex) {$$$CatchErrRest}
	quit ret
}

}
