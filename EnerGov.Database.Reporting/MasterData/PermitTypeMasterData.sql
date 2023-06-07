CREATE TABLE [laxmasterdata].[PermitTypeMasterData] (
	[PermitTypeId] CHAR(36) NOT NULL, 
    [PermitWorkClassId] CHAR(36) NOT NULL, 
    [Department] NVARCHAR(100) NOT NULL, 
    [PermitCategory] NVARCHAR(100) NOT NULL, 
    [PermitType] NVARCHAR(100) NOT NULL, 
    [PermitClass] NVARCHAR(100) NOT NULL, 
    [FixedNumberOfDwellingUnits] INT NOT NULL, 
    [IsNewConstruction] BIT NOT NULL, 
    [SpecialHandlingCode] NVARCHAR(36) NOT NULL, 
    [SquareFootageType] CHAR NULL, 
    [SummaryGroup] NVARCHAR(100) NULL, 
    [SummaryClass] NVARCHAR(100) NULL, 
    [SummaryWorkClass] NVARCHAR(50) NULL, 
    [MechanicalIsNewHandling] CHAR NOT NULL, 
    CONSTRAINT [PK_PermitTypeMasterData] PRIMARY KEY ([PermitTypeId], [PermitWorkClassId], [SpecialHandlingCode], [MechanicalIsNewHandling])
)
