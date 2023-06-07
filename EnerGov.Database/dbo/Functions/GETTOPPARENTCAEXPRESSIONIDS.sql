﻿CREATE FUNCTION [dbo].[GETTOPPARENTCAEXPRESSIONIDS]
(
		@CAEXPRESSIONIDS AS [RecordIDs] READONLY
)
RETURNS @TOPPARENTCAEXPRESSIONIDS TABLE(TOPPARENTCAEXPRESSIONID CHAR(36),EXPRESSIONID CHAR(36))
AS
BEGIN	
	;WITH CTE AS
	(
		SELECT 
			[CAEXPRESSION].[CAEXPRESSIONID],
			[CAEXPRESSION].[PARENTEXPRESSIONID], 
			[RECORDID] AS [EXPRESSIONID]
		FROM [dbo].[CAEXPRESSION] 
		INNER JOIN @CAEXPRESSIONIDS ON [CAEXPRESSION].[CAEXPRESSIONID] = [RECORDID]		
		UNION ALL
		SELECT 
			[CHILDRECORD].[CAEXPRESSIONID],
			[CHILDRECORD].[PARENTEXPRESSIONID],
			[PARENTRECORD].[EXPRESSIONID]
		FROM 
			[dbo].[CAEXPRESSION] [CHILDRECORD] INNER JOIN CTE AS [PARENTRECORD] 
				ON [CHILDRECORD].[CAEXPRESSIONID] = [PARENTRECORD].[PARENTEXPRESSIONID]
	)
	INSERT INTO @TOPPARENTCAEXPRESSIONIDS(TOPPARENTCAEXPRESSIONID,EXPRESSIONID)
	SELECT [CTE].[CAEXPRESSIONID],[CTE].[EXPRESSIONID]
	FROM [CTE] 
	WHERE [CTE].[PARENTEXPRESSIONID] IS NULL 
		
	RETURN 
END