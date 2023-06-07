CREATE  PROCEDURE [systemsettingsmanager].[USP_RESOURCE_DELETE]      
-- Add the parameters for the stored procedure here      
@RESOURCEID CHAR(36)  
AS      
BEGIN        
 DELETE FROM  [dbo].[RESOURCE]      
 WHERE [RESOURCE].[RESOURCEID] = @RESOURCEID   
END