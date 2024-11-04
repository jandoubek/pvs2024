Include (ALVALIBRARY, ALVAEDFORMS, GENERAL, ALVAISY)

Class ALVA.ISY.ISYZastavky.Forms.formISYZastavkyZastavkaImage [ Abstract ]
{

/// 
/// Load souboru
/// 
ClassMethod LoadSoubor(ByRef sys As %String, ByRef in As %String, ByRef out As %String) As %String
{
	$$$Init
	try 
	{		 
		$$$FillParams
		
		s id=^||ML("IN",1)
		s cis=$p(id,"~",1)
		s idfa=$p(id,"~",2)
		s key=$p(id,"~",3)
		
		m ^CacheTempMLSrvBytes(GUID)=^["MLINE"]ALVA.ISY.ZAS.SOUBORY("Cis",cis,"IdFa",idfa,"File",key,"RAW")
	}
	
	catch (ex) {
		$$$CatchErrRest
		}
	q ret
}

}
