CREATE TABLE [dbo].[MAILINGADDRESS] (
    [MAILINGADDRESSID] CHAR (36)      NOT NULL,
    [ADDRESSLINE1]     NVARCHAR (200) NULL,
    [ADDRESSLINE2]     NVARCHAR (200) NULL,
    [ADDRESSLINE3]     NVARCHAR (200) NULL,
    [CITY]             NVARCHAR (50)  NULL,
    [STATE]            NVARCHAR (50)  NULL,
    [COUNTY]           NVARCHAR (50)  NULL,
    [COUNTRY]          NVARCHAR (50)  NULL,
    [POSTALCODE]       NVARCHAR (50)  NULL,
    [COUNTRYTYPE]      INT            NOT NULL,
    [LASTCHANGEDON]    DATETIME       NOT NULL,
    [LASTCHANGEDBY]    CHAR (36)      NOT NULL,
    [POSTDIRECTION]    NVARCHAR (30)  NULL,
    [PREDIRECTION]     NVARCHAR (30)  NULL,
    [ROWVERSION]       INT            NOT NULL,
    [ADDRESSID]        CHAR (36)      CONSTRAINT [DF_MailingAddress_AddressID] DEFAULT (newid()) NULL,
    [ADDRESSTYPE]      NVARCHAR (50)  NULL,
    [STREETTYPE]       NVARCHAR (50)  NULL,
    [PARCELID]         CHAR (36)      NULL,
    [PARCELNUMBER]     NVARCHAR (50)  NULL,
    [UNITORSUITE]      VARCHAR (20)   NULL,
    [PROVINCE]         NVARCHAR (50)  NULL,
    [RURALROUTE]       NVARCHAR (50)  NULL,
    [STATION]          NVARCHAR (50)  NULL,
    [COMPSITE]         NVARCHAR (50)  NULL,
    [POBOX]            NVARCHAR (50)  NULL,
    [ATTN]             NVARCHAR (50)  NULL,
    [GENERALDELIVERY]  BIT            NULL,
    CONSTRAINT [PK_AMMailingAddress] PRIMARY KEY CLUSTERED ([MAILINGADDRESSID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_MailingAddress_MailingAddressCountryType] FOREIGN KEY ([COUNTRYTYPE]) REFERENCES [dbo].[MAILINGADDRESSCOUNTRYTYPE] ([MAILINGADDRESSCOUNTRYTYPEID]),
    CONSTRAINT [FK_MailingAddress_Parcel] FOREIGN KEY ([PARCELID]) REFERENCES [dbo].[PARCEL] ([PARCELID]),
    CONSTRAINT [FK_MailingAddress_ParcelAddress] FOREIGN KEY ([ADDRESSID]) REFERENCES [dbo].[PARCELADDRESS] ([ADDRESSID]),
    CONSTRAINT [FK_MailingAddress_Users] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [NCIDEX_MAILINGADDRESS_ADDRESSLINE1_ADDRESSLINE2_INCL]
    ON [dbo].[MAILINGADDRESS]([ADDRESSLINE1] ASC, [ADDRESSLINE2] ASC)
    INCLUDE([MAILINGADDRESSID], [ADDRESSLINE3], [POSTDIRECTION], [PREDIRECTION], [STREETTYPE]) WITH (FILLFACTOR = 90, PAD_INDEX = ON);


GO
CREATE NONCLUSTERED INDEX [NCIDX_MAILINGADDRESS_ADDRESSLINE2_ADDRESSLINE1_INCL]
    ON [dbo].[MAILINGADDRESS]([ADDRESSLINE2] ASC, [ADDRESSLINE1] ASC)
    INCLUDE([MAILINGADDRESSID]) WITH (FILLFACTOR = 90, PAD_INDEX = ON);


GO
CREATE NONCLUSTERED INDEX [NCIDX_MAILINGADDRESS_LASTCHANGEDON_LASTCHANGEDBY_ROWVERSION]
    ON [dbo].[MAILINGADDRESS]([LASTCHANGEDON] ASC, [LASTCHANGEDBY] ASC, [ROWVERSION] ASC) WITH (FILLFACTOR = 90, PAD_INDEX = ON);


GO


CREATE TRIGGER [TG_MAILINGADDRESS_UPDATE] ON MAILINGADDRESS
   AFTER UPDATE
AS 
BEGIN	
	SET NOCOUNT ON
	
	DECLARE @CaseType VARCHAR(50) = (SELECT dbo.UFN_GET_CASE_FROM_CONTEXT_INFO())
	-- Check if OFFICE Text is set in the Context info, if yes, then Insert the History Logs else return without inserting any logs	
	IF @CaseType = 'OFFICE'
	BEGIN	
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
			[OFFICE].[OFFICEID],
			[OFFICE].[ROWVERSION],
			GETUTCDATE(),
			[OFFICE].[LASTCHANGEDBY],
			'Address Line 1', 
			ISNULL([deleted].[ADDRESSLINE1], '[none]'),
			ISNULL([inserted].[ADDRESSLINE1], '[none]'),
			'Office (' + [OFFICE].[NAME] + '), Mailing Address (' + [inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '') + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			0,
			[inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '')
	FROM	[deleted] JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	INNER JOIN OFFICEADDRESS ON [OFFICEADDRESS].[MAILLINGADDRESSID] = [deleted].[MAILINGADDRESSID]
	INNER JOIN OFFICE ON [OFFICE].[OFFICEID] = [OFFICEADDRESS].[OFFICEID]
	WHERE	ISNULL([deleted].[ADDRESSLINE1], '') <> ISNULL([inserted].[ADDRESSLINE1], '')
	UNION ALL	
	SELECT
			[OFFICE].[OFFICEID],
			[OFFICE].[ROWVERSION],
			GETUTCDATE(),
			[OFFICE].[LASTCHANGEDBY],
			'Address Line 2',
			ISNULL([deleted].[ADDRESSLINE2], '[none]'),
			ISNULL([inserted].[ADDRESSLINE2], '[none]'),
			'Office (' + [OFFICE].[NAME] + '), Mailing Address (' + [inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '') + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			0,
			[inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '')
	FROM	[deleted] JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	INNER JOIN OFFICEADDRESS ON [OFFICEADDRESS].[MAILLINGADDRESSID] = [deleted].[MAILINGADDRESSID]
	INNER JOIN OFFICE ON [OFFICE].[OFFICEID] = [OFFICEADDRESS].[OFFICEID]
	WHERE	ISNULL([deleted].[ADDRESSLINE2], '') <> ISNULL([inserted].[ADDRESSLINE2], '')
	UNION ALL	
	SELECT
			[OFFICE].[OFFICEID],
			[OFFICE].[ROWVERSION],
			GETUTCDATE(),
			[OFFICE].[LASTCHANGEDBY],
			'Address Line 3',
			ISNULL([deleted].[ADDRESSLINE3], '[none]'),
			ISNULL([inserted].[ADDRESSLINE3], '[none]'),
			'Office (' + [OFFICE].[NAME] + '), Mailing Address (' + [inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '') + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			0,
			[inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '')
	FROM	[deleted] JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	INNER JOIN OFFICEADDRESS ON [OFFICEADDRESS].[MAILLINGADDRESSID] = [deleted].[MAILINGADDRESSID]
	INNER JOIN OFFICE ON [OFFICE].[OFFICEID] = [OFFICEADDRESS].[OFFICEID]
	WHERE	ISNULL([deleted].[ADDRESSLINE3], '') <> ISNULL([inserted].[ADDRESSLINE3], '')
	UNION ALL	
	SELECT
			[OFFICE].[OFFICEID],
			[OFFICE].[ROWVERSION],
			GETUTCDATE(),
			[OFFICE].[LASTCHANGEDBY],
			'US City',
			ISNULL([deleted].[CITY], '[none]'),
			ISNULL([inserted].[CITY], '[none]'),
			'Office (' + [OFFICE].[NAME] + '), Mailing Address (' + [inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '') + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			0,
			[inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '')
	FROM	[deleted] JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	INNER JOIN OFFICEADDRESS ON [OFFICEADDRESS].[MAILLINGADDRESSID] = [deleted].[MAILINGADDRESSID]
	INNER JOIN OFFICE ON [OFFICE].[OFFICEID] = [OFFICEADDRESS].[OFFICEID]
	WHERE	ISNULL([deleted].[CITY], '') <> ISNULL([inserted].[CITY], '')
	UNION ALL	
	SELECT
			[OFFICE].[OFFICEID],
			[OFFICE].[ROWVERSION],
			GETUTCDATE(),
			[OFFICE].[LASTCHANGEDBY],
			'State',
			ISNULL([deleted].[STATE], '[none]'),
			ISNULL([inserted].[STATE], '[none]'),
			'Office (' + [OFFICE].[NAME] + '), Mailing Address (' + [inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '') + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			0,
			[inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '')
	FROM	[deleted] JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	INNER JOIN OFFICEADDRESS ON [OFFICEADDRESS].[MAILLINGADDRESSID] = [deleted].[MAILINGADDRESSID]
	INNER JOIN OFFICE ON [OFFICE].[OFFICEID] = [OFFICEADDRESS].[OFFICEID]
	WHERE	ISNULL([deleted].[STATE], '') <> ISNULL([inserted].[STATE], '')
	UNION ALL	
	SELECT
			[OFFICE].[OFFICEID],
			[OFFICE].[ROWVERSION],
			GETUTCDATE(),
			[OFFICE].[LASTCHANGEDBY],
			'County',
			ISNULL([deleted].[COUNTY], '[none]'),
			ISNULL([inserted].[COUNTY], '[none]'),
			'Office (' + [OFFICE].[NAME] + '), Mailing Address (' + [inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '') + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			0,
			[inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '')
	FROM	[deleted] JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	INNER JOIN OFFICEADDRESS ON [OFFICEADDRESS].[MAILLINGADDRESSID] = [deleted].[MAILINGADDRESSID]
	INNER JOIN OFFICE ON [OFFICE].[OFFICEID] = [OFFICEADDRESS].[OFFICEID]
	WHERE	ISNULL([deleted].[COUNTY], '') <> ISNULL([inserted].[COUNTY], '')
	UNION ALL	
	SELECT
			[OFFICE].[OFFICEID],
			[OFFICE].[ROWVERSION],
			GETUTCDATE(),
			[OFFICE].[LASTCHANGEDBY],
			'Country',
			ISNULL([deleted].[COUNTRY], '[none]'),
			ISNULL([inserted].[COUNTRY], '[none]'),
			'Office (' + [OFFICE].[NAME] + '), Mailing Address (' + [inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '') + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			0,
			[inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '')
	FROM	[deleted] JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	INNER JOIN OFFICEADDRESS ON [OFFICEADDRESS].[MAILLINGADDRESSID] = [deleted].[MAILINGADDRESSID]
	INNER JOIN OFFICE ON [OFFICE].[OFFICEID] = [OFFICEADDRESS].[OFFICEID]
	WHERE	ISNULL([deleted].[COUNTRY], '') <> ISNULL([inserted].[COUNTRY], '')
	UNION ALL	
	SELECT
			[OFFICE].[OFFICEID],
			[OFFICE].[ROWVERSION],
			GETUTCDATE(),
			[OFFICE].[LASTCHANGEDBY],
			'Postal Code',
			ISNULL([deleted].[POSTALCODE], '[none]'),
			ISNULL([inserted].[POSTALCODE], '[none]'),
			'Office (' + [OFFICE].[NAME] + '), Mailing Address (' + [inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '') + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			0,
			[inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '')
	FROM	[deleted] JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	INNER JOIN OFFICEADDRESS ON [OFFICEADDRESS].[MAILLINGADDRESSID] = [deleted].[MAILINGADDRESSID]
	INNER JOIN OFFICE ON [OFFICE].[OFFICEID] = [OFFICEADDRESS].[OFFICEID]
	WHERE	ISNULL([deleted].[POSTALCODE], '') <> ISNULL([inserted].[POSTALCODE], '')
	UNION ALL	
	SELECT
			[OFFICE].[OFFICEID],
			[OFFICE].[ROWVERSION],
			GETUTCDATE(),
			[OFFICE].[LASTCHANGEDBY],
			'Country Type',
			[DELETED_MAILINGADDRESSCOUNTRYTYPE].[MAILINGADDRESSCOUNTRYTYPENAME],
			[INSERTED_MAILINGADDRESSCOUNTRYTYPE].[MAILINGADDRESSCOUNTRYTYPENAME],
			'Office (' + [OFFICE].[NAME] + '), Mailing Address (' + [inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '') + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			0,
			[inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '')
	FROM	[deleted] JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	INNER JOIN OFFICEADDRESS ON [OFFICEADDRESS].[MAILLINGADDRESSID] = [deleted].[MAILINGADDRESSID]
	INNER JOIN OFFICE ON [OFFICE].[OFFICEID] = [OFFICEADDRESS].[OFFICEID]
	LEFT OUTER JOIN MAILINGADDRESSCOUNTRYTYPE [INSERTED_MAILINGADDRESSCOUNTRYTYPE] WITH (NOLOCK) ON [INSERTED_MAILINGADDRESSCOUNTRYTYPE].[MAILINGADDRESSCOUNTRYTYPEID] = [inserted].[COUNTRYTYPE]
	LEFT OUTER JOIN MAILINGADDRESSCOUNTRYTYPE [DELETED_MAILINGADDRESSCOUNTRYTYPE] WITH (NOLOCK) ON [DELETED_MAILINGADDRESSCOUNTRYTYPE].[MAILINGADDRESSCOUNTRYTYPEID] = [deleted].[COUNTRYTYPE]
	WHERE	[deleted].[COUNTRYTYPE] <> [inserted].[COUNTRYTYPE]
	UNION ALL
	SELECT
			[OFFICE].[OFFICEID],
			[OFFICE].[ROWVERSION],
			GETUTCDATE(),
			[OFFICE].[LASTCHANGEDBY],
			'Post Direction',
			ISNULL([deleted].[POSTDIRECTION], '[none]'),
			ISNULL([inserted].[POSTDIRECTION], '[none]'),
			'Office (' + [OFFICE].[NAME] + '), Mailing Address (' + [inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '') + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			0,
			[inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '')
	FROM	[deleted] JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	INNER JOIN OFFICEADDRESS ON [OFFICEADDRESS].[MAILLINGADDRESSID] = [deleted].[MAILINGADDRESSID]
	INNER JOIN OFFICE ON [OFFICE].[OFFICEID] = [OFFICEADDRESS].[OFFICEID]
	WHERE	ISNULL([deleted].[POSTDIRECTION], '') <> ISNULL([inserted].[POSTDIRECTION], '')
	UNION ALL
	SELECT
			[OFFICE].[OFFICEID],
			[OFFICE].[ROWVERSION],
			GETUTCDATE(),
			[OFFICE].[LASTCHANGEDBY],
			'Pre Direction',
			ISNULL([deleted].[PREDIRECTION], '[none]'),
			ISNULL([inserted].[PREDIRECTION], '[none]'),
			'Office (' + [OFFICE].[NAME] + '), Mailing Address (' + [inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '') + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			0,
			[inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '')
	FROM	[deleted] JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	INNER JOIN OFFICEADDRESS ON [OFFICEADDRESS].[MAILLINGADDRESSID] = [deleted].[MAILINGADDRESSID]
	INNER JOIN OFFICE ON [OFFICE].[OFFICEID] = [OFFICEADDRESS].[OFFICEID]
	WHERE	ISNULL([deleted].[PREDIRECTION], '') <> ISNULL([inserted].[PREDIRECTION], '')	
	UNION ALL
	SELECT
			[OFFICE].[OFFICEID],
			[OFFICE].[ROWVERSION],
			GETUTCDATE(),
			[OFFICE].[LASTCHANGEDBY],
			'Address Type',
			ISNULL([deleted].[ADDRESSTYPE], '[none]'),
			ISNULL([inserted].[ADDRESSTYPE], '[none]'),
			'Office (' + [OFFICE].[NAME] + '), Mailing Address (' + [inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '') + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			0,
			[inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '')
	FROM	[deleted] JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	INNER JOIN OFFICEADDRESS ON [OFFICEADDRESS].[MAILLINGADDRESSID] = [deleted].[MAILINGADDRESSID]
	INNER JOIN OFFICE ON [OFFICE].[OFFICEID] = [OFFICEADDRESS].[OFFICEID]
	WHERE	ISNULL([deleted].[ADDRESSTYPE], '') <> ISNULL([inserted].[ADDRESSTYPE], '')
	UNION ALL	
	SELECT
			[OFFICE].[OFFICEID],
			[OFFICE].[ROWVERSION],
			GETUTCDATE(),
			[OFFICE].[LASTCHANGEDBY],
			'Street Type',
			ISNULL([deleted].[STREETTYPE], '[none]'),
			ISNULL([inserted].[STREETTYPE], '[none]'),
			'Office (' + [OFFICE].[NAME] + '), Mailing Address (' + [inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '') + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			0,
			[inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '')
	FROM	[deleted] JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	INNER JOIN OFFICEADDRESS ON [OFFICEADDRESS].[MAILLINGADDRESSID] = [deleted].[MAILINGADDRESSID]
	INNER JOIN OFFICE ON [OFFICE].[OFFICEID] = [OFFICEADDRESS].[OFFICEID]
	WHERE	ISNULL([deleted].[STREETTYPE], '') <> ISNULL([inserted].[STREETTYPE], '')	
	UNION ALL
	SELECT
			[OFFICE].[OFFICEID],
			[OFFICE].[ROWVERSION],
			GETUTCDATE(),
			[OFFICE].[LASTCHANGEDBY],
			'Parcel Number',
			[DELETED_PARCEL].[PARCELNUMBER],
			[INSERTED_PARCEL].[PARCELNUMBER],
			'Office (' + [OFFICE].[NAME] + '), Mailing Address (' + [inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '') + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			0,
			[inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '')
	FROM	[deleted] JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	INNER JOIN OFFICEADDRESS ON [OFFICEADDRESS].[MAILLINGADDRESSID] = [deleted].[MAILINGADDRESSID]
	INNER JOIN OFFICE ON [OFFICE].[OFFICEID] = [OFFICEADDRESS].[OFFICEID]
	LEFT OUTER JOIN PARCEL [INSERTED_PARCEL] WITH (NOLOCK) ON [INSERTED_PARCEL].[PARCELID] = [inserted].[PARCELID]
	LEFT OUTER JOIN PARCEL [DELETED_PARCEL] WITH (NOLOCK) ON [DELETED_PARCEL].[PARCELID] = [deleted].[PARCELID]
	WHERE	ISNULL([deleted].[PARCELID], '') <> ISNULL([inserted].[PARCELID], '')
	UNION ALL
	SELECT
			[OFFICE].[OFFICEID],
			[OFFICE].[ROWVERSION],
			GETUTCDATE(),
			[OFFICE].[LASTCHANGEDBY],
			'Unit or Suite',
			ISNULL([deleted].[UNITORSUITE], '[none]'),
			ISNULL([inserted].[UNITORSUITE], '[none]'),
			'Office (' + [OFFICE].[NAME] + '), Mailing Address (' + [inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '') + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			0,
			[inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '')
	FROM	[deleted] JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	INNER JOIN OFFICEADDRESS ON [OFFICEADDRESS].[MAILLINGADDRESSID] = [deleted].[MAILINGADDRESSID]
	INNER JOIN OFFICE ON [OFFICE].[OFFICEID] = [OFFICEADDRESS].[OFFICEID]
	WHERE	ISNULL([deleted].[UNITORSUITE], '') <> ISNULL([inserted].[UNITORSUITE], '')
	UNION ALL
	SELECT
			[OFFICE].[OFFICEID],
			[OFFICE].[ROWVERSION],
			GETUTCDATE(),
			[OFFICE].[LASTCHANGEDBY],
			'Province',
			ISNULL([deleted].[PROVINCE], '[none]'),
			ISNULL([inserted].[PROVINCE], '[none]'),
			'Office (' + [OFFICE].[NAME] + '), Mailing Address (' + [inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '') + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			0,
			[inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '')
	FROM	[deleted] JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	INNER JOIN OFFICEADDRESS ON [OFFICEADDRESS].[MAILLINGADDRESSID] = [deleted].[MAILINGADDRESSID]
	INNER JOIN OFFICE ON [OFFICE].[OFFICEID] = [OFFICEADDRESS].[OFFICEID]
	WHERE	ISNULL([deleted].[PROVINCE], '') <> ISNULL([inserted].[PROVINCE], '')
	UNION ALL
	SELECT
			[OFFICE].[OFFICEID],
			[OFFICE].[ROWVERSION],
			GETUTCDATE(),
			[OFFICE].[LASTCHANGEDBY],
			'Rural Route',
			ISNULL([deleted].[RURALROUTE], '[none]'),
			ISNULL([inserted].[RURALROUTE], '[none]'),
			'Office (' + [OFFICE].[NAME] + '), Mailing Address (' + [inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '') + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			0,
			[inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '')
	FROM	[deleted] JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	INNER JOIN OFFICEADDRESS ON [OFFICEADDRESS].[MAILLINGADDRESSID] = [deleted].[MAILINGADDRESSID]
	INNER JOIN OFFICE ON [OFFICE].[OFFICEID] = [OFFICEADDRESS].[OFFICEID]
	WHERE	ISNULL([deleted].[RURALROUTE], '') <> ISNULL([inserted].[RURALROUTE], '')
	UNION ALL
	SELECT
			[OFFICE].[OFFICEID],
			[OFFICE].[ROWVERSION],
			GETUTCDATE(),
			[OFFICE].[LASTCHANGEDBY],
			'Station',
			ISNULL([deleted].[STATION], '[none]'),
			ISNULL([inserted].[STATION], '[none]'),
			'Office (' + [OFFICE].[NAME] + '), Mailing Address (' + [inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '') + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			0,
			[inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '')
	FROM	[deleted] JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	INNER JOIN OFFICEADDRESS ON [OFFICEADDRESS].[MAILLINGADDRESSID] = [deleted].[MAILINGADDRESSID]
	INNER JOIN OFFICE ON [OFFICE].[OFFICEID] = [OFFICEADDRESS].[OFFICEID]
	WHERE	ISNULL([deleted].[STATION], '') <> ISNULL([inserted].[STATION], '')
	UNION ALL
	SELECT
			[OFFICE].[OFFICEID],
			[OFFICE].[ROWVERSION],
			GETUTCDATE(),
			[OFFICE].[LASTCHANGEDBY],
			'Compsite',
			ISNULL([deleted].[COMPSITE], '[none]'),
			ISNULL([inserted].[COMPSITE], '[none]'),
			'Office (' + [OFFICE].[NAME] + '), Mailing Address (' + [inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '') + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			0,
			[inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '')
	FROM	[deleted] JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	INNER JOIN OFFICEADDRESS ON [OFFICEADDRESS].[MAILLINGADDRESSID] = [deleted].[MAILINGADDRESSID]
	INNER JOIN OFFICE ON [OFFICE].[OFFICEID] = [OFFICEADDRESS].[OFFICEID]
	WHERE	ISNULL([deleted].[COMPSITE], '') <> ISNULL([inserted].[COMPSITE], '')
	UNION ALL
	SELECT
			[OFFICE].[OFFICEID],
			[OFFICE].[ROWVERSION],
			GETUTCDATE(),
			[OFFICE].[LASTCHANGEDBY],
			'P.O. Box',
			ISNULL([deleted].[POBOX], '[none]'),
			ISNULL([inserted].[POBOX], '[none]'),
			'Office (' + [OFFICE].[NAME] + '), Mailing Address (' + [inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '') + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			0,
			[inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '')
	FROM	[deleted] JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	INNER JOIN OFFICEADDRESS ON [OFFICEADDRESS].[MAILLINGADDRESSID] = [deleted].[MAILINGADDRESSID]
	INNER JOIN OFFICE ON [OFFICE].[OFFICEID] = [OFFICEADDRESS].[OFFICEID]
	WHERE	ISNULL([deleted].[POBOX], '') <> ISNULL([inserted].[POBOX], '')
	UNION ALL
	SELECT
			[OFFICE].[OFFICEID],
			[OFFICE].[ROWVERSION],
			GETUTCDATE(),
			[OFFICE].[LASTCHANGEDBY],
			'Attn',
			ISNULL([deleted].[ATTN], '[none]'),
			ISNULL([inserted].[ATTN], '[none]'),
			'Office (' + [OFFICE].[NAME] + '), Mailing Address (' + [inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '') + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			0,
			[inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '')
	FROM	[deleted] JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	INNER JOIN OFFICEADDRESS ON [OFFICEADDRESS].[MAILLINGADDRESSID] = [deleted].[MAILINGADDRESSID]
	INNER JOIN OFFICE ON [OFFICE].[OFFICEID] = [OFFICEADDRESS].[OFFICEID]
	WHERE	ISNULL([deleted].[ATTN], '') <> ISNULL([inserted].[ATTN], '')
	UNION ALL
	SELECT
			[OFFICE].[OFFICEID],
			[OFFICE].[ROWVERSION],
			GETUTCDATE(),
			[OFFICE].[LASTCHANGEDBY],
			'General Delivery',
			CASE [deleted].[GENERALDELIVERY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			CASE [inserted].[GENERALDELIVERY] WHEN 1 THEN 'Yes' WHEN 0 THEN 'No'  ELSE '[none]' END,
			'Office (' + [OFFICE].[NAME] + '), Mailing Address (' + [inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '') + ')',
			'A4A2A7E4-FB08-47AA-80D9-51C0E68DEBC7',
			2,
			0,
			[inserted].[ADDRESSLINE1] + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '')
	FROM	[deleted] JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	INNER JOIN OFFICEADDRESS ON [OFFICEADDRESS].[MAILLINGADDRESSID] = [deleted].[MAILINGADDRESSID]
	INNER JOIN OFFICE ON [OFFICE].[OFFICEID] = [OFFICEADDRESS].[OFFICEID]
	WHERE	([deleted].[GENERALDELIVERY] <> [inserted].[GENERALDELIVERY]) OR ([deleted].[GENERALDELIVERY] IS NULL AND [inserted].[GENERALDELIVERY] IS NOT NULL)
			OR ([deleted].[GENERALDELIVERY] IS NOT NULL AND [inserted].[GENERALDELIVERY] IS NULL)
	END
	-- Check if MAILINGADDRESS Text is set in the Context info, if yes, then Insert the History Logs else return without inserting any logs	
	IF @CaseType = 'MAILINGADDRESS'
	BEGIN
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
			[inserted].[MAILINGADDRESSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Address Line 1',
			ISNULL([deleted].[ADDRESSLINE1], '[none]'),
			ISNULL([inserted].[ADDRESSLINE1], '[none]'),
			'Manage Address (' + ISNULL([inserted].[ADDRESSLINE1], '[none]') + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '[none]') + ')',
			'C73E22D5-B0C5-4A8C-9073-3067CAFA44A0',
			2,
			1,
			ISNULL([inserted].[ADDRESSLINE1], '[none]') + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	WHERE	[deleted].[ADDRESSLINE1] <> [inserted].[ADDRESSLINE1]
	UNION ALL
	SELECT
			[inserted].[MAILINGADDRESSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Address Line 2',
			ISNULL([deleted].[ADDRESSLINE2], '[none]'),
			ISNULL([inserted].[ADDRESSLINE2], '[none]'),
			'Manage Address (' + ISNULL([inserted].[ADDRESSLINE1], '[none]') + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '[none]') + ')',
			'C73E22D5-B0C5-4A8C-9073-3067CAFA44A0',
			2,
			1,
			ISNULL([inserted].[ADDRESSLINE1], '[none]') + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	WHERE	ISNULL([deleted].[ADDRESSLINE2], '') <> ISNULL([inserted].[ADDRESSLINE2], '')
	UNION ALL
	SELECT
			[inserted].[MAILINGADDRESSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Address Line 3',
			ISNULL([deleted].[ADDRESSLINE3], '[none]'),
			ISNULL([inserted].[ADDRESSLINE3], '[none]'),
			'Manage Address (' + ISNULL([inserted].[ADDRESSLINE1], '[none]') + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '[none]') + ')',
			'C73E22D5-B0C5-4A8C-9073-3067CAFA44A0',
			2,
			1,
			ISNULL([inserted].[ADDRESSLINE1], '[none]') + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	WHERE	ISNULL([deleted].[ADDRESSLINE3], '') <> ISNULL([inserted].[ADDRESSLINE3], '')
	UNION ALL
	SELECT
			[inserted].[MAILINGADDRESSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'City',
			ISNULL([deleted].[CITY], '[none]'),
			ISNULL([inserted].[CITY], '[none]'),
			'Manage Address (' + ISNULL([inserted].[ADDRESSLINE1], '[none]') + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '[none]') + ')',
			'C73E22D5-B0C5-4A8C-9073-3067CAFA44A0',
			2,
			1,
			ISNULL([inserted].[ADDRESSLINE1], '[none]') + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	WHERE	ISNULL([deleted].[CITY], '') <> ISNULL([inserted].[CITY], '')
	UNION ALL
	SELECT
			[inserted].[MAILINGADDRESSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'State',
			ISNULL([deleted].[STATE], '[none]'),
			ISNULL([inserted].[STATE], '[none]'),
			'Manage Address ( ' + ISNULL([inserted].[ADDRESSLINE1], '[none]') + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '[none]') + ' )',
			'C73E22D5-B0C5-4A8C-9073-3067CAFA44A0',
			2,
			1,
			ISNULL([inserted].[ADDRESSLINE1], '[none]') + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	WHERE	ISNULL([deleted].[STATE], '') <> ISNULL([inserted].[STATE], '')
	UNION ALL
	SELECT
			[inserted].[MAILINGADDRESSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'County',
			ISNULL([deleted].[COUNTY], '[none]'),
			ISNULL([inserted].[COUNTY], '[none]'),
			'Manage Address (' + ISNULL([inserted].[ADDRESSLINE1], '[none]') + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '[none]') + ')',
			'C73E22D5-B0C5-4A8C-9073-3067CAFA44A0',
			2,
			1,
			ISNULL([inserted].[ADDRESSLINE1], '[none]') + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	WHERE	ISNULL([deleted].[COUNTY], '') <> ISNULL([inserted].[COUNTY], '')
	UNION ALL
	SELECT
			[inserted].[MAILINGADDRESSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Country',
			ISNULL([deleted].[COUNTRY], '[none]'),
			ISNULL([inserted].[COUNTRY], '[none]'),
			'Manage Address (' + ISNULL([inserted].[ADDRESSLINE1], '[none]') + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '[none]') + ')',
			'C73E22D5-B0C5-4A8C-9073-3067CAFA44A0',
			2,
			1,
			ISNULL([inserted].[ADDRESSLINE1], '[none]') + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	WHERE	ISNULL([deleted].[COUNTRY], '') <> ISNULL([inserted].[COUNTRY], '')
	UNION ALL
	SELECT
			[inserted].[MAILINGADDRESSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Postal Code',
			ISNULL([deleted].[POSTALCODE], '[none]'),
			ISNULL([inserted].[POSTALCODE], '[none]'),
			'Manage Address (' + ISNULL([inserted].[ADDRESSLINE1], '[none]') + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '[none]') + ')',
			'C73E22D5-B0C5-4A8C-9073-3067CAFA44A0',
			2,
			1,
			ISNULL([inserted].[ADDRESSLINE1], '[none]') + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	WHERE	ISNULL([deleted].[POSTALCODE], '') <> ISNULL([inserted].[POSTALCODE], '')
	UNION ALL
	SELECT
			[inserted].[MAILINGADDRESSID],
			[inserted].[ROWVERSION],
			GETUTCDATE(),
			[inserted].[LASTCHANGEDBY],
			'Address Type',
			ISNULL([deleted].[ADDRESSTYPE], '[none]'),
			ISNULL([inserted].[ADDRESSTYPE], '[none]'),
			'Manage Address (' + ISNULL([inserted].[ADDRESSLINE1], '[none]') + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '[none]') + ')',
			'C73E22D5-B0C5-4A8C-9073-3067CAFA44A0',
			2,
			1,
			ISNULL([inserted].[ADDRESSLINE1], '[none]') + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '[none]')
	FROM	[deleted]
			JOIN [inserted] ON [deleted].[MAILINGADDRESSID] = [inserted].[MAILINGADDRESSID]
	WHERE	ISNULL([deleted].[ADDRESSTYPE], '') <> ISNULL([inserted].[ADDRESSTYPE], '')
	
	END
END
GO


CREATE TRIGGER [TG_MAILINGADDRESS_INSERT] ON MAILINGADDRESS
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @CaseType VARCHAR(50) = (SELECT dbo.UFN_GET_CASE_FROM_CONTEXT_INFO())
	-- Check if MAILINGADDRESS Text is set in the Context info, if yes, then Insert the History Logs else return without inserting any logs	
	IF @CaseType = 'MAILINGADDRESS'
	BEGIN
		-- Check if LASTCHANGEDBY contains VALID User Id and it Exists in USERS table, this is in replacement to foreign key reference of MAILINGADDRESS table with USERS table.
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
				[inserted].[MAILINGADDRESSID],
				[inserted].[ROWVERSION],
				GETUTCDATE(),
				[inserted].[LASTCHANGEDBY],
				'Manage Address Added',
				'',
				'',
				'Manage Address (' + ISNULL([inserted].[ADDRESSLINE1], '[none]') + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '[none]') + ')',
				'C73E22D5-B0C5-4A8C-9073-3067CAFA44A0',
				1,
				1,
				ISNULL([inserted].[ADDRESSLINE1], '[none]') + ' ' +  ISNULL([inserted].[ADDRESSLINE2], '[none]')
		FROM	[inserted]
	END	
END
GO


CREATE TRIGGER [TG_MAILINGADDRESS_DELETE] ON MAILINGADDRESS
   AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @CaseType VARCHAR(50) = (SELECT dbo.UFN_GET_CASE_FROM_CONTEXT_INFO())
	-- Check if MAILINGADDRESS Text is set in the Context info, if yes, then Insert the History Logs else return without inserting any logs	
	IF @CaseType = 'MAILINGADDRESS'
	BEGIN
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
				[deleted].[MAILINGADDRESSID],
				[deleted].[ROWVERSION],
				GETUTCDATE(),
				(SELECT dbo.UFN_GET_USERID_FROM_CONTEXT_INFO()),
				'Manage Address Deleted',
				'',
				'',
				'Manage Address (' + ISNULL([deleted].[ADDRESSLINE1], '[none]') + ' ' +  ISNULL([deleted].[ADDRESSLINE2], '[none]') + ')',
				'C73E22D5-B0C5-4A8C-9073-3067CAFA44A0',
				3,
				1,
				ISNULL([deleted].[ADDRESSLINE1], '[none]') + ' ' +  ISNULL([deleted].[ADDRESSLINE2], '[none]')
		FROM	[deleted]
	END
END