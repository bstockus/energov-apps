﻿CREATE PROCEDURE [communitydevelopmentsetup].[USP_PMPERMITVALUATIONGROUP_SELECT_LOOKUP]
AS
	SET NOCOUNT ON;
	SELECT 
		[dbo].[PMPERMITVALUATIONGROUP].[PMPERMITVALUATIONGROUPID],
		[dbo].[PMPERMITVALUATIONGROUP].[NAME]
	FROM [dbo].[PMPERMITVALUATIONGROUP]
	ORDER BY [dbo].[PMPERMITVALUATIONGROUP].[NAME]
RETURN 0