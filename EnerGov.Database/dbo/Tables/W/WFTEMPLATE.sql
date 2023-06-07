CREATE TABLE [dbo].[WFTEMPLATE] (
    [WFTEMPLATEID]  CHAR (36)      NOT NULL,
    [NAME]          NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]   NVARCHAR (MAX) NULL,
    [WFENTITYID]    INT            NOT NULL,
    [LASTCHANGEDBY] CHAR (36)      NULL,
    [LASTCHANGEDON] DATETIME       CONSTRAINT [DF_WFTEMPLATE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]    INT            CONSTRAINT [DF_WFTEMPLATE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_WFTemplate] PRIMARY KEY CLUSTERED ([WFTEMPLATEID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_WFTemplate_WFEntity] FOREIGN KEY ([WFENTITYID]) REFERENCES [dbo].[WFENTITY] ([WFENTITYID])
);


GO
CREATE NONCLUSTERED INDEX [WFTEMPLATE_IX_QUERY]
    ON [dbo].[WFTEMPLATE]([WFTEMPLATEID] ASC, [NAME] ASC);


GO
CREATE TRIGGER [dbo].[TG_WFTEMPLATE_DELETE] ON [dbo].[WFTEMPLATE]
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
			[deleted].[WFTEMPLATEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Workflow Template Deleted',
			'',
			'',
			'Workflow Template (' + [deleted].[NAME] + ')',
			'4828BC29-4760-4E15-8B16-E6AFCD835AB8',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO
CREATE TRIGGER [dbo].[TG_WFTEMPLATE_UPDATE] ON [dbo].[WFTEMPLATE] 
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
			[inserted].[WFTEMPLATEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Workflow Template (' + [inserted].[NAME] + ')',
			'4828BC29-4760-4E15-8B16-E6AFCD835AB8',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WFTEMPLATEID] = [inserted].[WFTEMPLATEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL

	SELECT
			[inserted].[WFTEMPLATEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Workflow Template (' + [inserted].[NAME] + ')',
			'4828BC29-4760-4E15-8B16-E6AFCD835AB8',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WFTEMPLATEID] = [inserted].[WFTEMPLATEID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
	UNION ALL

	SELECT
			[inserted].[WFTEMPLATEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Entity',
			[WFENTITY_DELETED].[NAME],
			[WFENTITY_INSERTED].[NAME],
			'Workflow Template (' + [inserted].[NAME] + ')',
			'4828BC29-4760-4E15-8B16-E6AFCD835AB8',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WFTEMPLATEID] = [inserted].[WFTEMPLATEID]			
			INNER JOIN [WFENTITY] [WFENTITY_INSERTED] WITH (NOLOCK) ON [WFENTITY_INSERTED].[WFENTITYID] = [inserted].[WFENTITYID]
			INNER JOIN [WFENTITY] [WFENTITY_DELETED] WITH (NOLOCK) ON [WFENTITY_DELETED].[WFENTITYID] = [deleted].[WFENTITYID]
	WHERE	[deleted].[WFENTITYID] <> [inserted].[WFENTITYID]

END
GO
CREATE TRIGGER [dbo].[TG_WFTEMPLATE_INSERT] ON [dbo].[WFTEMPLATE]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of WFTEMPLATE table with USERS table.
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
			[inserted].[WFTEMPLATEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Workflow Template Added',
			'',
			'',
			'Workflow Template (' + [inserted].[NAME] + ')',
			'4828BC29-4760-4E15-8B16-E6AFCD835AB8',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END