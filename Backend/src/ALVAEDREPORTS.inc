ROUTINE ALVAEDREPORTS [Type=INC]
#; Typ agendy...
#define AgendaTypeHim 1
#define AgendaTypeZakaznici 2
#define AgendaTypeVozidla 3
#define AgendaTypeFakturace 4
#define AgendaTypeEs 5
#define AgendaTypeEsFinancovani 6
#define AgendaTypeFakturaceEx 7
#define AgendaTypeSklady 8
#define AgendaTypeShmain 9
#define AgendaTypeNd 10
#define AgendaTypeMhd 11
#define AgendaTypeReporting 12
#define AgendaTypeJrmain 13

#; Datovy typ...
#define DataTypeText 1
#define DataTypeDate 2
#define DataTypeNumber 3

#; Typ bunky...
#define CellTypeHeader 1
#define CellTypeData 2

#; Datovy typ polozky sablony...
#define ItemTypeNumeric 1
#define ItemTypeText 2
#define ItemTypeDateTime 3

#; Atributy polozky sablony...
#define ItemAttrOptional 0
#define ItemAttrRequired 1

#; Datovy typ parametru...
#define ParamDataTypeText 1
#define ParamDataTypeList 6

#; Typy ciselniku...
#define CodebookTypeNone 0
#define CodebookTypeUser 1
#define CodebookTypeUcty 1001
#define CodebookTypeStrediska 1002
#define CodebookTypeZakazky 1003
#define CodebookTypeAgendy 1004
#define CodebookTypeTypyDokladu 1005
#define CodebookTypePrepravniSystemy 1006
#define CodebookTypeOsobniCisla 1007
#define CodebookTypeRz 1008
#define CodebookTypeExterniCinnosti 1009
#define CodebookTypeZakaznik 1010
#define CodebookTypeCiselneRady 1011
#define CodebookTypeProvozovny 1012
#define CodebookTypeZpusobyPlatby 1013
#define CodebookTypeBanky 1014
#define CodebookTypePokladny 1015
#define CodebookTypeStaty 1016
#define CodebookTypeStatyMpz 1017
#define CodebookTypeMeny 1018
#define CodebookTypeStrediskaCiselne 1019
#define CodebookTypeZboziProdej 1020
#define CodebookTypeFirmy 1021
#define CodebookTypeZakazniciIco 1022
#define CodebookTypeRidiciMhd 1023
#define CodebookTypeTypyVozidel 1024
#define CodebookTypeUzivatele 1025
#define CodebookTypeOsobniCislaZivi 1026
#define CodebookTypeRidiciAD 1027
#define CodebookTypeM2Razeni 1028
#define CodebookTypeZastavky 1029
#define CodebookTypeSkupinyLinek 1030
#define CodebookTypeCelostatRegistrZastavek 1031
#define CodebookTypeZam 1032
#define CodebookTypeNegZn 1033
#define CodebookTypeKategorieObsaditelnostiAutobusu 1034
#; ekos..
#define CodebookTypeTypyUcetnihoPripadu 1101
#define CodebookTypeAgendyCinnosti 1102
#define CodebookTypeUcetniPripady 1103
#define CodebookTypeDanoveKody 1104
#define CodebookTypeCinnosti 1105
#define CodebookTypeUcetniPripadyFD 1107
#define CodebookTypeDenikFD 1108
#define CodebookTypeDenikFV 1109
#define CodebookTypeSkodniUdalosti 1201
#define CodebookTypeSapWbs 1301
#define CodebookTypeSaldUcet 1110
#; Majetek...
#define CodebookTypeDruhyMajetku 2001
#define CodebookTypeTridyMajetku 2002
#define CodebookTypeSkupinyKaret 2003
#define CodebookTypeNazvyMajetku 2004
#define CodebookTypeUmisteniMajetku 2005
#define CodebookTypeOdpovedneOsoby 2006
#define CodebookTypeSkpMajetku 2007
#define CodebookTypeOdpisoveSkupiny 2008
#define CodebookTypeZpusobyVyrazeni 2009
#define CodebookTypeInventarniKarty 2010
#; Sklady SH...
#define CodebookTypeSklad 3001
#define CodebookTypePohyb 3002
#define CodebookTypeMaterial 3003
#define CodebookTypeJednotka 3004
#define CodebookTypeDilenskeZakazky 3005
#define CodebookTypeZbozi 3006
#; Fakturace...
#define CodebookTypeFakturacniRady 4001
#define CodebookTypeFakturacniAgendy 4002
#define CodebookTypeFakturacniTypyDokladu 4003
#define CodebookTypeFakturacniJazyky 4004
#define CodebookTypeFakturacniDoklady 4005
#define CodebookTypeFakturacniZalohy 4006
#define CodebookTypeFakturacniPolozkyArchivu 4007
#define CodebookTypeFakturacniMeny 4008
#define CodebookTypeFakturacniUzivatele 4009
#; General Mzdy...
#define CodebookTypeGeneralMzdyStrediska 5001
#define CodebookTypeGeneralMzdyKategorie 5002
#define CodebookTypeGeneralMzdyStatusy 5003
#define CodebookTypeGeneralMzdyVyplatniStrediska 5004
#define CodebookTypeGeneralMzdyZdravotniPojistovny 5007
#define CodebookTypeGeneralMzdyOdboroveUseky 5008
#define CodebookTypeGeneralMzdyProfese 5009
#define CodebookTypeGeneralMzdyCzIsco 5010
#define CodebookTypeGeneralMzdyLekari 5017
#define CodebookTypeGeneralMzdyTypyLP 5018
#define CodebookTypeGeneralMzdyTypySK 5019
#define CodebookTypeGeneralMzdyTypyRP 5021
#define CodebookTypeGeneralMzdySkupinyRP 5028
#define CodebookTypeGeneralMzdyTypyUkonceniPP 5029
#define CodebookTypeGeneralMzdyTypySS 5031
#define CodebookTypeGeneralMzdyTridy 5034
#define CodebookTypeGeneralMzdyMistaVykonuPrace 5051
#define CodebookTypeGeneralMzdyDruhyMzdy 5052
#define CodebookTypeGeneralMzdyCinnosti 5060
#define CodebookTypeGeneralMzdyLokality 5061
#define CodebookTypeGeneralMzdyDuvodyUkonceniPP 5063
#define CodebookTypeGeneralMzdyNemovitosti 5064
#define CodebookTypeGeneralMzdyTypyNem 5084
#define CodebookTypeGeneralMzdyDruhySK 5088
#define CodebookTypeGeneralMzdyDruhyPrilohy 5123
#; Prepravni kontrola...
#define CodebookTypePrKontrolaRevizori 6001
#define CodebookTypePrKontrolaTypyPokutovychBloku 6002
#; AUDO...
#define CodebookTypeAuDoZastavky 7001
#define CodebookTypeAuDoLinkySpoje 7002
#define CodebookTypeAuDoPrepravniSystemy 7003
#define CodebookTypeAuDoTurnusy 7004
#; ISYCiselniky
#define CodebookTypeISYBlizkeObce 8001 
#define CodebookTypeISYSkupinyZastavekProSlevu 8003
#define CodebookTypeISYTarifniZony 8004
#define CodebookTypeISYLinky 8005
#; MHD2...
#define CodebookTypeMHD2Cile 9001
#define CodebookTypeMHD2DuvodyPreobsazeniVozu 9002
#define CodebookTypeMHD2IDS 9003
#define CodebookTypeMHD2Kalendare 9004
#define CodebookTypeMHD2Poznamky 9005
#define CodebookTypeMHD2Pracoviste 9006
#define CodebookTypeMHD2PrepravniSystemy 9007
#define CodebookTypeMHD2SkupinyLinek 9008
#define CodebookTypeMHD2TypyProvozu 9009
#define CodebookTypeMHD2VariantyChronometrazi 9010
#define CodebookTypeMHD2Zony 9011
#define CodebookTypeMHD2Zastavky 9012
#define CodebookTypeMHD2TypySkupin 9013
#define CodebookTypeMHD2ZastavkyPodleCisel 9014
#define CodebookTypeMHD2AtributyZastavkyTrasy 9015
#define CodebookTypeMHD2AtributySpoje 9016
#define CodebookTypeMHD2Prestupy 9017
#define CodebookTypeMHD2PrejezdSpoje 9018
#define CodebookTypeMHD2Smeny 9019
#define CodebookTypeMHD2Linky 9020
#define CodebookTypeMHD2Obehy 9021

#; Mtz...
#define CodebookTypeMtzSklad 99001
#define CodebookTypeMtzPohyb 99002
#define CodebookTypeMtzMaterial 99003
#define CodebookTypeMtzJednotka 99004
#define CodebookTypeMtzZakazkyAO 99005
#define CodebookTypeMtzSkupinyMaterialu 99006
#define CodebookTypeMtzDatovePolozky 99007
#define CodebookTypeMtzVzory 99008
#define CodebookTypeMtzDruhyPhm 99009


#; Typ parametru importni sablony...
#define SpecialTypeObdobi 1
#define SpecialTypeMethod 1001
#define SpecialTypeSpecification 1002

#; Typ metody parametru importni sablony...
#define SpecialMethodTypeDefault 0
#define SpecialMethodTypeCodebook 1001001
#define SpecialMethodTypeConversion 1001002
#define SpecialMethodTypeCodebookKeys 1001003

#; Typ dat sablony...
#define TemplateDataTypeImport 1
#define TemplateDataTypeHistory 2

#; Typ oblasti dat sablony...
#define TemplateDataRangeAll 1
#define TemplateDataRangeErrorsOnly 2

#; Typ vlajky importu...
#define ImportStateFlagTypeNone 0
#define ImportStateFlagTypeSkipProcessing 1
#define ImportStateFlagTypeSkipValidating 2