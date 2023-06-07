CREATE TABLE [dbo].[GLACCOUNT] (
    [GLACCOUNTID]                   CHAR (36)      NOT NULL,
    [NAME]                          NVARCHAR (100) NOT NULL,
    [DESCRIPTION]                   NVARCHAR (MAX) NULL,
    [ACCOUNTNUMBER]                 NVARCHAR (500) NOT NULL,
    [ACTIVE]                        BIT            NOT NULL,
    [LASTCHANGEDBY]                 CHAR (36)      NULL,
    [LASTCHANGEDON]                 DATETIME       CONSTRAINT [DF_GLaccount_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                    INT            CONSTRAINT [DF_GLaccount_RowVersion] DEFAULT ((1)) NOT NULL,
    [DYNAMICACCOUNT]                BIT            DEFAULT ((0)) NOT NULL,
    [DYNAMICACCOUNTSQLFUNCTIONNAME] NVARCHAR (500) NULL,
    CONSTRAINT [PK_Account] PRIMARY KEY CLUSTERED ([GLACCOUNTID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_GLACCOUNT_USERS] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO

CREATE TRIGGER [dbo].[TG_GLACCOUNT_UPDATE] on [dbo].[GLACCOUNT]    
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
			[inserted].[GLACCOUNTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'GL Account (' + [inserted].[NAME] + ')',
			'5984877F-690C-4173-8E95-964961EAE4C7',			
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].GLACCOUNTID = [inserted].GLACCOUNTID
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[GLACCOUNTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'GL Account (' + [inserted].[NAME] + ')',
			'5984877F-690C-4173-8E95-964961EAE4C7',			
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].GLACCOUNTID = [inserted].GLACCOUNTID
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
	UNION ALL
	SELECT
			[inserted].[GLACCOUNTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Account Number',
			[deleted].[ACCOUNTNUMBER],
			[inserted].[ACCOUNTNUMBER],
			'GL Account (' + [inserted].[NAME] + ')',
			'5984877F-690C-4173-8E95-964961EAE4C7',			
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].GLACCOUNTID = [inserted].GLACCOUNTID	
	WHERE	[deleted].[ACCOUNTNUMBER] <> [inserted].[ACCOUNTNUMBER]
	UNION ALL
	SELECT
			[inserted].[GLACCOUNTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active Flag',			
			CASE WHEN [deleted].[ACTIVE] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[ACTIVE] = 1 THEN 'Yes' ELSE 'No' END,
			'GL Account (' + [inserted].[NAME] + ')',
			'5984877F-690C-4173-8E95-964961EAE4C7',			
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].GLACCOUNTID = [inserted].GLACCOUNTID	
	WHERE	[deleted].[ACTIVE] <> [inserted].[ACTIVE]
	UNION ALL
	SELECT
			[inserted].[GLACCOUNTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Dynamic Account Number Flag',			
			CASE WHEN [deleted].[DYNAMICACCOUNT] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[DYNAMICACCOUNT] = 1 THEN 'Yes' ELSE 'No' END,
			'GL Account (' + [inserted].[NAME] + ')',
			'5984877F-690C-4173-8E95-964961EAE4C7',			
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].GLACCOUNTID = [inserted].GLACCOUNTID	
	WHERE	[deleted].[DYNAMICACCOUNT] <> [inserted].[DYNAMICACCOUNT]
	UNION ALL
	SELECT
			[inserted].[GLACCOUNTID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Dynamic Account Number SQL Function',
			ISNULL([deleted].[DYNAMICACCOUNTSQLFUNCTIONNAME],'[none]'),
			ISNULL([inserted].[DYNAMICACCOUNTSQLFUNCTIONNAME],'[none]'),
			'GL Account (' + [inserted].[NAME] + ')',
			'5984877F-690C-4173-8E95-964961EAE4C7',			
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].GLACCOUNTID = [inserted].GLACCOUNTID
	WHERE	ISNULL([deleted].[DYNAMICACCOUNTSQLFUNCTIONNAME],'') <> ISNULL([inserted].[DYNAMICACCOUNTSQLFUNCTIONNAME],'')
	END
GO

CREATE TRIGGER [TG_GLACCOUNT_INSERT] ON GLACCOUNT
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
        [inserted].[GLACCOUNTID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'GL Account Added',
        '',
        '',
        'GL Account (' + [inserted].[NAME] + ')',
		'5984877F-690C-4173-8E95-964961EAE4C7',			
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_GLACCOUNT_DELETE]
   ON  [dbo].[GLACCOUNT] 
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
			[deleted].[GLACCOUNTID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'GL Account Deleted',
			'',
			'',
			'GL Account (' + [deleted].[NAME] + ')',
			'5984877F-690C-4173-8E95-964961EAE4C7',			
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END