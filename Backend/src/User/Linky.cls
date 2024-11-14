Class User.Linky Extends %RegisteredObject
{

ClassMethod Test()
{
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


    // Nacti spoje linky
    k arrSpoje d ##class(ALVA.ISY.ISYLinky.API.LinkySpoje).seznam(.sys,$lb(6,"","0230009"),"",.arrSpoje) 
    m arr("spoje")=arrSpoje
    m ^||linky(6,"0230009","spoje")=arrSpoje

    k ^jm m ^jm = ^||linky
}

ClassMethod NacistLinky()
{
    //
    // Nacte informace o lince, trasy a spojich do procesniho globalu
    //
    // ^||linky(skupinaId, linkaId)=$lb(...) // obecne informace o lince
    // ^||linky(skupinaId, linkaId,"trasa")  // body trasy linky
    // ^||linky(skupinaId, linkaId,"spoje")  // seznam spoju linky
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


            // Nacti spoje linky
            k arrSpoje d ##class(ALVA.ISY.ISYLinky.API.LinkySpoje).seznam(.sys,$lb(skupinaId,"",linkaId),"",.arrSpoje) 
            m ^||linky(skupinaId,linkaId,"spoje")=arrSpoje
        }
    }

    k ^jm m ^jm = ^||linky
}

}
