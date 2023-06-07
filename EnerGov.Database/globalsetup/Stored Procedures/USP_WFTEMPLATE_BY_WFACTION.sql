﻿CREATE PROCEDURE [globalsetup].[USP_WFTEMPLATE_BY_WFACTION]
(
	@WFACTIONID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;

SELECT
		DISTINCT [dbo].[WFTEMPLATESTEP].[WFTEMPLATEID]
FROM [dbo].[WFTEMPLATESTEP] WITH (NOLOCK)
JOIN [dbo].[WFTEMPLATESTEPACTION]  WITH (NOLOCK) ON [dbo].[WFTEMPLATESTEP].[WFTEMPLATESTEPID] = [dbo].[WFTEMPLATESTEPACTION].[WFTEMPLATESTEPID]
WHERE
	[dbo].[WFTEMPLATESTEPACTION].[WFACTIONID] = @WFACTIONID
END