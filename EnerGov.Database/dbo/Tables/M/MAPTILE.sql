CREATE TABLE [dbo].[MAPTILE] (
    [MAPTILEID]      VARCHAR (36)  NOT NULL,
    [MAPNAME]        VARCHAR (35)  NOT NULL,
    [MAPDESCRIPTION] VARCHAR (200) NOT NULL,
    [MAPURL]         VARCHAR (MAX) NOT NULL,
    [MAPIMAGE]       VARCHAR (MAX) NULL,
    [USERID]         CHAR (36)     NOT NULL,
    [LASTCHANGEDBY]  CHAR (36)     NULL,
    [LASTCHANGEDON]  DATETIME      CONSTRAINT [DF_MAPTILE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]     INT           CONSTRAINT [DF_MAPTILE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_MAPTILE] PRIMARY KEY CLUSTERED ([MAPTILEID] ASC),
    CONSTRAINT [FK_MAPTILE_USER] FOREIGN KEY ([USERID]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_MAPTILE_ALL]
    ON [dbo].[MAPTILE]([USERID] ASC, [MAPTILEID] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_MAPTILE_LOOKUP]
    ON [dbo].[MAPTILE]([MAPTILEID] ASC, [USERID] ASC);


GO

CREATE TRIGGER [dbo].[TG_MAPTILE_UPDATE] ON [dbo].[MAPTILE] 
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of MAPTILE table with USERS table.
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
			[ADDITIONALINFO]
		)
	SELECT
			[inserted].[MAPTILEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Map Tile Name',
			[deleted].[MAPNAME],
			[inserted].[MAPNAME],
			'Map Tile (' + [inserted].[MAPNAME] + ')'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MAPTILEID] = [inserted].[MAPTILEID]
	WHERE	[deleted].[MAPNAME] <> [inserted].[MAPNAME]
	
	UNION ALL
	SELECT
			[inserted].[MAPTILEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Map Tile Description',
			[deleted].[MAPDESCRIPTION],
			[inserted].[MAPDESCRIPTION],
			'Map Tile (' + [inserted].[MAPNAME] + ')'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MAPTILEID] = [inserted].[MAPTILEID]
	WHERE	[deleted].[MAPDESCRIPTION] <> [inserted].[MAPDESCRIPTION]	
	UNION ALL
	SELECT
			[inserted].[MAPTILEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Map Tile URL',
			[deleted].[MAPURL],
			[inserted].[MAPURL],
			'Map Tile (' + [inserted].[MAPNAME] + ')'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MAPTILEID] = [inserted].[MAPTILEID]
	WHERE	[deleted].[MAPURL] <> [inserted].[MAPURL]		
	UNION ALL
	SELECT
			[inserted].[MAPTILEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Map Tile Image',
			ISNULL([deleted].[MAPIMAGE],'[none]'),
			ISNULL([inserted].[MAPIMAGE],'[none]'),
			'Map Tile (' + [inserted].[MAPNAME] + ')'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MAPTILEID] = [inserted].[MAPTILEID]
	WHERE	ISNULL([deleted].[MAPIMAGE],'') <> ISNULL([inserted].[MAPIMAGE],'')
	UNION ALL
	SELECT
			[inserted].[MAPTILEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Map Tile User',
			ISNULL([DELETED_USER].[LNAME],'[none]') + ', '+	ISNULL([DELETED_USER].[FNAME],'[none]') ,
			ISNULL([INSERTED_USER].[LNAME],'[none]') + ', '+	ISNULL([INSERTED_USER].[FNAME],'[none]') ,
			'Map Tile (' + [inserted].[MAPNAME] + ')'
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MAPTILEID] = [inserted].[MAPTILEID]
			INNER JOIN [dbo].[USERS] AS [INSERTED_USER] ON [inserted].[USERID]= [INSERTED_USER].[SUSERGUID]
			INNER JOIN [dbo].[USERS] AS [DELETED_USER] ON [deleted].[USERID]= [DELETED_USER].[SUSERGUID]
	WHERE	[deleted].[USERID]<> [inserted].[USERID]	
END
GO

CREATE TRIGGER [dbo].[TG_MAPTILE_DELETE] ON [dbo].[MAPTILE]
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
			[ADDITIONALINFO]
		)
	SELECT
			[deleted].[MAPTILEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Map Tile Deleted',
			'',
			'',
			'Map Tile (' + [deleted].[MAPNAME] + ')'
	FROM	[deleted]
END
GO
CREATE TRIGGER [dbo].[TG_MAPTILE_INSERT] ON [dbo].[MAPTILE]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of MAPTILE table with USERS table.
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
		[ADDITIONALINFO]
    )
	SELECT
			[inserted].[MAPTILEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Map Tile Added',
			'',
			'',
			'Map Tile (' + [inserted].[MAPNAME] + ')'
	FROM	[inserted]	
END