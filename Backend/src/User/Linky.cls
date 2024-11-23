Class User.Linky Extends %RegisteredObject
{

ClassMethod Test()
{
    // d ##class(User.Linky).Test()

    Kill sys
    Set sc = ##class(User.RestApi).GetSys(.sys)

    k ^||linky

    // Nacist linku
    k arr d ##class(ALVA.ISY.ISYLinky.API.Linky).nacti(.sys,$lb(6,"","0230009"),,.arr)
    s CisloDleLicence = $lg(arr("DTA"), 1)
    s CisloIds = $lg(arr("DTA"), 2)
    s CisloMhd = $lg(arr("DTA"), 3)
    s NazevLinky = $lg(arr("DTA"), 4)
    m ^||linky(6,"0230009")=arr

    // Nacist trasu linky
    k arrTrasa d ##class(ALVA.ISY.ISYLinky.API.LinkyTrasa).nacti(.sys,$lb(6,"","0230009"),"",.arrTrasa)
    m arr("trasa")=arrTrasa
    m ^||linky(6,"0230009","trasa")=arrTrasa

    // Pro kazdou zastavku nacte vsechny linky, ktere ji obsahuji
    s bodTrasyId=""
    f {
        s bodTrasyId=$o(arrTrasa("DTA",bodTrasyId)) q:bodTrasyId=""
        s bodTrasyInfo = $g(arrTrasa("DTA", bodTrasyId))
        s zastavkaId = $lg(bodTrasyInfo, 1) continue:zastavkaId=""

        s ^||linky("zastavky",zastavkaId,6,"0230009")=bodTrasyId
    }


    // Nacti spoje linky
    k arrSpoje d ##class(ALVA.ISY.ISYLinky.API.LinkySpoje).seznam(.sys,$lb(6,"","0230009"),"",.arrSpoje) 
    m arr("spoje")=arrSpoje
    m ^||linky(6,"0230009","spoje")=arrSpoje
    f smerSpojeId=0:1:1 {
        s spojId=""
        f {
            s spojId=$o(arrSpoje("DTA",smerSpojeId,spojId)) q:spojId=""

            k arrSpoj d ##class(ALVA.ISY.ISYLinky.API.LinkySpoje).nacti(.sys,$lb(6,"","0230009",smerSpojeId,spojId),"",.arrSpoj)
            m ^||linky(6,"0230009","spoje","DTA",smerSpojeId,spojId)=arrSpoj
        }
    }

    k ^jm m ^jm = ^||linky
}

ClassMethod NacistLinky()
{
    //
    // d ##class(User.Linky).NacistLinky()
    //
    // Nacte informace o lince, trasy a spojich do procesniho globalu
    //
    // ^||linky(skupinaId, linkaId)=$lb(...)                // obecne informace o lince
    // ^||linky(skupinaId, linkaId,"trasa")                 // body trasy linky
    // ^||linky(skupinaId, linkaId,"spoje")                 // seznam spoju linky
    // ^||linky(skupinaId, linkaId,"spoje",smerId,spojeID)  // detaily spoje linky
    // ^||linky(zastavkaId,skupinaId,linkaId)=bodTrasyId    // seznam linek obsahujici danou zastavku
    //

    Kill sys
    Set sc = ##class(User.RestApi).GetSys(.sys)

    k ^||linky

    s skupinaId = "" 
    f {
        s skupinaId = $o(^JRL(skupinaId)) q:skupinaId=""
        i '+skupinaId continue // Preskocit nenumericke indexy
        s linkaId = ""
        f {
            s linkaId = $o(^JRL(skupinaId,linkaId)) q:linkaId=""

            // Nacist linku
            k arr d ##class(ALVA.ISY.ISYLinky.API.Linky).nacti(.sys,$lb(skupinaId,"",linkaId),,.arr)
            m ^||linky(skupinaId,linkaId)=arr
            
            // Nacist trasu linky
            k arrTrasa d ##class(ALVA.ISY.ISYLinky.API.LinkyTrasa).nacti(.sys,$lb(skupinaId,"",linkaId),"",.arrTrasa)
            m ^||linky(skupinaId,linkaId,"trasa")=arrTrasa

            // Pro kazdou zastavku nacte vsechny linky, ktere ji obsahuji
            s bodTrasyId=""
            f {
                s bodTrasyId=$o(arrTrasa("DTA",bodTrasyId)) q:bodTrasyId=""
                s bodTrasyInfo = $g(arrTrasa("DTA", bodTrasyId))
                s zastavkaId = $lg(bodTrasyInfo, 1) continue:zastavkaId=""

                s ^||linky("zastavky",zastavkaId,skupinaId,linkaId)=bodTrasyId
            }

            // Nacti seznam spoju linky
            k arrSpoje d ##class(ALVA.ISY.ISYLinky.API.LinkySpoje).seznam(.sys,$lb(skupinaId,"",linkaId),"",.arrSpoje) 
            m ^||linky(skupinaId,linkaId,"spoje")=arrSpoje

            // Nacti detaily spoju
            f smerSpojeId=0:1:1 {
                s spojId = "" 
                f {
                    s spojId=$o(arrSpoje("DTA",smerSpojeId,spojId)) q:spojId=""

                    k arrSpoj d ##class(ALVA.ISY.ISYLinky.API.LinkySpoje).nacti(.sys,$lb(skupinaId,"",linkaId,smerSpojeId,spojId),"",.arrSpoj)
                    m ^||linky(skupinaId,linkaId,"spoje","DTA",smerSpojeId,spojId)=arrSpoj
                }
            }
        }
    }

    k ^jm m ^jm = ^||linky
}

ClassMethod NajdiSpojeBezPrestupu(zastavka1Id As %String, zastavka2Id As %String, min As %String) As %Library.DynamicObject
{
    // Nacti data do globalu
    #; d ##class(User.Linky).NacistLinky()
    d ##class(User.Linky).Test()

    #; d ##class(User.Linky).NajdiSpojeBezPrestupu(644,15060,600)
    #; d ##class(User.Linky).NajdiSpojeBezPrestupu(15060,644,600)

    s zastavka1Id = 644
    s zastavka2Id = 15060
    s min = 600 

    k arrZastavky1 m arrZastavky1=^||linky("zastavky",zastavka1Id)
    k arrZastavky2 m arrZastavky2=^||linky("zastavky",zastavka2Id)

    k ^jmTest 
    m ^jmTest("zastavky1")=arrZastavky1
    m ^jmTest("zastavky2")=arrZastavky2

    s bod1 = $g(^||linky("zastavky",zastavka1Id,6,"0230009"))
    s bod2 = $g(^||linky("zastavky",zastavka2Id,6,"0230009"))

    s smerId = $s(bod1 < bod2: 0,
                  bod1 > bod2: 1,
                  1: "")

    k resultSpoje

    s spojId=""
    f {
        s spojId=$o(^||linky(6,"0230009","spoje","DTA",smerId,spojId)) q:spojId=""

        s projizdiBod1 = $d(^||linky(6,"0230009","spoje","DTA",smerId,spojId,"DTA","trasa",bod1))
        s projizdiBod2 = $d(^||linky(6,"0230009","spoje","DTA",smerId,spojId,"DTA","trasa",bod2))

        s isValidVyjezd = $lg($g(^||linky(6,"0230009","spoje","DTA",smerId,spojId,"DTA","trasa",bod1)),1) > min

        i projizdiBod1 && projizdiBod2 && isValidVyjezd s resultSpoje(6,"0230009",spojId)=""
    }

    m ^jmTest("result")=resultSpoje

    s result = []
    s SkupinaLinekId = ""
    f {
        s SkupinaLinekId = $o(resultSpoje(SkupinaLinekId)) q:SkupinaLinekId=""
        s LinkaId = ""
        f {
            s LinkaId = $o(resultSpoje(SkupinaLinekId, LinkaId)) q:LinkaId=""
            s SpojId = ""
            f {
                s SpojId = $o(resultSpoje(SkupinaLinekId, LinkaId, SpojId)) q:SpojId=""

                s SmerId = SpojId+1 # 2
                s (vyjezd,vjezd) = ""

                s prvniBod = $o(^||linky(SkupinaLinekId,LinkaId,"spoje","DTA",SmerId,SpojId,"DTA","trasa",""))
                i prvniBod'="" s vyjezd = $lg($g(^||linky(SkupinaLinekId,LinkaId,"spoje","DTA",SmerId,SpojId,"DTA","trasa",prvniBod)),1)

                s posledniBod = $o(^||linky(SkupinaLinekId,LinkaId,"spoje","DTA",SmerId,SpojId,"DTA","trasa",""),-1)
                i posledniBod'="" s vjezd = $lg($g(^||linky(SkupinaLinekId,LinkaId,"spoje","DTA",SmerId,SpojId,"DTA","trasa",posledniBod)),1)

                d result.%Push({
                    "LinkaID": (LinkaId),
                    "SpojID": (SpojId),
                    "Vyjezd": (vyjezd),
                    "Vjezd": (vjezd)
                })
            }
        }
    }

    ret result
}

}
