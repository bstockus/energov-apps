CREATE TABLE [dbo].[RealPropertyAddresses]
(
	[PropertyInternalID] [numeric](7, 0) NOT NULL,
	[PropertyAddressID] [numeric](7, 0) NOT NULL, 
    CONSTRAINT [PK_RealPropertyAddresses] PRIMARY KEY ([PropertyInternalID], [PropertyAddressID]), 
    CONSTRAINT [FK_RealPropertyAddresses_RealProperties] FOREIGN KEY ([PropertyInternalID]) REFERENCES [RealProperties]([PropertyInternalID]), 
    CONSTRAINT [FK_RealPropertyAddresses_PropertyAddresses] FOREIGN KEY ([PropertyAddressID]) REFERENCES [PropertyAddresses]([PropertyAddressID])
)
