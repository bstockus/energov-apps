﻿CREATE PROCEDURE [common].[USP_PLPLANWORKCLASS_MAIN_LOOKUP]
AS
	SET NOCOUNT ON;
	SELECT 
		[dbo].[PLPLANWORKCLASS].[PLPLANWORKCLASSID],
		[dbo].[PLPLANWORKCLASS].[NAME]
	FROM [dbo].[PLPLANWORKCLASS]
	ORDER BY [dbo].[PLPLANWORKCLASS].[NAME]