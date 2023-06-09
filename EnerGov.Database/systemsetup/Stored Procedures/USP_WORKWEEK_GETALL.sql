﻿CREATE PROCEDURE [systemsetup].[USP_WORKWEEK_GETALL]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT		[dbo].[WORKWEEK].[DAYOFWEEK],
				[dbo].[WORKWEEK].[STARTTIME],
				[dbo].[WORKWEEK].[ENDTIME],
				[dbo].[WORKWEEK].[ISWORKINGDAY],
				[dbo].[WORKWEEK].[LASTCHANGEDBY],
				[dbo].[WORKWEEK].[LASTCHANGEDON],
				[dbo].[WORKWEEK].[ROWVERSION]
	FROM		[dbo].[WORKWEEK]
			
	ORDER BY	[dbo].[WORKWEEK].[DAYOFWEEK]
END