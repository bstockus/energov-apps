﻿CREATE TABLE [dbo].[TXREMITTANCEACCOUNT] (
    [TXREMITTANCEACCOUNTID]     CHAR (36)     NOT NULL,
    [TXREMITTANCESTATUSID]      CHAR (36)     NOT NULL,
    [TXREMITTANCETYPEID]        CHAR (36)     NOT NULL,
    [OPENDATE]                  DATETIME      NULL,
    [CLOSEDATE]                 DATETIME      NULL,
    [NAME]                      VARCHAR (50)  NULL,
    [DESCRIPTION]               VARCHAR (MAX) NULL,
    [CREATEDBY]                 CHAR (36)     NOT NULL,
    [CREATEDDATE]               DATETIME      NOT NULL,
    [GLOBALENTITYACCOUNTID]     CHAR (36)     NULL,
    [BLGLOBALENTITYEXTENSIONID] CHAR (36)     NOT NULL,
    [REMITTANCEACCOUNTNUMBER]   NVARCHAR (50) NOT NULL,
    [IMPORTCUSTOMFIELDLAYOUTID] CHAR (36)     NULL,
    [LASTCHANGEDON]             DATETIME      NULL,
    [ROWVERSION]                INT           NOT NULL,
    [LASTCHANGEBY]              CHAR (36)     NULL,
    [REPORTPERIODID]            CHAR (36)     NOT NULL,
    [GENERATEDDATE]             DATETIME      NULL,
    [ACCOUNTNUMBER]             NVARCHAR (50) NULL,
    [DISTRICT]                  CHAR (36)     NOT NULL,
    [ACCOUNTBALANCE]            MONEY         NULL,
    PRIMARY KEY CLUSTERED ([TXREMITTANCEACCOUNTID] ASC),
    CONSTRAINT [FK_TXACCOUNTCREATEDBY] FOREIGN KEY ([CREATEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_TXACCOUNTCUSTOMELAYOUT] FOREIGN KEY ([IMPORTCUSTOMFIELDLAYOUTID]) REFERENCES [dbo].[CUSTOMFIELDLAYOUT] ([GCUSTOMFIELDLAYOUTS]),
    CONSTRAINT [FK_TXACCOUNTDISTRICT] FOREIGN KEY ([DISTRICT]) REFERENCES [dbo].[DISTRICT] ([DISTRICTID]),
    CONSTRAINT [FK_TXACCOUNTGLOBALACCTID] FOREIGN KEY ([GLOBALENTITYACCOUNTID]) REFERENCES [dbo].[GLOBALENTITYACCOUNT] ([GLOBALENTITYACCOUNTID]),
    CONSTRAINT [FK_TXACCOUNTLASTCHANGEBY] FOREIGN KEY ([LASTCHANGEBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_TXACCOUNTREPORTID] FOREIGN KEY ([REPORTPERIODID]) REFERENCES [dbo].[TXRPTPERIOD] ([TXRPTPERIODID]),
    CONSTRAINT [FK_TXACCOUNTTXREMITTANCESTATUSID] FOREIGN KEY ([TXREMITTANCESTATUSID]) REFERENCES [dbo].[TXREMITSTATUS] ([TXREMITSTATUSID]),
    CONSTRAINT [FK_TXACCOUNTTXREMITTANCETYPEID] FOREIGN KEY ([TXREMITTANCETYPEID]) REFERENCES [dbo].[TXREMITTANCETYPE] ([TXREMITTANCETYPEID]),
    CONSTRAINT [FK_TXBLGLOBALENTITYEXTENSIONID] FOREIGN KEY ([BLGLOBALENTITYEXTENSIONID]) REFERENCES [dbo].[BLGLOBALENTITYEXTENSION] ([BLGLOBALENTITYEXTENSIONID])
);


GO
CREATE NONCLUSTERED INDEX [IX_TXREMITTANCEACCOUNT_BLGLOBALENTITYEXTENSIONID]
    ON [dbo].[TXREMITTANCEACCOUNT]([BLGLOBALENTITYEXTENSIONID] ASC);


GO

CREATE TRIGGER [TG_TXREMITTANCEACCOUNT_UPDATE_EVENT_QUEUE_CLOSED] ON TXREMITTANCEACCOUNT
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [TXREMITTANCEEVENTQUEUE]
			( 
				[TXREMITTANCEACCOUNTID],
				[TXREMITTANCEEVENTTYPEID],
				[EVENTSTATUSID],
				[CREATEDDATE],
				[TXREMITTANCELASTCHANGEDBY]
			)
		-- insert using a SELECT query (do not use IF EXISTS SELECT or SELECT into variables/use the variables) so that if a bulk update of TXREMITTANCEACCOUNT is made 
		--then we pick the correct TXREMITTANCEACCOUNT record to check the previous and new status
		SELECT 
			[INSERTED].TXREMITTANCEACCOUNTID,
			4, -- ID for 'Tax Remittance Account Closed' event Type 
			1, -- ID for 'Pending' Event Status
			GETUTCDATE(),
			[INSERTED].LASTCHANGEBY
		FROM [INSERTED]
		JOIN [TXREMITSTATUS] AS [NEWSTATUS] WITH(NOLOCK) ON [NEWSTATUS].[TXREMITSTATUSID] = [INSERTED].[TXREMITTANCESTATUSID]
		JOIN [DELETED] ON [DELETED].[TXREMITTANCEACCOUNTID] = [INSERTED].[TXREMITTANCEACCOUNTID]
		JOIN [TXREMITSTATUS] AS [OLDSTATUS] WITH(NOLOCK) ON [OLDSTATUS].[TXREMITSTATUSID] = [DELETED].[TXREMITTANCESTATUSID]
		WHERE
			-- check if the new status has issued flag
			[NEWSTATUS].[TXREMITSTATUSSYSTEMID] = 2
			-- check if the old status of the does not have the CLOSED flag, if it's already issued then do not insert a new record in the Event Queue table
		AND [OLDSTATUS].[TXREMITSTATUSSYSTEMID] != 2
 
END
GO


CREATE TRIGGER [TG_TXREMITTANCEACCOUNT_UPDATE_ELASTIC] ON  TXREMITTANCEACCOUNT
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
		[Inserted].[TXREMITTANCEACCOUNTID] ,
        'EnerGovBusiness.TaxRemittance.TaxRemAccount' ,
        [Inserted].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted];

END
GO

CREATE TRIGGER [TG_TXREMITTANCEACCOUNT_INSERT_EVENT_QUEUE_CLOSED] ON TXREMITTANCEACCOUNT
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	BEGIN
		INSERT INTO [TXREMITTANCEEVENTQUEUE]
			( 
				[TXREMITTANCEACCOUNTID],
				[TXREMITTANCEEVENTTYPEID],
				[EVENTSTATUSID],
				[CREATEDDATE],
				[TXREMITTANCELASTCHANGEDBY]
			)
			-- check if the status is CLOSED, if this coniditon is met then insert a new record in the Event Queue table
			SELECT
				[INSERTED].TXREMITTANCEACCOUNTID,
				4, -- ID for 'Tax Remittance Account Closed' event Type 
				1, -- ID for 'Pending' Event Status
				GETUTCDATE(),
				[INSERTED].LASTCHANGEBY
			FROM [INSERTED]
			JOIN [TXREMITSTATUS] WITH(NOLOCK) ON	[INSERTED].TXREMITTANCESTATUSID = TXREMITSTATUS.TXREMITSTATUSID
			WHERE 
				TXREMITSTATUS.TXREMITSTATUSSYSTEMID = 2
	END
END
GO

CREATE TRIGGER [TG_TXREMITTANCEACCOUNT_INSERT_EVENT_QUEUE_CREATED] ON TXREMITTANCEACCOUNT
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	BEGIN
		INSERT INTO [TXREMITTANCEEVENTQUEUE]
			( 
				[TXREMITTANCEACCOUNTID],
				[TXREMITTANCEEVENTTYPEID],
				[EVENTSTATUSID],
				[CREATEDDATE],
				[TXREMITTANCELASTCHANGEDBY]
			)
			-- Insert a new record in the Event Queue table anytime created (don't need to check the status)
			SELECT
				[INSERTED].TXREMITTANCEACCOUNTID,
				1, -- ID for 'Created' event Type 
				1, -- ID for 'Pending' Event Status
				GETUTCDATE(),
				[INSERTED].LASTCHANGEBY
			FROM [INSERTED]
	END
END
GO


CREATE TRIGGER [TG_TXREMITTANCEACCOUNT_DELETE_ELASTIC] ON  TXREMITTANCEACCOUNT
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
		[Deleted].[TXREMITTANCEACCOUNTID] ,
        'EnerGovBusiness.TaxRemittance.TaxRemAccount' ,
        [Deleted].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        3 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Deleted];

END
GO

CREATE TRIGGER [TG_TXREMITTANCEACCOUNT_INSERT_ELASTIC] ON  TXREMITTANCEACCOUNT
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
		[Inserted].[TXREMITTANCEACCOUNTID] ,
        'EnerGovBusiness.TaxRemittance.TaxRemAccount' ,
        [Inserted].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        1 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted];

END