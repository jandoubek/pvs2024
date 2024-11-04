Class ALVA.GENERALAPI.ParserXML Extends %XML.SAX.ContentHandler
{

Property element As %String;

Property glb As %String;

Method startElement(uri As %String, localname As %String, qname As %String, attrs As %List)
{
    s ..element=..element_","""_localname_""""
    if $e(..element)="," s ..element=$e(..element,2,*)
    s ..element=..element_","_$i(@(..glb_"("_..element_")"))
    if attrs'="" for i=1:5:$ll(attrs) s @(..glb_"("_..element_","""_$li(attrs,i+1)_""",""A"")")=$li(attrs,i+4)
}

Method endElement(uri As %String, localname As %String, qname As %String)
{
	s ..element=$p(..element,",",1,$l(..element,",")-2)
}

Method characters(chars As %String, length As %Integer)
{
	s chars=$zstrip(chars,"<>W",$c(10,13))
	if chars'="" s @(..glb_"("_..element_")")=$g(@(..glb_"("_..element_")"))_chars
}

ClassMethod ReadFile(file As %String, element As %String, glb As %String) As %Status
{
    s handler=..%New()
    s handler.element=element
    s handler.glb=glb
    q ##class(%XML.SAX.Parser).ParseFile(file,handler)
}

ClassMethod ReadString(string As %String, element As %String, glb As %String) As %Status
{
    s handler=..%New()
    s handler.element=element
    s handler.glb=glb
    q ##class(%XML.SAX.Parser).ParseString(string,handler)
}

}
