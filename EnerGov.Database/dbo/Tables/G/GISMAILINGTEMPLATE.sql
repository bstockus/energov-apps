CREATE TABLE [dbo].[GISMAILINGTEMPLATE] (
    [GISMAILINGTEMPLATEID] CHAR (36)      NOT NULL,
    [NAME]                 NVARCHAR (250) NOT NULL,
    [DESCRIPTION]          NVARCHAR (500) NULL,
    [MAPSERVICEURL]        NVARCHAR (MAX) NOT NULL,
    [FEATURECLASSNAME]     NVARCHAR (500) NULL,
    [NAME1]                NVARCHAR (500) NULL,
    [NAME2]                NVARCHAR (500) NULL,
    [ADDRESS1]             NVARCHAR (500) NULL,
    [ADDRESS2]             NVARCHAR (500) NULL,
    [ADDRESS3]             NVARCHAR (500) NULL,
    [ADDRESS4]             NVARCHAR (500) NULL,
    [LASTCHANGEDBY]        CHAR (36)      NULL,
    [LASTCHANGEDON]        DATETIME       CONSTRAINT [DF_GISMAILINGTEMPLATE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]           INT            CONSTRAINT [DF_GISMAILINGTEMPLATE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_GISMAILINGTEMPLATE] PRIMARY KEY CLUSTERED ([GISMAILINGTEMPLATEID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [GISMAILINGTEMPLATE_IX_QUERY]
    ON [dbo].[GISMAILINGTEMPLATE]([GISMAILINGTEMPLATEID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_GISMAILINGTEMPLATE_UPDATE] ON [dbo].[GISMAILINGTEMPLATE]
	AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of GISMAILINGTEMPLATE table with USERS table.
	IF EXISTS (SELECT * FROM inserted 
		LEFT OUTER JOIN USERS WITH (NOLOCK) ON USERS.SUSERGUID = inserted.LASTCHANGEDBY
		WHERE inserted.LASTCHANGEDBY IS NOT NULL AND USERS.SUSERGUID IS NULL)
	BEGIN		
		RAISERROR ('The INSERT or UPDATE statement conflicted with the FOREIGN KEY to table USERS', 16, 0);
		ROLLBACK;
		RETURN;
	END

	INSERT INTO [HISTORYSYSTEMSETUP]
			([ID],
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
			[RECORDNAME])
	SELECT			
			[inserted].[GISMAILINGTEMPLATEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'GIS Mailing Template (' + [inserted].[NAME] + ')',
			'ddb79624-6894-476e-9786-bacd51ab1445',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISMAILINGTEMPLATEID] = [inserted].[GISMAILINGTEMPLATEID]			
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL

	SELECT			
			[inserted].[GISMAILINGTEMPLATEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION], '[none]'),
			ISNULL([inserted].[DESCRIPTION], '[none]'),
			'GIS Mailing Template (' + [inserted].[NAME] + ')',
			'ddb79624-6894-476e-9786-bacd51ab1445',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISMAILINGTEMPLATEID] = [inserted].[GISMAILINGTEMPLATEID]			
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL

	SELECT			
			[inserted].[GISMAILINGTEMPLATEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Map Service URL',
			[deleted].[MAPSERVICEURL],
			[inserted].[MAPSERVICEURL],
			'GIS Mailing Template (' + [inserted].[NAME] + ')',
			'ddb79624-6894-476e-9786-bacd51ab1445',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISMAILINGTEMPLATEID] = [inserted].[GISMAILINGTEMPLATEID]			
	WHERE	[deleted].[MAPSERVICEURL] <> [inserted].[MAPSERVICEURL]	
	UNION ALL

	SELECT			
			[inserted].[GISMAILINGTEMPLATEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Feature Class Name',
			ISNULL([deleted].[FEATURECLASSNAME], '[none]'),
			ISNULL([inserted].[FEATURECLASSNAME], '[none]'),
			'GIS Mailing Template (' + [inserted].[NAME] + ')',
			'ddb79624-6894-476e-9786-bacd51ab1445',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISMAILINGTEMPLATEID] = [inserted].[GISMAILINGTEMPLATEID]			
	WHERE	ISNULL([deleted].[FEATURECLASSNAME], '') <> ISNULL([inserted].[FEATURECLASSNAME], '')
	UNION ALL

	SELECT			
			[inserted].[GISMAILINGTEMPLATEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name Line 1',
			ISNULL([deleted].[NAME1], '[none]'),
			ISNULL([inserted].[NAME1], '[none]'),
			'GIS Mailing Template (' + [inserted].[NAME] + ')',
			'ddb79624-6894-476e-9786-bacd51ab1445',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISMAILINGTEMPLATEID] = [inserted].[GISMAILINGTEMPLATEID]			
	WHERE	ISNULL([deleted].[NAME1], '') <> ISNULL([inserted].[NAME1], '')
	UNION ALL

	SELECT			
			[inserted].[GISMAILINGTEMPLATEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name Line 2',
			ISNULL([deleted].[NAME2], '[none]'),
			ISNULL([inserted].[NAME2], '[none]'),
			'GIS Mailing Template (' + [inserted].[NAME] + ')',
			'ddb79624-6894-476e-9786-bacd51ab1445',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISMAILINGTEMPLATEID] = [inserted].[GISMAILINGTEMPLATEID]			
	WHERE	ISNULL([deleted].[NAME2], '') <> ISNULL([inserted].[NAME2], '')
	UNION ALL

	SELECT			
			[inserted].[GISMAILINGTEMPLATEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Address Line 1',
			ISNULL([deleted].[ADDRESS1], '[none]'),
			ISNULL([inserted].[ADDRESS1], '[none]'),
			'GIS Mailing Template (' + [inserted].[NAME] + ')',
			'ddb79624-6894-476e-9786-bacd51ab1445',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISMAILINGTEMPLATEID] = [inserted].[GISMAILINGTEMPLATEID]			
	WHERE	ISNULL([deleted].[ADDRESS1], '') <> ISNULL([inserted].[ADDRESS1], '')
	UNION ALL

	SELECT			
			[inserted].[GISMAILINGTEMPLATEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Address Line 2',
			ISNULL([deleted].[ADDRESS2], '[none]'),
			ISNULL([inserted].[ADDRESS2], '[none]'),
			'GIS Mailing Template (' + [inserted].[NAME] + ')',
			'ddb79624-6894-476e-9786-bacd51ab1445',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISMAILINGTEMPLATEID] = [inserted].[GISMAILINGTEMPLATEID]			
	WHERE	ISNULL([deleted].[ADDRESS2], '') <> ISNULL([inserted].[ADDRESS2], '')
	UNION ALL

	SELECT			
			[inserted].[GISMAILINGTEMPLATEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Address Line 3',
			ISNULL([deleted].[ADDRESS3], '[none]'),
			ISNULL([inserted].[ADDRESS3], '[none]'),
			'GIS Mailing Template (' + [inserted].[NAME] + ')',
			'ddb79624-6894-476e-9786-bacd51ab1445',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISMAILINGTEMPLATEID] = [inserted].[GISMAILINGTEMPLATEID]			
	WHERE	ISNULL([deleted].[ADDRESS3], '') <> ISNULL([inserted].[ADDRESS3], '')
	UNION ALL

	SELECT			
			[inserted].[GISMAILINGTEMPLATEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Address Line 4',
			ISNULL([deleted].[ADDRESS4], '[none]'),
			ISNULL([inserted].[ADDRESS4], '[none]'),
			'GIS Mailing Template (' + [inserted].[NAME] + ')',
			'ddb79624-6894-476e-9786-bacd51ab1445',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISMAILINGTEMPLATEID] = [inserted].[GISMAILINGTEMPLATEID]			
	WHERE	ISNULL([deleted].[ADDRESS4], '') <> ISNULL([inserted].[ADDRESS4], '')
END
GO

CREATE TRIGGER [dbo].[TG_GISMAILINGTEMPLATE_DELTE] ON [dbo].[GISMAILINGTEMPLATE]
	AFTER DELETE
AS
BEGIN
	INSERT INTO [HISTORYSYSTEMSETUP]
			([ID],
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
			[RECORDNAME])
	SELECT
			[deleted].[GISMAILINGTEMPLATEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'GIS Mailing Template Deleted',
			'',
			'',
			'GIS Mailing Template (' + [deleted].[NAME] + ')',
			'ddb79624-6894-476e-9786-bacd51ab1445',
			3,
			1,
			[deleted].[NAME]
			FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_GISMAILINGTEMPLATE_INSERT] ON [dbo].[GISMAILINGTEMPLATE]
	AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of GISMAILINGTEMPLATE table with USERS table.
	IF EXISTS (SELECT * FROM inserted 
		LEFT OUTER JOIN USERS WITH (NOLOCK) ON USERS.SUSERGUID = inserted.LASTCHANGEDBY
		WHERE inserted.LASTCHANGEDBY IS NOT NULL AND USERS.SUSERGUID IS NULL)
	BEGIN		
		RAISERROR ('The INSERT or UPDATE statement conflicted with the FOREIGN KEY to table USERS', 16, 0);
		ROLLBACK;
		RETURN;
	END

	INSERT INTO [HISTORYSYSTEMSETUP]
			([ID],
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
			[RECORDNAME])
	SELECT
			[inserted].[GISMAILINGTEMPLATEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'GIS Mailing Template Added',
			'',
			'',
			'GIS Mailing Template (' + [inserted].[NAME] + ')',
			'ddb79624-6894-476e-9786-bacd51ab1445',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]
END