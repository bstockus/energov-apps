CREATE TABLE [dbo].[RealPropertyLegalDescriptions]
(
	[PropertyInternalID] [numeric](7, 0) NOT NULL,
	[LegalDescription] [varchar](max) NULL, 
    CONSTRAINT [PK_RealPropertyLegalDescriptions] PRIMARY KEY ([PropertyInternalID]),
	CONSTRAINT [FK_RealPropertyLegalDescriptions_RealProperties] FOREIGN KEY ([PropertyInternalID]) REFERENCES [RealProperties]([PropertyInternalID])
)
