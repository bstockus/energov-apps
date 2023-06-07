CREATE TABLE [dbo].[IPCASETYPE] (
    [IPCASETYPEID]             CHAR (36)      NOT NULL,
    [NAME]                     NVARCHAR (100) NOT NULL,
    [DESCRIPTION]              NVARCHAR (MAX) NULL,
    [PREFIX]                   NVARCHAR (10)  NULL,
    [CUSTOMFIELDLAYOUTID]      CHAR (36)      NULL,
    [DEFAULTSTATUSID]          CHAR (36)      NULL,
    [DAYSTOCASEAPPROVALEXPIRE] INT            NOT NULL,
    [ACTIVE]                   BIT            NOT NULL,
    [LASTCHANGEDBY]            CHAR (36)      NULL,
    [LASTCHANGEDON]            DATETIME       CONSTRAINT [DF_IPCASETYPE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]               INT            CONSTRAINT [DF_IPCASETYPE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_IPCASETYPE] PRIMARY KEY CLUSTERED ([IPCASETYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_IPCASETYPE_CFLAYOUT] FOREIGN KEY ([CUSTOMFIELDLAYOUTID]) REFERENCES [dbo].[CUSTOMFIELDLAYOUT] ([GCUSTOMFIELDLAYOUTS]),
    CONSTRAINT [FK_IPCASETYPE_IPCASESTATUS] FOREIGN KEY ([DEFAULTSTATUSID]) REFERENCES [dbo].[IPCASESTATUS] ([IPCASESTATUSID])
);


GO
CREATE NONCLUSTERED INDEX [IPCASETYPE_IX_QUERY]
    ON [dbo].[IPCASETYPE]([IPCASETYPEID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_IPCASETYPE_INSERT] ON [dbo].[IPCASETYPE]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IPCASETYPE table with USERS table.
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
        [inserted].[IPCASETYPEID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Impact Case Type Added',
        '',
        '',
        'Impact Case Type (' + [inserted].[NAME] + ')',
		'1D95EA95-4C0E-48A2-B8CF-B057044CC0E4',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_IPCASETYPE_UPDATE] 
   ON  [dbo].[IPCASETYPE]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of IPCASETYPE table with USERS table.
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
			[inserted].[IPCASETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Impact Case Type (' + [inserted].[NAME] + ')',
			'1D95EA95-4C0E-48A2-B8CF-B057044CC0E4',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPCASETYPEID] = [inserted].[IPCASETYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[IPCASETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Impact Case Type (' + [inserted].[NAME] + ')',
			'1D95EA95-4C0E-48A2-B8CF-B057044CC0E4',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPCASETYPEID] = [inserted].[IPCASETYPEID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL
	SELECT
			[inserted].[IPCASETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Prefix',
			ISNULL([deleted].[PREFIX],'[none]'),
			ISNULL([inserted].[PREFIX],'[none]'),			
			'Impact Case Type (' + [inserted].[NAME] + ')',
			'1D95EA95-4C0E-48A2-B8CF-B057044CC0E4',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPCASETYPEID] = [inserted].[IPCASETYPEID]
	WHERE	ISNULL([deleted].[PREFIX], '') <> ISNULL([inserted].[PREFIX], '')	
	UNION ALL
	SELECT
			[inserted].[IPCASETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Custom Field',
			ISNULL([CUSTOMFIELDLAYOUT_DELETED].[SNAME], '[none]'),
			ISNULL([CUSTOMFIELDLAYOUT_INSERTED].[SNAME], '[none]'),
			'Impact Case Type (' + [inserted].[NAME] + ')',
			'1D95EA95-4C0E-48A2-B8CF-B057044CC0E4',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPCASETYPEID] = [inserted].[IPCASETYPEID]
			LEFT JOIN CUSTOMFIELDLAYOUT CUSTOMFIELDLAYOUT_DELETED WITH (NOLOCK) ON [deleted].[CUSTOMFIELDLAYOUTID] = [CUSTOMFIELDLAYOUT_DELETED].[GCUSTOMFIELDLAYOUTS]
			LEFT JOIN CUSTOMFIELDLAYOUT CUSTOMFIELDLAYOUT_INSERTED WITH (NOLOCK) ON [inserted].[CUSTOMFIELDLAYOUTID] = [CUSTOMFIELDLAYOUT_INSERTED].[GCUSTOMFIELDLAYOUTS]
	WHERE	ISNULL([deleted].[CUSTOMFIELDLAYOUTID], '') <> ISNULL([inserted].[CUSTOMFIELDLAYOUTID], '')
	UNION ALL
	SELECT
			[inserted].[IPCASETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Status',
			ISNULL([DEFAULTSTATUS_DELETED].[NAME], '[none]'),
			ISNULL([DEFAULTSTATUS_INSERTED].[NAME], '[none]'),
			'Impact Case Type (' + [inserted].[NAME] + ')',
			'1D95EA95-4C0E-48A2-B8CF-B057044CC0E4',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPCASETYPEID] = [inserted].[IPCASETYPEID]
			LEFT JOIN IPCASESTATUS DEFAULTSTATUS_DELETED WITH (NOLOCK) ON [deleted].[DEFAULTSTATUSID] = [DEFAULTSTATUS_DELETED].[IPCASESTATUSID]
			LEFT JOIN IPCASESTATUS DEFAULTSTATUS_INSERTED WITH (NOLOCK) ON [inserted].[DEFAULTSTATUSID] = [DEFAULTSTATUS_INSERTED].[IPCASESTATUSID]
	WHERE	ISNULL([deleted].[DEFAULTSTATUSID], '') <> ISNULL([inserted].[DEFAULTSTATUSID], '')
	UNION ALL
	SELECT 
			[inserted].[IPCASETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Days To Case Approval Expire',
			CONVERT(NVARCHAR(MAX),[deleted].[DAYSTOCASEAPPROVALEXPIRE]),
			CONVERT(NVARCHAR(MAX),[inserted].[DAYSTOCASEAPPROVALEXPIRE]),
			'Impact Case Type (' + [inserted].[NAME] + ')',
			'1D95EA95-4C0E-48A2-B8CF-B057044CC0E4',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[IPCASETYPEID] = [inserted].[IPCASETYPEID]
	WHERE	[deleted].[DAYSTOCASEAPPROVALEXPIRE] <> [inserted].[DAYSTOCASEAPPROVALEXPIRE]
	UNION ALL
	SELECT
			[inserted].[IPCASETYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active Flag',
			CASE [deleted].[ACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ACTIVE] WHEN 1 THEN 'Yes'ELSE 'No' END,
			'Impact Case Type (' + [inserted].[NAME] + ')',
			'1D95EA95-4C0E-48A2-B8CF-B057044CC0E4',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
	JOIN	[inserted] ON [deleted].[IPCASETYPEID] = [inserted].[IPCASETYPEID]
	WHERE	([deleted].[ACTIVE] <> [inserted].[ACTIVE])
END
GO

CREATE TRIGGER [dbo].[TG_IPCASETYPE_DELETE]
   ON  [dbo].[IPCASETYPE]
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
			[deleted].[IPCASETYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Impact Case Type Deleted',
			'',
			'',
			'Impact Case Type (' + [deleted].[NAME] + ')',
			'1D95EA95-4C0E-48A2-B8CF-B057044CC0E4',
			3,
			1,
			[deleted].[NAME]
	FROM [deleted]
END