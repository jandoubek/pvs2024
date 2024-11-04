Class ALVA.ISY.Helpers [ Abstract ]
{

ClassMethod ListToString(list As %List) As %String
{
	s str="$lb("
	i list'=$lb(){
		f i=1:1:$ll(list){
			s listItem=$lg(list,i)
			i listItem="" s listItem=""
			
			i $lv(listItem),$ll(listItem)>0 { s str=str_..ListToString(listItem)_"," }
			else { s str=str_listItem_"," }
		}
		i $e(str,*-0)="," s str=$e(str,0,*-1)
	}
	s str=str_")"
	q str
}

ClassMethod RunG2F()
{
	// d ##class(ALVA.ISY.Helpers).RunG2F()
	d ..GlobalToFile("^ALVA.MTZ", "D:\CacheIns\PS\"_"file1.txt")
}

ClassMethod GlobalToFile(globalName, fileName)
{
	s stream=##class(%Stream.FileCharacter).%New()
	s stream.TranslateTable="UTF8"
	d stream.LinkToFile(fileName)
	
	s ref=$q(@globalName@(""),1,val)
	f{
		i ref="" q
		s processGlobalNameLength=$l(globalName)
		s keys=$e(ref,processGlobalNameLength+2,*-1)
		i $lv(val),$ll(val)>0 s val=..ListToString(val)
		
		d stream.WriteLine("("_$zcvt(keys,"O","UTF8")_")"_"="_$zcvt(val,"O","UTF8"))
		s ref=$q(@ref,1,val)
	}
	
	d stream.%Save()
}

}
