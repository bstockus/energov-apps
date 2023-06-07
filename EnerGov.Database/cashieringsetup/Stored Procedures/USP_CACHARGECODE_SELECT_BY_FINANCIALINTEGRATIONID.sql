﻿CREATE PROCEDURE [cashieringsetup].[USP_CACHARGECODE_SELECT_BY_FINANCIALINTEGRATIONID]
(
	@FINANCIALINTEGRATIONID AS CHAR(36) = NULL
)
AS
BEGIN
SET NOCOUNT ON;
	SELECT 
		[dbo].[CACHARGECODE].[CACHARGECODEID],
		[dbo].[CACHARGECODE].[CHARGECODE],
		[dbo].[CACHARGECODE].[DESCRIPTION],
		[dbo].[CACHARGECODE].[CAFINANCIALINTEGRATIONSETUPID]
	FROM [dbo].[CACHARGECODE]
	WHERE [dbo].[CACHARGECODE].[CAFINANCIALINTEGRATIONSETUPID] = @FINANCIALINTEGRATIONID
	ORDER BY [dbo].[CACHARGECODE].[CHARGECODE] ASC
END