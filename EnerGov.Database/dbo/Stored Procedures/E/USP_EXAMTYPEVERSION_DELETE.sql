﻿CREATE PROCEDURE [dbo].[USP_EXAMTYPEVERSION_DELETE]
(
	@EXAMTYPEVERSIONID CHAR(36)
)
AS
DELETE FROM [dbo].[EXAMTYPEVERSION]
WHERE
	[EXAMTYPEVERSIONID] = @EXAMTYPEVERSIONID