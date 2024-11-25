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
    k ^JRSearch

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
            m ^JRSearch(skupinaId,linkaId)=arr
            
            // Nacist trasu linky
            k arrTrasa d ##class(ALVA.ISY.ISYLinky.API.LinkyTrasa).nacti(.sys,$lb(skupinaId,"",linkaId),"",.arrTrasa)
            m ^||linky(skupinaId,linkaId,"trasa")=arrTrasa
            m ^JRSearch(skupinaId,linkaId,"trasa")=arrTrasa

            // Pro kazdou zastavku nacte vsechny linky, ktere ji obsahuji
            s bodTrasyId=""
            f {
                s bodTrasyId=$o(arrTrasa("DTA",bodTrasyId)) q:bodTrasyId=""
                s bodTrasyInfo = $g(arrTrasa("DTA", bodTrasyId))
                s zastavkaId = $lg(bodTrasyInfo, 1) continue:zastavkaId=""

                s ^||linky("zastavky",zastavkaId,skupinaId,linkaId)=bodTrasyId
                s ^JRSearch("zastavky",zastavkaId,skupinaId,linkaId)=bodTrasyId
            }

            // Nacti seznam spoju linky
            k arrSpoje d ##class(ALVA.ISY.ISYLinky.API.LinkySpoje).seznam(.sys,$lb(skupinaId,"",linkaId),"",.arrSpoje) 
            m ^||linky(skupinaId,linkaId,"spoje")=arrSpoje
            m ^JRSearch(skupinaId,linkaId,"spoje")=arrSpoje

            // Nacti detaily spoju
            f smerSpojeId=0:1:1 {
                s spojId = "" 
                f {
                    s spojId=$o(arrSpoje("DTA",smerSpojeId,spojId)) q:spojId=""

                    k arrSpoj d ##class(ALVA.ISY.ISYLinky.API.LinkySpoje).nacti(.sys,$lb(skupinaId,"",linkaId,smerSpojeId,spojId),"",.arrSpoj)
                    m ^||linky(skupinaId,linkaId,"spoje","DTA",smerSpojeId,spojId)=arrSpoj
                    m ^JRSearch(skupinaId,linkaId,"spoje","DTA",smerSpojeId,spojId)=arrSpoj
                }
            }
        }
    }
}

ClassMethod NajdiSpojeBezPrestupu(zastavka1Id As %String, zastavka2Id As %String, dateTime As %String) As %Library.DynamicObject
{
    #; d ##class(User.Linky).NajdiSpojeBezPrestupu(644,15060,600)
    #; d ##class(User.Linky).NajdiSpojeBezPrestupu(15060,644,600)

    s nazevZastavky1 = ##class(User.Zastavky).GetZastavkaName(zastavka1Id)
    s nazevZastavky2 = ##class(User.Zastavky).GetZastavkaName(zastavka2Id)

    s min = ##class(User.Utils).ISO86012Min(dateTime) 

    k arrZastavky1 m arrZastavky1=^JRSearch("zastavky",zastavka1Id)
    k arrZastavky2 m arrZastavky2=^JRSearch("zastavky",zastavka2Id)

    k ^jmTest 
    m ^jmTest("zastavky1")=arrZastavky1
    m ^jmTest("zastavky2")=arrZastavky2

    // Najit linky, na kterych jsou obe zastavky
    k spolecneLinky
    
    s SkupinaLinekId = ""
    f {
        s SkupinaLinekId = $o(^JRSearch("zastavky",zastavka1Id,SkupinaLinekId)) q:SkupinaLinekId=""
        
        s linkaId = ""
        f {
            s linkaId = $o(^JRSearch("zastavky",zastavka1Id,SkupinaLinekId,linkaId)) q:linkaId=""
            
            i $d(^JRSearch("zastavky",zastavka2Id,SkupinaLinekId,linkaId)) {
                s spolecneLinky(SkupinaLinekId,linkaId)=""
            }
        }
    }

    s SkupinaLinekId=$o(spolecneLinky("")) ret:SkupinaLinekId="" {}
    s linkaId = $o(spolecneLinky(SkupinaLinekId,"")) 

    s bod1 = $g(^JRSearch("zastavky",zastavka1Id,SkupinaLinekId,linkaId))
    s bod2 = $g(^JRSearch("zastavky",zastavka2Id,SkupinaLinekId,linkaId))

    s smerId = $s(bod1 < bod2: 0,
                  bod1 > bod2: 1,
                  1: "")

    k resultSpoje

    s spojId=""
    f {
        s spojId=$o(^JRSearch(SkupinaLinekId,linkaId,"spoje","DTA",smerId,spojId)) q:spojId=""

        s projizdiBod1 = $d(^JRSearch(SkupinaLinekId,linkaId,"spoje","DTA",smerId,spojId,"DTA","trasa",bod1))
        s projizdiBod2 = $d(^JRSearch(SkupinaLinekId,linkaId,"spoje","DTA",smerId,spojId,"DTA","trasa",bod2))

        s isValidVyjezd = $lg($g(^JRSearch(SkupinaLinekId,linkaId,"spoje","DTA",smerId,spojId,"DTA","trasa",bod1)),1) > min

        i projizdiBod1 && projizdiBod2 && isValidVyjezd s resultSpoje(SkupinaLinekId,linkaId,spojId)=""
    }

    // Vratim spoje serezene podle casu vyjezdy
    k tempArray
    
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
                s (odjezdMin,prijezdMin) = ""

                s prvniBod = ##class(User.Zastavky).GetBodIdTrasy(SkupinaLinekId,LinkaId,zastavka1Id)
                i prvniBod'="" s odjezdMin = $lg($g(^JRSearch(SkupinaLinekId,LinkaId,"spoje","DTA",SmerId,SpojId,"DTA","trasa",prvniBod)),1)

                s posledniBod = ##class(User.Zastavky).GetBodIdTrasy(SkupinaLinekId,LinkaId,zastavka2Id)
                i posledniBod'="" s prijezdMin = $lg($g(^JRSearch(SkupinaLinekId,LinkaId,"spoje","DTA",SmerId,SpojId,"DTA","trasa",posledniBod)),1)

                s odjezd = ##class(User.Utils).Min2hhmm(odjezdMin)
                s prijezd = ##class(User.Utils).Min2hhmm(prijezdMin)

                s trasa = []
                s bodId = ""
                f {
                    s bodId = $o(^JRSearch(SkupinaLinekId,LinkaId,"spoje","DTA",SmerId,SpojId,"DTA","trasa",bodId)) q:bodId=""
                    s bodInfo = $g(^JRSearch(SkupinaLinekId,LinkaId,"spoje","DTA",SmerId,SpojId,"DTA","trasa",bodId))
                    s casVBode = ##class(User.Utils).Min2hhmm($lg(bodInfo, 1))
                    s km = $lg(bodInfo, 3) \ 1000
                    s placeId = $lg($g(^JRSearch(SkupinaLinekId,LinkaId,"trasa","DTA",bodId)),1)
                    s place = ##class(User.Zastavky).GetZastavkaName(placeId)
                    i SmerId = 0 s inRoute = (prvniBod <= bodId) && (bodId <= posledniBod)
                    i SmerId = 1 s inRoute = (prvniBod >= bodId) && (bodId >= posledniBod)

                    d trasa.%Push({
                        "place": (place),
                        "time": (casVBode),
                        "km": (km),
                        "inRoute": (inRoute)
                    })
                }

                s vzdalenostPrvniBod = $lg($g(^JRSearch(SkupinaLinekId,LinkaId,"spoje","DTA",SmerId,SpojId,"DTA","trasa",prvniBod)),3) \ 1000
                s vzdalenostPosledniBod = $lg($g(^JRSearch(SkupinaLinekId,LinkaId,"spoje","DTA",SmerId,SpojId,"DTA","trasa",posledniBod)),3) \ 1000
                s vzdalenost = vzdalenostPosledniBod - vzdalenostPrvniBod

                s dobaJizdy = prijezdMin-odjezdMin
                i smerId = 0 s pocetZastavek = posledniBod - prvniBod + 1
                i smerId = 1 s pocetZastavek = prvniBod - posledniBod + 1

                // Store in temporary array with odjezdMin as key
                // Use $j to pad odjezdMin for proper sorting and add a counter to handle duplicate times
                s counter = $i(tempArray(odjezdMin))
                s tempArray(odjezdMin,counter) = {
                    "SkupinaLinekId": (SkupinaLinekId),
                    "LinkaID": (LinkaId),
                    "SpojID": (SpojId),
                    "ZeStanice": (nazevZastavky1),
                    "DoStanice": (nazevZastavky2),
                    "Odjezd": (odjezd),
                    "Prijezd": (prijezd),
                    "Trasa": (trasa),
                    "Vzdalenost": (vzdalenost),
                    "DobaJizdy": (dobaJizdy),
                    "PocetZastavek": (pocetZastavek)
                }
            }
        }
    }

    s result = []
    s odjezdMin = ""
    f {
        s odjezdMin = $o(tempArray(odjezdMin)) q:odjezdMin=""
        s counter = ""
        f {
            s counter = $o(tempArray(odjezdMin,counter)) q:counter=""
            d result.%Push(tempArray(odjezdMin,counter))
        }
    }

    ret result
}

}
