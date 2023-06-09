﻿CREATE PROCEDURE [metadata].[USP_BUMETADATA_GETBYMODULEID]
(
	@ENTITYID INT
)
AS
BEGIN
	SELECT [dbo].[BUMETADATA].[BUMETADATAID], 
		   [dbo].[BUMETADATA].[FIELDNAME],
		   [dbo].[BUMETADATA].[CONTROLTYPE],
		   [dbo].[BUMETADATA].[FIELDTYPE],
		   [dbo].[BUMETADATA].[FIELDLABEL]
	FROM 
	[dbo].[BUMETADATA] 
	WHERE [dbo].[BUMETADATA].[ENTITY] = @ENTITYID
END