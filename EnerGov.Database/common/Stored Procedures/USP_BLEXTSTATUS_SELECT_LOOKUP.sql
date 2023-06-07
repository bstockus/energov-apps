﻿CREATE PROCEDURE [common].[USP_BLEXTSTATUS_SELECT_LOOKUP]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT		[dbo].[BLEXTSTATUS].[BLEXTSTATUSID],
				[dbo].[BLEXTSTATUS].[NAME]
	FROM		[dbo].[BLEXTSTATUS]
	ORDER BY	[dbo].[BLEXTSTATUS].[NAME]
END