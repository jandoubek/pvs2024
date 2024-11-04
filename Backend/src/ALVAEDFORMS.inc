ROUTINE ALVAEDFORMS [Type=INC]
/// Datovy global
#define PublicDataGlobal ^||ALVA.EDFORMS.CONTROLS.LIST.Data

#; Typ formulare...
/// Bez typu formulare
#define FormTypeNone 0
/// Big
#define FormTypeBig 1
/// List
#define FormTypeBil 2
/// DotNet formular
#define FormTypeDotNet 3

#; Rezim formulare...
/// Bez rezimu formulare
#define FormModeNone -1
/// Seznam
#define FormModeList 0
/// Vyber
#define FormModeSelection 1
/// Vyber s pridanim
#define FormModeSelectionAdd 2
/// Novy
#define FormModeAdd 3
/// Editace
#define FormModeEdit 4
/// Prohlizeni
#define FormModeView 5

#; Vyberovy rezim...
/// Single select
#define SelectionModeSingle 0
/// Multi select
#define SelectionModeMulti 1
/// Check select
#define SelectionModeCheck 2

#; Typ stavu...
/// OK
#define BigStateTypeOk 1
/// Varovani
#define BigStateTypeWarning 2
/// Chyba
#define BigStateTypeError 3
/// Informace
#define BigStateTypeInformation 4

#; Typ validace...
/// Polozka
#define BigValidationTypeItem 1
/// Skupiny
#define BigValidationTypeGroups 2

#; Datovy typ polozky BIGu...
/// Text
#define BigItemDataTypeText 1
/// Datum
#define BigItemDataTypeDate 2
/// Integer
#define BigItemDataTypeInteger 3
/// Decimal
#define BigItemDataTypeDecimal 4
/// Boolean
#define BigItemDataTypeBoolean 5
/// List
#define BigItemDataTypeList 6
/// Codebook
#define BigItemDataTypeCodebook 7
/// Doba
#define BigItemDataTypeDuration 8
/// Heslo
#define BigItemDataTypePassword 9
/// Odbdobí (202210) při editu skočí prvně do měsíce
#define BigItemDataTypeObdobi 10
/// Odbdobí (202210) při editu skočí prvně do roku
#define BigItemDataTypeObdobiR 11
/// Interval času
#define BigItemDataTypeDateInterval 12
/// Vyber adresare
#define BigItemDataTypeDialogDirectory 101
/// Vyber souboru
#define BigItemDataTypeDialogFile 102
/// Vyber adresare
#define BigItemDataTypeDialogServerDirectory 103
/// Vyber souboru
#define BigItemDataTypeDialogServerFile 104
/// Vyber barvy
#define BigItemDataTypeDialogColor 105
/// Vyber font
#define BigItemDataTypeDialogFont 106
/// Vyber souboru pro Save
#define BigItemDataTypeDialogFileSave 107

#; Datovy typ polozky BILu...
/// Odkaz - string
#define BilItemDataTypeHyperLinkString 201
/// Odkaz - integer
#define BilItemDataTypeHyperLinkInteger 202

#; Typ parametru polozky Bigu...
/// Zobrazit id
#define BigParamTypeShowId "BigParam_ShowId"
/// Doba - maximalni pocet kladnych minut
#define BigParamTypeDurationMaxPosMinutes "BigParam_Duration_MaxPosMinutes"
/// Doba - maximalni pocet zapornych minut
#define BigParamTypeDurationMaxNegMinutes "BigParam_Duration_MaxNegMinutes"


#; Zarovnani textu BILu...
/// Doleva
#define BilTextAlignLeft 1
/// Doprava
#define BilTextAlignRight 2
/// Doprostred
#define BilTextAlignCenter 3

#; BaseDataGrid
#define BDGDataTypeText 1
#define BDGDataTypeDate 2
#define BDGDataTypeInteger 3
#define BDGDataTypeDecimal 4
#define BDGDataTypeBoolean 5
#define BDGDataTypeList 6
#define BDGDataTypeCodebook 7
#define BDGDataTypeTime 8
#define BDGDataTypeDateRange 9
#define BDGDataTypeTemplate 10
#define BDGDataTypeDirectoryDialog 11

#define BDGStateOk 1
#define BDGStateInfo 2
#define BDGStateWarning 3
#define BDGStateError 4