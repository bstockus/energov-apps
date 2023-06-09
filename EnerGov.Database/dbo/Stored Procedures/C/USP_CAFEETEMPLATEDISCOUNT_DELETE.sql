﻿CREATE PROCEDURE [dbo].[USP_CAFEETEMPLATEDISCOUNT_DELETE]
(
@CAFEETEMPLATEDISCOUNTID CHAR(36)
)
AS

DELETE FROM [dbo].[CATEMPLATEFEEDISCOUNTXREF]
WHERE	[dbo].[CATEMPLATEFEEDISCOUNTXREF].[CAFEETEMPLATEDISCOUNTID] = @CAFEETEMPLATEDISCOUNTID

DELETE	[dbo].[CADISCOUNTINPUTTRANSLATION] FROM [dbo].[CADISCOUNTINPUTTRANSLATION]
JOIN	[dbo].[CAFEETEMPLATEDISCOUNTINPUT] ON [dbo].[CAFEETEMPLATEDISCOUNTINPUT].[CAFEETEMPLATEDISCOUNTINPUTID] = [dbo].[CADISCOUNTINPUTTRANSLATION].[CAFEETEMPLATEDISCOUNTINPUTID]
WHERE	[dbo].[CAFEETEMPLATEDISCOUNTINPUT].[CAFEETEMPLATEDISCOUNTID] = @CAFEETEMPLATEDISCOUNTID  

DELETE	[dbo].[CAFEETEMPLATEDISCOUNTINPUT] FROM [dbo].[CAFEETEMPLATEDISCOUNTINPUT]
WHERE	[dbo].[CAFEETEMPLATEDISCOUNTINPUT].[CAFEETEMPLATEDISCOUNTID] = @CAFEETEMPLATEDISCOUNTID  

DECLARE @EXPRESSIONIDS RECORDIDS
DECLARE @CONDITIONGROUPIDS RECORDIDS

INSERT	INTO @EXPRESSIONIDS(RECORDID)
SELECT	[dbo].[CAFEETEMPLATEDISCOUNT].[CAEXPRESSIONID] FROM [dbo].[CAFEETEMPLATEDISCOUNT]
WHERE	[dbo].[CAFEETEMPLATEDISCOUNT].[CAFEETEMPLATEDISCOUNTID] = @CAFEETEMPLATEDISCOUNTID   

INSERT	INTO @CONDITIONGROUPIDS(RECORDID)
SELECT	[dbo].[CAFEETEMPLATEDISCOUNT].[CACONDITIONGROUPID] FROM [dbo].[CAFEETEMPLATEDISCOUNT]
WHERE	[dbo].[CAFEETEMPLATEDISCOUNT].[CAFEETEMPLATEDISCOUNTID] = @CAFEETEMPLATEDISCOUNTID

DELETE FROM [dbo].[CAFEETEMPLATEDISCOUNT]
WHERE
	[CAFEETEMPLATEDISCOUNTID] = @CAFEETEMPLATEDISCOUNTID  

EXEC [dbo].[USP_CAEXPRESSION_DELETE_BY_IDS] @EXPRESSIONIDS
EXEC [dbo].[USP_CACONDITIONGROUP_DELETE_BY_IDS] @CONDITIONGROUPIDS