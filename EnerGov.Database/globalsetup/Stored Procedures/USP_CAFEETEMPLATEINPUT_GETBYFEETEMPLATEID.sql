﻿CREATE PROCEDURE [globalsetup].[USP_CAFEETEMPLATEINPUT_GETBYFEETEMPLATEID]
	@CAFEETEMPLATEID CHAR(36)
AS
BEGIN
SET NOCOUNT ON;

	SELECT  [dbo].[CAFEETEMPLATEFEEINPUT].[CAFEETEMPLATEFEEINPUTID] AS INPUTID,
			[dbo].[CAFEETEMPLATEFEEINPUT].[CAFEETEMPLATEFEEID] AS PARENTID,
			[dbo].[CAFEETEMPLATEFEEINPUT].[CAFEETEMPLATEINPUTTYPEID] AS INPUTTYPEID,
			[dbo].[CAFEETEMPLATEFEEINPUT].[INPUTVALUE],
			[dbo].[CAFEETEMPLATEFEEINPUT].[INPUTFRIENDLYNAME],
			[dbo].[CAFEETEMPLATEFEEINPUT].[ISDISPLAY],
			[dbo].[CAFEETEMPLATEFEEINPUT].[CUSTOMFIELDTABLE] AS CUSTOMFIELDTABLE,
			[dbo].[CAFEETEMPLATEFEEINPUT].[CLASSNAME] AS CLASSNAME,
			CONVERT(bit, 1) AS ISFEEINPUT
	FROM	[dbo].[CAFEETEMPLATEFEEINPUT]
	INNER JOIN [dbo].[CAFEETEMPLATEFEE] ON [dbo].[CAFEETEMPLATEFEE].[CAFEETEMPLATEFEEID] = [dbo].[CAFEETEMPLATEFEEINPUT].[CAFEETEMPLATEFEEID]
	WHERE [dbo].[CAFEETEMPLATEFEE].[CAFEETEMPLATEID] = @CAFEETEMPLATEID
	UNION ALL
	SELECT  [dbo].[CAFEETEMPLATEDISCOUNTINPUT].[CAFEETEMPLATEDISCOUNTINPUTID] AS INPUTID,
			[dbo].[CAFEETEMPLATEDISCOUNTINPUT].[CAFEETEMPLATEDISCOUNTID] AS PARENTID,
			[dbo].[CAFEETEMPLATEDISCOUNTINPUT].[CAFEETEMPLATEINPUTTYPEID] AS INPUTTYPEID,
			[dbo].[CAFEETEMPLATEDISCOUNTINPUT].[INPUTVALUE],
			[dbo].[CAFEETEMPLATEDISCOUNTINPUT].[INPUTFRIENDLYNAME],
			[dbo].[CAFEETEMPLATEDISCOUNTINPUT].[ISDISPLAY],
			NULL AS CUSTOMFIELDTABLE,
			[dbo].[CAFEETEMPLATEDISCOUNTINPUT].[CLASSNAME],
			CONVERT(bit, 0) AS ISFEEINPUT
	FROM	[dbo].[CAFEETEMPLATEDISCOUNTINPUT]
	INNER JOIN [dbo].[CAFEETEMPLATEDISCOUNT] ON [dbo].[CAFEETEMPLATEDISCOUNT].[CAFEETEMPLATEDISCOUNTID] = [dbo].[CAFEETEMPLATEDISCOUNTINPUT].[CAFEETEMPLATEDISCOUNTID]
	WHERE [dbo].[CAFEETEMPLATEDISCOUNT].[CAFEETEMPLATEID] = @CAFEETEMPLATEID

END