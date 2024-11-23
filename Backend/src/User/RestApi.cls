Class User.RestApi Extends %CSP.REST
{

Parameter HandleCorsRequest = 1;

Parameter CONTENTTYPE = "application/json";

Parameter CONVERTINPUTSTREAM = 1;

Parameter CHARSET = "utf-8";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/data" Method="OPTIONS" Call="HandleOptions"/>
    <Route Url="/stations" Method="GET" Call="LoadStations"/>
    <Route Url="/trips" Method="GET" Call="FindTrips"/>
</Routes>
}

ClassMethod SetHttpHeaders() As %Status
{
    #; Set origin = $Get(%request.CgiEnvs("HTTP_ORIGIN"))
    #; Do %response.SetHeader("Access-Control-Allow-Origin", "http://localhost:5173")
    #; Do %response.SetHeader("Access-Control-Allow-Credentials", "true")
    #; Do %response.SetHeader("Access-Control-Allow-Methods", "GET, PUT, POST, DELETE, OPTIONS")
    #; Do %response.SetHeader("Access-Control-Max-Age","10000")
    #; Do %response.SetHeader("Access-Control-Allow-Headers","Content-Type, Authorization, Accept-Language, X-Requested-With")
    Do %response.SetHeader("Access-Control-Allow-Origin", "http://localhost:5173")
    Do %response.SetHeader("Access-Control-Allow-Credentials", "true")
    Do %response.SetHeader("Access-Control-Allow-Methods", "GET, PUT, POST, DELETE, OPTIONS")
    Do %response.SetHeader("Access-Control-Max-Age", "10000")
    Do %response.SetHeader("Access-Control-Allow-Headers", "Content-Type, Authorization, Accept-Language, X-Requested-With")
    
    Quit $$$OK
}

ClassMethod HandleOptions() As %Status
{
    Do ..SetHttpHeaders()
    Do %response.Write("")
    Do %response.Status(200)
    Quit $$$OK
}

ClassMethod OnHandleCorsRequest(pUrl As %String, ByRef pContinue As %Boolean) As %Status
{
    Do ..SetHttpHeaders()

    Set tOrigin=$Get(%request.CgiEnvs("HTTP_ORIGIN"))
    Do ..SetResponseHeaderIfEmpty("Access-Control-Allow-Origin",tOrigin)

    If %request.Method = "OPTIONS" {
        Set pContinue = 0
    }
    Quit $$$OK
}

ClassMethod GetSys(ByRef sys As %String) As %Status
{
    Set sys("U","IdFa")="CK_SCHWAN"
    Set sys("U","delimiter")=$CHAR(0)
    Set sys("U","SystemDB")="MLINE"
    Set sys("C","User")=007
    Set sys("U","DATA")="USER"
    Set sys("U","MLP")=7
    Set sys("U","fullName")="007"
    Set sys("U","loginName")="007"
    Set sys("C","GUID")=7

    Quit $$$OK
}

ClassMethod LoadStations() As %Status
{
    Set response = {}
    Set response.stations = ##class(User.Zastavky).NactiZastavky()
    
    Write response.%ToJSON()
    Quit $$$OK
}

ClassMethod FindTrips() As %Status
{
    #dim %response As %CSP.Response
    #dim %request As %CSP.Request
    
    // Get parameters from the request URL
    Set fromStation = %request.Get("fromStation")
    Set toStation = %request.Get("toStation")
    Set dateTime = %request.Get("dateTime")

    // Validate parameters
    If (fromStation = "") || (toStation = "") || (dateTime = "") {
        Set response = {}
        Set response.status = "error"
        Set response.message = "Missing required parameters"
        Write response.%ToJSON()
        Quit $$$OK
    }
    
    Set response = {}
    Set response.trips = []
    
    Try {
        Set trips = ##class(User.Linky).NajdiSpojeBezPrestupu(fromStation, toStation, dateTime)
        
        Set response.status = "success"
        Set response.trips = trips
        
    } Catch ex {
        Set response.status = "error"
        Set response.message = ex.DisplayString()
    }
    
    Write response.%ToJSON()
    
    Quit $$$OK
}

}
