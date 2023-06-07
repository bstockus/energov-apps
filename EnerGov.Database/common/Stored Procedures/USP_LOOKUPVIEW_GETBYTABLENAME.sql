﻿CREATE PROCEDURE [common].[USP_LOOKUPVIEW_GETBYTABLENAME]
	@TABLENAME VARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [dbo].[LOOKUPVIEW].[UNIQUEID],[dbo].[LOOKUPVIEW].[STRINGVALUE]
	FROM [dbo].[LOOKUPVIEW] 
	WHERE [dbo].[LOOKUPVIEW].[TABLENAME] = @TABLENAME
	ORDER BY [dbo].[LOOKUPVIEW].[STRINGVALUE]
END