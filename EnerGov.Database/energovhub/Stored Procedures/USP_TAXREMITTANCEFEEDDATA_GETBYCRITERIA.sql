﻿CREATE PROCEDURE [energovhub].[USP_TAXREMITTANCEFEEDDATA_GETBYCRITERIA]
(
 @STARTDATE DATETIME,
 @ENDDATE DATETIME
)
    
AS  
BEGIN    
SET NOCOUNT ON;

 SELECT   
		[GLOBALENTITY].[GLOBALENTITYNAME] AS BUSINESSNAME,
		[TXREMITTANCEACCOUNT].[ACCOUNTNUMBER],
		[TXBILLPERIOD].[PERIODNAME] AS BILLPERIOD,
		[TXBILLPERIOD].[DUEDATE],
		[TXREMITTANCE].[REPORTEDDATE],
		[DISTRICT].[DESCRIPTION] AS DISTRICT,
		MONTH([TXREMITTANCE].[REPORTEDDATE]) AS  [MONTH],
		YEAR([TXREMITTANCE].[REPORTEDDATE]) AS [YEAR],
		[TXREMITSTATUS].[NAME] AS TAXREMITTANCESTATUS,
		[TXREMITTANCETYPE].[NAME] AS TAXREMITTANCETYPE,
		CASE     
			WHEN ([TXREMITTANCE].[REPORTEDDATE] IS NOT NULL)    
				THEN DATEDIFF(DAY, [TXBILLPERIOD].[DUEDATE], [TXREMITTANCE].[REPORTEDDATE])
			ELSE    
				0
		END AS DUEREPORTDIFFERENCEDAYS,
		ISNULL([TXREMITTANCE].[AMOUNTREPORTED],0) AS TOTAL
		FROM [dbo].[TXREMITTANCE]
        INNER JOIN [dbo].[TXREMITTANCEACCOUNT]  ON  [TXREMITTANCE].[TXREMITTANCEACCOUNTID] = [TXREMITTANCEACCOUNT].[TXREMITTANCEACCOUNTID]
        INNER JOIN [dbo].[BLGLOBALENTITYEXTENSION] ON [TXREMITTANCEACCOUNT].[BLGLOBALENTITYEXTENSIONID] = [BLGLOBALENTITYEXTENSION].[BLGLOBALENTITYEXTENSIONID]
		INNER JOIN [dbo].[GLOBALENTITY] ON [BLGLOBALENTITYEXTENSION].[GLOBALENTITYID] = [GLOBALENTITY].[GLOBALENTITYID]
		INNER JOIN [dbo].[TXBILLPERIOD] ON [TXREMITTANCE].[TXBILLPERIODID] = [TXBILLPERIOD].[BILLPERIODID]
		INNER JOIN [dbo].[TXREMITSTATUS] ON [TXREMITTANCEACCOUNT].[TXREMITTANCESTATUSID] = [TXREMITSTATUS].[TXREMITSTATUSID]
		INNER JOIN [dbo].[TXREMITTANCETYPE] ON [TXREMITTANCEACCOUNT].[TXREMITTANCETYPEID] = [TXREMITTANCETYPE].[TXREMITTANCETYPEID]
		INNER JOIN [dbo].[TXRPTPERIOD] ON [TXREMITTANCEACCOUNT].[REPORTPERIODID] = [TXRPTPERIOD].[TXRPTPERIODID]
		INNER JOIN [dbo].[DISTRICT] ON [TXREMITTANCEACCOUNT].[DISTRICT] = [DISTRICT].[DISTRICTID]
		WHERE
		(
		([TXREMITTANCE].[REPORTEDDATE] IS NOT NULL 
				AND 
		(@STARTDATE IS NULL OR [TXREMITTANCE].[REPORTEDDATE] > @STARTDATE))
				AND
		([TXREMITTANCE].[REPORTEDDATE] < @ENDDATE))
END