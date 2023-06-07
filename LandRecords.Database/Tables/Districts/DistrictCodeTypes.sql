CREATE TABLE [dbo].[DistrictCodeTypes]
(
	[CodeType] CHAR(2) NOT NULL, 
    [Description] CHAR(25) NULL, 
    [UsageIndicator] CHAR NULL, 
    [IsTaxationIndicator] BIT NOT NULL, 
    [IncludeInAssessmentProcess] BIT NOT NULL,
	CONSTRAINT [PK_DistrictCodeTypes] PRIMARY KEY ([CodeType])
)
