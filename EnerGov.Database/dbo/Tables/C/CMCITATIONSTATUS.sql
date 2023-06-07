CREATE TABLE [dbo].[CMCITATIONSTATUS] (
    [CMCITATIONSTATUSID] CHAR (36)      NOT NULL,
    [NAME]               NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]        NVARCHAR (MAX) NULL,
    [ISSUEDFLAG]         BIT            CONSTRAINT [DF_CMCITATIONSTATUS_ISSUEDFLAG] DEFAULT ((0)) NOT NULL,
    [CLOSEDFLAG]         BIT            CONSTRAINT [DF_CMCITATIONSTATUS_CLOSEDFLAG] DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]      CHAR (36)      NOT NULL,
    [LASTCHANGEDON]      DATETIME       CONSTRAINT [DF_CMCITATIONSTATUS_LASTCHANGEDON] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]         INT            CONSTRAINT [DF_CMCITATIONSTATUS_ROWVERSION] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_CMCITATIONSTATUS] PRIMARY KEY CLUSTERED ([CMCITATIONSTATUSID] ASC),
    CONSTRAINT [FK_CMCITATIONSTATUS_LASTCHANGEDBY] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [UC_CMCITATIONSTATUS_NAME] UNIQUE NONCLUSTERED ([NAME] ASC)
);


GO
CREATE TRIGGER [dbo].[TG_CMCITATIONSTATUS_UPDATE] 
    ON [dbo].[CMCITATIONSTATUS]
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
			[inserted].[CMCITATIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Citation Status Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Citation Status (' + [inserted].[NAME] + ')',
			'C145C995-2260-460A-B5F9-3E80A3312C18',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]	JOIN [inserted] ON [deleted].[CMCITATIONSTATUSID] = [inserted].[CMCITATIONSTATUSID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]

	UNION ALL

	SELECT
			[inserted].[CMCITATIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Citation Status Description',
			ISNULL([deleted].[DESCRIPTION], N'[none]'),
			ISNULL([inserted].[DESCRIPTION], N'[none]'),
			'Citation Status (' + [inserted].[NAME] + ')',
			'C145C995-2260-460A-B5F9-3E80A3312C18',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CMCITATIONSTATUSID] = [inserted].[CMCITATIONSTATUSID]	
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')

	UNION ALL

	SELECT
			[inserted].[CMCITATIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Citation Status Issued Flag',
			CASE [deleted].[ISSUEDFLAG] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[ISSUEDFLAG] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Citation Status (' + [inserted].[NAME] + ')',
			'C145C995-2260-460A-B5F9-3E80A3312C18',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CMCITATIONSTATUSID] = [inserted].[CMCITATIONSTATUSID]	
	WHERE	[deleted].[ISSUEDFLAG] <> [inserted].[ISSUEDFLAG]

	UNION ALL

	SELECT
			[inserted].[CMCITATIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Citation Status Closed Flag',
			CASE [deleted].[CLOSEDFLAG] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[CLOSEDFLAG] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Citation Status (' + [inserted].[NAME] + ')',
			'C145C995-2260-460A-B5F9-3E80A3312C18',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CMCITATIONSTATUSID] = [inserted].[CMCITATIONSTATUSID]	
	WHERE	[deleted].[CLOSEDFLAG] <> [inserted].[CLOSEDFLAG]
END
GO


CREATE TRIGGER [TG_CMCITATIONSTATUS_INSERT]
    ON [dbo].[CMCITATIONSTATUS]
    FOR INSERT
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
			[inserted].[CMCITATIONSTATUSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Citation Status Added',
			'',
			[inserted].[NAME],
			'Citation Status (' + [inserted].[NAME] + ')',
			'C145C995-2260-460A-B5F9-3E80A3312C18',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]
END
GO

CREATE TRIGGER [TG_CMCITATIONSTATUS_DELETE] 
    ON [dbo].[CMCITATIONSTATUS]
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
			[deleted].[CMCITATIONSTATUSID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Citation Status Deleted',
			'',
			'',
			'Citation Status (' + [deleted].[NAME] + ')',
			'C145C995-2260-460A-B5F9-3E80A3312C18',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END