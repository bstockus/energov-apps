﻿CREATE PROCEDURE [codecase].[USP_CMCODECASE_UNRESOLVEDVIOLATION_GETBYID]
	@CODECASEID CHAR(36)
AS
	BEGIN
	DECLARE @MINDATE DATETIME = MIN(GETDATE())
	SELECT * FROM (
	SELECT [CMVIOLATION].[CMVIOLATIONID],
		   [CMVIOLATION].[COMPLIANCEDATE],
		   [CMCODEWFACTIONSTEP].[NAME],
		   [CMVIOLATION].[CITATIONISSUEDATE]		
	FROM   [CMCODEWFACTIONSTEP]
		   INNER JOIN [CMCODEWFSTEP] ON [CMCODEWFACTIONSTEP].[CMCODEWFSTEPID] = [CMCODEWFSTEP].[CMCODEWFSTEPID]
		   INNER JOIN [CMVIOLATION] ON [CMVIOLATION].[CMCODEWFACTIONID] = [CMCODEWFACTIONSTEP].[CMCODEWFACTIONSTEPID]
		   INNER JOIN [CMVIOLATIONSTATUS] ON [CMVIOLATIONSTATUS].[CMVIOLATIONSTATUSID] = [CMVIOLATION].[CMVIOLATIONSTATUSID]
	WHERE  CMCODEWFACTIONSTEP.WFACTIONTYPEID = 9 and CMCODEWFSTEP.CMCODECASEID = @CODECASEID
		   AND [CMVIOLATION].[RESOLVEDDATE] IS NULL AND [CMVIOLATIONSTATUS].[SUCCESSFLAG] = 0

	UNION
	SELECT	[CMVIOLATION].[CMVIOLATIONID],
			[CMVIOLATION].[COMPLIANCEDATE],
			[CMCODEWFSTEP].[NAME],
			[CMVIOLATION].[CITATIONISSUEDATE]					
	FROM	[CMCODEWFSTEP]
			INNER JOIN CMVIOLATION ON [CMVIOLATION].[CMCODEWFSTEPID] = [CMCODEWFSTEP].[CMCODEWFSTEPID]	
			INNER JOIN [CMVIOLATIONSTATUS] ON [CMVIOLATIONSTATUS].[CMVIOLATIONSTATUSID] = [CMVIOLATION].[CMVIOLATIONSTATUSID]
	WHERE	[CMCODEWFSTEP].[CMCODECASEID] = @CODECASEID AND [CMVIOLATION].[RESOLVEDDATE] IS NULL AND [CMVIOLATIONSTATUS].[SUCCESSFLAG] = 0 AND [CMCODEWFSTEP].WFSTEPTYPEID=10 ) AS a
	ORDER BY
	CASE WHEN [CITATIONISSUEDATE] IS NULL THEN @MINDATE
	ELSE [CITATIONISSUEDATE] END, [COMPLIANCEDATE], [NAME]
END