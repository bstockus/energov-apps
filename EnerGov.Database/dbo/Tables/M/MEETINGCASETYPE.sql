﻿CREATE TABLE [dbo].[MEETINGCASETYPE] (
    [CASETYPEID]    CHAR (36)     NOT NULL,
    [MODULEID]      INT           NOT NULL,
    [TYPEID]        CHAR (36)     NULL,
    [WORKCLASSID]   CHAR (36)     NULL,
    [LIMIT]         INT           NULL,
    [MEETINGTYPEID] CHAR (36)     NULL,
    [MODULENAME]    NVARCHAR (50) NULL,
    [TYPENAME]      NVARCHAR (50) NULL,
    [WORKCLASSNAME] NVARCHAR (50) NULL,
    CONSTRAINT [PK_MEETINGCASETYPE] PRIMARY KEY CLUSTERED ([CASETYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_MCASETYPE_MTYPE] FOREIGN KEY ([MEETINGTYPEID]) REFERENCES [dbo].[MEETINGTYPE] ([MEETINGTYPEID])
);


GO
CREATE NONCLUSTERED INDEX [MEETINGCASETYPE_IX_MEETINGTYPEID]
    ON [dbo].[MEETINGCASETYPE]([MEETINGTYPEID] ASC);


GO

CREATE TRIGGER [TG_MEETINGCASETYPE_DELETE] ON [MEETINGCASETYPE]
	AFTER DELETE
AS
BEGIN
	SET NOCOUNT ON

	INSERT INTO [HISTORYSYSTEMSETUP]
	(
		[ID],
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
			[MEETINGTYPE].[MEETINGTYPEID],
			[MEETINGTYPE].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Meeting Type Case Type Deleted',
			'',
			'',
			'Meeting Type (' + [MEETINGTYPE].[NAME] + '), Case Type (' + ISNULL([PLPLANTYPE].[PLANNAME],[PMPERMITTYPE].[NAME]) + ')',
			'EC05B099-E360-4E90-A7D1-33B39B57F7A0',
			3,
			0,
			ISNULL([PLPLANTYPE].[PLANNAME],[PMPERMITTYPE].[NAME])
	FROM	[deleted]	
	INNER JOIN MEETINGTYPE ON [deleted].[MEETINGTYPEID] = [MEETINGTYPE].[MEETINGTYPEID]
	LEFT JOIN PLPLANTYPE WITH (NOLOCK) ON [deleted].[TYPEID] = [PLPLANTYPE].[PLPLANTYPEID]
	LEFT JOIN PMPERMITTYPE WITH (NOLOCK) ON [deleted].[TYPEID] = [PMPERMITTYPE].[PMPERMITTYPEID]
END
GO

CREATE TRIGGER [dbo].[TG_MEETINGCASETYPE_UPDATE] ON [dbo].[MEETINGCASETYPE] 
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
			[MEETINGTYPE].[MEETINGTYPEID],
			[MEETINGTYPE].[ROWVERSION],
			GETUTCDATE(),
			[MEETINGTYPE].[LASTCHANGEDBY],
			'Module',
			CASE
				WHEN [deleted].[MODULEID] = 1 THEN 'Plan'
				WHEN [deleted].[MODULEID] = 2 THEN 'Permit' 
			END,
			CASE 
				WHEN [inserted].[MODULEID] = 1 THEN 'Plan' 
				WHEN [inserted].[MODULEID] = 2 THEN 'Permit' 
			END,
			'Meeting Type (' + [MEETINGTYPE].[NAME] + '), Case Type (' + ISNULL([PLPLANTYPE].[PLANNAME],[PMPERMITTYPE].[NAME]) + ')',
			'EC05B099-E360-4E90-A7D1-33B39B57F7A0',
			2,
			0,
			ISNULL([PLPLANTYPE].[PLANNAME],[PMPERMITTYPE].[NAME])
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MEETINGTYPEID] = [inserted].[MEETINGTYPEID]
			INNER JOIN MEETINGTYPE ON [inserted].[MEETINGTYPEID] = [MEETINGTYPE].[MEETINGTYPEID]
			LEFT JOIN PLPLANTYPE WITH (NOLOCK) ON [inserted].[TYPEID] = [PLPLANTYPE].[PLPLANTYPEID]
			LEFT JOIN PMPERMITTYPE WITH (NOLOCK) ON [inserted].[TYPEID] = [PMPERMITTYPE].[PMPERMITTYPEID]
	WHERE	[deleted].[MODULEID] <> [inserted].[MODULEID]
	
	UNION ALL
	SELECT
			[MEETINGTYPE].[MEETINGTYPEID],
			[MEETINGTYPE].[ROWVERSION],
			GETUTCDATE(),
			[MEETINGTYPE].[LASTCHANGEDBY],
			'Case Type',
			CASE 
			WHEN [deleted].[MODULEID] = 1 THEN ISNULL([PLPLANTYPE_DELETED].[PLANNAME],'[none]') 
			WHEN [deleted].[MODULEID] = 2 THEN ISNULL([PMPERMITTYPE_DELETED].[NAME],'[none]') END,
			CASE 
			WHEN [inserted].[MODULEID] = 1 THEN ISNULL([PLPLANTYPE_INSERTED].[PLANNAME],'[none]') 
			WHEN [inserted].[MODULEID] = 2 THEN ISNULL([PMPERMITTYPE_INSERTED].[NAME],'[none]') END,
			'Meeting Type (' + [MEETINGTYPE].[NAME] + '), Case Type (' + ISNULL([PLPLANTYPE_INSERTED].[PLANNAME],[PMPERMITTYPE_INSERTED].[NAME]) + ')',
			'EC05B099-E360-4E90-A7D1-33B39B57F7A0',
			2,
			0,
			ISNULL([PLPLANTYPE_INSERTED].[PLANNAME],[PMPERMITTYPE_INSERTED].[NAME])
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MEETINGTYPEID] = [inserted].[MEETINGTYPEID]
			INNER JOIN MEETINGTYPE ON [inserted].[MEETINGTYPEID] = [MEETINGTYPE].[MEETINGTYPEID]
			LEFT JOIN PLPLANTYPE PLPLANTYPE_INSERTED WITH (NOLOCK) ON [inserted].[TYPEID] = [PLPLANTYPE_INSERTED].[PLPLANTYPEID]
			LEFT JOIN PLPLANTYPE PLPLANTYPE_DELETED WITH (NOLOCK) ON [deleted].[TYPEID] = [PLPLANTYPE_DELETED].[PLPLANTYPEID]
			LEFT JOIN PMPERMITTYPE PMPERMITTYPE_INSERTED WITH (NOLOCK)  ON [inserted].[TYPEID] = [PMPERMITTYPE_INSERTED].[PMPERMITTYPEID]
			LEFT JOIN PMPERMITTYPE PMPERMITTYPE_DELETED  WITH (NOLOCK) ON [deleted].[TYPEID] = [PMPERMITTYPE_DELETED].[PMPERMITTYPEID]
	WHERE	ISNULL([deleted].[TYPEID],'') <> ISNULL([inserted].[TYPEID],'')
	
	UNION ALL
	SELECT
			[MEETINGTYPE].[MEETINGTYPEID],
			[MEETINGTYPE].[ROWVERSION],
			GETUTCDATE(),
			[MEETINGTYPE].[LASTCHANGEDBY],
			'Work Class',
			CASE 
			WHEN [deleted].[MODULEID] = 1 THEN ISNULL([PLPLANWORKCLASS_DELETED].[NAME],'[none]') 
			WHEN [deleted].[MODULEID] = 2 THEN ISNULL([PMPERMITWORKCLASS_DELETED].[NAME],'[none]') END,
			CASE 
			WHEN [inserted].[MODULEID] = 1 THEN ISNULL([PLPLANWORKCLASS_INSERTED].[NAME],'[none]') 
			WHEN [inserted].[MODULEID] = 2 THEN ISNULL([PMPERMITWORKCLASS_INSERTED].[NAME],'[none]') END,		
			'Meeting Type (' + [MEETINGTYPE].[NAME] + '), Case Type (' + ISNULL([PLPLANTYPE].[PLANNAME],[PMPERMITTYPE].[NAME]) + ')',
			'EC05B099-E360-4E90-A7D1-33B39B57F7A0',
			2,
			0,
			ISNULL([PLPLANTYPE].[PLANNAME],[PMPERMITTYPE].[NAME])
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MEETINGTYPEID] = [inserted].[MEETINGTYPEID]
			INNER JOIN MEETINGTYPE ON [inserted].[MEETINGTYPEID] = [MEETINGTYPE].[MEETINGTYPEID]
			LEFT JOIN PLPLANTYPE ON [inserted].[TYPEID] = [PLPLANTYPE].[PLPLANTYPEID]
			LEFT JOIN PLPLANWORKCLASS PLPLANWORKCLASS_INSERTED WITH (NOLOCK) ON [inserted].[WORKCLASSID] = [PLPLANWORKCLASS_INSERTED].[PLPLANWORKCLASSID]
			LEFT JOIN PLPLANWORKCLASS PLPLANWORKCLASS_DELETED WITH (NOLOCK) ON [deleted].[WORKCLASSID] = [PLPLANWORKCLASS_DELETED].[PLPLANWORKCLASSID]
			LEFT JOIN PMPERMITWORKCLASS PMPERMITWORKCLASS_INSERTED WITH (NOLOCK) ON [inserted].[WORKCLASSID] = [PMPERMITWORKCLASS_INSERTED].[PMPERMITWORKCLASSID]
			LEFT JOIN PMPERMITWORKCLASS PMPERMITWORKCLASS_DELETED WITH (NOLOCK) ON [deleted].[WORKCLASSID] = [PMPERMITWORKCLASS_DELETED].[PMPERMITWORKCLASSID]
			LEFT JOIN PMPERMITTYPE WITH (NOLOCK) ON [inserted].[TYPEID] = [PMPERMITTYPE].[PMPERMITTYPEID]
	WHERE	ISNULL([deleted].[WORKCLASSID],'') <> ISNULL([inserted].[WORKCLASSID],'')
	
	UNION ALL
	SELECT			
			[MEETINGTYPE].[MEETINGTYPEID],
			[MEETINGTYPE].[ROWVERSION],
			GETUTCDATE(),
			[MEETINGTYPE].[LASTCHANGEDBY],
			'Limit',
			CASE WHEN [deleted].[LIMIT] IS NULL THEN '[none]' ELSE CONVERT(NVARCHAR(MAX), [deleted].[LIMIT]) END,
			CASE WHEN [inserted].[LIMIT] IS NULL THEN '[none]' ELSE CONVERT(NVARCHAR(MAX), [inserted].[LIMIT]) END,			
			'Meeting Type (' + [MEETINGTYPE].[NAME] + '), Case Type (' + ISNULL([PLPLANTYPE].[PLANNAME],[PMPERMITTYPE].[NAME]) + ')',
			'EC05B099-E360-4E90-A7D1-33B39B57F7A0',
			2,
			0,
			ISNULL([PLPLANTYPE].[PLANNAME],[PMPERMITTYPE].[NAME])
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MEETINGTYPEID] = [inserted].[MEETINGTYPEID]
			INNER JOIN MEETINGTYPE ON [inserted].[MEETINGTYPEID] = [MEETINGTYPE].[MEETINGTYPEID]
			LEFT JOIN PLPLANTYPE WITH (NOLOCK) ON [inserted].[TYPEID] = [PLPLANTYPE].[PLPLANTYPEID]
			LEFT JOIN PMPERMITTYPE WITH (NOLOCK) ON [inserted].[TYPEID] = [PMPERMITTYPE].[PMPERMITTYPEID]
	WHERE	ISNULL([deleted].[LIMIT],'') <> ISNULL([inserted].[LIMIT],'')
END
GO

CREATE TRIGGER [TG_MEETINGCASETYPE_INSERT] ON [MEETINGCASETYPE]
	AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON

	INSERT INTO [HISTORYSYSTEMSETUP]
	(
		[ID],
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
			[MEETINGTYPE].[MEETINGTYPEID],
			[MEETINGTYPE].[ROWVERSION],
			GETUTCDATE(),
			[MEETINGTYPE].[LASTCHANGEDBY],
			'Meeting Type Case Type Added',
			'',
			'',
			'Meeting Type (' + [MEETINGTYPE].[NAME] + '), Case Type (' + ISNULL([PLPLANTYPE].[PLANNAME],[PMPERMITTYPE].[NAME]) + ')',
			'EC05B099-E360-4E90-A7D1-33B39B57F7A0',
			1,
			0,
			ISNULL([PLPLANTYPE].[PLANNAME],[PMPERMITTYPE].[NAME])
	FROM	[inserted]
	INNER JOIN MEETINGTYPE ON [inserted].[MEETINGTYPEID] = [MEETINGTYPE].[MEETINGTYPEID]
	LEFT JOIN PLPLANTYPE WITH (NOLOCK) ON [inserted].[TYPEID] = [PLPLANTYPE].[PLPLANTYPEID]
	LEFT JOIN PMPERMITTYPE WITH (NOLOCK) ON [inserted].[TYPEID] = [PMPERMITTYPE].[PMPERMITTYPEID]
END