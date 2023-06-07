--Create stored procedure to gather and return a snapshot of client configuration and key data points.
--This information will be compiled and sent to appinsights.
--Then, it would be consumed by EnerGov support. 
--This utility procedure is only for making raw data available for analysis. 
--
--Data Sets Returned:
--1. Random items of concern (item name with value)
--2. EnerGov version history (version number with upgrade date)
--3. EnerGov Windows Service Tasks (task name with schedule)
--4. System and CAP settings (setting name with value)

--As of 2020.1, that procedure will be called through a windows service task, which can be setup on a schedule to post the data to appinsights.

CREATE PROCEDURE [common].[USP_GET_SUPPORT_SNAPSHOT_DATA]
AS
BEGIN
	
	--Constants for the 4 different types of snapshot data items we gather.
	DECLARE 
	@SnapshotItemTypeOther VARCHAR(50) = 'Other',
	@SnapshotItemTypeSystemSetting VARCHAR(50) = 'Setting',
	@SnapshotItemTypeReleaseHistory VARCHAR(50) = 'Upgrade',
	@SnapshotItemTypeServiceTask VARCHAR(50) = 'V2Task';

	DECLARE @systemSupportSnapshotDataTable TABLE
	(
		DataItemType	VARCHAR(50),
		DataItemName	VARCHAR(100) NOT NULL,
		DataItemValue	VARCHAR(MAX) NULL
	);


	--Gatering random data from various sources

	INSERT INTO @systemSupportSnapshotDataTable (DataItemType, DataItemName, DataItemValue)

	select @SnapshotItemTypeOther, 'DecisionEngineLastUsed', CONVERT(varchar(20), MAX(ENTEREDON), 120) from DECISIONENTRY
	UNION ALL
	select @SnapshotItemTypeOther, 'PortalLastAppDate', CONVERT(varchar(20), MAX(AppliedDates.LAST_USED), 120) 
	FROM 
	(
		SELECT CONVERT(varchar(50), MAX(APPLYDATE), 120) AS LAST_USED FROM PMPERMIT WHERE ISAPPLIEDONLINE = 1
		UNION ALL 
		SELECT CONVERT(varchar(50), MAX(APPLICATIONDATE), 120) AS LAST_USED FROM PLPLAN WHERE ISAPPLIEDONLINE = 1
		UNION ALL 
		SELECT CONVERT(varchar(50), MAX(APPLIEDDATE), 120) AS LAST_USED FROM BLLICENSE WHERE ISAPPLIEDONLINE = 1
		UNION ALL 
		SELECT CONVERT(varchar(50), MAX(APPLIEDDATE), 120) AS LAST_USED FROM ILLICENSE WHERE ISAPPLIEDONLINE = 1
	) AppliedDates
	WHERE AppliedDates.LAST_USED < GETDATE()
	UNION ALL
	select @SnapshotItemTypeOther, 'EReviewsUsed', COALESCE((SELECT TOP 1 '1' from ERPROJECTFILE), '0') 
	where exists (select 1 from SETTINGS where [NAME] ='EReviewEnable' and BITVALUE = 1)
	UNION ALL
	select @SnapshotItemTypeOther, 'LastEReviewsUpload', CONVERT(varchar(20), MAX(CREATEDATE), 120) from ERPROJECTFILE
	where exists (select 1 from SETTINGS where [NAME] ='EReviewEnable' and BITVALUE = 1)
	UNION ALL
	select @SnapshotItemTypeOther, 'PermitModuleUsed', COALESCE((SELECT TOP 1 '1' from PMPERMIT WHERE LASTCHANGEDON > DATEADD(YEAR, -1, GETDATE())), '0') 
	UNION ALL
	select @SnapshotItemTypeOther, 'PlanModuleUsed', COALESCE((SELECT TOP 1 '1' from PLPLAN WHERE LASTCHANGEDON > DATEADD(YEAR, -1, GETDATE())), '0') 
	UNION ALL
	select @SnapshotItemTypeOther, 'BusinessLicenseModuleUsed', COALESCE((SELECT TOP 1 '1' from BLLICENSE WHERE LASTCHANGEDON > DATEADD(YEAR, -1, GETDATE())), '0') 
	UNION ALL
	select @SnapshotItemTypeOther, 'ProLicenseModuleUsed', COALESCE((SELECT TOP 1 '1' from ILLICENSE WHERE LASTCHANGEDON > DATEADD(YEAR, -1, GETDATE())), '0') 
	UNION ALL
	select @SnapshotItemTypeOther, 'CodeModuleUsed', COALESCE((SELECT TOP 1 '1' from CMCODECASE WHERE LASTCHANGEDON > DATEADD(YEAR, -1, GETDATE())), '0') 
	UNION ALL
	select @SnapshotItemTypeOther, 'RequestModuleUsed', COALESCE((SELECT TOP 1 '1' from CITIZENREQUEST WHERE LASTCHANGEDON > DATEADD(YEAR, -1, GETDATE())), '0') 
	UNION ALL
	select @SnapshotItemTypeOther, 'LandlordLicenseModuleUsed', COALESCE((SELECT TOP 1 '1' from RPLANDLORDLICENSE WHERE LASTCHANGEDON > DATEADD(YEAR, -1, GETDATE())), '0') 
	UNION ALL
	select @SnapshotItemTypeOther, 'TaxRemittanceModuleUsed', COALESCE((SELECT TOP 1 '1' from TXREMITTANCE WHERE REPORTEDDATE > DATEADD(YEAR, -1, GETDATE())), '0') 
	UNION ALL
	select @SnapshotItemTypeOther, 'ProjectModuleUsed', COALESCE((SELECT TOP 1 '1' from PRPROJECT WHERE LASTCHANGEDON > DATEADD(YEAR, -1, GETDATE())), '0') 
	UNION ALL
	select @SnapshotItemTypeOther, 'EnerGovDbVersion', STRINGVALUE  from SETTINGS where [NAME] = 'EnerGovEnterpriseServerBuild'
	UNION ALL
	select @SnapshotItemTypeOther, 'ObjectCacheMB', CAST(CAST(SUM(LEN(OBJECTCACHE.OBJECTDATA)) / 1024.0 / 1024.0 as INT) as varchar(20))  FROM OBJECTCACHE
	UNION ALL
	select @SnapshotItemTypeOther, 'ActiveStaffUsers', CAST(COUNT(1) as varchar(10)) from USERS where BACTIVE = 1 and SROLEID is not null
	UNION ALL
	select @SnapshotItemTypeOther, 'ActiveOnlineUsers', CAST(COUNT(1) as varchar(10)) from USERS where BACTIVE = 1 and SROLEID is null and LEN(id) = 36
	UNION ALL
	select @SnapshotItemTypeOther, 'TylerCashieringUsed', COALESCE((SELECT TOP 1 '1' from CATRANSACTIONPAYMENT 
	where PAYMENTNOTE like '%Tyler Cashiering%' AND LASTCHANGEDON > DATEADD(YEAR, -1, GETDATE())), '0') 
	UNION ALL
	select @SnapshotItemTypeOther, 'AppraisalIntegrationEnabled', COALESCE((SELECT TOP 1 '1' from SETTINGS WHERE [NAME] = 'AppraisalTaxIntegrationEnable' and BITVALUE = 1), '0') 
	UNION ALL
	select @SnapshotItemTypeOther, 'LandRecordsIntegrationEnabled', COALESCE((SELECT TOP 1 '1' from SETTINGS WHERE [NAME] = 'LandRecordsIntegrationEnable' and BITVALUE = 1), '0') 
	UNION ALL
	select @SnapshotItemTypeOther, 'LastTcmProcessed', COALESCE(CONVERT(varchar(20), MAX(PROCESSEDDATE), 120), '') from TCMPOSTPROCESS
	UNION ALL
	select @SnapshotItemTypeOther, 'TCMIntegrationEnabled', COALESCE(
		(SELECT TOP 1 '1' from SETTINGS 
			WHERE ([NAME] = 'EnableTCMIntegration' and BITVALUE = 1) 
			OR ([NAME] = 'TCMDLL' AND STRINGVALUE = 'TylerContentManagement.Integration')), '0') 
	UNION ALL
	select @SnapshotItemTypeOther, 'ThirdPartyDocManagementTool', CASE WHEN STRINGVALUE = 'TYLERCONTENTMANAGEMENT.INTEGRATION' THEN '' ELSE STRINGVALUE END FROM SETTINGS WHERE [NAME] = 'TCMDLL'
	UNION ALL
	select @SnapshotItemTypeOther, 'TylerCodeIncidentMgmtUsed', COALESCE((SELECT TOP 1 '1' from CMCODECASENOTE WHERE [TEXT] LIKE '%Source: Tyler Incident Management%' AND CREATEDDATE > DATEADD(YEAR, -1, GETDATE())), '0') 
	UNION ALL
	select @SnapshotItemTypeOther, 'TylerCrmIncidentMgmtUsed', COALESCE((SELECT TOP 1 '1' from CITIZENREQUESTNOTE WHERE [TEXT] LIKE '%Source: Tyler Incident Management%' AND CREATEDDATE > DATEADD(YEAR, -1, GETDATE())), '0') 
	UNION ALL
	select @SnapshotItemTypeOther, 'PMMIntegrationEnabled', COALESCE((SELECT TOP 1 '1' from SETTINGS WHERE [NAME] = 'EnablePMMIntegration' and BITVALUE = 1), '0') 
	UNION ALL
	select @SnapshotItemTypeOther, 'GlobalErrorCountTotal', CAST(COUNT(1) as varchar(10)) from GLOBALERROR
	UNION ALL
	select @SnapshotItemTypeOther, 'GlobalErrorCount24hr', CAST(COUNT(1) as varchar(10)) from GLOBALERROR where LOGDATE > DATEADD(DAY, -1, GETDATE())
	UNION ALL
	select @SnapshotItemTypeOther, 'UnsentEmailQueueCountTotal', CAST(COUNT(1) as varchar(10)) from EMAILQUEUE WHERE DATESENT IS NULL
	UNION ALL
	select @SnapshotItemTypeOther, 'ElasticQueueCountTotal', CAST(COUNT(1) as varchar(10)) from ELASTICSEARCHOBJECT
	UNION ALL
	select @SnapshotItemTypeOther, 'ElasticQueueCount24hr', CAST(COUNT(1) as varchar(10)) from ELASTICSEARCHOBJECT WHERE CREATEDATE > DATEADD(DAY, -1, GETDATE())
	UNION ALL
	select @SnapshotItemTypeOther, 'ElasticQueueCountUnprocessed', CAST(COUNT(1) as varchar(10)) from ELASTICSEARCHOBJECT WHERE PROCESSEDDATE IS NULL
	UNION ALL
	select @SnapshotItemTypeOther, 'WorkflowActionPostProcessCountTotal', CAST(COUNT(1) as varchar(10)) from WORKFLOWACTIONPOSTPROCESS
	UNION ALL
	select @SnapshotItemTypeOther, 'WorkflowActionPostProcessCount24hr', CAST(COUNT(1) as varchar(10)) from WORKFLOWACTIONPOSTPROCESS WHERE CREATEDATE > DATEADD(DAY, -1, GETDATE())
	UNION ALL
	select @SnapshotItemTypeOther, 'WorkflowActionPostProcessCountUnprocessed', CAST(COUNT(1) as varchar(10)) from WORKFLOWACTIONPOSTPROCESS WHERE PROCESSEDDATE IS NULL
	UNION ALL
	select @SnapshotItemTypeOther, 'WorkflowPostProcessCountTotal', CAST(COUNT(1) as varchar(10)) from WORKFLOWPOSTPROCESS
	UNION ALL
	select @SnapshotItemTypeOther, 'WorkflowPostProcessCount24hr', CAST(COUNT(1) as varchar(10)) from WORKFLOWPOSTPROCESS WHERE CREATEDATE > DATEADD(DAY, -1, GETDATE())
	UNION ALL
	select @SnapshotItemTypeOther, 'WorkflowPostProcessCountUnprocessed', CAST(COUNT(1) as varchar(10)) from WORKFLOWPOSTPROCESS WHERE PROCESSEDDATE IS NULL
	UNION ALL
	select @SnapshotItemTypeOther, 'GISHistoryQueueCountTotal', CAST(COUNT(1) as varchar(10)) from GISHISTORYQUEUE
	UNION ALL
	select @SnapshotItemTypeOther, 'GISHistoryQueueCountUnprocessed', CAST(COUNT(1) as varchar(10)) from GISHISTORYQUEUE WHERE PROCESSEDDATE IS NULL
	UNION ALL
	select @SnapshotItemTypeOther, 'GISHistoryQueueCount24hr', CAST(COUNT(1) as varchar(10)) from GISHISTORYQUEUE WHERE CREATEDATE > DATEADD(DAY, -1, GETDATE())
	UNION ALL
	select @SnapshotItemTypeOther, 'RecordChangeQueueCountTotal', CAST(COUNT(1) as varchar(10)) from RECORDCHANGETRACKQUEUE
	UNION ALL
	select @SnapshotItemTypeOther, 'RecordChangeQueueCountUnprocessed', CAST(COUNT(1) as varchar(10)) from RECORDCHANGETRACKQUEUE WHERE PROCESSEDDATE IS NULL
	UNION ALL
	select @SnapshotItemTypeOther, 'RecordChangeQueueCount24hr', CAST(COUNT(1) as varchar(10)) from RECORDCHANGETRACKQUEUE WHERE CREATEDATE > DATEADD(DAY, -1, GETDATE())
	UNION ALL
	select @SnapshotItemTypeOther, 'NewEReviewsInUse', COALESCE((SELECT TOP 1 '1' from ERENTITYSESSION), '0') 
	UNION ALL
	select @SnapshotItemTypeOther, 'FinanceIntegrationActiveCount', CAST(COUNT(1) as varchar(10))  
	from CAFINANCIALINTEGRATIONSETUP cfis JOIN CAFINANCIALINTEGRATIONTYPE cfit ON cfis.CAFINANCIALINTEGRATIONTYPEID = cfit.CAFINANCIALINTEGRATIONTYPEID
	WHERE cfis.ISACTIVE = 1

	--Batch Processing Integration (NEW, SUPPORTS MULTI JURISDICTION)
	DECLARE 
	@financeIntegrationName varchar(100),
	@miscBatch bit,
	@accountsPayableBatch bit,
	@accountsReceivableBatch bit,
	@externalExportBatch bit,
	@financeServiceUrl varchar(200),
	@financeLastChangedOn datetime,
	@integrationCounter int;

	DECLARE financeIntegrationsCursor CURSOR FAST_FORWARD READ_ONLY
	FOR
	select cfit.[NAME], ENABLEGL, ENABLEAP, ENABLEAR, ENABLEEX, WEBSERVICEURL, cfis.LASTCHANGEDON, ROW_NUMBER() OVER (ORDER BY ISDEFAULT DESC)
	from CAFINANCIALINTEGRATIONSETUP cfis JOIN CAFINANCIALINTEGRATIONTYPE cfit ON cfis.CAFINANCIALINTEGRATIONTYPEID = cfit.CAFINANCIALINTEGRATIONTYPEID
	WHERE cfis.ISACTIVE = 1
	
	OPEN financeIntegrationsCursor
	FETCH NEXT FROM financeIntegrationsCursor INTO 
		@financeIntegrationName, 
		@miscBatch, 
		@accountsPayableBatch, 
		@accountsReceivableBatch, 
		@externalExportBatch, 
		@financeServiceUrl, 
		@financeLastChangedOn, 
		@integrationCounter; 
	WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO @systemSupportSnapshotDataTable (DataItemType, DataItemName, DataItemValue)
			select @SnapshotItemTypeOther, 'FinanceIntegrationName-' + CAST(@integrationCounter as varchar(5)), @financeIntegrationName
			UNION ALL
			select @SnapshotItemTypeOther, 'FinanceIntegrationMSCEnabled-' + CAST(@integrationCounter as varchar(5)), CASE WHEN @miscBatch = 1 THEN '1' ELSE '0' END
			UNION ALL
			select @SnapshotItemTypeOther, 'FinanceIntegrationAPEnabled-' + CAST(@integrationCounter as varchar(5)), CASE WHEN @accountsPayableBatch = 1 THEN '1' ELSE '0' END
			UNION ALL
			select @SnapshotItemTypeOther, 'FinanceIntegrationAREnabled-' + CAST(@integrationCounter as varchar(5)), CASE WHEN @accountsReceivableBatch = 1 THEN '1' ELSE '0' END
			UNION ALL
			select @SnapshotItemTypeOther, 'FinanceIntegrationEXEnabled-' + CAST(@integrationCounter as varchar(5)), CASE WHEN @externalExportBatch = 1 THEN '1' ELSE '0' END
			UNION ALL
			select @SnapshotItemTypeOther, 'FinanceIntegrationURL-' + CAST(@integrationCounter as varchar(5)), @financeServiceUrl
			UNION ALL
			select @SnapshotItemTypeOther, 'FinanceIntegrationChanged-' + CAST(@integrationCounter as varchar(5)), COALESCE(CONVERT(varchar(50), @financeLastChangedOn, 120), '')
				
			FETCH NEXT FROM financeIntegrationsCursor INTO 
				@financeIntegrationName, 
				@miscBatch, 
				@accountsPayableBatch, 
				@accountsReceivableBatch, 
				@externalExportBatch, 
				@financeServiceUrl, 
				@financeLastChangedOn, 
				@integrationCounter; 
		END;
				
	CLOSE financeIntegrationsCursor
	DEALLOCATE financeIntegrationsCursor
	


	--Get Release History
	INSERT INTO @systemSupportSnapshotDataTable (DataItemType, DataItemName, DataItemValue)
	select TOP 5 @SnapshotItemTypeReleaseHistory, VERSIONCHANGEDTO [DataItemName], CHANGEDATE [DataItemValue] from RELEASEHISTORY where LEN(COALESCE(VERSIONCHANGEDTO, '')) > 0 order by CHANGEDATE DESC


	--Get Windows Service v2 Tasks Enabled
	INSERT INTO @systemSupportSnapshotDataTable (DataItemType, DataItemName, DataItemValue)
	select @SnapshotItemTypeServiceTask, wst.[NAME] [DataItemName], js.[NAME] [DataItemValue] 
	from WINDOWSSERVICETASK wst LEFT JOIN JOBSCHEDULE js on js.JOBSCHEDULEID = wst.JOBSCHEDULEID where ISENABLED = 1 and ISREADY = 1


	--System Settings, Including CAP Settings
	INSERT INTO @systemSupportSnapshotDataTable (DataItemType, DataItemName, DataItemValue)
	SELECT @SnapshotItemTypeSystemSetting, [NAME] [DataItemName], COALESCE(CAST(INTVALUE as VARCHAR(10)), STRINGVALUE, COALESCE(CAST(BITVALUE as CHAR(1)), '')) [DataItemValue] FROM SETTINGS
	UNION ALL
	SELECT @SnapshotItemTypeSystemSetting, [NAME] [DataItemName], COALESCE(CAST(INTVALUE as VARCHAR(10)), STRINGVALUE, COALESCE(CAST(BITVALUE as CHAR(1)), '')) [DataItemValue] FROM CAPSETTING



	-----------------------------------------------------
	--CSS SECTION (nice-to-have item that could be included in future releases)
	--	IF THE CLIENT HAS CSS, YOU CAN RETRIEVE SOME INFO FROM THE CSS DB.
	--	YOU WOULD HAVE TO UNCOMMENT THE BELOW CODE AND FILL IN THE DB NAME FOR THE CSS DB.

	----MyGovPay
	--INSERT INTO SystemSupportSnapshotData (DataItemName, DataItemValue)
	--select COALESCE((SELECT TOP 1 'true' from [CSS_DB_NAME].[dbo].[TENANT_PAYMENT_SETTING] 
	--WHERE PAYMENT_SERVICE_URL = 'https://api.mygovpay.com/orderpayment'), 0) [CSSMyGovPayEnabled]
	--UNION ALL
	----Persolvent
	--select COALESCE((SELECT TOP 1 'true' from [CSS_DB_NAME].[dbo].[TENANT_PAYMENT_SETTING] 
	--WHERE PAYMENT_SERVICE_URL = 'https://www.mygovpay.com/services/REST/mygovpay.svc/orders'), 0) [CSSPersolventEnabled]

	-----------------------------------------------------
	
	--Return data for viewing/saving/exporting.
	select DataItemType, DataItemName, SUBSTRING(DataItemValue, 1, 150) DataItemValue from @systemSupportSnapshotDataTable order by DataItemType, DataItemName

END