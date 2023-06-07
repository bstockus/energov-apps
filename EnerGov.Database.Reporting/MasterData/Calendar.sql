CREATE TABLE [laxmasterdata].[Calendar]
(
	DateKey             INT         NOT NULL,
	[Date]              DATE        NOT NULL,
    CONSTRAINT [PK_Calendar] PRIMARY KEY ([DateKey])
)

GO

CREATE INDEX [IX_Calendar_Date] ON [laxmasterdata].[Calendar] ([Date])