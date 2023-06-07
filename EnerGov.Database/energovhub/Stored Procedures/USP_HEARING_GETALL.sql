﻿CREATE PROCEDURE [energovhub].[USP_HEARING_GETALL]    
AS  
BEGIN    
SET NOCOUNT ON;

 SELECT   
		[PLPLAN].[PLANNUMBER] AS CASENUMBER,
		'Plan' AS CASETYPE,
		[HEARINGTYPE].[NAME] AS HEARINGTYPE,
		[HEARINGSTATUS].[NAME] AS HEARINGSTATUS,
		[HEARING].[STARTDATE],
		[HEARING].[ENDDATE]
 FROM  [dbo].[HEARINGXREF]
		 INNER JOIN [dbo].[PLPLANWFACTIONSTEP] ON [HEARINGXREF].[OBJECTID] = [PLPLANWFACTIONSTEP].[PLPLANWFACTIONSTEPID]
		 INNER JOIN [dbo].[PLPLANWFSTEP] ON [PLPLANWFACTIONSTEP].[PLPLANWFSTEPID] = [PLPLANWFSTEP].[PLPLANWFSTEPID]
		 INNER JOIN [dbo].[PLPLAN] ON [PLPLANWFSTEP].[PLPLANID] = [PLPLAN].[PLPLANID]
		 INNER JOIN [dbo].[HEARING] ON [HEARINGXREF].[HEARINGID] = [HEARING].[HEARINGID]
		 INNER JOIN [dbo].[HEARINGTYPE] ON [HEARING].[HEARINGTYPEID] = [HEARINGTYPE].[HEARINGTYPEID]
		 INNER JOIN [dbo].[HEARINGSTATUS] ON [HEARING].[HEARINGSTATUSID] = [HEARINGSTATUS].[HEARINGSTATUSID]

 UNION

   SELECT   
		[PMPERMIT].[PERMITNUMBER] AS CASENUMBER,
		'Permit' AS CASETYPE,
		[HEARINGTYPE].[NAME] AS HEARINGTYPE,
		[HEARINGSTATUS].[NAME] AS HEARINGSTATUS,
		[HEARING].[STARTDATE],
		[HEARING].[ENDDATE]
 FROM  [dbo].[HEARINGXREF]
		 INNER JOIN [dbo].[PMPERMITWFACTIONSTEP] ON [HEARINGXREF].[OBJECTID] = [PMPERMITWFACTIONSTEP].[PMPERMITWFACTIONSTEPID]
		 INNER JOIN [dbo].[PMPERMITWFSTEP] ON [PMPERMITWFACTIONSTEP].[PMPERMITWFSTEPID] = [PMPERMITWFSTEP].[PMPERMITWFSTEPID]
		 INNER JOIN [dbo].[PMPERMIT] ON [PMPERMITWFSTEP].[PMPERMITID] = [PMPERMIT].[PMPERMITID]
		 INNER JOIN [dbo].[HEARING] ON [HEARINGXREF].[HEARINGID] = [HEARING].[HEARINGID]
		 INNER JOIN [dbo].[HEARINGTYPE] ON [HEARING].[HEARINGTYPEID] = [HEARINGTYPE].[HEARINGTYPEID]
		 INNER JOIN [dbo].[HEARINGSTATUS] ON [HEARING].[HEARINGSTATUSID] = [HEARINGSTATUS].[HEARINGSTATUSID]
END