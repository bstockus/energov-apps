﻿CREATE PROCEDURE [dbo].[USP_BLLICENSETYPE_DELETE]  
(  
 @BLLICENSETYPEID CHAR(36),  
 @ROWVERSION INT  
)  
AS  
SET NOCOUNT ON;  

EXEC [dbo].[USP_BLLICENSETYPECLASS_DELETE_BYPARENTID] @BLLICENSETYPEID   
EXEC [dbo].[USP_BLLICENSEALLOWEDACTIVITY_DELETE_BYPARENTID] @BLLICENSETYPEID  
  
SET NOCOUNT OFF;  
  
DELETE FROM [dbo].[BLLICENSETYPE]  
WHERE  
 [BLLICENSETYPEID] = @BLLICENSETYPEID AND   
 [ROWVERSION]= @ROWVERSION