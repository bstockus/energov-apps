﻿CREATE PROCEDURE [energovhub].[USP_PROFFER_GETALL]    
AS  
BEGIN    
SET NOCOUNT ON;
 SELECT   
		[IPCASE].[SOURCECASENUMBER],
		CASE     
			WHEN ([IPCASE].SOURCECASEENTITY = 1)    
			THEN 'Plan'    
			ELSE    
				'Permit'
		END AS SOURCECASEENTITY,
		[IPCASE].[CASENUMBER],
		[IPCASETYPE].[NAME] AS CASETYPE,
		[IPCASESTATUS].[NAME] AS CASESTATUS,
		[energovhub].[UFN_GET_PROFFER_BALANCE_DUE] (IPCASE.IPCASEID) AS BALANCEDUE
   FROM
   [dbo].[IPCASE]
    INNER JOIN [dbo].[IPCASETYPE] ON [IPCASE].[IPCASETYPEID] = [IPCASETYPE].[IPCASETYPEID]
	INNER JOIN [dbo].[IPCASESTATUS] ON [IPCASE].[IPCASESTATUSID] = [IPCASESTATUS].[IPCASESTATUSID]
END