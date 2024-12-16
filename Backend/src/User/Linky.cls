Class User.Linky Extends %RegisteredObject
{

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

    s SkupinaLinekId=$o(spolecneLinky("")) ret:SkupinaLinekId="" []
    s linkaId = $o(spolecneLinky(SkupinaLinekId,"")) 

    s bod1 = $g(^JRSearch("zastavky",zastavka1Id,SkupinaLinekId,linkaId))
    s bod2 = $g(^JRSearch("zastavky",zastavka2Id,SkupinaLinekId,linkaId))

    s smerId = $s(bod1 < bod2: 0,
                  bod1 > bod2: 1,
                  1: -1)

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
                    i SmerId = 0 s isActive = (prvniBod <= bodId) && (bodId <= posledniBod)
                    i SmerId = 1 s isActive = (prvniBod >= bodId) && (bodId >= posledniBod)

                    d trasa.%Push({
                        "place": (place),
                        "time": (casVBode),
                        "km": (km),
                        "isActive": (isActive)
                    })
                }

                s vzdalenostPrvniBod = $lg($g(^JRSearch(SkupinaLinekId,LinkaId,"spoje","DTA",SmerId,SpojId,"DTA","trasa",prvniBod)),3) \ 1000
                s vzdalenostPosledniBod = $lg($g(^JRSearch(SkupinaLinekId,LinkaId,"spoje","DTA",SmerId,SpojId,"DTA","trasa",posledniBod)),3) \ 1000
                s vzdalenost = vzdalenostPosledniBod - vzdalenostPrvniBod

                s dobaJizdy = prijezdMin-odjezdMin
                i smerId = 0 s pocetZastavek = posledniBod - prvniBod + 1
                i smerId = 1 s pocetZastavek = prvniBod - posledniBod + 1

                s dateEnglishFormat = $p(dateTime, " ", 1)
                s dateCzechFormat = $tr($zd($zdh(dateEnglishFormat, 3),4),"/",".")

                s directRoute = {
                    "Datum": (dateCzechFormat),
                    "ZeStanice": (nazevZastavky1),
                    "DoStanice": (nazevZastavky2),
                    "Odjezd": (odjezd),
                    "Prijezd": (prijezd),
                    "PrestupStanice": "",
                    "PrvniUsek": {
                        "ZeStanice": (nazevZastavky1),
                        "DoStanice": (nazevZastavky2),
                        "Odjezd": (odjezd),
                        "Prijezd": (prijezd),
                        "LinkaID": (LinkaId),
                        "SkupinaLinekId": (SkupinaLinekId),
                        "SpojID": (SpojId),
                        "Vzdalenost": (vzdalenost),
                        "Trasa": (trasa)
                    },
                    "DruhyUsek": "",
                    "CelkovaVzdalenost": (vzdalenost),
                    "CelkovaDobaJizdy": (dobaJizdy),
                    "PocetPrestupu": 0
                }

                d result.%Push(directRoute)
            }
        }
    }

    ret result
}

ClassMethod NajdiSpojeJedenPrestup(zastavka1Id As %String, zastavka2Id As %String, dateTime As %String) As %Library.DynamicObject
{
    // First check for direct routes
    s directRoutes = ..NajdiSpojeBezPrestupu(zastavka1Id, zastavka2Id, dateTime)
    
    // If direct routes exist, return them
    if directRoutes.%Size() > 0 {
        ret directRoutes
    }
    
    // Initial setup
    s min = ##class(User.Utils).ISO86012Min(dateTime)
    
    // First find all lines from start station
    k startLines
    s SkupinaLinekId = ""
    f {
        s SkupinaLinekId = $o(^JRSearch("zastavky",zastavka1Id,SkupinaLinekId)) q:SkupinaLinekId=""
        s linkaId = ""
        f {
            s linkaId = $o(^JRSearch("zastavky",zastavka1Id,SkupinaLinekId,linkaId)) q:linkaId=""
            s startLines(SkupinaLinekId,linkaId)=""
        }
    }
    
    // For each starting line, find potential transfer points
    k transferOptions
    s SkupinaLinekId = ""
    f {
        s SkupinaLinekId = $o(startLines(SkupinaLinekId)) q:SkupinaLinekId=""
        s linkaId = ""
        f {
            s linkaId = $o(startLines(SkupinaLinekId,linkaId)) q:linkaId=""
            
            // Get all stations on this line after the start station
            s bod = ##class(User.Zastavky).GetBodIdTrasy(SkupinaLinekId,linkaId,zastavka1Id)
            f {
                s bod = $o(^JRSearch(SkupinaLinekId,linkaId,"trasa","DTA",bod)) q:bod=""
                
                // Get station ID for this point
                s zastavkaId = $lg($g(^JRSearch(SkupinaLinekId,linkaId,"trasa","DTA",bod)),1)
                
                // Find lines from this station to destination
                d ..FindConnectingLines(zastavkaId, zastavka2Id, .transferOptions)
            }
        }
    }
    
    // Now find actual connections
    s resultSpoje = ##class(%Library.DynamicArray).%New()
    k uniqueDepartures  // Track best arrival for each departure time

    s transferStationId = ""
    f {
        s transferStationId = $o(transferOptions(transferStationId)) q:transferStationId=""
        
        // Get first leg options
        s firstLegRoutes = ..NajdiSpojeBezPrestupu(zastavka1Id, transferStationId, dateTime)
        
        // For each first leg
        f i=1:1:firstLegRoutes.%Size() {
            s firstLeg = firstLegRoutes.%Get(i-1)
            
            // Calculate arrival time + transfer buffer
            s arrivalMin = ##class(User.Utils).HHMM2Min(firstLeg.Prijezd) + 5  // 5 min transfer buffer
            s transferTime = ##class(User.Utils).Min2ISO8601(arrivalMin)
            
            // Get second leg options
            s secondLegRoutes = ..NajdiSpojeBezPrestupu(transferStationId, zastavka2Id, transferTime)
            
            // Track best second leg for this first leg
            s bestArrivalTime = 99999
            s bestSecondLeg = ""
            
            // Check all possible second legs
            f j=1:1:secondLegRoutes.%Size() {
                s secondLeg = secondLegRoutes.%Get(j-1)
                
                // Check if departure is before arrival
                s departureTime = ##class(User.Utils).HHMM2Min(firstLeg.Odjezd)
                s arrivalTime = ##class(User.Utils).HHMM2Min(secondLeg.Prijezd)
                
                i departureTime < arrivalTime {
                    // Validate transfer timing
                    s isValidTransfer = 0
                    s firstLegStations = firstLeg.PrvniUsek.Trasa
                    
                    f k=1:1:firstLegStations.%Size() {
                        s station = firstLegStations.%Get(k-1)
                        i station.place = secondLeg.ZeStanice {
                            s firstLegTransferTime = ##class(User.Utils).HHMM2Min(station.time)
                            s secondLegDepartureTime = ##class(User.Utils).HHMM2Min(secondLeg.Odjezd)
                            
                            i (firstLegTransferTime + 5) <= secondLegDepartureTime {
                                // If this arrival is earlier than current best for this departure time
                                i arrivalTime < bestArrivalTime {
                                    s bestArrivalTime = arrivalTime
                                    s bestSecondLeg = secondLeg
                                    s isValidTransfer = 1
                                }
                                q
                            }
                        }
                    }
                }
            }
            
            // If we found a valid combination for this departure time
            i bestSecondLeg'="" {
                // Check if we already have a better route for this departure time
                i '$d(uniqueDepartures(firstLeg.Odjezd)) || 
                   (bestArrivalTime < ##class(User.Utils).HHMM2Min(uniqueDepartures(firstLeg.Odjezd))) {
                    // Store the best arrival time for this departure
                    s uniqueDepartures(firstLeg.Odjezd) = bestSecondLeg.Prijezd

                    s dateEnglishFormat = $p(dateTime, " ", 1)
                    s dateCzechFormat = $tr($zd($zdh(dateEnglishFormat, 3),4),"/",".")
                    
                    // Create combined route using the new structure
                    s combinedRoute = {
                        "Datum": (dateCzechFormat),
                        "ZeStanice": (firstLeg.ZeStanice),
                        "DoStanice": (bestSecondLeg.DoStanice),
                        "Odjezd": (firstLeg.Odjezd),
                        "Prijezd": (bestSecondLeg.Prijezd),
                        "PrestupStanice": (bestSecondLeg.ZeStanice),
                        "PrvniUsek": {
                            "ZeStanice": (firstLeg.PrvniUsek.ZeStanice),
                            "DoStanice": (firstLeg.PrvniUsek.DoStanice),
                            "Odjezd": (firstLeg.PrvniUsek.Odjezd),
                            "Prijezd": (firstLeg.PrvniUsek.Prijezd),
                            "LinkaID": (firstLeg.PrvniUsek.LinkaID),
                            "SkupinaLinekId": (firstLeg.PrvniUsek.SkupinaLinekId),
                            "SpojID": (firstLeg.PrvniUsek.SpojID),
                            "Vzdalenost": (firstLeg.PrvniUsek.Vzdalenost),
                            "Trasa": (firstLeg.PrvniUsek.Trasa)
                        },
                        "DruhyUsek": {
                            "ZeStanice": (bestSecondLeg.PrvniUsek.ZeStanice),
                            "DoStanice": (bestSecondLeg.PrvniUsek.DoStanice),
                            "Odjezd": (bestSecondLeg.PrvniUsek.Odjezd),
                            "Prijezd": (bestSecondLeg.PrvniUsek.Prijezd),
                            "LinkaID": (bestSecondLeg.PrvniUsek.LinkaID),
                            "SkupinaLinekId": (bestSecondLeg.PrvniUsek.SkupinaLinekId),
                            "SpojID": (bestSecondLeg.PrvniUsek.SpojID),
                            "Vzdalenost": (bestSecondLeg.PrvniUsek.Vzdalenost),
                            "Trasa": (bestSecondLeg.PrvniUsek.Trasa)
                        },
                        "CelkovaVzdalenost": (firstLeg.PrvniUsek.Vzdalenost + bestSecondLeg.PrvniUsek.Vzdalenost),
                        "CelkovaDobaJizdy": (##class(User.Utils).HHMM2Min(bestSecondLeg.Prijezd) - ##class(User.Utils).HHMM2Min(firstLeg.Odjezd)),
                        "PocetPrestupu": 1
                    }
                    
                    // Remove any existing route with this departure time
                    f l=0:1:resultSpoje.%Size()-1 {
                        s existingRoute = resultSpoje.%Get(l)
                        i existingRoute.Odjezd = firstLeg.Odjezd {
                            d resultSpoje.%Remove(l)
                            q
                        }
                    }
                    
                    d resultSpoje.%Push(combinedRoute)
                }
            }
        }
    }
    
    ret resultSpoje
}

ClassMethod FindConnectingLines(zastavkaId As %String, destinationId As %String, ByRef transferOptions)
{
    s SkupinaLinekId = ""
    f {
        s SkupinaLinekId = $o(^JRSearch("zastavky",zastavkaId,SkupinaLinekId)) q:SkupinaLinekId=""
        s linkaId = ""
        f {
            s linkaId = $o(^JRSearch("zastavky",zastavkaId,SkupinaLinekId,linkaId)) q:linkaId=""
            
            // Check if this line reaches destination
            i $d(^JRSearch("zastavky",destinationId,SkupinaLinekId,linkaId)) {
                s transferOptions(zastavkaId,SkupinaLinekId,linkaId)=""
            }
        }
    }
}

ClassMethod CombineRoutes(firstLeg As %DynamicObject, secondLeg As %DynamicObject) As %DynamicObject
{
    // Get transfer station name for reference
    s transferStation = secondLeg.ZeStanice
    
    // Mark stations in first leg as active if they're between source and transfer
    s firstLegTrasa = firstLeg.Trasa
    s foundStart = 0
    s newFirstLegTrasa = ##class(%Library.DynamicArray).%New()
    
    f i=1:1:firstLegTrasa.%Size() {
        s station = firstLegTrasa.%Get(i-1)
        
        // Start marking as active once we find source station
        i station.place = firstLeg.ZeStanice s foundStart = 1
        
        // Create new station object with isActive flag
        s newStation = {
            "place": (station.place),
            "time": (station.time),
            "km": (station.km),
            "isActive": (foundStart)
        }
        
        // Stop marking as active after transfer station
        i station.place = transferStation s foundStart = 0
        
        d newFirstLegTrasa.%Push(newStation)
    }
    
    // Mark stations in second leg as active if they're between transfer and destination
    s secondLegTrasa = secondLeg.Trasa
    s foundTransfer = 0
    s newSecondLegTrasa = ##class(%Library.DynamicArray).%New()
    
    f i=1:1:secondLegTrasa.%Size() {
        s station = secondLegTrasa.%Get(i-1)
        
        // Start marking as active once we find transfer station
        i station.place = transferStation s foundTransfer = 1
        
        // Create new station object with isActive flag
        s newStation = {
            "place": (station.place),
            "time": (station.time),
            "km": (station.km),
            "isActive": (foundTransfer)
        }
        
        // Stop marking as active after destination
        i station.place = secondLeg.DoStanice s foundTransfer = 0
        
        d newSecondLegTrasa.%Push(newStation)
    }
    
    // Create modified legs with the new trasa arrays
    s newFirstLeg = {
        "ZeStanice": (firstLeg.ZeStanice),
        "DoStanice": (firstLeg.DoStanice),
        "Odjezd": (firstLeg.Odjezd),
        "Prijezd": (firstLeg.Prijezd),
        "LinkaID": (firstLeg.LinkaID),
        "SkupinaLinekId": (firstLeg.SkupinaLinekId),
        "SpojID": (firstLeg.SpojID),
        "Vzdalenost": (firstLeg.Vzdalenost),
        "Trasa": (newFirstLegTrasa)
    }
    
    s newSecondLeg = {
        "ZeStanice": (secondLeg.ZeStanice),
        "DoStanice": (secondLeg.DoStanice),
        "Odjezd": (secondLeg.Odjezd),
        "Prijezd": (secondLeg.Prijezd),
        "LinkaID": (secondLeg.LinkaID),
        "SkupinaLinekId": (secondLeg.SkupinaLinekId),
        "SpojID": (secondLeg.SpojID),
        "Vzdalenost": (secondLeg.Vzdalenost),
        "Trasa": (newSecondLegTrasa)
    }
    
    // Create new combined route object
    s combined = {
        "ZeStanice": (firstLeg.ZeStanice),
        "DoStanice": (secondLeg.DoStanice),
        "Odjezd": (firstLeg.Odjezd),
        "Prijezd": (secondLeg.Prijezd),
        "PrestupStanice": (transferStation),
        "PrvniUsek": (newFirstLeg),
        "DruhyUsek": (newSecondLeg),
        "CelkovaVzdalenost": (firstLeg.Vzdalenost + secondLeg.Vzdalenost),
        "CelkovaDobaJizdy": (30),
        "PocetPrestupu": 1
    }
    q combined
}

}
