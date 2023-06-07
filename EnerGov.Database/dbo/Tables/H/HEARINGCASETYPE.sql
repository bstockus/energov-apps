﻿CREATE TABLE [dbo].[HEARINGCASETYPE] (
    [CASETYPEID]    CHAR (36)     NOT NULL,
    [MODULEID]      INT           NOT NULL,
    [TYPEID]        CHAR (36)     NULL,
    [WORKCLASSID]   CHAR (36)     NULL,
    [LIMIT]         INT           NULL,
    [HEARINGTYPEID] CHAR (36)     NULL,
    [MODULENAME]    NVARCHAR (50) NULL,
    [TYPENAME]      NVARCHAR (50) NULL,
    [WORKCLASSNAME] NVARCHAR (50) NULL,
    CONSTRAINT [PK_HEARINGCASETYPE] PRIMARY KEY CLUSTERED ([CASETYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_HCASETYPE_HTYPE] FOREIGN KEY ([HEARINGTYPEID]) REFERENCES [dbo].[HEARINGTYPE] ([HEARINGTYPEID])
);


GO
CREATE NONCLUSTERED INDEX [HEARINGCASETYPE_IX_HEARINGTYPEID]
    ON [dbo].[HEARINGCASETYPE]([HEARINGTYPEID] ASC);


GO

CREATE TRIGGER [TG_HEARINGCASETYPE_DELETE] ON [HEARINGCASETYPE]
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
			[HEARINGTYPE].[HEARINGTYPEID],
			[HEARINGTYPE].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Hearing Type Case Type Deleted',
			'',
			'',
			'Hearing Type (' + [HEARINGTYPE].[NAME] + '), Case Type (' + ISNULL([PLPLANTYPE].[PLANNAME],[PMPERMITTYPE].[NAME]) + ')',
			'D2EF914D-EACD-4AA2-AF1B-6B2E30AE074B',
			3,
			0,
			ISNULL([PLPLANTYPE].[PLANNAME],[PMPERMITTYPE].[NAME])
	FROM	[deleted]	
	INNER JOIN HEARINGTYPE ON [deleted].[HEARINGTYPEID] = [HEARINGTYPE].[HEARINGTYPEID]
	LEFT JOIN PLPLANTYPE WITH (NOLOCK) ON [deleted].[TYPEID] = [PLPLANTYPE].[PLPLANTYPEID]
	LEFT JOIN PMPERMITTYPE WITH (NOLOCK) ON [deleted].[TYPEID] = [PMPERMITTYPE].[PMPERMITTYPEID]
END
GO

CREATE TRIGGER [dbo].[TG_HEARINGCASETYPE_UPDATE] ON [dbo].[HEARINGCASETYPE] 
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
			[HEARINGTYPE].[HEARINGTYPEID],
			[HEARINGTYPE].[ROWVERSION],
			GETUTCDATE(),
			[HEARINGTYPE].[LASTCHANGEDBY],
			'Module',
			CASE
				WHEN [deleted].[MODULEID] = 1 THEN 'Plan'
				WHEN [deleted].[MODULEID] = 2 THEN 'Permit' 
			END,
			CASE 
				WHEN [inserted].[MODULEID] = 1 THEN 'Plan' 
				WHEN [inserted].[MODULEID] = 2 THEN 'Permit' 
			END,
			'Hearing Type (' + [HEARINGTYPE].[NAME] + '), Case Type (' + ISNULL([PLPLANTYPE].[PLANNAME],[PMPERMITTYPE].[NAME]) + ')',
			'D2EF914D-EACD-4AA2-AF1B-6B2E30AE074B',
			2,
			0,
			ISNULL([PLPLANTYPE].[PLANNAME],[PMPERMITTYPE].[NAME])
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[HEARINGTYPEID] = [inserted].[HEARINGTYPEID]
			INNER JOIN HEARINGTYPE ON [inserted].[HEARINGTYPEID] = [HEARINGTYPE].[HEARINGTYPEID]
			LEFT JOIN PLPLANTYPE WITH (NOLOCK) ON [inserted].[TYPEID] = [PLPLANTYPE].[PLPLANTYPEID]
			LEFT JOIN PMPERMITTYPE WITH (NOLOCK) ON [inserted].[TYPEID] = [PMPERMITTYPE].[PMPERMITTYPEID]
	WHERE	[deleted].[MODULEID] <> [inserted].[MODULEID]
	UNION ALL

SELECT
			[HEARINGTYPE].[HEARINGTYPEID],
			[HEARINGTYPE].[ROWVERSION],
			GETUTCDATE(),
			[HEARINGTYPE].[LASTCHANGEDBY],
			'Case Type',
			CASE 
			WHEN [deleted].[MODULEID] = 1 THEN ISNULL([PLPLANTYPE_DELETED].[PLANNAME],'[none]') 
			WHEN [deleted].[MODULEID] = 2 THEN ISNULL([PMPERMITTYPE_DELETED].[NAME],'[none]') END,
			CASE 
			WHEN [inserted].[MODULEID] = 1 THEN ISNULL([PLPLANTYPE_INSERTED].[PLANNAME],'[none]') 
			WHEN [inserted].[MODULEID] = 2 THEN ISNULL([PMPERMITTYPE_INSERTED].[NAME],'[none]') END,
			'Hearing Type (' + [HEARINGTYPE].[NAME] + '), Case Type (' + ISNULL([PLPLANTYPE_INSERTED].[PLANNAME],[PMPERMITTYPE_INSERTED].[NAME]) + ')',
			'D2EF914D-EACD-4AA2-AF1B-6B2E30AE074B',
			2,
			0,
			ISNULL([PLPLANTYPE_INSERTED].[PLANNAME],[PMPERMITTYPE_INSERTED].[NAME])
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[HEARINGTYPEID] = [inserted].[HEARINGTYPEID]
			INNER JOIN HEARINGTYPE ON [inserted].[HEARINGTYPEID] = [HEARINGTYPE].[HEARINGTYPEID]
			LEFT JOIN PLPLANTYPE PLPLANTYPE_INSERTED WITH (NOLOCK) ON [inserted].[TYPEID] = [PLPLANTYPE_INSERTED].[PLPLANTYPEID]
			LEFT JOIN PLPLANTYPE PLPLANTYPE_DELETED WITH (NOLOCK) ON [deleted].[TYPEID] = [PLPLANTYPE_DELETED].[PLPLANTYPEID]
			LEFT JOIN PMPERMITTYPE PMPERMITTYPE_INSERTED WITH (NOLOCK)  ON [inserted].[TYPEID] = [PMPERMITTYPE_INSERTED].[PMPERMITTYPEID]
			LEFT JOIN PMPERMITTYPE PMPERMITTYPE_DELETED  WITH (NOLOCK) ON [deleted].[TYPEID] = [PMPERMITTYPE_DELETED].[PMPERMITTYPEID]
	WHERE	ISNULL([deleted].[TYPEID],'') <> ISNULL([inserted].[TYPEID],'')
	UNION ALL

	SELECT
			[HEARINGTYPE].[HEARINGTYPEID],
			[HEARINGTYPE].[ROWVERSION],
			GETUTCDATE(),
			[HEARINGTYPE].[LASTCHANGEDBY],
			'Work Class',
			CASE 
			WHEN [deleted].[MODULEID] = 1 THEN ISNULL([PLPLANWORKCLASS_DELETED].[NAME],'[none]') 
			WHEN [deleted].[MODULEID] = 2 THEN ISNULL([PMPERMITWORKCLASS_DELETED].[NAME],'[none]') END,
			CASE 
			WHEN [inserted].[MODULEID] = 1 THEN ISNULL([PLPLANWORKCLASS_INSERTED].[NAME],'[none]') 
			WHEN [inserted].[MODULEID] = 2 THEN ISNULL([PMPERMITWORKCLASS_INSERTED].[NAME],'[none]') END,		
			'Hearing Type (' + [HEARINGTYPE].[NAME] + '), Case Type (' + ISNULL([PLPLANTYPE].[PLANNAME],[PMPERMITTYPE].[NAME]) + ')',
			'D2EF914D-EACD-4AA2-AF1B-6B2E30AE074B',
			2,
			0,
			ISNULL([PLPLANTYPE].[PLANNAME],[PMPERMITTYPE].[NAME])
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[HEARINGTYPEID] = [inserted].[HEARINGTYPEID]
			INNER JOIN HEARINGTYPE ON [inserted].[HEARINGTYPEID] = [HEARINGTYPE].[HEARINGTYPEID]
			LEFT JOIN PLPLANTYPE WITH (NOLOCK) ON  [inserted].[TYPEID] = [PLPLANTYPE].[PLPLANTYPEID]
			LEFT JOIN PLPLANWORKCLASS PLPLANWORKCLASS_INSERTED WITH (NOLOCK) ON [inserted].[WORKCLASSID] = [PLPLANWORKCLASS_INSERTED].[PLPLANWORKCLASSID]
			LEFT JOIN PLPLANWORKCLASS PLPLANWORKCLASS_DELETED WITH (NOLOCK) ON [deleted].[WORKCLASSID] = [PLPLANWORKCLASS_DELETED].[PLPLANWORKCLASSID]
			LEFT JOIN PMPERMITWORKCLASS PMPERMITWORKCLASS_INSERTED WITH (NOLOCK) ON [inserted].[WORKCLASSID] = [PMPERMITWORKCLASS_INSERTED].[PMPERMITWORKCLASSID]
			LEFT JOIN PMPERMITWORKCLASS PMPERMITWORKCLASS_DELETED WITH (NOLOCK) ON [deleted].[WORKCLASSID] = [PMPERMITWORKCLASS_DELETED].[PMPERMITWORKCLASSID]
			LEFT JOIN PMPERMITTYPE WITH (NOLOCK) ON [inserted].[TYPEID] = [PMPERMITTYPE].[PMPERMITTYPEID]
	WHERE	ISNULL([deleted].[WORKCLASSID],'') <> ISNULL([inserted].[WORKCLASSID],'')
	UNION ALL

	SELECT			
			[HEARINGTYPE].[HEARINGTYPEID],
			[HEARINGTYPE].[ROWVERSION],
			GETUTCDATE(),
			[HEARINGTYPE].[LASTCHANGEDBY],
			'Limit',
			CASE WHEN [deleted].[LIMIT] IS NULL THEN '[none]' ELSE CONVERT(NVARCHAR(MAX), [deleted].[LIMIT]) END,
			CASE WHEN [inserted].[LIMIT] IS NULL THEN '[none]' ELSE CONVERT(NVARCHAR(MAX), [inserted].[LIMIT]) END,			
			'Hearing Type (' + [HEARINGTYPE].[NAME] + '), Case Type (' + ISNULL([PLPLANTYPE].[PLANNAME],[PMPERMITTYPE].[NAME]) + ')',
			'D2EF914D-EACD-4AA2-AF1B-6B2E30AE074B',
			2,
			0,
			ISNULL([PLPLANTYPE].[PLANNAME],[PMPERMITTYPE].[NAME])
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[HEARINGTYPEID] = [inserted].[HEARINGTYPEID]
			INNER JOIN HEARINGTYPE ON [inserted].[HEARINGTYPEID] = [HEARINGTYPE].[HEARINGTYPEID]
			LEFT JOIN PLPLANTYPE WITH (NOLOCK) ON [inserted].[TYPEID] = [PLPLANTYPE].[PLPLANTYPEID]
			LEFT JOIN PMPERMITTYPE WITH (NOLOCK) ON [inserted].[TYPEID] = [PMPERMITTYPE].[PMPERMITTYPEID]
	WHERE	ISNULL([deleted].[LIMIT],'') <> ISNULL([inserted].[LIMIT],'')		
END
GO
CREATE TRIGGER [TG_HEARINGCASETYPE_INSERT] ON [HEARINGCASETYPE]
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
			[HEARINGTYPE].[HEARINGTYPEID],
			[HEARINGTYPE].[ROWVERSION],
			GETUTCDATE(),
			[HEARINGTYPE].[LASTCHANGEDBY],
			'Hearing Type Case Type Added',
			'',
			'',
			'Hearing Type (' + [HEARINGTYPE].[NAME] + '), Case Type (' + ISNULL([PLPLANTYPE].[PLANNAME],[PMPERMITTYPE].[NAME]) + ')',
			'D2EF914D-EACD-4AA2-AF1B-6B2E30AE074B',
			1,
			0,
			ISNULL([PLPLANTYPE].[PLANNAME],[PMPERMITTYPE].[NAME])
	FROM	[inserted]
	INNER JOIN HEARINGTYPE ON [inserted].[HEARINGTYPEID] = [HEARINGTYPE].[HEARINGTYPEID]
	LEFT JOIN PLPLANTYPE WITH (NOLOCK) ON [inserted].[TYPEID] = [PLPLANTYPE].[PLPLANTYPEID]
	LEFT JOIN PMPERMITTYPE WITH (NOLOCK) ON [inserted].[TYPEID] = [PMPERMITTYPE].[PMPERMITTYPEID]
END