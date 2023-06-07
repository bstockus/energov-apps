CREATE TABLE [dbo].[RealPropertyZones]
(
	[PropertyInternalID] NUMERIC(7) NOT NULL , 
    [ZoneCodeType] CHAR(2) NOT NULL, 
    [ZoneCode] CHAR(6) NOT NULL, 
    [LocalMunicipalityCode] NUMERIC(3) NOT NULL, 
    CONSTRAINT [PK_RealPropertyZones] PRIMARY KEY ([PropertyInternalID], [ZoneCodeType], [ZoneCode], [LocalMunicipalityCode]),
    CONSTRAINT [FK_RealPropertyZones_RealProperties] FOREIGN KEY ([PropertyInternalID]) REFERENCES [RealProperties]([PropertyInternalID]), 
    CONSTRAINT [FK_RealPropertyZones_ZoneCodes] FOREIGN KEY ([ZoneCode],[ZoneCodeType],[LocalMunicipalityCode]) REFERENCES [ZoneCodes]([Code],[CodeType],[LocalMunicipalityCode])
)
