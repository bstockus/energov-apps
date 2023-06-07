CREATE TABLE [dbo].[CAFEE] (
    [CAFEEID]                        CHAR (36)      NOT NULL,
    [NAME]                           NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]                    NVARCHAR (MAX) NULL,
    [ACTIVE]                         BIT            NOT NULL,
    [ROWVERSION]                     INT            CONSTRAINT [DF_CAFEE_RowVersion] DEFAULT ((1)) NOT NULL,
    [LASTCHANGEDON]                  DATETIME       CONSTRAINT [DF_CAFEE_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [LASTCHANGEDBY]                  CHAR (36)      NULL,
    [CACOMPUTATIONTYPEID]            INT            CONSTRAINT [DF_CAFee_ComputationType] DEFAULT ((1)) NOT NULL,
    [NOTES]                          NVARCHAR (MAX) NULL,
    [ISTIMETRACKING]                 BIT            CONSTRAINT [DF_CAFEE_ISTIMETRACKING] DEFAULT ((0)) NOT NULL,
    [ISTAXFEE]                       BIT            DEFAULT ((0)) NOT NULL,
    [ISCPIFEE]                       BIT            DEFAULT ((0)) NOT NULL,
    [ISPRORATEFEE]                   BIT            DEFAULT ((0)) NOT NULL,
    [ISARFEE]                        BIT            DEFAULT ((0)) NOT NULL,
    [ARCREDITACCOUNTID]              CHAR (36)      NULL,
    [ARDEBITACCOUNTID]               CHAR (36)      NULL,
    [ARFEECODE]                      NVARCHAR (100) NULL,
    [SETTLEMENTCODE]                 NVARCHAR (100) NULL,
    [APPLYPRORATIONONRENEWAL]        BIT            NULL,
    [ISSUBJECTTOEXTERNALINVOICE]     BIT            DEFAULT ((0)) NOT NULL,
    [DAYSUNTILEXTERNALINVOICEEXPORT] INT            NULL,
    [ISEXEMPTFROMFEEWAIVER]          BIT            CONSTRAINT [DF_CAFEE_ISEXEMPTFROMFEEWAIVER] DEFAULT ((0)) NOT NULL,
    [JURISDICTIONID]                 CHAR (36)      NULL,
    [ISCOMPOUNDINGINTERESTFEE]       BIT            DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CAFee] PRIMARY KEY CLUSTERED ([CAFEEID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_ARCREDITACCT_CAFEE] FOREIGN KEY ([ARCREDITACCOUNTID]) REFERENCES [dbo].[GLACCOUNT] ([GLACCOUNTID]),
    CONSTRAINT [FK_ARDEBITACCT_CAFEE] FOREIGN KEY ([ARDEBITACCOUNTID]) REFERENCES [dbo].[GLACCOUNT] ([GLACCOUNTID]),
    CONSTRAINT [FK_CAFee_ComputationType] FOREIGN KEY ([CACOMPUTATIONTYPEID]) REFERENCES [dbo].[CACOMPUTATIONTYPE] ([CACOMPUTATIONTYPEID]),
    CONSTRAINT [FK_CAFee_Users] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_JURISDICTION_CAFEE] FOREIGN KEY ([JURISDICTIONID]) REFERENCES [dbo].[JURISDICTION] ([JURISDICTIONID])
);


GO
CREATE NONCLUSTERED INDEX [CAFEE_DAYSUNTILEXTERNALINVOICEEXPORT]
    ON [dbo].[CAFEE]([DAYSUNTILEXTERNALINVOICEEXPORT] ASC);


GO
CREATE NONCLUSTERED INDEX [CAFEE_IX_QUERY]
    ON [dbo].[CAFEE]([CAFEEID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_CAFEE_DELETE] ON  [dbo].[CAFEE]
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
			[deleted].[CAFEEID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Fee Deleted',
			'',
			'',
			'Fee (' + [deleted].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END
GO

CREATE TRIGGER [dbo].[TG_CAFEE_INSERT] ON [dbo].[CAFEE]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of CAFEE table with USERS table.
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
        [inserted].[CAFEEID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Fee Added',
        '',
        '',
        'Fee (' + [inserted].[NAME] + ')',
		'A66F715D-7817-4C5C-8D32-D9B22581828C',
		1,
		1,
		[inserted].[NAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_CAFEE_UPDATE] ON  [dbo].[CAFEE]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of CAFEE table with USERS table.
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
			[inserted].[CAFEEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Fee Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Fee (' + [inserted].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	UNION ALL

	SELECT
			[inserted].[CAFEEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Fee (' + [inserted].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
	WHERE	ISNULL([deleted].[DESCRIPTION],'') <> ISNULL([inserted].[DESCRIPTION],'')
	UNION ALL

	SELECT
			[inserted].[CAFEEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Active Flag',
			CASE [deleted].[ACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ACTIVE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Fee (' + [inserted].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
	WHERE	[deleted].[ACTIVE] <> [inserted].[ACTIVE]
	UNION ALL

	SELECT
			[inserted].[CAFEEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Fee Type',
			[CACOMPUTATIONTYPE_DELETED].[NAME],
			[CACOMPUTATIONTYPE_INSERTED].[NAME],
			'Fee (' + [inserted].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
			JOIN [CACOMPUTATIONTYPE] CACOMPUTATIONTYPE_INSERTED WITH (NOLOCK) ON [CACOMPUTATIONTYPE_INSERTED].[CACOMPUTATIONTYPEID] = [inserted].[CACOMPUTATIONTYPEID]
			JOIN [CACOMPUTATIONTYPE] CACOMPUTATIONTYPE_DELETED WITH (NOLOCK) ON [CACOMPUTATIONTYPE_DELETED].[CACOMPUTATIONTYPEID] = [deleted].[CACOMPUTATIONTYPEID]
	WHERE	[deleted].[CACOMPUTATIONTYPEID] <> [inserted].[CACOMPUTATIONTYPEID]
	UNION ALL

	SELECT
			[inserted].[CAFEEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Notes',
			ISNULL([deleted].[NOTES],'[none]'),
			ISNULL([inserted].[NOTES],'[none]'),
			'Fee (' + [inserted].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
	WHERE	ISNULL([deleted].[NOTES],'') <> ISNULL([inserted].[NOTES],'')
	UNION ALL

	SELECT
			[inserted].[CAFEEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Is Time Tracking Fee Flag',
			CASE [deleted].[ISTIMETRACKING] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISTIMETRACKING] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Fee (' + [inserted].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
	WHERE	[deleted].[ISTIMETRACKING] <> [inserted].[ISTIMETRACKING]
	UNION ALL

	SELECT
			[inserted].[CAFEEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Is Tax Fee Flag',
			CASE [deleted].[ISTAXFEE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISTAXFEE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Fee (' + [inserted].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
	WHERE	[deleted].[ISTAXFEE] <> [inserted].[ISTAXFEE]
	UNION ALL

	SELECT
			[inserted].[CAFEEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Subject To CPI Increase Flag',
			CASE [deleted].[ISCPIFEE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISCPIFEE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Fee (' + [inserted].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
	WHERE	[deleted].[ISCPIFEE] <> [inserted].[ISCPIFEE]
	UNION ALL

	SELECT
			[inserted].[CAFEEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Subject to Fee Proration Flag',
			CASE [deleted].[ISPRORATEFEE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISPRORATEFEE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Fee (' + [inserted].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
	WHERE	[deleted].[ISPRORATEFEE] <> [inserted].[ISPRORATEFEE]
	UNION ALL

	SELECT
			[inserted].[CAFEEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Is AR Fee Flag',
			CASE [deleted].[ISARFEE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISARFEE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Fee (' + [inserted].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
	WHERE	[deleted].[ISARFEE] <> [inserted].[ISARFEE]
	UNION ALL

	SELECT
			[inserted].[CAFEEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Apply Proration On Renewals Flag',
			CASE [deleted].[APPLYPRORATIONONRENEWAL] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			CASE [inserted].[APPLYPRORATIONONRENEWAL] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No' ELSE '[none]' END,
			'Fee (' + [inserted].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
	WHERE	[deleted].[APPLYPRORATIONONRENEWAL] <> [inserted].[APPLYPRORATIONONRENEWAL]
			OR ([deleted].[APPLYPRORATIONONRENEWAL] IS NULL AND [inserted].[APPLYPRORATIONONRENEWAL] IS NOT NULL)
			OR ([deleted].[APPLYPRORATIONONRENEWAL] IS NOT NULL AND [inserted].[APPLYPRORATIONONRENEWAL] IS NULL)
	UNION ALL

	SELECT
			[inserted].[CAFEEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Subject to External Invoice Flag',
			CASE [deleted].[ISSUBJECTTOEXTERNALINVOICE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISSUBJECTTOEXTERNALINVOICE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Fee (' + [inserted].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
	WHERE	[deleted].[ISSUBJECTTOEXTERNALINVOICE] <> [inserted].[ISSUBJECTTOEXTERNALINVOICE]	
	UNION ALL

	SELECT
			[inserted].[CAFEEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Exempt from Fee Waivers Flag',
			CASE [deleted].[ISEXEMPTFROMFEEWAIVER] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISEXEMPTFROMFEEWAIVER] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Fee (' + [inserted].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
	WHERE	[deleted].[ISEXEMPTFROMFEEWAIVER] <> [inserted].[ISEXEMPTFROMFEEWAIVER]	
	UNION ALL

	SELECT
			[inserted].[CAFEEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Is Compounding Interest Fee Flag',
			CASE [deleted].[ISCOMPOUNDINGINTERESTFEE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			CASE [inserted].[ISCOMPOUNDINGINTERESTFEE] WHEN 1 THEN 'Yes' ELSE 'No' END,
			'Fee (' + [inserted].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
	WHERE	[deleted].[ISCOMPOUNDINGINTERESTFEE] <> [inserted].[ISCOMPOUNDINGINTERESTFEE]
	UNION ALL

	SELECT
			[inserted].[CAFEEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Days Until Export',
			CASE WHEN [deleted].[DAYSUNTILEXTERNALINVOICEEXPORT] IS NULL THEN '[none]' ELSE CONVERT(NVARCHAR(MAX), [deleted].[DAYSUNTILEXTERNALINVOICEEXPORT]) END,
			CASE WHEN [inserted].[DAYSUNTILEXTERNALINVOICEEXPORT] IS NULL THEN '[none]' ELSE CONVERT(NVARCHAR(MAX), [inserted].[DAYSUNTILEXTERNALINVOICEEXPORT]) END,			
			'Fee (' + [inserted].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
	WHERE	ISNULL([deleted].[DAYSUNTILEXTERNALINVOICEEXPORT],'') <> ISNULL([inserted].[DAYSUNTILEXTERNALINVOICEEXPORT],'')
	UNION ALL

	SELECT
			[inserted].[CAFEEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'AR Credit Account',
			ISNULL([GLACCOUNT_DELETED].[NAME],'[none]'),
			ISNULL([GLACCOUNT_INSERTED].[NAME],'[none]'),
			'Fee (' + [inserted].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
			LEFT JOIN [GLACCOUNT] GLACCOUNT_INSERTED WITH (NOLOCK) ON [GLACCOUNT_INSERTED].[GLACCOUNTID] = [inserted].[ARCREDITACCOUNTID]
			LEFT JOIN [GLACCOUNT] GLACCOUNT_DELETED WITH (NOLOCK) ON [GLACCOUNT_DELETED].[GLACCOUNTID] = [deleted].[ARCREDITACCOUNTID]
	WHERE	ISNULL([deleted].[ARCREDITACCOUNTID],'') <> ISNULL([inserted].[ARCREDITACCOUNTID],'')
	UNION ALL

	SELECT
			[inserted].[CAFEEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'AR Debit Account',
			ISNULL([GLACCOUNT_DELETED].[NAME],'[none]'),
			ISNULL([GLACCOUNT_INSERTED].[NAME],'[none]'),
			'Fee (' + [inserted].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
			LEFT JOIN [GLACCOUNT] GLACCOUNT_INSERTED WITH (NOLOCK) ON [GLACCOUNT_INSERTED].[GLACCOUNTID] = [inserted].[ARDEBITACCOUNTID]
			LEFT JOIN [GLACCOUNT] GLACCOUNT_DELETED WITH (NOLOCK) ON [GLACCOUNT_DELETED].[GLACCOUNTID] = [deleted].[ARDEBITACCOUNTID]
	WHERE	ISNULL([deleted].[ARDEBITACCOUNTID],'') <> ISNULL([inserted].[ARDEBITACCOUNTID],'')
	UNION ALL

	SELECT
			[inserted].[CAFEEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Charge Code',
			ISNULL([deleted].[ARFEECODE],'[none]'),
			ISNULL([inserted].[ARFEECODE],'[none]'),
			'Fee (' + [inserted].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
	WHERE	ISNULL([deleted].[ARFEECODE],'') <> ISNULL([inserted].[ARFEECODE],'')
	UNION ALL

	SELECT
			[inserted].[CAFEEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Settlement Code',
			ISNULL([deleted].[SETTLEMENTCODE],'[none]'),
			ISNULL([inserted].[SETTLEMENTCODE],'[none]'),
			'Fee (' + [inserted].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
	WHERE	ISNULL([deleted].[SETTLEMENTCODE],'') <> ISNULL([inserted].[SETTLEMENTCODE],'')
	UNION ALL

	SELECT 
			[inserted].[CAFEEID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Fee Jurisdiction',
			ISNULL([JURISDICTION_DELETED].[NAME], '[none]'),
			ISNULL([JURISDICTION_INSERTED].[NAME], '[none]'),
			'Fee (' + [inserted].[NAME] + ')',
			'A66F715D-7817-4C5C-8D32-D9B22581828C',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAFEEID] = [inserted].[CAFEEID]
			LEFT JOIN [JURISDICTION] JURISDICTION_DELETED WITH (NOLOCK) ON [JURISDICTION_DELETED].[JURISDICTIONID] = [deleted].[JURISDICTIONID]
			LEFT JOIN [JURISDICTION] JURISDICTION_INSERTED WITH (NOLOCK) ON [JURISDICTION_INSERTED].[JURISDICTIONID] = [inserted].[JURISDICTIONID]
	WHERE	ISNULL([deleted].[JURISDICTIONID], '') <> ISNULL([inserted].[JURISDICTIONID], '')

END