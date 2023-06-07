CREATE TABLE [dbo].[PropertyAddresses]
(
	[PropertyAddressID] [numeric](7, 0) NOT NULL,
	[PropertyStreetName] [varchar](28) NULL,
	[PropertyStreetPrefixDirectional] [varchar](2) NULL,
	[PropertyStreetType] [char](4) NULL,
	[PropertyStreetSuffixDirectional] [varchar](2) NULL,
	[PropertyHouseNumber] [varchar](10) NULL,
	[PropertySecondaryType] [varchar](4) NULL,
	[PropertySecondaryNumber] [varchar](6) NULL,
	[PropertyCity] [varchar](28) NULL,
	[PropertyState] [varchar](2) NULL,
	[PropertyZipCode] [varchar](9) NULL, 
    CONSTRAINT [PK_PropertyAddresses] PRIMARY KEY ([PropertyAddressID])
)
