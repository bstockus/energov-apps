﻿CREATE PROCEDURE [globalsearch].[USP_WORKFLOWACTION_SEARCH_SELECT_LOOKUP]
(
   @SEARCH AS NVARCHAR(MAX) = '',
   @PAGE_NUMBER AS INT = 1,
   @PAGE_SIZE AS INT = 10,
   @IS_ASCENDING AS BIT = 1,
   @WFTEMPLATESTEPID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
WITH RAW_DATA AS(
    SELECT
        [WFACTION].[WFACTIONID],
        [WFACTION].[NAME],
        [WFACTION].[DESCRIPTION],
        CASE @IS_ASCENDING WHEN 1 THEN
                    ROW_NUMBER() OVER(ORDER BY [WFACTION].[NAME])
                ELSE
                    ROW_NUMBER() OVER(ORDER BY [WFACTION].[NAME] DESC)
                END AS RowNumber,
        COUNT(1) OVER() AS TotalRows
    FROM [dbo].[WFTEMPLATESTEP] WITH (NOLOCK)
        INNER JOIN [dbo].[WFTEMPLATESTEPACTION] WITH (NOLOCK)
                ON [WFTEMPLATESTEP].[WFTEMPLATESTEPID] = [WFTEMPLATESTEPACTION].[WFTEMPLATESTEPID]
        INNER JOIN [dbo].[WFACTION] WITH (NOLOCK)
                ON  [WFTEMPLATESTEPACTION].[WFACTIONID] = [WFACTION].[WFACTIONID]
    WHERE
        [WFTEMPLATESTEP].[WFTEMPLATESTEPID] = @WFTEMPLATESTEPID
        AND    ((@SEARCH <> ''
                AND ([WFACTION].[NAME] LIKE '%'+@SEARCH+'%'
                OR [WFACTION].[DESCRIPTION] LIKE '%'+@SEARCH+'%')
                )
              OR @SEARCH = ''
             )
    )
SELECT *
FROM RAW_DATA
WHERE
   RowNumber > @PAGE_SIZE * (@PAGE_NUMBER - 1) AND
   RowNumber <= @PAGE_SIZE * @PAGE_NUMBER
ORDER BY
   RowNumber
END