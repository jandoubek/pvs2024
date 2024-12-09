Class User.Utils Extends %RegisteredObject
{

ClassMethod Min2hhmm(min As %String) As %String
{
    ret $tr($j(min\60,2)_":"_$j(min#60,2)," ","0")
}

ClassMethod HHMM2Min(hhmm As %String) As %String
{
    ret $p(hhmm,":",1) * 60 + $p(hhmm,":",2)
}

ClassMethod ISO86012Min(ISO As %String) As %String
{
    s time = $p(ISO," ",2)
    
    s hours = +$p(time,":",1)
    s minutes = +$p(time,":",2)
    
    s totalMinutes = (hours * 60) + minutes
    
    // Ensure result is within valid range
    i totalMinutes < 0 s totalMinutes = 0
    i totalMinutes > 1439 s totalMinutes = 1439
    
    ret totalMinutes
}

ClassMethod Min2ISO8601(minutes As %Integer) As %String
{
    // Handle midnight rollover
    s adjustedMin = minutes # 1440  // 1440 = 24*60
    
    // Calculate hours and minutes
    s hours = adjustedMin \ 60
    s mins = adjustedMin # 60
    
    // Format with leading zeros
    s timeStr = $tr($j(hours,2)_$j(mins,2)," ","0")
    
    // Return in ISO8601 format HHMM
    q timeStr
}

}
