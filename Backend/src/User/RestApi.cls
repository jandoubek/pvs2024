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
    <Route Url="/data" Method="GET" Call="LoadStations"/>
</Routes>
}

ClassMethod SetHttpHeaders() As %Status
{
    Set origin = $Get(%request.CgiEnvs("HTTP_ORIGIN"))
    Do %response.SetHeader("Access-Control-Allow-Origin", "http://localhost:5173")
    Do %response.SetHeader("Access-Control-Allow-Credentials", "true")
    Do %response.SetHeader("Access-Control-Allow-Methods", "GET, PUT, POST, DELETE, OPTIONS")
    Do %response.SetHeader("Access-Control-Max-Age","10000")
    Do %response.SetHeader("Access-Control-Allow-Headers","Content-Type, Authorization, Accept-Language, X-Requested-With")
    
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
}

}
