
-- =============================================
-- Author:		<Kyong Hwangbo, EnerGov Solutions>	
-- Create date: <10/1/2010>
-- Description:	<Created as a script to pull all conditions for a project;
-- Report(s) using this query:
-- ProjectDetails.rpt
-- =============================================

CREATE PROCEDURE [dbo].[rpt_ProjectDetails-Conditions]
AS
BEGIN
	SET NOCOUNT ON;
-- Condition Info
SELECT PRProjectID, PRProjectConditionID, Condition.Name AS Condition
	, ConditionCategory.Name AS Category, Condition.Description, Condition.Comments, Condition.IsEnable, Condition.OriginObjectName, ConditionScope.ScopeName 
FROM PRProjectCondition 
	LEFT OUTER JOIN Condition ON PRProjectCondition.ConditionID = Condition.ConditionID 
	LEFT OUTER JOIN ConditionCategory ON Condition.ConditionCategoryID = ConditionCategory.ConditionCategoryID 
	LEFT OUTER JOIN ConditionScope ON PRProjectCondition.ConditionScopeID = ConditionScope.ConditionScopeID 
END

