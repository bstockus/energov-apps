﻿CREATE PROCEDURE [communitydevelopmentsetup].[USP_PMPERMITVALUATIONTYPE_GETALL]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[PMPERMITVALUATIONTYPE].[PMPERMITVALUATIONTYPEID],
	[dbo].[PMPERMITVALUATIONTYPE].[NAME],
	[dbo].[PMPERMITVALUATIONTYPE].[DESCRIPTION],
	[dbo].[PMPERMITVALUATIONTYPE].[LASTCHANGEDBY],
	[dbo].[PMPERMITVALUATIONTYPE].[LASTCHANGEDON],
	[dbo].[PMPERMITVALUATIONTYPE].[ROWVERSION]
FROM [dbo].[PMPERMITVALUATIONTYPE] ORDER BY [dbo].[PMPERMITVALUATIONTYPE].[NAME] ASC

END