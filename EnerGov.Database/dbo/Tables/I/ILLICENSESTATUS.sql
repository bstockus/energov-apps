﻿CREATE TABLE [dbo].[ILLICENSESTATUS] (
    [ILLICENSESTATUSID]       CHAR (36)      NOT NULL,
    [NAME]                    NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]             NVARCHAR (MAX) NULL,
    [ILLICENSESTATUSSYSTEMID] INT            NULL,
    [LASTCHANGEDBY]           CHAR (36)      NULL,
    [LASTCHANGEDON]           DATETIME       CONSTRAINT [DF_ILLICENSESTATUS_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]              INT            CONSTRAINT [DF_ILLICENSESTATUS_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_ILLicenseStatus] PRIMARY KEY CLUSTERED ([ILLICENSESTATUSID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_ILLICSTAT_ILLICSTATSYS] FOREIGN KEY ([ILLICENSESTATUSSYSTEMID]) REFERENCES [dbo].[ILLICENSESTATUSSYSTEM] ([ILLICENSESTATUSSYSTEMID])
);


GO
CREATE NONCLUSTERED INDEX [ILLICENSESTATUS_IX_QUERY]
    ON [dbo].[ILLICENSESTATUS]([ILLICENSESTATUSID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [TG_ILLICENSESTATUS_DELETE] ON ILLICENSESTATUS
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
			[deleted].[ILLICENSESTATUSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Professional License Status Deleted',
			'',
			'',
			'Professional License Status (' + [deleted].[NAME] + ')',
			'5229DDD7-6950-46E8-859C-509F61DA345E',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [TG_ILLICENSESTATUS_UPDATE] ON ILLICENSESTATUS
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of ILLICENSESTATUS table with USERS table.
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
			[inserted].[ILLICENSESTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Professional License Status (' + [inserted].[NAME] + ')',
			'5229DDD7-6950-46E8-859C-509F61DA345E',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSESTATUSID] = [inserted].[ILLICENSESTATUSID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	
	UNION ALL
	SELECT
			[inserted].[ILLICENSESTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION], '[none]'),
			ISNULL([inserted].[DESCRIPTION], '[none]'),
			'Professional License Status (' + [inserted].[NAME] + ')',
			'5229DDD7-6950-46E8-859C-509F61DA345E',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSESTATUSID] = [inserted].[ILLICENSESTATUSID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')

	UNION ALL
	SELECT
			[inserted].[ILLICENSESTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'System Status',
			ISNULL([ILLICENSESTATUSSYSTEM_DELETED].[NAME], '[none]'),
			ISNULL([ILLICENSESTATUSSYSTEM_INSERTED].[NAME], '[none]'),
			'Professional License Status (' + [inserted].[NAME] + ')',
			'5229DDD7-6950-46E8-859C-509F61DA345E',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSESTATUSID] = [inserted].[ILLICENSESTATUSID]
			LEFT JOIN ILLICENSESTATUSSYSTEM ILLICENSESTATUSSYSTEM_DELETED WITH (NOLOCK) ON [deleted].[ILLICENSESTATUSSYSTEMID] = ILLICENSESTATUSSYSTEM_DELETED.[ILLICENSESTATUSSYSTEMID]
			LEFT JOIN ILLICENSESTATUSSYSTEM ILLICENSESTATUSSYSTEM_INSERTED WITH (NOLOCK) ON [inserted].[ILLICENSESTATUSSYSTEMID] = ILLICENSESTATUSSYSTEM_INSERTED.[ILLICENSESTATUSSYSTEMID]
	WHERE	ISNULL([deleted].[ILLICENSESTATUSSYSTEMID], '') <> ISNULL([inserted].[ILLICENSESTATUSSYSTEMID], '')	
END
GO

CREATE TRIGGER [TG_ILLICENSESTATUS_INSERT] ON ILLICENSESTATUS
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of ILLICENSESTATUS table with USERS table.
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
			[inserted].[ILLICENSESTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Professional License Status Added',
			'',
			'',
			'Professional License Status (' + [inserted].[NAME] + ')',
			'5229DDD7-6950-46E8-859C-509F61DA345E',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END