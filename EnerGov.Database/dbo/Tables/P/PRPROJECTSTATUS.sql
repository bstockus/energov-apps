CREATE TABLE [dbo].[PRPROJECTSTATUS] (
    [PRPROJECTSTATUSID] CHAR (36)      NOT NULL,
    [NAME]              NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]       NVARCHAR (MAX) NULL,
    [HOLDFLAG]          BIT            CONSTRAINT [DF_PRProjectStatus_HoldFlag] DEFAULT ((0)) NULL,
    [COMPLETEDFLAG]     BIT            CONSTRAINT [DF_PRProjectStatus_CompletedFlag] DEFAULT ((0)) NOT NULL,
    [CANCELLEDFLAG]     BIT            CONSTRAINT [DF_PRProjectStatus_CancelledFlag] DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]     CHAR (36)      NULL,
    [LASTCHANGEDON]     DATETIME       CONSTRAINT [DF_PRProjectStatus_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]        INT            CONSTRAINT [DF_PRProjectStatus_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_PRProjectStatus] PRIMARY KEY CLUSTERED ([PRPROJECTSTATUSID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_PRProjectStatus_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [PRPROJECTSTATUS_IX_QUERY]
    ON [dbo].[PRPROJECTSTATUS]([PRPROJECTSTATUSID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_PRPROJECTSTATUS_UPDATE] 
   ON  [dbo].[PRPROJECTSTATUS]
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
			[inserted].[PRPROJECTSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Project Status (' + [inserted].[NAME] + ')',
			'6F30AF6D-97EE-4B9B-A1E7-6BDD1358F3A1',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PRPROJECTSTATUSID = [inserted].PRPROJECTSTATUSID
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[PRPROJECTSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Project Status (' + [inserted].[NAME] + ')',
			'6F30AF6D-97EE-4B9B-A1E7-6BDD1358F3A1',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PRPROJECTSTATUSID = [inserted].PRPROJECTSTATUSID
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
	UNION ALL
	SELECT
			[inserted].[PRPROJECTSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Hold Flag',
			CASE [deleted].[HOLDFLAG] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			CASE [inserted].[HOLDFLAG] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			'Project Status (' + [inserted].[NAME] + ')',
			'6F30AF6D-97EE-4B9B-A1E7-6BDD1358F3A1',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PRPROJECTSTATUSID = [inserted].PRPROJECTSTATUSID
	WHERE	([deleted].[HOLDFLAG] <> [inserted].[HOLDFLAG]) OR ([deleted].[HOLDFLAG] IS NULL AND [inserted].[HOLDFLAG] IS NOT NULL)
			OR ([deleted].[HOLDFLAG] IS NOT NULL AND [inserted].[HOLDFLAG] IS NULL)
	UNION ALL
	SELECT
			[inserted].[PRPROJECTSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Completed Flag',
			CASE WHEN [deleted].[COMPLETEDFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[COMPLETEDFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			'Project Status (' + [inserted].[NAME] + ')',
			'6F30AF6D-97EE-4B9B-A1E7-6BDD1358F3A1',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PRPROJECTSTATUSID = [inserted].PRPROJECTSTATUSID
	WHERE	[deleted].[COMPLETEDFLAG] <> [inserted].[COMPLETEDFLAG]
	UNION ALL
	SELECT
			[inserted].[PRPROJECTSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Cancelled Flag',
			CASE WHEN [deleted].[CANCELLEDFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[CANCELLEDFLAG] = 1 THEN 'Yes' ELSE 'No' END,
			'Project Status (' + [inserted].[NAME] + ')',
			'6F30AF6D-97EE-4B9B-A1E7-6BDD1358F3A1',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].PRPROJECTSTATUSID = [inserted].PRPROJECTSTATUSID
	WHERE	[deleted].[CANCELLEDFLAG] <> [inserted].[CANCELLEDFLAG]
END
GO

CREATE TRIGGER [dbo].[TG_PRPROJECTSTATUS_DELETE]
   ON  [dbo].[PRPROJECTSTATUS]
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
			[deleted].[PRPROJECTSTATUSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Project Status Deleted',
			'',
			'',
			'Project Status (' + [deleted].[NAME] + ')',
			'6F30AF6D-97EE-4B9B-A1E7-6BDD1358F3A1',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_PRPROJECTSTATUS_INSERT] ON [dbo].[PRPROJECTSTATUS]
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
        [inserted].[PRPROJECTSTATUSID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Project Status Added',
        '',
        '',
        'Project Status (' + [inserted].[NAME] + ')',
		'6F30AF6D-97EE-4B9B-A1E7-6BDD1358F3A1',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END