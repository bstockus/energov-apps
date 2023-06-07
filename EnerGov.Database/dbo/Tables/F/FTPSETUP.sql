CREATE TABLE [dbo].[FTPSETUP] (
    [FTPSETUPID]    CHAR (36)      NOT NULL,
    [NAME]          NVARCHAR (100) NOT NULL,
    [DESCRIPTION]   NVARCHAR (250) NULL,
    [URL]           NVARCHAR (250) NOT NULL,
    [USERNAME]      NVARCHAR (100) NOT NULL,
    [PASSWORD]      NVARCHAR (100) NOT NULL,
    [FTPTYPEID]     INT            NOT NULL,
    [PORT]          INT            NULL,
    [LASTCHANGEDBY] CHAR (36)      NOT NULL,
    [LASTCHANGEDON] DATETIME       NOT NULL,
    [ROWVERSION]    INT            NOT NULL,
    CONSTRAINT [PK_FTPSETUP] PRIMARY KEY CLUSTERED ([FTPSETUPID] ASC),
    CONSTRAINT [FK_FTPSETUP_FTPTYPE] FOREIGN KEY ([FTPTYPEID]) REFERENCES [dbo].[FTPTYPE] ([FTPTYPEID]),
    CONSTRAINT [FK_FTPSETUP_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [UC_FTPSETUP_NAME] UNIQUE NONCLUSTERED ([NAME] ASC)
);


GO
CREATE TRIGGER [dbo].[TG_FTPSETUP_UPDATE] 
    ON [dbo].[FTPSETUP]
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
			[inserted].[FTPSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Ftp Setup Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Ftp Setup (' + [inserted].[NAME] + ')',
			'0EE48696-E302-4061-8F42-93655DBF3230',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]	JOIN [inserted] ON [deleted].[FTPSETUPID] = [inserted].[FTPSETUPID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]

	UNION ALL

	SELECT
			[inserted].[FTPSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Ftp Setup Description',
			ISNULL([deleted].[DESCRIPTION], N'[none]'),
			ISNULL([inserted].[DESCRIPTION], N'[none]'),
			'Ftp Setup (' + [inserted].[NAME] + ')',
			'0EE48696-E302-4061-8F42-93655DBF3230',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[FTPSETUPID] = [inserted].[FTPSETUPID]	
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')

	UNION ALL

	SELECT
			[inserted].[FTPSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Ftp Setup Url',
			[deleted].[URL],
			[inserted].[URL],
			'Ftp Setup (' + [inserted].[NAME] + ')',
			'0EE48696-E302-4061-8F42-93655DBF3230',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[FTPSETUPID] = [inserted].[FTPSETUPID]	
	WHERE	[deleted].[URL] <> [inserted].[URL]

	UNION ALL

	SELECT
			[inserted].[FTPSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Ftp Setup UserName',
			[deleted].[USERNAME],
			[inserted].[USERNAME],
			'Ftp Setup (' + [inserted].[NAME] + ')',
			'0EE48696-E302-4061-8F42-93655DBF3230',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[FTPSETUPID] = [inserted].[FTPSETUPID]	
	WHERE	[deleted].[USERNAME] <> [inserted].[USERNAME]

	UNION ALL

	SELECT
			[inserted].[FTPSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Ftp Setup Password',
			[deleted].[PASSWORD],
			[inserted].[PASSWORD],
			'Ftp Setup (' + [inserted].[NAME] + ')',
			'0EE48696-E302-4061-8F42-93655DBF3230',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[FTPSETUPID] = [inserted].[FTPSETUPID]	
	WHERE	[deleted].[PASSWORD] <> [inserted].[PASSWORD]

	UNION ALL

	SELECT
			[inserted].[FTPSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Ftp Setup Port',
			ISNULL(CAST([deleted].[PORT] AS NVARCHAR(10)), '[none]'),
			ISNULL(CAST([inserted].[PORT] AS NVARCHAR(10)), '[none]'),
			'Ftp Setup (' + [inserted].[NAME] + ')',
			'0EE48696-E302-4061-8F42-93655DBF3230',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[FTPSETUPID] = [inserted].[FTPSETUPID]	
	WHERE	ISNULL([deleted].[PORT], 0) <> ISNULL([inserted].[PORT], 0)

	UNION ALL

	SELECT
			[inserted].[FTPSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Ftp Setup Ftp Type',
			[DELETED_TYPE].[NAME],
			[INSERTED_TYPE].[NAME],
			'Ftp Setup (' + [inserted].[NAME] + ')',
			'0EE48696-E302-4061-8F42-93655DBF3230',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[FTPSETUPID] = [inserted].[FTPSETUPID]	
			JOIN [FTPTYPE] AS DELETED_TYPE ON [deleted].[FTPTYPEID] = [DELETED_TYPE].[FTPTYPEID]
			JOIN [FTPTYPE] AS INSERTED_TYPE ON [inserted].[FTPTYPEID] = [INSERTED_TYPE].[FTPTYPEID]
	WHERE	[deleted].[FTPTYPEID] <> [inserted].[FTPTYPEID]
END
GO

CREATE TRIGGER [TG_FTPSETUP_INSERT]
    ON [dbo].[FTPSETUP]
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
			[inserted].[FTPSETUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Ftp Setup Added',
			'',
			'',
			'Ftp Setup (' + [inserted].[NAME] + ')',
			'0EE48696-E302-4061-8F42-93655DBF3230',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]
END
GO

CREATE TRIGGER [TG_FTPSETUP_DELETE] 
    ON [dbo].[FTPSETUP]
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
			[deleted].[FTPSETUPID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Ftp Setup Deleted',
			'',
			'',
			'Ftp Setup (' + [deleted].[NAME] + ')',
			'0EE48696-E302-4061-8F42-93655DBF3230',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END