﻿CREATE PROCEDURE [businessmanagementsetup].[USP_EXAMTYPEVERSION_GETBYPARENTID]
(
	@EXAMTYPEID CHAR(36)
)
AS
BEGIN
	SELECT 
		[dbo].[EXAMTYPEVERSION].[EXAMTYPEVERSIONID],
		[dbo].[EXAMTYPEVERSION].[EXAMTYPEID],
		[dbo].[EXAMTYPEVERSION].[EXAMVERSIONID],
		[dbo].[EXAMVERSION].[NAME],
		[dbo].[EXAMVERSION].[DESCRIPTION],
		[dbo].[EXAMTYPEVERSION].[ISDEFAULT],
		[dbo].[EXAMTYPEVERSION].[ACTIVE]
	FROM [dbo].[EXAMTYPEVERSION]
	INNER JOIN [dbo].[EXAMVERSION]
	ON [dbo].[EXAMVERSION].[EXAMVERSIONID] = [dbo].[EXAMTYPEVERSION].[EXAMVERSIONID]
	WHERE [dbo].[EXAMTYPEVERSION].[EXAMTYPEID] = @EXAMTYPEID
	ORDER BY [dbo].[EXAMVERSION].[NAME] ASC
END