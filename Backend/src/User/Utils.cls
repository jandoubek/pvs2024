Class User.Utils Extends %RegisteredObject
{

ClassMethod Min2hhmm(min As %String) As %String
{
    ret $tr($j(min\60,2)_":"_$j(min#60,2)," ","0")
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

}
