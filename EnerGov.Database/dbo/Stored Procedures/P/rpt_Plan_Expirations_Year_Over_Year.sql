


--Used in Plan Expirations Year Over Year.rpt
--Anooj Zaveri - 8/30/2010

CREATE PROCEDURE [dbo].[rpt_Plan_Expirations_Year_Over_Year]
@STARTDATE as DATETIME,
@ENDDATE as DATETIME
AS
SELECT     PLPlan.PLANNumber AS PlanNumber, PLPlan.ExpireDate, PLPlanType.PlanName AS PlanType
FROM         PLPlan INNER JOIN
                      PLPlanType ON PLPlan.PLPlanTypeID = PLPlanType.PLPlanTypeID
WHERE PLPlan.ExpireDate >= @STARTDATE and PLPlan.ExpireDate <= @ENDDATE

