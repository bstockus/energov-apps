﻿CREATE TABLE [dbo].[BLLICENSE] (
    [BLLICENSEID]               CHAR (36)      NOT NULL,
    [BLGLOBALENTITYEXTENSIONID] CHAR (36)      NOT NULL,
    [LICENSENUMBER]             NVARCHAR (50)  NOT NULL,
    [BLLICENSETYPEID]           CHAR (36)      NOT NULL,
    [BLLICENSECLASSID]          CHAR (36)      NOT NULL,
    [BLLICENSESTATUSID]         CHAR (36)      NOT NULL,
    [ISSUEDDATE]                DATETIME       NULL,
    [EXPIRATIONDATE]            DATETIME       NULL,
    [ISSUEDBY]                  CHAR (36)      NULL,
    [DISTRICTID]                CHAR (36)      NOT NULL,
    [APPLIEDDATE]               DATETIME       NULL,
    [LASTRENEWALDATE]           DATETIME       NULL,
    [TAXYEAR]                   INT            NULL,
    [ESTIMATEDRECEIPTS]         MONEY          NULL,
    [ANNUALRECEIPTS]            MONEY          NULL,
    [LASTCHANGEDBY]             CHAR (36)      NULL,
    [ROWVERSION]                INT            NOT NULL,
    [LASTCHANGEDON]             DATETIME       NULL,
    [ACCOUNTNUMBER]             NVARCHAR (50)  NULL,
    [DESCRIPTION]               NVARCHAR (MAX) NULL,
    [GLOBALENTITYACCOUNTID]     CHAR (36)      NULL,
    [REPORTEDRECEIPTS]          MONEY          NULL,
    [ALLOWEDDEDUCTIONAMOUNT]    MONEY          NULL,
    [BLLICENSEPARENTID]         CHAR (36)      NULL,
    [IMPORTCUSTOMFIELDLAYOUTID] CHAR (36)      NULL,
    [CALENDARDUEDATE]           DATETIME       NULL,
    [ISAPPLIEDONLINE]           BIT            CONSTRAINT [DF_BLLICENSE_ISAPPLIEDONLINE] DEFAULT ((0)) NOT NULL,
    [NUMBEROFUNITS]             INT            NULL,
    [PROPERTYNAME]              NVARCHAR (500) NULL,
    [LASTINSPECTIONDATE]        DATETIME       NULL,
    CONSTRAINT [PK_BLLicense] PRIMARY KEY CLUSTERED ([BLLICENSEID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_BLLicense_BLLicense] FOREIGN KEY ([BLLICENSEPARENTID]) REFERENCES [dbo].[BLLICENSE] ([BLLICENSEID]),
    CONSTRAINT [FK_BLLicense_BLLicenseClass] FOREIGN KEY ([BLLICENSECLASSID]) REFERENCES [dbo].[BLLICENSECLASS] ([BLLICENSECLASSID]),
    CONSTRAINT [FK_BLLicense_BLStatus] FOREIGN KEY ([BLLICENSESTATUSID]) REFERENCES [dbo].[BLLICENSESTATUS] ([BLLICENSESTATUSID]),
    CONSTRAINT [FK_BLLicense_BLType] FOREIGN KEY ([BLLICENSETYPEID]) REFERENCES [dbo].[BLLICENSETYPE] ([BLLICENSETYPEID]),
    CONSTRAINT [FK_BLLicense_CustomField] FOREIGN KEY ([IMPORTCUSTOMFIELDLAYOUTID]) REFERENCES [dbo].[CUSTOMFIELDLAYOUT] ([GCUSTOMFIELDLAYOUTS]),
    CONSTRAINT [FK_BLLicense_District] FOREIGN KEY ([DISTRICTID]) REFERENCES [dbo].[DISTRICT] ([DISTRICTID]),
    CONSTRAINT [FK_BLLicense_GlobalEntityAccount] FOREIGN KEY ([GLOBALENTITYACCOUNTID]) REFERENCES [dbo].[GLOBALENTITYACCOUNT] ([GLOBALENTITYACCOUNTID]),
    CONSTRAINT [FK_BLLicense_Users] FOREIGN KEY ([ISSUEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_BLLicense_Users1] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID]),
    CONSTRAINT [FK_License_GlobalEntityExt] FOREIGN KEY ([BLGLOBALENTITYEXTENSIONID]) REFERENCES [dbo].[BLGLOBALENTITYEXTENSION] ([BLGLOBALENTITYEXTENSIONID])
);


GO
CREATE NONCLUSTERED INDEX [BLLICENSE_ENT_EXT]
    ON [dbo].[BLLICENSE]([BLGLOBALENTITYEXTENSIONID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IX_BLLICENSE_RECENT_LIC]
    ON [dbo].[BLLICENSE]([BLGLOBALENTITYEXTENSIONID] ASC, [BLLICENSETYPEID] ASC, [TAXYEAR] ASC, [BLLICENSEID] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IMPORT1]
    ON [dbo].[BLLICENSE]([LICENSENUMBER] ASC) WITH (FILLFACTOR = 80);


GO
CREATE NONCLUSTERED INDEX [IX_BLLICENSE_LASTCHANGEDON]
    ON [dbo].[BLLICENSE]([LASTCHANGEDON] ASC)
    INCLUDE([BLLICENSEID]);


GO
CREATE NONCLUSTERED INDEX [IX_BLLICENSE_BLLICENSEPARENTID]
    ON [dbo].[BLLICENSE]([BLLICENSEPARENTID] ASC);


GO

CREATE TRIGGER [TG_BLLICENSE_UPDATE_EVENT_QUEUE_ISSUED] ON BLLICENSE
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [BUSINESSLICENSEEVENTQUEUE]
		( 
			[BLLICENSEID],
			[BUSINESSLICENSEEVENTTYPEID],
			[EVENTSTATUSID],
			[CREATEDDATE],
			[BUSINESSLICENSELASTCHANGEDBY]
		)
		-- insert using a SELECT query (do not use IF EXISTS SELECT or SELECT into variables/use the variables) so that if a bulk update of BLLICENSE is made 
		--then we pick the correct BLLICENSE record to check the previous and new status
		SELECT 
			[INSERTED].BLLICENSEID,
			2, -- ID for 'Issued' event Type 
			1, -- ID for 'Pending' Event Status
			GETUTCDATE(),
			[INSERTED].LASTCHANGEDBY
		FROM [INSERTED]
		INNER JOIN [BLLICENSESTATUS] AS [NEWSTATUS] WITH(NOLOCK) ON [NEWSTATUS].[BLLICENSESTATUSID] = [INSERTED].[BLLICENSESTATUSID]
		INNER JOIN [DELETED] ON [DELETED].[BLLICENSEID] = [INSERTED].[BLLICENSEID]
		INNER JOIN [BLLICENSESTATUS] AS [OLDSTATUS] WITH(NOLOCK) ON [OLDSTATUS].[BLLICENSESTATUSID] = [DELETED].[BLLICENSESTATUSID]		
		INNER JOIN [dbo].[BLLICENSETYPE] ON [INSERTED].[BLLICENSETYPEID] = [BLLICENSETYPE].[BLLICENSETYPEID]
		WHERE
			-- check if the new status has issued flag
			[NEWSTATUS].[BLLICENSESTATUSSYSTEMID] = 1
			-- check if the old status of the does not have the issued flag, if it's already issued then do not insert a new record in the Event Queue table
		AND [OLDSTATUS].[BLLICENSESTATUSSYSTEMID] != 1
		AND [BLLICENSETYPE].[BLLICENSETYPEMODULEID] = 1 -- BUSINESS LICENCE
 
END
GO

CREATE TRIGGER [TG_BLLICENSE_INSERT_EVENT_QUEUE_EXPIRED] ON BLLICENSE
   AFTER INSERT
AS 
BEGIN

	SET NOCOUNT ON;

	BEGIN
		INSERT INTO [BUSINESSLICENSEEVENTQUEUE]
			( 
				[BLLICENSEID],
				[BUSINESSLICENSEEVENTTYPEID],
				[EVENTSTATUSID],
				[CREATEDDATE],
				[BUSINESSLICENSELASTCHANGEDBY]
			)
			-- check if the status is issued, if this coniditon is met then insert a new record in the Event Queue table
			SELECT
				[INSERTED].BLLICENSEID,
				3, -- ID for 'Expired' event Type 
				1, -- ID for 'Pending' Event Status
				GETUTCDATE(),
				[INSERTED].LASTCHANGEDBY
			FROM [INSERTED]
			INNER JOIN BLLICENSESTATUS WITH(NOLOCK) ON	[INSERTED].BLLICENSESTATUSID = BLLICENSESTATUS.BLLICENSESTATUSID
			INNER JOIN [dbo].[BLLICENSETYPE] ON [INSERTED].[BLLICENSETYPEID] = [BLLICENSETYPE].[BLLICENSETYPEID]
			WHERE 
				BLLICENSESTATUS.BLLICENSESTATUSSYSTEMID = 2 AND [BLLICENSETYPE].[BLLICENSETYPEMODULEID] = 1 -- BUSINESS LICENCE
	END
END
GO

CREATE TRIGGER [TG_BLLICENSE_INSERT_EVENT_QUEUE_RENEWED] ON BLLICENSE
   AFTER INSERT
AS 
BEGIN

	SET NOCOUNT ON;

	BEGIN
		INSERT INTO [BUSINESSLICENSEEVENTQUEUE]
			( 
				[BLLICENSEID],
				[BUSINESSLICENSEEVENTTYPEID],
				[EVENTSTATUSID],
				[CREATEDDATE],
				[BUSINESSLICENSELASTCHANGEDBY]
			)
			-- Insert a new record in the Event Queue table anytime a Business License is CREATEd (don't need to check the status)
			SELECT
				[INSERTED].BLLICENSEID,
				4, -- ID for 'Renewed' event Type 
				1, -- ID for 'Pending' Event Status
				GETUTCDATE(),
				[INSERTED].LASTCHANGEDBY
			FROM [INSERTED]
			INNER JOIN [dbo].[BLLICENSETYPE] ON [INSERTED].[BLLICENSETYPEID] = [BLLICENSETYPE].[BLLICENSETYPEID]
            WHERE BLLICENSEPARENTID IS NOT NULL AND [BLLICENSETYPE].[BLLICENSETYPEMODULEID] = 1 -- BUSINESS LICENCE
	END
END
GO

CREATE TRIGGER [TG_BLLICENSE_INSERT_EVENT_QUEUE_ISSUED] ON BLLICENSE
   AFTER INSERT
AS 
BEGIN

	SET NOCOUNT ON;

	BEGIN
		INSERT INTO [BUSINESSLICENSEEVENTQUEUE]
			( 
				[BLLICENSEID],
				[BUSINESSLICENSEEVENTTYPEID],
				[EVENTSTATUSID],
				[CREATEDDATE],
				[BUSINESSLICENSELASTCHANGEDBY]
			)
			-- check if the status is issued, if this coniditon is met then insert a new record in the Event Queue table
			SELECT
				[INSERTED].BLLICENSEID,
				2, -- ID for 'Issued' event Type 
				1, -- ID for 'Pending' Event Status
				GETUTCDATE(),
				[INSERTED].LASTCHANGEDBY
			FROM [INSERTED]
			INNER JOIN BLLICENSESTATUS WITH(NOLOCK) ON [INSERTED].[BLLICENSESTATUSID] = [BLLICENSESTATUS].[BLLICENSESTATUSID]			
			INNER JOIN [dbo].[BLLICENSETYPE] ON [INSERTED].BLLICENSETYPEID = [BLLICENSETYPE].[BLLICENSETYPEID]
			WHERE 
				BLLICENSESTATUS.BLLICENSESTATUSSYSTEMID = 1 AND [BLLICENSETYPE].[BLLICENSETYPEMODULEID] = 1 -- BUSINESS LICENCE
	END
END
GO

CREATE TRIGGER [TG_BLLICENSE_UPDATE_EVENT_QUEUE_EXPIRED] ON BLLICENSE
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [BUSINESSLICENSEEVENTQUEUE]
		( 
			[BLLICENSEID],
			[BUSINESSLICENSEEVENTTYPEID],
			[EVENTSTATUSID],
			[CREATEDDATE],
			[BUSINESSLICENSELASTCHANGEDBY]
		)
		-- insert using a SELECT query (do not use IF EXISTS SELECT or SELECT into variables/use the variables) so that if a bulk update of BLLICENSE is made 
		--then we pick the correct BLLICENSE record to check the previous and new status
		SELECT 
			[INSERTED].BLLICENSEID,
			3, -- ID for 'Expired' event Type 
			1, -- ID for 'Pending' Event Status
			GETUTCDATE(),
			[INSERTED].LASTCHANGEDBY
		FROM [INSERTED]
		INNER JOIN [BLLICENSESTATUS] AS [NEWSTATUS] WITH(NOLOCK) ON [NEWSTATUS].[BLLICENSESTATUSID] = [INSERTED].[BLLICENSESTATUSID]
		INNER JOIN [DELETED] ON [DELETED].[BLLICENSEID] = [INSERTED].[BLLICENSEID]
		INNER JOIN [BLLICENSESTATUS] AS [OLDSTATUS] WITH(NOLOCK) ON [OLDSTATUS].[BLLICENSESTATUSID] = [DELETED].[BLLICENSESTATUSID]	
		INNER JOIN [dbo].[BLLICENSETYPE] ON [INSERTED].[BLLICENSETYPEID] = [BLLICENSETYPE].[BLLICENSETYPEID]
		WHERE
			-- check if the new status has issued flag
			[NEWSTATUS].[BLLICENSESTATUSSYSTEMID] = 2
			-- check if the old status of the does not have the issued flag, if it's already issued then do not insert a new record in the Event Queue table
		AND [OLDSTATUS].[BLLICENSESTATUSSYSTEMID] != 2
		AND [BLLICENSETYPE].[BLLICENSETYPEMODULEID] = 1 -- BUSINESS LICENCE
 
END
GO

CREATE TRIGGER [TG_BLLICENSE_INSERT_EVENT_QUEUE_CREATED] ON BLLICENSE
   AFTER INSERT
AS 
BEGIN

	SET NOCOUNT ON;

	BEGIN
		INSERT INTO [BUSINESSLICENSEEVENTQUEUE]
			( 
				[BLLICENSEID],
				[BUSINESSLICENSEEVENTTYPEID],
				[EVENTSTATUSID],
				[CREATEDDATE],
				[BUSINESSLICENSELASTCHANGEDBY]
			)
			-- Insert a new record in the Event Queue table anytime a Business License is CREATEd (don't need to check the status)
			SELECT
				[INSERTED].BLLICENSEID,
				1, -- ID for 'CREATEd' event Type 
				1, -- ID for 'Pending' Event Status
				GETUTCDATE(),
				[INSERTED].LASTCHANGEDBY
			FROM [INSERTED]
			INNER JOIN [dbo].[BLLICENSETYPE] ON [INSERTED].BLLICENSETYPEID = [BLLICENSETYPE].[BLLICENSETYPEID]
				WHERE BLLICENSETYPE.BLLICENSETYPEMODULEID = 1 -- BUSINESS LICENCE
	END
END
GO


CREATE TRIGGER [TG_BLLICENSE_UPDATE_ELASTIC] ON  BLLICENSE
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
		[Inserted].[BLLICENSEID] ,
        'EnerGovBusiness.BusinessLicense.BusinessLicense' ,
        [Inserted].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted];

END
GO

CREATE TRIGGER [TG_BLLICENSE_INSERT_ELASTIC] ON  BLLICENSE
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
		[Inserted].[BLLICENSEID] ,
        'EnerGovBusiness.BusinessLicense.BusinessLicense' ,
        [Inserted].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        1 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted];

END
GO


CREATE TRIGGER [TG_BLLICENSE_DELETE_ELASTIC] ON  BLLICENSE
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
		[Deleted].[BLLICENSEID] ,
        'EnerGovBusiness.BusinessLicense.BusinessLicense' ,
        [Deleted].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        3 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Deleted];

END
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	Sets expiration date to 1/1/2999 on insert if the issue date is blank to remove ability to renew new licenses
-- =============================================
CREATE TRIGGER [dbo].[PMO_TRG_UPDATE_LICENSE_EXPIRATION]
   ON [dbo].[BLLICENSE] 
   AFTER INSERT
AS 

Declare @BLLICENSEID varchar(36)
Set @BLLICENSEID = (Select BLLICENSEID from inserted)

DECLARE @ISSUEDATE date
SET @ISSUEDATE = (SELECT ISSUEDDATE from inserted)

BEGIN
  BEGIN TRY
       -- SET NOCOUNT ON added to prevent extra result sets from
       -- interfering with SELECT statements.
       SET NOCOUNT ON;
       
    IF @ISSUEDATE is null or @ISSUEDATE =''
       BEGIN
       UPDATE BLLICENSE
       SET EXPIRATIONDATE = '1/1/2999', ROWVERSION = ROWVERSION + 1
       WHERE BLLICENSEID = @BLLICENSEID
       END

   END TRY
	  BEGIN CATCH
		 --
		 --
		 INSERT into GLOBALERRORDATABASE VALUES (newid(),'PMO_TRG_UPDATE_LICENSE_EXPIRATION', getdate(), @@ERROR, null)
		 --	
		 --
	  END CATCH


END

GO
DISABLE TRIGGER [dbo].[PMO_TRG_UPDATE_LICENSE_EXPIRATION]
    ON [dbo].[BLLICENSE];
