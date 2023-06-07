CREATE TABLE [dbo].[RPTIMAGELIB] (
    [RPTIMAGELIBID] CHAR (36)       NOT NULL,
    [IMAGENAME]     NVARCHAR (50)   NOT NULL,
    [FILENAME]      NVARCHAR (150)  NULL,
    [PRIORFILENAME] NVARCHAR (150)  NULL,
    [DIMENSIONS]    NVARCHAR (50)   NULL,
    [IMAGE]         VARBINARY (MAX) NULL,
    [LASTCHANGEDBY] CHAR (36)       NULL,
    [LASTCHANGEDON] DATETIME        CONSTRAINT [DF_RPTIMAGELIB_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]    INT             CONSTRAINT [DF_RPTIMAGELIB_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_RPTIMAGELIB] PRIMARY KEY CLUSTERED ([RPTIMAGELIBID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [RPTIMAGELIB_IX_QUERY]
    ON [dbo].[RPTIMAGELIB]([RPTIMAGELIBID] ASC, [IMAGENAME] ASC);


GO

CREATE TRIGGER [TG_RPTIMAGELIB_DELETE] ON [RPTIMAGELIB]
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
			[deleted].[RPTIMAGELIBID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Report Image Library Deleted',
			'',
			'',
			'Report Image Library (' + [deleted].[IMAGENAME] + ')',
			'EFF66BD4-70D2-4DF3-BD50-34CA45961EA3',
			3,
			1,
			[deleted].[IMAGENAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [TG_RPTIMAGELIB_UPDATE] ON [RPTIMAGELIB]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of RPTIMAGELIB table with USERS table.
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
			[inserted].[RPTIMAGELIBID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Image Name',
			[deleted].[IMAGENAME],
			[inserted].[IMAGENAME],
			'Report Image Library (' + [inserted].[IMAGENAME] + ')',
			'EFF66BD4-70D2-4DF3-BD50-34CA45961EA3',
			2,
			1,
			[inserted].[IMAGENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPTIMAGELIBID] = [inserted].[RPTIMAGELIBID]
	WHERE	[deleted].[IMAGENAME] <> [inserted].[IMAGENAME]	
	UNION ALL
	SELECT
			[inserted].[RPTIMAGELIBID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'File Name',
			ISNULL([deleted].[FILENAME], '[none]'),
			ISNULL([inserted].[FILENAME], '[none]'),
			'Report Image Library (' + [inserted].[IMAGENAME] + ')',
			'EFF66BD4-70D2-4DF3-BD50-34CA45961EA3',
			2,
			1,
			[inserted].[IMAGENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPTIMAGELIBID] = [inserted].[RPTIMAGELIBID]
	WHERE	ISNULL([deleted].[FILENAME], '') <> ISNULL([inserted].[FILENAME], '')
	UNION ALL
	SELECT
			[inserted].[RPTIMAGELIBID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Prior File Name',
			ISNULL([deleted].[PRIORFILENAME], '[none]'),
			ISNULL([inserted].[PRIORFILENAME], '[none]'),
			'Report Image Library (' + [inserted].[IMAGENAME] + ')',
			'EFF66BD4-70D2-4DF3-BD50-34CA45961EA3',
			2,
			1,
			[inserted].[IMAGENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPTIMAGELIBID] = [inserted].[RPTIMAGELIBID]
	WHERE	ISNULL([deleted].[PRIORFILENAME], '') <> ISNULL([inserted].[PRIORFILENAME], '')
	UNION ALL
	SELECT
			[inserted].[RPTIMAGELIBID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Dimensions',
			ISNULL([deleted].[DIMENSIONS], '[none]'),
			ISNULL([inserted].[DIMENSIONS], '[none]'),
			'Report Image Library (' + [inserted].[IMAGENAME] + ')',
			'EFF66BD4-70D2-4DF3-BD50-34CA45961EA3',
			2,
			1,
			[inserted].[IMAGENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPTIMAGELIBID] = [inserted].[RPTIMAGELIBID]
	WHERE	ISNULL([deleted].[DIMENSIONS], '') <> ISNULL([inserted].[DIMENSIONS], '')
	UNION ALL
	SELECT
			[inserted].[RPTIMAGELIBID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Image',
			CASE WHEN [deleted].[IMAGE] IS NULL THEN '[none]' ELSE 'Image' END,
			CASE WHEN [inserted].[IMAGE] IS NULL THEN '[none]' ELSE 'Image' END,
			'Report Image Library (' + [inserted].[IMAGENAME] + ')',
			'EFF66BD4-70D2-4DF3-BD50-34CA45961EA3',
			2,
			1,
			[inserted].[IMAGENAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[RPTIMAGELIBID] = [inserted].[RPTIMAGELIBID]
	WHERE	[deleted].[IMAGE] <> [inserted].[IMAGE] OR 
			([deleted].[IMAGE] IS NULL AND [inserted].[IMAGE] IS NOT NULL) OR
			([deleted].[IMAGE] IS NOT NULL AND [inserted].[IMAGE] IS NULL)
END
GO

CREATE TRIGGER [TG_RPTIMAGELIB_INSERT] ON [RPTIMAGELIB]
   FOR INSERT
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of RPTIMAGELIB table with USERS table.
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
			[inserted].[RPTIMAGELIBID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Report Image Library Added',
			'',
			'',
			'Report Image Library (' + [inserted].[IMAGENAME] + ')',
			'EFF66BD4-70D2-4DF3-BD50-34CA45961EA3',
			1,
			1,
			[inserted].[IMAGENAME]
	FROM	[inserted]	
END