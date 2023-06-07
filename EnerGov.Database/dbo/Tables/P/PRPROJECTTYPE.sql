CREATE TABLE [dbo].[PRPROJECTTYPE] (
    [PRPROJECTTYPEID]      CHAR (36)      NOT NULL,
    [NAME]                 NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]          NVARCHAR (MAX) NULL,
    [CUSTOMFIELDID]        CHAR (36)      NULL,
    [CAFEETEMPLATEID]      CHAR (36)      NULL,
    [ACTIVE]               BIT            CONSTRAINT [DF_PRProjectType_Active] DEFAULT ((1)) NOT NULL,
    [USECASETYPENUMBERING] BIT            DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]        CHAR (36)      NULL,
    [LASTCHANGEDON]        DATETIME       CONSTRAINT [DF_PRPROJECTTYPE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]           INT            CONSTRAINT [DF_PRPROJECTTYPE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PRProjectType] PRIMARY KEY CLUSTERED ([PRPROJECTTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PRProjectType_FeeTemplate] FOREIGN KEY ([CAFEETEMPLATEID]) REFERENCES [dbo].[CAFEETEMPLATE] ([CAFEETEMPLATEID]),
    CONSTRAINT [FK_PRPROJECTTYPE_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_PRType_CustomField] FOREIGN KEY ([CUSTOMFIELDID]) REFERENCES [dbo].[CUSTOMFIELDLAYOUT] ([GCUSTOMFIELDLAYOUTS])
);


GO

CREATE TRIGGER [dbo].[TG_PRPROJECTTYPE_DELETE]
   ON  [dbo].[PRPROJECTTYPE]
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
			[deleted].[PRPROJECTTYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Project Type Deleted',
			'',
			'',
			'Project Type (' + [deleted].[NAME] + ')',
			'3524A7D9-D7E6-44C1-A320-828311F3E4C6',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_PRPROJECTTYPE_INSERT]
   ON  [dbo].[PRPROJECTTYPE]
   AFTER INSERT
AS 
BEGIN	
	SET NOCOUNT ON;
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
        [inserted].[PRPROJECTTYPEID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Project Type Added',
        '',
        '',
        'Project Type (' + [inserted].[NAME] + ')',
		'3524A7D9-D7E6-44C1-A320-828311F3E4C6',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted]
END
GO

CREATE TRIGGER [dbo].[TG_PRPROJECTTYPE_UPDATE] on [dbo].[PRPROJECTTYPE]   
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
			[inserted].[PRPROJECTTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Project Type Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Project Type (' + [inserted].[NAME] + ')',
			'3524A7D9-D7E6-44C1-A320-828311F3E4C6',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PRPROJECTTYPEID] = [inserted].[PRPROJECTTYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL

	SELECT
			[inserted].[PRPROJECTTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Project Type (' + [inserted].[NAME] + ')',
			'3524A7D9-D7E6-44C1-A320-828311F3E4C6',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PRPROJECTTYPEID] = [inserted].[PRPROJECTTYPEID]	
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL

	SELECT
			[inserted].[PRPROJECTTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Custom Fields',
			ISNULL([CUSTOMFIELDLAYOUT_DELETED].[SNAME], '[none]'),
			ISNULL([CUSTOMFIELDLAYOUT_INSERTED].[SNAME], '[none]'),
			'Project Type (' + [inserted].[NAME] + ')',
			'3524A7D9-D7E6-44C1-A320-828311F3E4C6',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PRPROJECTTYPEID] = [inserted].[PRPROJECTTYPEID]
			LEFT JOIN CUSTOMFIELDLAYOUT CUSTOMFIELDLAYOUT_DELETED WITH (NOLOCK) ON [deleted].[CUSTOMFIELDID] = [CUSTOMFIELDLAYOUT_DELETED].[GCUSTOMFIELDLAYOUTS]
			LEFT JOIN CUSTOMFIELDLAYOUT CUSTOMFIELDLAYOUT_INSERTED WITH (NOLOCK) ON [inserted].[CUSTOMFIELDID] = [CUSTOMFIELDLAYOUT_INSERTED].[GCUSTOMFIELDLAYOUTS]
	WHERE	ISNULL([deleted].[CUSTOMFIELDID],'') <> ISNULL([inserted].[CUSTOMFIELDID],'')
	UNION ALL

	SELECT
			[inserted].[PRPROJECTTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Fee Template',
			ISNULL([CAFEETEMPLATE_DELETED].[CAFEETEMPLATENAME], '[none]'),
			ISNULL([CAFEETEMPLATE_INSERTED].[CAFEETEMPLATENAME], '[none]'),
			'Project Type (' + [inserted].[NAME] + ')',
			'3524A7D9-D7E6-44C1-A320-828311F3E4C6',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PRPROJECTTYPEID] = [inserted].[PRPROJECTTYPEID]
			LEFT JOIN CAFEETEMPLATE CAFEETEMPLATE_DELETED WITH (NOLOCK) ON [deleted].[CAFEETEMPLATEID] = [CAFEETEMPLATE_DELETED].[CAFEETEMPLATEID]
			LEFT JOIN CAFEETEMPLATE CAFEETEMPLATE_INSERTED WITH (NOLOCK) ON [inserted].[CAFEETEMPLATEID] = [CAFEETEMPLATE_INSERTED].[CAFEETEMPLATEID]
	WHERE	ISNULL([deleted].[CAFEETEMPLATEID],'') <> ISNULL([inserted].[CAFEETEMPLATEID],'')
	UNION ALL

	SELECT 
			[inserted].[PRPROJECTTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active Flag',
			CASE WHEN [deleted].[ACTIVE] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[ACTIVE] = 1 THEN 'Yes' ELSE 'No' END,
			'Project Type (' + [inserted].[NAME] + ')',
			'3524A7D9-D7E6-44C1-A320-828311F3E4C6',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PRPROJECTTYPEID] = [inserted].[PRPROJECTTYPEID]
	WHERE	[deleted].[ACTIVE] <> [inserted].[ACTIVE]
	UNION ALL

	SELECT 
			[inserted].[PRPROJECTTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Case Type Numbering Flag',
			CASE WHEN [deleted].[USECASETYPENUMBERING] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[USECASETYPENUMBERING] = 1 THEN 'Yes' ELSE 'No' END,
			'Project Type (' + [inserted].[NAME] + ')',
			'3524A7D9-D7E6-44C1-A320-828311F3E4C6',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[PRPROJECTTYPEID] = [inserted].[PRPROJECTTYPEID]
	WHERE	[deleted].[USECASETYPENUMBERING] <> [inserted].[USECASETYPENUMBERING]
END