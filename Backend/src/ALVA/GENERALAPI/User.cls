Class ALVA.GENERALAPI.User Extends %RegisteredObject
{

ClassMethod getUserID() As %String
{
	// s userID=##class(ALVA.GENERALAPI.User).getUserID()
	s ret=""
	if $g(^CacheTempMLSrv($j,"SYS","U","MLP"))'="" { s ret=$g(^CacheTempMLSrv($j,"SYS","U","MLP")) }
	if $g(^||ML("SYS","U","MLP"))'="" { s ret=$g(^||ML("SYS","U","MLP")) }
	q $g(ret)
}

}
