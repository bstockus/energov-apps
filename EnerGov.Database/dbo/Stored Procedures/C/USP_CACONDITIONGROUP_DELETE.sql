﻿CREATE PROCEDURE [dbo].[USP_CACONDITIONGROUP_DELETE]
(
@CACONDITIONGROUPID CHAR(36)
)
AS

DECLARE @CONDITIONGROUPS RECORDIDS

;WITH CTE_CONDITIONGROUPS (CACONDITIONGROUPID) AS (		
		SELECT	@CACONDITIONGROUPID
		UNION ALL		
		SELECT
				CAST([INNER_CACONDITIONGROUP].[CACONDITIONGROUPID] AS CHAR(36))
		FROM	[dbo].[CACONDITIONGROUP] [INNER_CACONDITIONGROUP]
		INNER JOIN CTE_CONDITIONGROUPS [EXAMINED_CONDITIONGROUPS] ON [EXAMINED_CONDITIONGROUPS].[CACONDITIONGROUPID] = [INNER_CACONDITIONGROUP].[PARENTCONDITIONGROUPID]
)

INSERT INTO @CONDITIONGROUPS (RECORDID)
SELECT [CTE_CONDITIONGROUPS].[CACONDITIONGROUPID] FROM [CTE_CONDITIONGROUPS]

EXEC [dbo].[USP_CACONDITION_DELETE_BY_CONDITIONGROUPIDS] @CONDITIONGROUPS

DELETE FROM [dbo].[CACONDITIONGROUP]
WHERE	[CACONDITIONGROUPID] IN (SELECT RECORDID FROM @CONDITIONGROUPS)