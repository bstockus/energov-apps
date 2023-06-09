﻿CREATE PROCEDURE [dbo].[USP_GISFEATURECLASSSEARCHFIELD_UPDATE]
(
	@GISFEATURECLASSSEARCHFIELDID CHAR(36),
	@GISFEATURECLASSID CHAR(36),
	@NAME VARCHAR(100),
	@ALIAS VARCHAR(100)
)
AS

UPDATE [dbo].[GISFEATURECLASSSEARCHFIELD] SET
	[GISFEATURECLASSID] = @GISFEATURECLASSID,
	[NAME] = @NAME,
	[ALIAS] = @ALIAS

WHERE
	[GISFEATURECLASSSEARCHFIELDID] = @GISFEATURECLASSSEARCHFIELDID