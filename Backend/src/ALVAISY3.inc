ROUTINE ALVAISY3 [Type=INC]
#;----------------------------------------------------------------------------------------------------------------------
///
#define BGN27(%GROUPID,%GROUPNAME,%ITEMID,%VALUE,%NAME,%DATATYPE,%FORMAT,%ALLOWEDIT,%REQUIRED,%VALIDATIONREQUIRED,%CODEBOOKTYPE,%LIST,%STATUSID,%STATUSMESSAGE,%MULTISELECT,%CODEBOOKSELECTIONONLY,%SELECTABLE,%FORCEINPUT,%ITEMIDINTERNALID,%HIDDEN,%AllowedInputChars,%DeniedInputChars,%UserCodeBookId,%SelectableFormID,%DenyWhiteSpaces,%DisplayAllValues,%IgnoreItemName) $lb(%GROUPID,%GROUPNAME,%ITEMID,%VALUE,%NAME,%DATATYPE,%FORMAT,%ALLOWEDIT,%REQUIRED,%VALIDATIONREQUIRED,%CODEBOOKTYPE,%LIST,%STATUSID,%STATUSMESSAGE,%MULTISELECT,%CODEBOOKSELECTIONONLY,%SELECTABLE,%FORCEINPUT,%ITEMIDINTERNALID,%HIDDEN,%AllowedInputChars,%DeniedInputChars,%UserCodeBookId,%SelectableFormID,%DenyWhiteSpaces,%DisplayAllValues,%IgnoreItemName)
#;----------------------------------------------------------------------------------------------------------------------
///
#define FILLBIG(%DEFINICE,%DATA) ##continue
				 s data=$g(%DATA) ##continue
				 s poradi="" ##continue
				 f { ##continue
						s poradi=$o(%DEFINICE("big",poradi),1,dta) q:poradi="" ##continue
						s item="" ##continue
						s item=##class(ALVA.EDFORMS.CONTROLS.BIG.Item).%New() ##continue
						s item.GroupId=$li(dta,1) ##continue
						s item.GroupName=$li(dta,2) ##continue
						s item.Id=$li(dta,3) ##continue
						i $li(dta,11)'="" s item.CodebookType=$li(dta,11) ##continue
						i $li(dta,15) s item.MultiSelect=1 ##continue
						i id'="" { ##continue
							 i item.MultiSelect { ##continue
									s valueArr=$lg(data,item.Id) ##continue
									f ii=1:1:$l(valueArr,",") { ##continue
										 s valueArrI=$p(valueArr,",",ii) ##continue
										 s description="" ##continue
										 i valueArrI'="" d item.AddValue(valueArrI,description,"") ##continue
									} ##continue
							 }else{ ##continue
									s description="" ##continue
									d item.AddValue($lg(data,item.Id),description,"") ##continue
							 } ##continue
						}else{ ##continue
							 s item.FirstValue().Data=$li(dta,4) ##continue
						} ##continue
						s item.Name=$li(dta,5) ##continue
						s item.DataType=$li(dta,6) ##continue
						s item.Format=$li(dta,7) ##continue
						s item.AllowEdit=$li(dta,8) ##continue
						s item.Required=$li(dta,9) ##continue
						s item.ValidationRequired=$li(dta,10) ##continue
						i item.CodebookType=1010 { ##continue
							 d item.AddParam("VyberAdresy",$$$BigItemDataTypeBoolean,$lb(0)) ##continue
						} ##continue
						i item.CodebookType=1010333 { ##continue
							 s item.CodebookType=1010 ##continue
							 d item.AddParam("VyberAdresy",$$$BigItemDataTypeBoolean,$lb(1)) ##continue
						} ##continue
						f idx=1:1:$ll($li(dta,12)) { ##continue
							 d item.AddListItem($p($lg($li(dta,12),idx),"~",2),$p($lg($li(dta,12),idx),"~",1)) ##continue
						} ##continue
						s item.StatusId=$li(dta,13) ##continue
						s item.StatusMessage=$li(dta,14) ##continue
						i $li(dta,15) s item.MultiSelect=1 ##continue
						i $li(dta,16) s item.CodebookSelectionOnly=1 ##continue
						i $li(dta,17) s item.Selectable=1 ##continue
						i $li(dta,18) s item.ForceInput=1,item.StartingEditMode=2 ##continue
						i $li(dta,20) s item.Hidden=1 ##continue
						s item.DenyWhiteSpaces=1  ##continue
						s item.DeniedInputChars="~^#|" ##continue
						i $li(dta,21)'="" s item.AllowedInputChars=$li(dta,21) ##continue
						i $li(dta,22)'="" s item.DeniedInputChars=$li(dta,22) ##continue
						i $li(dta,24)'="" s item.SelectableFormID=$li(dta,24) ##continue
						i $li(dta,25)'="" s item.DenyWhiteSpaces=$li(dta,25) ##continue
						i $lg(dta,26)'="" s item.DisplayAllValues=$lg(dta,26) ##continue
						i $lg(dta,27)'="" s item.IgnoreItemName=$lg(dta,27) ##continue
						d items.Insert(item) ##continue
				 }
#;----------------------------------------------------------------------------------------------------------------------
///
#define FILLDEF(%VAR,%DELIMITERMULTIVAR) s %VAR=$lb() ##continue 
			s key="" ##continue
			for { ##continue
				 s item=items.GetNext(.key) q:key="" ##continue
				 s itemId=item.Id ##continue
				 s value="" ##continue
				 s valuekey="" ##continue
				 f { ##continue
						s newvalue=item.Values.GetNext(.valuekey) q:valuekey="" ##continue
						s value=value_$s(value'="":%DELIMITERMULTIVAR,1:"")_newvalue.Data ##continue
				 } ##continue
				 s $li(%VAR,itemId)=value ##continue
			}
#;----------------------------------------------------------------------------------------------------------------------
///
#define LISTFILL(%CIS)   s listCis=$lb() ##continue
				 s listCnt="" ##continue
				 s listId="" ##continue
				 f { ##continue 
						s listId=$o(%CIS(listId),1,listText) q:listId="" ##continue 
						s $li(listCis,$i(listCnt))=listId_"~"_listText ##continue
				 }
#;----------------------------------------------------------------------------------------------------------------------
///
#define FILLSYS(%SYS,%IDFA,%USERLB) ##continue
			s %SYS("U","delimiter")=$c(0) ##continue
			s %SYS("U","IdFa")=%IDFA ##continue
			s %SYS("U","SystemDB")=##class(ALVA.EDISON.Main).GetSystemDB() ##continue
			s %SYS("U","DATA")=##class(ALVA.GENERALAPI.DataBase).dataDB(%IDFA) ##continue
			s %SYS("U","MLP")=$li(%USERLB,1) ##continue
			s %SYS("U","loginName")=$ZCONVERT($li(%USERLB,2),"L") ##continue
			s %SYS("U","fullName")=$li(%USERLB,3)
#;----------------------------------------------------------------------------------------------------------------------
///
#define M3 ^CacheTempUser.m3
#;----------------------------------------------------------------------------------------------------------------------
///
#define ND(%Number) $tr($zd(%Number\1,4,,4,,,,,""),"/",".")
///
#define DN(%Date) $zdh($tr(%Date,".","/"),4,,,,,,,-1,1)
#;----------------------------------------------------------------------------------------------------------------------
