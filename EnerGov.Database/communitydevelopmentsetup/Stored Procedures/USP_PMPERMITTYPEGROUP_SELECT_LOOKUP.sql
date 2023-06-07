﻿CREATE PROCEDURE [communitydevelopmentsetup].[USP_PMPERMITTYPEGROUP_SELECT_LOOKUP]
AS
	SET NOCOUNT ON;
	SELECT 
		[dbo].[PMPERMITTYPEGROUP].[PMPERMITTYPEGROUPID],
		[dbo].[PMPERMITTYPEGROUP].[NAME]
	FROM [dbo].[PMPERMITTYPEGROUP] 
	ORDER BY [dbo].[PMPERMITTYPEGROUP].[NAME] ASC