﻿CREATE PROCEDURE [dbo].[USP_CAEXPRESSION_DELETE_BY_IDS]
(
	 @EXPRESSIONIDS RECORDIDS READONLY
)
AS
	;WITH CTE_EXPRESSIONS (CAEXPRESSIONID) AS (
		SELECT	[dbo].[CAEXPRESSION].[CAEXPRESSIONID]
		FROM	[dbo].[CAEXPRESSION]
		JOIN @EXPRESSIONIDS ON RECORDID = [dbo].[CAEXPRESSION].[CAEXPRESSIONID]
		UNION ALL
		SELECT
			CAST([INNER_EXPRESSION].CAEXPRESSIONID AS CHAR(36))
		FROM [dbo].CAEXPRESSION [INNER_EXPRESSION]
			INNER JOIN [CTE_EXPRESSIONS] [EXAMINED_EXPRESSIONS] ON [EXAMINED_EXPRESSIONS].[CAEXPRESSIONID] = [INNER_EXPRESSION].[PARENTEXPRESSIONID]
	)

	DELETE	[dbo].[CAEXPRESSION]
	FROM	[CTE_EXPRESSIONS]
	INNER JOIN [dbo].CAEXPRESSION ON [dbo].[CAEXPRESSION].[CAEXPRESSIONID] = [CTE_EXPRESSIONS].[CAEXPRESSIONID]