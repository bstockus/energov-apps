﻿CREATE PROCEDURE [dbo].[USP_FEETEMPLATEINPUT_DELETE_BY_FEETEMPLATEID]
	@CAFEETEMPLATEID CHAR(36)
AS

DELETE [dbo].[CAFEETEMPLATEFEEINPUT] FROM [dbo].[CAFEETEMPLATEFEEINPUT]
JOIN [dbo].[CAFEETEMPLATEFEE] ON [dbo].[CAFEETEMPLATEFEEINPUT].[CAFEETEMPLATEFEEID] = [dbo].[CAFEETEMPLATEFEE].[CAFEETEMPLATEFEEID]
WHERE	[dbo].[CAFEETEMPLATEFEE].[CAFEETEMPLATEID] = @CAFEETEMPLATEID  

DELETE [dbo].[CAFEETEMPLATEDISCOUNTINPUT] FROM [dbo].[CAFEETEMPLATEDISCOUNTINPUT]
JOIN [dbo].[CAFEETEMPLATEDISCOUNT] ON [dbo].[CAFEETEMPLATEDISCOUNTINPUT].[CAFEETEMPLATEDISCOUNTID] = [dbo].[CAFEETEMPLATEDISCOUNT].[CAFEETEMPLATEDISCOUNTID]
WHERE	[dbo].[CAFEETEMPLATEDISCOUNT].[CAFEETEMPLATEID] = @CAFEETEMPLATEID