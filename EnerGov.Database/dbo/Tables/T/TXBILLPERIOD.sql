CREATE TABLE [dbo].[TXBILLPERIOD] (
    [BILLPERIODID]                 CHAR (36)     NOT NULL,
    [YEAR]                         INT           NOT NULL,
    [PERIODNAME]                   NVARCHAR (50) NOT NULL,
    [STARTDATE]                    DATETIME      NOT NULL,
    [ENDDATE]                      DATETIME      NOT NULL,
    [DUEDATE]                      DATETIME      NOT NULL,
    [DEFAULTGENERATEDDATE]         DATETIME      NOT NULL,
    [RPTPERIODREF]                 CHAR (36)     NOT NULL,
    [LATEDATE]                     DATETIME      NOT NULL,
    [COMPOUNDINGINTERESTSTARTDATE] DATETIME      NULL,
    [LASTCHANGEDBY]                CHAR (36)     NULL,
    [LASTCHANGEDON]                DATETIME      CONSTRAINT [DF_TXBILLPERIOD_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                   INT           CONSTRAINT [DF_TXBILLPERIOD_RowVersion] DEFAULT ((1)) NOT NULL,
    PRIMARY KEY CLUSTERED ([BILLPERIODID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_TXBILLPERIODYEAR] FOREIGN KEY ([YEAR]) REFERENCES [dbo].[TXBILLPERIODYEAR] ([YEAR]),
    CONSTRAINT [FK_TXBILLRPTPERIOD] FOREIGN KEY ([RPTPERIODREF]) REFERENCES [dbo].[TXRPTPERIOD] ([TXRPTPERIODID])
);


GO
CREATE NONCLUSTERED INDEX [TXBILLPERIOD_IX_QUERY]
    ON [dbo].[TXBILLPERIOD]([BILLPERIODID] ASC, [PERIODNAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_TXBILLPERIOD_INSERT] ON [dbo].[TXBILLPERIOD]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of TXBILLPERIOD table with USERS table.
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
        [inserted].[BILLPERIODID], 
        [inserted].[ROWVERSION],
        GETUTCDATE(),
        [inserted].[LASTCHANGEDBY],
        'Tax Remmittance Bill Period Added',
        '',
        '',
        'Tax Remmittance Bill Period (' + [inserted].[PERIODNAME] + ')',
		'E3658321-D347-4F86-8775-22BEEDD66399',
		1,
		1,
		[inserted].[PERIODNAME]
    FROM [inserted] 
END
GO

CREATE TRIGGER [dbo].[TG_TXBILLPERIOD_UPDATE] 
   ON  [dbo].[TXBILLPERIOD]
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON;

	-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of TXBILLPERIOD table with USERS table.
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
			[inserted].[BILLPERIODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Period Name',
			[deleted].[PERIODNAME],
			[inserted].[PERIODNAME],
			'Tax Remmittance Bill Period (' + [inserted].[PERIODNAME] + ')',
			'E3658321-D347-4F86-8775-22BEEDD66399',
			2,
			1,
			[inserted].[PERIODNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BILLPERIODID] = [inserted].[BILLPERIODID]
	WHERE	[deleted].[PERIODNAME] <> [inserted].[PERIODNAME]
	UNION ALL
	SELECT
			[inserted].[BILLPERIODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Start Date',
			CONVERT(NVARCHAR(MAX), [deleted].[STARTDATE], 101),
			CONVERT(NVARCHAR(MAX), [inserted].[STARTDATE], 101),
			'Tax Remmittance Bill Period (' + [inserted].[PERIODNAME] + ')',
			'E3658321-D347-4F86-8775-22BEEDD66399',
			2,
			1,
			[inserted].[PERIODNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BILLPERIODID] = [inserted].[BILLPERIODID]
	WHERE	[deleted].[STARTDATE] <> [inserted].[STARTDATE]
	UNION ALL
	SELECT
			[inserted].[BILLPERIODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'End Date',
			CONVERT(NVARCHAR(MAX), [deleted].[ENDDATE], 101),
			CONVERT(NVARCHAR(MAX), [inserted].[ENDDATE], 101),
			'Tax Remmittance Bill Period (' + [inserted].[PERIODNAME] + ')',
			'E3658321-D347-4F86-8775-22BEEDD66399',
			2,
			1,
			[inserted].[PERIODNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BILLPERIODID] = [inserted].[BILLPERIODID]
	WHERE	[deleted].[ENDDATE] <> [inserted].[ENDDATE]
	UNION ALL
	SELECT
			[inserted].[BILLPERIODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Due Date',
			CONVERT(NVARCHAR(MAX), [deleted].[DUEDATE], 101),
			CONVERT(NVARCHAR(MAX), [inserted].[DUEDATE], 101),
			'Tax Remmittance Bill Period (' + [inserted].[PERIODNAME] + ')',
			'E3658321-D347-4F86-8775-22BEEDD66399',
			2,
			1,
			[inserted].[PERIODNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BILLPERIODID] = [inserted].[BILLPERIODID]
	WHERE	[deleted].[DUEDATE] <> [inserted].[DUEDATE]
	UNION ALL
	SELECT
			[inserted].[BILLPERIODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Report Generated Date',
			CONVERT(NVARCHAR(MAX), [deleted].[DEFAULTGENERATEDDATE], 101),
			CONVERT(NVARCHAR(MAX), [inserted].[DEFAULTGENERATEDDATE], 101),
			'Tax Remmittance Bill Period (' + [inserted].[PERIODNAME] + ')',
			'E3658321-D347-4F86-8775-22BEEDD66399',
			2,
			1,
			[inserted].[PERIODNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BILLPERIODID] = [inserted].[BILLPERIODID]
	WHERE	[deleted].[DEFAULTGENERATEDDATE] <> [inserted].[DEFAULTGENERATEDDATE]
	UNION ALL
	SELECT
			[inserted].[BILLPERIODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Late Date',
			CONVERT(NVARCHAR(MAX), [deleted].[LATEDATE], 101),
			CONVERT(NVARCHAR(MAX), [inserted].[LATEDATE], 101),
			'Tax Remmittance Bill Period (' + [inserted].[PERIODNAME] + ')',
			'E3658321-D347-4F86-8775-22BEEDD66399',
			2,
			1,
			[inserted].[PERIODNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BILLPERIODID] = [inserted].[BILLPERIODID]
	WHERE	[deleted].[LATEDATE] <> [inserted].[LATEDATE]
	UNION ALL
	SELECT
			[inserted].[BILLPERIODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Compounding Interest Start Date',
			CASE WHEN [deleted].[COMPOUNDINGINTERESTSTARTDATE] IS NOT NULL THEN CONVERT(NVARCHAR(MAX), [deleted].[COMPOUNDINGINTERESTSTARTDATE], 101) ELSE '[none]' END,
			CASE WHEN [inserted].[COMPOUNDINGINTERESTSTARTDATE] IS NOT NULL THEN CONVERT(NVARCHAR(MAX), [inserted].[COMPOUNDINGINTERESTSTARTDATE], 101) ELSE '[none]' END,
			'Tax Remmittance Bill Period (' + [inserted].[PERIODNAME] + ')',
			'E3658321-D347-4F86-8775-22BEEDD66399',
			2,
			1,
			[inserted].[PERIODNAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[BILLPERIODID] = [inserted].[BILLPERIODID]
	WHERE	ISNULL([deleted].[COMPOUNDINGINTERESTSTARTDATE], '') <> ISNULL([inserted].[COMPOUNDINGINTERESTSTARTDATE], '')
	UNION ALL
	SELECT
			[inserted].[BILLPERIODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Report Period',
			TXRPTPERIOD_DELETED.[NAME],
			TXRPTPERIOD_INSERTED.[NAME],
			'Tax Remmittance Bill Period (' + [inserted].[PERIODNAME] + ')',
			'E3658321-D347-4F86-8775-22BEEDD66399',
			2,
			1,
			[inserted].[PERIODNAME]
	FROM	[deleted] JOIN [inserted] ON [deleted].[BILLPERIODID] = [inserted].[BILLPERIODID]
			JOIN [TXRPTPERIOD]  AS TXRPTPERIOD_DELETED WITH (NOLOCK)
				ON [deleted].[RPTPERIODREF]= TXRPTPERIOD_DELETED.[TXRPTPERIODID] 
			JOIN [TXRPTPERIOD] AS TXRPTPERIOD_INSERTED WITH (NOLOCK)
				ON [inserted].[RPTPERIODREF] = TXRPTPERIOD_INSERTED.[TXRPTPERIODID]
			WHERE	[deleted].[RPTPERIODREF]<> [inserted].[RPTPERIODREF]
	UNION ALL
	SELECT
			[inserted].[BILLPERIODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Year',
			CONVERT(NVARCHAR(MAX),TXBILLPERIODYEAR_DELETED.[YEAR]),
			CONVERT(NVARCHAR(MAX),TXBILLPERIODYEAR_INSERTED.[YEAR]),
			'Tax Remmittance Bill Period (' + [inserted].[PERIODNAME] + ')',
			'E3658321-D347-4F86-8775-22BEEDD66399',
			2,
			1,
			[inserted].[PERIODNAME]
	FROM	[deleted] JOIN [inserted] ON [deleted].[BILLPERIODID] = [inserted].[BILLPERIODID]
			JOIN [TXBILLPERIODYEAR]  AS TXBILLPERIODYEAR_DELETED WITH (NOLOCK)
				ON [deleted].[YEAR]= TXBILLPERIODYEAR_DELETED.[YEAR] 
			JOIN [TXBILLPERIODYEAR] AS TXBILLPERIODYEAR_INSERTED WITH (NOLOCK)
				ON [inserted].[YEAR] = TXBILLPERIODYEAR_INSERTED.[YEAR]
			WHERE	[deleted].[YEAR]<> [inserted].[YEAR]

END
GO

CREATE TRIGGER [dbo].[TG_TXBILLPERIOD_DELETE]
   ON  [dbo].[TXBILLPERIOD]
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
			[deleted].[BILLPERIODID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Tax Remmittance Bill Period Deleted',
			'',
			'',
			'Tax Remmittance Bill Period (' + [deleted].[PERIODNAME] + ')',
			'E3658321-D347-4F86-8775-22BEEDD66399',
			3,
			1,
			[deleted].[PERIODNAME]
	FROM [deleted]
END