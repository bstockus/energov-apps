﻿CREATE PROCEDURE [systemsetup].[USP_APPLICATIONUSERTYPE_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[APPLICATIONUSERTYPE].[APPLICATIONUSERTYPEID],
	[dbo].[APPLICATIONUSERTYPE].[APPLICATIONID],
	[dbo].[APPLICATIONUSERTYPE].[TYPEID],
	[dbo].[APPLICATIONUSERTYPE].[TYPENAME]
FROM [dbo].[APPLICATIONUSERTYPE]

END