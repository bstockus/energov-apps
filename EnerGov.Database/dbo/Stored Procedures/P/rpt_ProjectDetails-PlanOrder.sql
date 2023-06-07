
-- =============================================
-- Author:		<Kyong Hwangbo, EnerGov Solutions>	
-- Create date: <10/1/2010>
-- Description:	<Created as a script to pull all plan orders for a project;
-- Report(s) using this query:
-- ProjectDetails.rpt
-- =============================================

CREATE PROCEDURE [dbo].[rpt_ProjectDetails-PlanOrder]
AS
BEGIN
	SET NOCOUNT ON;
-- Plan Order Info
SELECT PRProjectPlanOrder.PRProjectID, PRProjectPlanOrder.PRProjectPlanOrderID, PRProjectPlanOrder.PlanOrder, PLPlanType.PlanName AS PlanType, PLPlanWorkClass.Name AS WorkClass
FROM PRProjectPlanOrder	
	LEFT OUTER JOIN PLPlanType ON PRProjectPlanOrder.PLPlanTypeID = PLPlanType.PLPlanTypeID 
	LEFT OUTER JOIN PLPlanWorkClass ON PRProjectPlanOrder.PLPlanWorkClassID = PLPlanWorkClass.PLPlanWorkClassID 
END

