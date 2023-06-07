CREATE TABLE [dbo].[GISZONEMAPPING] (
    [GISZONEMAPPINGID] CHAR (36)     NOT NULL,
    [SOURCENAME]       VARCHAR (100) NOT NULL,
    [ARCGISURL]        VARCHAR (250) NOT NULL,
    [ARCGISLAYERNAME]  VARCHAR (250) NOT NULL,
    [ARCGISFIELDNAME]  VARCHAR (250) NOT NULL,
    [LASTCHANGEDBY]    CHAR (36)     NULL,
    [LASTCHANGEDON]    DATETIME      CONSTRAINT [DF_GISZONEMAPPING_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]       INT           CONSTRAINT [DF_GISZONEMAPPING_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_GISZoneMapping] PRIMARY KEY CLUSTERED ([GISZONEMAPPINGID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [GISZONEMAPPING_IX_QUERY]
    ON [dbo].[GISZONEMAPPING]([GISZONEMAPPINGID] ASC, [SOURCENAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_GISZONEMAPPING_INSERT] ON [dbo].[GISZONEMAPPING]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of GISZONEMAPPING table with USERS table
	IF EXISTS (SELECT * FROM inserted 
		LEFT OUTER JOIN USERS WITH (NOLOCK) ON USERS.SUSERGUID = inserted.LASTCHANGEDBY
		WHERE inserted.LASTCHANGEDBY IS NOT NULL AND USERS.SUSERGUID IS NULL)
	BEGIN		
		RAISERROR ('The INSERT or UPDATE statement conflicted with the FOREIGN KEY to table USERS', 16, 0);
		ROLLBACK;
		RETURN;
	END

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
        [inserted].[GISZONEMAPPINGID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Zone Inspector Mapping Added',
        '',
        '',
        'Zone Inspector Mapping (' + [inserted].[SOURCENAME] + ')',
		'D2A6823F-93FB-45DF-8F63-BE59E04D0E23',
		1,
		1,
		[inserted].[SOURCENAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_GISZONEMAPPING_UPDATE] ON  [dbo].[GISZONEMAPPING]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of GISZONEMAPPING table with USERS table.
	IF EXISTS (SELECT * FROM inserted 
		LEFT OUTER JOIN USERS WITH (NOLOCK) ON USERS.SUSERGUID = inserted.LASTCHANGEDBY
		WHERE inserted.LASTCHANGEDBY IS NOT NULL AND USERS.SUSERGUID IS NULL)
	BEGIN		
		RAISERROR ('The INSERT or UPDATE statement conflicted with the FOREIGN KEY to table USERS', 16, 0);
		ROLLBACK;
		RETURN;
	END

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
			[inserted].[GISZONEMAPPINGID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Source Name',
			[deleted].[SOURCENAME],
			[inserted].[SOURCENAME],
			'Zone Inspector Mapping (' + [inserted].[SOURCENAME] + ')',
			'D2A6823F-93FB-45DF-8F63-BE59E04D0E23',
			2,
			1,
			[inserted].[SOURCENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISZONEMAPPINGID] = [inserted].[GISZONEMAPPINGID]
	WHERE	[deleted].[SOURCENAME] <> [inserted].[SOURCENAME]	
	UNION ALL
	SELECT
			[inserted].[GISZONEMAPPINGID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'ARC GIS End Point',
			[deleted].[ARCGISURL],
			[inserted].[ARCGISURL],
			'Zone Inspector Mapping (' + [inserted].[SOURCENAME] + ')',
			'D2A6823F-93FB-45DF-8F63-BE59E04D0E23',
			2,
			1,
			[inserted].[SOURCENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISZONEMAPPINGID] = [inserted].[GISZONEMAPPINGID]
	WHERE	[deleted].[ARCGISURL] <> [inserted].[ARCGISURL]	
	UNION ALL
	SELECT
			[inserted].[GISZONEMAPPINGID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'ARC GIS Layer',
			[deleted].[ARCGISLAYERNAME],
			[inserted].[ARCGISLAYERNAME],
			'Zone Inspector Mapping (' + [inserted].[SOURCENAME] + ')',
			'D2A6823F-93FB-45DF-8F63-BE59E04D0E23',
			2,
			1,
			[inserted].[SOURCENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISZONEMAPPINGID] = [inserted].[GISZONEMAPPINGID]
	WHERE	[deleted].[ARCGISLAYERNAME] <> [inserted].[ARCGISLAYERNAME]	
	UNION ALL
	SELECT
			[inserted].[GISZONEMAPPINGID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Field Name',
			[deleted].[ARCGISFIELDNAME],
			[inserted].[ARCGISFIELDNAME],
			'Zone Inspector Mapping (' + [inserted].[SOURCENAME] + ')',
			'D2A6823F-93FB-45DF-8F63-BE59E04D0E23',
			2,
			1,
			[inserted].[SOURCENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[GISZONEMAPPINGID] = [inserted].[GISZONEMAPPINGID]
	WHERE	[deleted].[ARCGISFIELDNAME] <> [inserted].[ARCGISFIELDNAME]
END
GO

CREATE TRIGGER [dbo].[TG_GISZONEMAPPING_DELETE]  ON  [dbo].[GISZONEMAPPING]
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
			[deleted].[GISZONEMAPPINGID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Zone Inspector Mapping Deleted',
			'',
			'',
			'Zone Inspector Mapping (' + [deleted].[SOURCENAME] + ')',
			'D2A6823F-93FB-45DF-8F63-BE59E04D0E23',
			3,
			1,
			[deleted].[SOURCENAME]
	FROM	[deleted]
END