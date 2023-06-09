﻿CREATE PROCEDURE [maps].[USP_PARCELSPLIT_SEARCH_SELECT_LOOKUP]
(
	@SEARCH AS NVARCHAR(MAX) = '',
	@PAGE_NUMBER AS INT = 1,
	@PAGE_SIZE AS INT = 10,
	@SORT_FIELD AS NVARCHAR(50)='',
	@IS_ASCENDING AS BIT =0
)
AS
BEGIN
SET NOCOUNT ON;
;WITH RAW_DATA
	AS(
	SELECT [PARCELSPLIT].[PARCELSPLITID],
		[PARCELSPLIT].[PARCELID], 
		[PARCELSPLIT].[MODULE],
		[PARCELSPLIT].[CASEID],
		[PARCELSPLIT].[CASENUMBER],
		[PARCEL].[PARCELNUMBER],
		(CASE WHEN @IS_ASCENDING = 1
			THEN
				CASE
					WHEN @SORT_FIELD = 'casenumber' THEN ROW_NUMBER() OVER(ORDER BY [dbo].[PARCELSPLIT].[CASENUMBER] ASC)
					WHEN @SORT_FIELD = 'parcelnumber' THEN ROW_NUMBER() OVER(ORDER BY [dbo].[PARCEL].[PARCELNUMBER] ASC)
					ELSE ROW_NUMBER() OVER(ORDER BY [dbo].[PARCELSPLIT].[MODULE] ASC)
				END
			WHEN @IS_ASCENDING=0
			THEN
				CASE
					WHEN @SORT_FIELD = 'casenumber' THEN ROW_NUMBER() OVER(ORDER BY [dbo].[PARCELSPLIT].[CASENUMBER] DESC)
					WHEN @SORT_FIELD = 'parcelnumber' THEN ROW_NUMBER() OVER(ORDER BY [dbo].[PARCEL].[PARCELNUMBER] DESC)
					ELSE ROW_NUMBER() OVER(ORDER BY [dbo].[PARCELSPLIT].[MODULE] DESC)
				END
			END) AS RowNumber,
			COUNT(1) OVER() AS TotalRows
		FROM
			[dbo].[PARCELSPLIT]
			INNER JOIN [dbo].[PARCEL] ON [PARCELSPLIT].[PARCELID] = [PARCEL].[PARCELID]
		WHERE [PARCELSPLIT].[PROCESSED] = 0 
		AND ([PARCELSPLIT].[CASENUMBER] LIKE '%'+@SEARCH+'%'
		OR [PARCEL].[PARCELNUMBER] LIKE '%'+@SEARCH+'%'
		OR [PARCELSPLIT].[MODULE] LIKE '%'+@SEARCH+'%')
)
SELECT * FROM RAW_DATA
WHERE 
	RowNumber > @PAGE_SIZE * (@PAGE_NUMBER - 1) AND 
	RowNumber <= @PAGE_SIZE * @PAGE_NUMBER
ORDER BY 
	RowNumber
END