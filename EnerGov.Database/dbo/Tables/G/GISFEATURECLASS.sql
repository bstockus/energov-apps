CREATE TABLE [dbo].[GISFEATURECLASS] (
    [GISFEATURECLASSID] CHAR (36)     NOT NULL,
    [LAYERNUMBER]       INT           NULL,
    [ATTRIBUTEFIELD]    VARCHAR (50)  NULL,
    [LAYERURL]          VARCHAR (200) NULL,
    [LAYERNAME]         VARCHAR (50)  NULL,
    [ALIAS]             VARCHAR (50)  NULL,
    [LASTCHANGEDBY]     CHAR (36)     NULL,
    [LASTCHANGEDON]     DATETIME      CONSTRAINT [DF_GISFEATURECLASS_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]        INT           CONSTRAINT [DF_GISFEATURECLASS_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_GISFeatureClass] PRIMARY KEY CLUSTERED ([GISFEATURECLASSID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [GISFEATURECLASS_IX_QUERY]
    ON [dbo].[GISFEATURECLASS]([GISFEATURECLASSID] ASC, [ALIAS] ASC);


GO

CREATE TRIGGER [dbo].[TG_GISFEATURECLASS_DELTE] ON [dbo].[GISFEATURECLASS]
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
			[deleted].[GISFEATURECLASSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Feature Class Deleted',
			'',
			'',
			'Feature Class (' + ISNULL([deleted].[ALIAS], '[none]') + ')',
			'A85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			3,
			1,
			ISNULL([deleted].[ALIAS], '[none]')
	FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_GISFEATURECLASS_UPDATE] ON [dbo].[GISFEATURECLASS]
	AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of GISFEATURECLASS table with USERS table.
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
			[inserted].[GISFEATURECLASSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Alias',
			ISNULL([deleted].[ALIAS], '[none]'),
			ISNULL([inserted].[ALIAS], '[none]'),
			'Feature Class (' + ISNULL([inserted].[ALIAS], '[none]') + ')',
			'A85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			ISNULL([inserted].[ALIAS], '[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISFEATURECLASSID] = [inserted].[GISFEATURECLASSID]			
	WHERE	ISNULL([deleted].[ALIAS], '') <> ISNULL([inserted].[ALIAS], '')
	UNION ALL

	SELECT			
			[inserted].[GISFEATURECLASSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Attribute Field',
			ISNULL([deleted].[ATTRIBUTEFIELD], '[none]'),
			ISNULL([inserted].[ATTRIBUTEFIELD], '[none]'),
			'Feature Class (' + ISNULL([inserted].[ALIAS], '[none]') + ')',
			'A85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			ISNULL([inserted].[ALIAS], '[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISFEATURECLASSID] = [inserted].[GISFEATURECLASSID]			
	WHERE	ISNULL([deleted].[ATTRIBUTEFIELD], '') <> ISNULL([inserted].[ATTRIBUTEFIELD], '')
	UNION ALL

	SELECT			
			[inserted].[GISFEATURECLASSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Layer Number',			
			ISNULL(CAST([deleted].[LAYERNUMBER] AS NVARCHAR(MAX)), '[none]'),
			ISNULL(CAST([inserted].[LAYERNUMBER] AS NVARCHAR(MAX)), '[none]'),
			'Feature Class (' + ISNULL([inserted].[ALIAS], '[none]') + ')',
			'A85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			ISNULL([inserted].[ALIAS], '[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISFEATURECLASSID] = [inserted].[GISFEATURECLASSID]			
	WHERE	ISNULL([deleted].[LAYERNUMBER], '') <> ISNULL([inserted].[LAYERNUMBER], '')
	UNION ALL

	SELECT			
			[inserted].[GISFEATURECLASSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Layer URL',
			ISNULL([deleted].[LAYERURL], '[none]'),
			ISNULL([inserted].[LAYERURL], '[none]'),
			'Feature Class (' + ISNULL([inserted].[ALIAS], '[none]') + ')',
			'A85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			ISNULL([inserted].[ALIAS], '[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISFEATURECLASSID] = [inserted].[GISFEATURECLASSID]			
	WHERE	ISNULL([deleted].[LAYERURL], '') <> ISNULL([inserted].[LAYERURL], '')
	UNION ALL

	SELECT			
			[inserted].[GISFEATURECLASSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Feature Class',
			ISNULL([deleted].[LAYERNAME], '[none]'),
			ISNULL([inserted].[LAYERNAME], '[none]'),
			'Feature Class (' + ISNULL([inserted].[ALIAS], '[none]') + ')',
			'A85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			1,
			ISNULL([inserted].[ALIAS], '[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISFEATURECLASSID] = [inserted].[GISFEATURECLASSID]			
	WHERE	ISNULL([deleted].[LAYERNAME], '') <> ISNULL([inserted].[LAYERNAME], '')
END
GO

CREATE TRIGGER [dbo].[TG_GISFEATURECLASS_INSERT] ON [dbo].[GISFEATURECLASS]
	AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of GISFEATURECLASS table with USERS table.
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
			[inserted].[GISFEATURECLASSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Feature Class Added',
			'',
			'',
			'Feature Class (' + ISNULL([inserted].[ALIAS], '[none]') + ')',
			'A85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			1,
			1,
			ISNULL([inserted].[ALIAS], '[none]')
	FROM	[inserted]
END