CREATE TABLE [dbo].[CMCODECASESTATUS] (
    [CMCODECASESTATUSID] CHAR (36)      NOT NULL,
    [NAME]               VARCHAR (50)   NOT NULL,
    [DESCRIPTION]        NVARCHAR (MAX) NULL,
    [SUCCESSFLAG]        BIT            CONSTRAINT [DF_CMCodeCaseStatus_SuccessFlag] DEFAULT ((0)) NOT NULL,
    [FAILUREFLAG]        BIT            CONSTRAINT [DF_CMCodeCaseStatus_FailureFlag] DEFAULT ((0)) NOT NULL,
    [CANCELLEDFLAG]      BIT            CONSTRAINT [DF_CMCodeCaseStatus_CancelledFlag] DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]      CHAR (36)      NULL,
    [LASTCHANGEDON]      DATETIME       CONSTRAINT [DF_CMCodeCaseStatus_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]         INT            CONSTRAINT [DF_CMCodeCaseStatus_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_CMCodeCaseStatus] PRIMARY KEY CLUSTERED ([CMCODECASESTATUSID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CMCODECASESTATUS_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [CMCODECASESTATUS_IX_QUERY]
    ON [dbo].[CMCODECASESTATUS]([CMCODECASESTATUSID] ASC, [NAME] ASC);


GO


CREATE TRIGGER [TG_CMCODECASESTATUS_DELETE] ON CMCODECASESTATUS
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
			[deleted].[CMCODECASESTATUSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Code Case Status Deleted',
			'',
			'',
			'Code Case Status (' + [deleted].[NAME] + ')',
			'G3AFB6FE-439F-48B0-978D-748BE8F5D52C',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [TG_CMCODECASESTATUS_INSERT] ON CMCODECASESTATUS
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
			[inserted].[CMCODECASESTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Code Case Status Added',
			'',
			'',
			'Code Case Status (' + [inserted].[NAME] + ')',
			'G3AFB6FE-439F-48B0-978D-748BE8F5D52C',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [TG_CMCODECASESTATUS_UPDATE] ON CMCODECASESTATUS
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
			[inserted].[CMCODECASESTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Code Case Status (' + [inserted].[NAME] + ')',
			'G3AFB6FE-439F-48B0-978D-748BE8F5D52C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].CMCODECASESTATUSID = [inserted].CMCODECASESTATUSID
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[CMCODECASESTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Code Case Status (' + [inserted].[NAME] + ')',
			'G3AFB6FE-439F-48B0-978D-748BE8F5D52C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].CMCODECASESTATUSID = [inserted].CMCODECASESTATUSID
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL
	SELECT
			[inserted].[CMCODECASESTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Success Flag',
			CASE [deleted].[SUCCESSFLAG] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[SUCCESSFLAG] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Code Case Status (' + [inserted].[NAME] + ')',
			'G3AFB6FE-439F-48B0-978D-748BE8F5D52C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].CMCODECASESTATUSID = [inserted].CMCODECASESTATUSID
	WHERE	[deleted].[SUCCESSFLAG] <> [inserted].[SUCCESSFLAG]
	UNION ALL
	SELECT
			[inserted].[CMCODECASESTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Failure Flag',
			CASE WHEN [deleted].[FAILUREFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[FAILUREFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			'Code Case Status (' + [inserted].[NAME] + ')',
			'G3AFB6FE-439F-48B0-978D-748BE8F5D52C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].CMCODECASESTATUSID = [inserted].CMCODECASESTATUSID
	WHERE	[deleted].[FAILUREFLAG] <> [inserted].[FAILUREFLAG]
	UNION ALL
	SELECT
			[inserted].[CMCODECASESTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Cancelled Flag',
			CASE WHEN [deleted].[CANCELLEDFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[CANCELLEDFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			'Code Case Status (' + [inserted].[NAME] + ')',
			'G3AFB6FE-439F-48B0-978D-748BE8F5D52C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].CMCODECASESTATUSID = [inserted].CMCODECASESTATUSID
	WHERE	[deleted].[CANCELLEDFLAG] <> [inserted].[CANCELLEDFLAG]	
END