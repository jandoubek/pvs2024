Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYCiselniky.Forms.formISYCiselnikyRozvrhPasemJizdniDobyEdit Extends %RegisteredObject
{

/// 
/// index do pracovniho globalu
/// 
ClassMethod CTMPGLBFRMIDX() As %String
{
	q $p($THIS,"ALVA.ISY.",2)
	//d ..%ClassName(0)
}

/// 
/// načte data 
/// 
ClassMethod Load(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		
		$$$FillParams		
		k $$$CTMPGLBFRM(GUID,..CTMPGLBFRMIDX())
				// načtu vstup	
		s idx ="" s ID=""
				f
				{
					s idx=$o(^||ML("IN",idx),1,radka) i idx="" q
						s list= $listfromstring(radka,del)
						i $lg(list,1)="ID" { s ID=($lg(list,2)) }          
				}
				//
				i ID 
				{			
			k arrDta d ##class(ALVA.ISY.ISYCiselniky.API.RozvrhPasemJizdniDoby).nacti(.sys,ID,.arrDta)
			s $$$CTMPGLBFRM(GUID,..CTMPGLBFRMIDX(),"ID")=ID
			m $$$CTMPGLBFRM(GUID,..CTMPGLBFRMIDX(),"DTA")=arrDta("DTA")
		}
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

/// 
/// Uložení okna po stisku OK
/// 
ClassMethod Save(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		//k ^["as"]kopec
		//m ^["as"]kopec=^||ML("IN")
		//m ^||ML("OUT")=output
		$$$FillParams
		s ID=$g($$$CTMPGLBFRM(GUID,..CTMPGLBFRMIDX(),"ID"))
		k arrDta m arrDta("DTA")=$$$CTMPGLBFRM(GUID,..CTMPGLBFRMIDX(),"DTA")
		d ##class(ALVA.ISY.ISYCiselniky.API.RozvrhPasemJizdniDoby).uloz(.sys,.ID,.arrDta)
		k $$$CTMPGLBFRM(GUID,..CTMPGLBFRMIDX()) k output
	}
	
	catch (ex) {$$$CatchErrRest}
	q ret
}

/// 
/// Init gridu (seznam zastávek)
/// 
ClassMethod InitFg(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{	
		$$$FillParams 
		// načtu vstup	
		s idx ="" s ID=""
				f
				{
					s idx=$o(^||ML("IN",idx),1,radka) i idx="" q
						s list= $listfromstring(radka,del)
						i $lg(list,1)="ID" { s ID=($lg(list,2)) }          
				}
						//
		 k output
		 s output($i(i))=$lts($lb("TITLE","Denní rozvrh časových pásem jízdních dob"),del) 
		 s output($i(i))=$lts($lb("ITEM","casHHMM","Čas","T","0"),del)  
		 s output($i(i))=$lts($lb("ITEM","pasmo","Pásmo jízdní doby","CBO","1"),del)     //pasmo nelze měnit id je na to navázána logika visualku !!!
		 k arrDta d ##class(ALVA.ISY.ISYCiselniky.API.CasovaPasmaJizdniDoby).seznam(.sys,.arrDta)
		 s cboItems=$lb("CBO","pasmo","-","")
		 s pasmoJizdniDobyId="" f {
			 s val="" s pasmoJizdniDobyId=$o(arrDta("DTA",pasmoJizdniDobyId),1,val) i pasmoJizdniDobyId="" q
			 s popis=$lg(val,1)
			 s $li(cboItems,$ll(cboItems)+1)=pasmoJizdniDobyId
			 s $li(cboItems,$ll(cboItems)+1)=popis
		 }
		 s output($i(i))=$lts(cboItems,del) 
		 m ^||ML("OUT")=output		 
	}
	catch (ex){$$$CatchErrRest}
	q ret
}

/// 
/// Načtu grid 
/// 
ClassMethod LoadFg(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		$$$FillParams	
		k arrDta d ##class(ALVA.ISY.ISYCiselniky.API.CasovaPasmaJizdniDoby).seznam(.sys,.arrDta)
		f min=0:30:1410 {
			s casHHMM=##class(ALVA.GENERALAPI.Time).MinToHHMM(min)
			s pasmoJizdniDobyId=$lg($g($$$CTMPGLBFRM(GUID,..CTMPGLBFRMIDX(),"DTA","rozvrh",min)),1)
			i pasmoJizdniDobyId="" s pasmoJizdniDobyId="-"
			i '$d(arrDta("DTA",pasmoJizdniDobyId)) s pasmoJizdniDobyId="-"
			s idRadku=min
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"casHHMM",casHHMM),del)
			s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("ITEM",idRadku,"pasmo",pasmoJizdniDobyId),del)
		}
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

/// 
/// Načtu grid 
/// 
ClassMethod ValidateFg(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		$$$FillParams	
		// načtu vstup	
		k arrDta s idx =""
				for
				{
					s idx=$o(^||ML("IN",idx),1,radka) i idx="" q
						s list= $listfromstring(radka,del)
						i $lg(list,1)="Row" {
							s min=$lg(list,2)
							s pasmoJizdniDobyId=$lg(list,3)
							i pasmoJizdniDobyId'="-" {
						s arrDta(min)=pasmoJizdniDobyId
							}
					}          
				}
		s vporadku=1 s chybaTxt=""
		i $g(arrDta(0))="" {
			s vporadku=0 s chybaTxt="Pásmo jízdní doby musí být nastaveno na počátku dne (v čase 0:00)!"
		}
		s ^||ML("OUT",$i(^||ML("OUT")))=$lts($lb("Val",vporadku,chybaTxt),del)
		// neni li chyba, ulozim data
		if (vporadku)
		{
			k $$$CTMPGLBFRM(GUID,..CTMPGLBFRMIDX(),"DTA","rozvrh")
			s min="" f {
				s pasmoJizdniDobyId="" s min=$o(arrDta(min),1,pasmoJizdniDobyId) i min="" q
				s $$$CTMPGLBFRM(GUID,..CTMPGLBFRMIDX(),"DTA","rozvrh",min)=$lb(pasmoJizdniDobyId)	
			}
		}
	}
	catch (ex) {$$$CatchErrRest}
	q ret
}

}
