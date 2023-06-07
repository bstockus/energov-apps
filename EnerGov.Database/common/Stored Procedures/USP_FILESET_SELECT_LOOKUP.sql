﻿CREATE PROCEDURE [common].[USP_FILESET_SELECT_LOOKUP]
AS
	SET NOCOUNT ON;
	SELECT 
		[dbo].[FILESET].[FILESETID],
		[dbo].[FILESET].[NAME]
	FROM [dbo].[FILESET]
	ORDER BY [dbo].[FILESET].[NAME]