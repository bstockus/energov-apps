﻿CREATE PROCEDURE [dbo].[USP_IMINSPECTIONTYPEGROUP_DELETE]
(
	@IMINSPECTIONTYPEGROUPID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[IMINSPECTIONTYPEGROUP]
WHERE
	[IMINSPECTIONTYPEGROUPID] = @IMINSPECTIONTYPEGROUPID AND 
	[ROWVERSION]= @ROWVERSION