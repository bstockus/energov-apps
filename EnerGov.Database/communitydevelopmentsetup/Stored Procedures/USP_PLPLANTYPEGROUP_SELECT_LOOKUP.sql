﻿CREATE PROCEDURE [communitydevelopmentsetup].[USP_PLPLANTYPEGROUP_SELECT_LOOKUP]
AS
	SET NOCOUNT ON;
	SELECT 
		[dbo].[PLPLANTYPEGROUP].[PLPLANTYPEGROUPID],
		[dbo].[PLPLANTYPEGROUP].[NAME]
	FROM [dbo].[PLPLANTYPEGROUP] 
	ORDER BY [dbo].[PLPLANTYPEGROUP].[NAME] ASC