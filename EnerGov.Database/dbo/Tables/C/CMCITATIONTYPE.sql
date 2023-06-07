CREATE TABLE [dbo].[CMCITATIONTYPE] (
    [CMCITATIONTYPEID]        CHAR (36)      NOT NULL,
    [NAME]                    NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]             NVARCHAR (MAX) NULL,
    [PREFIX]                  NVARCHAR (10)  NULL,
    [DEFAULTCITATIONSTATUSID] CHAR (36)      NULL,
    [ACTIVE]                  BIT            CONSTRAINT [DF_CMCITATIONTYPE_ACTIVEFLAG] DEFAULT ((1)) NOT NULL,
    [AUTONUMBER]              BIT            CONSTRAINT [DF_CMCITATIONTYPE_AUTONUMBER] DEFAULT ((0)) NOT NULL,
    [TYPESPECIFICAUTONUMBER]  BIT            CONSTRAINT [DF_CMCITATIONTYPE_AUTONUMBERBYTYPE] DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY]           CHAR (36)      NOT NULL,
    [LASTCHANGEDON]           DATETIME       CONSTRAINT [DF_CMCITATIONTYPE_LASTCHANGEDON] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]              INT            CONSTRAINT [DF_CMCITATIONTYPE_ROWVERSION] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_CMCITATIONTYPE] PRIMARY KEY CLUSTERED ([CMCITATIONTYPEID] ASC),
    CONSTRAINT [FK_CMCITATIONTYPE_CMCITATIONSTATUS] FOREIGN KEY ([DEFAULTCITATIONSTATUSID]) REFERENCES [dbo].[CMCITATIONSTATUS] ([CMCITATIONSTATUSID]),
    CONSTRAINT [FK_CMCITATIONTYPE_LASTCHANGEDBY] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [UC_CMCITATIONTYPE_NAME] UNIQUE NONCLUSTERED ([NAME] ASC)
);


GO

CREATE TRIGGER [TG_CMCITATIONTYPE_HISTORY_DELETE] 
    ON [dbo].[CMCITATIONTYPE]
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
			[deleted].[CMCITATIONTYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Citation Type Deleted',
			'',
			'',
			'Citation type deleted (' + [deleted].[NAME] + ')',
			'1C0EFA26-C479-4209-8B76-E46DEAD89810',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO
CREATE TRIGGER [dbo].[TG_CMCITATIONTYPE_HISTORY_UPDATE] 
    ON [dbo].[CMCITATIONTYPE]
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
			[inserted].[CMCITATIONTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Citation type name updated (' + [inserted].[NAME] + ')',
			'1C0EFA26-C479-4209-8B76-E46DEAD89810',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CMCITATIONTYPEID] = [inserted].[CMCITATIONTYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]

	UNION ALL

	SELECT
			[inserted].[CMCITATIONTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Citation type description updated (' + [inserted].[NAME] + ')',
			'1C0EFA26-C479-4209-8B76-E46DEAD89810',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CMCITATIONTYPEID] = [inserted].[CMCITATIONTYPEID]	
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')

	UNION ALL

	SELECT 
			[inserted].[CMCITATIONTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Prefix',
			ISNULL([deleted].[PREFIX],'[none]'),
			ISNULL([inserted].[PREFIX],'[none]'),
			'Citation type prefix updated (' + [inserted].[NAME] + ')',
			'1C0EFA26-C479-4209-8B76-E46DEAD89810',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CMCITATIONTYPEID] = [inserted].[CMCITATIONTYPEID]
	WHERE	ISNULL([deleted].[PREFIX], '') <> ISNULL([inserted].[PREFIX], '')

	UNION ALL

	SELECT
			[inserted].[CMCITATIONTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active',
			CASE [deleted].[ACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Citation type active updated (' + [inserted].[NAME] + ')',			
			'1C0EFA26-C479-4209-8B76-E46DEAD89810',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CMCITATIONTYPEID] = [inserted].[CMCITATIONTYPEID]	
	WHERE	[deleted].[ACTIVE] <> [inserted].[ACTIVE]

	UNION ALL

	SELECT
			[inserted].[CMCITATIONTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Auto-number',
			CASE [deleted].[AUTONUMBER] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[AUTONUMBER] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Citation type auto-number updated (' + [inserted].[NAME] + ')',			
			'1C0EFA26-C479-4209-8B76-E46DEAD89810',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CMCITATIONTYPEID] = [inserted].[CMCITATIONTYPEID]	
	WHERE	[deleted].[AUTONUMBER] <> [inserted].[AUTONUMBER]

	UNION ALL

	SELECT
			[inserted].[CMCITATIONTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Type-specific Auto-number',
			CASE [deleted].[TYPESPECIFICAUTONUMBER] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[TYPESPECIFICAUTONUMBER] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Citation type type-specific auto-number updated (' + [inserted].[NAME] + ')',			
			'1C0EFA26-C479-4209-8B76-E46DEAD89810',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CMCITATIONTYPEID] = [inserted].[CMCITATIONTYPEID]	
	WHERE	[deleted].[TYPESPECIFICAUTONUMBER] <> [inserted].[TYPESPECIFICAUTONUMBER]

	UNION ALL

	SELECT
			[inserted].[CMCITATIONTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Citation Status',
			ISNULL([STATUS_OLD].[NAME], '[none]'),
			ISNULL([STATUS_NEW].[NAME], '[none]'),
			'Citation type default citation status updated (' + [inserted].[NAME] + ')',			
			'1C0EFA26-C479-4209-8B76-E46DEAD89810',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CMCITATIONTYPEID] = [inserted].[CMCITATIONTYPEID]	
			LEFT JOIN [CMCITATIONSTATUS] [STATUS_OLD] WITH (NOLOCK) ON [deleted].[DEFAULTCITATIONSTATUSID] = [STATUS_OLD].[CMCITATIONSTATUSID]
			LEFT JOIN [CMCITATIONSTATUS] [STATUS_NEW] WITH (NOLOCK) ON [deleted].[DEFAULTCITATIONSTATUSID] = [STATUS_NEW].[CMCITATIONSTATUSID]
	WHERE	ISNULL([deleted].[DEFAULTCITATIONSTATUSID], '') <> ISNULL([inserted].[DEFAULTCITATIONSTATUSID], '')

END
GO



CREATE TRIGGER [TG_CMCITATIONTYPE_HISTORY_INSERT]
    ON [dbo].[CMCITATIONTYPE]
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
			[inserted].[CMCITATIONTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Citation Type Added',
			'',
			[inserted].[NAME],
			'Citation type added (' + [inserted].[NAME] + ')',
			'1C0EFA26-C479-4209-8B76-E46DEAD89810',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]
END