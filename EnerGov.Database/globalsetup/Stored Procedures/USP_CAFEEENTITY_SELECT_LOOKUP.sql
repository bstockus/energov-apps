﻿CREATE PROCEDURE [globalsetup].[USP_CAFEEENTITY_SELECT_LOOKUP]
AS
SET NOCOUNT ON;
SELECT		[dbo].[CAENTITY].[CAENTITYID],
			[dbo].[CAENTITY].[NAME],
			[dbo].[CAENTITY].[CAMODULEID],
			[dbo].[CAENTITY].[ISHTMLDEPRICATED]
FROM		[dbo].[CAENTITY]
ORDER BY	[dbo].[CAENTITY].[NAME]