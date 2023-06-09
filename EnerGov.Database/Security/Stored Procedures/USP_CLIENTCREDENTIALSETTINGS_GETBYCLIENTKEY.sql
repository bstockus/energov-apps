﻿CREATE PROCEDURE [security].[USP_CLIENTCREDENTIALSETTINGS_GETBYCLIENTKEY]
	@CLIENTKEY nvarchar(100)
AS
BEGIN
SET NOCOUNT ON;
	
SELECT 
	[dbo].[CLIENTCREDENTIALSETTINGS].[CLIENTCREDENTIALSETTINGID],
	[dbo].[CLIENTCREDENTIALSETTINGS].[CLIENTCREDENTIALID],
	[dbo].[CLIENTCREDENTIALSETTINGS].[NAME],
	[dbo].[CLIENTCREDENTIALSETTINGS].[VALUE],
	[dbo].[CLIENTCREDENTIALSETTINGS].[DESCRIPTION],
	[dbo].[CLIENTCREDENTIALSETTINGS].[LASTCHANGEDON]	
FROM [dbo].[CLIENTCREDENTIALSETTINGS]
	JOIN [dbo].[CLIENTCREDENTIAL] ON [CLIENTCREDENTIALSETTINGS].[CLIENTCREDENTIALID] = [CLIENTCREDENTIAL].[CLIENTCREDENTIALID]
WHERE [dbo].[CLIENTCREDENTIAL].[CLIENTKEY] = @CLIENTKEY

END