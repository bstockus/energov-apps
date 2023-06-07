CREATE TABLE [dbo].[IPCASESTATUS] (
    [IPCASESTATUSID] CHAR (36)      NOT NULL,
    [NAME]           NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]    NVARCHAR (MAX) NULL,
    [APPROVAL]       BIT            NOT NULL,
    [ACTIVE]         BIT            NOT NULL,
    [CANCELLED]      BIT            DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]  CHAR (36)      NULL,
    [LASTCHANGEDON]  DATETIME       CONSTRAINT [DF_IPCASESTATUS_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]     INT            CONSTRAINT [DF_IPCASESTATUS_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_IPCASESTATUS] PRIMARY KEY CLUSTERED ([IPCASESTATUSID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IPCASESTATUS_IX_QUERY]
    ON [dbo].[IPCASESTATUS]([IPCASESTATUSID] ASC, [NAME] ASC);


GO


CREATE TRIGGER [dbo].[TG_IPCASESTATUS_DELETE] ON  [dbo].[IPCASESTATUS]
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
			[deleted].[IPCASESTATUSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Impact Case Status Deleted',
			'',
			'',
			'Impact Case Status (' + [deleted].[NAME] + ')',
			'45635516-6BC3-4BFD-B0D2-30986AD93785',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO


CREATE TRIGGER [dbo].[TG_IPCASESTATUS_INSERT] ON [dbo].[IPCASESTATUS]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IPCASESTATUS table with USERS table.
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
			[inserted].[IPCASESTATUSID], 
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Impact Case Status Added',
			'',
			'',
			'Impact Case Status (' + [inserted].[NAME] + ')',
			'45635516-6BC3-4BFD-B0D2-30986AD93785',
			1,
			1,
			[inserted].[NAME]
    FROM	[inserted] 
END
GO


CREATE TRIGGER [dbo].[TG_IPCASESTATUS_UPDATE] ON  [dbo].[IPCASESTATUS]
	AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IPCASESTATUS table with USERS table.
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
			[inserted].[IPCASESTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Impact Case Status (' + [inserted].[NAME] + ')',
			'45635516-6BC3-4BFD-B0D2-30986AD93785',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPCASESTATUSID] = [inserted].[IPCASESTATUSID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT 
			[inserted].[IPCASESTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',			
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Impact Case Status (' + [inserted].[NAME] + ')',
			'45635516-6BC3-4BFD-B0D2-30986AD93785',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPCASESTATUSID] = [inserted].[IPCASESTATUSID]	
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL
	SELECT 
			[inserted].[IPCASESTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Approval Flag',
			CASE WHEN [deleted].[APPROVAL] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[APPROVAL] = 1 THEN 'Yes' ELSE 'No' END,
			'Impact Case Status (' + [inserted].[NAME] + ')',
			'45635516-6BC3-4BFD-B0D2-30986AD93785',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPCASESTATUSID] = [inserted].[IPCASESTATUSID]
	WHERE	[deleted].[APPROVAL] <> [inserted].[APPROVAL]
	UNION ALL
	SELECT 
			[inserted].[IPCASESTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active Flag',
			CASE WHEN [deleted].[ACTIVE] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[ACTIVE] = 1 THEN 'Yes' ELSE 'No' END,
			'Impact Case Status (' + [inserted].[NAME] + ')',
			'45635516-6BC3-4BFD-B0D2-30986AD93785',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPCASESTATUSID] = [inserted].[IPCASESTATUSID]
	WHERE	[deleted].[ACTIVE] <> [inserted].[ACTIVE]
	UNION ALL
	SELECT 
			[inserted].[IPCASESTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Cancelled Flag',
			CASE WHEN [deleted].[CANCELLED] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[CANCELLED] = 1 THEN 'Yes' ELSE 'No' END,
			'Impact Case Status (' + [inserted].[NAME] + ')',
			'45635516-6BC3-4BFD-B0D2-30986AD93785',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPCASESTATUSID] = [inserted].[IPCASESTATUSID]
	WHERE	[deleted].[CANCELLED] <> [inserted].[CANCELLED]
END