﻿CREATE PROCEDURE [globalsearch].[USP_HOLDENTITY_GETBYIDS_LOOKUP]
(
	@IDS RECORDIDS READONLY-- HOLDIDS
)
AS
BEGIN
SET NOCOUNT ON;

SELECT	[BLEXTHOLD].[SUSERGUID],
		[BLEXTHOLD].[HOLDSETUPID],
		[BLEXTHOLD].[BLEXTHOLDID],
		[BLEXTHOLD].[ACTIVE],
		[USERS].[FNAME],
		[USERS].[LNAME],
		[BLEXTHOLD].[CREATEDDATE]		
FROM [BLEXTHOLD] 
		INNER JOIN [USERS] WITH (NOLOCK) ON [BLEXTHOLD].[SUSERGUID]=[USERS].[SUSERGUID] 
WHERE 
	[BLEXTHOLD].[BLEXTHOLDID] IN (SELECT [RECORDID] FROM @IDS) 

UNION ALL
SELECT 
	[PRPROJECTHOLD].[PRPROJECTID],
	[PRPROJECTHOLD].[HOLDSETUPID],
	[PRPROJECTHOLD].[PRPROJECTHOLDID],
	[PRPROJECTHOLD].[ACTIVE],
	[USERS].[FNAME],
	[USERS].[LNAME],	
	[PRPROJECTHOLD].[CREATEDDATE]
FROM PRPROJECTHOLD
	INNER JOIN USERS WITH (NOLOCK) ON [PRPROJECTHOLD].[SUSERGUID] = [USERS].[SUSERGUID]
WHERE 
	[PRPROJECTHOLD].[PRPROJECTHOLDID] IN (SELECT [RECORDID] FROM @IDS)

UNION ALL
SELECT  [GLOBALENTITYHOLD].[GLOBALENTITYID],
	[GLOBALENTITYHOLD].[HOLDSETUPID],
	[GLOBALENTITYHOLD].[GLOBALENTITYHOLDID],
	[GLOBALENTITYHOLD].[ACTIVE],
	[USERS].[FNAME],
	[USERS].[LNAME],
	[GLOBALENTITYHOLD].[CREATEDDATE]
FROM [dbo].[GLOBALENTITYHOLD] 
	INNER JOIN [dbo].[USERS]  WITH (NOLOCK) ON [GLOBALENTITYHOLD].[SUSERGUID]=[USERS].[SUSERGUID]
WHERE 
	[GLOBALENTITYHOLD].[GLOBALENTITYHOLDID] IN (SELECT [RECORDID] FROM @IDS)

UNION ALL
SELECT	[BLLICENSEHOLD].[SUSERGUID],
		[BLLICENSEHOLD].[HOLDSETUPID],
		[BLLICENSEHOLD].[BLLICENSEHOLDID],
		[BLLICENSEHOLD].[ACTIVE],
		[USERS].[FNAME],
		[USERS].[LNAME],
		[BLLICENSEHOLD].[CREATEDDATE]		
FROM [BLLICENSEHOLD]
		INNER JOIN [USERS] WITH (NOLOCK) ON [BLLICENSEHOLD].[SUSERGUID]=[USERS].[SUSERGUID] 
WHERE 
	[BLLICENSEHOLD].[BLLICENSEHOLDID] IN  (SELECT [RECORDID] FROM @IDS)	
UNION ALL
SELECT	[ILLICENSEHOLD].[SUSERGUID],
		[ILLICENSEHOLD].[HOLDSETUPID],
		[ILLICENSEHOLD].[ILLICENSEHOLDID],
		[ILLICENSEHOLD].[ACTIVE],
		[USERS].[FNAME],
		[USERS].[LNAME],
		[ILLICENSEHOLD].[CREATEDDATE]		
FROM [ILLICENSEHOLD]
		INNER JOIN [USERS] WITH (NOLOCK) ON [ILLICENSEHOLD].[SUSERGUID]=[USERS].[SUSERGUID] 
WHERE 
	[ILLICENSEHOLD].[ILLICENSEHOLDID] IN  (SELECT [RECORDID] FROM @IDS)	

EXEC [globalsearch].[USP_HOLDTYPESETUPS_GETBYIDS_LOOKUP] @IDS

END