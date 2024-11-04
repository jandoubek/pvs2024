Class ALVA.GENERALAPI.String Extends %RegisteredObject
{

/// validace emailu
ClassMethod valEmail(ByRef email As %String, ByRef msg As %String)
{
   // d ##class(ALVA.GENERALAPI.String).valEmail("stanislav.kaska@m-line.cz",.msg)
   s msg=""
   s predZav=$p(email,"@")             
   s zaZav=$p(email,"@",2)               
   s zaTec=$p(email,".",2)  
   s predTec=$p(zaZav,".",2)
   if (($l(email,"@")>2)||($l(zaZav,".")>2)||($l(email,".")<2)||($l(email," ")>1)||($l(zaTec)<1)||($l(predTec)<1)||($l(predZav)<1)) {
      s msg="Neplatný formát e-mailu"
   }
   if (email["|") {
      s msg="Email obsahuje neplatný znak |"
   }
}

/// 
/// vkládá před nebo za danné znaky
/// jak=L/R, n=pocet
ClassMethod formatStr(ByRef in As %String, ByRef jak As %String, ByRef n As %String, ByRef znak As %String) As %String
{
   // w ##class(ALVA.GENERALAPI.String).formatStr("1","P",2,"0")
   if ($g(znak)="") { s znak=" " }
   if (+$g(n)=0) { s n=$l(in) }
   s zn=""
   for i=1:1:(n-$l(in) ) { s zn=zn_znak }
   s out=in
   // vkládá znaky za
   if (jak="L")  {  s out=$e(in_zn,1,n) }
	// vkládá znaky před
   elseif ((jak="R")!(jak="P"))  {s out=$e(zn,1,n-$l(in))_in }
   q out
}

/// 
/// zamění . za , jobne danný počet míst
/// 
ClassMethod formatNum(ByRef number As %String, ByRef dec As %String, ByRef mezeryMeziRady As %String, ByRef desetOddel As %String) As %String
{
   // w ##class(ALVA.GENERALAPI.String).formatNum("10241564.1256",2)
   if ($g(desetOddel)= ""){s desetOddel = ","}
   if $g(dec)="" { s dec = 0 }
   s return=number
   if $g(number)'="" {
      if (+$g(mezeryMeziRady) =1) { s number=$tr($fn(number,",",dec),","," ") }
      else { s number=$tr($fn(number,",",dec),",","") }
      s return=$tr(number,".",desetOddel)
    }
   q return
}

/// odstraní háčky a čárky z textu
ClassMethod HackyACarkyFuc(ByRef s As %String) As %String
{
    // w ##class(ALVA.GENERALAPI.String).HackyACarkyFuc("ěščřžýáíé")
   s r=""
   s i=0 f {
      s i=i+1 q:(i>$l(s))
      s p=$e(s,i,i)
      // malé
      i (p="á") s p="a"
      i (p="ä") s p="a"
      i (p="č") s p="c"
      i (p="ď") s p="d"
      i (p="ě") s p="e"
      i (p="ë") s p="e"
      i (p="é") s p="e"
      i (p="í") s p="i"
      i (p="ĺ") s p="l"
      i (p="ľ") s p="l"
      i (p="ň") s p="n"
      i (p="ó") s p="o"
      i (p="ö") s p="o"
      i (p="ô") s p="o"
      i (p="ř") s p="r"
      i (p="ŕ") s p="r"
      i (p="š") s p="s"
      i (p="ť") s p="t"
      i (p="ú") s p="u"
      i (p="ů") s p="u"
      i (p="ü") s p="u"
      i (p="ý") s p="y"
      i (p="ž") s p="z"
      // velké
      i (p="Á") s p="A"
      i (p="Ä") s p="A"
      i (p="Č") s p="C"
      i (p="Ď") s p="D"
      i (p="Ě") s p="E"
      i (p="Ë") s p="E"
      i (p="É") s p="E"
      i (p="Í") s p="I"
      i (p="Ĺ") s p="L"
      i (p="Ľ") s p="L"
      i (p="Ň") s p="N"
      i (p="Ó") s p="O"
      i (p="Ö") s p="O"
      i (p="Ô") s p="O"
      i (p="Ř") s p="R"
      i (p="Ŕ") s p="R"
      i (p="Š") s p="S"
      i (p="Ť") s p="T"
      i (p="Ú") s p="U"
      i (p="Ů") s p="U"
      i (p="Ü") s p="U"
      i (p="Ý") s p="Y"
      i (p="Ž") s p="Z"
      //
      s r=r_p
   }
   q r
}

/// odstraní mezery na začítku a na konci z textu
ClassMethod Trim(ByRef x As %String) As %String
{
   // w ##class(ALVA.GENERALAPI.String).Trim(" neco ")
   f i=1:1:$l(x) q:" "'=$e(x,i)
   f j=$l(x):-1:1 q:" "'=$e(x,j)
   q $e(x,i,j)
}

/// obsahuje řetězec text
ClassMethod Alphabetic(ByRef x As %String) As %String
{
   // w ##class(ALVA.GENERALAPI.String).Alphabetic("123ABC")
   s z="AaÁáÄäBbCcČčDdĎďEeÉéĚěFfGgHh|{}IiÍíJjKkLlĹĺĽľMmNnŇňOoÓóÖöÔôPpQqRrŘřSsŠšTtŤťUuÚúŮůÜüVvWwXxYyÝýZzŽž()/ ;:""*$#~"
   s r=0 f i=1:1:$l(z) { s y=$e(z,i,i) i x[y { s r=1 } } 
   if $l(x,".")>2 { s r=1 }
   q $g(r)
}

/// převede text na tříditělný string bez CH, Ch a ch
ClassMethod gSortTxt(text As %String) As %String
{
   // w ##class(ALVA.GENERALAPI.String).gSortTxt("šchuj9876")
   
   s r2="AaÁáÄäBbCcČčDdĎďEeÉéĚěFfGgHh|{}IiÍíJjKkLlĹĺĽľMmNnŇňOoÓóÖöÔôPpQqRrŘřSsŠšTtŤťUuÚúŮůÜüVvWwXxYyÝýZzŽž0123456789()-/ .;,:""*$#"
   
   s r1="" f i=1:1:$l(r2) { s r1=r1_$C(1000+i) }
   
   s text=$replace(text,"CH","|")
   s text=$replace(text,"Ch","{")
   s text=$replace(text,"ch","}")
   
   q $tr(text,r2,r1)
}

/// prevede arr(key)=val na string val,val,val,...
ClassMethod ArrayToString(array, delimiter, maxLen)
{
   //k arr s arr(1)="karel",arr(5)="pavel",arr(7)="honza",arr(11)="jirka"
   //w ##class(ALVA.GENERALAPI.String).ArrayToString(.arr,",",3)

   i $g(delimiter)="" s delimiter=","
   s maxLen=$g(maxLen) // ""=neomezeno
   
   i maxLen'="",+maxLen=0 q ""
   s i=$o(array("")) i i="" q ""
   s n=1,text=array(i)
   f {
      s n=n+1 i maxLen'="",n>maxLen q
      s i=$o(array(i)) q:i=""
      s text=text_delimiter_array(i)
   }
   q text
}

}
