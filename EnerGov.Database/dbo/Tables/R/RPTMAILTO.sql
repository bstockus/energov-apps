﻿CREATE TABLE [dbo].[RPTMAILTO] (
    [RPTMAILTOID]      CHAR (36)      NOT NULL,
    [RPTAUTOMAILID]    CHAR (36)      NOT NULL,
    [FIRSTNAME]        NVARCHAR (50)  NULL,
    [LASTNAME]         NVARCHAR (50)  NULL,
    [GLOBALENTITYNAME] NVARCHAR (100) NULL,
    [EMAIL]            NVARCHAR (80)  NOT NULL,
    CONSTRAINT [PK_RPTMailTO] PRIMARY KEY CLUSTERED ([RPTMAILTOID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_RPTMailTO_Auto] FOREIGN KEY ([RPTAUTOMAILID]) REFERENCES [dbo].[RPTAUTOMAIL] ([RPTAUTOMAILID])
);


GO

CREATE TRIGGER [dbo].[TG_RPTMAILTO_DELETE] 
	ON [dbo].[RPTMAILTO]
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
			[RPTAUTOMAIL].[RPTAUTOMAILID],
			[RPTAUTOMAIL].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Report Recipients Deleted',
			'',
			'',
			'Report Automation (' + ISNULL([RPTAUTOMAIL].[SESSIONNAME],'[none]') + '), Report Recipients(' + ISNULL([deleted].[FIRSTNAME],'') + COALESCE(', ' + [deleted].[LASTNAME],'') + COALESCE(', ' + [deleted].[GLOBALENTITYNAME],'') + ')',
			'EBB9A3C5-8B05-4E5D-8A53-78585EB20FB5',
			3,
			0,
			ISNULL([RPTAUTOMAIL].[SESSIONNAME],'[none]')
	FROM	[deleted]
			INNER JOIN [RPTAUTOMAIL] ON [RPTAUTOMAIL].[RPTAUTOMAILID] = [deleted].[RPTAUTOMAILID]
END
GO

CREATE TRIGGER [dbo].[TG_RPTMAILTO_UPDATE] 
	ON [dbo].[RPTMAILTO]
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
			[RPTAUTOMAIL].[RPTAUTOMAILID],
			[RPTAUTOMAIL].[ROWVERSION],
			GETUTCDATE(),
			[RPTAUTOMAIL].[LASTCHANGEDBY],
			'First Name',
			ISNULL([deleted].[FIRSTNAME],'[none]'),
			ISNULL([inserted].[FIRSTNAME],'[none]'),
			'Report Automation (' + ISNULL([RPTAUTOMAIL].[SESSIONNAME],'[none]') + '), Report Recipients(' + ISNULL([inserted].[FIRSTNAME],'') + COALESCE(', ' + [inserted].[LASTNAME],'') + COALESCE(', ' + [inserted].[GLOBALENTITYNAME],'') + ')',
			'EBB9A3C5-8B05-4E5D-8A53-78585EB20FB5',
			2,
			0,
			ISNULL([RPTAUTOMAIL].[SESSIONNAME],'[none]')
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[RPTMAILTOID] = [inserted].[RPTMAILTOID]
			INNER JOIN [RPTAUTOMAIL] ON [RPTAUTOMAIL].[RPTAUTOMAILID] = [inserted].[RPTAUTOMAILID]
	WHERE	ISNULL([deleted].[FIRSTNAME],'') <> ISNULL([inserted].[FIRSTNAME],'')

	UNION ALL
	SELECT
			[RPTAUTOMAIL].[RPTAUTOMAILID],
			[RPTAUTOMAIL].[ROWVERSION],
			GETUTCDATE(),
			[RPTAUTOMAIL].[LASTCHANGEDBY],
			'Last Name',
			ISNULL([deleted].[LASTNAME],'[none]'),
			ISNULL([inserted].[LASTNAME],'[none]'),
			'Report Automation (' + ISNULL([RPTAUTOMAIL].[SESSIONNAME],'[none]') + '), Report Recipients(' + ISNULL([inserted].[FIRSTNAME],'') + COALESCE(', ' + [inserted].[LASTNAME],'') + COALESCE(', ' + [inserted].[GLOBALENTITYNAME],'') + ')',
			'EBB9A3C5-8B05-4E5D-8A53-78585EB20FB5',
			2,
			0,
			ISNULL([RPTAUTOMAIL].[SESSIONNAME],'[none]')
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[RPTMAILTOID] = [inserted].[RPTMAILTOID]
			INNER JOIN [RPTAUTOMAIL] ON [RPTAUTOMAIL].[RPTAUTOMAILID] = [inserted].[RPTAUTOMAILID]
	WHERE	ISNULL([deleted].[LASTNAME],'') <> ISNULL([inserted].[LASTNAME],'')

	UNION ALL
	SELECT
			[RPTAUTOMAIL].[RPTAUTOMAILID],
			[RPTAUTOMAIL].[ROWVERSION],
			GETUTCDATE(),
			[RPTAUTOMAIL].[LASTCHANGEDBY],
			'Company Name',
			ISNULL([deleted].[GLOBALENTITYNAME],'[none]'),
			ISNULL([inserted].[GLOBALENTITYNAME],'[none]'),
			'Report Automation (' + ISNULL([RPTAUTOMAIL].[SESSIONNAME],'[none]') + '), Report Recipients(' + ISNULL([inserted].[FIRSTNAME],'') + COALESCE(', ' + [inserted].[LASTNAME],'') + COALESCE(', ' + [inserted].[GLOBALENTITYNAME],'') + ')',
			'EBB9A3C5-8B05-4E5D-8A53-78585EB20FB5',
			2,
			0,
			ISNULL([RPTAUTOMAIL].[SESSIONNAME],'[none]')
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[RPTMAILTOID] = [inserted].[RPTMAILTOID]
			INNER JOIN [RPTAUTOMAIL] ON [RPTAUTOMAIL].[RPTAUTOMAILID] = [inserted].[RPTAUTOMAILID]
	WHERE	ISNULL([deleted].[GLOBALENTITYNAME],'') <> ISNULL([inserted].[GLOBALENTITYNAME],'')
END
GO

CREATE TRIGGER [dbo].[TG_RPTMAILTO_INSERT] 
	ON [dbo].[RPTMAILTO]
    AFTER INSERT
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
			[RPTAUTOMAIL].[RPTAUTOMAILID],
			[RPTAUTOMAIL].[ROWVERSION],
			GETUTCDATE(),
			[RPTAUTOMAIL].[LASTCHANGEDBY],
			'Report Recipients Added',
			'',
			'',
			'Report Automation (' + ISNULL([RPTAUTOMAIL].[SESSIONNAME],'[none]') + '), Report Recipients(' + ISNULL([inserted].[FIRSTNAME],'') + COALESCE(', ' + [inserted].[LASTNAME],'') + COALESCE(', ' + [inserted].[GLOBALENTITYNAME],'') + ')',
			'EBB9A3C5-8B05-4E5D-8A53-78585EB20FB5',
			1,
			0,
			ISNULL([RPTAUTOMAIL].[SESSIONNAME],'[none]')
	FROM	[inserted]
			INNER JOIN [RPTAUTOMAIL] ON [RPTAUTOMAIL].[RPTAUTOMAILID] = [inserted].[RPTAUTOMAILID]
END