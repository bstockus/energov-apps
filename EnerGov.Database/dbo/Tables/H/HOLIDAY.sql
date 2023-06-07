CREATE TABLE [dbo].[HOLIDAY] (
    [HOLIDAYID]     CHAR (36)      NOT NULL,
    [NAME]          NVARCHAR (100) NOT NULL,
    [HOLIDAYDATE]   DATETIME       NOT NULL,
    [LASTCHANGEDBY] CHAR (36)      NULL,
    [LASTCHANGEDON] DATETIME       CONSTRAINT [DF_Holiday_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]    INT            CONSTRAINT [DF_Holiday_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Holiday] PRIMARY KEY CLUSTERED ([HOLIDAYID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_HOLIDAY_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [HOLIDAY_IX_QUERY]
    ON [dbo].[HOLIDAY]([HOLIDAYID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [TG_HOLIDAY_DELETE] ON HOLIDAY
   AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;

    INSERT INTO [HISTORYSYSTEMSETUP]
    (	[ID],
		[ROWVERSION],
		[CHANGEDON],
		[CHANGEDBY],
		[FIELDNAME],
		[OLDVALUE],
		[NEWVALUE],
		[ADDITIONALINFO],
		[FORMID],
		[ACTION],
		[ISROOT],
		[RECORDNAME]
    )

	SELECT
			[deleted].[HOLIDAYID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Holiday Deleted',
			'',
			'',
			'Holiday (' + [deleted].[NAME] + ')',
			'DEBCDF67-43A5-49EB-BBB4-F1FB99F0A14E',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO


CREATE TRIGGER [TG_HOLIDAY_INSERT] ON HOLIDAY
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;

    INSERT INTO [HISTORYSYSTEMSETUP]
    (	[ID],
		[ROWVERSION],
		[CHANGEDON],
		[CHANGEDBY],
		[FIELDNAME],
		[OLDVALUE],
		[NEWVALUE],
		[ADDITIONALINFO],
		[FORMID],
		[ACTION],
		[ISROOT],
		[RECORDNAME]
    )

	SELECT
			[inserted].[HOLIDAYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Holiday Added',
			'',
			'',
			'Holiday (' + [inserted].[NAME] + ')',
			'DEBCDF67-43A5-49EB-BBB4-F1FB99F0A14E',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [TG_HOLIDAY_UPDATE] ON HOLIDAY
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

    INSERT INTO [HISTORYSYSTEMSETUP]
    (	[ID],
		[ROWVERSION],
		[CHANGEDON],
		[CHANGEDBY],
		[FIELDNAME],
		[OLDVALUE],
		[NEWVALUE],
		[ADDITIONALINFO],
		[FORMID],
		[ACTION],
		[ISROOT],
		[RECORDNAME]
    )

	SELECT
			[inserted].[HOLIDAYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Holiday (' + [inserted].[NAME] + ')',
			'DEBCDF67-43A5-49EB-BBB4-F1FB99F0A14E',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[HOLIDAYID] = [inserted].[HOLIDAYID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]	
	UNION ALL
	SELECT
			[inserted].[HOLIDAYID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Date',
			CONVERT(NVARCHAR(MAX), [deleted].[HOLIDAYDATE], 101),
			CONVERT(NVARCHAR(MAX), [inserted].[HOLIDAYDATE], 101),
			'Holiday (' + [inserted].[NAME] + ')',
			'DEBCDF67-43A5-49EB-BBB4-F1FB99F0A14E',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[HOLIDAYID] = [inserted].[HOLIDAYID]
	WHERE	[deleted].[HOLIDAYDATE] <> [inserted].[HOLIDAYDATE]	
END