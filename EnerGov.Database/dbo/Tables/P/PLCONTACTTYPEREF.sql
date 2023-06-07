﻿CREATE TABLE [dbo].[PLCONTACTTYPEREF] (
    [CONTACTTYPEEXTID]            CHAR (36) NOT NULL,
    [LANDMANAGEMENTCONTACTTYPEID] CHAR (36) NOT NULL,
    [CONTACTTYPEGROUP]            INT       NULL,
    [ISREQUIRED]                  BIT       CONSTRAINT [DF_PLCONTACTTYPEREF_REQ] DEFAULT ((0)) NOT NULL,
    [OBJCLASSID]                  CHAR (36) NULL,
    [OBJTYPEID]                   CHAR (36) NULL,
    [OBJMODULEID]                 INT       NOT NULL,
    CONSTRAINT [PK_PLCONTACTTYPEREF] PRIMARY KEY CLUSTERED ([CONTACTTYPEEXTID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PLCONTACTTYPEREF_COTYPE] FOREIGN KEY ([LANDMANAGEMENTCONTACTTYPEID]) REFERENCES [dbo].[LANDMANAGEMENTCONTACTTYPE] ([LANDMANAGEMENTCONTACTTYPEID])
);


GO

CREATE TRIGGER [TG_PLCONTACTTYPEREF_UPDATE_APPLICATION] ON PLCONTACTTYPEREF
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
			[PLAPPLICATIONTYPE].[PLAPPLICATIONTYPEID],
			[PLAPPLICATIONTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PLAPPLICATIONTYPE].[LASTCHANGEDBY],
			'Set',
			CAST(ISNULL([deleted].[CONTACTTYPEGROUP], '[none]') AS NVARCHAR(MAX)),
			CAST(ISNULL([inserted].[CONTACTTYPEGROUP], '[none]') AS NVARCHAR(MAX)),
			'Contact Type (' + [LANDMANAGEMENTCONTACTTYPE].[NAME] + ')',
			'0C9FECFF-F1B4-4A19-A89B-F7B414BC8D46',
			2,
			0,
			[LANDMANAGEMENTCONTACTTYPE].[NAME]
	FROM	[deleted]
	INNER JOIN [inserted] ON [deleted].CONTACTTYPEEXTID = [inserted].CONTACTTYPEEXTID
	INNER JOIN PLAPPLICATIONTYPE ON [inserted].OBJMODULEID = 0 AND PLAPPLICATIONTYPE.PLAPPLICATIONTYPEID = [inserted].OBJTYPEID
	INNER JOIN LANDMANAGEMENTCONTACTTYPE WITH (NOLOCK) ON LANDMANAGEMENTCONTACTTYPE.LANDMANAGEMENTCONTACTTYPEID = [inserted].LANDMANAGEMENTCONTACTTYPEID
	WHERE	ISNULL([deleted].[CONTACTTYPEGROUP], -2147483648) <> ISNULL([inserted].[CONTACTTYPEGROUP], -2147483648)
	UNION ALL
	SELECT
			[PLAPPLICATIONTYPE].[PLAPPLICATIONTYPEID],
			[PLAPPLICATIONTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PLAPPLICATIONTYPE].[LASTCHANGEDBY],
			'Required Flag',
			CASE WHEN [deleted].[ISREQUIRED] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[ISREQUIRED] = 1 THEN 'Yes' ELSE 'No' END,
			'Contact Type (' + [LANDMANAGEMENTCONTACTTYPE].[NAME] + ')',
			'0C9FECFF-F1B4-4A19-A89B-F7B414BC8D46',
			2,
			0,
			[LANDMANAGEMENTCONTACTTYPE].[NAME]
	FROM	[deleted]
	INNER JOIN [inserted] ON [deleted].CONTACTTYPEEXTID = [inserted].CONTACTTYPEEXTID
	INNER JOIN PLAPPLICATIONTYPE ON [inserted].OBJMODULEID = 0 AND PLAPPLICATIONTYPE.PLAPPLICATIONTYPEID = [inserted].OBJTYPEID
	INNER JOIN LANDMANAGEMENTCONTACTTYPE WITH (NOLOCK) ON LANDMANAGEMENTCONTACTTYPE.LANDMANAGEMENTCONTACTTYPEID = [inserted].LANDMANAGEMENTCONTACTTYPEID
	WHERE	[deleted].[ISREQUIRED] <> [inserted].[ISREQUIRED]

	UNION ALL
	SELECT 
			[PLPLANTYPE].[PLPLANTYPEID],
			[PLPLANTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PLPLANTYPE].[LASTCHANGEDBY],
			'Contact Type Required Flag',
			CASE [deleted].[ISREQUIRED] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[ISREQUIRED] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Plan Type (' + [PLPLANTYPE].[PLANNAME] + '), Work Class Name (' + ISNULL([PLPLANWORKCLASS].[NAME],'[none]') +'), Contact Type (' + [LANDMANAGEMENTCONTACTTYPE].[NAME] +')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			0,
			[LANDMANAGEMENTCONTACTTYPE].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CONTACTTYPEEXTID] = [inserted].[CONTACTTYPEEXTID]
			INNER JOIN [LANDMANAGEMENTCONTACTTYPE] WITH (NOLOCK) ON [LANDMANAGEMENTCONTACTTYPE].[LANDMANAGEMENTCONTACTTYPEID] = [inserted].[LANDMANAGEMENTCONTACTTYPEID]
			INNER JOIN [PLPLANWORKCLASS] WITH (NOLOCK) ON [PLPLANWORKCLASS].[PLPLANWORKCLASSID] = [inserted].[OBJCLASSID]
			INNER JOIN [PLPLANTYPEWORKCLASS] ON [PLPLANTYPEWORKCLASS].[PLPLANTYPEWORKCLASSID] = [inserted].[OBJTYPEID]
			INNER JOIN [PLPLANTYPE] ON [PLPLANTYPE].[PLPLANTYPEID]= [PLPLANTYPEWORKCLASS].[PLPLANTYPEID]
	WHERE	[deleted].[ISREQUIRED] <> [inserted].[ISREQUIRED]
	UNION ALL
	SELECT 
			[PLPLANTYPE].[PLPLANTYPEID],
			[PLPLANTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PLPLANTYPE].[LASTCHANGEDBY],
			'Plan Type Contact Type Set',
			ISNULL(CONVERT(NVARCHAR(MAX),[deleted].[CONTACTTYPEGROUP]),'[none]'),
			ISNULL(CONVERT(NVARCHAR(MAX),[inserted].[CONTACTTYPEGROUP]),'[none]'),
			'Plan Type (' + [PLPLANTYPE].[PLANNAME] + '), Work Class Name (' + ISNULL([PLPLANWORKCLASS].[NAME],'[none]') +'), Contact Type (' + [LANDMANAGEMENTCONTACTTYPE].[NAME] +')',
			'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
			2,
			0,
			[LANDMANAGEMENTCONTACTTYPE].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CONTACTTYPEEXTID] = [inserted].[CONTACTTYPEEXTID]
			INNER JOIN [LANDMANAGEMENTCONTACTTYPE] WITH (NOLOCK) ON [LANDMANAGEMENTCONTACTTYPE].[LANDMANAGEMENTCONTACTTYPEID] = [inserted].[LANDMANAGEMENTCONTACTTYPEID]
			INNER JOIN [PLPLANWORKCLASS] WITH (NOLOCK) ON [PLPLANWORKCLASS].[PLPLANWORKCLASSID] = [inserted].[OBJCLASSID]
			INNER JOIN [PLPLANTYPEWORKCLASS] ON [PLPLANTYPEWORKCLASS].[PLPLANTYPEWORKCLASSID] = [inserted].[OBJTYPEID]
			INNER JOIN [PLPLANTYPE] ON [PLPLANTYPE].[PLPLANTYPEID] = [PLPLANTYPEWORKCLASS].[PLPLANTYPEID]
	WHERE	ISNULL([deleted].[CONTACTTYPEGROUP],'') <> ISNULL([inserted].[CONTACTTYPEGROUP],'')
END
GO

CREATE TRIGGER [TG_PLCONTACTTYPEREF_DELETE_APPLICATION] ON PLCONTACTTYPEREF
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
			[PLAPPLICATIONTYPE].[PLAPPLICATIONTYPEID],
			[PLAPPLICATIONTYPE].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Application Contact Type Deleted',
			'',
			'',
			'Contact Type (' + [LANDMANAGEMENTCONTACTTYPE].[NAME] + ')',
			'0C9FECFF-F1B4-4A19-A89B-F7B414BC8D46',
			3,
			0,
			[LANDMANAGEMENTCONTACTTYPE].[NAME]
	FROM	[deleted]
	INNER JOIN PLAPPLICATIONTYPE ON [deleted].OBJMODULEID = 0 AND PLAPPLICATIONTYPE.PLAPPLICATIONTYPEID = [deleted].OBJTYPEID 
	INNER JOIN LANDMANAGEMENTCONTACTTYPE WITH (NOLOCK) ON LANDMANAGEMENTCONTACTTYPE.LANDMANAGEMENTCONTACTTYPEID = [deleted].LANDMANAGEMENTCONTACTTYPEID
	UNION ALL
	SELECT
		[PLPLANTYPE].[PLPLANTYPEID],
		[PLPLANTYPE].[ROWVERSION],
		GETUTCDATE(),			
		(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
		'Plan Type Contact Type Deleted',
        '',
        '',       
		'Plan Type (' + [PLPLANTYPE].[PLANNAME] + '), Work Class Name (' + ISNULL([PLPLANWORKCLASS].[NAME],'[none]') +'), Contact Type (' + [LANDMANAGEMENTCONTACTTYPE].[NAME] +')',
		'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
		3,
		0,
		[LANDMANAGEMENTCONTACTTYPE].[NAME]
    FROM [deleted]
	INNER JOIN [LANDMANAGEMENTCONTACTTYPE] WITH (NOLOCK) ON [LANDMANAGEMENTCONTACTTYPE].[LANDMANAGEMENTCONTACTTYPEID] = [deleted].[LANDMANAGEMENTCONTACTTYPEID]
	INNER JOIN [PLPLANWORKCLASS] WITH (NOLOCK) ON [PLPLANWORKCLASS].[PLPLANWORKCLASSID]  = [deleted].[OBJCLASSID]
	INNER JOIN [PLPLANTYPEWORKCLASS] ON [PLPLANTYPEWORKCLASS].[PLPLANTYPEWORKCLASSID] = [deleted].[OBJTYPEID]	
	INNER JOIN [PLPLANTYPE] ON [PLPLANTYPE].[PLPLANTYPEID]  = [PLPLANTYPEWORKCLASS].[PLPLANTYPEID]
END
GO

CREATE TRIGGER [TG_PLCONTACTTYPEREF_INSERT_APPLICATION] ON PLCONTACTTYPEREF
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
			[PLAPPLICATIONTYPE].[PLAPPLICATIONTYPEID],
			[PLAPPLICATIONTYPE].[ROWVERSION],
			GETUTCDATE(),
			[PLAPPLICATIONTYPE].[LASTCHANGEDBY],
			'Application Contact Type Added',
			'',
			'',
			'Contact Type (' + [LANDMANAGEMENTCONTACTTYPE].[NAME] + ')',
			'0C9FECFF-F1B4-4A19-A89B-F7B414BC8D46',
			1,
			0,
			[LANDMANAGEMENTCONTACTTYPE].[NAME]
	FROM	[inserted]	
	INNER JOIN PLAPPLICATIONTYPE ON [inserted].OBJMODULEID = 0 AND PLAPPLICATIONTYPE.PLAPPLICATIONTYPEID = [inserted].OBJTYPEID 
	INNER JOIN LANDMANAGEMENTCONTACTTYPE WITH (NOLOCK) ON LANDMANAGEMENTCONTACTTYPE.LANDMANAGEMENTCONTACTTYPEID = [inserted].LANDMANAGEMENTCONTACTTYPEID

	UNION ALL
	SELECT 
        [PLPLANTYPE].[PLPLANTYPEID], 
        [PLPLANTYPE].[ROWVERSION],
        GETUTCDATE(),
        [PLPLANTYPE].[LASTCHANGEDBY],	
        'Plan Type Contact Type Added',
        '',
        '',       
		'Plan Type (' + ISNULL([PLPLANTYPE].[PLANNAME],'[none]') + '), Work Class Name (' + ISNULL([PLPLANWORKCLASS].[NAME],'[none]') +'), Contact Type (' + [LANDMANAGEMENTCONTACTTYPE].[NAME] +')',
		'DEC0149B-EF4A-4E0F-AA4A-E622B90C1545',
		1,
		0,
		[LANDMANAGEMENTCONTACTTYPE].[NAME]
    FROM [inserted]
	INNER JOIN [LANDMANAGEMENTCONTACTTYPE] WITH (NOLOCK) ON [LANDMANAGEMENTCONTACTTYPE].[LANDMANAGEMENTCONTACTTYPEID] = [inserted].[LANDMANAGEMENTCONTACTTYPEID]
	INNER JOIN [PLPLANWORKCLASS] WITH (NOLOCK) ON [PLPLANWORKCLASS].[PLPLANWORKCLASSID]  = [inserted].[OBJCLASSID]
	INNER JOIN [PLPLANTYPEWORKCLASS] ON [PLPLANTYPEWORKCLASS].[PLPLANTYPEWORKCLASSID]= [inserted].[OBJTYPEID]	
	INNER JOIN [PLPLANTYPE] ON [PLPLANTYPE].[PLPLANTYPEID]= [PLPLANTYPEWORKCLASS].[PLPLANTYPEID]
END