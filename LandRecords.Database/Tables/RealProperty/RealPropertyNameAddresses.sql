CREATE TABLE [dbo].[RealPropertyNameAddresses]
(
	[PropertyInternalID] [numeric](7, 0) NOT NULL,
	[NameAddressID] [numeric](7, 0) NOT NULL,
	[NameTypeCode] [char](2) NULL,
	[IsBillToIndicator] [bit] NULL, 
    CONSTRAINT [PK_RealPropertyNameAddresses] PRIMARY KEY ([PropertyInternalID], [NameAddressID]), 
    CONSTRAINT [FK_RealPropertyNameAddresses_RealProperties] FOREIGN KEY ([PropertyInternalID]) REFERENCES [RealProperties]([PropertyInternalID]), 
    CONSTRAINT [FK_RealPropertyNameAddresses_NameAddresses] FOREIGN KEY ([NameAddressID]) REFERENCES [NameAddresses]([NameAddressID]), 
    CONSTRAINT [FK_RealPropertyNameAddresses_NameTypes] FOREIGN KEY ([NameTypeCode]) REFERENCES [NameTypes]([TypeCode])
)
