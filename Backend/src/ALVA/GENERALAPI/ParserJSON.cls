Class ALVA.GENERALAPI.ParserJSON [ Abstract ]
{

/*

prevod JSON do viceurovnoveho globalu

	Do ##class(ALVA.GENERALAPI.ParserJSON).Log("Starting")
	Set sc = ##class(ALVA.GENERALAPI.ParserJSON).ToGlb(in, "^[""MLINE""]kz",,1)
    If $$$ISERR(sc) {
        Do ##class(ALVA.GENERALAPI.ParserJSON).Log("Error " _ $System.Status.GetErrorText(sc))
        Set ex = ##class(%Exception.StatusException).CreateFromStatus(sc)
        Throw ex
    }
    Do ##class(ALVA.GENERALAPI.ParserJSON).Log("Completed successfully")
        
*/
ClassMethod ToGlb(obj, ByRef global, prefix As %List = "", log = 0) As %Status
{
    Set sc = $$$OK
    Try {
        If (obj = "") {
            Do ..SetGlobalValue(global, prefix, "", log)
            Quit
        }
        If '$IsObject(obj) {
            Do ..SetGlobalValue(global, prefix, obj, log)
            Quit
        }
        
        Do:log ..Log("Processing object of type: " _ $ClassName(obj))
        
        If (obj.%Extends("%DynamicObject")) {
            Set iterator = obj.%GetIterator()
            While iterator.%GetNext(.key, .value) {
                Set newPrefix = ..AppendToPrefix(prefix, key)
                Do:log ..Log("Processing key: " _ key)
                Set sc = ..ToGlb(value, global, newPrefix, log)
                If $$$ISERR(sc) Quit
            }
        } ElseIf (obj.%Extends("%DynamicArray")) {
            For i=0:1:obj.%Size()-1 {
                Set value = obj.%Get(i)
                Set newPrefix = ..AppendToPrefix(prefix, i)
                Do:log ..Log("Processing array index: " _ i)
                Set sc = ..ToGlb(value, global, newPrefix, log)
                If $$$ISERR(sc) Quit
            }
        } ElseIf (obj.%Extends("%Library.DynamicAbstractObject")) {
            Do ..SetGlobalValue(global, prefix, obj.%ToJSON(), log)
        } Else {
            Set strValue = obj.%ToString()
            Do ..SetGlobalValue(global, prefix, strValue, log)
        }
    } Catch ex {
        Do:log ..Log("Error in ToGlb: " _ ex.DisplayString())
        Set sc = ex.AsStatus()
    }
    Quit sc
}

/*

prevod JSON do jednourovnoveho globalu

*/
ClassMethod ToGlbSingle(obj, ByRef global, prefix As %String = "") As %Status
{
    Set sc = $$$OK
    Try {
        If (obj = "") {
            Set global(prefix) = ""
        } ElseIf $IsObject(obj) {
            If (obj.%Extends("%DynamicObject")) {
                Set iterator = obj.%GetIterator()
                While iterator.%GetNext(.key, .value) {
                    Set newPrefix = $Select(prefix '= "": prefix_".", 1: "") _ key
                    Set sc = ..ToGlbFlat(value, .global, newPrefix)
                    If $$$ISERR(sc) Quit
                }
            } ElseIf (obj.%Extends("%DynamicArray")) {
                For i=0:1:obj.%Size()-1 {
                    Set value = obj.%Get(i)
                    Set newPrefix = prefix _ "[" _ i _ "]"
                    Set sc = ..ToGlbFlat(value, .global, newPrefix)
                    If $$$ISERR(sc) Quit
                }
            } ElseIf (obj.%Extends("%Library.DynamicAbstractObject")) {
                // Handle other dynamic object types if necessary
                Set global(prefix) = obj.%ToJSON()
            } Else {
                // For other object types, store as string representation
                Set global(prefix) = obj.%ToString()
            }
        } Else {
            // For primitive types (strings, numbers, booleans)
            Set global(prefix) = obj
        }
    } Catch ex {
        Set sc = ex.AsStatus()
    }
    Quit sc
}

ClassMethod AppendToPrefix(prefix As %List, key) As %List
{
    If $ListLength(prefix) = 0 {
        Quit $ListBuild(key)
    }
    Quit prefix _ $ListBuild(key)
}

ClassMethod SetGlobalValue(ByRef global, prefix As %List, value, log)
{
    Set globalRef = global
    Set indexPart = ""
    For i=1:1:$ListLength(prefix) {
        Set key = $List(prefix, i)
        If indexPart '= "" Set indexPart = indexPart _ ","
        If $IsValidNum(key) {
            Set indexPart = indexPart _ key
        } Else {
            Set indexPart = indexPart _ $$$QUOTE(key)
        }
    }
    If indexPart '= "" Set globalRef = globalRef _ "(" _ indexPart _ ")"
    
    Try {
        Set @globalRef = value
        Do:log ..Log("Set global value: " _ globalRef _ " = " _ value)
    } Catch ex {
        Do:log ..Log("Error setting global value: " _ ex.DisplayString() _ " for global reference: " _ globalRef)
    }
}

ClassMethod Log(message As %String)
{
	/*
		Jak pouzit LOG:
		Do ##class(ALVA.GENERALAPI.ParserJSON).Log("Starting")
		Set sc = ##class(ALVA.GENERALAPI.ParserJSON).ToGlb(in, "^[""MLINE""]kz",,1) // 1=Logovani
		If $$$ISERR(sc) {
            Do ##class(ALVA.GENERALAPI.ParserJSON).Log("Error " _ $System.Status.GetErrorText(sc))
            Set ex = ##class(%Exception.StatusException).CreateFromStatus(sc)
            Throw ex
        }
		Do ##class(ALVA.GENERALAPI.ParserJSON).Log("Completed successfully")
	*/
	
    Set timestamp = $ZDateTime($Horolog, 3)
    Set logEntry = timestamp _ " - " _ message
    Set ^["MLINE"]ALVA.GENERALAPI.ParserJSON.Log($Increment(^["MLINE"]ALVA.GENERALAPI.ParserJSON.Log)) = logEntry
}

}
