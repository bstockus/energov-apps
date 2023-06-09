﻿CREATE PROCEDURE [dbo].[USP_IMINSPECTIONCATEGORY_DELETE]
(
	@IMINSPECTIONCATEGORYID CHAR(36),
	@ROWVERSION INT
)
AS

SET NOCOUNT ON;
EXEC [dbo].[USP_IMINSPECTIONCATEGORYXREF_DELETE_BYPARENTID] @IMINSPECTIONCATEGORYID
SET NOCOUNT OFF;

DELETE FROM [dbo].[IMINSPECTIONCATEGORY]
WHERE
	[dbo].[IMINSPECTIONCATEGORY].[IMINSPECTIONCATEGORYID] = @IMINSPECTIONCATEGORYID AND 
	[dbo].[IMINSPECTIONCATEGORY].[ROWVERSION] = @ROWVERSION