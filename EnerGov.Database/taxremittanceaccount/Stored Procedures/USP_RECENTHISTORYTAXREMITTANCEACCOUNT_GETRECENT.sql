﻿CREATE PROCEDURE [taxremittanceaccount].[USP_RECENTHISTORYTAXREMITTANCEACCOUNT_GETRECENT]
(
	@USERID AS NVARCHAR(36),
	@PAGE_NUMBER AS INT = 1,
	@PAGE_SIZE AS INT = 15
)
AS

WITH RAW_DATA AS (
		SELECT TOP(15)
		tra.TXREMITTANCEACCOUNTID,
		tra.REMITTANCEACCOUNTNUMBER AS ACCOUNTNUMBER,
		blge.COMPANYNAME,
		trs.NAME AS [STATUS],
		tra.OPENDATE,
		trt.NAME AS [ACCOUNTTYPE],
		txrp.NAME [REPORTPERIOD],
		traa.MAILINGADDRESSID,
		ma.ADDRESSLINE1,
		ma.ADDRESSLINE2,
		ma.ADDRESSLINE3,
		ma.ADDRESSTYPE,
		ma.CITY,
		ma.COUNTRY,
		ma.POBOX,
		ma.POSTALCODE,
		ma.PREDIRECTION,
		ma.PROVINCE,
		ma.RURALROUTE,
		ma.STATE,
		ma.STATION,
		rhtra.USERID,
		ud.FNAME AS FNAME,
		ud.LNAME AS LNAME,
		uis.FNAME AS ISSUEDBYFNAME,
		uis.LNAME AS ISSUEDBYLNAME,
		trs.TXREMITSTATUSSYSTEMID

		From [dbo].RECENTHISTORYTAXREMIITANCEACCOUNT AS rhtra

		INNER JOIN [dbo].TXREMITTANCEACCOUNT AS tra
		ON rhtra.TXREMITTANCEACCOUNTID=tra.TXREMITTANCEACCOUNTID

		INNER JOIN [dbo].[TXREMITSTATUS] AS trs
		ON tra.[TXREMITTANCESTATUSID]=trs.TXREMITSTATUSID

		INNER JOIN [dbo].[TXREMITTANCETYPE] AS trt
		ON tra.TXREMITTANCETYPEID=trt.TXREMITTANCETYPEID

		INNER JOIN [dbo].[BLGLOBALENTITYEXTENSION] AS blge
		ON tra.BLGLOBALENTITYEXTENSIONID= blge.BLGLOBALENTITYEXTENSIONID

		INNER JOIN [dbo].[TXRPTPERIOD] AS txrp
		ON tra.REPORTPERIODID= txrp.TXRPTPERIODID

		INNER JOIN [dbo].[USERS] AS ud
		ON rhtra.USERID= ud.SUSERGUID

		INNER JOIN [dbo].[USERS] AS uis
		ON tra.CREATEDBY= uis.SUSERGUID 

		LEFT JOIN [dbo].[TXREMITTANCEACCOUNTADDRESS] as traa
		ON traa.TXREMITTANCEACCOUNTID=tra.TXREMITTANCEACCOUNTID
		AND ISNULL(traa.MAIN,0)=1  

		LEFT JOIN [dbo].[MAILINGADDRESS] AS ma
		ON ma.MAILINGADDRESSID=traa.MAILINGADDRESSID

		WHERE rhtra.USERID=@USERID
		ORDER BY rhtra.LOGGEDDATETIME DESC
)

SELECT 
		rd.TXREMITTANCEACCOUNTID,
		rd.ACCOUNTNUMBER,
		rd.COMPANYNAME,
		rd.STATUS,
		rd.OPENDATE,
		rd.ACCOUNTTYPE,
		rd.REPORTPERIOD,
		rd.MAILINGADDRESSID,
		rd.ADDRESSLINE1,
		rd.ADDRESSLINE2,
		rd.ADDRESSLINE3,
		rd.ADDRESSTYPE,
		rd.CITY,
		rd.COUNTRY,
		rd.POBOX,
		rd.POSTALCODE,
		rd.PREDIRECTION,
		rd.PROVINCE,
		rd.RURALROUTE,
		rd.STATE,
		rd.STATION,
		rd.USERID,
		rd.FNAME,
		rd.LNAME,
		rd.ISSUEDBYFNAME,
		rd.ISSUEDBYLNAME,
		CASE
			WHEN rd.TXREMITSTATUSSYSTEMID = 1	
			THEN ndd.DUEDATE
			ELSE NULL
		END AS [DUEDATE],
		15 TotalRows 
FROM RAW_DATA as rd
LEFT JOIN (
SELECT TXREMITTANCEACCOUNT.TXREMITTANCEACCOUNTID, MIN(TXBILLPERIOD.DUEDATE) DUEDATE
			FROM [dbo].[TXBILLPERIOD]
				INNER JOIN TXRPTPERIOD ON TXRPTPERIOD.TXRPTPERIODID = TXBILLPERIOD.RPTPERIODREF
				INNER JOIN TXREMITTANCEACCOUNT ON TXREMITTANCEACCOUNT.REPORTPERIODID = TXRPTPERIOD.TXRPTPERIODID		
			WHERE [dbo].[TXBILLPERIOD].DUEDATE >= GETDATE()
			GROUP BY TXREMITTANCEACCOUNTID) as ndd 
ON ndd.TXREMITTANCEACCOUNTID=rd.TXREMITTANCEACCOUNTID