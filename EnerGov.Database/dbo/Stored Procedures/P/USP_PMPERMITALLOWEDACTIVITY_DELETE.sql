﻿CREATE PROCEDURE [dbo].[USP_PMPERMITALLOWEDACTIVITY_DELETE]
(
@PMPERMITALLOWEDACTIVITYID CHAR(36)
)
AS
DELETE FROM [dbo].[PMPERMITALLOWEDACTIVITY]
WHERE
	[PMPERMITALLOWEDACTIVITYID] = @PMPERMITALLOWEDACTIVITYID