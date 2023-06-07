﻿CREATE PROCEDURE [dbo].[USP_CACONDITION_DELETE_BY_CONDITIONGROUPIDS]
(
	@CONDITIONGROUPIDS RECORDIDS READONLY
)
AS
BEGIN
	DECLARE @EXPRESSIONIDS RECORDIDS
	
	INSERT	INTO @EXPRESSIONIDS(RECORDID)
	SELECT	[dbo].[CACONDITION].[COMPAREEXPRESSIONID]
	FROM	[dbo].[CACONDITION]
	JOIN @CONDITIONGROUPIDS ON [dbo].[CACONDITION].[CACONDITIONGROUPID] = RECORDID   

	DELETE	[dbo].[CACONDITION]
	FROM	[dbo].[CACONDITION]
	JOIN @CONDITIONGROUPIDS ON [dbo].[CACONDITION].[CACONDITIONGROUPID] = RECORDID

	EXEC [dbo].[USP_CAEXPRESSION_DELETE_BY_IDS] @EXPRESSIONIDS
END