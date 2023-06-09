﻿CREATE TABLE [dbo].[WFACTIONGROUPACTIONXREF] (
    [WFACTIONGROUPACTIONXREFID] CHAR (36) NOT NULL,
    [WFACTIONGROUPID]           CHAR (36) NOT NULL,
    [WFACTIONID]                CHAR (36) NOT NULL,
    [PRIORITYORDER]             INT       NOT NULL,
    [SORTORDER]                 INT       NOT NULL,
    [AUTOFILL]                  BIT       NOT NULL,
    [AUTORECEIVE]               BIT       CONSTRAINT [DF_WFActionGroupActionXRef_AutoReceive] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_WFActionGroupActionXRef] PRIMARY KEY CLUSTERED ([WFACTIONGROUPACTIONXREFID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ActionXRef_Action] FOREIGN KEY ([WFACTIONID]) REFERENCES [dbo].[WFACTION] ([WFACTIONID]),
    CONSTRAINT [FK_ActionXRef_Group] FOREIGN KEY ([WFACTIONGROUPID]) REFERENCES [dbo].[WFACTIONGROUP] ([WFACTIONGROUPID])
);


GO
CREATE TRIGGER [dbo].[TG_WFACTIONGROUPACTIONXREF_DELETE]  
   ON  [dbo].[WFACTIONGROUPACTIONXREF] 
   AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;
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
		[WFACTIONGROUP].[WFACTIONGROUPID],
		[WFACTIONGROUP].[ROWVERSION],
		GETUTCDATE(),			
		(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
		'Workflow Action Group Action Deleted',
        '',
        '',       
		'Workflow Action Group (' + [WFACTIONGROUP].[NAME] + '), Workflow Action Name (' + [WFACTION].[NAME] +')',
		'B2E65396-BF99-4411-9498-E21F42CD80FD',
		3,
		0,
		[WFACTION].[NAME]
    FROM [deleted]
	INNER JOIN [WFACTIONGROUP] ON [WFACTIONGROUP].[WFACTIONGROUPID] = [deleted].[WFACTIONGROUPID]
	INNER JOIN [WFACTION] WITH (NOLOCK) ON [WFACTION].[WFACTIONID] = [deleted].[WFACTIONID]
END
GO
CREATE TRIGGER [dbo].[TG_WFACTIONGROUPACTIONXREF_INSERT]
   ON  [dbo].[WFACTIONGROUPACTIONXREF]
   AFTER INSERT
AS 
BEGIN	
	SET NOCOUNT ON;	
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
        [WFACTIONGROUP].[WFACTIONGROUPID], 
        [WFACTIONGROUP].[ROWVERSION],
        GETUTCDATE(),
        [WFACTIONGROUP].[LASTCHANGEDBY],	
        'Workflow Action Group Action Added',
        '',
        '',       
		'Workflow Action Group (' + [WFACTIONGROUP].[NAME] + '), Workflow Action Name (' + [WFACTION].[NAME] +')',
		'B2E65396-BF99-4411-9498-E21F42CD80FD',
		1,
		0,
		[WFACTION].[NAME]
    FROM [inserted]
	INNER JOIN [WFACTIONGROUP] ON [WFACTIONGROUP].[WFACTIONGROUPID] = [inserted].[WFACTIONGROUPID]
	INNER JOIN [WFACTION] WITH (NOLOCK) ON [WFACTION].[WFACTIONID] = [inserted].[WFACTIONID]
END
GO
CREATE TRIGGER [dbo].[TG_WFACTIONGROUPACTIONXREF_UPDATE]
   ON  [dbo].[WFACTIONGROUPACTIONXREF]
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
			[WFACTIONGROUP].[WFACTIONGROUPID],
			[WFACTIONGROUP].[ROWVERSION],
			GETUTCDATE(),
			[WFACTIONGROUP].[LASTCHANGEDBY],
			'Action Priority',
			CONVERT(NVARCHAR(MAX), [deleted].[PRIORITYORDER]),
			CONVERT(NVARCHAR(MAX), [inserted].[PRIORITYORDER]),
			'Workflow Action Group (' + [WFACTIONGROUP].[NAME] + '), Workflow Action Name (' + [WFACTION].[NAME] +')',
			'B2E65396-BF99-4411-9498-E21F42CD80FD',
			2,
			0,
			[WFACTION].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WFACTIONGROUPACTIONXREFID] = [inserted].[WFACTIONGROUPACTIONXREFID]
			INNER JOIN [WFACTIONGROUP] ON [WFACTIONGROUP].[WFACTIONGROUPID] = [inserted].[WFACTIONGROUPID]
			INNER JOIN [WFACTION] WITH (NOLOCK) ON [WFACTION].[WFACTIONID] = [inserted].[WFACTIONID]
	WHERE	[deleted].[PRIORITYORDER] <> [inserted].[PRIORITYORDER]
	UNION ALL
	SELECT
			[WFACTIONGROUP].[WFACTIONGROUPID],
			[WFACTIONGROUP].[ROWVERSION],
			GETUTCDATE(),
			[WFACTIONGROUP].[LASTCHANGEDBY],
			'Sort Order',
			CONVERT(NVARCHAR(MAX), [deleted].[SORTORDER]),
			CONVERT(NVARCHAR(MAX), [inserted].[SORTORDER]),
			'Workflow Action Group (' + [WFACTIONGROUP].[NAME] + '), Workflow Action Name (' + [WFACTION].[NAME] +')',
			'B2E65396-BF99-4411-9498-E21F42CD80FD',
			2,
			0,
			[WFACTION].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WFACTIONGROUPACTIONXREFID] = [inserted].[WFACTIONGROUPACTIONXREFID]
			INNER JOIN [WFACTIONGROUP] ON [WFACTIONGROUP].[WFACTIONGROUPID] = [inserted].[WFACTIONGROUPID]
			INNER JOIN [WFACTION] WITH (NOLOCK) ON [WFACTION].[WFACTIONID] = [inserted].[WFACTIONID]
	WHERE	[deleted].[SORTORDER] <> [inserted].[SORTORDER]
	UNION ALL
	SELECT
			[WFACTIONGROUP].[WFACTIONGROUPID],
			[WFACTIONGROUP].[ROWVERSION],
			GETUTCDATE(),
			[WFACTIONGROUP].[LASTCHANGEDBY],
			'Auto Fill Flag',
			CASE [deleted].[AUTOFILL]  WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[AUTOFILL] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Workflow Action Group (' + [WFACTIONGROUP].[NAME] + '), Workflow Action (' + [WFACTION].[NAME] +')',
			'B2E65396-BF99-4411-9498-E21F42CD80FD',
			2,
			0,
			[WFACTION].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WFACTIONGROUPACTIONXREFID] = [inserted].[WFACTIONGROUPACTIONXREFID]
			INNER JOIN [WFACTIONGROUP] ON [WFACTIONGROUP].[WFACTIONGROUPID] = [inserted].[WFACTIONGROUPID]
			INNER JOIN [WFACTION] WITH (NOLOCK) ON [WFACTION].[WFACTIONID] = [inserted].[WFACTIONID]
	WHERE	[deleted].[AUTOFILL] <> [inserted].[AUTOFILL]
	UNION ALL
	SELECT
			[WFACTIONGROUP].[WFACTIONGROUPID],
			[WFACTIONGROUP].[ROWVERSION],
			GETUTCDATE(),
			[WFACTIONGROUP].[LASTCHANGEDBY],
			'Auto Receive Flag',
			CASE [deleted].[AUTORECEIVE]	 WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[AUTORECEIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Workflow Action Group (' + [WFACTIONGROUP].[NAME] + '), Workflow Action Name (' + [WFACTION].[NAME] +')',
			'B2E65396-BF99-4411-9498-E21F42CD80FD',
			2,
			0,
			[WFACTION].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WFACTIONGROUPACTIONXREFID] = [inserted].[WFACTIONGROUPACTIONXREFID]
			INNER JOIN [WFACTIONGROUP] ON [WFACTIONGROUP].[WFACTIONGROUPID] = [inserted].[WFACTIONGROUPID]
			INNER JOIN [WFACTION] WITH (NOLOCK) ON [WFACTION].[WFACTIONID] = [inserted].[WFACTIONID]
	WHERE	[deleted].[AUTORECEIVE] <> [inserted].[AUTORECEIVE]
END