CREATE TABLE [dbo].[CUSTOMSAVERLICENSEMANAGEMENT] (
    [ID]                                               CHAR (36)      NOT NULL,
    [AlcoholLicenseType]                               NVARCHAR (36)  NULL,
    [BeerGardenLicenseType]                            NVARCHAR (36)  NULL,
    [ServerTrainingQuestion]                           NVARCHAR (36)  NULL,
    [ApplicantEmployeeAgentQuestion]                   NVARCHAR (36)  NULL,
    [PremiseDescriptionQuestion]                       NVARCHAR (MAX) NULL,
    [OtherInterestQuestion]                            NVARCHAR (36)  NULL,
    [CorpStateQuestion]                                NVARCHAR (50)  NULL,
    [CorpDateQuestion]                                 DATETIME       NULL,
    [SubsidiaryCompanyQuestion]                        NVARCHAR (36)  NULL,
    [InterestInOtherCompanyQuestion]                   NVARCHAR (36)  NULL,
    [PreviousLicensedPremiseQuestion]                  NVARCHAR (36)  NULL,
    [PreviousLicenseeQuestion]                         NVARCHAR (MAX) NULL,
    [SpecialOccupationalTaxQuestion]                   NVARCHAR (36)  NULL,
    [SellerPermitQuestion]                             NVARCHAR (36)  NULL,
    [BuyFromWholesalerQuestion]                        NVARCHAR (36)  NULL,
    [WISellersPermitNbr]                               NVARCHAR (50)  NULL,
    [BeerGardenDescription]                            NVARCHAR (MAX) NULL,
    [OutdoorCabaretDescription]                        NVARCHAR (MAX) NULL,
    [IndoorCabaretDescription]                         NVARCHAR (MAX) NULL,
    [CabaretLicenseType]                               NVARCHAR (36)  NULL,
    [OtherBusinessConductedOnPremise]                  NVARCHAR (MAX) NULL,
    [OutdoorCabaretNatureofEntertainment]              NVARCHAR (MAX) NULL,
    [IndoorCabaretNatureofEntertainment]               NVARCHAR (MAX) NULL,
    [RenewalBuyFromWholesalerQuestion]                 NVARCHAR (36)  NULL,
    [PremiseDescriptionStorageQuestion]                NVARCHAR (MAX) NULL,
    [RenewalPremiseDescriptionSalesAndServiceQuestion] NVARCHAR (MAX) NULL,
    [RenewalPremiseStorageAreaQuestion]                NVARCHAR (MAX) NULL,
    [RenewalNewConvictionQuestion]                     NVARCHAR (36)  NULL,
    [RenewalNewConvictionExplainQuestion]              NVARCHAR (MAX) NULL,
    [RenewalPendingChargesQuestion]                    NVARCHAR (36)  NULL,
    [RenewalPendingChargesExplainQuestion]             NVARCHAR (MAX) NULL,
    [MonthsToProRate]                                  INT            NULL,
    [DWDCertificateOfRegistrationRequired]             BIT            NULL,
    [DWDCertificateOfRegistrationProvidedDate]         DATETIME       NULL,
    [DWDCertificateOfRegistrationStampedDate]          DATETIME       NULL,
    [NatureOfBusiness]                                 NVARCHAR (MAX) NULL,
    [YearsInBusiness]                                  INT            NULL,
    [LocalAddressAndTelephone]                         NVARCHAR (MAX) NULL,
    [SellersLocationInLaCrosse]                        NVARCHAR (MAX) NULL,
    [SellersDateInLaCrosse]                            DATETIME       NULL,
    [PastLocation1Date]                                DATETIME       NULL,
    [PastLocation2Date]                                DATETIME       NULL,
    [PastLocation3Date]                                DATETIME       NULL,
    [PastLocation1Where]                               NVARCHAR (MAX) NULL,
    [PastLocation2Where]                               NVARCHAR (MAX) NULL,
    [PastLocation3Where]                               NVARCHAR (MAX) NULL,
    [NumberOfLots]                                     INT            NULL,
    [LocationsWhereBusinessWillBeConducted]            NVARCHAR (MAX) NULL,
    [StartDate]                                        DATETIME       NULL,
    [Times]                                            NVARCHAR (50)  NULL,
    [DescriptionOfFoodBeingOffered]                    NVARCHAR (MAX) NULL,
    [StandSizeAndDimensions]                           NVARCHAR (MAX) NULL,
    [VehicleState]                                     NVARCHAR (50)  NULL,
    [VehicleMake]                                      NVARCHAR (50)  NULL,
    [VehicleModel]                                     NVARCHAR (50)  NULL,
    [VehicleYear]                                      INT            NULL,
    [VehicleLicenseNumber]                             NVARCHAR (50)  NULL,
    [PastMunicipality1Date]                            DATETIME       NULL,
    [PastMunicipality2Date]                            DATETIME       NULL,
    [PastMunicipality3Date]                            DATETIME       NULL,
    [PastMunicipality4Date]                            DATETIME       NULL,
    [PastMunicipality5Date]                            DATETIME       NULL,
    [PastMunicipality1Where]                           NVARCHAR (50)  NULL,
    [PastMunicipality2Where]                           NVARCHAR (50)  NULL,
    [PastMunicipality3Where]                           NVARCHAR (50)  NULL,
    [PastMunicipality4Where]                           NVARCHAR (50)  NULL,
    [PastMunicipality5Where]                           NVARCHAR (50)  NULL,
    [JunkDealerLicenseType]                            NVARCHAR (36)  NULL,
    [KindOfMaterialToBeHandled]                        NVARCHAR (MAX) NULL,
    [DetailedNatureOfBusiness]                         NVARCHAR (MAX) NULL,
    [NumberOfIDCards]                                  INT            NULL,
    [DirectSellersLicenseType]                         NVARCHAR (36)  NULL,
    [RecyclingFacilityType]                            NVARCHAR (36)  NULL,
    [SecondhandLicenseType]                            NVARCHAR (36)  NULL,
    [DescriptionOfVehicle]                             NVARCHAR (MAX) NULL,
    [EngagedInCleaningWasteQuestion]                   NVARCHAR (36)  NULL,
    [NameOfMobileHomePark]                             NVARCHAR (MAX) NULL,
    [Screens500OrUnder]                                INT            NULL,
    [Screens500To1000]                                 INT            NULL,
    [ScreensOver1000]                                  INT            NULL,
    [PastConvictionsQuestion]                          NVARCHAR (36)  NULL,
    [PastConvictionsDescription]                       NVARCHAR (MAX) NULL,
    [InsuranceCarrierAgent]                            NVARCHAR (MAX) NULL,
    [InsuranceAddress]                                 NVARCHAR (MAX) NULL,
    [InsuranceTelephone]                               NVARCHAR (50)  NULL,
    [InsuranceEmail]                                   NVARCHAR (50)  NULL,
    [MethodOfCharging]                                 NVARCHAR (36)  NULL,
    [ScheduleOfRates]                                  NVARCHAR (MAX) NULL,
    [NumberOfVehiclesToBeLicensed]                     INT            NULL,
    [NumberofClassCLicenses]                           INT            NULL,
    [NumberOfClassALicenses]                           INT            NULL,
    [NumberOfClassBLicenses]                           INT            NULL,
    [FireNumberOfApartments]                           INT            NULL,
    [FireNumberOfHotelRooms]                           INT            NULL,
    [FireCommercialSquareFootage]                      FLOAT (53)     NULL,
    [FireHighLifeSafetySquareFootage]                  INT            NULL,
    [ZollOccupancyID]                                  NVARCHAR (50)  NULL,
    [IsBilledOccupancy]                                BIT            NULL,
    [ClerksCompanyType]                                NVARCHAR (36)  NULL,
    [CorporationRegistrationState]                     NVARCHAR (50)  NULL,
    [CorporationRegistrationType]                      NVARCHAR (36)  NULL,
    [CorporationRegistrationDate]                      DATETIME       NULL,
    JunkDealer1000FootWaiver                         bit,
    JunkWaiverExpirationDate                         datetime,
    CONSTRAINT [PK_LicenseManagement] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE TRIGGER [TG_CUSTOMSAVERLICENSEMANAGEMENT_UPDATE_ELASTIC_LICENSE] ON  CUSTOMSAVERLICENSEMANAGEMENT
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

    INSERT INTO [ELASTICSEARCHOBJECT]
    ( [ELASTICSEARCHOBJECTID] ,
        [OBJECTID] ,
        [OBJECTCLASSNAME] ,
        [ROWVERSION] ,
        [CREATEDATE] ,
        [PROCESSEDDATE] ,
        [OBJECTACTION] ,
        [INDEXNAME]
    )
	SELECT
		NEWID() ,
		[B].[BLLICENSEID] ,
        'EnerGovBusiness.BusinessLicense.BusinessLicense' ,
        [B].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted]
	JOIN [BLLICENSE] AS [B] WITH (NOLOCK) ON [B].[BLLICENSEID] = [Inserted].[ID];

END

GO

CREATE TRIGGER [TG_CUSTOMSAVERLICENSEMANAGEMENT_UPDATE_ELASTIC_BUSINESS] ON  CUSTOMSAVERLICENSEMANAGEMENT
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

    INSERT INTO [ELASTICSEARCHOBJECT]
    ( [ELASTICSEARCHOBJECTID] ,
        [OBJECTID] ,
        [OBJECTCLASSNAME] ,
        [ROWVERSION] ,
        [CREATEDATE] ,
        [PROCESSEDDATE] ,
        [OBJECTACTION] ,
        [INDEXNAME]
    )
	SELECT
		NEWID() ,
		[B].[BLGLOBALENTITYEXTENSIONID] ,
        'EnerGovBusiness.BusinessLicense.BusinessLicenseGlobalEntityExtension' ,
        [B].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted]
	JOIN [BLGLOBALENTITYEXTENSION] AS [B] WITH (NOLOCK) ON [B].[BLGLOBALENTITYEXTENSIONID] = [Inserted].[ID];

END
