﻿CREATE PROCEDURE [dbo].[USP_WFTEMPLATESTEPACTION_DELETE]
(
@WFTEMPLATESTEPACTIONID CHAR(36)
)
AS
DELETE FROM [dbo].[WFTEMPLATESTEPACTION]
WHERE
	[WFTEMPLATESTEPACTIONID] = @WFTEMPLATESTEPACTIONID