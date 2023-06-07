CREATE TABLE [dbo].[CMVIOLATIONSTATUS] (
    [CMVIOLATIONSTATUSID] CHAR (36)      NOT NULL,
    [NAME]                NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]         NVARCHAR (MAX) NULL,
    [SUCCESSFLAG]         BIT            CONSTRAINT [DF_CMViolationStatus_SuccessFlag] DEFAULT ((0)) NOT NULL,
    [DEFAULTFLAG]         BIT            CONSTRAINT [DF_CMViolationStatus_DefaultFlag] DEFAULT ((0)) NOT NULL,
    [FAILUREFLAG]         BIT            DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]       CHAR (36)      NULL,
    [LASTCHANGEDON]       DATETIME       CONSTRAINT [DF_CMViolationStatus_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]          INT            CONSTRAINT [DF_CMViolationStatus_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_CodeStatus] PRIMARY KEY CLUSTERED ([CMVIOLATIONSTATUSID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CMVIOLATIONSTATUS_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [CMVIOLATIONSTATUS_IX_QUERY]
    ON [dbo].[CMVIOLATIONSTATUS]([CMVIOLATIONSTATUSID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [TG_CMVIOLATIONSTATUS_UPDATE] ON CMVIOLATIONSTATUS
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
			[inserted].[CMVIOLATIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Violation Status (' + [inserted].[NAME] + ')',
			'BA5398B9-42FB-4A56-96ED-DADCD0401E4C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].CMVIOLATIONSTATUSID = [inserted].CMVIOLATIONSTATUSID
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[CMVIOLATIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Violation Status (' + [inserted].[NAME] + ')',
			'BA5398B9-42FB-4A56-96ED-DADCD0401E4C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].CMVIOLATIONSTATUSID = [inserted].CMVIOLATIONSTATUSID
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL
	SELECT
			[inserted].[CMVIOLATIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Flag',
			CASE [deleted].[DEFAULTFLAG] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[DEFAULTFLAG] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Violation Status (' + [inserted].[NAME] + ')',
			'BA5398B9-42FB-4A56-96ED-DADCD0401E4C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].CMVIOLATIONSTATUSID = [inserted].CMVIOLATIONSTATUSID
	WHERE	[deleted].[DEFAULTFLAG] <> [inserted].[DEFAULTFLAG]	
	UNION ALL
	SELECT
			[inserted].[CMVIOLATIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Success Flag',
			CASE [deleted].[SUCCESSFLAG] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[SUCCESSFLAG] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Violation Status (' + [inserted].[NAME] + ')',
			'BA5398B9-42FB-4A56-96ED-DADCD0401E4C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].CMVIOLATIONSTATUSID = [inserted].CMVIOLATIONSTATUSID
	WHERE	[deleted].[SUCCESSFLAG] <> [inserted].[SUCCESSFLAG]
	UNION ALL
	SELECT
			[inserted].[CMVIOLATIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Failure Flag',
			CASE WHEN [deleted].[FAILUREFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[FAILUREFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			'Violation Status (' + [inserted].[NAME] + ')',
			'BA5398B9-42FB-4A56-96ED-DADCD0401E4C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].CMVIOLATIONSTATUSID = [inserted].CMVIOLATIONSTATUSID
	WHERE	[deleted].[FAILUREFLAG] <> [inserted].[FAILUREFLAG]
END
GO


CREATE TRIGGER [TG_CMVIOLATIONSTATUS_DELETE] ON CMVIOLATIONSTATUS
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
			[deleted].[CMVIOLATIONSTATUSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Violation Status Deleted',
			'',
			'',
			'Violation Status (' + [deleted].[NAME] + ')',
			'BA5398B9-42FB-4A56-96ED-DADCD0401E4C',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [TG_CMVIOLATIONSTATUS_INSERT] ON CMVIOLATIONSTATUS
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
			[inserted].[CMVIOLATIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Violation Status Added',
			'',
			'',
			'Violation Status (' + [inserted].[NAME] + ')',
			'BA5398B9-42FB-4A56-96ED-DADCD0401E4C',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END