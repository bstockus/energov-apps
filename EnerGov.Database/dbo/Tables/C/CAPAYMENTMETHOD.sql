CREATE TABLE [dbo].[CAPAYMENTMETHOD] (
    [CAPAYMENTMETHODID]           CHAR (36)      NOT NULL,
    [CAPAYMENTTYPEID]             INT            NOT NULL,
    [NAME]                        NVARCHAR (50)  NOT NULL,
    [DESCRIPTION]                 NVARCHAR (MAX) NULL,
    [ISACTIVE]                    BIT            CONSTRAINT [DF_CAPaymentMethod_IsAction] DEFAULT ((1)) NOT NULL,
    [REQUIRESSUPPLIMENTALDATA]    BIT            CONSTRAINT [DF_CAPaymentMethod_ReqSuppliment] DEFAULT ((0)) NOT NULL,
    [REQUIRESCOUNTDOWN]           BIT            CONSTRAINT [DF_CAPaymentMethod_ReqCntDown] DEFAULT ((0)) NOT NULL,
    [ISREFUNDTYPE]                BIT            CONSTRAINT [DF_CAPaymentMethod_IsRefund] DEFAULT ((0)) NOT NULL,
    [SUPPLIMENTALDATANAME]        NVARCHAR (50)  NULL,
    [SUPPLIMENTALDATADESCRIPTION] NVARCHAR (MAX) NULL,
    [ISSYSTEMMETHOD]              BIT            CONSTRAINT [DF_CAPayMethod_IsSysMethod] DEFAULT ((0)) NULL,
    [ISBONDRELEASEMETHOD]         BIT            DEFAULT ((0)) NOT NULL,
    [INCLUDEBONDRELEASEINTILL]    BIT            NULL,
    [INCLUDEREFUNDINTILLSESSION]  BIT            NULL,
    [FEEWAIVER]                   BIT            CONSTRAINT [DF_CAPaymentMethod_FeeWaiver] DEFAULT ((0)) NULL,
    [TENDERTYPEID]                INT            NULL,
    [LASTCHANGEDBY]               CHAR (36)      NULL,
    [LASTCHANGEDON]               DATETIME       CONSTRAINT [DF_CAPAYMENTMETHOD_LastChangedOn] DEFAULT (getutcdate()) NOT NULL,
    [ROWVERSION]                  INT            CONSTRAINT [DF_CAPAYMENTMETHOD_RowVersion] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_CAPaymentMethod] PRIMARY KEY CLUSTERED ([CAPAYMENTMETHODID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_CAPaymentMethod_PayType] FOREIGN KEY ([CAPAYMENTTYPEID]) REFERENCES [dbo].[CAPAYMENTTYPE] ([CAPAYMENTTYPEID])
);


GO
CREATE NONCLUSTERED INDEX [CAPAYMENTMETHOD_IX_QUERY]
    ON [dbo].[CAPAYMENTMETHOD]([CAPAYMENTMETHODID] ASC, [NAME] ASC);


GO

CREATE TRIGGER [dbo].[TG_CAPAYMENTMETHOD_ROLEPAYMENTMETHODXREF_INSERT] ON [dbo].[CAPAYMENTMETHOD]
    AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON

	INSERT INTO [ROLEPAYMENTMETHODXREF]
	(
		[ROLEPAYMENTMETHODXREFID],
		[SROLEGUID],
		[CAPAYMENTMETHODID],
		[DISABLEDFLAG]
	)
	SELECT
		NEWID(),            
		[ROLES].[SROLEGUID],
		[inserted].[CAPAYMENTMETHODID],
		0
	FROM [inserted]
	CROSS JOIN [ROLES]
END
GO

CREATE TRIGGER [TG_CAPAYMENTMETHOD_UPDATE] ON CAPAYMENTMETHOD
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
			[inserted].[CAPAYMENTMETHODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Payment Type',
			[CAPAYMENTTYPE_DELETED].[NAME],
			[CAPAYMENTTYPE_INSERTED].[NAME],
			'Payment Method (' + [inserted].[NAME] + ')',
			'434408C4-A87D-45AE-813C-39FFF2002FC5',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN	[inserted] ON [deleted].[CAPAYMENTMETHODID] = [inserted].[CAPAYMENTMETHODID]
			INNER JOIN CAPAYMENTTYPE CAPAYMENTTYPE_DELETED WITH (NOLOCK) ON [deleted].[CAPAYMENTTYPEID] = [CAPAYMENTTYPE_DELETED].[CAPAYMENTTYPEID]
			INNER JOIN CAPAYMENTTYPE CAPAYMENTTYPE_INSERTED WITH (NOLOCK) ON [inserted].[CAPAYMENTTYPEID] = [CAPAYMENTTYPE_INSERTED].[CAPAYMENTTYPEID]
	WHERE	[deleted].[CAPAYMENTTYPEID] <> [inserted].[CAPAYMENTTYPEID]

	UNION ALL
	SELECT
			[inserted].[CAPAYMENTMETHODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Name',
			[deleted].[NAME],
			[inserted].[NAME],
			'Payment Method (' + [inserted].[NAME] + ')',
			'434408C4-A87D-45AE-813C-39FFF2002FC5',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAPAYMENTMETHODID] = [inserted].[CAPAYMENTMETHODID]
	WHERE	[deleted].[NAME] <> [inserted].[NAME]
	
	UNION ALL
	SELECT
			[inserted].[CAPAYMENTMETHODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Description',
			ISNULL([deleted].[DESCRIPTION],'[none]'),
			ISNULL([inserted].[DESCRIPTION],'[none]'),
			'Payment Method (' + [inserted].[NAME] + ')',
			'434408C4-A87D-45AE-813C-39FFF2002FC5',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAPAYMENTMETHODID] = [inserted].[CAPAYMENTMETHODID]
	WHERE	ISNULL([deleted].[DESCRIPTION], '') <> ISNULL([inserted].[DESCRIPTION], '')
	UNION ALL
	SELECT
			[inserted].[CAPAYMENTMETHODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Is Active Flag',
			CASE WHEN [deleted].[ISACTIVE] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[ISACTIVE] = 1 THEN 'Yes' ELSE 'No' END,
			'Payment Method (' + [inserted].[NAME] + ')',
			'434408C4-A87D-45AE-813C-39FFF2002FC5',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAPAYMENTMETHODID] = [inserted].[CAPAYMENTMETHODID]
	WHERE	[deleted].[ISACTIVE] <> [inserted].[ISACTIVE]
	UNION ALL
	SELECT
			[inserted].[CAPAYMENTMETHODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Requires Supplemental Data Flag',
			CASE WHEN [deleted].[REQUIRESSUPPLIMENTALDATA] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[REQUIRESSUPPLIMENTALDATA] = 1 THEN 'Yes' ELSE 'No' END,
			'Payment Method (' + [inserted].[NAME] + ')',
			'434408C4-A87D-45AE-813C-39FFF2002FC5',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAPAYMENTMETHODID] = [inserted].[CAPAYMENTMETHODID]
	WHERE	[deleted].[REQUIRESSUPPLIMENTALDATA] <> [inserted].[REQUIRESSUPPLIMENTALDATA]
	UNION ALL
	SELECT
			[inserted].[CAPAYMENTMETHODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Requires Count Down Flag',
			CASE WHEN [deleted].[REQUIRESCOUNTDOWN] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[REQUIRESCOUNTDOWN] = 1 THEN 'Yes' ELSE 'No' END,
			'Payment Method (' + [inserted].[NAME] + ')',
			'434408C4-A87D-45AE-813C-39FFF2002FC5',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAPAYMENTMETHODID] = [inserted].[CAPAYMENTMETHODID]
	WHERE	[deleted].[REQUIRESCOUNTDOWN] <> [inserted].[REQUIRESCOUNTDOWN]
	UNION ALL
	SELECT
			[inserted].[CAPAYMENTMETHODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Is Refund Type Flag',
			CASE WHEN [deleted].[ISREFUNDTYPE] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[ISREFUNDTYPE] = 1 THEN 'Yes' ELSE 'No' END,
			'Payment Method (' + [inserted].[NAME] + ')',
			'434408C4-A87D-45AE-813C-39FFF2002FC5',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAPAYMENTMETHODID] = [inserted].[CAPAYMENTMETHODID]
	WHERE	[deleted].[ISREFUNDTYPE] <> [inserted].[ISREFUNDTYPE]
	UNION ALL
	SELECT
			[inserted].[CAPAYMENTMETHODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Supplemental Data Name',
			ISNULL([deleted].[SUPPLIMENTALDATANAME],'[none]'),
			ISNULL([inserted].[SUPPLIMENTALDATANAME],'[none]'),
			'Payment Method (' + [inserted].[NAME] + ')',
			'434408C4-A87D-45AE-813C-39FFF2002FC5',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAPAYMENTMETHODID] = [inserted].[CAPAYMENTMETHODID]
	WHERE	ISNULL([deleted].[SUPPLIMENTALDATANAME], '') <> ISNULL([inserted].[SUPPLIMENTALDATANAME], '')
	UNION ALL
	SELECT
			[inserted].[CAPAYMENTMETHODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Supplemental Data Description',
			ISNULL([deleted].[SUPPLIMENTALDATADESCRIPTION],'[none]'),
			ISNULL([inserted].[SUPPLIMENTALDATADESCRIPTION],'[none]'),
			'Payment Method (' + [inserted].[NAME] + ')',
			'434408C4-A87D-45AE-813C-39FFF2002FC5',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAPAYMENTMETHODID] = [inserted].[CAPAYMENTMETHODID]
	WHERE	ISNULL([deleted].[SUPPLIMENTALDATADESCRIPTION], '') <> ISNULL([inserted].[SUPPLIMENTALDATADESCRIPTION], '')
	UNION ALL
	SELECT
			[inserted].[CAPAYMENTMETHODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Payment Method Is System Method Flag',
			CASE [deleted].[ISSYSTEMMETHOD] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			CASE [inserted].[ISSYSTEMMETHOD] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			'Payment Method (' + [inserted].[NAME] + ')',
			'434408C4-A87D-45AE-813C-39FFF2002FC5',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAPAYMENTMETHODID] = [inserted].[CAPAYMENTMETHODID]
	WHERE	([deleted].[ISSYSTEMMETHOD] <> [inserted].[ISSYSTEMMETHOD]) OR ([deleted].[ISSYSTEMMETHOD] IS NULL AND [inserted].[ISSYSTEMMETHOD] IS NOT NULL)
			OR ([deleted].[ISSYSTEMMETHOD] IS NOT NULL AND [inserted].[ISSYSTEMMETHOD] IS NULL)
	UNION ALL
	SELECT
			[inserted].[CAPAYMENTMETHODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Bond Release Method Flag',
			CASE WHEN [deleted].[ISBONDRELEASEMETHOD] = 1 THEN 'Yes' ELSE 'No' END,
			CASE WHEN [inserted].[ISBONDRELEASEMETHOD] = 1 THEN 'Yes' ELSE 'No' END,
			'Payment Method (' + [inserted].[NAME] + ')',
			'434408C4-A87D-45AE-813C-39FFF2002FC5',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAPAYMENTMETHODID] = [inserted].[CAPAYMENTMETHODID]
	WHERE	[deleted].[ISBONDRELEASEMETHOD] <> [inserted].[ISBONDRELEASEMETHOD]
	UNION ALL
	SELECT
			[inserted].[CAPAYMENTMETHODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Display Bond Release In Till Flag',
			CASE [deleted].[INCLUDEBONDRELEASEINTILL] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			CASE [inserted].[INCLUDEBONDRELEASEINTILL] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			'Payment Method (' + [inserted].[NAME] + ')',
			'434408C4-A87D-45AE-813C-39FFF2002FC5',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAPAYMENTMETHODID] = [inserted].[CAPAYMENTMETHODID]
	WHERE	([deleted].[INCLUDEBONDRELEASEINTILL] <> [inserted].[INCLUDEBONDRELEASEINTILL]) OR ([deleted].[INCLUDEBONDRELEASEINTILL] IS NULL AND [inserted].[INCLUDEBONDRELEASEINTILL] IS NOT NULL)
			OR ([deleted].[INCLUDEBONDRELEASEINTILL] IS NOT NULL AND [inserted].[INCLUDEBONDRELEASEINTILL] IS NULL)
	UNION ALL
			SELECT
			[inserted].[CAPAYMENTMETHODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Include Refund In Till Session Flag',
			CASE [deleted].[INCLUDEREFUNDINTILLSESSION] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			CASE [inserted].[INCLUDEREFUNDINTILLSESSION] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			'Payment Method (' + [inserted].[NAME] + ')',
			'434408C4-A87D-45AE-813C-39FFF2002FC5',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAPAYMENTMETHODID] = [inserted].[CAPAYMENTMETHODID]
	WHERE	([deleted].[INCLUDEREFUNDINTILLSESSION] <> [inserted].[INCLUDEREFUNDINTILLSESSION]) OR ([deleted].[INCLUDEREFUNDINTILLSESSION] IS NULL AND [inserted].[INCLUDEREFUNDINTILLSESSION] IS NOT NULL)
			OR ([deleted].[INCLUDEREFUNDINTILLSESSION] IS NOT NULL AND [inserted].[INCLUDEREFUNDINTILLSESSION] IS NULL)
	UNION ALL
	SELECT
			[inserted].[CAPAYMENTMETHODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Fee Waiver Flag',
			CASE [deleted].[FEEWAIVER] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			CASE [inserted].[FEEWAIVER] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			'Payment Method (' + [inserted].[NAME] + ')',
			'434408C4-A87D-45AE-813C-39FFF2002FC5',
			2,
			1,
			[inserted].[NAME]
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[CAPAYMENTMETHODID] = [inserted].[CAPAYMENTMETHODID]
	WHERE	([deleted].[FEEWAIVER] <> [inserted].[FEEWAIVER]) OR ([deleted].[FEEWAIVER] IS NULL AND [inserted].[FEEWAIVER] IS NOT NULL)
			OR ([deleted].[FEEWAIVER] IS NOT NULL AND [inserted].[FEEWAIVER] IS NULL)
END
GO

CREATE TRIGGER [TG_CAPAYMENTMETHOD_INSERT] ON CAPAYMENTMETHOD
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
			[inserted].[CAPAYMENTMETHODID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Payment Method Added',
			'',
			'',
			'Payment Method (' + [inserted].[NAME] + ')',
			'434408C4-A87D-45AE-813C-39FFF2002FC5',
			1,
			1,
			[inserted].[NAME]
	FROM	[inserted]	
END
GO

CREATE TRIGGER [TG_CAPAYMENTMETHOD_DELETE] ON CAPAYMENTMETHOD
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
			[deleted].[CAPAYMENTMETHODID],
			[deleted].[ROWVERSION],
			GETUTCDATE(),
			(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
			'Payment Method Deleted',
			'',
			'',
			'Payment Method (' + [deleted].[NAME] + ')',
			'434408C4-A87D-45AE-813C-39FFF2002FC5',
			3,
			1,
			[deleted].[NAME]
	FROM	[deleted]
END