CREATE TABLE [dbo].[RPTAUTOMAIL] (
    [RPTAUTOMAILID]       CHAR (36)      NOT NULL,
    [SESSIONNAME]         VARCHAR (255)  NULL,
    [RPTDATERANGEID]      INT            NOT NULL,
    [DAYNUMDATE]          INT            NULL,
    [RPTREPORTID]         CHAR (36)      NOT NULL,
    [RECURRENCEID]        CHAR (36)      NOT NULL,
    [DESCRIPTION]         VARCHAR (MAX)  NULL,
    [LASTRECURRENCE]      DATETIME       NULL,
    [NEXTRECURRENCE]      DATETIME       NULL,
    [CUSTOMSUBJECT]       NVARCHAR (MAX) NULL,
    [CUSTOMBODY]          NVARCHAR (MAX) NULL,
    [FTPSETUPID]          CHAR (36)      NULL,
    [SUBPATH]             NVARCHAR (255) NULL,
    [LASTCHANGEDON]       DATETIME       CONSTRAINT [DF_RPTAUTOMAIL_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [LASTCHANGEDBY]       CHAR (36)      NULL,
    [RPTREPORTFILETYPEID] INT            NOT NULL,
    [ROWVERSION]          INT            CONSTRAINT [DF_RPTAUTOMAIL_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_RPTAutoMail] PRIMARY KEY CLUSTERED ([RPTAUTOMAILID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_RPTAutoMail_FtpSetup] FOREIGN KEY ([FTPSETUPID]) REFERENCES [dbo].[FTPSETUP] ([FTPSETUPID]),
    CONSTRAINT [FK_RPTAutoMail_Recur] FOREIGN KEY ([RECURRENCEID]) REFERENCES [dbo].[RECURRENCE] ([RECURRENCEID]),
    CONSTRAINT [FK_RPTAutoMail_ReportFileType] FOREIGN KEY ([RPTREPORTFILETYPEID]) REFERENCES [dbo].[RPTREPORTFILETYPE] ([RPTREPORTFILETYPEID]),
    CONSTRAINT [FK_RPTAutoMail_RPT] FOREIGN KEY ([RPTREPORTID]) REFERENCES [dbo].[RPTREPORT] ([RPTREPORTID])
);


GO
CREATE NONCLUSTERED INDEX [RPTAUTOMAIL_IX_FTPSETUPID]
    ON [dbo].[RPTAUTOMAIL]([FTPSETUPID] ASC);


GO
CREATE NONCLUSTERED INDEX [RPTAUTOMAIL_IX_RECURRENCEID]
    ON [dbo].[RPTAUTOMAIL]([RECURRENCEID] ASC);


GO
CREATE NONCLUSTERED INDEX [RPTAUTOMAIL_IX_RPTREPORTID]
    ON [dbo].[RPTAUTOMAIL]([RPTREPORTID] ASC);


GO
CREATE NONCLUSTERED INDEX [RPTMAILTO_IX_RPTAUTOMAILID]
    ON [dbo].[RPTAUTOMAIL]([RPTAUTOMAILID] ASC);


GO
CREATE NONCLUSTERED INDEX [RPTPRINTTO_IX_RPTAUTOMAILID]
    ON [dbo].[RPTAUTOMAIL]([RPTAUTOMAILID] ASC);


GO

CREATE TRIGGER [dbo].[TG_RPTAUTOMAIL_INSERT] 
	ON [dbo].[RPTAUTOMAIL]
	AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BILLINGRATE table with USERS table.
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
			[inserted].[RPTAUTOMAILID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Report Automation Added',
			'',
			'',
			'Report Automation (' + ISNULL([inserted].[SESSIONNAME],'[none]') + ')',
			'EBB9A3C5-8B05-4E5D-8A53-78585EB20FB5',
			1,
			1,
			ISNULL([inserted].[SESSIONNAME],'[none]')
	FROM	[inserted]
END
GO

CREATE TRIGGER [dbo].[TG_RPTAUTOMAIL_UPDATE] 
	ON [dbo].[RPTAUTOMAIL]
    AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of BILLINGRATE table with USERS table.
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
			[inserted].[RPTAUTOMAILID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Session Name',
			ISNULL([deleted].[SESSIONNAME],'[none]'),
			ISNULL([inserted].[SESSIONNAME],'[none]'),
			'Report Automation (' + ISNULL([inserted].[SESSIONNAME],'[none]') + ')',
			'EBB9A3C5-8B05-4E5D-8A53-78585EB20FB5',
			2,
			1,
			ISNULL([inserted].[SESSIONNAME],'[none]')
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[RPTAUTOMAILID] = [inserted].[RPTAUTOMAILID]
	WHERE	ISNULL([deleted].[SESSIONNAME],'') <> ISNULL([inserted].[SESSIONNAME],'')

	UNION ALL
	SELECT
			[inserted].[RPTAUTOMAILID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Report Automation (' + ISNULL([inserted].[SESSIONNAME],'[none]') + ')',
			'EBB9A3C5-8B05-4E5D-8A53-78585EB20FB5',
			2,
			1,
			ISNULL([inserted].[SESSIONNAME],'[none]')
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[RPTAUTOMAILID] = [inserted].[RPTAUTOMAILID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')

	UNION ALL
	SELECT
			[inserted].[RPTAUTOMAILID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Recurrence',
			DELETERECURRENCE.[NAME],
			INSERTRECURRENCE.[NAME],
			'Report Automation (' + ISNULL([inserted].[SESSIONNAME],'[none]') + ')',
			'EBB9A3C5-8B05-4E5D-8A53-78585EB20FB5',
			2,
			1,
			ISNULL([inserted].[SESSIONNAME],'[none]')
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[RPTAUTOMAILID] = [inserted].[RPTAUTOMAILID]
			INNER JOIN [RECURRENCE] AS DELETERECURRENCE WITH (NOLOCK) ON DELETERECURRENCE.[RECURRENCEID] = [deleted].[RECURRENCEID]
			INNER JOIN [RECURRENCE] AS INSERTRECURRENCE WITH (NOLOCK) ON INSERTRECURRENCE.[RECURRENCEID] = [inserted].[RECURRENCEID]
	WHERE	[deleted].[RECURRENCEID] <> [inserted].[RECURRENCEID]

	UNION ALL
	SELECT
			[inserted].[RPTAUTOMAILID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Report',
			ISNULL(DELETERPTREPORT.[REPORTNAME],'[none]'),
			ISNULL(INSERTRPTREPORT.[REPORTNAME],'[none]'),
			'Report Automation (' + ISNULL([inserted].[SESSIONNAME],'[none]') + ')',
			'EBB9A3C5-8B05-4E5D-8A53-78585EB20FB5',
			2,
			1,
			ISNULL([inserted].[SESSIONNAME],'[none]')
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[RPTAUTOMAILID] = [inserted].[RPTAUTOMAILID]
			INNER JOIN [RPTREPORT] AS DELETERPTREPORT WITH (NOLOCK) ON DELETERPTREPORT.[RPTREPORTID] = [deleted].[RPTREPORTID]
			INNER JOIN [RPTREPORT] AS INSERTRPTREPORT WITH (NOLOCK) ON INSERTRPTREPORT.[RPTREPORTID] = [inserted].[RPTREPORTID]
	WHERE	[deleted].[RPTREPORTID] <> [inserted].[RPTREPORTID]

	UNION ALL
	SELECT
			[inserted].[RPTAUTOMAILID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Date Range',
			CASE [deleted].[RPTDATERANGEID] WHEN 1 THEN 'Last [#] Days' WHEN 2 THEN 'Month To Date' 
				WHEN 3 THEN 'Week To Date' WHEN 4 THEN 'Year To Date' WHEN 5 THEN 'Next [#] of Days' END,
			CASE [inserted].[RPTDATERANGEID] WHEN 1 THEN 'Last [#] Days' WHEN 2 THEN 'Month To Date' 
				WHEN 3 THEN 'Week To Date' WHEN 4 THEN 'Year To Date' WHEN 5 THEN 'Next [#] of Days' END,
			'Report Automation (' + ISNULL([inserted].[SESSIONNAME],'[none]') + ')',
			'EBB9A3C5-8B05-4E5D-8A53-78585EB20FB5',
			2,
			1,
			ISNULL([inserted].[SESSIONNAME],'[none]')
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[RPTAUTOMAILID] = [inserted].[RPTAUTOMAILID]
	WHERE	[deleted].[RPTDATERANGEID] <> [inserted].[RPTDATERANGEID]

	UNION ALL
	SELECT
			[inserted].[RPTAUTOMAILID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Number of Days',
			CASE WHEN [deleted].[DAYNUMDATE] IS NULL THEN '[none]' ELSE CONVERT(NVARCHAR(MAX),[deleted].[DAYNUMDATE]) END,
			CASE WHEN [inserted].[DAYNUMDATE] IS NULL THEN '[none]' ELSE CONVERT(NVARCHAR(MAX),[inserted].[DAYNUMDATE]) END,
			'Report Automation (' + ISNULL([inserted].[SESSIONNAME],'[none]') + ')',
			'EBB9A3C5-8B05-4E5D-8A53-78585EB20FB5',
			2,
			1,
			ISNULL([inserted].[SESSIONNAME],'[none]')
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[RPTAUTOMAILID] = [inserted].[RPTAUTOMAILID]
	WHERE	ISNULL([deleted].[DAYNUMDATE],0) <> ISNULL([inserted].[DAYNUMDATE],0)

	UNION ALL
	SELECT
			[inserted].[RPTAUTOMAILID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'FTP',
			ISNULL(DELETEFTPSETUP.[NAME],'[none]'),
			ISNULL(INSERTFTPSETUP.[NAME],'[none]'),
			'Report Automation (' + ISNULL([inserted].[SESSIONNAME],'[none]') + ')',
			'EBB9A3C5-8B05-4E5D-8A53-78585EB20FB5',
			2,
			1,
			ISNULL([inserted].[SESSIONNAME],'[none]')
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[RPTAUTOMAILID] = [inserted].[RPTAUTOMAILID]
			LEFT JOIN [FTPSETUP] AS DELETEFTPSETUP WITH (NOLOCK) ON DELETEFTPSETUP.[FTPSETUPID] = [deleted].[FTPSETUPID]
			LEFT JOIN [FTPSETUP] AS INSERTFTPSETUP WITH (NOLOCK) ON INSERTFTPSETUP.[FTPSETUPID] = [inserted].[FTPSETUPID]
	WHERE	ISNULL([deleted].[FTPSETUPID],'') <> ISNULL([inserted].[FTPSETUPID],'')

	UNION ALL
	SELECT
			[inserted].[RPTAUTOMAILID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Sub-path',
			ISNULL([deleted].[SUBPATH],'[none]'),
			ISNULL([inserted].[SUBPATH],'[none]'),
			'Report Automation (' + ISNULL([inserted].[SESSIONNAME],'[none]') + ')',
			'EBB9A3C5-8B05-4E5D-8A53-78585EB20FB5',
			2,
			1,
			ISNULL([inserted].[SESSIONNAME],'[none]')
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[RPTAUTOMAILID] = [inserted].[RPTAUTOMAILID]
	WHERE	ISNULL([deleted].[SUBPATH],'') <> ISNULL([inserted].[SUBPATH],'')

	UNION ALL
	SELECT
			[inserted].[RPTAUTOMAILID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Subject',
			ISNULL([deleted].[CUSTOMSUBJECT],'[none]'),
			ISNULL([inserted].[CUSTOMSUBJECT],'[none]'),
			'Report Automation (' + ISNULL([inserted].[SESSIONNAME],'[none]') + ')',
			'EBB9A3C5-8B05-4E5D-8A53-78585EB20FB5',
			2,
			1,
			ISNULL([inserted].[SESSIONNAME],'[none]')
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[RPTAUTOMAILID] = [inserted].[RPTAUTOMAILID]
	WHERE	ISNULL([deleted].[CUSTOMSUBJECT],'') <> ISNULL([inserted].[CUSTOMSUBJECT],'')

	UNION ALL
	SELECT
			[inserted].[RPTAUTOMAILID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Body',
			ISNULL([deleted].[CUSTOMBODY],'[none]'),
			ISNULL([inserted].[CUSTOMBODY],'[none]'),
			'Report Automation (' + ISNULL([inserted].[SESSIONNAME],'[none]') + ')',
			'EBB9A3C5-8B05-4E5D-8A53-78585EB20FB5',
			2,
			1,
			ISNULL([inserted].[SESSIONNAME],'[none]')
	FROM	[deleted]
			INNER JOIN [inserted] ON [deleted].[RPTAUTOMAILID] = [inserted].[RPTAUTOMAILID]
	WHERE	ISNULL([deleted].[CUSTOMBODY],'') <> ISNULL([inserted].[CUSTOMBODY],'')
END
GO

CREATE TRIGGER [dbo].[TG_RPTAUTOMAIL_DELETE] 
	ON [dbo].[RPTAUTOMAIL]
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
			[deleted].[RPTAUTOMAILID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Report Automation Deleted',
			'',
			'',
			'Report Automation (' + ISNULL([deleted].[SESSIONNAME],'[none]') + ')',
			'EBB9A3C5-8B05-4E5D-8A53-78585EB20FB5',
			3,
			1,
			ISNULL([deleted].[SESSIONNAME],'[none]')
	FROM	[deleted]
END