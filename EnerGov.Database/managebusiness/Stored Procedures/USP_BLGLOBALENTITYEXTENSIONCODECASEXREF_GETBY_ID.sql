﻿CREATE  PROCEDURE [managebusiness].[USP_BLGLOBALENTITYEXTENSIONCODECASEXREF_GETBY_ID] 
@BLGLOBALENTITYEXTENSIONID CHAR(36)
AS    
BEGIN 
SET NOCOUNT ON;
 SELECT   
		 [CMCODECASE].[CMCODECASEID],
		 [CMCODECASESTATUS].[NAME],
		 [CMCODECASE].[CASENUMBER] AS CASENUMBER ,
		 [CMCASETYPE].[NAME] AS CMCASETYPE,
		 [CMCODECASE].[OPENEDDATE]
  FROM  [dbo].[BLGLOBALENTITYEXTENSIONCODECASEXREF]
		  INNER JOIN [dbo].[CMCODECASE] ON [CMCODECASE].[CMCODECASEID] = [BLGLOBALENTITYEXTENSIONCODECASEXREF].[CMCODECASEID]
		  INNER JOIN [dbo].[CMCODECASESTATUS] ON [CMCODECASESTATUS].[CMCODECASESTATUSID] = [CMCODECASE].[CMCODECASESTATUSID]
		  INNER JOIN [dbo].[CMCASETYPE] ON [CMCODECASE].[CMCASETYPEID] = [CMCASETYPE].[CMCASETYPEID]
  WHERE [BLGLOBALENTITYEXTENSIONCODECASEXREF].[BLGLOBALENTITYEXTENSIONID] = @BLGLOBALENTITYEXTENSIONID
		  AND [CMCODECASESTATUS].[SUCCESSFLAG] = 0
		  AND [CMCODECASESTATUS].[FAILUREFLAG] = 0
		  AND [CMCODECASESTATUS].[CANCELLEDFLAG] = 0
	 ORDER BY [CMCODECASE].[OPENEDDATE] DESC
  END