﻿CREATE  PROCEDURE [SystemSettingsManager].[USP_TEAMRESOURCE_DELETE]      
@TEAMRESOURCEID CHAR(36)
AS      
BEGIN        
 DELETE FROM  [dbo].[TEAMRESOURCE]      
 WHERE [TEAMRESOURCE].[TEAMRESOURCEID] = @TEAMRESOURCEID    
END