﻿CREATE PROCEDURE [globalsetup].[USP_WFTEMPLATE_BY_WFSTEP]
(
	@WFSTEPID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT
		[dbo].[WFTEMPLATESTEP].[WFTEMPLATEID]
FROM [dbo].[WFTEMPLATESTEP] WITH (NOLOCK) 
WHERE
	[WFSTEPID] = @WFSTEPID
END