CREATE  PROCEDURE [livelink].[USP_MAPREQUEST_DELETE]  
-- Add the parameters for the stored procedure here  
@REQUESTDATE DATETIME  
AS  
BEGIN    
 DELETE FROM  [dbo].[MAPREQUEST]  
 WHERE REQUESTDATE < @REQUESTDATE  
END