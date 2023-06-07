CREATE TABLE [dbo].[BLEXTLOCATION] (
    [BLEXTLOCATIONID] CHAR (36)      NOT NULL,
    [NAME]            NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]     NVARCHAR (MAX) NULL,
    [LASTCHANGEDBY]   CHAR (36)      NULL,
    [LASTCHANGEDON]   DATETIME       CONSTRAINT [DF_BLEXTLOCATION_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]      INT            CONSTRAINT [DF_BLEXTLOCATION_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_BLExtLocation] PRIMARY KEY CLUSTERED ([BLEXTLOCATIONID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [BLEXTLOCATION_IX_QUERY]
    ON [dbo].[BLEXTLOCATION]([BLEXTLOCATIONID] ASC, [NAME] ASC);


GO


CREATE TRIGGER [dbo].[TG_BLEXTLOCATION_DELETE] ON  [dbo].[BLEXTLOCATION]
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
			[deleted].[BLEXTLOCATIONID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Business Location Deleted',
			'',
			'',
			'Business Location (' + [deleted].[NAME] + ')',
			'0B107585-7BC7-48B3-83D3-BC13C04251EB',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO


CREATE TRIGGER [dbo].[TG_BLEXTLOCATION_INSERT] ON [dbo].[BLEXTLOCATION]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BLEXTLOCATION table with USERS table.
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
        [inserted].[BLEXTLOCATIONID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Business Location Added',
        '',
        '',
        'Business Location (' + [inserted].[NAME] + ')',
		'0B107585-7BC7-48B3-83D3-BC13C04251EB',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO


CREATE TRIGGER [dbo].[TG_BLEXTLOCATION_UPDATE] ON  [dbo].[BLEXTLOCATION]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BLEXTLOCATION table with USERS table.
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
			[inserted].[BLEXTLOCATIONID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Business Location (' + [inserted].[NAME] + ')',
			'0B107585-7BC7-48B3-83D3-BC13C04251EB',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLEXTLOCATIONID] = [inserted].[BLEXTLOCATIONID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[BLEXTLOCATIONID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Business Location (' + [inserted].[NAME] + ')',
			'0B107585-7BC7-48B3-83D3-BC13C04251EB',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BLEXTLOCATIONID] = [inserted].[BLEXTLOCATIONID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
END