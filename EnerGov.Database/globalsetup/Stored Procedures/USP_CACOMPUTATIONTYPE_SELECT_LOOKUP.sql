﻿CREATE PROCEDURE [globalsetup].[USP_CACOMPUTATIONTYPE_SELECT_LOOKUP]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT		[dbo].[CACOMPUTATIONTYPE].[CACOMPUTATIONTYPEID],
				[dbo].[CACOMPUTATIONTYPE].[NAME]
	FROM		[dbo].[CACOMPUTATIONTYPE]
	ORDER BY	[dbo].[CACOMPUTATIONTYPE].[NAME]
END