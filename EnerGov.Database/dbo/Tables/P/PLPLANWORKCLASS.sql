CREATE TABLE [dbo].[PLPLANWORKCLASS] (
    [PLPLANWORKCLASSID] CHAR (36)      NOT NULL,
    [NAME]              NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]       NVARCHAR (MAX) NULL,
    [LASTCHANGEDBY]     CHAR (36)      NULL,
    [LASTCHANGEDON]     DATETIME       CONSTRAINT [DF_PLPlanWorkClass_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]        INT            CONSTRAINT [DF_PLPlanWorkClass_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PLPlanWorkClass] PRIMARY KEY CLUSTERED ([PLPLANWORKCLASSID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PLPlanWorkClass_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [PLPLANWORKCLASS_IX_QUERY]
    ON [dbo].[PLPLANWORKCLASS]([PLPLANWORKCLASSID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_PLPLANWORKCLASS_DELETE]
   ON  [dbo].[PLPLANWORKCLASS]
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
			[deleted].[PLPLANWORKCLASSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Plan Work Class Deleted',
			'',
			'',
			'Plan Work Class (' + [deleted].[NAME] + ')',
			'926E6876-5E3E-49BF-9A2E-AD3D1CBF3677',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_PLPLANWORKCLASS_INSERT] ON [dbo].[PLPLANWORKCLASS]
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
        [inserted].[PLPLANWORKCLASSID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Plan Work Class Added',
        '',
        '',
        'Plan Work Class (' + [inserted].[NAME] + ')',
		'926E6876-5E3E-49BF-9A2E-AD3D1CBF3677',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_PLPLANWORKCLASS_UPDATE] 
   ON  [dbo].[PLPLANWORKCLASS]
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
			[inserted].[PLPLANWORKCLASSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Plan Work Class (' + [inserted].[NAME] + ')',
			'926E6876-5E3E-49BF-9A2E-AD3D1CBF3677',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PLPLANWORKCLASSID = [inserted].PLPLANWORKCLASSID
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[PLPLANWORKCLASSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Plan Work Class (' + [inserted].[NAME] + ')',
			'926E6876-5E3E-49BF-9A2E-AD3D1CBF3677',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PLPLANWORKCLASSID = [inserted].PLPLANWORKCLASSID
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
END