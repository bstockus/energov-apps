

CREATE PROCEDURE [dbo].[rpt_Contact_Detail_Report_Plans]
@GLOBALENTITYID as varchar(36)
AS
SELECT     PLPlan.PLANNumber AS PlanNumber, PLPlanType.PlanName AS PlanType, PLPlanWorkClass.Name AS PlanWorkclass, PLPlanStatus.Name AS PlanStatus, 
                      PLPlan.ApplicationDate, PLPlan.ExpireDate, PLPlan.CompleteDate, PLPlanContact.PLPlanID
FROM         PLPlanContact INNER JOIN
                      PLPlan ON PLPlanContact.PLPlanID = PLPlan.PLPlanID INNER JOIN
                      PLPlanType ON PLPlan.PLPlanTypeID = PLPlanType.PLPlanTypeID INNER JOIN
                      PLPlanStatus ON PLPlan.PLPlanStatusID = PLPlanStatus.PLPlanStatusID INNER JOIN
                      PLPlanWorkClass ON PLPlan.PLPlanWorkClassID = PLPlanWorkClass.PLPlanWorkClassID
WHERE PLPlanContact.GlobalEntityID = @GLOBALENTITYID


