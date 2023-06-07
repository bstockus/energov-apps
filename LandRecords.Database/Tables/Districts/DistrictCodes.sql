CREATE TABLE [dbo].[DistrictCodes]
(
	[Code] CHAR(6) NOT NULL , 
    [CodeType] CHAR(2) NOT NULL, 
    [Description] CHAR(30) NULL, 
    [IsActive] BIT NOT NULL, 
    CONSTRAINT [PK_DistrictCodes] PRIMARY KEY ([Code], [CodeType]),
	CONSTRAINT [FK_DistrictCodes_DistrictCodeTypes] FOREIGN KEY ([CodeType]) REFERENCES [DistrictCodeTypes]([CodeType])
)
