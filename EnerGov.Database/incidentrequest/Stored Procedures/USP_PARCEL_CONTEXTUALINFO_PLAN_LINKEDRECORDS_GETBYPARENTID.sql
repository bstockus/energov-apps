﻿CREATE PROCEDURE [incidentrequest].[USP_PARCEL_CONTEXTUALINFO_PLAN_LINKEDRECORDS_GETBYPARENTID] 
	@PARENTID char(36)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
   
	SELECT DISTINCT			
			[PLPLAN].[PLANNUMBER],
			[PLPLANTYPE].[PLANNAME],
			[PLPLANWORKCLASS].[NAME],
			[PLPLANSTATUS].[NAME],
			[PLPLANSTATUS].[CANCELLEDFLAG],
			[PLPLANSTATUS].[FAILUREFLAG],
			[PLPLANSTATUS].[HOLDFLAG],
			[PLPLANSTATUS].[SUCCESSFLAG],
			[PLPLAN].[PLPLANID]
	FROM [PLPLANPARCEL]	
	INNER JOIN [PLPLAN] ON [PLPLAN].[PLPLANID] = [PLPLANPARCEL].[PLPLANID]
	INNER JOIN [PLPLANTYPE] ON [PLPLANTYPE].[PLPLANTYPEID] = [PLPLAN].[PLPLANTYPEID]
	INNER JOIN [PLPLANWORKCLASS] ON [PLPLANWORKCLASS].[PLPLANWORKCLASSID] = [PLPLAN].[PLPLANWORKCLASSID]
	INNER JOIN [PLPLANSTATUS] ON [PLPLANSTATUS].[PLPLANSTATUSID] = [PLPLAN].[PLPLANSTATUSID]	
	WHERE 
		[PLPLANPARCEL].[PARCELID] = @PARENTID
END