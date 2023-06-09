﻿CREATE PROCEDURE [globalsearch].[USP_BUSINESS_TYPE_GETBYIDS_LOOKUP]
(
	@IDS RecordIDs READONLY
)
AS
BEGIN
SET NOCOUNT ON;

SELECT 
		[BLEXTBUSINESSTYPE].[BLEXTBUSINESSTYPEID], 
		[BLEXTBUSINESSTYPE].[CODENUMBER], 
		[BLEXTBUSINESSTYPE].[NAME], 
		[BLEXTBUSINESSCATEGORY].[NAME] AS [CATEGORY_NAME]
FROM [BLEXTBUSINESSTYPE] WITH (NOLOCK)
INNER JOIN [BLEXTBUSINESSCATEGORY] WITH (NOLOCK) ON [BLEXTBUSINESSTYPE].[BLEXTBUSINESSCATEGORYID] = [BLEXTBUSINESSCATEGORY].[BLEXTBUSINESSCATEGORYID]
WHERE
	 [BLEXTBUSINESSTYPE].[BLEXTBUSINESSTYPEID] IN (SELECT [RECORDID] FROM @IDS)
END