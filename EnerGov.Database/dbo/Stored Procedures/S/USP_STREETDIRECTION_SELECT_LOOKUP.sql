﻿CREATE PROCEDURE [dbo].[USP_STREETDIRECTION_SELECT_LOOKUP]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[STREETDIRECTION].[STREETDIRECTIONID],
	[dbo].[STREETDIRECTION].[NAME]
FROM [dbo].[STREETDIRECTION]
ORDER BY [dbo].[STREETDIRECTION].[NAME]
END