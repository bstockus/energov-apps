﻿CREATE PROCEDURE [globalsetup].[USP_CATEMPLATEFEEDISCOUNTXREF_GETBYFEETEMPLATEID]
	@CAFEETEMPLATEID CHAR(36)
AS
BEGIN
SET NOCOUNT ON;

	SELECT	[dbo].[CATEMPLATEFEEDISCOUNTXREF].[CATEMPLATEFEEDISCOUNTXREFID],
			[dbo].[CATEMPLATEFEEDISCOUNTXREF].[CAFEETEMPLATEFEEID],
			[dbo].[CATEMPLATEFEEDISCOUNTXREF].[CAFEETEMPLATEDISCOUNTID],
			[dbo].[CATEMPLATEFEEDISCOUNTXREF].[SORTORDER]
	FROM [dbo].[CATEMPLATEFEEDISCOUNTXREF]
	INNER JOIN [dbo].[CAFEETEMPLATEFEE] ON [dbo].[CAFEETEMPLATEFEE].[CAFEETEMPLATEFEEID] = [dbo].[CATEMPLATEFEEDISCOUNTXREF].[CAFEETEMPLATEFEEID]
	WHERE [dbo].[CAFEETEMPLATEFEE].[CAFEETEMPLATEID] = @CAFEETEMPLATEID

END