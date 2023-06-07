CREATE TABLE [dbo].[ZoneCodes]
(
	[Code] CHAR(6) NOT NULL , 
    [CodeType] CHAR(2) NOT NULL, 
	[LocalMunicipalityCode] NUMERIC(3) NOT NULL,
    [Description] CHAR(30) NULL, 
    [IsActive] BIT NOT NULL, 
    CONSTRAINT [PK_ZoneCodes] PRIMARY KEY ([Code], [CodeType], [LocalMunicipalityCode]), 
    CONSTRAINT [FK_ZoneCodes_ZoneCodeTypes] FOREIGN KEY ([CodeType]) REFERENCES [ZoneCodeTypes]([CodeType])
)
