CREATE TABLE [dbo].[Referendums]
(
	[Id] INT NOT NULL,
	[Description] CHAR(30) NULL, 
    [DistrictCode] CHAR(6) NOT NULL, 
    [DistrictCodeType] CHAR(2) NOT NULL, 
    [YearIncreaseEnd] INT NOT NULL, 
    CONSTRAINT [PK_Referendums] PRIMARY KEY ([Id]),
	CONSTRAINT [FK_Referendums_DistrictCodes] FOREIGN KEY ([DistrictCode],[DistrictCodeType]) REFERENCES [DistrictCodes]([Code],[CodeType])
)
