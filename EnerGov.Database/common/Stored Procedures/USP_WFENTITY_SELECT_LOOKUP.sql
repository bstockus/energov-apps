﻿CREATE PROCEDURE [common].[USP_WFENTITY_SELECT_LOOKUP]
AS
SET NOCOUNT ON;
SELECT 
	[dbo].[WFENTITY].[WFENTITYID],
	[dbo].[WFENTITY].[NAME]
FROM [dbo].[WFENTITY]
WHERE [dbo].[WFENTITY].[WFENTITYID] !=3 and [dbo].[WFENTITY].[WFENTITYID] !=6
ORDER BY [dbo].[WFENTITY].[NAME]