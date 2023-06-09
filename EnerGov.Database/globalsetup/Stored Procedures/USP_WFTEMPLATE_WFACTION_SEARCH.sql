﻿CREATE PROCEDURE [globalsetup].[USP_WFTEMPLATE_WFACTION_SEARCH]
(
	@SEARCH AS NVARCHAR(MAX) = '',
	@WFSTEPTYPEID AS INT,
	@PAGE_NUMBER AS INT = 1,
	@PAGE_SIZE AS INT = 10,
	@IS_ASCENDING AS BIT = 1
)
AS
BEGIN
	WITH RAW_DATA AS (
		SELECT
			[dbo].[WFACTION].[WFACTIONID],
			[dbo].[WFACTION].[NAME],
			[dbo].[WFACTION].[DESCRIPTION],
			[dbo].[WFACTIONTYPE].[WFACTIONTYPEID],
			[dbo].[WFACTIONTYPE].[NAME] [TYPENAME],
			CASE @IS_ASCENDING WHEN 1 THEN
				ROW_NUMBER() OVER(ORDER BY [dbo].[WFACTION].[NAME])
			ELSE
				ROW_NUMBER() OVER(ORDER BY [dbo].[WFACTION].[NAME] DESC)
			END AS RowNumber,
			COUNT(1) OVER() AS TotalRows
		FROM [dbo].[WFACTION]
		JOIN [dbo].[WFACTIONTYPE]
			ON [dbo].[WFACTIONTYPE].[WFACTIONTYPEID] = [dbo].[WFACTION].[WFACTIONTYPEID]
		JOIN [dbo].[WFSTEPTYPEACTIONTYPE]
			ON [dbo].[WFSTEPTYPEACTIONTYPE].[WFACTIONTYPEID]=[dbo].[WFACTIONTYPE].[WFACTIONTYPEID]
		WHERE ([dbo].[WFSTEPTYPEACTIONTYPE].[WFSTEPTYPEID]=@WFSTEPTYPEID)
			AND ([dbo].[WFACTION].[NAME] LIKE '%'+ @SEARCH +'%'  OR [dbo].[WFACTION].[DESCRIPTION] LIKE '%'+ @SEARCH +'%')
		)
	
	SELECT * 
	FROM RAW_DATA
	WHERE
		RowNumber > @PAGE_SIZE * (@PAGE_NUMBER - 1) AND 
		RowNumber <= @PAGE_SIZE * @PAGE_NUMBER
	ORDER BY 
		RowNumber
END