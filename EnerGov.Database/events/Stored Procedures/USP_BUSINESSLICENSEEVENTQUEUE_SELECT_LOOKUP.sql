﻿CREATE PROCEDURE [events].[USP_BUSINESSLICENSEEVENTQUEUE_SELECT_LOOKUP]
(
	@BATCHSIZE AS INT = 1000
)
AS

DECLARE @IsFreeFormEnabledForCompanyName BIT  = [events].[ISFREEFORMENABLED_FOR_COMPANYNAME]()

DECLARE @RESULT_DATA AS TABLE 
(
	[BUSINESSLICENSEEVENTQUEUEID] BIGINT, 
	[BUSINESSLICENSEEVENTTYPEID] INT,
	[CREATEDDATE] DATETIME,
	[BLLICENSEID] CHAR(36),
	[DESCRIPTION] NVARCHAR(80),
	[LICENSENUMBER] NVARCHAR(50),
	[BLLICENSEPARENTID] CHAR(36),
	[ISAPPLIEDONLINE] BIT,
	[APPLIEDDATE] DATETIME,
	[ISSUEDDATE] DATETIME,
	[TAXYEAR] INT,
	[ESTIMATEDRECEIPTS] MONEY,
	[REPORTEDRECEIPTS] MONEY,
	[ALLOWEDDEDUCTIONAMOUNT] MONEY,
	[EXPIRATIONDATE] DATETIME,
	[LASTRENEWALDATE] DATETIME,
	[BLLICENSETYPENAME] NVARCHAR(50),
	[BLLICENSECLASSNAME] NVARCHAR(50),
	[BLLICENSESTATUSNAME] NVARCHAR(50),
	[DISTRICTNAME] NVARCHAR(50),
	[HOLDTYPENAME] NVARCHAR(50),
	[MODULENAME] NVARCHAR(100),
	[ADDRESSLINE1] NVARCHAR(200),
	[ADDRESSLINE2] NVARCHAR(200),
	[ADDRESSLINE3] NVARCHAR(200),
	[STREETTYPE] NVARCHAR(50),
	[PREDIRECTION] NVARCHAR(30),
	[POSTDIRECTION] NVARCHAR(30),
	[UNITORSUITE] NVARCHAR(20),
	[CITY] NVARCHAR(50),
	[COUNTRYTYPE] INT,
	[PROVINCE] NVARCHAR(50),
	[STATE] NVARCHAR(50),
	[POSTALCODE] NVARCHAR(50),
	[COUNTRY] NVARCHAR(50),
	[LASTCHANGEDBY] NVARCHAR(70),
	[BLGLOBALENTITYEXTENSIONID] CHAR(36)
);

WITH RAW_DATA AS (
	SELECT TOP(@BATCHSIZE)
	[BUSINESSLICENSEEVENTQUEUE].[BUSINESSLICENSEEVENTQUEUEID],
	[BUSINESSLICENSEEVENTQUEUE].[BUSINESSLICENSEEVENTTYPEID],
	[BUSINESSLICENSEEVENTQUEUE].[CREATEDDATE],
	[BLLICENSE].[BLLICENSEID],
	SUBSTRING([BLLICENSE].[DESCRIPTION], 1, 80) AS [DESCRIPTION],
	[BLLICENSE].[LICENSENUMBER],
	[BLLICENSE].[BLLICENSEPARENTID],
	[BLLICENSE].[ISAPPLIEDONLINE],
	[BLLICENSE].[APPLIEDDATE],
	[BLLICENSE].[ISSUEDDATE],
	[BLLICENSE].[TAXYEAR],
	[BLLICENSE].[ESTIMATEDRECEIPTS],
	[BLLICENSE].[REPORTEDRECEIPTS],
	[BLLICENSE].[ALLOWEDDEDUCTIONAMOUNT],
	[BLLICENSE].[EXPIRATIONDATE],
	[BLLICENSE].[LASTRENEWALDATE],
	[BLLICENSETYPE].[NAME] AS [BLLICENSETYPENAME],
	[BLLICENSECLASS].[NAME] AS [BLLICENSECLASSNAME],
	[BLLICENSESTATUS].[NAME] AS [BLLICENSESTATUSNAME],
	[DISTRICT].[NAME] AS [DISTRICTNAME],
	[HOLDTYPE].[HOLDTYPENAME],
	[HOLDMODULELIST].[MODULENAME],
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
	LTRIM(RTRIM(CONCAT([dbo].[USERS].[FNAME], ' ', [dbo].[USERS].[LNAME]))) AS [LASTCHANGEDBY],
	[BLLICENSE].[BLGLOBALENTITYEXTENSIONID]

	FROM [dbo].[BUSINESSLICENSEEVENTQUEUE]
	INNER JOIN [dbo].[BLLICENSE] WITH (NOLOCK) ON [dbo].[BLLICENSE].[BLLICENSEID] = [dbo].[BUSINESSLICENSEEVENTQUEUE].[BLLICENSEID]
	INNER JOIN [dbo].[BLLICENSETYPE] WITH (NOLOCK) ON [dbo].[BLLICENSETYPE].[BLLICENSETYPEID] = [dbo].[BLLICENSE].[BLLICENSETYPEID]
	INNER JOIN [dbo].[BLLICENSECLASS] ON [dbo].[BLLICENSECLASS].[BLLICENSECLASSID] = [dbo].[BLLICENSE].[BLLICENSECLASSID]
	INNER JOIN [dbo].[BLLICENSESTATUS] ON [dbo].[BLLICENSESTATUS].[BLLICENSESTATUSID] = [dbo].[BLLICENSE].[BLLICENSESTATUSID]
	INNER JOIN [dbo].[DISTRICT] ON [dbo].[DISTRICT].[DISTRICTID] = [dbo].[BLLICENSE].[DISTRICTID]
	LEFT JOIN [dbo].[HOLDTYPESETUPS] WITH (NOLOCK) ON [dbo].[HOLDTYPESETUPS].[HOLDSETUPID] = [dbo].[BUSINESSLICENSEEVENTQUEUE].[HOLDSETUPID]
	LEFT JOIN [dbo].[HOLDTYPE] ON [dbo].[HOLDTYPE].[HOLDTYPEID] = [dbo].[HOLDTYPESETUPS].[HOLDTYPEID]
	LEFT JOIN [dbo].[HOLDMODULELIST] ON [dbo].[HOLDMODULELIST].[MODULEID] = [dbo].[HOLDTYPESETUPS].[MODULEID]
	LEFT JOIN [dbo].[BLLICENSEADDRESS] WITH(NOLOCK) ON [dbo].[BLLICENSEADDRESS].[BLLICENSEID] = [dbo].[BLLICENSE].[BLLICENSEID] AND [dbo].[BLLICENSEADDRESS].[MAIN] = 1
	LEFT JOIN [dbo].[MAILINGADDRESS] WITH(NOLOCK) ON [dbo].[MAILINGADDRESS].[MAILINGADDRESSID] = [dbo].[BLLICENSEADDRESS].[MAILINGADDRESSID]
	LEFT JOIN [dbo].[USERS] WITH(NOLOCK) ON [dbo].[USERS].[SUSERGUID] = [dbo].[BLLICENSE].[LASTCHANGEDBY]
	WHERE [dbo].[BUSINESSLICENSEEVENTQUEUE].[PROCESSEDDATE] IS NULL
	ORDER BY [dbo].[BUSINESSLICENSEEVENTQUEUE].[CREATEDDATE]
	)
INSERT INTO @RESULT_DATA 
SELECT * FROM RAW_DATA

SELECT * FROM @RESULT_DATA

SELECT
[RESULTDATA].[BLLICENSEID],
[BLGLOBALENTITYEXTENSION].[BLGLOBALENTITYEXTENSIONID],
CASE 
	WHEN ([BLGLOBALENTITYEXTENSION].[COMPANYNAME] IS NULL AND @IsFreeFormEnabledForCompanyName = 0) THEN [GLOBALENTITY].[GLOBALENTITYNAME]
	ELSE [BLGLOBALENTITYEXTENSION].[COMPANYNAME]
END AS [COMPANYNAME],
[DISTRICT].[NAME] AS [DISTRICTNAME],
[BLGLOBALENTITYEXTENSION].[DESCRIPTION],
[BLGLOBALENTITYEXTENSION].[OPENDATE],
[BLGLOBALENTITYEXTENSION].[CLOSEDATE],
[BLGLOBALENTITYEXTENSION].[LASTAUDITDATE],
[BLGLOBALENTITYEXTENSION].[BUSINESSPHONE],
[BLGLOBALENTITYEXTENSION].[EMAIL],
[BLGLOBALENTITYEXTENSION].[EINNUMBER],
[BLGLOBALENTITYEXTENSION].[SSN],
[BLGLOBALENTITYEXTENSION].[STATETAXNUMBER],
[BLGLOBALENTITYEXTENSION].[DBA],
[BLGLOBALENTITYEXTENSION].[REGISTRATIONID],
[dbo].[BLEXTCOMPANYTYPE].[NAME] AS [BUSINESSTYPE],
[dbo].[BLEXTSTATUS].[NAME] AS [STATUSNAME],
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
[MAILINGADDRESS].[COUNTRY]

FROM @RESULT_DATA AS [RESULTDATA]
INNER JOIN [dbo].[BLGLOBALENTITYEXTENSION] WITH(NOLOCK) ON [dbo].[BLGLOBALENTITYEXTENSION].[BLGLOBALENTITYEXTENSIONID] = [RESULTDATA].[BLGLOBALENTITYEXTENSIONID]
INNER JOIN [dbo].[DISTRICT] ON [dbo].[DISTRICT].[DISTRICTID] = [dbo].[BLGLOBALENTITYEXTENSION].[DISTRICTID]
INNER JOIN [dbo].[BLEXTCOMPANYTYPE] WITH(NOLOCK) ON [dbo].[BLEXTCOMPANYTYPE].[BLEXTCOMPANYTYPEID] = [dbo].[BLGLOBALENTITYEXTENSION].[BLEXTCOMPANYTYPEID]
INNER JOIN [dbo].[BLEXTSTATUS] ON [dbo].[BLEXTSTATUS].[BLEXTSTATUSID] = [dbo].[BLGLOBALENTITYEXTENSION].[BLEXTSTATUSID]
LEFT JOIN [dbo].[BLGLOBALENTITYEXTENSIONADDRESS] WITH(NOLOCK) ON [dbo].[BLGLOBALENTITYEXTENSIONADDRESS].[BLGLOBALENTITYEXTENSIONID] = [dbo].[BLGLOBALENTITYEXTENSION].[BLGLOBALENTITYEXTENSIONID] AND [dbo].[BLGLOBALENTITYEXTENSIONADDRESS].[MAIN] = 1
LEFT JOIN [dbo].[MAILINGADDRESS] WITH(NOLOCK) ON [dbo].[MAILINGADDRESS].[MAILINGADDRESSID] = [dbo].[BLGLOBALENTITYEXTENSIONADDRESS].[MAILINGADDRESSID]
LEFT JOIN [dbo].[GLOBALENTITY] WITH(NOLOCK) ON [dbo].[GLOBALENTITY].[GLOBALENTITYID] = [dbo].[BLGLOBALENTITYEXTENSION].[GLOBALENTITYID]


SELECT 
[BLLICENSECONTACT].[BLLICENSEID],
[BLLICENSECONTACT].[ISBILLING],
[GLOBALENTITY].[GLOBALENTITYID],
[GLOBALENTITY].[GLOBALENTITYNAME],
[GLOBALENTITY].[FIRSTNAME],
[GLOBALENTITY].[MIDDLENAME],
[GLOBALENTITY].[LASTNAME],
[BLCONTACTTYPE].[NAME] AS [CONTACTTYPENAME],
[BLCONTACTTYPESYSTEM].[NAME] AS [SYSTEMCONTACTTYPENAME]

FROM @RESULT_DATA AS [RESULTDATA] 
INNER JOIN [dbo].[BLLICENSECONTACT] WITH(NOLOCK) ON [dbo].[BLLICENSECONTACT].[BLLICENSEID] = [RESULTDATA].[BLLICENSEID]
LEFT JOIN [dbo].[GLOBALENTITY] WITH(NOLOCK) ON [dbo].[GLOBALENTITY].[GLOBALENTITYID] = [dbo].[BLLICENSECONTACT].[GLOBALENTITYID]
INNER JOIN [dbo].[BLCONTACTTYPE] WITH(NOLOCK) ON [dbo].[BLCONTACTTYPE].[BLCONTACTTYPEID] = [dbo].[BLLICENSECONTACT].[BLCONTACTTYPEID]
INNER JOIN [dbo].[BLCONTACTTYPESYSTEM] WITH(NOLOCK) ON [dbo].[BLCONTACTTYPESYSTEM].[BLCONTACTTYPESYSTEMID] = [dbo].[BLCONTACTTYPE].[BLCONTACTTYPESYSTEMID]