Class ALVA.GENERALAPI.FIRMA.EKOS Extends %RegisteredObject
{

/// 
/// vrátí zda je aktivní účetnicví ekos
/// 
ClassMethod isActiv(ByRef IdFa As %String) As %String
{
	//w ##class(ALVA.GENERALAPI.FIRMA.EKOS).isEkosActiv("SM_CSAD")
	s vystup = 0
	s dataDB = ##class(ALVA.GENERALAPI.FIRMA.Function).dataDB(IdFa)
 	s in("IdFa")=IdFa
 	s output= $$LoadNastav^ALVAESfnastav(.in,.o)
	if ($g(o("Dta","ExtAgd","Set"))="MLINE"){s vystup=1}
	q vystup
}

}
