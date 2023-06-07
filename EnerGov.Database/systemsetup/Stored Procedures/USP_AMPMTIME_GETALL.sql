﻿CREATE PROCEDURE [systemsetup].[USP_AMPMTIME_GETALL]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT		[dbo].[AMPMTIME].[AMPMTIMEID],
				[dbo].[AMPMTIME].[STARTTIME],
				[dbo].[AMPMTIME].[ENDTIME],
				[dbo].[AMPMTIME].[LASTCHANGEDBY],
				[dbo].[AMPMTIME].[LASTCHANGEDON],
				[dbo].[AMPMTIME].[ROWVERSION]
	FROM		[dbo].[AMPMTIME]
			
	ORDER BY	[dbo].[AMPMTIME].[AMPMTIMEID]
END