﻿CREATE PROCEDURE [common].[USP_HOLIDAYS]
(	
	@TODAY DATETIME = NULL
)
AS

SET NOCOUNT ON;

SELECT
	[dbo].[HOLIDAY].[HOLIDAYDATE]
FROM [dbo].[HOLIDAY]
WHERE @TODAY IS NULL OR [dbo].[HOLIDAY].[HOLIDAYDATE]>= @TODAY
ORDER BY [dbo].[HOLIDAY].[HOLIDAYDATE]