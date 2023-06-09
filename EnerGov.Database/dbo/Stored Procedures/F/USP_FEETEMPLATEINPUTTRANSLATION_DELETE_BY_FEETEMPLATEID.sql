﻿CREATE PROCEDURE [dbo].[USP_FEETEMPLATEINPUTTRANSLATION_DELETE_BY_FEETEMPLATEID]
	@CAFEETEMPLATEID CHAR(36)
AS

DELETE	[dbo].[CAFEEINPUTTRANSLATION] FROM [dbo].[CAFEEINPUTTRANSLATION]
JOIN	[dbo].[CAFEETEMPLATEFEEINPUT] ON [dbo].[CAFEETEMPLATEFEEINPUT].[CAFEETEMPLATEFEEINPUTID] = [dbo].[CAFEEINPUTTRANSLATION].[CAFEETEMPLATEFEEINPUTID]
JOIN	[dbo].[CAFEETEMPLATEFEE] ON [dbo].[CAFEETEMPLATEFEEINPUT].[CAFEETEMPLATEFEEID] = [dbo].[CAFEETEMPLATEFEE].[CAFEETEMPLATEFEEID]
WHERE	[dbo].[CAFEETEMPLATEFEE].[CAFEETEMPLATEID] = @CAFEETEMPLATEID  

DELETE	[dbo].[CADISCOUNTINPUTTRANSLATION] FROM [dbo].[CADISCOUNTINPUTTRANSLATION]
JOIN	[dbo].[CAFEETEMPLATEDISCOUNTINPUT] ON [dbo].[CAFEETEMPLATEDISCOUNTINPUT].[CAFEETEMPLATEDISCOUNTINPUTID] = [dbo].[CADISCOUNTINPUTTRANSLATION].[CAFEETEMPLATEDISCOUNTINPUTID]
JOIN	[dbo].[CAFEETEMPLATEDISCOUNT] ON [dbo].[CAFEETEMPLATEDISCOUNTINPUT].[CAFEETEMPLATEDISCOUNTID] = [dbo].[CAFEETEMPLATEDISCOUNT].[CAFEETEMPLATEDISCOUNTID]
WHERE	[dbo].[CAFEETEMPLATEDISCOUNT].[CAFEETEMPLATEID] = @CAFEETEMPLATEID