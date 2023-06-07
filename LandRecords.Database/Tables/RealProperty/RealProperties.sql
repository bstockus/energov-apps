CREATE TABLE [dbo].[RealProperties]
(
	[PropertyInternalID] [numeric](7, 0) NOT NULL,
	[LocalMunicipalityCode] [numeric](3, 0) NOT NULL,
	[MiddleParcelNumber] [numeric](6, 0) NOT NULL,
	[RightParcelNumber] [numeric](3, 0) NOT NULL,
	[Section] [char](2) NULL,
	[Township] [char](3) NULL,
	[Range] [char](2) NULL,
	[QuarterQuarter] [char](2) NULL,
	[PinParcelIdentifier] [char](4) NULL,
	[TotalAcreage] [numeric](7, 3) NULL,
	[PropertyChangedIndicator] [char](1) NULL,
	[PropertyTaxableCurrentYear] [bit] NULL,
	[IsHistory] [bit] NULL,
	[InitialTaxYear] [int] NOT NULL,
	[FinalTaxYear] [int] NOT NULL, 
    CONSTRAINT [PK_RealProperties] PRIMARY KEY ([PropertyInternalID])
)
