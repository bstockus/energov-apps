﻿CREATE PROCEDURE [communitydevelopmentsetup].[USP_PMPERMITVALUATIONTYPEVALGROUPX_GETALL]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT	[dbo].[PMPERMITVALUATIONTYPEVALGROUPX].[PMPERMITVALUATIONTYPEVALGRPXID],
			[dbo].[PMPERMITVALUATIONTYPEVALGROUPX].[PMPERMITVALUATIONTYPEID],
			[dbo].[PMPERMITVALUATIONTYPEVALGROUPX].[PMPERMITVALUATIONGROUPID],
			[dbo].[PMPERMITVALUATIONTYPEVALGROUPX].[PMPERMITVALTYPEVALGRPID],
			[dbo].[PMPERMITVALUATIONTYPEVALGROUPX].[FACTOR],
			[dbo].[PMPERMITVALUATIONTYPEVALGROUPX].[EDITABLE]
	FROM	[dbo].[PMPERMITVALUATIONTYPEVALGROUPX]

END