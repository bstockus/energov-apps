﻿CREATE PROCEDURE [common].[USP_PLPLANCAPAPPLICATIONTYPE_SELECT_LOOKUP]
AS
	SET NOCOUNT ON;
	SELECT 
		[dbo].[PLPLANCAPAPPLICATIONTYPE].[PLPLANCAPAPPLICATIONTYPEID],
		[dbo].[PLPLANCAPAPPLICATIONTYPE].[NAME]
	FROM [dbo].[PLPLANCAPAPPLICATIONTYPE]
	ORDER BY [dbo].[PLPLANCAPAPPLICATIONTYPE].[NAME]