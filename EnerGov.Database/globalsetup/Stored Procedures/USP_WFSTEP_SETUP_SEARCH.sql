﻿CREATE PROCEDURE [globalsetup].[USP_WFSTEP_SETUP_SEARCH]
(
	@SEARCH AS NVARCHAR(MAX) = '',
	@PAGE_NUMBER AS INT = 1,
	@PAGE_SIZE AS INT = 10,
	@IS_ASCENDING AS BIT = 1
)
AS
BEGIN
	WITH RAW_DATA AS (
		SELECT
			[dbo].[WFSTEP].[WFSTEPID],
			[dbo].[WFSTEP].[NAME],
			[dbo].[WFSTEP].[DESCRIPTION],
			[dbo].[WFSTEPTYPE].[NAME] as STEPTYPENAME,
			[dbo].[WORKFLOWCOMPLETETYPE].[NAME] as COMPLETETYPENAME,
			CASE @IS_ASCENDING WHEN 1 THEN
				ROW_NUMBER() OVER(ORDER BY [dbo].[WFSTEP].[NAME])
			ELSE
				ROW_NUMBER() OVER(ORDER BY [dbo].[WFSTEP].[NAME] DESC)
			END AS RowNumber,
			COUNT(1) OVER() AS TotalRows
		FROM [dbo].[WFSTEP]
		INNER JOIN [dbo].[WFSTEPTYPE] on [dbo].[WFSTEPTYPE].WFSTEPTYPEID = [dbo].[WFSTEP].[WFSTEPTYPEID]
		LEFT JOIN [dbo].[WORKFLOWCOMPLETETYPE] on [dbo].[WORKFLOWCOMPLETETYPE].[WORKFLOWCOMPLETETYPEID] = [dbo].[WFSTEP].[WORKFLOWCOMPLETETYPEID]
		WHERE ([dbo].[WFSTEP].[NAME] LIKE '%'+ @SEARCH +'%' or [dbo].[WFSTEP].[DESCRIPTION] LIKE '%'+ @SEARCH +'%') 
	)

	SELECT * 
	FROM RAW_DATA
	WHERE
		RowNumber > @PAGE_SIZE * (@PAGE_NUMBER - 1) AND 
		RowNumber <= @PAGE_SIZE * @PAGE_NUMBER
	ORDER BY 
		RowNumber
END