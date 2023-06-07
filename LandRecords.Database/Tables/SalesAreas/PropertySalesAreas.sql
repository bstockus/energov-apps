CREATE TABLE [dbo].[PropertySalesAreas]
(
	[ParcelNumber] VARCHAR(15) NOT NULL, 
    [SalesArea] VARCHAR(15) NOT NULL,
	CONSTRAINT [PK_PropertySalesAreas] PRIMARY KEY ([ParcelNumber])
)

GO

CREATE INDEX [IX_PropertySalesAreas_SalesArea] ON [dbo].[PropertySalesAreas] ([SalesArea])
