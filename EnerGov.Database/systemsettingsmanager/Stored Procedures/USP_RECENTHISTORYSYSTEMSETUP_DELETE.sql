﻿CREATE PROCEDURE [systemsettingsmanager].[USP_RECENTHISTORYSYSTEMSETUP_DELETE]      
(
 @ENTITYID AS CHAR(36)
)
AS      
BEGIN        
DELETE FROM [dbo].[RECENTHISTORYSYSTEMSETUP] WHERE ENTITYID = @ENTITYID  
END