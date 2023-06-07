﻿CREATE PROCEDURE [systemsetup].[USP_INTELLIGENTOBJECT_SEARCH]
(
	@SEARCH			AS NVARCHAR(MAX)	=	'',
	@PAGE_NUMBER	AS INT				=	1,
	@PAGE_SIZE		AS INT				=	10,
	@IS_ASCENDING	AS BIT				=	1
)
AS

WITH RAW_DATA AS (
	SELECT		[dbo].[WORKFLOW].[WORKFLOWID],
				[dbo].[SYSTEMMODULE].[MODULENAME],
				[dbo].[WORKFLOW].[WORKFLOWNAME],
				[dbo].[WORKFLOW].[ROOTCLASSNAME],
				[dbo].[WORKFLOW].[ISSERVER],
				[dbo].[WORKFLOW].[ISCLIENT],
				[dbo].[WORKFLOW].[WORKFLOWDESCRIPTION],
				[dbo].[WORKFLOW].[ISENABLED],
				[dbo].[WORKFLOW].[ISPOSTPROCESS],

				CASE @IS_ASCENDING WHEN 1 THEN
					ROW_NUMBER() OVER(ORDER BY [dbo].[WORKFLOW].[WORKFLOWNAME])
				ELSE
					ROW_NUMBER() OVER(ORDER BY [dbo].[WORKFLOW].[WORKFLOWNAME] DESC)
				END AS RowNumber,
				COUNT(1) OVER() AS TotalRows
	FROM		[dbo].[WORKFLOW]
				INNER JOIN [dbo].[SYSTEMMODULE] ON [dbo].[WORKFLOW].[MODULEID] = [dbo].[SYSTEMMODULE].[SYSTEMMODULEID]
	WHERE ([dbo].[WORKFLOW].[WORKFLOWNAME] LIKE '%'+ @SEARCH +'%') OR ([dbo].[WORKFLOW].[WORKFLOWDESCRIPTION] LIKE '%'+ @SEARCH +'%')
)

SELECT		* 
FROM		RAW_DATA
WHERE		RowNumber > @PAGE_SIZE * (@PAGE_NUMBER - 1) 
			AND RowNumber <= @PAGE_SIZE * @PAGE_NUMBER
ORDER BY	RowNumber