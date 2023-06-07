﻿CREATE TABLE [dbo].[GISFEATURECLASSSEARCHFIELD] (
    [GISFEATURECLASSSEARCHFIELDID] CHAR (36)     NOT NULL,
    [GISFEATURECLASSID]            CHAR (36)     NOT NULL,
    [NAME]                         VARCHAR (100) NOT NULL,
    [ALIAS]                        VARCHAR (100) NULL,
    CONSTRAINT [PK_GISFeatureClassSearchField] PRIMARY KEY CLUSTERED ([GISFEATURECLASSSEARCHFIELDID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_GISFeatureClassSearchField_GISFeatureClass] FOREIGN KEY ([GISFEATURECLASSID]) REFERENCES [dbo].[GISFEATURECLASS] ([GISFEATURECLASSID])
);


GO
CREATE NONCLUSTERED INDEX [GISFEATURECLASSSEARCHFIELD_IX_GISFEATURECLASSID]
    ON [dbo].[GISFEATURECLASSSEARCHFIELD]([GISFEATURECLASSID] ASC);


GO

CREATE TRIGGER [TG_GISFEATURECLASSSEARCHFIELD_INSERT] ON [GISFEATURECLASSSEARCHFIELD]
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
			[GISFEATURECLASS].[GISFEATURECLASSID],
			[GISFEATURECLASS].[ROWVERSION],
			GETUTCDATE(),
			[GISFEATURECLASS].[LASTCHANGEDBY],
			'Feature Class Search Field Added',
			'',
			'',
			'Feature Class (' + ISNULL([GISFEATURECLASS].[ALIAS], '[none]') + '), Search Field (' + [inserted].[NAME] + ')',
			'A85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			1,
			0,
			[inserted].[NAME]
	FROM	[inserted]
			INNER JOIN [GISFEATURECLASS] ON [inserted].[GISFEATURECLASSID] = [GISFEATURECLASS].[GISFEATURECLASSID]	
END
GO

CREATE TRIGGER [dbo].[TG_GISFEATURECLASSSEARCHFIELD_UPDATE] ON  [dbo].[GISFEATURECLASSSEARCHFIELD]
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
			[GISFEATURECLASS].[GISFEATURECLASSID],
			[GISFEATURECLASS].[ROWVERSION],
			GETUTCDATE(),
			[GISFEATURECLASS].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Feature Class (' + ISNULL([GISFEATURECLASS].[ALIAS], '[none]') + '), Search Field (' + [inserted].[NAME] + ')',
			'A85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted] JOIN [inserted] ON [deleted].[GISFEATURECLASSSEARCHFIELDID] = [inserted].[GISFEATURECLASSSEARCHFIELDID]
			INNER JOIN [GISFEATURECLASS] ON [GISFEATURECLASS].[GISFEATURECLASSID] = [inserted].[GISFEATURECLASSID]	
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL

	SELECT 
			[GISFEATURECLASS].[GISFEATURECLASSID],
			[GISFEATURECLASS].[ROWVERSION],
			GETUTCDATE(),
			[GISFEATURECLASS].[LASTCHANGEDBY],
			'Alias',
			ISNULL([deleted].[ALIAS], '[none]'),
			ISNULL([inserted].[ALIAS], '[none]'),
			'Feature Class (' + ISNULL([GISFEATURECLASS].[ALIAS], '[none]') + '), Search Field (' + [inserted].[NAME] + ')',
			'A85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			2,
			0,
			[inserted].[NAME]
	FROM	[deleted] JOIN [inserted] ON [deleted].[GISFEATURECLASSSEARCHFIELDID] = [inserted].[GISFEATURECLASSSEARCHFIELDID]
			INNER JOIN [GISFEATURECLASS] ON [GISFEATURECLASS].[GISFEATURECLASSID] = [inserted].[GISFEATURECLASSID]	
	WHERE	ISNULL([deleted].[ALIAS], '') <> ISNULL([inserted].[ALIAS], '')

END
GO

CREATE TRIGGER [TG_GISFEATURECLASSSEARCHFIELD_DELETE] ON [GISFEATURECLASSSEARCHFIELD]
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
			[GISFEATURECLASS].[GISFEATURECLASSID],
			[GISFEATURECLASS].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Feature Class Search Field Deleted',
			'',
			'',
			'Feature Class (' + ISNULL([GISFEATURECLASS].[ALIAS], '[none]') + '), Search Field (' + [deleted].[NAME] + ')',
			'A85FB7D7-45FE-4FE0-88BE-FBD958E41153',
			3,
			0,
			[deleted].[NAME]
	FROM	[deleted]	
			INNER JOIN [GISFEATURECLASS] ON [deleted].[GISFEATURECLASSID] = [GISFEATURECLASS].[GISFEATURECLASSID]	
END