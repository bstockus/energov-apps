CREATE TABLE [dbo].[CASCHEDULE] (
    [CASCHEDULEID]  CHAR (36)      NOT NULL,
    [NAME]          NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]   NVARCHAR (MAX) NOT NULL,
    [STARTDATE]     DATETIME       NOT NULL,
    [ENDDATE]       DATETIME       NOT NULL,
    [IGNOREYEAR]    BIT            CONSTRAINT [DF_CASchedule_IgnoreYear] DEFAULT ((0)) NOT NULL,
    [LASTCHANGEDBY] CHAR (36)      NULL,
    [LASTCHANGEDON] DATETIME       CONSTRAINT [DF_CASCHEDULE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]    INT            CONSTRAINT [DF_CASCHEDULE_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_CASchedule] PRIMARY KEY CLUSTERED ([CASCHEDULEID] ASC) WITH (FILLFACTOR = 80)
);


GO
CREATE NONCLUSTERED INDEX [CASCHEDULE_IX_QUERY]
    ON [dbo].[CASCHEDULE]([CASCHEDULEID] ASC, [NAME] ASC);


GO


CREATE TRIGGER [dbo].[TG_CASCHEDULE_DELETE] ON  [dbo].[CASCHEDULE]
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
			[deleted].[CASCHEDULEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Fee Schedule Deleted',
			'',
			'',
			'Fee Schedule (' + [deleted].[NAME] + ')',
			'3A4AAFFD-993E-4336-BF12-3B066D3835EB',			
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO


CREATE TRIGGER [dbo].[TG_CASCHEDULE_INSERT] ON [dbo].[CASCHEDULE]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of CASCHEDULE table with USERS table.
	IF EXISTS (SELECT * FROM inserted 
		LEFT OUTER JOIN USERS WITH (NOLOCK) ON USERS.SUSERGUID = inserted.LASTCHANGEDBY
		WHERE inserted.LASTCHANGEDBY IS NOT NULL AND USERS.SUSERGUID IS NULL)
	BEGIN		
		RAISERROR ('The INSERT or UPDATE statement conflicted with the FOREIGN KEY to table USERS', 16, 0);
		ROLLBACK;
		RETURN;
	END

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
        [inserted].[CASCHEDULEID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Fee Schedule Added',
        '',
        '',
        'Fee Schedule (' + [inserted].[NAME] + ')',
		'3A4AAFFD-993E-4336-BF12-3B066D3835EB',			
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO


CREATE TRIGGER [dbo].[TG_CASCHEDULE_UPDATE] ON  [dbo].[CASCHEDULE]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of CASCHEDULE table with USERS table.
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
			[inserted].[CASCHEDULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Fee Schedule (' + [inserted].[NAME] + ')',
			'3A4AAFFD-993E-4336-BF12-3B066D3835EB',			
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CASCHEDULEID] = [inserted].[CASCHEDULEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[CASCHEDULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			[deleted].[DESCRIPTION],
			[inserted].[DESCRIPTION],
			'Fee Schedule (' + [inserted].[NAME] + ')',
			'3A4AAFFD-993E-4336-BF12-3B066D3835EB',			
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CASCHEDULEID] = [inserted].[CASCHEDULEID]
	WHERE	[deleted].[DESCRIPTION] <> [inserted].[DESCRIPTION]
	UNION ALL
	SELECT
			[inserted].[CASCHEDULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Ignore Year Flag',
			CASE [deleted].[IGNOREYEAR] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[IGNOREYEAR] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Fee Schedule (' + [inserted].[NAME] + ')',
			'3A4AAFFD-993E-4336-BF12-3B066D3835EB',			
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CASCHEDULEID] = [inserted].[CASCHEDULEID]
	WHERE	[deleted].[IGNOREYEAR] <> [inserted].[IGNOREYEAR]
	UNION ALL
	SELECT
			[inserted].[CASCHEDULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Start Date',
			CONVERT(NVARCHAR(MAX), [deleted].[STARTDATE], 101),
			CONVERT(NVARCHAR(MAX), [inserted].[STARTDATE], 101),
			'Fee Schedule (' + [inserted].[NAME] + ')',
			'3A4AAFFD-993E-4336-BF12-3B066D3835EB',			
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CASCHEDULEID] = [inserted].[CASCHEDULEID]
	WHERE	[deleted].[STARTDATE] <> [inserted].[STARTDATE]
	UNION ALL
	SELECT
			[inserted].[CASCHEDULEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'End Date',
			CONVERT(NVARCHAR(MAX), [deleted].[ENDDATE], 101),
			CONVERT(NVARCHAR(MAX), [inserted].[ENDDATE], 101),
			'Fee Schedule (' + [inserted].[NAME] + ')',
			'3A4AAFFD-993E-4336-BF12-3B066D3835EB',			
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CASCHEDULEID] = [inserted].[CASCHEDULEID]
	WHERE	[deleted].[ENDDATE] <> [inserted].[ENDDATE]
END