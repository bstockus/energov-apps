﻿CREATE PROCEDURE [dbo].[USP_CAFEETEMPLATEFEE_DELETE]
(
@CAFEETEMPLATEFEEID CHAR(36)
)
AS
DELETE FROM [dbo].[CAFEETEMPLATEFEEPRORATEDATE]
WHERE	[dbo].[CAFEETEMPLATEFEEPRORATEDATE].[CAFEETEMPLATEFEEID] = @CAFEETEMPLATEFEEID  

DELETE FROM [dbo].[CATEMPLATEFEEDISCOUNTXREF]
WHERE	[dbo].[CATEMPLATEFEEDISCOUNTXREF].[CAFEETEMPLATEFEEID] = @CAFEETEMPLATEFEEID

DELETE	[dbo].[CAFEEINPUTTRANSLATION] FROM [dbo].[CAFEEINPUTTRANSLATION]
JOIN	[dbo].[CAFEETEMPLATEFEEINPUT] ON [dbo].[CAFEETEMPLATEFEEINPUT].[CAFEETEMPLATEFEEINPUTID] = [dbo].[CAFEEINPUTTRANSLATION].[CAFEETEMPLATEFEEINPUTID]
WHERE	[dbo].[CAFEETEMPLATEFEEINPUT].[CAFEETEMPLATEFEEID] = @CAFEETEMPLATEFEEID  

DELETE	[dbo].[CAFEETEMPLATEFEEINPUT]
WHERE	[dbo].[CAFEETEMPLATEFEEINPUT].[CAFEETEMPLATEFEEID] = @CAFEETEMPLATEFEEID  


DECLARE @EXPRESSIONIDS RECORDIDS
DECLARE @CONDITIONGROUPIDS RECORDIDS

INSERT	INTO @EXPRESSIONIDS(RECORDID)
SELECT	[dbo].[CAFEETEMPLATEFEE].[CAEXPRESSIONID] FROM [dbo].[CAFEETEMPLATEFEE]
WHERE	[dbo].[CAFEETEMPLATEFEE].[CAFEETEMPLATEFEEID] = @CAFEETEMPLATEFEEID

INSERT	INTO @CONDITIONGROUPIDS(RECORDID)
SELECT	[dbo].[CAFEETEMPLATEFEE].[CACONDITIONGROUPID] FROM [dbo].[CAFEETEMPLATEFEE]
WHERE	[dbo].[CAFEETEMPLATEFEE].[CAFEETEMPLATEFEEID] = @CAFEETEMPLATEFEEID

DELETE FROM [dbo].[CAFEETEMPLATEFEE]
WHERE	[CAFEETEMPLATEFEEID] = @CAFEETEMPLATEFEEID  

EXEC [dbo].[USP_CAEXPRESSION_DELETE_BY_IDS] @EXPRESSIONIDS
EXEC [dbo].[USP_CACONDITIONGROUP_DELETE_BY_IDS] @CONDITIONGROUPIDS