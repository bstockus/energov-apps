﻿CREATE  PROCEDURE [systemsettingsmanager].[USP_RESOURCE_GETBY_TEAMID]    
@TEAMID CHAR(36)
AS  
BEGIN      
SET NOCOUNT ON;
 SELECT   
	[TEAMRESOURCE].[USERID],
	[RESOURCE].[UNAVAILABLESTARTDATE],
	[RESOURCE].[UNAVAILABLEENDDATE]
  FROM  [dbo].[RESOURCE]   
  INNER JOIN [dbo].[TEAMRESOURCE]  ON [TEAMRESOURCE].[USERID] = [RESOURCE].[USERID]
 WHERE
	[TEAMRESOURCE].[TEAMID] = @TEAMID
END