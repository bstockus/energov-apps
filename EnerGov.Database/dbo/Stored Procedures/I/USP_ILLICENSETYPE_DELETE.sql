﻿CREATE PROCEDURE [dbo].[USP_ILLICENSETYPE_DELETE]
(
	@ILLICENSETYPEID CHAR(36),
	@ROWVERSION INT
)
AS
SET NOCOUNT ON;

	EXEC [dbo].[USP_ILLICENSETYPELICENSECLASS_DELETE_BYPARENTID] @ILLICENSETYPEID
	EXEC [dbo].[USP_ILLICENSETYPELICENSEGROUP_DELETE_BYPARENTID] @ILLICENSETYPEID
    EXEC [dbo].[USP_ILLICENSEALLOWEDACTIVITY_DELETE_BYPARENTID] @ILLICENSETYPEID
	EXEC [dbo].[USP_ILLICENSETYPECLASSTYPE_DELETE_BYPARENTID] @ILLICENSETYPEID
	EXEC [dbo].[USP_ATTACHMENTREQFILEREF_DELETE_BYPARENTID] @ILLICENSETYPEID, NULL

SET NOCOUNT OFF;  
DELETE FROM [dbo].[ILLICENSETYPE]
WHERE
	[ILLICENSETYPEID] = @ILLICENSETYPEID AND [ROWVERSION]= @ROWVERSION