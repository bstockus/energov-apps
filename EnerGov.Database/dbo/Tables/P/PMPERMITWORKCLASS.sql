CREATE TABLE [dbo].[PMPERMITWORKCLASS] (
    [PMPERMITWORKCLASSID] CHAR (36)      NOT NULL,
    [NAME]                NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]         NVARCHAR (MAX) NULL,
    [LASTCHANGEDBY]       CHAR (36)      NULL,
    [LASTCHANGEDON]       DATETIME       CONSTRAINT [DF_PMPermitWorkClass_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]          INT            CONSTRAINT [DF_PMPermitWorkClass_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PMPermitWorkClass] PRIMARY KEY CLUSTERED ([PMPERMITWORKCLASSID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_PMPERMITWORKCLASS_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [PMPERMITWORKCLASS_IX_QUERY]
    ON [dbo].[PMPERMITWORKCLASS]([PMPERMITWORKCLASSID] ASC, [NAME] ASC) WITH (FILLFACTOR = 80);


GO

CREATE TRIGGER [dbo].[TG_PMPERMITWORKCLASS_DELETE]
   ON  [dbo].[PMPERMITWORKCLASS]
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
			[deleted].[PMPERMITWORKCLASSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Permit Work Class Deleted',
			'',
			'',
			'Permit Work Class (' + [deleted].[NAME] + ')',
			'86316A61-0EF6-4705-9A06-71F666BBBF2F',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_PMPERMITWORKCLASS_INSERT] ON [dbo].[PMPERMITWORKCLASS]
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
        [inserted].[PMPERMITWORKCLASSID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Permit Work Class Added',
        '',
        '',
        'Permit Work Class (' + [inserted].[NAME] + ')',
		'86316A61-0EF6-4705-9A06-71F666BBBF2F',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_PMPERMITWORKCLASS_UPDATE] 
   ON  [dbo].[PMPERMITWORKCLASS]
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
			[inserted].[PMPERMITWORKCLASSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Permit Work Class (' + [inserted].[NAME] + ')',
			'86316A61-0EF6-4705-9A06-71F666BBBF2F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PMPERMITWORKCLASSID = [inserted].PMPERMITWORKCLASSID
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[PMPERMITWORKCLASSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Permit Work Class (' + [inserted].[NAME] + ')',
			'86316A61-0EF6-4705-9A06-71F666BBBF2F',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PMPERMITWORKCLASSID = [inserted].PMPERMITWORKCLASSID
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
END