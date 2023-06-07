CREATE TABLE [dbo].[IMINSPECTIONCASESTATUS] (
    [IMINSPECTIONCASESTATUSID] CHAR (36)      NOT NULL,
    [NAME]                     NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]              NVARCHAR (MAX) NULL,
    [ACTIVE]                   BIT            CONSTRAINT [DF_IMINSPECTIONCASESTATUS_ACTIVE] DEFAULT ((0)) NOT NULL,
    [PAUSE]                    BIT            CONSTRAINT [DF_IMINSPECTIONCASESTATUS_PAUSE] DEFAULT ((0)) NOT NULL,
    [COMPLETE]                 BIT            CONSTRAINT [DF_IMINSPECTIONCASESTATUS_COMPLETE] DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]            CHAR (36)      NULL,
    [LASTCHANGEDON]            DATETIME       CONSTRAINT [DF_IMINSPECTIONCASESTATUS_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]               INT            CONSTRAINT [DF_IMINSPECTIONCASESTATUS_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_IMINSPECTIONCASESTATUS] PRIMARY KEY CLUSTERED ([IMINSPECTIONCASESTATUSID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IMINSPECTIONCASESTATUS_IX_QUERY]
    ON [dbo].[IMINSPECTIONCASESTATUS]([IMINSPECTIONCASESTATUSID] ASC, [NAME] ASC);


GO
CREATE TRIGGER [TG_IMINSPECTIONCASESTATUS_UPDATE]
	ON IMINSPECTIONCASESTATUS
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IMINSPECTIONCASESTATUS table with USERS table.
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
			[inserted].[IMINSPECTIONCASESTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Inspection Case Status (' + [inserted].[NAME] + ')',
			'BDC69B0E-9FA5-4FA9-8D94-969E31886BC0',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTIONCASESTATUSID] = [inserted].[IMINSPECTIONCASESTATUSID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[IMINSPECTIONCASESTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Inspection Case Status (' + [inserted].[NAME] + ')',
			'BDC69B0E-9FA5-4FA9-8D94-969E31886BC0',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTIONCASESTATUSID] = [inserted].[IMINSPECTIONCASESTATUSID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')	
	UNION ALL
	SELECT
			[inserted].[IMINSPECTIONCASESTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active Flag',
			CASE WHEN [deleted].[ACTIVE] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[ACTIVE] = 1 THEN 'Yes' ELSE 'No' END,
			'Inspection Case Status (' + [inserted].[NAME] + ')',
			'BDC69B0E-9FA5-4FA9-8D94-969E31886BC0',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTIONCASESTATUSID] = [inserted].[IMINSPECTIONCASESTATUSID]
	WHERE	[deleted].[ACTIVE] <> [inserted].[ACTIVE]
	UNION ALL
	SELECT
			[inserted].[IMINSPECTIONCASESTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Pause Flag',
			CASE WHEN [deleted].[PAUSE] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[PAUSE] = 1 THEN 'Yes' ELSE 'No' END,
			'Inspection Case Status (' + [inserted].[NAME] + ')',
			'BDC69B0E-9FA5-4FA9-8D94-969E31886BC0',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTIONCASESTATUSID] = [inserted].[IMINSPECTIONCASESTATUSID]
	WHERE	[deleted].[PAUSE] <> [inserted].[PAUSE]
	UNION ALL
	SELECT
			[inserted].[IMINSPECTIONCASESTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Complete Flag',
			CASE WHEN [deleted].[COMPLETE] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[COMPLETE] = 1 THEN 'Yes' ELSE 'No' END,
			'Inspection Case Status (' + [inserted].[NAME] + ')',
			'BDC69B0E-9FA5-4FA9-8D94-969E31886BC0',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IMINSPECTIONCASESTATUSID] = [inserted].[IMINSPECTIONCASESTATUSID]
	WHERE	[deleted].[COMPLETE] <> [inserted].[COMPLETE]
END
GO
CREATE TRIGGER [dbo].[TG_IMINSPECTIONCASESTATUS_INSERT] 
	ON [dbo].[IMINSPECTIONCASESTATUS]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
		-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IMINSPECTIONCASESTATUS table with USERS table.
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
        [inserted].[IMINSPECTIONCASESTATUSID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Inspection Case Status Added',
        '',
        '',
        'Inspection Case Status (' + [inserted].[NAME] + ')',
		'BDC69B0E-9FA5-4FA9-8D94-969E31886BC0',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_IMINSPECTIONCASESTATUS_DELETE]
   ON  [dbo].[IMINSPECTIONCASESTATUS]
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
			[deleted].[IMINSPECTIONCASESTATUSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Inspection Case Status Deleted',
			'',
			'',
			'Inspection Case Status (' + [deleted].[NAME] + ')',
			'BDC69B0E-9FA5-4FA9-8D94-969E31886BC0',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END