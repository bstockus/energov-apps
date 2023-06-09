﻿CREATE PROCEDURE [globalsetup].[USP_WFTEMPLATE_WFSTEP_SEARCH_BYWFENTITYID]
(
	@SEARCH AS NVARCHAR(MAX) = '',
	@PAGE_NUMBER AS INT = 1,
	@PAGE_SIZE AS INT = 10,
	@IS_ASCENDING AS BIT = 1,
	@WFENTITYID AS INT
)
AS
WITH RAW_DATA AS (
	SELECT		[dbo].[WFSTEP].[WFSTEPID],
				[dbo].[WFSTEP].[NAME],
				[dbo].[WFSTEP].[DESCRIPTION],
				[dbo].[WFSTEPTYPE].[WFSTEPTYPEID],
				[dbo].[WFSTEPTYPE].[NAME] [TYPENAME],				
				CASE @IS_ASCENDING WHEN 1 THEN
					ROW_NUMBER() OVER(ORDER BY [dbo].[WFSTEP].[NAME])
				ELSE
					ROW_NUMBER() OVER(ORDER BY [dbo].[WFSTEP].[NAME] DESC)
				END AS RowNumber,
				COUNT(1) OVER() AS TotalRows
	FROM 
				[dbo].[WFSTEP]
	INNER JOIN 
				[dbo].[WFSTEPTYPE] ON [dbo].[WFSTEP].[WFSTEPTYPEID] = [dbo].[WFSTEPTYPE].[WFSTEPTYPEID]
	INNER JOIN 
				[dbo].[WFENTITYSTEPTYPE] ON [dbo].[WFENTITYSTEPTYPE].[WFSTEPTYPEID] = [dbo].[WFSTEP].[WFSTEPTYPEID]
	WHERE 
				([dbo].[WFENTITYSTEPTYPE].[WFENTITYID] = @WFENTITYID) AND ([dbo].[WFSTEP].[NAME] LIKE '%'+ @SEARCH +'%' OR [dbo].[WFSTEP].[DESCRIPTION] LIKE '%'+ @SEARCH +'%')
)
	SELECT * 
	FROM 
		RAW_DATA
	WHERE
		RowNumber > @PAGE_SIZE * (@PAGE_NUMBER - 1) AND 
		RowNumber <= @PAGE_SIZE * @PAGE_NUMBER
	ORDER BY 
		RowNumber