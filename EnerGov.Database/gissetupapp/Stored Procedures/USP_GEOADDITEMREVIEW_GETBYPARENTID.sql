﻿CREATE PROCEDURE [gissetupapp].[USP_GEOADDITEMREVIEW_GETBYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT		[dbo].[GEOADDITEMREVIEW].[GEOADDITEMREVIEWID],	
			[dbo].[GEOADDITEMREVIEW].[GEORULEPROCESSID],
			[dbo].[GEOADDITEMREVIEW].[PLSUBMITTALTYPEID],
			[dbo].[GEOADDITEMREVIEW].[PLITEMREVIEWTYPEID]
FROM		[dbo].[GEOADDITEMREVIEW]
INNER JOIN	[dbo].[GEORULEPROCESS]	ON [dbo].[GEORULEPROCESS].[GEORULEPROCESSID] = [dbo].[GEOADDITEMREVIEW].[GEORULEPROCESSID]
WHERE		[dbo].[GEORULEPROCESS].[GEORULEID] =  @PARENTID  

END