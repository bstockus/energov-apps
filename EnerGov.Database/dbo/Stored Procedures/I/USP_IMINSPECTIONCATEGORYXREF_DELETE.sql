﻿CREATE PROCEDURE [dbo].[USP_IMINSPECTIONCATEGORYXREF_DELETE]
(
@IMINSPECTIONCATEGORYXREFID CHAR(36)
)
AS
DELETE FROM [dbo].[IMINSPECTIONCATEGORYXREF]
WHERE
	[dbo].[IMINSPECTIONCATEGORYXREF].[IMINSPECTIONCATEGORYXREFID] = @IMINSPECTIONCATEGORYXREFID