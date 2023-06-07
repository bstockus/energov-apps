﻿CREATE PROCEDURE [globalsetup].[USP_CMCASETYPE_SELECT_LOOKUP]
AS
	SET NOCOUNT ON;
	SELECT		[dbo].[CMCASETYPE].[CMCASETYPEID],
				[dbo].[CMCASETYPE].[NAME]
	FROM		[dbo].[CMCASETYPE]
	ORDER BY	[dbo].[CMCASETYPE].[NAME]