


--Used in Plans Completed Year Over Year.rpt
--Anooj Zaveri - 8/30/2010

CREATE PROCEDURE [dbo].[rpt_Plan_Completed_Year_Over_Year]
@STARTDATE as DATETIME,
@ENDDATE as DATETIME
AS
SELECT     PLPlan.PLANNumber AS PlanNumber, PLPlanType.PlanName AS PlanType, PLPlan.CompleteDate
FROM         PLPlan INNER JOIN
                      PLPlanType ON PLPlan.PLPlanTypeID = PLPlanType.PLPlanTypeID
WHERE PLPlan.CompleteDate >= @STARTDATE and PLPlan.CompleteDate <= @ENDDATE


