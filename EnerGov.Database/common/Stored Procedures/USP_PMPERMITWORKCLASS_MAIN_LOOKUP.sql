﻿CREATE PROCEDURE [common].[USP_PMPERMITWORKCLASS_MAIN_LOOKUP]
AS
	SET NOCOUNT ON;
	SELECT 
		[dbo].[PMPERMITWORKCLASS].[PMPERMITWORKCLASSID],
		[dbo].[PMPERMITWORKCLASS].[NAME]
	FROM [dbo].[PMPERMITWORKCLASS]
	ORDER BY [dbo].[PMPERMITWORKCLASS].[NAME]