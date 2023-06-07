CREATE TABLE [dbo].[RealPropertySplitMergeHistory]
(
	[OriginalPropertyInternalID] NUMERIC(7) NOT NULL,
	[NewPropertyInternalID] NUMERIC(7) NOT NULL,
	[PropertyTransferDate] DATETIME NOT NULL,
	[ChangeIndicatorCode] INT, 
    CONSTRAINT [FK_RealPropertySplitMergeHistory_RealProperties_Original] FOREIGN KEY ([OriginalPropertyInternalID]) REFERENCES [RealProperties]([PropertyInternalID]),
	CONSTRAINT [FK_RealPropertySplitMergeHistory_RealProperties_New] FOREIGN KEY ([NewPropertyInternalID]) REFERENCES [RealProperties]([PropertyInternalID]),
	CONSTRAINT [FK_RealPropertySplitMergeHistory_ChangeIndicatorCodes] FOREIGN KEY ([ChangeIndicatorCode]) REFERENCES [ChangeIndicatorCodes]([ChangeIndicatorCode]), 
    CONSTRAINT [PK_RealPropertySplitMergeHistory] PRIMARY KEY ([OriginalPropertyInternalID], [NewPropertyInternalID], [PropertyTransferDate])
)
