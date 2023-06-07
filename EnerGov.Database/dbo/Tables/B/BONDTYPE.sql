CREATE TABLE [dbo].[BONDTYPE] (
    [BONDTYPEID]             CHAR (36)      NOT NULL,
    [NAME]                   NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]            NVARCHAR (MAX) NULL,
    [DEFAULTAMOUNT]          MONEY          NOT NULL,
    [HASTRANSACTION]         BIT            NOT NULL,
    [DEFAULTSTATUSID]        CHAR (36)      NULL,
    [PREFIX]                 NVARCHAR (10)  NULL,
    [DAYSTOEXPIRE]           INT            NULL,
    [ACTIVE]                 BIT            DEFAULT ((0)) NOT NULL,
    [AUTONUMBER]             BIT            DEFAULT ((0)) NOT NULL,
    [ISUSERELEASEINTEREST]   BIT            DEFAULT ((0)) NULL,
    [DAYSPRIORTOACCRUAL]     INT            DEFAULT ((0)) NULL,
    [BONDINTERESTSCHEDULEID] CHAR (36)      NULL,
    [LASTCHANGEDBY]          CHAR (36)      NULL,
    [LASTCHANGEDON]          DATETIME       CONSTRAINT [DF_BONDTYPE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]             INT            CONSTRAINT [DF_BONDTYPE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_BondType] PRIMARY KEY CLUSTERED ([BONDTYPEID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_BondType_DefaultStatus] FOREIGN KEY ([DEFAULTSTATUSID]) REFERENCES [dbo].[BONDSTATUS] ([BONDSTATUSID]),
    CONSTRAINT [FK_BONDTYPE_INT_SCH_ID] FOREIGN KEY ([BONDINTERESTSCHEDULEID]) REFERENCES [dbo].[BONDINTERESTSCHEDULE] ([BONDINTERESTSCHEDULEID])
);


GO
CREATE NONCLUSTERED INDEX [BONDTYPE_IX_QUERY]
    ON [dbo].[BONDTYPE]([BONDTYPEID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_BONDTYPE_INSERT] ON [dbo].[BONDTYPE]
   FOR INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BONDTYPE table with USERS table.
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
			[inserted].[BONDTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Bond Type Added',
			'',
			'',
			'Bond Type (' + [inserted].[NAME] + ')',
			'2A595EDB-1C83-4801-AA9A-43322A829F97',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [dbo].[TG_BONDTYPE_UPDATE] ON [dbo].[BONDTYPE]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
		
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BONDTYPE table with USERS table.
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
			[inserted].[BONDTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Bond Type (' + [inserted].[NAME] + ')',
			'2A595EDB-1C83-4801-AA9A-43322A829F97',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BONDTYPEID] = [inserted].[BONDTYPEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL

	SELECT
			[inserted].[BONDTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Bond Type (' + [inserted].[NAME] + ')',
			'2A595EDB-1C83-4801-AA9A-43322A829F97',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BONDTYPEID] = [inserted].[BONDTYPEID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')	
	UNION ALL

	SELECT
			[inserted].[BONDTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Amount',
			CAST(FORMAT([deleted].[DEFAULTAMOUNT], 'C') AS NVARCHAR(MAX)),
			CAST(FORMAT([inserted].[DEFAULTAMOUNT], 'C') AS NVARCHAR(MAX)),
			'Bond Type (' + [inserted].[NAME] + ')',
			'2A595EDB-1C83-4801-AA9A-43322A829F97',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BONDTYPEID] = [inserted].[BONDTYPEID]
	WHERE	[deleted].[DEFAULTAMOUNT] <> [inserted].[DEFAULTAMOUNT]
	UNION ALL

	SELECT
			[inserted].[BONDTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Has Transactions Flag',
			CASE [deleted].[HASTRANSACTION] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[HASTRANSACTION] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,			
			'Bond Type (' + [inserted].[NAME] + ')',
			'2A595EDB-1C83-4801-AA9A-43322A829F97',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BONDTYPEID] = [inserted].[BONDTYPEID]
	WHERE	[deleted].[HASTRANSACTION] <> [inserted].[HASTRANSACTION]
	UNION ALL

	SELECT
			[inserted].[BONDTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Default Status',
			ISNULL([BONDSTATUS_DELETED].[NAME],'[none]'),
			ISNULL([BONDSTATUS_INSERTED].[NAME],'[none]'),
			'Bond Type (' + [inserted].[NAME] + ')',
			'2A595EDB-1C83-4801-AA9A-43322A829F97',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BONDTYPEID] = [inserted].[BONDTYPEID]
			LEFT JOIN BONDSTATUS BONDSTATUS_DELETED WITH (NOLOCK) ON [deleted].DEFAULTSTATUSID = [BONDSTATUS_DELETED].BONDSTATUSID
			LEFT JOIN BONDSTATUS BONDSTATUS_INSERTED WITH (NOLOCK) ON [inserted].DEFAULTSTATUSID = [BONDSTATUS_INSERTED].BONDSTATUSID
	WHERE	ISNULL([deleted].[DEFAULTSTATUSID],'') <> ISNULL([inserted].[DEFAULTSTATUSID],'')
	UNION ALL

	SELECT
			[inserted].[BONDTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Prefix',
			ISNULL([deleted].[PREFIX],'[none]'),
			ISNULL([inserted].[PREFIX],'[none]'),
			'Bond Type (' + [inserted].[NAME] + ')',
			'2A595EDB-1C83-4801-AA9A-43322A829F97',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BONDTYPEID] = [inserted].[BONDTYPEID]
	WHERE	ISNULL([deleted].[PREFIX], '') <> ISNULL([inserted].[PREFIX], '')	
	UNION ALL

	SELECT
			[inserted].[BONDTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Days to Expire',
			CASE WHEN [deleted].[DAYSTOEXPIRE] IS NULL THEN '[none]' ELSE CONVERT(NVARCHAR(MAX), [deleted].[DAYSTOEXPIRE]) END,
			CASE WHEN [inserted].[DAYSTOEXPIRE] IS NULL THEN '[none]' ELSE CONVERT(NVARCHAR(MAX), [inserted].[DAYSTOEXPIRE]) END,			
			'Bond Type (' + [inserted].[NAME] + ')',
			'2A595EDB-1C83-4801-AA9A-43322A829F97',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BONDTYPEID] = [inserted].[BONDTYPEID]
	WHERE	ISNULL([deleted].[DAYSTOEXPIRE],'') <> ISNULL([inserted].[DAYSTOEXPIRE],'')
	UNION ALL

	SELECT
			[inserted].[BONDTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active Flag',
			CASE [deleted].[ACTIVE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[ACTIVE] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Bond Type (' + [inserted].[NAME] + ')',
			'2A595EDB-1C83-4801-AA9A-43322A829F97',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BONDTYPEID] = [inserted].[BONDTYPEID]
	 WHERE	[deleted].[ACTIVE] <> [inserted].[ACTIVE]	
	UNION ALL

	SELECT
			[inserted].[BONDTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Auto Number Flag',
			CASE [deleted].[AUTONUMBER] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			CASE [inserted].[AUTONUMBER] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' END,
			'Bond Type (' + [inserted].[NAME] + ')',
			'2A595EDB-1C83-4801-AA9A-43322A829F97',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BONDTYPEID] = [inserted].[BONDTYPEID]
	 WHERE	[deleted].[AUTONUMBER] <> [inserted].[AUTONUMBER]	
	UNION ALL

	SELECT
			[inserted].[BONDTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Calculate Release Interest Flag',
			CASE [deleted].[ISUSERELEASEINTEREST] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			CASE [inserted].[ISUSERELEASEINTEREST] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			'Bond Type (' + [inserted].[NAME] + ')',
			'2A595EDB-1C83-4801-AA9A-43322A829F97',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BONDTYPEID] = [inserted].[BONDTYPEID]
	WHERE	([deleted].[ISUSERELEASEINTEREST] <> [inserted].[ISUSERELEASEINTEREST]) OR ([deleted].[ISUSERELEASEINTEREST] IS NULL AND [inserted].[ISUSERELEASEINTEREST] IS NOT NULL)
			OR ([deleted].[ISUSERELEASEINTEREST] IS NOT NULL AND [inserted].[ISUSERELEASEINTEREST] IS NULL)
	UNION ALL			
	SELECT
			[inserted].[BONDTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Days Prior To Accrual',
			CASE WHEN [deleted].[DAYSPRIORTOACCRUAL] IS NULL THEN '[none]' ELSE CONVERT(NVARCHAR(MAX), [deleted].[DAYSPRIORTOACCRUAL]) END,
			CASE WHEN [inserted].[DAYSPRIORTOACCRUAL] IS NULL THEN '[none]' ELSE CONVERT(NVARCHAR(MAX), [inserted].[DAYSPRIORTOACCRUAL]) END,			
			'Bond Type (' + [inserted].[NAME] + ')',
			'2A595EDB-1C83-4801-AA9A-43322A829F97',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BONDTYPEID] = [inserted].[BONDTYPEID]
	WHERE	ISNULL([deleted].[DAYSPRIORTOACCRUAL],'') <> ISNULL([inserted].[DAYSPRIORTOACCRUAL],'')
	UNION ALL

	SELECT
			[inserted].[BONDTYPEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Interest Schedule',
			ISNULL([BONDINTERESTSCHEDULE_DELETED].[NAME],'[none]'),
			ISNULL([BONDINTERESTSCHEDULE_INSERTED].[NAME],'[none]'),
			'Bond Type (' + [inserted].[NAME] + ')',
			'2A595EDB-1C83-4801-AA9A-43322A829F97',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BONDTYPEID] = [inserted].[BONDTYPEID]
			LEFT JOIN BONDINTERESTSCHEDULE BONDINTERESTSCHEDULE_DELETED WITH (NOLOCK) ON [deleted].BONDINTERESTSCHEDULEID = [BONDINTERESTSCHEDULE_DELETED].BONDINTERESTSCHEDULEID
			LEFT JOIN BONDINTERESTSCHEDULE BONDINTERESTSCHEDULE_INSERTED WITH (NOLOCK) ON [inserted].BONDINTERESTSCHEDULEID = [BONDINTERESTSCHEDULE_INSERTED].BONDINTERESTSCHEDULEID
	WHERE	ISNULL([deleted].[BONDINTERESTSCHEDULEID],'') <> ISNULL([inserted].[BONDINTERESTSCHEDULEID],'')
END
GO

CREATE TRIGGER [dbo].[TG_BONDTYPE_DELETE] ON [dbo].[BONDTYPE]
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
			[deleted].[BONDTYPEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Bond Type Deleted',
			'',
			'',
			'Bond Type (' + [deleted].[NAME] + ')',
			'2A595EDB-1C83-4801-AA9A-43322A829F97',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END