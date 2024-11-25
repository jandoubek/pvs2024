Class User.Zastavky Extends %RegisteredObject
{

ClassMethod GetZastavkaName(ZastavkaId As %Integer) As %String
{
    ret:ZastavkaId="" "" 

    s ZastavkaInfo = $g(^JRZ(ZastavkaId))
    #; s ZastavkaNazev = $p(ZastavkaInfo,"$",2)_" "_$p(ZastavkaInfo,"$",3)
    s ZastavkaNazev = $p(ZastavkaInfo,"$",2)

    ret ZastavkaNazev
}

ClassMethod GetBodIdTrasy(SkupinaLinekId As %Integer, LinkaId As %String, ZastavkaId As %Integer) As %Integer
{
    s bodId = ""
    f {
        s bodId = $o(^JRSearch(SkupinaLinekId,LinkaId,"trasa","DTA",bodId)) q:bodId=""
        s bodInfo = $g(^JRSearch(SkupinaLinekId,LinkaId,"trasa","DTA",bodId))

        i ZastavkaId = $lg(bodInfo, 1) ret bodId
    }

    ret ""
}

ClassMethod NactiZastavky() As %Library.DynamicObject
{
    Kill sys
    Set sc = ##class(User.RestApi).GetSys(.sys)

    Kill arr
    Set arr("PAR","nactiGPS")=1

    Set result=[]
    Set uniqueIDs = ""

    Set SkupinaLinekId = ""
    For {
        Set SkupinaLinekId = $ORDER(^JRL(SkupinaLinekId)) Quit:SkupinaLinekId=""

        Set LinkaID = ""
        For {
            Set LinkaID = $ORDER(^JRL(SkupinaLinekId, LinkaID)) Quit:LinkaID=""

            Do ##class(ALVA.ISY.ISYLinky.API.LinkyTrasa).nacti(.sys,$LISTBUILD(SkupinaLinekId, "", LinkaID),"",.arr)

            Set BodTrasyID = ""
            For {
                Set BodTrasyID = $ORDER(arr("DTA", BodTrasyID)) Quit:BodTrasyID=""

                Set BodTrasyInfo = $GET(arr("DTA", BodTrasyID))
                Set ZastavkaID = $LISTGET(BodTrasyInfo, 1) continue:ZastavkaID=""

                If '$DATA(uniqueIDs(ZastavkaID))
                {
                    Set ZastavkaNazev=..GetZastavkaName(ZastavkaID)
                    
                    Do result.%Push({ 
                        "id": (ZastavkaID),
                        "label": (ZastavkaNazev)
                    })

                    Set uniqueIDs(ZastavkaID)=""
                }
            }
        }
    }
    
    Return result
}

}
