﻿CREATE PROCEDURE [globalsetup].[USP_CACONDITION_GETBYFEETEMPLATEID]
	@CAFEETEMPLATEID CHAR(36)
AS
BEGIN
SET NOCOUNT ON;

	;WITH CTE_CONDITIONGROUPS (CACONDITIONGROUPID) AS (
		SELECT	[dbo].[CAFEETEMPLATEFEE].[CACONDITIONGROUPID] 
		FROM	[dbo].[CAFEETEMPLATEFEE]
		WHERE	[dbo].[CAFEETEMPLATEFEE].[CAFEETEMPLATEID] = @CAFEETEMPLATEID AND [dbo].[CAFEETEMPLATEFEE].[CACONDITIONGROUPID] IS NOT NULL
		UNION ALL
		SELECT	[dbo].[CAFEETEMPLATEDISCOUNT].[CACONDITIONGROUPID] 
		FROM	[dbo].[CAFEETEMPLATEDISCOUNT]
		WHERE	[dbo].[CAFEETEMPLATEDISCOUNT].[CAFEETEMPLATEID] = @CAFEETEMPLATEID AND [dbo].[CAFEETEMPLATEDISCOUNT].[CACONDITIONGROUPID] IS NOT NULL
		UNION ALL		
		SELECT
				CAST([INNER_CACONDITIONGROUP].[CACONDITIONGROUPID] AS CHAR(36))
		FROM	[dbo].[CACONDITIONGROUP] [INNER_CACONDITIONGROUP]
		INNER JOIN CTE_CONDITIONGROUPS [EXAMINED_CONDITIONGROUPS] ON [EXAMINED_CONDITIONGROUPS].[CACONDITIONGROUPID] = [INNER_CACONDITIONGROUP].[PARENTCONDITIONGROUPID]
	)

	SELECT	[dbo].[CACONDITION].[CACONDITIONID],
			[dbo].[CACONDITION].[CACONDITIONGROUPID],
			[dbo].[CACONDITION].[OPERANDTYPEID],
			[dbo].[CACONDITION].[OPERANDVALUE],
			[dbo].[CACONDITION].[OPERANDFRIENDLYNAME],
			[dbo].[CACONDITION].[OPERANDDATATYPEID],
			[dbo].[CACONDITION].[OPERATORID],
			[dbo].[CACONDITION].[COMPAREEXPRESSIONID],
			[dbo].[CACONDITION].[CLASSNAME],
			[dbo].[CACONDITION].[CUSTOMFIELDTABLE]
	FROM	[CTE_CONDITIONGROUPS]
	INNER JOIN [dbo].[CACONDITION] ON [dbo].[CACONDITION].[CACONDITIONGROUPID] = [CTE_CONDITIONGROUPS].[CACONDITIONGROUPID]
	
END