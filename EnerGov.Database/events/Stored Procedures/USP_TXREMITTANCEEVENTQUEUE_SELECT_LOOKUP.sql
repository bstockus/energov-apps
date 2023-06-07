﻿CREATE PROCEDURE [events].[USP_TXREMITTANCEEVENTQUEUE_SELECT_LOOKUP]
(
	@BATCHSIZE AS INT = 1000
)
AS
DECLARE @UseFreeFormText BIT = 0, @IsCAPOnlineEnable BIT = 0, @IsFreeFormON BIT = 0

SELECT @UseFreeFormText = [BITVALUE] FROM [dbo].[SETTINGS] WHERE [NAME] = 'UseFreeformTextForCompanyName'
SELECT @IsCAPOnlineEnable = [BITVALUE] FROM [dbo].[CAPSETTING] WHERE [NAME] = 'CAPOnlineEnable'
IF(@IsCAPOnlineEnable = 0 AND @UseFreeFormText = 1)
	SET @IsFreeFormON = 1

DECLARE @RESULT_DATA AS TABLE 
(
	[TXREMITTANCEEVENTQUEUEID] BIGINT, 
	[TXREMITTANCEEVENTTYPEID] INT,
	[CREATEDDATE] DATETIME,
	[TXREMITTANCEACCOUNTID] CHAR(36),
	[DESCRIPTION] VARCHAR(MAX),
	[TXREMITTANCEACCOUNTNAME] VARCHAR(50),
	[REMITTANCEACCOUNTNUMBER] NVARCHAR(50),
	[DUEDATE] DATETIME,
	[PERIODNAME] NVARCHAR(50),
	[REPORTEDDATE] DATETIME,
	[TXREMITTANCETYPENAME] NVARCHAR(50),
	[TXREMITSTATUSNAME] NVARCHAR(50),
	[TXREMITTANCEACCOUNTCREATEDDATE] DATETIME,
	[OPENDATE] DATETIME,
	[GENERATEDDATE] DATETIME,
	[CLOSEDATE] DATETIME,
	[DISTRICTNAME] NVARCHAR(100),
	[LASTCHANGEDBY] NVARCHAR(70),
	[ADDRESSLINE1] NVARCHAR(200),
	[ADDRESSLINE2] NVARCHAR(200),
	[ADDRESSLINE3] NVARCHAR(200),
	[STREETTYPE] NVARCHAR(50),
	[PREDIRECTION] NVARCHAR(30),
	[POSTDIRECTION] NVARCHAR(30),
	[UNITORSUITE]  VARCHAR(20),
	[CITY] NVARCHAR(50),
	[COUNTRYTYPE] INT,
	[PROVINCE] NVARCHAR(50),
	[STATE] NVARCHAR(50),
	[POSTALCODE] NVARCHAR(50),
	[COUNTRY] NVARCHAR(50),
	[BLGLOBALENTITYEXTENSIONID] CHAR(36),
	[COMPANYNAME] NVARCHAR(100),
	[GLDISTRICTNAME] NVARCHAR(100),
	[BLGLOBALENTITYEXTENSIONDESC] NVARCHAR(MAX),
	[BLGLOBALENTITYEXTENSIONOPENDATE] DATETIME,
	[BLGLOBALENTITYEXTENSIONCLOSEDDATE] DATETIME,
	[LASTAUDITDATE] DATETIME,
	[BUSINESSPHONE] NVARCHAR(50),
	[EMAIL] NVARCHAR(250),
	[BLEXTCOMPANYTYPENAME] NVARCHAR(50),
	[EINNUMBER] NVARCHAR(11),
	[SSN] NVARCHAR(256),
	[BLEXTSTATUSNAME] NVARCHAR(50),
	[STATETAXNUMBER] NVARCHAR(20),
	[DBA] NVARCHAR(100),
	[REGISTRATIONID] VARCHAR(50)
);


WITH RAW_DATA AS
(
SELECT TOP(@BATCHSIZE)
	[TXREMITTANCEEVENTQUEUE].[TXREMITTANCEEVENTQUEUEID],
	[TXREMITTANCEEVENTQUEUE].[TXREMITTANCEEVENTTYPEID],
	[TXREMITTANCEEVENTQUEUE].[CREATEDDATE],
	[TXREMITTANCEACCOUNT].[TXREMITTANCEACCOUNTID],
	[TXREMITTANCEACCOUNT].[DESCRIPTION],
	[TXREMITTANCEACCOUNT].[NAME],
	[TXREMITTANCEACCOUNT].[REMITTANCEACCOUNTNUMBER],
	[TXBILLPERIOD].[DUEDATE],
	[TXBILLPERIOD].[PERIODNAME],
	[TXREMITTANCE].[REPORTEDDATE],
	[TXREMITTANCETYPE].[NAME] [TXREMITTANCETYPENAME],
	[TXREMITSTATUS].[NAME] [TXREMITSTATUSNAME],
	[TXREMITTANCEACCOUNT].[CREATEDDATE] [TXREMITTANCEACCOUNTCREATEDDATE],
	[TXREMITTANCEACCOUNT].[OPENDATE],
	[TXREMITTANCEACCOUNT].[GENERATEDDATE],
	[TXREMITTANCEACCOUNT].[CLOSEDATE],
	[DISTRICT].[NAME] [DISTRICTNAME],
	LTRIM(RTRIM(CONCAT([dbo].[USERS].[FNAME], ' ', [dbo].[USERS].[LNAME]))) AS [LASTCHANGEDBY],
	[MAILINGADDRESS].[ADDRESSLINE1],
	[MAILINGADDRESS].[ADDRESSLINE2],
	[MAILINGADDRESS].[ADDRESSLINE3],
	[MAILINGADDRESS].[STREETTYPE],
	[MAILINGADDRESS].[PREDIRECTION],
	[MAILINGADDRESS].[POSTDIRECTION],
	[MAILINGADDRESS].[UNITORSUITE],
	[MAILINGADDRESS].[CITY],
	[MAILINGADDRESS].[COUNTRYTYPE],
	[MAILINGADDRESS].[PROVINCE],
	[MAILINGADDRESS].[STATE],
	[MAILINGADDRESS].[POSTALCODE],
	[MAILINGADDRESS].[COUNTRY],
	[TXREMITTANCEACCOUNT].[BLGLOBALENTITYEXTENSIONID],
	CASE 
	WHEN ([BLGLOBALENTITYEXTENSION].[COMPANYNAME] IS NULL AND @IsFreeFormON = 0) THEN [GLOBALENTITY].[GLOBALENTITYNAME]
	ELSE [BLGLOBALENTITYEXTENSION].[COMPANYNAME]
	END AS [COMPANYNAME],
	[GLDISTRICT].[NAME] [GLDISTRICTNAME],
	[BLGLOBALENTITYEXTENSION].[DESCRIPTION] [BLGLOBALENTITYEXTENSIONDESC],
	[BLGLOBALENTITYEXTENSION].[OPENDATE] [BLGLOBALENTITYEXTENSIONOPENDATE],
	[BLGLOBALENTITYEXTENSION].[CLOSEDATE] [BLGLOBALENTITYEXTENSIONCLOSEDDATE],
	[BLGLOBALENTITYEXTENSION].[LASTAUDITDATE],
	[BLGLOBALENTITYEXTENSION].[BUSINESSPHONE],
	[BLGLOBALENTITYEXTENSION].[EMAIL],
	[BLEXTCOMPANYTYPE].[NAME] [BLEXTCOMPANYTYPENAME],
	[BLGLOBALENTITYEXTENSION].[EINNUMBER],
	[BLGLOBALENTITYEXTENSION].[SSN],
	[BLEXTSTATUS].[NAME] [BLEXTSTATUSNAME],
	[BLGLOBALENTITYEXTENSION].[STATETAXNUMBER],
	[BLGLOBALENTITYEXTENSION].[DBA],
	[BLGLOBALENTITYEXTENSION].[REGISTRATIONID]

FROM [dbo].[TXREMITTANCEEVENTQUEUE]
	INNER JOIN [dbo].[TXREMITTANCEACCOUNT] WITH(NOLOCK) ON [dbo].[TXREMITTANCEACCOUNT].[TXREMITTANCEACCOUNTID] = [dbo].[TXREMITTANCEEVENTQUEUE].[TXREMITTANCEACCOUNTID]
	INNER JOIN [dbo].[TXREMITSTATUS] WITH(NOLOCK) ON [dbo].[TXREMITSTATUS].[TXREMITSTATUSID] = [dbo].[TXREMITTANCEACCOUNT].[TXREMITTANCESTATUSID]
	INNER JOIN [dbo].[TXREMITTANCETYPE] WITH(NOLOCK) ON [dbo].[TXREMITTANCETYPE].[TXREMITTANCETYPEID] = [dbo].[TXREMITTANCEACCOUNT].[TXREMITTANCETYPEID]
	INNER JOIN [dbo].[DISTRICT] WITH(NOLOCK) ON [dbo].[DISTRICT].[DISTRICTID] = [dbo].[TXREMITTANCEACCOUNT].[DISTRICT]
	LEFT JOIN [dbo].[TXREMITTANCE] WITH(NOLOCK) ON [dbo].[TXREMITTANCE].[TXREMITTANCEID] = [dbo].[TXREMITTANCEEVENTQUEUE].[TXREMITTANCEID]
	LEFT JOIN [dbo].[TXBILLPERIOD] WITH(NOLOCK) ON [dbo].[TXBILLPERIOD].[BILLPERIODID] = [dbo].[TXREMITTANCE].[TXBILLPERIODID]
	INNER JOIN [dbo].[BLGLOBALENTITYEXTENSION] WITH(NOLOCK) ON [dbo].[BLGLOBALENTITYEXTENSION].[BLGLOBALENTITYEXTENSIONID] = [dbo].[TXREMITTANCEACCOUNT].[BLGLOBALENTITYEXTENSIONID]
	INNER JOIN [dbo].[BLEXTCOMPANYTYPE] WITH(NOLOCK) ON [dbo].[BLEXTCOMPANYTYPE].[BLEXTCOMPANYTYPEID] = [dbo].[BLGLOBALENTITYEXTENSION].[BLEXTCOMPANYTYPEID]
	INNER JOIN [dbo].[BLEXTSTATUS] WITH(NOLOCK) ON [dbo].[BLEXTSTATUS].[BLEXTSTATUSID] = [dbo].[BLGLOBALENTITYEXTENSION].[BLEXTSTATUSID]
	LEFT JOIN [dbo].[BLGLOBALENTITYEXTENSIONADDRESS] WITH(NOLOCK) ON [dbo].[BLGLOBALENTITYEXTENSIONADDRESS].[BLGLOBALENTITYEXTENSIONID] = [dbo].[BLGLOBALENTITYEXTENSION].[BLGLOBALENTITYEXTENSIONID] AND [dbo].[BLGLOBALENTITYEXTENSIONADDRESS].[MAIN] = 1
	LEFT JOIN [dbo].[GLOBALENTITY] WITH(NOLOCK) ON [dbo].[GLOBALENTITY].[GLOBALENTITYID] = [dbo].[BLGLOBALENTITYEXTENSION].[GLOBALENTITYID]
	LEFT JOIN [dbo].[MAILINGADDRESS] WITH(NOLOCK) ON [dbo].[MAILINGADDRESS].[MAILINGADDRESSID] = [dbo].[BLGLOBALENTITYEXTENSIONADDRESS].[MAILINGADDRESSID]
	LEFT JOIN [dbo].[DISTRICT] [GLDISTRICT] WITH(NOLOCK) ON [GLDISTRICT].[DISTRICTID] = [dbo].[BLGLOBALENTITYEXTENSION].[DISTRICTID]
	LEFT JOIN [dbo].[USERS] WITH(NOLOCK) ON [dbo].[USERS].[SUSERGUID] = [dbo].[TXREMITTANCEACCOUNT].[LASTCHANGEBY]

	WHERE [dbo].[TXREMITTANCEEVENTQUEUE].[PROCESSEDDATE] IS NULL
	ORDER BY [dbo].[TXREMITTANCEEVENTQUEUE].[CREATEDDATE]
)

INSERT INTO @RESULT_DATA
SELECT * FROM RAW_DATA

SELECT * FROM @RESULT_DATA

SELECT 
[TXREMACCCONTACT].[TXREMITTANCEACCOUNTID],
[TXREMACCCONTACT].[ISBILLING],
[GLOBALENTITY].[GLOBALENTITYID],
[GLOBALENTITY].[GLOBALENTITYNAME],
[GLOBALENTITY].[FIRSTNAME],
[GLOBALENTITY].[MIDDLENAME],
[GLOBALENTITY].[LASTNAME],
[BLCONTACTTYPE].[NAME] AS [CONTACTTYPENAME],
[BLCONTACTTYPESYSTEM].[NAME] AS [SYSTEMCONTACTTYPENAME]

FROM @RESULT_DATA AS [RESULTDATA] 
INNER JOIN [dbo].[TXREMACCCONTACT] WITH(NOLOCK) ON [dbo].[TXREMACCCONTACT].[TXREMITTANCEACCOUNTID] = [RESULTDATA].[TXREMITTANCEACCOUNTID]
INNER JOIN [dbo].[GLOBALENTITY] WITH(NOLOCK) ON [dbo].[GLOBALENTITY].[GLOBALENTITYID] = [dbo].[TXREMACCCONTACT].[GLOBALENTITYID]
LEFT JOIN [dbo].[BLCONTACTTYPE] WITH(NOLOCK) ON [dbo].[BLCONTACTTYPE].BLCONTACTTYPEID = [dbo].[TXREMACCCONTACT].[BLCONTACTTYPEID]
INNER JOIN [dbo].[BLCONTACTTYPESYSTEM] WITH(NOLOCK) ON [dbo].[BLCONTACTTYPESYSTEM].[BLCONTACTTYPESYSTEMID] = [dbo].[BLCONTACTTYPE].[BLCONTACTTYPESYSTEMID]