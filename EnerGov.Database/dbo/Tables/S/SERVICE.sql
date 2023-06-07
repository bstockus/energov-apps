CREATE TABLE [dbo].[SERVICE] (
    [SERVICEID]      CHAR (36)       NOT NULL,
    [MACHINENAME]    NVARCHAR (128)  NOT NULL,
    [BASEDIRECTORY]  NVARCHAR (1000) NOT NULL,
    [ISACTIVE]       BIT             NOT NULL,
    [ISV2]           BIT             DEFAULT ((0)) NOT NULL,
    [ISCOORDINATOR]  BIT             DEFAULT ((0)) NOT NULL,
    [SERVICEBASEURL] NVARCHAR (100)  NULL,
    [LASTCHANGEDBY]  CHAR (36)       NULL,
    [LASTCHANGEDON]  DATETIME        CONSTRAINT [DF_SERVICE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]     INT             CONSTRAINT [DF_SERVICE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_SERVICE] PRIMARY KEY CLUSTERED ([SERVICEID] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_SESERVICE_ALL]
    ON [dbo].[SERVICE]([MACHINENAME] ASC, [BASEDIRECTORY] ASC) WITH (FILLFACTOR = 80);


GO

CREATE TRIGGER [dbo].[TG_SERVICE_UPDATE] ON  [dbo].[SERVICE]
	AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of SERVICE table with USERS table.
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
			[inserted].[SERVICEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Machine Name',
			[deleted].[MACHINENAME],
			[inserted].[MACHINENAME],
			'Windows Service Configuration (' + [inserted].[MACHINENAME] + ', ' + [inserted].[BASEDIRECTORY] + ')',
			'0235B443-1680-47B9-B273-484A05D57986',
			2,
			1,
			[inserted].[MACHINENAME] + ', ' + [inserted].[BASEDIRECTORY]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SERVICEID] = [inserted].[SERVICEID]
	WHERE	[deleted].[MACHINENAME] <> [inserted].[MACHINENAME]
	UNION ALL
	SELECT 
			[inserted].[SERVICEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Base Directory',			
			[deleted].[BASEDIRECTORY],
			[inserted].[BASEDIRECTORY],
			'Windows Service Configuration (' + [inserted].[MACHINENAME] + ', ' + [inserted].[BASEDIRECTORY] + ')',
			'0235B443-1680-47B9-B273-484A05D57986',
			2,
			1,
			[inserted].[MACHINENAME] + ', ' + [inserted].[BASEDIRECTORY]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SERVICEID] = [inserted].[SERVICEID]	
	WHERE	[deleted].[BASEDIRECTORY] <> [inserted].[BASEDIRECTORY]
	UNION ALL
	SELECT 
			[inserted].[SERVICEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Enable Service Flag',			
			CASE [deleted].[ISACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Windows Service Configuration (' + [inserted].[MACHINENAME] + ', ' + [inserted].[BASEDIRECTORY] + ')',
			'0235B443-1680-47B9-B273-484A05D57986',
			2,
			1,
			[inserted].[MACHINENAME] + ', ' + [inserted].[BASEDIRECTORY]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SERVICEID] = [inserted].[SERVICEID]	
	WHERE	[deleted].[ISACTIVE] <> [inserted].[ISACTIVE]
	UNION ALL
	SELECT 
			[inserted].[SERVICEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Is Running Flag',			
			CASE [deleted].[ISV2] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISV2] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Windows Service Configuration (' + [inserted].[MACHINENAME] + ', ' + [inserted].[BASEDIRECTORY] + ')',
			'0235B443-1680-47B9-B273-484A05D57986',
			2,
			1,
			[inserted].[MACHINENAME] + ', ' + [inserted].[BASEDIRECTORY]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SERVICEID] = [inserted].[SERVICEID]	
	WHERE	[deleted].[ISV2] <> [inserted].[ISV2]
	UNION ALL
	SELECT 
			[inserted].[SERVICEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Coordinator Flag',			
			CASE [deleted].[ISCOORDINATOR] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISCOORDINATOR] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Windows Service Configuration (' + [inserted].[MACHINENAME] + ', ' + [inserted].[BASEDIRECTORY] + ')',
			'0235B443-1680-47B9-B273-484A05D57986',
			2,
			1,
			[inserted].[MACHINENAME] + ', ' + [inserted].[BASEDIRECTORY]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SERVICEID] = [inserted].[SERVICEID]	
	WHERE	[deleted].[ISCOORDINATOR] <> [inserted].[ISCOORDINATOR]
	UNION ALL
	SELECT 
			[inserted].[SERVICEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Base Url',			
			ISNULL([deleted].[SERVICEBASEURL],'[none]'),
			ISNULL([inserted].[SERVICEBASEURL],'[none]'),
			'Windows Service Configuration (' + [inserted].[MACHINENAME] + ', ' + [inserted].[BASEDIRECTORY] + ')',
			'0235B443-1680-47B9-B273-484A05D57986',
			2,
			1,
			[inserted].[MACHINENAME] + ', ' + [inserted].[BASEDIRECTORY]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[SERVICEID] = [inserted].[SERVICEID]	
	WHERE	ISNULL([deleted].[SERVICEBASEURL],'') <> ISNULL([inserted].[SERVICEBASEURL], '')	
END
GO

CREATE TRIGGER [dbo].[TG_SERVICE_DELETE]
   ON  [dbo].[SERVICE] 
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
    )SELECT
			[deleted].[SERVICEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Service Deleted',
			'',
			'',
			'Service (' + [deleted].[MACHINENAME] + ')',
			'0235B443-1680-47B9-B273-484A05D57986',
			3,
			1,
			[deleted].[MACHINENAME]
	FROM	[deleted]
END