CREATE TABLE [dbo].[ILLICENSEGROUP] (
    [ILLICENSEGROUPID]    CHAR (36)      NOT NULL,
    [NAME]                NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]         NVARCHAR (MAX) NULL,
    [MAXCOMMERCIALVALUE]  MONEY          NULL,
    [MAXRESIDENTIALVALUE] MONEY          NULL,
    [LASTCHANGEDBY]       CHAR (36)      NULL,
    [LASTCHANGEDON]       DATETIME       CONSTRAINT [DF_ILLICENSEGROUP_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]          INT            CONSTRAINT [DF_ILLICENSEGROUP_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_ILLicenseGroup] PRIMARY KEY CLUSTERED ([ILLICENSEGROUPID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [ILLICENSEGROUP_IX_QUERY]
    ON [dbo].[ILLICENSEGROUP]([ILLICENSEGROUPID] ASC, [NAME] ASC);


GO


CREATE TRIGGER [dbo].[TG_ILLICENSEGROUP_INSERT] ON [dbo].[ILLICENSEGROUP]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of ILLICENSEGROUP table with USERS table.
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
        [inserted].[ILLICENSEGROUPID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Certification Group Added',
        '',
        '',
        'Certification Group (' + [inserted].[NAME] + ')',
		'BA235021-A93E-4112-9672-05B17FC14999',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO


CREATE TRIGGER [dbo].[TG_ILLICENSEGROUP_UPDATE] ON  [dbo].[ILLICENSEGROUP]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of ILLICENSEGROUP table with USERS table.
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
			[inserted].[ILLICENSEGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Certification Group (' + [inserted].[NAME] + ')',
			'BA235021-A93E-4112-9672-05B17FC14999',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSEGROUPID] = [inserted].[ILLICENSEGROUPID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL
	SELECT
			[inserted].[ILLICENSEGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Certification Group (' + [inserted].[NAME] + ')',
			'BA235021-A93E-4112-9672-05B17FC14999',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSEGROUPID] = [inserted].[ILLICENSEGROUPID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
	UNION ALL
	SELECT
			[inserted].[ILLICENSEGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Maximum Commercial Value',
			ISNULL(CAST(FORMAT([deleted].[MAXCOMMERCIALVALUE], 'C') AS NVARCHAR(MAX)), '[none]'),
			ISNULL(CAST(FORMAT([inserted].[MAXCOMMERCIALVALUE], 'C') AS NVARCHAR(MAX)), '[none]'),
			'Certification Group (' + [inserted].[NAME] + ')',
			'BA235021-A93E-4112-9672-05B17FC14999',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSEGROUPID] = [inserted].[ILLICENSEGROUPID]
	WHERE	ISNULL([deleted].[MAXCOMMERCIALVALUE],'') <> ISNULL([inserted].[MAXCOMMERCIALVALUE],'')
	UNION ALL
	SELECT
			[inserted].[ILLICENSEGROUPID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Maximum Residential Value',
			ISNULL(CAST(FORMAT([deleted].[MAXRESIDENTIALVALUE], 'C') AS NVARCHAR(MAX)), '[none]'),
			ISNULL(CAST(FORMAT([inserted].[MAXRESIDENTIALVALUE], 'C') AS NVARCHAR(MAX)), '[none]'),
			'Certification Group (' + [inserted].[NAME] + ')',
			'BA235021-A93E-4112-9672-05B17FC14999',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[ILLICENSEGROUPID] = [inserted].[ILLICENSEGROUPID]
	WHERE	ISNULL([deleted].[MAXRESIDENTIALVALUE],'') <> ISNULL([inserted].[MAXRESIDENTIALVALUE],'')
END
GO


CREATE TRIGGER [dbo].[TG_ILLICENSEGROUP_DELETE] ON  [dbo].[ILLICENSEGROUP]
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
			[deleted].[ILLICENSEGROUPID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Certification Group Deleted',
			'',
			'',
			'Certification Group (' + [deleted].[NAME] + ')',
			'BA235021-A93E-4112-9672-05B17FC14999',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END