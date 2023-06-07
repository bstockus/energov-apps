﻿CREATE PROCEDURE [businessmanagementsetup].[USP_RPPROPERTYSYSSTATUS_SELECT_LOOKUP]
AS
	SET NOCOUNT ON;
	SELECT 
		[dbo].[RPPROPERTYSYSSTATUS].[RPPROPERTYSYSSTATUSID],
		[dbo].[RPPROPERTYSYSSTATUS].[NAME]
	FROM [dbo].[RPPROPERTYSYSSTATUS]
	ORDER BY [dbo].[RPPROPERTYSYSSTATUS].[NAME] ASC