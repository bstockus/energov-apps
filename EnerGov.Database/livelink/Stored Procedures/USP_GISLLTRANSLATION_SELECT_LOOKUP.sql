﻿CREATE PROCEDURE [livelink].[USP_GISLLTRANSLATION_SELECT_LOOKUP]
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[GISLLTRANSLATION].[GISLLMAPPING],	
	[GISLLTRANSLATION].[EXTERNALVALUE],
	[GISLLTRANSLATION].[ENERGOVVALUE]
FROM 
	[dbo].[GISLLTRANSLATION] WITH (NOLOCK)
END