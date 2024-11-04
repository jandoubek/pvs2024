ROUTINE KDZBASE [Type=INC]
#define DataTypeText 1
#define DataTypeInteger 2
#define DataTypeDouble 3
#define DataTypeDate 4
#define DataTypeBoolean 5
#define DataTypeList 6
#define DataTypeFormList 7
#define DataTypeFileSelect 8
#define DataTypeDirectorySelect 9
#define DataTypeDateMulti 10
#define DataTypeTime 11
#define DataTypeTimeSpan 12
#define DataTypeHorolog 13
#define DataTypeDateTime 14
#define DataTypeTextArea 15
#define DataTypeDateTimeSpan 16
#define DataTypeColor 17
#define DataTypeObdobi 18
#define DataTypeObdobiSpan 19

#define StateNone 0
#define StateOk 1
#define StateInfo 2
#define StateWarning 3
#define StateError 4

#define FormModeNone 0
#define FormModeAdd 1
#define FormModeEdit 2
#define FormModeView 4
#define FormModeList 8
#define FormModeSelect 16
#define FormModeSelectAdd 17

#define ValidationModeSingle 1
#define ValidationModeMulti 2

#define SelectionModeSingleSelect 1
#define SelectionModeMultiSelect 2

#define TvNodeTypeFolder 1
#define TvNodeTypeForm 2

#define FormTreeViewNodeTypeFolder 1
#define FormTreeViewNodeTypeForm 2

#define BaseRestBinary ^CacheTempKDZBASERestBinary

#define Null $c(0)

#define ListStart $c(17)
#define ListEnd $c(18)
#define ListItemSeparator $c(19)

#define SeparatorFile $c(28)
#define SeparatorGroup $c(29)
#define SeparatorRecord $c(30)
#define SeparatorUnit $c(31)

#define InitOBSOLETE ##continue
	s ret=1 ##continue
	s err="" ##continue
	s IdFa=$g(sys("U","IdFa")) ##continue
	s dataDB=$g(sys("U","DATA")) ##continue
	s systemDB=$g(sys("U","SystemDB")) ##continue
	s loginName=$g(sys("U","loginName")) ##continue
	s fullName=$g(sys("U","fullName")) ##continue
	s D=$c(0) ##continue
	s T="~" ##continue
	s guid=$g(sys("C","GUID")) ##continue
	s guidForm=$g(sys("C","GUIDForm"))
	
#define Init ##continue
	s ret=1 ##continue
	s err="" ##continue
	s IdFa=$g(sys("COMPANY","IdFa")) ##continue
	s companyId=$g(sys("COMPANY","Id")) ##continue
	s dataDB=$g(sys("NS","Data")) ##continue
	s classDB=$g(sys("NS","Class")) ##continue
	s systemDB=$g(sys("NS","System")) ##continue
	s logDB=$g(sys("NS","Log")) ##continue
	s userId=$g(sys("USER","Id")) ##continue
	s D=$c(0) ##continue
	s guid=$g(sys("MISC","Guid")) ##continue
	s guidForm=$g(sys("MISC","GuidForm")) ##continue
	s T="~" 
	
#define OutListsToStrings ##continue
	s i=0 ##continue
	f{ ##continue
		s i=$o(^||KDZ("OUT",i)) q:i="" ##continue
		s ^||KDZ("OUT",i)=$lts(^||KDZ("OUT",i),D,1) ##continue
	}
	
#define InStringsToLists ##continue
	s i=0 ##continue
	f{ ##continue
		s i=$o(^||KDZ("IN",i)) q:i="" ##continue
		s ^||KDZ("IN",i)=$lfs(^||KDZ("IN",i),D) ##continue
	}
	
#define CatchErr ##continue   
	s ret=err_ex.DisplayString()

#define CatchErr(%ex,%err,%ret) s %ret=$$$ERROR($$$GeneralError,%err_%ex.DisplayString())

#define ThrowErr(%sc,%err) if $case($g(%sc),"":0,"0":0,"1":0,:1) s %err=$case($e(%sc),0:$SYSTEM.Status.GetErrorText(%sc),1:%sc,:%sc) ztrap

/// ==============
/// REPORT
/// ==============
#Define ReportStatus(%status,%statusText) $lb(%status,%statusText)
#Define ReportSet(%reportName) $lb(%reportName)
#Define ReportAttrs(%reportId,%reportName,%showFilterDialog,%showSaveFileDialog,%openFile) $lb(%reportId,%reportName,%showFilterDialog,%showSaveFileDialog,%openFile)
#Define ReportTableAttrs(%tableName) $lb(%tableName)
#Define ReportTablePropAttrs(%propListIndex,%propName,%dataType,%format,%nullable) $lb(%propListIndex,%propName,%dataType,%format,%nullable)
#Define ReportTablePropAttrsBasic(%propListIndex,%propName,%dataType) $lb(%propListIndex,%propName,%dataType)
#Define ReportTableItemValues(%lb) %lb
#Define ReportGroupAttrs(%groupId,%groupName) $lb(%groupId,%groupName)
#Define ReportPropAttrs(%propId,%groupId,%propName,%dataType,%required,%validated,%editable,%hidden,%showValueButton,%format,%status,%statusText,%formListId,%formListMultiSelect,%formListAllowedAdd,%nullable,%minValue,%maxValue) $lb(%propId,%groupId,%propName,%dataType,%required,%validated,%editable,%hidden,%showValueButton,%format,%status,%statusText,%formListId,%formListMultiSelect,%formListAllowedAdd,%nullable,%minValue,%maxValue)
#Define ReportPropAttrsBasic(%propId,%groupId,%propName,%dataType,%required,%validated,%editable) $lb(%propId,%groupId,%propName,%dataType,%required,%validated,%editable,0,0,"",0,"","",0,0,1)
#Define ReportGetFilter(%reportId) ##continue
	k in1,out1 ##continue
	s in1("ReportId")=%reportId ##continue
	s ret=##class(KDZ.BASE.CONTROLS.API.BaseFilter).GetFilter(.sys,.in1,.out1) ##continue
	i ret'=$$$OK{ $$$ThrowErr(ret,err) } ##continue
	m filter=out1("FILTER") ##continue
	s filterText=out1("Text") ##continue
	s ^||KDZ("OUT","FILTER")=$lb(,,filterText) ##continue

/// ==============
/// DATASET
/// ==============
#Define DatasetGetFilter(%datasetId) ##continue
	k in1,out1 ##continue
	s in1("DatasetId")=%datasetId ##continue
	s ret=##class(KDZ.BASE.CONTROLS.API.BaseFilter).GetFilter(.sys,.in1,.out1) ##continue
	i ret'=$$$OK{ $$$ThrowErr(ret,err) } ##continue
	m filter=out1("FILTER") ##continue
	s filterText=out1("Text") ##continue
	s ^||KDZ("OUT","FILTER")=$lb(,,filterText) ##continue

/// ==============
/// BIL2
/// ==============
#Define Bil2Set $lb()
#Define Bil2Status(%status,%statusText) $lb(%status,%statusText)
#Define Bil2PropAttrs(%propId,%propListIndex,%propName,%dataType,%hidden,%format,%nullable) $lb(%propId,%propListIndex,%propName,%dataType,%hidden,%format,%nullable)
#Define Bil2Item(%itemId,%itemName,%itemTag) $lb(%itemId,%itemName,%itemTag)
/// #Define Bil2ItemAttrs(%itemId,%itemName,%selected,%itemTag) $lb(%itemId,%itemName,%selected,%itemTag) ... chybne 8.3.2022 KZ
#Define Bil2ItemAttrs(%itemId,%itemName,%selected,%disabled) $lb(%itemId,%itemName,%selected,%disabled)
#Define Bil2ItemBig2Value(%displayValue,%description,%dataValue) $lb(%displayValue,%description,%dataValue)
#Define Bil2ItemStyle(%backColor,%foreColor) $lb($case(%backColor,"":"#FFFFFF",:%backColor),$case(%foreColor,"":"#000000",:%foreColor))
#Define Bil2ItemValues(%lb) %lb
#Define Bil2GetFilter(%classname) ##continue
	k in1,out1 ##continue
	s in1("FormId")=%classname ##continue
	s ret=##class(KDZ.BASE.CONTROLS.API.BaseFilter).GetFilter(.sys,.in1,.out1) ##continue
	i ret'=$$$OK{ $$$ThrowErr(ret,err) } ##continue
	m filter=out1("FILTER") ##continue
	s filterText=out1("Text") ##continue
	s ^||KDZ("OUT","FILTER")=$lb(,,filterText) ##continue

/// ==============
/// BIG2
/// ==============
#define Big2GrpItm(%grp,%itm) (%grp_"//"_%itm)
#define Big2GrpItmSep "//"
#Define Big2Set $lb()
#Define Big2SetCancel(%cancel) $lb(%cancel)
#Define Big2Status(%status,%statusText) $lb(%status,%statusText)
#Define Big2GroupAttrs(%groupId,%groupName) $lb(%groupId,%groupName)
#Define Big2PropAttrs(%propId,%groupId,%propName,%dataType,%required,%validated,%editable,%hidden,%showValueButton,%format,%status,%statusText,%formListId,%formListMultiSelect,%formListAllowedAdd,%nullable) $lb(%propId,%groupId,%propName,%dataType,%required,%validated,%editable,%hidden,%showValueButton,%format,%status,%statusText,%formListId,%formListMultiSelect,%formListAllowedAdd,%nullable)
#Define Big2PropAttrsBasic(%propId,%groupId,%propName,%dataType,%required,%validated,%editable) $lb(%propId,%groupId,%propName,%dataType,%required,%validated,%editable,0,0,"",0,"","",0,0,1)
#Define Big2PropValue(%displayValue,%description,%dataValue) $lb(%displayValue,%description,%dataValue)
#Define Big2PropValueBasic(%displayValue) $lb(%displayValue)
#Define Big2PropAttrsPropId 1
#Define Big2PropAttrsGroupId 2
#Define Big2PropAttrsPropName 3
#Define Big2PropAttrsDataType 4
#Define Big2PropAttrsRequired 5
#Define Big2PropAttrsValidated 6
#Define Big2PropAttrsEditable 7
#Define Big2PropAttrsHidden 8
#Define Big2PropAttrsShowValueButton 9
#Define Big2PropAttrsFormat 10
#Define Big2PropAttrsStatus 11
#Define Big2PropAttrsStatusText 12
#Define Big2PropAttrsFormListId 13
#Define Big2PropAttrsFormListMultiSelect 14
#Define Big2PropAttrsFormListAllowedAdd 15
#Define Big2PropAttrsNullable 16

/// ==============
/// prevody datumu
/// ==============
/// hrl -> dd.mm.rrrr
#define ND(%Number) $tr($zd(%Number\1,4,,4,,,,,""),"/",".")
/// dd.mm.rrrr -> hrl
#define DN(%Date) $zdh($tr(%Date,".","/"),4,,,,,,,-1)
/// hrl -> ciselne den v tydnu 1-7
#define NDW(%Number) %Number+3#7+1
/// hrl -> index
#define HorToId(%H) (%H*100000+$p(%H,",",2))
/// index -> hrl
#define IdToHor(%Id) ((%Id\100000)_","_(%Id#100000))
