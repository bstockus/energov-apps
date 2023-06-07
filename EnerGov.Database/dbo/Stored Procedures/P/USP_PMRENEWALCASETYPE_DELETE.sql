﻿CREATE PROCEDURE [dbo].[USP_PMRENEWALCASETYPE_DELETE]
(
	@PMRENEWALCASETYPEID CHAR(36),
	@ROWVERSION INT
)
AS
DELETE FROM [dbo].[PMRENEWALCASETYPE]
WHERE
	[PMRENEWALCASETYPEID] = @PMRENEWALCASETYPEID AND 
	[ROWVERSION]= @ROWVERSION