CREATE TABLE [dbo].[NameAddresses]
(
	[LastName] [varchar](50) NULL,
	[FirstName] [varchar](50) NULL,
	[StreetName] [varchar](50) NULL,
	[StreetPrefixDirectional] [varchar](50) NULL,
	[StreetSuffixDirectional] [varchar](50) NULL,
	[HouseNumber] [varchar](50) NULL,
	[StreetSecondaryNumber] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[ZipCode] [varchar](50) NULL,
	[DeliveryPointBarCode] [numeric](2, 0) NULL,
	[DPBCCheckDigit] [numeric](1, 0) NULL,
	[CountryCode] [varchar](50) NULL,
	[StreetType] [varchar](50) NULL,
	[SecondaryType] [varchar](50) NULL,
	[NameAddressID] [numeric](7, 0) NOT NULL,
	[IsBusiness] [bit] NULL, 
    CONSTRAINT [PK_NameAddresses] PRIMARY KEY ([NameAddressID])
)
