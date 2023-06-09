﻿CREATE PROCEDURE [globalsetup].[USP_CAFEETEMPLATECHILD_GETBYIDS]
	@CAFEETEMPLATEIDS RecordIDs READONLY
AS
BEGIN
SET NOCOUNT ON;
	
	SELECT	[dbo].[CAFEETEMPLATE].[CAFEETEMPLATEID],
			[dbo].[CAFEETEMPLATE].[CAFEETEMPLATENAME],
			[dbo].[CAFEETEMPLATE].[CAFEETEMPLATEDESCRIPTION]
	FROM	[dbo].[CAFEETEMPLATE]
	INNER JOIN @CAFEETEMPLATEIDS AS CAFEETEMPLATEIDS ON [dbo].[CAFEETEMPLATE].[CAFEETEMPLATEID] = CAFEETEMPLATEIDS.RECORDID
	
	EXEC [globalsetup].[USP_CAFEETEMPLATECHILD_FEES_GETBYFEETEMPLATEIDS] @CAFEETEMPLATEIDS
END