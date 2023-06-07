﻿CREATE TABLE [dbo].[CAMISCFEE] (
    [CAMISCFEEID]    CHAR (36)       NOT NULL,
    [CAFEEID]        CHAR (36)       NOT NULL,
    [CASTATUSID]     INT             NOT NULL,
    [FEEDESCRIPTION] NVARCHAR (MAX)  NOT NULL,
    [AMOUNT]         MONEY           NOT NULL,
    [PAIDAMOUNT]     MONEY           CONSTRAINT [DEF_CAMiscFee_PaidAmount] DEFAULT ((0)) NOT NULL,
    [INPUTVALUE]     DECIMAL (20, 4) NULL,
    [FEENAME]        NVARCHAR (50)   NOT NULL,
    CONSTRAINT [PK_CAMiscFee] PRIMARY KEY NONCLUSTERED ([CAMISCFEEID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_CAMiscFee_Status] FOREIGN KEY ([CASTATUSID]) REFERENCES [dbo].[CASTATUS] ([CASTATUSID]),
    CONSTRAINT [FK_CCAMiscFee_Fee] FOREIGN KEY ([CAFEEID]) REFERENCES [dbo].[CAFEE] ([CAFEEID])
);


GO
CREATE NONCLUSTERED INDEX [IX_CAMISCFEE_CAFEE]
    ON [dbo].[CAMISCFEE]([CAFEEID] ASC);


GO

CREATE TRIGGER [TG_CAMISCFEE_DELETE_ELASTIC_FEE] ON  CAMISCFEE
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
		[Deleted].[CAMISCFEEID] ,
        'EnerGovBusiness.Cashier.Fee' ,
        1,
        GETDATE() ,
        NULL ,
        3 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Deleted];

END
GO

CREATE TRIGGER [TG_CAMISCFEE_UPDATE_ELASTIC_FEE] ON  CAMISCFEE
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
		NEWID() ,
		[Inserted].[CAMISCFEEID] ,
        'EnerGovBusiness.Cashier.Fee' ,
        1 ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted];

END
GO

CREATE TRIGGER [TG_CAMISCFEE_INSERT_ELASTIC_FEE] ON  CAMISCFEE
   AFTER INSERT
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
		[Inserted].[CAMISCFEEID] ,
        'EnerGovBusiness.Cashier.Fee' ,
        1 ,
        GETDATE() ,
        NULL ,
        1 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted];

END
GO

CREATE TRIGGER [TG_CAMISCFEE_DELETE_ELASTIC_INVOICE] ON  [CAMISCFEE]
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
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Deleted]
	JOIN [CAINVOICEMISCFEE] AS [CIMF] WITH (NOLOCK) ON [CIMF].[CAMISCFEEID] = [Deleted].[CAMISCFEEID]
	JOIN [CAINVOICE] AS [CI] WITH (NOLOCK) ON [CI].[CAINVOICEID] = [CIMF].[CAINVOICEID];

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
	FROM [Deleted]
	JOIN [CAINVOICEMISCFEE] AS [CIMF] WITH (NOLOCK) ON [CIMF].[CAMISCFEEID] = [Deleted].[CAMISCFEEID]
	JOIN [CAINVOICE] AS [CI] WITH (NOLOCK) ON [CI].[CAINVOICEID] = [CIMF].[CAINVOICEID];

END
GO

CREATE TRIGGER [TG_CAMISCFEE_INSERTUPDATE_ELASTIC_INVOICE] ON  [CAMISCFEE]
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
	JOIN [CAINVOICEMISCFEE] AS [CIMF] WITH (NOLOCK) ON [CIMF].[CAMISCFEEID] = [Inserted].[CAMISCFEEID]
	JOIN [CAINVOICE] AS [CI] WITH (NOLOCK) ON [CI].[CAINVOICEID] = [CIMF].[CAINVOICEID];

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
	JOIN [CAINVOICEMISCFEE] AS [CIMF] WITH (NOLOCK) ON [CIMF].[CAMISCFEEID] = [Inserted].[CAMISCFEEID]
	JOIN [CAINVOICE] AS [CI] WITH (NOLOCK) ON [CI].[CAINVOICEID] = [CIMF].[CAINVOICEID];
END