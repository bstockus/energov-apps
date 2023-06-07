CREATE TABLE [dbo].[RealPropertyDistricts]
(
	[PropertyInternalID] NUMERIC(7) NOT NULL , 
    [DistrictCodeType] CHAR(2) NOT NULL, 
    [DistrictCode] CHAR(6) NOT NULL, 
    CONSTRAINT [PK_RealPropertyDistricts] PRIMARY KEY ([PropertyInternalID], [DistrictCodeType], [DistrictCode]),
    CONSTRAINT [FK_RealPropertyDistricts_RealProperties] FOREIGN KEY ([PropertyInternalID]) REFERENCES [RealProperties]([PropertyInternalID]), 
    CONSTRAINT [FK_RealPropertyDistricts_DistrictCodes] FOREIGN KEY ([DistrictCode],[DistrictCodeType]) REFERENCES [DistrictCodes]([Code],[CodeType])
)
