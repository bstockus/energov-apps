﻿CREATE PROCEDURE [maps].[USP_MAPTILE_GETBY_USERID]
(
	@USERID CHAR(36)
)
AS
BEGIN	
SET NOCOUNT ON;
	SELECT [MAPTILE].[MAPTILEID],
		[MAPTILE].[MAPNAME],
		[MAPTILE].[MAPDESCRIPTION],
		[MAPTILE].[MAPURL],
		[MAPTILE].[MAPIMAGE],
		[MAPTILE].[LASTCHANGEDBY],
		[MAPTILE].[LASTCHANGEDON],
		[MAPTILE].[ROWVERSION]
	FROM 
		[dbo].[MAPTILE] WHERE [MAPTILE].[USERID]=@USERID
END