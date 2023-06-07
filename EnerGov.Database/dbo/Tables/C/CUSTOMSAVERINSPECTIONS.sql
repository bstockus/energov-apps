CREATE TABLE [dbo].[CUSTOMSAVERINSPECTIONS] (
    [ID]                                       CHAR (36)      NOT NULL,
    [RISPGeneralElectricCount]                 INT            NULL,
    [RISPSmokeAlarmBatteriesCount]             INT            NULL,
    [RISPSmokeAlarmOtherCount]                 INT            NULL,
    [RISPCODetectorBatteriesCount]             INT            NULL,
    [RISPCODetectorOtherCount]                 INT            NULL,
    [RISPOverFusedCount]                       INT            NULL,
    [RISPOpenWiringCount]                      INT            NULL,
    [RISPHVACVentilationCount]                 INT            NULL,
    [RISPHazardsCount]                         INT            NULL,
    [RISPExitEgressCount]                      INT            NULL,
    [RISPPlumbingCount]                        INT            NULL,
    [RISPSanitationCount]                      INT            NULL,
    [RISPExtensionCordsCount]                  INT            NULL,
    [RISPGeneralElectricComments]              NVARCHAR (MAX) NULL,
    [RISPSmokeAlarmBatteriesComments]          NVARCHAR (MAX) NULL,
    [RISPSmokeAlarmOtherComments]              NVARCHAR (MAX) NULL,
    [RISPCODetectorBatteriesComments]          NVARCHAR (MAX) NULL,
    [RISPCODetectorOtherComments]              NVARCHAR (MAX) NULL,
    [RISPOverFusedComments]                    NVARCHAR (MAX) NULL,
    [RISPOpenWiringComments]                   NVARCHAR (MAX) NULL,
    [RISPHVACVentilationComments]              NVARCHAR (MAX) NULL,
    [RISPHazardsComments]                      NVARCHAR (MAX) NULL,
    [RISPExitEgressComments]                   NVARCHAR (MAX) NULL,
    [RISPPlumbingComments]                     NVARCHAR (MAX) NULL,
    [RISPSanitationComments]                   NVARCHAR (MAX) NULL,
    [RISPExtensionCordsComments]               NVARCHAR (MAX) NULL,
    [BuildingBuilt]                            NVARCHAR (36)  NULL,
    [RISPInspectionType]                       NVARCHAR (36)  NULL,
    [RISPBuildingSold]                         BIT            NULL,
    [RISPCitationIssued]                       BIT            NULL,
    [RISPWarrantRequired]                      BIT            NULL,
    [RISPNumberOfUnits]                        INT            NULL,
    [RISPCondemnationHHUseCount]               INT            NULL,
    [RISPCondemnationHHUseComments]            NVARCHAR (MAX) NULL,
    [RISPCondemnationRehabRazeFound]           BIT            NULL,
    [RISPCondemnationRazeAndRemoveFound]       BIT            NULL,
    [RISPCondemnationRehabRazeComments]        NVARCHAR (MAX) NULL,
    [RISPCondemnationRazeAndRemoveComments]    NVARCHAR (MAX) NULL,
    [ChangeInOccupancyInformation]             BIT            NULL,
    [DescriptionOfOccupancyInformationChanges] NVARCHAR (MAX) NULL,
    [ReferToFirePrevention]                    BIT            NULL,
    [ReferToBuildingInspections]               BIT            NULL,
    [ReasonForFirePreventionReferral]          NVARCHAR (MAX) NULL,
    [ReasonForBuildingInspectionsReferral]     NVARCHAR (MAX) NULL,
    [InspectedBy]                              NVARCHAR (36)  NULL,
    [FireNumberOfApartments]                   INT            NULL,
    [FireNumberOfHotelRooms]                   INT            NULL,
    [FireCommercialSquareFootage]              FLOAT (53)     NULL,
    [FireHighLifeSafetySquareFootage]          INT            NULL,
    [ZollOccupancyID]                          NVARCHAR (50)  NULL,
    CONSTRAINT [PK_Inspections] PRIMARY KEY NONCLUSTERED ([ID] ASC) WITH (FILLFACTOR = 80)
);


GO

CREATE TRIGGER [TG_CUSTOMSAVERINSPECTIONS_UPDATE_ELASTIC] ON  CUSTOMSAVERINSPECTIONS
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
		[C].[IMINSPECTIONID] ,
        'EnerGovBusiness.Inspections.Inspection' ,
        [C].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted]
	JOIN [IMINSPECTION] AS [C] WITH (NOLOCK) ON [C].[IMINSPECTIONID] = [Inserted].[ID]
	
	UNION ALL

	SELECT 
		NEWID(),
		[IMINSPECTIONCASE].[IMINSPECTIONCASEID],
		'EnerGovBusiness.Inspections.InspectionCase',
		[IMINSPECTIONCASE].[ROWVERSION],
		GETDATE() ,
        NULL ,
		2,
		(SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted]
	JOIN [IMINSPECTIONCASE] WITH (NOLOCK) ON [IMINSPECTIONCASE].[IMINSPECTIONCASEID] = [Inserted].[ID];
END
