﻿CREATE TABLE [dbo].[ATTACHMENTREQFILEREF] (
    [ATTACHMENTREQFILEREFID] CHAR (36)      NOT NULL,
    [NAME]                   NVARCHAR (260) NOT NULL,
    [ISREQUIRED]             BIT            DEFAULT ((0)) NOT NULL,
    [QUANTITY]               INT            DEFAULT ((0)) NOT NULL,
    [ATTACHMENTGROUPID]      CHAR (36)      NULL,
    [OBJECTCLASSID]          CHAR (36)      NOT NULL,
    [OBJECTTYPEID]           CHAR (36)      NOT NULL,
    CONSTRAINT [PK_ATTACHMENTREQFILEREF] PRIMARY KEY CLUSTERED ([ATTACHMENTREQFILEREFID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ATTACHMENTREQFILEREF_ATTACHMENTGROUP] FOREIGN KEY ([ATTACHMENTGROUPID]) REFERENCES [dbo].[ATTACHMENTGROUP] ([ATTACHMENTGROUPID])
);


GO

CREATE TRIGGER [dbo].[TG_ATTACHMENTREQFILEREF_DELETE]  
    ON  [dbo].[ATTACHMENTREQFILEREF]
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
		[PMPERMITTYPE].[PMPERMITTYPEID],
		[PMPERMITTYPE].[ROWVERSION],
		GETUTCDATE(),			
		(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
		'Permit Type CAP File Type Deleted',
        '',
        '',       
		'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + [PMPERMITWORKCLASS].[NAME] +'), File Name (' + [deleted].[NAME] +')',
		'4976A4A9-20E8-4B8F-997D-CE244B540104',
		3,
		0,
		[deleted].[NAME]
    FROM [deleted]
	INNER JOIN [PMPERMITWORKCLASS] WITH (NOLOCK) ON [PMPERMITWORKCLASS].[PMPERMITWORKCLASSID] = [deleted].[OBJECTCLASSID]
	INNER JOIN [PMPERMITTYPEWORKCLASS] ON [PMPERMITTYPEWORKCLASS].[PMPERMITTYPEWORKCLASSID] = [deleted].[OBJECTTYPEID]	
	INNER JOIN [PMPERMITTYPE] ON [PMPERMITTYPE].[PMPERMITTYPEID] = [PMPERMITTYPEWORKCLASS].[PMPERMITTYPEID]
	UNION ALL
	SELECT
		[PLPLANTYPE].[PLPLANTYPEID],
		[PLPLANTYPE].[ROWVERSION],
		GETUTCDATE(),			
		(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
		'Plan Type CAP File Type Deleted',
        '',
        '',       
		'Plan Type (' + [PLPLANTYPE].[PLANNAME] + '), Work Class Name (' + [PLPLANWORKCLASS].[NAME] +'), File Name (' + [deleted].[NAME] +')',
		'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
		3,
		0,
		[deleted].[NAME]
    FROM [deleted]
	INNER JOIN [PLPLANWORKCLASS] WITH (NOLOCK) ON [PLPLANWORKCLASS].[PLPLANWORKCLASSID] = [deleted].[OBJECTCLASSID]
	INNER JOIN [PLPLANTYPEWORKCLASS]  ON [PLPLANTYPEWORKCLASS].[PLPLANTYPEWORKCLASSID] = [deleted].[OBJECTTYPEID]
	INNER JOIN [PLPLANTYPE] ON [PLPLANTYPE].[PLPLANTYPEID] = [PLPLANTYPEWORKCLASS].[PLPLANTYPEID]
	UNION ALL
	SELECT
			[BLEXTCOMPANYTYPE].[BLEXTCOMPANYTYPEID],
			[BLEXTCOMPANYTYPE].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Business Company Type CAP File Type Deleted',
			'',
			'',
			'Business Company Type (' + [BLEXTCOMPANYTYPE].[NAME] + '),  CAP File Type (' + [deleted].[NAME] + ')',
			null,
			3,
			0,
			[deleted].[NAME]
	FROM	[deleted]
			JOIN [BLEXTCOMPANYTYPE] ON [BLEXTCOMPANYTYPE].[BLEXTCOMPANYTYPEID] = [deleted].[OBJECTTYPEID]
	UNION ALL
	SELECT 
        [BLLICENSETYPE].[BLLICENSETYPEID], 
        [BLLICENSETYPE].[ROWVERSION],
        GETUTCDATE(),
		(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
        'Business License Type CAP File Type Deleted',
        '',
        '',       
		'Business License Type (' + [BLLICENSETYPE].[NAME] + '), License Classification Name (' + [BLLICENSECLASS].[NAME] +'), File Name (' + [deleted].[NAME] +')',
		'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
		3,
		0,
		[deleted].[NAME]
    FROM [deleted]	
	INNER JOIN [BLLICENSECLASS] WITH (NOLOCK) ON [BLLICENSECLASS].[BLLICENSECLASSID] = [deleted].[OBJECTCLASSID]
	INNER JOIN [BLLICENSETYPECLASS]  ON [BLLICENSETYPECLASS].[BLLICENSECLASSID] = [BLLICENSECLASS].[BLLICENSECLASSID]	
	INNER JOIN [BLLICENSETYPE]  ON [BLLICENSETYPE].[BLLICENSETYPEID] = [BLLICENSETYPECLASS].[BLLICENSETYPEID] and [BLLICENSETYPE].[BLLICENSETYPEID]=  [deleted].[OBJECTTYPEID]

	UNION ALL
	SELECT DISTINCT
        [ILLICENSETYPE].[ILLICENSETYPEID], 
        [ILLICENSETYPE].[ROWVERSION],
        GETUTCDATE(),
		(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
        'Professional License Type CAP File Type Deleted',
        '',
        '',       
		'Professional License Type (' + [ILLICENSETYPE].[NAME] + '), Professional License Classification Name (' + [ILLICENSECLASSIFICATION].[NAME] +'), File Name (' + [deleted].[NAME] +')',
		'67978C16-D720-4F8E-8120-E00FBB732A77',
		3,
		0,
		[deleted].[NAME]
    FROM [deleted]	
	INNER JOIN [ILLICENSECLASSIFICATION] WITH (NOLOCK) ON [ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID] = [deleted].[OBJECTCLASSID]
	INNER JOIN [ILLICENSETYPELICENSECLASS]  ON [ILLICENSETYPELICENSECLASS].[ILLICENSECLASSIFICATIONID] =[ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID]	
	INNER JOIN [ILLICENSETYPE]  ON [ILLICENSETYPE].[ILLICENSETYPEID] = [ILLICENSETYPELICENSECLASS].[ILLICENSETYPEID] AND [ILLICENSETYPE].[ILLICENSETYPEID] = [deleted].[OBJECTTYPEID]
END
GO

CREATE TRIGGER [dbo].[TG_ATTACHMENTREQFILEREF_UPDATE]
   ON  [dbo].[ATTACHMENTREQFILEREF] 
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
			[PMPERMITTYPE].[PMPERMITTYPEID],
			[PMPERMITTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PMPERMITTYPE].[LASTCHANGEDBY],
			'Default File Group',
			ISNULL([ATTACHMENTGROUP_DELETED].[NAME],'[none]'),
			ISNULL([ATTACHMENTGROUP_INSERTED].[NAME],'[none]'),
			'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + [PMPERMITWORKCLASS].[NAME] +'), File Name (' + [inserted].[NAME] +')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTREQFILEREFID] = [inserted].[ATTACHMENTREQFILEREFID]			
			INNER JOIN [PMPERMITWORKCLASS] WITH (NOLOCK) ON [PMPERMITWORKCLASS].[PMPERMITWORKCLASSID] = [inserted].[OBJECTCLASSID]
			INNER JOIN [PMPERMITTYPEWORKCLASS]  ON [PMPERMITTYPEWORKCLASS].[PMPERMITTYPEWORKCLASSID] = [inserted].[OBJECTTYPEID]
			INNER JOIN [PMPERMITTYPE] ON [PMPERMITTYPE].[PMPERMITTYPEID] = [PMPERMITTYPEWORKCLASS].[PMPERMITTYPEID]
			LEFT JOIN [ATTACHMENTGROUP] [ATTACHMENTGROUP_DELETED] WITH (NOLOCK) ON [deleted].[ATTACHMENTGROUPID] = [ATTACHMENTGROUP_DELETED].[ATTACHMENTGROUPID]
			LEFT JOIN [ATTACHMENTGROUP] [ATTACHMENTGROUP_INSERTED] WITH (NOLOCK) ON [inserted].[ATTACHMENTGROUPID] = [ATTACHMENTGROUP_INSERTED].[ATTACHMENTGROUPID]			
	WHERE	ISNULL([deleted].[ATTACHMENTGROUPID],'') <> ISNULL([inserted].[ATTACHMENTGROUPID],'')
	UNION ALL
	SELECT 
			[PMPERMITTYPE].[PMPERMITTYPEID],
			[PMPERMITTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PMPERMITTYPE].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + [PMPERMITWORKCLASS].[NAME] +'), File Name (' + [inserted].[NAME] +')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTREQFILEREFID] = [inserted].[ATTACHMENTREQFILEREFID]			
			INNER JOIN [PMPERMITWORKCLASS] WITH (NOLOCK) ON [PMPERMITWORKCLASS].[PMPERMITWORKCLASSID] = [inserted].[OBJECTCLASSID]
			INNER JOIN [PMPERMITTYPEWORKCLASS] ON [PMPERMITTYPEWORKCLASS].[PMPERMITTYPEWORKCLASSID] = [inserted].[OBJECTTYPEID]
			INNER JOIN [PMPERMITTYPE] ON [PMPERMITTYPE].[PMPERMITTYPEID] = [PMPERMITTYPEWORKCLASS].[PMPERMITTYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT 
			[PMPERMITTYPE].[PMPERMITTYPEID],
			[PMPERMITTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PMPERMITTYPE].[LASTCHANGEDBY],
			'Required Flag',
			CASE [deleted].[ISREQUIRED] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISREQUIRED] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + [PMPERMITWORKCLASS].[NAME] +'), File Name (' + [inserted].[NAME] +')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTREQFILEREFID] = [inserted].[ATTACHMENTREQFILEREFID]			
			INNER JOIN [PMPERMITWORKCLASS] WITH (NOLOCK) ON [PMPERMITWORKCLASS].[PMPERMITWORKCLASSID] = [inserted].[OBJECTCLASSID]
			INNER JOIN [PMPERMITTYPEWORKCLASS] ON [PMPERMITTYPEWORKCLASS].[PMPERMITTYPEWORKCLASSID] = [inserted].[OBJECTTYPEID]
			INNER JOIN [PMPERMITTYPE] ON [PMPERMITTYPE].[PMPERMITTYPEID] = [PMPERMITTYPEWORKCLASS].[PMPERMITTYPEID]
	WHERE	[deleted].[ISREQUIRED] <> [inserted].[ISREQUIRED]
	UNION ALL
	SELECT 
			[PMPERMITTYPE].[PMPERMITTYPEID],
			[PMPERMITTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PMPERMITTYPE].[LASTCHANGEDBY],
			'Quantity',
			CONVERT(NVARCHAR(MAX), [deleted].[QUANTITY]),
			CONVERT(NVARCHAR(MAX), [inserted].[QUANTITY]),
			'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + [PMPERMITWORKCLASS].[NAME] +'), File Name (' + [inserted].[NAME] +')',
			'4976A4A9-20E8-4B8F-997D-CE244B540104',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTREQFILEREFID] = [inserted].[ATTACHMENTREQFILEREFID]			
			INNER JOIN [PMPERMITWORKCLASS] WITH (NOLOCK) ON [PMPERMITWORKCLASS].[PMPERMITWORKCLASSID] = [inserted].[OBJECTCLASSID]
			INNER JOIN [PMPERMITTYPEWORKCLASS] ON [PMPERMITTYPEWORKCLASS].[PMPERMITTYPEWORKCLASSID] = [inserted].[OBJECTTYPEID]
			INNER JOIN [PMPERMITTYPE] ON [PMPERMITTYPE].[PMPERMITTYPEID] = [PMPERMITTYPEWORKCLASS].[PMPERMITTYPEID]
	WHERE	[deleted].[QUANTITY] <> [inserted].[QUANTITY]

	
	UNION ALL
	SELECT 
			[PLPLANTYPE].[PLPLANTYPEID],
			[PLPLANTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PLPLANTYPE].[LASTCHANGEDBY],
			'Default File Group',
			ISNULL([ATTACHMENTGROUP_DELETED].[NAME],'[none]'),
			ISNULL([ATTACHMENTGROUP_INSERTED].[NAME],'[none]'),
			'Plan Type (' + [PLPLANTYPE].[PLANNAME] + '), Work Class Name (' + [PLPLANWORKCLASS].[NAME] +'), File Name (' + [inserted].[NAME] +')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTREQFILEREFID] = [inserted].[ATTACHMENTREQFILEREFID]			
			INNER JOIN [PLPLANWORKCLASS] WITH (NOLOCK) ON [PLPLANWORKCLASS].[PLPLANWORKCLASSID] = [inserted].[OBJECTCLASSID]
			INNER JOIN [PLPLANTYPEWORKCLASS] ON [PLPLANTYPEWORKCLASS].[PLPLANTYPEWORKCLASSID] = [inserted].[OBJECTTYPEID]
			INNER JOIN [PLPLANTYPE] ON [PLPLANTYPE].[PLPLANTYPEID] = [PLPLANTYPEWORKCLASS].[PLPLANTYPEID]
			LEFT JOIN [ATTACHMENTGROUP] [ATTACHMENTGROUP_DELETED] WITH (NOLOCK) ON [deleted].[ATTACHMENTGROUPID] = [ATTACHMENTGROUP_DELETED].[ATTACHMENTGROUPID]
			LEFT JOIN [ATTACHMENTGROUP] [ATTACHMENTGROUP_INSERTED] WITH (NOLOCK) ON [inserted].[ATTACHMENTGROUPID] = [ATTACHMENTGROUP_INSERTED].[ATTACHMENTGROUPID]			
	WHERE	ISNULL([deleted].[ATTACHMENTGROUPID],'') <> ISNULL([inserted].[ATTACHMENTGROUPID],'')
	UNION ALL
	SELECT 
			[PLPLANTYPE].[PLPLANTYPEID],
			[PLPLANTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PLPLANTYPE].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Plan Type (' + [PLPLANTYPE].[PLANNAME] + '), Work Class Name (' + [PLPLANWORKCLASS].[NAME] +'), File Name (' + [inserted].[NAME] +')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTREQFILEREFID] = [inserted].[ATTACHMENTREQFILEREFID]			
			INNER JOIN [PLPLANWORKCLASS] WITH (NOLOCK) ON [PLPLANWORKCLASS].[PLPLANWORKCLASSID] = [inserted].[OBJECTCLASSID]
			INNER JOIN [PLPLANTYPEWORKCLASS]  ON [PLPLANTYPEWORKCLASS].[PLPLANTYPEWORKCLASSID] = [inserted].[OBJECTTYPEID]
			INNER JOIN [PLPLANTYPE] ON [PLPLANTYPE].[PLPLANTYPEID] = [PLPLANTYPEWORKCLASS].[PLPLANTYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT 
			[PLPLANTYPE].[PLPLANTYPEID],
			[PLPLANTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PLPLANTYPE].[LASTCHANGEDBY],
			'Required Flag',
			CASE [deleted].[ISREQUIRED] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISREQUIRED] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Plan Type (' + [PLPLANTYPE].[PLANNAME] + '), Work Class Name (' + [PLPLANWORKCLASS].[NAME] +'), File Name (' + [inserted].[NAME] +')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTREQFILEREFID] = [inserted].[ATTACHMENTREQFILEREFID]			
			INNER JOIN [PLPLANWORKCLASS] WITH (NOLOCK) ON [PLPLANWORKCLASS].[PLPLANWORKCLASSID] = [inserted].[OBJECTCLASSID]
			INNER JOIN [PLPLANTYPEWORKCLASS]  ON [PLPLANTYPEWORKCLASS].[PLPLANTYPEWORKCLASSID] = [inserted].[OBJECTTYPEID]
			INNER JOIN [PLPLANTYPE] ON [PLPLANTYPE].[PLPLANTYPEID] = [PLPLANTYPEWORKCLASS].[PLPLANTYPEID]
	WHERE	[deleted].[ISREQUIRED] <> [inserted].[ISREQUIRED]
	UNION ALL
	SELECT 
			[PLPLANTYPE].[PLPLANTYPEID],
			[PLPLANTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PLPLANTYPE].[LASTCHANGEDBY],
			'Quantity',
			CONVERT(NVARCHAR(MAX), [deleted].[QUANTITY]),
			CONVERT(NVARCHAR(MAX), [inserted].[QUANTITY]),
			'Plan Type (' + [PLPLANTYPE].[PLANNAME] + '), Work Class Name (' + [PLPLANWORKCLASS].[NAME] +'), File Name (' + [inserted].[NAME] +')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTREQFILEREFID] = [inserted].[ATTACHMENTREQFILEREFID]			
			INNER JOIN [PLPLANWORKCLASS] WITH (NOLOCK) ON [PLPLANWORKCLASS].[PLPLANWORKCLASSID] = [inserted].[OBJECTCLASSID]
			INNER JOIN [PLPLANTYPEWORKCLASS] ON [PLPLANTYPEWORKCLASS].[PLPLANTYPEWORKCLASSID] = [inserted].[OBJECTTYPEID]
			INNER JOIN [PLPLANTYPE] ON [PLPLANTYPE].[PLPLANTYPEID] = [PLPLANTYPEWORKCLASS].[PLPLANTYPEID]
	WHERE	[deleted].[QUANTITY] <> [inserted].[QUANTITY]
	
	UNION ALL
	SELECT
			[BLEXTCOMPANYTYPE].[BLEXTCOMPANYTYPEID],
			[BLEXTCOMPANYTYPE].[ROWVERSION],
			GETUTCDATE(),
			[BLEXTCOMPANYTYPE].[LASTCHANGEDBY],
			'Business Company Type CAP File Type Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Business Company Type (' + [BLEXTCOMPANYTYPE].[NAME] + '),  CAP File Type (' + [inserted].[NAME] + ')',
			null,
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
	        JOIN [inserted] ON [deleted].[ATTACHMENTREQFILEREFID] = [inserted].[ATTACHMENTREQFILEREFID]
	        JOIN [BLEXTCOMPANYTYPE] ON [BLEXTCOMPANYTYPE].[BLEXTCOMPANYTYPEID] = [deleted].[OBJECTTYPEID]			
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	
	UNION ALL
	SELECT
			[BLEXTCOMPANYTYPE].[BLEXTCOMPANYTYPEID],
			[BLEXTCOMPANYTYPE].[ROWVERSION],
			GETUTCDATE(),
			[BLEXTCOMPANYTYPE].[LASTCHANGEDBY],
			'Business Company Type CAP File Type Required Flag',
			CASE [deleted].[ISREQUIRED] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISREQUIRED] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Business Company Type (' + [BLEXTCOMPANYTYPE].[NAME] + '),  CAP File Type (' + [inserted].[NAME] + ')',
			null,
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTREQFILEREFID] = [inserted].[ATTACHMENTREQFILEREFID]			
			JOIN [BLEXTCOMPANYTYPE] ON [BLEXTCOMPANYTYPE].[BLEXTCOMPANYTYPEID] = [deleted].[OBJECTTYPEID]
	WHERE	[deleted].[ISREQUIRED] <> [inserted].[ISREQUIRED]
	
	UNION ALL
	SELECT
			[BLEXTCOMPANYTYPE].[BLEXTCOMPANYTYPEID],
			[BLEXTCOMPANYTYPE].[ROWVERSION],
			GETUTCDATE(),
			[BLEXTCOMPANYTYPE].[LASTCHANGEDBY],
			'Business Company Type CAP File Type Quantity',
			CONVERT(NVARCHAR(MAX), [deleted].[QUANTITY]),
			CONVERT(NVARCHAR(MAX), [inserted].[QUANTITY]),			
			'Business Company Type (' + [BLEXTCOMPANYTYPE].[NAME] + '),  CAP File Type (' + [inserted].[NAME] + ')',
			null,
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTREQFILEREFID] = [inserted].[ATTACHMENTREQFILEREFID]	
			JOIN [BLEXTCOMPANYTYPE] ON [BLEXTCOMPANYTYPE].[BLEXTCOMPANYTYPEID] = [deleted].[OBJECTTYPEID]
	WHERE	[deleted].[QUANTITY] <> [inserted].[QUANTITY]
	
	UNION ALL
	SELECT
			[BLEXTCOMPANYTYPE].[BLEXTCOMPANYTYPEID],
			[BLEXTCOMPANYTYPE].[ROWVERSION],
			GETUTCDATE(),
			[BLEXTCOMPANYTYPE].[LASTCHANGEDBY],
			'Business Company Type CAP File Type Default File Group',
			ISNULL([ATTACHMENTGROUP_DELETED].[NAME],'[none]'),
			ISNULL([ATTACHMENTGROUP_INSERTED].[NAME],'[none]'),
			'Business Company Type (' + [BLEXTCOMPANYTYPE].[NAME] + '),  CAP File Type (' + [inserted].[NAME] + ')',
			null,
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTREQFILEREFID] = [inserted].[ATTACHMENTREQFILEREFID]	
			JOIN [BLEXTCOMPANYTYPE] ON [BLEXTCOMPANYTYPE].[BLEXTCOMPANYTYPEID] = [deleted].[OBJECTTYPEID]
			LEFT JOIN [ATTACHMENTGROUP] ATTACHMENTGROUP_INSERTED WITH (NOLOCK) ON [ATTACHMENTGROUP_INSERTED].[ATTACHMENTGROUPID] = [inserted].[ATTACHMENTGROUPID]
			LEFT JOIN [ATTACHMENTGROUP] ATTACHMENTGROUP_DELETED WITH (NOLOCK) ON [ATTACHMENTGROUP_DELETED].[ATTACHMENTGROUPID] = [deleted].[ATTACHMENTGROUPID]
	WHERE	ISNULL([deleted].[ATTACHMENTGROUPID], '') <> ISNULL([inserted].[ATTACHMENTGROUPID], '')	
	UNION ALL
	SELECT 
			[BLLICENSETYPE].[BLLICENSETYPEID], 
			[BLLICENSETYPE].[ROWVERSION],
			GETUTCDATE(),
			[BLLICENSETYPE].[LASTCHANGEDBY],
			'Default File Group',
			ISNULL([ATTACHMENTGROUP_DELETED].[NAME],'[none]'),
			ISNULL([ATTACHMENTGROUP_INSERTED].[NAME],'[none]'),
			'Business License Type  (' + [BLLICENSETYPE].[NAME] + '), License Classification Name (' + [BLLICENSECLASS].[NAME] +'), File Name (' + [inserted].[NAME] +')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTREQFILEREFID] = [inserted].[ATTACHMENTREQFILEREFID]			
			INNER JOIN [BLLICENSECLASS] WITH (NOLOCK) ON [BLLICENSECLASS].[BLLICENSECLASSID] = [inserted].[OBJECTCLASSID]
			INNER JOIN [BLLICENSETYPECLASS]  ON [BLLICENSETYPECLASS].[BLLICENSECLASSID] = [BLLICENSECLASS].[BLLICENSECLASSID]	
			INNER JOIN [BLLICENSETYPE]  ON [BLLICENSETYPE].[BLLICENSETYPEID] = [BLLICENSETYPECLASS].[BLLICENSETYPEID] and [BLLICENSETYPE].[BLLICENSETYPEID]=  [inserted].[OBJECTTYPEID]
			LEFT JOIN [ATTACHMENTGROUP] [ATTACHMENTGROUP_DELETED] WITH (NOLOCK) ON [deleted].[ATTACHMENTGROUPID] = [ATTACHMENTGROUP_DELETED].[ATTACHMENTGROUPID]
			LEFT JOIN [ATTACHMENTGROUP] [ATTACHMENTGROUP_INSERTED] WITH (NOLOCK) ON [inserted].[ATTACHMENTGROUPID] = [ATTACHMENTGROUP_INSERTED].[ATTACHMENTGROUPID]			
	WHERE	ISNULL([deleted].[ATTACHMENTGROUPID],'') <> ISNULL([inserted].[ATTACHMENTGROUPID],'')
	UNION ALL
	SELECT 
			[BLLICENSETYPE].[BLLICENSETYPEID], 
			[BLLICENSETYPE].[ROWVERSION],
			GETUTCDATE(),
			[BLLICENSETYPE].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Business License Type  (' + [BLLICENSETYPE].[NAME] + '), License Classification Name (' + [BLLICENSECLASS].[NAME] +'), File Name (' + [inserted].[NAME] +')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTREQFILEREFID] = [inserted].[ATTACHMENTREQFILEREFID]			
			INNER JOIN [BLLICENSECLASS] WITH (NOLOCK) ON [BLLICENSECLASS].[BLLICENSECLASSID] = [inserted].[OBJECTCLASSID]
			INNER JOIN [BLLICENSETYPECLASS]  ON [BLLICENSETYPECLASS].[BLLICENSECLASSID] = [BLLICENSECLASS].[BLLICENSECLASSID]	
			INNER JOIN [BLLICENSETYPE]  ON [BLLICENSETYPE].[BLLICENSETYPEID] = [BLLICENSETYPECLASS].[BLLICENSETYPEID] and [BLLICENSETYPE].[BLLICENSETYPEID]=  [inserted].[OBJECTTYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT 
			[BLLICENSETYPE].[BLLICENSETYPEID], 
			[BLLICENSETYPE].[ROWVERSION],
			GETUTCDATE(),
			[BLLICENSETYPE].[LASTCHANGEDBY],
			'Required Flag',
			CASE [deleted].[ISREQUIRED] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISREQUIRED] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Business License Type  (' + [BLLICENSETYPE].[NAME] + '), License Classification Name (' + [BLLICENSECLASS].[NAME] +'), File Name (' + [inserted].[NAME] +')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTREQFILEREFID] = [inserted].[ATTACHMENTREQFILEREFID]			
			INNER JOIN [BLLICENSECLASS] WITH (NOLOCK) ON [BLLICENSECLASS].[BLLICENSECLASSID] = [inserted].[OBJECTCLASSID]
			INNER JOIN [BLLICENSETYPECLASS]  ON [BLLICENSETYPECLASS].[BLLICENSECLASSID] = [BLLICENSECLASS].[BLLICENSECLASSID]	
			INNER JOIN [BLLICENSETYPE]  ON [BLLICENSETYPE].[BLLICENSETYPEID] = [BLLICENSETYPECLASS].[BLLICENSETYPEID] and [BLLICENSETYPE].[BLLICENSETYPEID]=  [inserted].[OBJECTTYPEID]
			WHERE	[deleted].[ISREQUIRED] <> [inserted].[ISREQUIRED]
	UNION ALL
	SELECT 
			[BLLICENSETYPE].[BLLICENSETYPEID], 
			[BLLICENSETYPE].[ROWVERSION],
			GETUTCDATE(),
			[BLLICENSETYPE].[LASTCHANGEDBY],
			'Quantity',
			CONVERT(NVARCHAR(MAX), [deleted].[QUANTITY]),
			CONVERT(NVARCHAR(MAX), [inserted].[QUANTITY]),
			'Business License Type  (' + [BLLICENSETYPE].[NAME] + '), License Classification Name (' + [BLLICENSECLASS].[NAME] +'), File Name (' + [inserted].[NAME] +')',
			'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTREQFILEREFID] = [inserted].[ATTACHMENTREQFILEREFID]				
			INNER JOIN [BLLICENSECLASS] WITH (NOLOCK) ON [BLLICENSECLASS].[BLLICENSECLASSID] = [inserted].[OBJECTCLASSID]
			INNER JOIN [BLLICENSETYPECLASS]  ON [BLLICENSETYPECLASS].[BLLICENSECLASSID] = [BLLICENSECLASS].[BLLICENSECLASSID]	
			INNER JOIN [BLLICENSETYPE]  ON [BLLICENSETYPE].[BLLICENSETYPEID] = [BLLICENSETYPECLASS].[BLLICENSETYPEID] and [BLLICENSETYPE].[BLLICENSETYPEID]=  [inserted].[OBJECTTYPEID]
	WHERE	[deleted].[QUANTITY] <> [inserted].[QUANTITY]		

	UNION ALL
	SELECT 
			[ILLICENSETYPE].[ILLICENSETYPEID], 
			[ILLICENSETYPE].[ROWVERSION],
			GETUTCDATE(),
			[ILLICENSETYPE].[LASTCHANGEDBY],
			'Default File Group',
			ISNULL([ATTACHMENTGROUP_DELETED].[NAME],'[none]'),
			ISNULL([ATTACHMENTGROUP_INSERTED].[NAME],'[none]'),
			'Professional License Type  (' + [ILLICENSETYPE].[NAME] + '), Professional License Classification Name (' + [ILLICENSECLASSIFICATION].[NAME] +'), File Name (' + [inserted].[NAME] +')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTREQFILEREFID] = [inserted].[ATTACHMENTREQFILEREFID]			
			INNER JOIN [ILLICENSECLASSIFICATION] WITH (NOLOCK) ON [ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID] = [inserted].[OBJECTCLASSID]
			INNER JOIN [ILLICENSETYPELICENSECLASS]  ON [ILLICENSETYPELICENSECLASS].[ILLICENSECLASSIFICATIONID] =[ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID]	
			INNER JOIN [ILLICENSETYPE]  ON [ILLICENSETYPE].[ILLICENSETYPEID] = [ILLICENSETYPELICENSECLASS].[ILLICENSETYPEID] AND [ILLICENSETYPE].[ILLICENSETYPEID] = [inserted].[OBJECTTYPEID]
			LEFT JOIN [ATTACHMENTGROUP] [ATTACHMENTGROUP_DELETED] WITH (NOLOCK) ON [deleted].[ATTACHMENTGROUPID] = [ATTACHMENTGROUP_DELETED].[ATTACHMENTGROUPID]
			LEFT JOIN [ATTACHMENTGROUP] [ATTACHMENTGROUP_INSERTED] WITH (NOLOCK) ON [inserted].[ATTACHMENTGROUPID] = [ATTACHMENTGROUP_INSERTED].[ATTACHMENTGROUPID]			
	WHERE	ISNULL([deleted].[ATTACHMENTGROUPID],'') <> ISNULL([inserted].[ATTACHMENTGROUPID],'')
	UNION ALL
	SELECT 
			[ILLICENSETYPE].[ILLICENSETYPEID], 
			[ILLICENSETYPE].[ROWVERSION],
			GETUTCDATE(),
			[ILLICENSETYPE].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Professional License Type  (' + [ILLICENSETYPE].[NAME] + '), Professional License Classification Name (' + [ILLICENSECLASSIFICATION].[NAME] +'), File Name (' + [inserted].[NAME] +')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTREQFILEREFID] = [inserted].[ATTACHMENTREQFILEREFID]						
			INNER JOIN [ILLICENSECLASSIFICATION] WITH (NOLOCK) ON [ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID] = [inserted].[OBJECTCLASSID]
			INNER JOIN [ILLICENSETYPELICENSECLASS]  ON [ILLICENSETYPELICENSECLASS].[ILLICENSECLASSIFICATIONID] =[ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID]	
			INNER JOIN [ILLICENSETYPE]  ON [ILLICENSETYPE].[ILLICENSETYPEID] = [ILLICENSETYPELICENSECLASS].[ILLICENSETYPEID] AND [ILLICENSETYPE].[ILLICENSETYPEID] = [inserted].[OBJECTTYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT 
			[ILLICENSETYPE].[ILLICENSETYPEID], 
			[ILLICENSETYPE].[ROWVERSION],
			GETUTCDATE(),
			[ILLICENSETYPE].[LASTCHANGEDBY],
			'Required Flag',
			CASE [deleted].[ISREQUIRED] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISREQUIRED] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Professional License Type  (' + [ILLICENSETYPE].[NAME] + '), Professional License Classification Name (' + [ILLICENSECLASSIFICATION].[NAME] +'), File Name (' + [inserted].[NAME] +')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTREQFILEREFID] = [inserted].[ATTACHMENTREQFILEREFID]			
			INNER JOIN [ILLICENSECLASSIFICATION] WITH (NOLOCK) ON [ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID] = [inserted].[OBJECTCLASSID]
			INNER JOIN [ILLICENSETYPELICENSECLASS]  ON [ILLICENSETYPELICENSECLASS].[ILLICENSECLASSIFICATIONID] =[ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID]	
			INNER JOIN [ILLICENSETYPE]  ON [ILLICENSETYPE].[ILLICENSETYPEID] = [ILLICENSETYPELICENSECLASS].[ILLICENSETYPEID] AND [ILLICENSETYPE].[ILLICENSETYPEID] = [inserted].[OBJECTTYPEID]
			WHERE	[deleted].[ISREQUIRED] <> [inserted].[ISREQUIRED]
	UNION ALL
	SELECT 
			[ILLICENSETYPE].[ILLICENSETYPEID], 
			[ILLICENSETYPE].[ROWVERSION],
			GETUTCDATE(),
			[ILLICENSETYPE].[LASTCHANGEDBY],
			'Quantity',
			CONVERT(NVARCHAR(MAX), [deleted].[QUANTITY]),
			CONVERT(NVARCHAR(MAX), [inserted].[QUANTITY]),
			'Professional License Type  (' + [ILLICENSETYPE].[NAME] + '), Professional License Classification Name (' + [ILLICENSECLASSIFICATION].[NAME] +'), File Name (' + [inserted].[NAME] +')',
			'67978C16-D720-4F8E-8120-E00FBB732A77',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ATTACHMENTREQFILEREFID] = [inserted].[ATTACHMENTREQFILEREFID]				
			INNER JOIN [ILLICENSECLASSIFICATION] WITH (NOLOCK) ON [ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID] = [inserted].[OBJECTCLASSID]
			INNER JOIN [ILLICENSETYPELICENSECLASS]  ON [ILLICENSETYPELICENSECLASS].[ILLICENSECLASSIFICATIONID] =[ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID]	
			INNER JOIN [ILLICENSETYPE]  ON [ILLICENSETYPE].[ILLICENSETYPEID] = [ILLICENSETYPELICENSECLASS].[ILLICENSETYPEID] AND [ILLICENSETYPE].[ILLICENSETYPEID] = [inserted].[OBJECTTYPEID]
	WHERE	[deleted].[QUANTITY] <> [inserted].[QUANTITY]		
END
GO

CREATE TRIGGER [dbo].[TG_ATTACHMENTREQFILEREF_INSERT]
   ON  [dbo].[ATTACHMENTREQFILEREF]
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
        [PMPERMITTYPE].[PMPERMITTYPEID], 
        [PMPERMITTYPE].[ROWVERSION],
        GETUTCDATE(),
        [PMPERMITTYPE].[LASTCHANGEDBY],	
        'Permit Type CAP File Type Added',
        '',
        '',       
		'Permit Type (' + [PMPERMITTYPE].[NAME] + '), Work Class Name (' + [PMPERMITWORKCLASS].[NAME] +'), File Name (' + [inserted].[NAME] +')',
		'4976A4A9-20E8-4B8F-997D-CE244B540104',
		1,
		0,
		[inserted].[NAME]
    FROM [inserted]	
	INNER JOIN [PMPERMITWORKCLASS] WITH (NOLOCK) ON [PMPERMITWORKCLASS].[PMPERMITWORKCLASSID] = [inserted].[OBJECTCLASSID]
	INNER JOIN [PMPERMITTYPEWORKCLASS]  ON [PMPERMITTYPEWORKCLASS].[PMPERMITTYPEWORKCLASSID] = [inserted].[OBJECTTYPEID]	
	INNER JOIN [PMPERMITTYPE]  ON [PMPERMITTYPE].[PMPERMITTYPEID] = [PMPERMITTYPEWORKCLASS].[PMPERMITTYPEID]

	UNION ALL
	SELECT 
        [PLPLANTYPE].[PLPLANTYPEID], 
        [PLPLANTYPE].[ROWVERSION],
        GETUTCDATE(),
        [PLPLANTYPE].[LASTCHANGEDBY],	
        'Plan Type CAP File Type Added',
        '',
        '',       
		'Plan Type (' + [PLPLANTYPE].[PLANNAME] + '), Work Class Name (' + [PLPLANWORKCLASS].[NAME] +'), File Name (' + [inserted].[NAME] +')',
		'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
		1,
		0,
		[inserted].[NAME]
    FROM [inserted]	
	INNER JOIN [PLPLANWORKCLASS] WITH (NOLOCK) ON [PLPLANWORKCLASS].[PLPLANWORKCLASSID] = [inserted].[OBJECTCLASSID]
	INNER JOIN [PLPLANTYPEWORKCLASS] ON [PLPLANTYPEWORKCLASS].[PLPLANTYPEWORKCLASSID] = [inserted].[OBJECTTYPEID]	
	INNER JOIN [PLPLANTYPE] ON [PLPLANTYPE].[PLPLANTYPEID] = [PLPLANTYPEWORKCLASS].[PLPLANTYPEID]	

	UNION ALL
	SELECT 
			[BLEXTCOMPANYTYPE].[BLEXTCOMPANYTYPEID],
			[BLEXTCOMPANYTYPE].[ROWVERSION],
			GETUTCDATE(),
			[BLEXTCOMPANYTYPE].[LASTCHANGEDBY],
			'Business Company Type CAP File Type Added',
			'',
			'',
			'Business Company Type (' + [BLEXTCOMPANYTYPE].[NAME] + '),  CAP File Type (' + [inserted].[NAME] + ')',
			null,
			1,
			0,
			[inserted].[NAME]
	FROM	[inserted]
	JOIN BLEXTCOMPANYTYPE ON [inserted].[OBJECTTYPEID] = BLEXTCOMPANYTYPE.BLEXTCOMPANYTYPEID	

	UNION ALL
	SELECT DISTINCT
        [BLLICENSETYPE].[BLLICENSETYPEID], 
        [BLLICENSETYPE].[ROWVERSION],
        GETUTCDATE(),
        [BLLICENSETYPE].[LASTCHANGEDBY],	
        'Business License Type CAP File Type Added',
        '',
        '',       
		'Business License Type (' + [BLLICENSETYPE].[NAME] + '), License Classification Name (' + [BLLICENSECLASS].[NAME] +'), File Name (' + [inserted].[NAME] +')',
		'8C9D2A3A-2F18-45CE-B059-33A98C1EA148',
		1,
		0,
		[inserted].[NAME]
    FROM [inserted]	
	INNER JOIN [BLLICENSECLASS] WITH (NOLOCK) ON [BLLICENSECLASS].[BLLICENSECLASSID] = [inserted].[OBJECTCLASSID]
	INNER JOIN [BLLICENSETYPECLASS]  ON [BLLICENSETYPECLASS].[BLLICENSECLASSID] = [BLLICENSECLASS].[BLLICENSECLASSID]	
	INNER JOIN [BLLICENSETYPE]  ON [BLLICENSETYPE].[BLLICENSETYPEID] = [BLLICENSETYPECLASS].[BLLICENSETYPEID] AND [BLLICENSETYPE].[BLLICENSETYPEID]=  [inserted].[OBJECTTYPEID]
	
	UNION ALL
	SELECT DISTINCT
        [ILLICENSETYPE].[ILLICENSETYPEID], 
        [ILLICENSETYPE].[ROWVERSION],
        GETUTCDATE(),
        [ILLICENSETYPE].[LASTCHANGEDBY],	
        'Professional License Type CAP File Type Added',
        '',
        '',       
		'Professional License Type (' + [ILLICENSETYPE].[NAME] + '), Professional License Classification Name (' + [ILLICENSECLASSIFICATION].[NAME] +'), File Name (' + [inserted].[NAME] +')',
		'67978C16-D720-4F8E-8120-E00FBB732A77',
		1,
		0,
		[inserted].[NAME]
    FROM [inserted]	
	INNER JOIN [ILLICENSECLASSIFICATION] WITH (NOLOCK) ON [ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID] = [inserted].[OBJECTCLASSID]
	INNER JOIN [ILLICENSETYPELICENSECLASS]  ON [ILLICENSETYPELICENSECLASS].[ILLICENSECLASSIFICATIONID] =[ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID]	
	INNER JOIN [ILLICENSETYPE]  ON [ILLICENSETYPE].[ILLICENSETYPEID] = [ILLICENSETYPELICENSECLASS].[ILLICENSETYPEID] AND [ILLICENSETYPE].[ILLICENSETYPEID] = [inserted].[OBJECTTYPEID]
END