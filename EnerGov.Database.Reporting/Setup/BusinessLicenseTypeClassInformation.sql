CREATE TABLE [laxreports].[BusinessLicenseTypeClassInformation]
(
	[LicenseTypeId] CHAR(36) NOT NULL, 
    [LicenseClassId] CHAR(36) NOT NULL,
	[PickListItemId] CHAR(36) NOT NULL DEFAULT '',
	[DisplayName] VARCHAR(255) NOT NULL,
	[UseAlcoholPremiseDescription] BIT NOT NULL DEFAULT 0,
	[UseBeerGardenPremiseDescription] BIT NOT NULL DEFAULT 0,
	[UseIndoorCabaretDescription] BIT NOT NULL DEFAULT 0,
	[UseOutdoorCabaretDescription] BIT NOT NULL DEFAULT 0,
	[UseAgentName] BIT NOT NULL DEFAULT 0, 
	[UseJunkDealerLogic] BIT NOT NULL DEFAULT 0,
	[UseRecyclingFacilityLicenseSubClass] BIT NOT NULL DEFAULT 0,
	[UseSecondhandLicenseLogic] BIT NOT NULL DEFAULT 0,
	[AdditionalText] NVARCHAR(MAX) NOT NULL DEFAULT '',
    CONSTRAINT [PK_BusinessLicenseTypeClassInformation] PRIMARY KEY ([LicenseTypeId], [LicenseClassId], [PickListItemId])
)
