﻿CREATE PROCEDURE [dbo].[USP_CACONDITION_DELETE]
(
@CACONDITIONID CHAR(36)
)
AS

DECLARE @EXPRESSIONIDS RECORDIDS

INSERT	INTO @EXPRESSIONIDS(RECORDID)
SELECT [dbo].[CACONDITION].[COMPAREEXPRESSIONID]
FROM [dbo].[CACONDITION]
WHERE [CACONDITIONID] = @CACONDITIONID

DELETE FROM [dbo].[CACONDITION]
WHERE [CACONDITIONID] = @CACONDITIONID  

EXEC [dbo].[USP_CAEXPRESSION_DELETE_BY_IDS] @EXPRESSIONIDS