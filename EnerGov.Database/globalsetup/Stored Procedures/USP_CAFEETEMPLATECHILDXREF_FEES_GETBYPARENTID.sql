﻿CREATE PROCEDURE [globalsetup].[USP_CAFEETEMPLATECHILDXREF_FEES_GETBYPARENTID]
	@CAFEETEMPLATEID CHAR(36)
AS
BEGIN
SET NOCOUNT ON;
	
SELECT	
		[dbo].[CAFEETEMPLATEFEE].[CAFEETEMPLATEFEEID],
		[dbo].[CAFEETEMPLATECHILDXREF].[CHILDFEETEMPLATEID],
		[dbo].[CAFEETEMPLATEFEE].[CAFEEID],
		[dbo].[CAFEETEMPLATEFEE].[FEENAME],
		[dbo].[CAFEETEMPLATEFEE].[FEEDESCRIPTION],
		[dbo].[CAFEETEMPLATEFEE].[FEEORDER],
		[dbo].[CAFEETEMPLATEFEE].[ISMANUAL],
		[dbo].[CAFEETEMPLATEFEE].[ISHIDDEN],
		[dbo].[CAFEETEMPLATEFEE].[ISDISABLE]
FROM	[dbo].[CAFEETEMPLATECHILDXREF]
INNER JOIN [dbo].[CAFEETEMPLATEFEE] ON [dbo].[CAFEETEMPLATECHILDXREF].[CHILDFEETEMPLATEID] = [dbo].[CAFEETEMPLATEFEE].[CAFEETEMPLATEID]
WHERE	[dbo].[CAFEETEMPLATECHILDXREF].[PARENTFEETEMPLATEID] = @CAFEETEMPLATEID

END