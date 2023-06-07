﻿CREATE PROCEDURE [common].[USP_LOOKUPVIEWFORINTEGERS_GETBYTABLENAME]
	@TABLENAME VARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	SELECT [dbo].[LOOKUPVIEWFORINTEGERS].[UNIQUEID],[dbo].[LOOKUPVIEWFORINTEGERS].[STRINGVALUE]
	FROM [dbo].[LOOKUPVIEWFORINTEGERS]
	WHERE [dbo].[LOOKUPVIEWFORINTEGERS].[TABLENAME] = @TABLENAME
END