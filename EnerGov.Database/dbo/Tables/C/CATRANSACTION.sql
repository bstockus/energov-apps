﻿CREATE TABLE [dbo].[CATRANSACTION] (
    [CATRANSACTIONID]        CHAR (36)      NOT NULL,
    [CATRANSACTIONTYPEID]    INT            NOT NULL,
    [CATRANSACTIONSTATUSID]  INT            NOT NULL,
    [CATILLSESSIONID]        CHAR (36)      NOT NULL,
    [PARENTTRANSACTIONID]    CHAR (36)      NULL,
    [GLOBALENTITYID]         CHAR (36)      NULL,
    [GLOBALENTITYNAME]       NVARCHAR (MAX) NOT NULL,
    [TRANSACTIONDATE]        DATETIME       NOT NULL,
    [CREATEDBY]              CHAR (36)      NOT NULL,
    [RECEIPTNUMBER]          NVARCHAR (50)  NULL,
    [NOTE]                   VARCHAR (MAX)  NULL,
    [CHANGEBACK]             MONEY          CONSTRAINT [DEF_CATransacton_ChangeBack] DEFAULT ((0)) NOT NULL,
    [ROWVERSION]             INT            CONSTRAINT [DF_CATransaction_RowVersion] DEFAULT ((1)) NOT NULL,
    [LASTCHANGEDON]          DATETIME       CONSTRAINT [DF_CATransaction_LastChangedOn] DEFAULT (getdate()) NOT NULL,
    [LASTCHANGEDBY]          CHAR (36)      NOT NULL,
    [TRANSACTIONGROUPNUMBER] NVARCHAR (50)  CONSTRAINT [DEF_CATransaction_GroupNumber] DEFAULT ('UNASSIGNED - '+CONVERT([varchar](10),getdate(),(110))) NOT NULL,
    [OFFICEID]               CHAR (36)      NULL,
    [EXTERNALSYSTEMID]       NVARCHAR (50)  NULL,
    [DEPOSITREFNBR]          NVARCHAR (50)  NULL,
    [EXTERNALBATCHNBR]       NVARCHAR (50)  NULL,
    [NSFDATE]                DATETIME       NULL,
    CONSTRAINT [PK_CATransaction] PRIMARY KEY NONCLUSTERED ([CATRANSACTIONID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_CATRANSACTION_OFFICE] FOREIGN KEY ([OFFICEID]) REFERENCES [dbo].[OFFICE] ([OFFICEID]),
    CONSTRAINT [FK_CATransaction_Parent] FOREIGN KEY ([PARENTTRANSACTIONID]) REFERENCES [dbo].[CATRANSACTION] ([CATRANSACTIONID]),
    CONSTRAINT [FK_CATransaction_Status] FOREIGN KEY ([CATRANSACTIONSTATUSID]) REFERENCES [dbo].[CATRANSACTIONSTATUS] ([CATRANSACTIONSTATUSID]),
    CONSTRAINT [FK_CATransaction_TillSession] FOREIGN KEY ([CATILLSESSIONID]) REFERENCES [dbo].[CATILLSESSION] ([CATILLSESSIONID]),
    CONSTRAINT [FK_CATransaction_Type] FOREIGN KEY ([CATRANSACTIONTYPEID]) REFERENCES [dbo].[CATRANSACTIONTYPE] ([CATRANSACTIONTYPEID]),
    CONSTRAINT [FK_CATransaction_Users] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [CATRANSACTION_EXTERNALSYS]
    ON [dbo].[CATRANSACTION]([EXTERNALSYSTEMID] ASC, [CATRANSACTIONID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IX_CATRANSACTION_TILL]
    ON [dbo].[CATRANSACTION]([CATILLSESSIONID] ASC)
    INCLUDE([CATRANSACTIONID], [CATRANSACTIONTYPEID], [CATRANSACTIONSTATUSID], [PARENTTRANSACTIONID], [GLOBALENTITYID], [GLOBALENTITYNAME], [TRANSACTIONDATE], [CREATEDBY], [RECEIPTNUMBER], [NOTE], [CHANGEBACK], [ROWVERSION], [LASTCHANGEDON], [LASTCHANGEDBY], [TRANSACTIONGROUPNUMBER], [OFFICEID], [EXTERNALSYSTEMID], [DEPOSITREFNBR], [EXTERNALBATCHNBR]) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IMPORT2]
    ON [dbo].[CATRANSACTION]([GLOBALENTITYID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IMPORT3]
    ON [dbo].[CATRANSACTION]([CATILLSESSIONID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IMPORT4]
    ON [dbo].[CATRANSACTION]([CATRANSACTIONTYPEID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IMPORT5]
    ON [dbo].[CATRANSACTION]([CATRANSACTIONSTATUSID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [NCIDX_CATRANSACTION_PARENTTRANSACTIONID]
    ON [dbo].[CATRANSACTION]([PARENTTRANSACTIONID] ASC) WITH (FILLFACTOR = 90, PAD_INDEX = ON);


GO
CREATE NONCLUSTERED INDEX [NCIDX_CATRANSACTION_TRANSACTIONDATE_INCL]
    ON [dbo].[CATRANSACTION]([TRANSACTIONDATE] ASC)
    INCLUDE([CATRANSACTIONID]) WITH (FILLFACTOR = 90, PAD_INDEX = ON);


GO
CREATE NONCLUSTERED INDEX [IX_CATRANSACTION_EXTERNALBATCHNBR]
    ON [dbo].[CATRANSACTION]([EXTERNALBATCHNBR] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_CATRANSACTION_CATRANSACTIONTYPEID]
    ON [dbo].[CATRANSACTION]([CATRANSACTIONTYPEID] ASC);


GO
CREATE TRIGGER [TG_CATRANSACTION_INSERTUPDATE_ELASTIC_INVOICE] ON  [CATRANSACTION]
   AFTER INSERT, UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

    INSERT INTO [ELASTICSEARCHOBJECT]
    ( [ELASTICSEARCHOBJECTID] ,
        [OBJECTID] ,
        [OBJECTCLASSNAME] ,
        [ROWVERSION] ,
        [CREATEDATE] ,
        [PROCESSEDDATE] ,
        [OBJECTACTION] ,
        [INDEXNAME]
    )
	SELECT
		NEWID() ,
		[CI].[CAINVOICEID] ,
        'EnerGovBusiness.Cashier.CAInvoice' ,
        [CI].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted]
	JOIN [CATRANSACTIONINVOICE] AS [CTI] WITH (NOLOCK) ON [CTI].[CATRANSACTIONID] = [Inserted].[CATRANSACTIONID]
	JOIN [CAINVOICE] AS [CI] WITH (NOLOCK) ON [CI].[CAINVOICEID] = [CTI].[CAINVOICEID];

	INSERT INTO [ELASTICSEARCHOBJECT]
    ( [ELASTICSEARCHOBJECTID] ,
        [OBJECTID] ,
        [OBJECTCLASSNAME] ,
        [ROWVERSION] ,
        [CREATEDATE] ,
        [PROCESSEDDATE] ,
        [OBJECTACTION] ,
        [INDEXNAME]
    )
	SELECT
		NEWID() ,
		[CI].[CAINVOICEID] ,
        'EnerGovBusiness.Cashier.CashieringInvoice' ,
        [CI].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted]
	JOIN [CATRANSACTIONINVOICE] AS [CTI] WITH (NOLOCK) ON [CTI].[CATRANSACTIONID] = [Inserted].[CATRANSACTIONID]
	JOIN [CAINVOICE] AS [CI] WITH (NOLOCK) ON [CI].[CAINVOICEID] = [CTI].[CAINVOICEID];

END
GO

CREATE TRIGGER [TG_CATRANSACTION_DELETE_ELASTIC_INVOICE] ON  [CATRANSACTION]
   AFTER DELETE
AS 
BEGIN
	SET NOCOUNT ON;

    INSERT INTO [ELASTICSEARCHOBJECT]
    ( [ELASTICSEARCHOBJECTID] ,
        [OBJECTID] ,
        [OBJECTCLASSNAME] ,
        [ROWVERSION] ,
        [CREATEDATE] ,
        [PROCESSEDDATE] ,
        [OBJECTACTION] ,
        [INDEXNAME]
    )
	SELECT
		NEWID() ,
		[CI].[CAINVOICEID] ,
        'EnerGovBusiness.Cashier.CAInvoice' ,
        [CI].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        3 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Deleted]
	JOIN [CATRANSACTIONINVOICE] AS [CTI] WITH (NOLOCK) ON [CTI].[CATRANSACTIONID] = [Deleted].[CATRANSACTIONID]
	JOIN [CAINVOICE] AS [CI] WITH (NOLOCK) ON [CI].[CAINVOICEID] = [CTI].[CAINVOICEID];

	INSERT INTO [ELASTICSEARCHOBJECT]
    ( [ELASTICSEARCHOBJECTID] ,
        [OBJECTID] ,
        [OBJECTCLASSNAME] ,
        [ROWVERSION] ,
        [CREATEDATE] ,
        [PROCESSEDDATE] ,
        [OBJECTACTION] ,
        [INDEXNAME]
    )
	SELECT
		NEWID() ,
		[CI].[CAINVOICEID] ,
        'EnerGovBusiness.Cashier.CashieringInvoice' ,
        [CI].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        3 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Deleted]
	JOIN [CATRANSACTIONINVOICE] AS [CTI] WITH (NOLOCK) ON [CTI].[CATRANSACTIONID] = [Deleted].[CATRANSACTIONID]
	JOIN [CAINVOICE] AS [CI] WITH (NOLOCK) ON [CI].[CAINVOICEID] = [CTI].[CAINVOICEID];

END
GO

CREATE TRIGGER [TG_CATRANSACTION_UPDATE_ELASTIC_PAYMENT] ON CATRANSACTION
	AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [ELASTICSEARCHOBJECT]
    ( [ELASTICSEARCHOBJECTID] ,
        [OBJECTID] ,
        [OBJECTCLASSNAME] ,
        [ROWVERSION] ,
        [CREATEDATE] ,
        [PROCESSEDDATE] ,
        [OBJECTACTION] ,
        [INDEXNAME]
    )
	SELECT
		NEWID(),
		[CATRANSACTIONPAYMENT].[CATRANSACTIONPAYMENTID],
		'EnerGovBusiness.Cashier.CATransactionPayment',
		[CATRANSACTIONPAYMENT].[ROWVERSION],
		GETDATE(),
		NULL,
		2,
		(SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted]
	JOIN [CATRANSACTIONPAYMENT] ON [CATRANSACTIONPAYMENT].[CATRANSACTIONID] = [Inserted].[CATRANSACTIONID];

END
GO

CREATE TRIGGER [TG_CATRANSACTION_INSERT_EVENT_QUEUE_PAYMENT_NSF] ON CATRANSACTION
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	BEGIN
			--Event for Fee Payment NSF (only NSF involving fees...exclude bonds, deposits, etc.)
			INSERT INTO [TRANSACTIONEVENTQUEUE]
			( 
				[CATRANSACTIONID],
                [RECEIPTNUMBER],
				[TRANSACTIONEVENTTYPEID],
				[EVENTSTATUSID],
				[CREATEDDATE],
				[LASTCHANGEDBY]
			)
			SELECT 
				[INSERTED].CATRANSACTIONID,
                [INSERTED].[RECEIPTNUMBER],
				2, -- ID for 'Payment NSF' transaction event type 
				1, -- ID for 'Pending' event Status
				GETUTCDATE(),
				[INSERTED].[LASTCHANGEDBY]
			FROM [INSERTED]
			WHERE [INSERTED].[CATRANSACTIONTYPEID] = 5
			AND EXISTS 
			(
				SELECT 1 FROM [CATRANSACTIONFEE] WHERE [CATRANSACTIONFEE].[CATRANSACTIONID] = [INSERTED].[PARENTTRANSACTIONID]
				UNION ALL
				SELECT 1 FROM [CATRANSACTIONMISCFEE] WHERE [CATRANSACTIONMISCFEE].[CATRANSACTIONID] = [INSERTED].[PARENTTRANSACTIONID]
			)
	END
END
GO
DISABLE TRIGGER [dbo].[TG_CATRANSACTION_INSERT_EVENT_QUEUE_PAYMENT_NSF]
    ON [dbo].[CATRANSACTION];


GO


CREATE TRIGGER [TG_CATRANSACTION_INSERT_EVENT_QUEUE_FEE_PAYMENT] ON CATRANSACTION
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	BEGIN
			--Event for Fee Payment Transaction
			INSERT INTO [TRANSACTIONEVENTQUEUE]
			( 
				[CATRANSACTIONID],
                [RECEIPTNUMBER],
				[TRANSACTIONEVENTTYPEID],
				[EVENTSTATUSID],
				[CREATEDDATE],
				[LASTCHANGEDBY]
			)
			SELECT 
				[INSERTED].CATRANSACTIONID,
                [INSERTED].[RECEIPTNUMBER],
				4, -- ID for 'Fee Payment' transaction event type 
				1, -- ID for 'Pending' event Status
				GETUTCDATE(),
				[INSERTED].[LASTCHANGEDBY]
			FROM [INSERTED]
			-- Fee Payment, Account Withdrawal
			WHERE [INSERTED].[CATRANSACTIONTYPEID] IN (1,3)
	END
END
GO
DISABLE TRIGGER [dbo].[TG_CATRANSACTION_INSERT_EVENT_QUEUE_FEE_PAYMENT]
    ON [dbo].[CATRANSACTION];


GO

CREATE TRIGGER [TG_CATRANSACTION_INSERT_EVENT_QUEUE_PAYMENT_VOIDED] ON CATRANSACTION
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	BEGIN
			--Event for Fee Payment Voided (only voids involving fees...exclude bonds, deposits, etc.)
			INSERT INTO [TRANSACTIONEVENTQUEUE]
			( 
				[CATRANSACTIONID],
                [RECEIPTNUMBER],
				[TRANSACTIONEVENTTYPEID],
				[EVENTSTATUSID],
				[CREATEDDATE],
				[LASTCHANGEDBY]
			)
			SELECT 
				[INSERTED].CATRANSACTIONID,
                [INSERTED].[RECEIPTNUMBER],
				3, -- ID for 'Payment Voided' transaction event type 
				1, -- ID for 'Pending' event Status
				GETUTCDATE(),
				[INSERTED].[LASTCHANGEDBY]
			FROM [INSERTED]
			WHERE [INSERTED].[CATRANSACTIONTYPEID] = 6
			AND EXISTS 
			(
				SELECT 1 FROM [CATRANSACTIONFEE] WHERE [CATRANSACTIONFEE].[CATRANSACTIONID] = [INSERTED].[PARENTTRANSACTIONID]
				UNION ALL
				SELECT 1 FROM [CATRANSACTIONMISCFEE] WHERE [CATRANSACTIONMISCFEE].[CATRANSACTIONID] = [INSERTED].[PARENTTRANSACTIONID]
			)
	END
END
GO
DISABLE TRIGGER [dbo].[TG_CATRANSACTION_INSERT_EVENT_QUEUE_PAYMENT_VOIDED]
    ON [dbo].[CATRANSACTION];


GO

CREATE TRIGGER [TG_CATRANSACTION_INSERT_EVENT_QUEUE_PAYMENT_REFUNDED] ON CATRANSACTION
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	BEGIN
			--Event for refund of a fee payment (only refunds involving fees...exclude bonds, deposits, etc.)
			INSERT INTO [TRANSACTIONEVENTQUEUE]
			( 
				[CATRANSACTIONID],
                [RECEIPTNUMBER],
				[TRANSACTIONEVENTTYPEID],
				[EVENTSTATUSID],
				[CREATEDDATE],
				[LASTCHANGEDBY]
			)
			SELECT 
				[INSERTED].CATRANSACTIONID,
                [INSERTED].[RECEIPTNUMBER],
				1, -- ID for 'Payment Refunded' transaction event type 
				1, -- ID for 'Pending' event Status
				GETUTCDATE(),
				[INSERTED].[LASTCHANGEDBY]
			FROM [INSERTED]
			WHERE [INSERTED].[CATRANSACTIONTYPEID] = 4
			AND EXISTS 
			(
				SELECT 1 FROM [CATRANSACTIONFEE] WHERE [CATRANSACTIONFEE].[CATRANSACTIONID] = [INSERTED].[PARENTTRANSACTIONID]
				UNION ALL
				SELECT 1 FROM [CATRANSACTIONMISCFEE] WHERE [CATRANSACTIONMISCFEE].[CATRANSACTIONID] = [INSERTED].[PARENTTRANSACTIONID]
			)
	END
END
GO
DISABLE TRIGGER [dbo].[TG_CATRANSACTION_INSERT_EVENT_QUEUE_PAYMENT_REFUNDED]
    ON [dbo].[CATRANSACTION];

