CREATE TABLE [dbo].[WFSTEP] (
    [WFSTEPID]               CHAR (36)       NOT NULL,
    [NAME]                   NVARCHAR (100)  NOT NULL,
    [DESCRIPTION]            NVARCHAR (MAX)  NULL,
    [WFSTEPTYPEID]           INT             NOT NULL,
    [ICON]                   VARBINARY (MAX) NULL,
    [DAYSTOCOMPLETE]         INT             NULL,
    [WORKFLOWCOMPLETETYPEID] INT             NULL,
    [CMCODEID]               CHAR (36)       NULL,
    [LASTCHANGEDBY]          CHAR (36)       NULL,
    [LASTCHANGEDON]          DATETIME        CONSTRAINT [DF_WFSTEP_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]             INT             CONSTRAINT [DF_WFSTEP_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_WFStep] PRIMARY KEY CLUSTERED ([WFSTEPID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_WFStep_Code] FOREIGN KEY ([CMCODEID]) REFERENCES [dbo].[CMCODE] ([CMCODEID]),
    CONSTRAINT [FK_WFStep_WFCompleteType] FOREIGN KEY ([WORKFLOWCOMPLETETYPEID]) REFERENCES [dbo].[WORKFLOWCOMPLETETYPE] ([WORKFLOWCOMPLETETYPEID]),
    CONSTRAINT [FK_WFStep_WFStepType] FOREIGN KEY ([WFSTEPTYPEID]) REFERENCES [dbo].[WFSTEPTYPE] ([WFSTEPTYPEID])
);


GO
CREATE NONCLUSTERED INDEX [WFSTEP_IX_QUERY]
    ON [dbo].[WFSTEP]([WFSTEPID] ASC, [NAME] ASC);


GO
CREATE TRIGGER [dbo].[TG_WFSTEP_INSERT] ON [dbo].[WFSTEP]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of WFSTEP table with USERS table.
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
			[inserted].[WFSTEPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Workflow Step Added',
			'',
			'',
			'Workflow Step (' + [inserted].[NAME] + ')',
			'F5133F52-6687-440E-BDCE-5BF0F7DCCF57',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO
CREATE TRIGGER [dbo].[TG_WFSTEP_UPDATE] ON [dbo].[WFSTEP]
	AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of WFSTEP table with USERS table.
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
			[inserted].[WFSTEPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Workflow Step (' + [inserted].[NAME] + ')',
			'F5133F52-6687-440E-BDCE-5BF0F7DCCF57',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WFSTEPID] = [inserted].[WFSTEPID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL

	SELECT
			[inserted].[WFSTEPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Workflow Step (' + [inserted].[NAME] + ')',
			'F5133F52-6687-440E-BDCE-5BF0F7DCCF57',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WFSTEPID] = [inserted].[WFSTEPID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
	UNION ALL

	SELECT
			[inserted].[WFSTEPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Step Type',
			[WFSTEPTYPE_DELETED].[NAME],
			[WFSTEPTYPE_INSERTED].[NAME],
			'Workflow Step (' + [inserted].[NAME] + ')',
			'F5133F52-6687-440E-BDCE-5BF0F7DCCF57',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WFSTEPID] = [inserted].[WFSTEPID]			
			INNER JOIN [WFSTEPTYPE] [WFSTEPTYPE_INSERTED] WITH (NOLOCK) ON [WFSTEPTYPE_INSERTED].[WFSTEPTYPEID] = [inserted].[WFSTEPTYPEID]
			INNER JOIN [WFSTEPTYPE] [WFSTEPTYPE_DELETED] WITH (NOLOCK) ON [WFSTEPTYPE_DELETED].[WFSTEPTYPEID] = [deleted].[WFSTEPTYPEID]
	WHERE	[deleted].[WFSTEPTYPEID] <> [inserted].[WFSTEPTYPEID]
	UNION ALL

	SELECT
			[inserted].[WFSTEPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Set Icon',
			CASE WHEN [deleted].[ICON] IS NULL THEN '[none]' ELSE 'Icon' END,
			CASE WHEN [inserted].[ICON] IS NULL THEN '[none]' ELSE 'Icon' END,
			'Workflow Step (' + [inserted].[NAME] + ')',
			'F5133F52-6687-440E-BDCE-5BF0F7DCCF57',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WFSTEPID] = [inserted].[WFSTEPID]
	WHERE	[deleted].[ICON] <> [inserted].[ICON] OR 
			([deleted].[ICON] IS NULL AND [inserted].[ICON] IS NOT NULL) OR
			([deleted].[ICON] IS NOT NULL AND [inserted].[ICON] IS NULL)
	UNION ALL

	SELECT
			[inserted].[WFSTEPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Days To Complete',
			ISNULL(CONVERT(NVARCHAR(MAX),[deleted].[DAYSTOCOMPLETE]),'[none]'),
			ISNULL(CONVERT(NVARCHAR(MAX),[inserted].[DAYSTOCOMPLETE]),'[none]'),
			'Workflow Step (' + [inserted].[NAME] + ')',
			'F5133F52-6687-440E-BDCE-5BF0F7DCCF57',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WFSTEPID] = [inserted].[WFSTEPID]
	WHERE	ISNULL([deleted].[DAYSTOCOMPLETE], '') <> ISNULL([inserted].[DAYSTOCOMPLETE], '')
	UNION ALL

	SELECT
			[inserted].[WFSTEPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Complete Type',
			ISNULL([WORKFLOWCOMPLETETYPE_DELETED].[NAME],'[none]'),
			ISNULL([WORKFLOWCOMPLETETYPE_INSERTED].[NAME],'[none]'),
			'Workflow Step (' + [inserted].[NAME] + ')',
			'F5133F52-6687-440E-BDCE-5BF0F7DCCF57',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WFSTEPID] = [inserted].[WFSTEPID]
			LEFT JOIN [WORKFLOWCOMPLETETYPE] [WORKFLOWCOMPLETETYPE_INSERTED] WITH (NOLOCK) ON [WORKFLOWCOMPLETETYPE_INSERTED].[WORKFLOWCOMPLETETYPEID] = [inserted].[WORKFLOWCOMPLETETYPEID]
			LEFT JOIN [WORKFLOWCOMPLETETYPE] [WORKFLOWCOMPLETETYPE_DELETED] WITH (NOLOCK) ON [WORKFLOWCOMPLETETYPE_DELETED].[WORKFLOWCOMPLETETYPEID] = [deleted].[WORKFLOWCOMPLETETYPEID]
	WHERE	ISNULL([deleted].[WORKFLOWCOMPLETETYPEID], '') <> ISNULL([inserted].[WORKFLOWCOMPLETETYPEID], '')
	UNION ALL

	SELECT
			[inserted].[WFSTEPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Code',
			ISNULL([CMCODE_DELETED].[CODENUMBER],'[none]'),
			ISNULL([CMCODE_INSERTED].[CODENUMBER],'[none]'),
			'Workflow Step (' + [inserted].[NAME] + ')',
			'F5133F52-6687-440E-BDCE-5BF0F7DCCF57',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[WFSTEPID] = [inserted].[WFSTEPID]
			LEFT JOIN [CMCODE] [CMCODE_INSERTED] WITH (NOLOCK) ON [CMCODE_INSERTED].[CMCODEID] = [inserted].[CMCODEID]
			LEFT JOIN [CMCODE] [CMCODE_DELETED] WITH (NOLOCK) ON [CMCODE_DELETED].[CMCODEID] = [deleted].[CMCODEID]
	WHERE	ISNULL([deleted].[CMCODEID], '') <> ISNULL([inserted].[CMCODEID], '')
END
GO
CREATE TRIGGER [dbo].[TG_WFSTEP_DELETE] ON [dbo].[WFSTEP]
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
			[deleted].[WFSTEPID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Workflow Step Deleted',
			'',
			'',
			'Workflow Step (' + [deleted].[NAME] + ')',
			'F5133F52-6687-440E-BDCE-5BF0F7DCCF57',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END