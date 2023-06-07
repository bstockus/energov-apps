﻿CREATE PROCEDURE [dbo].[USP_ILLICENSETYPELICENSECLASS_DELETE_BYPARENTID]
(
	@PARENTID CHAR(36)
)
AS

-- Delete Required Fields for (ProfessionalLicenseType, ProfessionalLicenseTypeClassification)
EXEC [dbo].[USP_ILLICENSEREQUIREDFIELD_DELETE_BYPARENTID] @PARENTID, NULL

-- Delete Online File types for (ProfessionalLicenseType, ProfessionalLicenseTypeClassification)
EXEC [dbo].[USP_ATTACHMENTREQFILEREF_DELETE_BYPARENTID] @PARENTID,NULL

EXEC [dbo].[USP_BLCONTACTTYPEREF_DELETE_BYPARENTID] @PARENTID

DELETE FROM [dbo].[ILLICENSETYPELICENSECLASS]
WHERE
	[ILLICENSETYPEID] = @PARENTID