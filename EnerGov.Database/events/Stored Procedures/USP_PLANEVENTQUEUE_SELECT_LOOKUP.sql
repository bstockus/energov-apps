﻿CREATE PROCEDURE [events].[USP_PLANEVENTQUEUE_SELECT_LOOKUP]
(
	@BATCHSIZE AS INT = 1000
)
AS

DECLARE @RESULT_DATA AS TABLE 
(
	[PLANEVENTQUEUEID] BIGINT, 
	[PLANEVENTTYPEID] INT,
	[CREATEDDATE] DATETIME,
	[PLPLANID] CHAR(36),
	[DESCRIPTION] NVARCHAR(80),
	[PLANNUMBER] NVARCHAR(50),
	[APPLICATIONDATE] DATETIME,
	[SQUAREFEET] DECIMAL(15,2),
	[VALUE] MONEY,
	[LASTCHANGEDON] DATETIME,
	[PLANNAME] NVARCHAR(50),
	[WORKCLASSNAME] NVARCHAR(50),
	[NAME] NVARCHAR(50),
	[HOLDFLAG] BIT,
	[SUCCESSFLAG] BIT,
	[FAILUREFLAG] BIT,
	[CANCELLEDFLAG] BIT,
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
	[PARCELNUMBER] NVARCHAR(50),
	[TAXNUMBER] NVARCHAR(50),
	[LASTCHANGEDBY] NVARCHAR(70),
	[COMPLETEDATE] DATETIME,
	[APPROVALEXPIREDATE] DATETIME
);

WITH RAW_DATA AS
(
SELECT TOP(@BATCHSIZE)
	[PLANEVENTQUEUE].[PLANEVENTQUEUEID],
	[PLANEVENTQUEUE].[PLANEVENTTYPEID],
	[PLANEVENTQUEUE].[CREATEDDATE],
	[PLPLAN].[PLPLANID],
	SUBSTRING([PLPLAN].[DESCRIPTION], 1, 80) AS [DESCRIPTION],
	[PLPLAN].[PLANNUMBER],
	[PLPLAN].[APPLICATIONDATE],
	[PLPLAN].[SQUAREFEET],
	[PLPLAN].[VALUE],
	[PLPLAN].[LASTCHANGEDON],
	[PLPLANTYPE].[PLANNAME],
	[PLPLANWORKCLASS].[NAME] AS [WORKCLASSNAME],
	[PLPLANSTATUS].[NAME],
	[PLPLANSTATUS].[HOLDFLAG],
	[PLPLANSTATUS].[SUCCESSFLAG],
	[PLPLANSTATUS].[FAILUREFLAG],
	[PLPLANSTATUS].[CANCELLEDFLAG],
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
	LTRIM(RTRIM(CONCAT([dbo].[USERS].[FNAME], ' ', [dbo].[USERS].[LNAME]))) AS [LASTCHANGEDBY],
	[PLPLAN].[COMPLETEDATE],
	[PLPLAN].[APPROVALEXPIREDATE]

FROM [dbo].[PLANEVENTQUEUE]
	INNER JOIN [dbo].[PLPLAN] WITH(NOLOCK) ON [dbo].[PLPLAN].[PLPLANID] = [dbo].[PLANEVENTQUEUE].[PLPLANID]
	INNER JOIN [dbo].[PLPLANSTATUS] WITH(NOLOCK) ON [dbo].[PLPLANSTATUS].[PLPLANSTATUSID] = [dbo].[PLPLAN].[PLPLANSTATUSID]
	INNER JOIN [dbo].[PLPLANTYPE] WITH(NOLOCK) ON [dbo].[PLPLANTYPE].[PLPLANTYPEID] = [dbo].[PLPLAN].[PLPLANTYPEID]
	LEFT JOIN [dbo].[PLPLANWORKCLASS] WITH(NOLOCK) ON [dbo].[PLPLANWORKCLASS].[PLPLANWORKCLASSID] = [dbo].[PLPLAN].[PLPLANWORKCLASSID]
	LEFT JOIN [dbo].[PLPLANADDRESS] WITH(NOLOCK) ON [dbo].[PLPLANADDRESS].[PLPLANID] = [dbo].[PLPLAN].[PLPLANID] AND [dbo].[PLPLANADDRESS].[MAIN] = 1
	LEFT JOIN [dbo].[MAILINGADDRESS] WITH(NOLOCK) ON [dbo].[MAILINGADDRESS].[MAILINGADDRESSID] = [dbo].[PLPLANADDRESS].[MAILINGADDRESSID]
	LEFT JOIN [dbo].[PLPLANPARCEL] WITH(NOLOCK) ON [dbo].[PLPLANPARCEL].[PLPLANID] = [dbo].[PLPLAN].[PLPLANID] AND [dbo].[PLPLANPARCEL].[MAIN] = 1
	LEFT JOIN [dbo].[PARCEL] WITH(NOLOCK) ON [dbo].[PARCEL].[PARCELID] = [dbo].[PLPLANPARCEL].[PARCELID]
	LEFT JOIN [dbo].[USERS] WITH(NOLOCK) ON [dbo].[USERS].[SUSERGUID] = [dbo].[PLPLAN].[LASTCHANGEDBY]

	WHERE [dbo].[PLANEVENTQUEUE].[PROCESSEDDATE] IS NULL
	ORDER BY [dbo].[PLANEVENTQUEUE].[CREATEDDATE]
)

INSERT INTO @RESULT_DATA
SELECT * FROM RAW_DATA

SELECT * FROM @RESULT_DATA

-- only for plan approved event
SELECT 
	[RESULTDATA].[PLPLANID],
	[dbo].[ATTACHMENT].[ATTACHMENTID],
	[dbo].[ATTACHMENT].[FILENAME],
	[dbo].[ATTACHMENTGROUP].[ATTACHMENTGROUPID],
	[dbo].[ATTACHMENTGROUP].[NAME]
FROM @RESULT_DATA [RESULTDATA]
INNER JOIN [dbo].[ATTACHMENT] WITH(NOLOCK) ON [RESULTDATA].[PLPLANID] = [dbo].[ATTACHMENT].[PARENTID]
LEFT JOIN [dbo].[ATTACHMENTGROUP] WITH(NOLOCK) ON [dbo].[ATTACHMENT].[ATTACHMENTGROUPID] = [dbo].[ATTACHMENTGROUP].[ATTACHMENTGROUPID] AND [dbo].[ATTACHMENTGROUP].[RECORDEDFILE] = 1
WHERE [RESULTDATA].PLANEVENTTYPEID = 2

SELECT 
[PLPLANCONTACT].[PLPLANID],
[PLPLANCONTACT].[ISBILLING],
[GLOBALENTITY].[GLOBALENTITYID],
[GLOBALENTITY].[GLOBALENTITYNAME],
[GLOBALENTITY].[FIRSTNAME],
[GLOBALENTITY].[MIDDLENAME],
[GLOBALENTITY].[LASTNAME],
[LANDMANAGEMENTCONTACTTYPE].NAME AS [CONTACTTYPENAME],
[LANDMANAGEMENTCONTACTSYSTEMTYP].NAME AS [SYSTEMCONTACTTYPENAME]

FROM @RESULT_DATA AS [RESULTDATA] 
INNER JOIN [dbo].[PLPLANCONTACT] WITH(NOLOCK) ON [dbo].[PLPLANCONTACT].[PLPLANID] = [RESULTDATA].[PLPLANID]
INNER JOIN [dbo].[GLOBALENTITY] WITH(NOLOCK) ON [dbo].[GLOBALENTITY].[GLOBALENTITYID] = [dbo].[PLPLANCONTACT].[GLOBALENTITYID]
INNER JOIN [dbo].[LANDMANAGEMENTCONTACTTYPE] WITH(NOLOCK) ON [dbo].[LANDMANAGEMENTCONTACTTYPE].[LANDMANAGEMENTCONTACTTYPEID] = [dbo].[PLPLANCONTACT].[LANDMANAGEMENTCONTACTTYPEID]
INNER JOIN [dbo].[LANDMANAGEMENTCONTACTSYSTEMTYP] WITH(NOLOCK) ON [dbo].[LANDMANAGEMENTCONTACTSYSTEMTYP].[LANDMANAGEMENTCONTACTSYSTEMTYP] = [dbo].[LANDMANAGEMENTCONTACTTYPE].[LANDMANAGEMENTCONTACTSYSTEMTYP]