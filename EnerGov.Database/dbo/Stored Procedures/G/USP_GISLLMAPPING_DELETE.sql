﻿CREATE PROCEDURE [dbo].[USP_GISLLMAPPING_DELETE]
(
	@GISLLMAPPINGID CHAR(36)
)
AS

EXEC [dbo].[USP_GISLLTRANSLATION_DELETE_BY_GISLLMAPPINGID] @GISLLMAPPINGID

DELETE FROM [dbo].[GISLLMAPPING]
WHERE
	[GISLLMAPPINGID] = @GISLLMAPPINGID