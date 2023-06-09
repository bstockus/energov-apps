﻿CREATE TABLE [dbo].[CACOMPUTEDFEE] (
    [CACOMPUTEDFEEID]    CHAR (36)       NOT NULL,
    [CAFEETEMPLATEFEEID] CHAR (36)       NOT NULL,
    [FEEDESCRIPTION]     NVARCHAR (MAX)  NOT NULL,
    [FEEORDER]           INT             NOT NULL,
    [ISMANUALLYADDED]    BIT             NOT NULL,
    [COMPUTEDAMOUNT]     MONEY           NOT NULL,
    [ISPROCESSED]        BIT             NOT NULL,
    [CASTATUSID]         INT             CONSTRAINT [DEF_CAComputedFee_StatusID] DEFAULT ((1)) NOT NULL,
    [AMOUNTPAIDTODATE]   MONEY           CONSTRAINT [DF_CAComputedFee_Paid] DEFAULT ((0)) NOT NULL,
    [ROWVERSION]         INT             CONSTRAINT [DF_ComputedFee_RowVer] DEFAULT ((1)) NOT NULL,
    [LASTCHANGEDON]      DATETIME        CONSTRAINT [DF_ComputedFee_Changed] DEFAULT (getdate()) NOT NULL,
    [LASTCHANGEDBY]      CHAR (36)       NOT NULL,
    [ISDELETED]          BIT             CONSTRAINT [DF_CAComputedFee_IsDeleted] DEFAULT ((0)) NOT NULL,
    [INPUTVALUE]         DECIMAL (20, 4) NULL,
    [FEEPRIORITY]        INT             CONSTRAINT [DF_CAComputedFee_Priority] DEFAULT ((0)) NOT NULL,
    [FEENUMBER]          NVARCHAR (500)  NULL,
    [CREATEDBY]          CHAR (36)       NOT NULL,
    [CREATEDON]          DATETIME        CONSTRAINT [DF_CAComputedFee_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [FEENAME]            NVARCHAR (50)   NOT NULL,
    [BASEAMOUNT]         MONEY           CONSTRAINT [DF_CAComputedFee_Base] DEFAULT ((0)) NOT NULL,
    [NOTES]              NVARCHAR (MAX)  NULL,
    [DISPLAYINPUTVALUE]  MONEY           CONSTRAINT [DF_CAComputedFee_DisplayInputValue] DEFAULT ((0)) NOT NULL,
    [ISONLINEADDED]      BIT             CONSTRAINT [DF_CACOMPUTEDFEE_ISONLINEADDED] DEFAULT ((0)) NOT NULL,
    [TIMETRACKINGID]     CHAR (36)       NULL,
    [WFACTIONID]         CHAR (36)       NULL,
    [TOTALFEEBASEDID]    CHAR (36)       NULL,
    [CPIAMOUNT]          DECIMAL (20, 4) NULL,
    [FEEPRORATIONAMOUNT] DECIMAL (20, 4) NULL,
    [FEEPRORATIONRATE]   DECIMAL (20, 4) NULL,
    [CREDITAMOUNT]       DECIMAL (20, 4) NULL,
    [ISRENEWALFEE]       BIT             NULL,
    CONSTRAINT [PK_CAComputedFee] PRIMARY KEY NONCLUSTERED ([CACOMPUTEDFEEID] ASC) WITH (FILLFACTOR = 80),
    CONSTRAINT [FK_CAComputedFee_Status] FOREIGN KEY ([CASTATUSID]) REFERENCES [dbo].[CASTATUS] ([CASTATUSID]),
    CONSTRAINT [FK_CaComputedFee_TimeTracking] FOREIGN KEY ([TIMETRACKINGID]) REFERENCES [dbo].[TIMETRACKING] ([TIMETRACKINGID]),
    CONSTRAINT [FK_ComputedFee_TemplateFee] FOREIGN KEY ([CAFEETEMPLATEFEEID]) REFERENCES [dbo].[CAFEETEMPLATEFEE] ([CAFEETEMPLATEFEEID]),
    CONSTRAINT [FK_ComputedFee_Users] FOREIGN KEY ([LASTCHANGEDBY]) REFERENCES [dbo].[USERS] ([SUSERGUID])
);


GO
CREATE NONCLUSTERED INDEX [IX_CACOMPUTEDFEE_STATUS]
    ON [dbo].[CACOMPUTEDFEE]([CACOMPUTEDFEEID] ASC, [CASTATUSID] ASC)
    INCLUDE([COMPUTEDAMOUNT], [AMOUNTPAIDTODATE]);


GO
CREATE NONCLUSTERED INDEX [IX_CACOMPUTEDFEE_LASTCHANGEDON]
    ON [dbo].[CACOMPUTEDFEE]([LASTCHANGEDON] ASC)
    INCLUDE([CACOMPUTEDFEEID]);


GO
CREATE NONCLUSTERED INDEX [IX_CACOMPUTEDFEE_TEMPLATEFEEID]
    ON [dbo].[CACOMPUTEDFEE]([CAFEETEMPLATEFEEID] ASC);


GO


CREATE TRIGGER [TG_CACOMPUTEDFEE_INSERTUPDATE_ELASTIC_INVOICE] ON  [CACOMPUTEDFEE]
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
	JOIN [CAINVOICEFEE] AS [CIF] WITH (NOLOCK) ON [CIF].[CACOMPUTEDFEEID] = [Inserted].[CACOMPUTEDFEEID]
	JOIN [CAINVOICE] AS [CI] WITH (NOLOCK) ON [CI].[CAINVOICEID] = [CIF].[CAINVOICEID];

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
	JOIN [CAINVOICEFEE] AS [CIF] WITH (NOLOCK) ON [CIF].[CACOMPUTEDFEEID] = [Inserted].[CACOMPUTEDFEEID]
	JOIN [CAINVOICE] AS [CI] WITH (NOLOCK) ON [CI].[CAINVOICEID] = [CIF].[CAINVOICEID];

END
GO

CREATE TRIGGER [TG_CACOMPUTEDFEE_DELETE_ELASTIC_INVOICE] ON  [CACOMPUTEDFEE]
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
	JOIN [CAINVOICEFEE] AS [CIF] WITH (NOLOCK) ON [CIF].[CACOMPUTEDFEEID] = [Deleted].[CACOMPUTEDFEEID]
	JOIN [CAINVOICE] AS [CI] WITH (NOLOCK) ON [CI].[CAINVOICEID] = [CIF].[CAINVOICEID];

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
	JOIN [CAINVOICEFEE] AS [CIF] WITH (NOLOCK) ON [CIF].[CACOMPUTEDFEEID] = [Deleted].[CACOMPUTEDFEEID]
	JOIN [CAINVOICE] AS [CI] WITH (NOLOCK) ON [CI].[CAINVOICEID] = [CIF].[CAINVOICEID];

END
GO

CREATE TRIGGER [TG_CACOMPUTEDFEE_INSERT_ELASTIC_FEE] ON  CACOMPUTEDFEE
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
		[Inserted].[CACOMPUTEDFEEID] ,
        'EnerGovBusiness.Cashier.Fee' ,
        [Inserted].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        1 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted];

END
GO

CREATE TRIGGER [TG_CACOMPUTEDFEE_UPDATE_ELASTIC_FEE] ON  CACOMPUTEDFEE
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
		[Inserted].[CACOMPUTEDFEEID] ,
        'EnerGovBusiness.Cashier.Fee' ,
        [Inserted].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        2 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Inserted];

END
GO

CREATE TRIGGER [TG_CMCODECASE_INSERTUPDATE_EVENT_QUEUE_FEESPAIDINFULL]
ON CACOMPUTEDFEE
AFTER INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON;
       
    DECLARE 
	@codeCaseIds RecordIDs, 
	@LastChangedBy CHAR(36)

	--Get any codecases linked to fees that have been paid in full in this transaction.
	INSERT INTO @codeCaseIds (RECORDID)
	SELECT 
		DISTINCT ccf.CMCODECASEID
	FROM 
		[INSERTED] New
	INNER JOIN CMCODECASEFEE ccf WITH (NOLOCK) ON ccf.CACOMPUTEDFEEID = New.CACOMPUTEDFEEID
	LEFT OUTER JOIN [DELETED] Old ON New.CACOMPUTEDFEEID = Old.CACOMPUTEDFEEID
	WHERE New.CASTATUSID = 4
	AND COALESCE(Old.CASTATUSID, 0) <> New.CASTATUSID

	--Exit trigger if no codecase fees were paid in full
	IF (SELECT COUNT(1) FROM @codeCaseIds) = 0
		RETURN
	ELSE
		BEGIN
			SELECT TOP 1 @LastChangedBy = LASTCHANGEDBY FROM [INSERTED]
			
			--Stage codecase event for 'Paid in Full' for each involved codecase that has no unpaid fees left
			INSERT INTO [CODECASEEVENTQUEUE]
				(
				[CMCODECASEID],
				[CASENUMBER],
				[CODECASEEVENTTYPEID],
				[EVENTSTATUSID],
				[CREATEDDATE],
				[CODECASELASTCHANGEDBY]
				)
			SELECT
				RecordID,
				CASENUMBER,
				4,
				1,
				GETUTCDATE(),
				@LastChangedBy
			FROM @codeCaseIds c
			JOIN CMCODECASE WITH (NOLOCK) ON CMCODECASE.CMCODECASEID = c.RECORDID
			WHERE
			--Only if balance due on the case is zero
			(
				SELECT COALESCE(SUM(COMPUTEDAMOUNT - AMOUNTPAIDTODATE), 0.00)
				FROM CMCODECASEFEE WITH (NOLOCK)
				JOIN CACOMPUTEDFEE WITH (NOLOCK) ON CMCODECASEFEE.CACOMPUTEDFEEID = CACOMPUTEDFEE.CACOMPUTEDFEEID
				WHERE CMCODECASEFEE.CMCODECASEID = c.RecordID
				AND CACOMPUTEDFEE.CASTATUSID IN (1, 2, 3, 6, 7, 8)
			) = 0.00
			AND
			--Filter out any events of this type that are not processed (avoid duplicates)
			NOT EXISTS
			(
				SELECT 1 FROM [CODECASEEVENTQUEUE] WITH (NOLOCK) WHERE CODECASEEVENTTYPEID = 4 AND PROCESSEDDATE IS NULL AND CMCODECASEID = c.RECORDID
			)

		END

END
GO
DISABLE TRIGGER [dbo].[TG_CMCODECASE_INSERTUPDATE_EVENT_QUEUE_FEESPAIDINFULL]
    ON [dbo].[CACOMPUTEDFEE];


GO

CREATE TRIGGER [TG_PMPERMIT_INSERTUPDATE_EVENT_QUEUE_FEESPAIDINFULL]
ON CACOMPUTEDFEE
AFTER INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON;
       
    DECLARE @permitsAffected RecordIDs, @LastChangedBy CHAR(36)

	--Get any permits linked to fees that have been paid in full in this transaction.
	INSERT INTO @permitsAffected (RecordID)
	SELECT 
		DISTINCT ppf.PMPERMITID
	FROM 
		[INSERTED] New
	INNER JOIN PMPERMITFEE ppf WITH (NOLOCK) ON ppf.CACOMPUTEDFEEID = New.CACOMPUTEDFEEID
	LEFT OUTER JOIN [DELETED] Old ON New.CACOMPUTEDFEEID = Old.CACOMPUTEDFEEID
	WHERE New.CASTATUSID = 4
	AND COALESCE(Old.CASTATUSID, 0) <> New.CASTATUSID

	--Exit trigger if no permit fees were paid in full
	IF (SELECT COUNT(1) FROM @permitsAffected) = 0
		RETURN
	ELSE
		BEGIN
			SELECT TOP 1 @LastChangedBy = LASTCHANGEDBY FROM [INSERTED]
			
			--Stage permit event for 'Paid in Full' for each involved permit that has no unpaid fees left
			INSERT INTO [PERMITEVENTQUEUE]
				(
				[PMPERMITID],
				[PERMITEVENTTYPEID],
				[EVENTSTATUSID],
				[CREATEDDATE],
				[PERMITLASTCHANGEDBY]
				)
			SELECT
				RecordID,
				8,
				1,
				GETUTCDATE(),
				@LastChangedBy
			FROM @permitsAffected pa
			WHERE
			--Only if balance due on the permit is zero
			(
				SELECT COALESCE(SUM(COMPUTEDAMOUNT - AMOUNTPAIDTODATE), 0.00)
				FROM PMPERMITFEE WITH (NOLOCK)
				JOIN CACOMPUTEDFEE WITH (NOLOCK)ON PMPERMITFEE.CACOMPUTEDFEEID = CACOMPUTEDFEE.CACOMPUTEDFEEID
				WHERE PMPERMITFEE.PMPERMITID = pa.RecordID
				AND CACOMPUTEDFEE.CASTATUSID IN (1, 2, 3, 6, 7, 8)
			) = 0.00
			AND
			--Filter out any events of this type that are not processed (avoid duplicates)
			NOT EXISTS
			(
				SELECT 1 FROM [PERMITEVENTQUEUE] WITH (NOLOCK) WHERE PERMITEVENTTYPEID = 8 AND PROCESSEDDATE IS NULL AND PMPERMITID = pa.RECORDID
			)

		END

END
GO
DISABLE TRIGGER [dbo].[TG_PMPERMIT_INSERTUPDATE_EVENT_QUEUE_FEESPAIDINFULL]
    ON [dbo].[CACOMPUTEDFEE];


GO


CREATE TRIGGER [TG_CMVIOLATION_INSERTUPDATE_EVENT_QUEUE_FEESPAIDINFULL]
ON CACOMPUTEDFEE
AFTER INSERT, UPDATE
AS
BEGIN
	SET NOCOUNT ON;
       
    DECLARE 
	@violationIds RecordIDs, 
	@LastChangedBy CHAR(36)

	--Get any violations linked to fees that have been paid in full in this transaction.
	INSERT INTO @violationIds (RecordID)
	SELECT 
		DISTINCT cvf.CMVIOLATIONID
	FROM 
		[INSERTED] New
	JOIN [CMVIOLATIONFEE] cvf WITH (NOLOCK) ON cvf.CACOMPUTEDFEEID = New.CACOMPUTEDFEEID
	LEFT JOIN [DELETED] Old ON New.CACOMPUTEDFEEID = Old.CACOMPUTEDFEEID
	WHERE New.CASTATUSID = 4
	AND COALESCE(Old.CASTATUSID, 0) <> New.CASTATUSID

	--Exit trigger if no violation fees were paid in full
	IF (SELECT COUNT(1) FROM @violationIds) = 0
		RETURN
	ELSE
		BEGIN
			SELECT TOP 1 @LastChangedBy = LASTCHANGEDBY FROM [INSERTED]
			
			--Stage codecase event for 'Paid in Full' for each involved violation that has no unpaid fees left
			INSERT INTO [CODECASEEVENTQUEUE]
				(
				[CMCODECASEID],
				[CASENUMBER],
				[CODECASEEVENTTYPEID],
				[EVENTSTATUSID],
				[CREATEDDATE],
				[CODECASELASTCHANGEDBY],
				[CMVIOLATIONID]
				)
			SELECT
				[CMCODECASE].[CMCODECASEID],
				[CMCODECASE].[CASENUMBER],
				6,
				1,
				GETUTCDATE(),
				@LastChangedBy,
				v.RECORDID
			FROM @violationIds v
			JOIN [CMVIOLATION] WITH (NOLOCK) ON [CMVIOLATION].[CMVIOLATIONID] = v.RECORDID
			JOIN [CMCODEWFACTIONSTEP] WITH (NOLOCK) ON [CMVIOLATION].[CMCODEWFACTIONID] = [CMCODEWFACTIONSTEP].[CMCODEWFACTIONSTEPID]
			JOIN [CMCODEWFSTEP] WITH (NOLOCK) ON [CMCODEWFACTIONSTEP].[CMCODEWFSTEPID] = [CMCODEWFSTEP].[CMCODEWFSTEPID]
			JOIN [CMCODECASE] WITH (NOLOCK) ON [CMCODEWFSTEP].[CMCODECASEID] = [CMCODECASE].[CMCODECASEID]
			WHERE
			--Only if balance due on the case is zero
			(
				SELECT COALESCE(SUM(COMPUTEDAMOUNT - AMOUNTPAIDTODATE), 0.00)
				FROM CMVIOLATIONFEE WITH (NOLOCK)
				JOIN CACOMPUTEDFEE WITH (NOLOCK) ON [CMVIOLATIONFEE].[CACOMPUTEDFEEID] = [CACOMPUTEDFEE].[CACOMPUTEDFEEID]
				WHERE CMVIOLATIONFEE.CMVIOLATIONID = v.RECORDID
				AND CACOMPUTEDFEE.CASTATUSID IN (1, 2, 3, 6, 7, 8)
			) = 0.00
			AND
			--Filter out any events of this type that are not processed (avoid duplicates)
			NOT EXISTS
			(
				SELECT 1 FROM [CODECASEEVENTQUEUE] WITH (NOLOCK) WHERE [CODECASEEVENTTYPEID] = 6 AND [PROCESSEDDATE] IS NULL AND [CMVIOLATIONID] = v.RECORDID
			)

		END

END
GO
DISABLE TRIGGER [dbo].[TG_CMVIOLATION_INSERTUPDATE_EVENT_QUEUE_FEESPAIDINFULL]
    ON [dbo].[CACOMPUTEDFEE];


GO

CREATE TRIGGER [TG_CACOMPUTEDFEE_DELETE_ELASTIC_FEE] ON  CACOMPUTEDFEE
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
		[Deleted].[CACOMPUTEDFEEID] ,
        'EnerGovBusiness.Cashier.Fee' ,
        [Deleted].[ROWVERSION] ,
        GETDATE() ,
        NULL ,
        3 ,
        (SELECT STRINGVALUE FROM SETTINGS WITH (NOLOCK) WHERE NAME = 'ServiceBusTenant')
	FROM [Deleted];

END