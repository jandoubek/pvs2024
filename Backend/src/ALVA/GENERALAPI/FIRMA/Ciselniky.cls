Include (ALVAEDFORMS, ALVAEDREPORTS)

Class ALVA.GENERALAPI.FIRMA.Ciselniky Extends %RegisteredObject
{

/*
ciselnik spolecne - funkce exist
VSTUP:	in("id")
		in("Codebook")	id ciselniku
VYSTUP:	
	out("exists")	=	1 existuje
	out("exists")	=	0 neexistuje
	out("id")		id polozky
*/
ClassMethod ItemExists(ByRef in As %String, ByRef out As %String) As %String
{
	k out
	s sc=$$$OK
	s sysbase=##class(ALVA.EDISON.Main).GetSystemDB()
	S id=$G(in("id")),Codebook=$LG(in("Codebook"))
	//
	//ciselnik bankovnich kodu
	If Codebook=$$$CodebookTypeBanky {
		If id="" { s out("exists")=0 }
		Else {
			s veta=$G(^[sysbase]MlId("IdFa","is*mline","Cis","-","Banky","Dta",+id))
			If veta="" { s out("exists")=0	}
			Else {
				s out("exists")=1,out("id")=$P(veta,"~")
			}
		}
	}
 	q sc
}

/*
ciselnik spolecne - funkce nacti polozku
VSTUP:	in("id")
		in("Codebook")	id ciselniku
VYSTUP:	
	
	out("data","item")	$lb(id,nazev)
*/
ClassMethod LoadItem(ByRef in As %String, ByRef out As %String) As %String
{
	k out
	s sc=$$$OK
	s sysbase=##class(ALVA.EDISON.Main).GetSystemDB()
	S id=$G(in("id")),Codebook=$LG(in("Codebook"))
	//
	//ciselnik bankovnich kodu
	If Codebook=$$$CodebookTypeBanky {
		If id="" s sc=$$$ERROR($$$GeneralError,"Chybí ID položky") $$$ThrowOnError(sc)
		s veta=$G(^[sysbase]MlId("IdFa","is*mline","Cis","-","Banky","Dta",+id))
		s out("data","item")=$lb($P(veta,"~"),$P(veta,"~"))		//vzdy normalizovany tvar
	}
 	q sc
}

/*
ciselnik spolecne - funkce seznam
VSTUP:	in("Codebook")	id ciselniku
VYSTUP:	out("data","item",item)	$lb(id,nazev)
*/
ClassMethod List(ByRef in As %String, ByRef out As %String) As %String
{
	k out
	s sc=$$$OK
	s sysbase=##class(ALVA.EDISON.Main).GetSystemDB()
	S Codebook=$LG(in("Codebook"))
	//
	//ciselnik bankovnich kodu
	If Codebook=$$$CodebookTypeBanky {
		S id="" For {
			s id=$O(^[sysbase]MlId("IdFa","is*mline","Cis","-","Banky","Dta",id)) Q:id=""  s veta=$G(^(id))
			s out("data","item",id)=$lb($P(veta,"~"),$P(veta,"~",2))
		}
	}
 	q sc
}

}
