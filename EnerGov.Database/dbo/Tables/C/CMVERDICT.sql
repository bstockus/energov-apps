CREATE TABLE [dbo].[CMVERDICT] (
    [CMVERDICTID]   CHAR (36)      NOT NULL,
    [NAME]          NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]   NVARCHAR (MAX) NULL,
    [LASTCHANGEDBY] CHAR (36)      NOT NULL,
    [LASTCHANGEDON] DATETIME       CONSTRAINT [DF_CMVERDICT_LASTCHANGEDON] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]    INT            CONSTRAINT [DF_CMVERDICT_ROWVERSION] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_CMVERDICT] PRIMARY KEY CLUSTERED ([CMVERDICTID] ASC),
    CONSTRAINT [FK_CMVERDICT_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [UC_CMVERDICT_NAME] UNIQUE NONCLUSTERED ([NAME] ASC)
);


GO


CREATE TRIGGER [TG_CMVERDICT_HISTORY_INSERT]
    ON [dbo].[CMVERDICT]
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
			[inserted].[CMVERDICTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Verdict Added',
			'',
			[inserted].[NAME],
			'Verdict configuration added (' + [inserted].[NAME] + ')',
			'246B673A-CE0C-4E9E-B6B7-AC39F8635663',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]
END
GO
CREATE TRIGGER [dbo].[TG_CMVERDICT_HISTORY_UPDATE] 
    ON [dbo].[CMVERDICT]
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
			[inserted].[CMVERDICTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Verdict configuration name updated (' + [inserted].[NAME] + ')',
			'246B673A-CE0C-4E9E-B6B7-AC39F8635663',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CMVERDICTID] = [inserted].[CMVERDICTID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]

	UNION ALL

	SELECT
			[inserted].[CMVERDICTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Verdict configuration description updated (' + [inserted].[NAME] + ')',
			'246B673A-CE0C-4E9E-B6B7-AC39F8635663',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CMVERDICTID] = [inserted].[CMVERDICTID]	
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')

END
GO

CREATE TRIGGER [TG_CMVERDICT_HISTORY_DELETE] 
    ON [dbo].[CMVERDICT]
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
			[deleted].[CMVERDICTID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Verdict Deleted',
			'',
			'',
			'Verdict configuration deleted (' + [deleted].[NAME] + ')',
			'246B673A-CE0C-4E9E-B6B7-AC39F8635663',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END