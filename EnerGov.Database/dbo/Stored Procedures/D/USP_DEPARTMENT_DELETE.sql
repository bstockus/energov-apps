﻿CREATE PROCEDURE [dbo].[USP_DEPARTMENT_DELETE]
(
	@DEPARTMENTID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[DEPARTMENT]
WHERE
	[DEPARTMENTID] = @DEPARTMENTID AND 
	[ROWVERSION]= @ROWVERSION