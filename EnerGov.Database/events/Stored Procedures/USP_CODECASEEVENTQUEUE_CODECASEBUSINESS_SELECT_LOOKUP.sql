﻿CREATE PROCEDURE [events].[USP_CODECASEEVENTQUEUE_CODECASEBUSINESS_SELECT_LOOKUP]
(
	@BATCHSIZE AS INT = 1000
)
AS

DECLARE @IsFreeFormEnabledForCompanyName BIT  = [events].[ISFREEFORMENABLED_FOR_COMPANYNAME]()

DECLARE @RESULT_DATA AS TABLE 
(
	[CODECASEEVENTQUEUEID] BIGINT, 
	[CODECASEEVENTTYPEID] INT,
	[CREATEDDATE] DATETIME,
	[CMCODECASEID] CHAR(36),
	[DESCRIPTION] NVARCHAR(80),
	[CASENUMBER] NVARCHAR(50),
	[EMERGENCY] BIT,
	[OPENEDDATE] DATETIME,
	[CLOSEDDATE] DATETIME,
	[CODECASETYPENAME] NVARCHAR(50),
	[CODECASESTATUSNAME] NVARCHAR(50),
	[SUCCESSFLAG] BIT,
	[FAILUREFLAG] BIT,
	[CANCELLEDFLAG] BIT,
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
	[PARCELNUMBER] NVARCHAR(50),
	[TAXNUMBER] NVARCHAR(50),
	[LASTCHANGEDON] DATETIME,
	[LASTCHANGEDBY] NVARCHAR(70)
);

WITH RAW_DATA AS
(
	SELECT TOP(@BATCHSIZE)
	[CODECASEEVENTQUEUE].[CODECASEEVENTQUEUEID],
	[CODECASEEVENTQUEUE].[CODECASEEVENTTYPEID],
	[CODECASEEVENTQUEUE].[CREATEDDATE],
	[CMCODECASE].[CMCODECASEID],
	SUBSTRING([CMCODECASE].[DESCRIPTION], 1, 80) AS [DESCRIPTION],
	[CMCODECASE].[CASENUMBER],
	[CMCODECASE].[EMERGENCY],
	[CMCODECASE].[OPENEDDATE],
	[CMCODECASE].[CLOSEDDATE],
	[CMCASETYPE].[NAME] AS [CODECASETYPENAME],
	[CMCODECASESTATUS].[NAME] AS [CODECASESTATUSNAME],
	[CMCODECASESTATUS].[SUCCESSFLAG],
	[CMCODECASESTATUS].[FAILUREFLAG],
	[CMCODECASESTATUS].[CANCELLEDFLAG],
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
	[PARCEL].[PARCELNUMBER],
	[PARCEL].[TAXNUMBER],
	[CMCODECASE].[LASTCHANGEDON],
	LTRIM(RTRIM(CONCAT([dbo].[USERS].[FNAME], ' ', [dbo].[USERS].[LNAME]))) AS [LASTCHANGEDBY]

	FROM [dbo].[CODECASEEVENTQUEUE]
	INNER JOIN [dbo].[BLGLOBALENTITYEXTENSIONCODECASEXREF] WITH(NOLOCK) ON [dbo].[BLGLOBALENTITYEXTENSIONCODECASEXREF].[CMCODECASEID] = [dbo].[CODECASEEVENTQUEUE].[CMCODECASEID]
	INNER JOIN [dbo].[CMCODECASE] WITH(NOLOCK) ON [dbo].[CMCODECASE].[CMCODECASEID] = [dbo].[BLGLOBALENTITYEXTENSIONCODECASEXREF].[CMCODECASEID]
	INNER JOIN [dbo].[CMCODECASESTATUS] WITH(NOLOCK) ON [dbo].[CMCODECASESTATUS].[CMCODECASESTATUSID] = [dbo].[CMCODECASE].[CMCODECASESTATUSID]
	LEFT JOIN [dbo].[CMCASETYPE] WITH(NOLOCK) ON [dbo].[CMCASETYPE].[CMCASETYPEID] = [dbo].[CMCODECASE].[CMCASETYPEID]
	LEFT JOIN [dbo].[CMCODECASEADDRESS] WITH(NOLOCK) ON [dbo].[CMCODECASEADDRESS].[CMCODECASEID] = [dbo].[CMCODECASE].[CMCODECASEID] AND [dbo].[CMCODECASEADDRESS].[MAIN] = 1
	LEFT JOIN [dbo].[MAILINGADDRESS] WITH(NOLOCK) ON [dbo].[MAILINGADDRESS].[MAILINGADDRESSID] = [dbo].[CMCODECASEADDRESS].[MAILINGADDRESSID]
	LEFT JOIN [dbo].[CMCODECASEPARCEL] WITH(NOLOCK) ON [dbo].[CMCODECASEPARCEL].[CMCODECASEID] = [dbo].[CMCODECASE].[CMCODECASEID] AND [dbo].[CMCODECASEPARCEL].[PRIMARY] = 1
	LEFT JOIN [dbo].[PARCEL] WITH(NOLOCK) ON [dbo].[PARCEL].[PARCELID] = [dbo].[CMCODECASEPARCEL].[PARCELID]
	LEFT JOIN [dbo].[USERS] WITH(NOLOCK) ON [dbo].[USERS].[SUSERGUID] = [dbo].[CMCODECASE].[LASTCHANGEDBY]
	WHERE [dbo].[CODECASEEVENTQUEUE].[PROCESSEDDATE] IS NULL AND [dbo].[CODECASEEVENTQUEUE].[CMVIOLATIONID] IS NULL
	ORDER BY [dbo].[CODECASEEVENTQUEUE].[CREATEDDATE]
)
INSERT INTO @RESULT_DATA
SELECT * FROM RAW_DATA

SELECT * FROM @RESULT_DATA

SELECT
[BLGLOBALENTITYEXTENSIONCODECASEXREF].[CMCODECASEID],
[BLGLOBALENTITYEXTENSIONCODECASEXREF].[BLGLOBALENTITYEXTENSIONID],
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
INNER JOIN [dbo].[BLGLOBALENTITYEXTENSIONCODECASEXREF] WITH(NOLOCK) ON [dbo].[BLGLOBALENTITYEXTENSIONCODECASEXREF].[CMCODECASEID] = [RESULTDATA].[CMCODECASEID]
INNER JOIN [dbo].[BLGLOBALENTITYEXTENSION] WITH(NOLOCK) ON [dbo].[BLGLOBALENTITYEXTENSION].[BLGLOBALENTITYEXTENSIONID] = [dbo].[BLGLOBALENTITYEXTENSIONCODECASEXREF].[BLGLOBALENTITYEXTENSIONID]
INNER JOIN [dbo].[DISTRICT] WITH(NOLOCK) ON [dbo].[DISTRICT].[DISTRICTID] = [dbo].[BLGLOBALENTITYEXTENSION].[DISTRICTID]
INNER JOIN [dbo].[BLEXTCOMPANYTYPE] WITH(NOLOCK) ON [dbo].[BLEXTCOMPANYTYPE].[BLEXTCOMPANYTYPEID] = [dbo].[BLGLOBALENTITYEXTENSION].[BLEXTCOMPANYTYPEID]
INNER JOIN [dbo].[BLEXTSTATUS] WITH(NOLOCK) ON [dbo].[BLEXTSTATUS].[BLEXTSTATUSID] = [dbo].[BLGLOBALENTITYEXTENSION].[BLEXTSTATUSID]
LEFT JOIN [dbo].[BLGLOBALENTITYEXTENSIONADDRESS] WITH(NOLOCK) ON [dbo].[BLGLOBALENTITYEXTENSIONADDRESS].[BLGLOBALENTITYEXTENSIONID] = [dbo].[BLGLOBALENTITYEXTENSION].[BLGLOBALENTITYEXTENSIONID] AND [dbo].[BLGLOBALENTITYEXTENSIONADDRESS].[MAIN] = 1
LEFT JOIN [dbo].[MAILINGADDRESS] WITH(NOLOCK) ON [dbo].[MAILINGADDRESS].[MAILINGADDRESSID] = [dbo].[BLGLOBALENTITYEXTENSIONADDRESS].[MAILINGADDRESSID]
LEFT JOIN [dbo].[GLOBALENTITY] WITH(NOLOCK) ON [dbo].[GLOBALENTITY].[GLOBALENTITYID] = [dbo].[BLGLOBALENTITYEXTENSION].[GLOBALENTITYID]

DECLARE @CMCODECASEIDs RecordIDs
INSERT INTO @CMCODECASEIDs(RECORDID)
SELECT DISTINCT [CMCODECASEID] 
FROM @RESULT_DATA

EXEC [events].[USP_EVENTQUEUE_GET_CODECASECONTACT] @UNIQUEIDS = @CMCODECASEIDs