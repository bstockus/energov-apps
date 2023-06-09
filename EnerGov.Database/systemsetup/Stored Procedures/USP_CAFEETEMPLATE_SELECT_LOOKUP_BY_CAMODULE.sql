﻿CREATE PROCEDURE [systemsetup].[USP_CAFEETEMPLATE_SELECT_LOOKUP_BY_CAMODULE]
(
	@CAMODULEID INT
)
AS
BEGIN
SET NOCOUNT ON;
SELECT  
	[dbo].[CAFEETEMPLATE].[CAFEETEMPLATEID],
	[dbo].[CAFEETEMPLATE].[CAFEETEMPLATENAME]
	FROM [dbo].[CAFEETEMPLATE] 
	INNER JOIN [dbo].[CAENTITY] on [dbo].[CAFEETEMPLATE].[CAENTITYID] = [dbo].[CAENTITY].[CAENTITYID]
	INNER JOIN [dbo].[CAMODULE] on [dbo].[CAENTITY].[CAMODULEID] = [dbo].[CAMODULE].[CAMODULEID]
WHERE [dbo].[CAMODULE].[CAMODULEID] = @CAMODULEID
ORDER BY [dbo].[CAFEETEMPLATE].[CAFEETEMPLATENAME]
END