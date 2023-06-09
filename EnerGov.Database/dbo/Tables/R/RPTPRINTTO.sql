﻿CREATE TABLE [dbo].[RPTPRINTTO] (
    [RPTPRINTTOID]  CHAR (36)      NOT NULL,
    [RPTAUTOMAILID] CHAR (36)      NOT NULL,
    [PRINTERPATH]   NVARCHAR (100) NOT NULL,
    [DESCRIPTION]   NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_RPTPRINTTO] PRIMARY KEY NONCLUSTERED ([RPTPRINTTOID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_RPTPRINTTO_AUTO] FOREIGN KEY ([RPTAUTOMAILID]) REFERENCES [dbo].[RPTAUTOMAIL] ([RPTAUTOMAILID])
);


GO

CREATE TRIGGER [dbo].[TG_RPTPRINTTO_DELETE] 
	ON [dbo].[RPTPRINTTO]
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
			'Printer Configurations Deleted',
			'',
			'',
			'Report Automation (' + ISNULL([RPTAUTOMAIL].[SESSIONNAME],'[none]') + '), Printer Configurations(' + ISNULL([deleted].[PRINTERPATH],'') + COALESCE(', ' + [deleted].[DESCRIPTION],'') + ')',
			'EBB9A3C5-8B05-4E5D-8A53-78585EB20FB5',
			3,
			0,
			ISNULL([RPTAUTOMAIL].[SESSIONNAME],'[none]')
	FROM	[deleted]
			INNER JOIN [RPTAUTOMAIL] ON [RPTAUTOMAIL].[RPTAUTOMAILID] = [deleted].[RPTAUTOMAILID]
END
GO

CREATE TRIGGER [dbo].[TG_RPTPRINTTO_UPDATE] 
	ON [dbo].[RPTPRINTTO]
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
			'Printer Name',
			[deleted].[PRINTERPATH],
			[inserted].[PRINTERPATH],
			'Report Automation (' + ISNULL([RPTAUTOMAIL].[SESSIONNAME],'[none]') + '), Printer Configurations(' + ISNULL([inserted].[PRINTERPATH],'') + COALESCE(', ' + [inserted].[DESCRIPTION],'') + ')',
			'EBB9A3C5-8B05-4E5D-8A53-78585EB20FB5',
			2,
			0,
			ISNULL([RPTAUTOMAIL].[SESSIONNAME],'[none]')
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[RPTPRINTTOID] = [inserted].[RPTPRINTTOID]
			INNER JOIN [RPTAUTOMAIL] ON [RPTAUTOMAIL].[RPTAUTOMAILID] = [inserted].[RPTAUTOMAILID]
	WHERE	[deleted].[PRINTERPATH] <> [inserted].[PRINTERPATH]

	UNION ALL
	SELECT
			[RPTAUTOMAIL].[RPTAUTOMAILID],
			[RPTAUTOMAIL].[ROWVERSION],
			GETUTCDATE(),
			[RPTAUTOMAIL].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Report Automation (' + ISNULL([RPTAUTOMAIL].[SESSIONNAME],'[none]') + '), Printer Configurations(' + ISNULL([inserted].[PRINTERPATH],'') + COALESCE(', ' + [inserted].[DESCRIPTION],'') + ')',
			'EBB9A3C5-8B05-4E5D-8A53-78585EB20FB5',
			2,
			0,
			ISNULL([RPTAUTOMAIL].[SESSIONNAME],'[none]')
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[RPTPRINTTOID] = [inserted].[RPTPRINTTOID]
			INNER JOIN [RPTAUTOMAIL] ON [RPTAUTOMAIL].[RPTAUTOMAILID] = [inserted].[RPTAUTOMAILID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')

END
GO

CREATE TRIGGER [dbo].[TG_RPTPRINTTO_INSERT] 
	ON [dbo].[RPTPRINTTO]
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
			'Printer Configurations Added',
			'',
			'',
			'Report Automation (' + ISNULL([RPTAUTOMAIL].[SESSIONNAME],'[none]') + '), Printer Configurations(' + ISNULL([inserted].[PRINTERPATH],'') + COALESCE(', ' + [inserted].[DESCRIPTION],'') + ')',
			'EBB9A3C5-8B05-4E5D-8A53-78585EB20FB5',
			1,
			0,
			ISNULL([RPTAUTOMAIL].[SESSIONNAME],'[none]')
	FROM	[inserted]
			INNER JOIN [RPTAUTOMAIL] ON [RPTAUTOMAIL].[RPTAUTOMAILID] = [inserted].[RPTAUTOMAILID]
END