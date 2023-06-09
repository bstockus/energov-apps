﻿CREATE PROCEDURE [globalsetup].[USP_PLSUBMITTALTYPEITEMREVIEWTYPEX_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT [dbo].[PLSUBMITTALTYPEITEMREVIEWTYPEX].[PLSUBMITTALTYPEITEMREVWTYPXID],
	   [dbo].[PLSUBMITTALTYPEITEMREVIEWTYPEX].[PLSUBMITTALTYPEID],	
	   [dbo].[PLSUBMITTALTYPEITEMREVIEWTYPEX].[PLITEMREVIEWTYPEID],
	   [dbo].[PLITEMREVIEWTYPE].[NAME],
	   [dbo].[PLSUBMITTALTYPEITEMREVIEWTYPEX].[PRIORITY],
	   [dbo].[PLSUBMITTALTYPEITEMREVIEWTYPEX].[AUTOADD]
FROM [dbo].[PLSUBMITTALTYPEITEMREVIEWTYPEX]
JOIN [dbo].[PLITEMREVIEWTYPE]
ON [dbo].[PLSUBMITTALTYPEITEMREVIEWTYPEX].[PLITEMREVIEWTYPEID] = 
[dbo].[PLITEMREVIEWTYPE].[PLITEMREVIEWTYPEID]	
ORDER BY [dbo].[PLSUBMITTALTYPEITEMREVIEWTYPEX].[PRIORITY],[dbo].[PLITEMREVIEWTYPE].[NAME]
END