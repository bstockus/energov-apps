﻿CREATE PROCEDURE [incidentrequest].[USP_PARCEL_CONTEXTUALINFO_BLLICENSE_LINKEDRECORDS_GETBYPARENTID] 
	@PARENTID char(36)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   
	SELECT DISTINCT			
			[BLLICENSE].[LICENSENUMBER],
			[BLLICENSETYPE].[NAME],
			[BLLICENSESTATUS].[NAME],
			[BLLICENSESTATUSSYSTEM].[NAME],
			[BLLICENSECLASS].[NAME]												
	FROM [BLLICENSEPARCEL]	
	INNER JOIN [BLLICENSE] ON [BLLICENSE].[BLLICENSEID] = [BLLICENSEPARCEL].[BLLICENSEID]
	INNER JOIN [BLLICENSETYPE] ON [BLLICENSETYPE].[BLLICENSETYPEID] = [BLLICENSE].[BLLICENSETYPEID]	
	INNER JOIN [BLLICENSESTATUS] ON [BLLICENSESTATUS].[BLLICENSESTATUSID] = [BLLICENSE].[BLLICENSESTATUSID]
	INNER JOIN [BLLICENSESTATUSSYSTEM] ON [BLLICENSESTATUSSYSTEM].[BLLICENSESTATUSSYSTEMID]=[BLLICENSESTATUS].[BLLICENSESTATUSSYSTEMID]
	INNER JOIN [BLLICENSECLASS] ON [BLLICENSECLASS].[BLLICENSECLASSID] = [BLLICENSE].[BLLICENSECLASSID]
	WHERE 
		[BLLICENSEPARCEL].[PARCELID] = @PARENTID
END