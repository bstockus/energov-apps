

--Used in Plan Applications Year Over Year.rpt
--Anooj Zaveri - 8/30/2010

CREATE PROCEDURE [dbo].[rpt_Plan_Applications_Year_Over_Year]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME
AS
SELECT     PLPlan.PLANNumber AS PlanNumber, PLPlanType.PlanName AS PlanType, PLPlan.ApplicationDate
FROM         PLPlan INNER JOIN
                      PLPlanType ON PLPlan.PLPlanTypeID = PLPlanType.PLPlanTypeID
WHERE PLPlan.ApplicationDate >= @STARTDATE AND PLPlan.ApplicationDate <= @ENDDATE



