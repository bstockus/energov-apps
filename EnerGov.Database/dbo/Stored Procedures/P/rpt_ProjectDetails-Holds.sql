
-- =============================================
-- Author:		<Kyong Hwangbo, EnerGov Solutions>	
-- Create date: <10/1/2010>
-- Description:	<Created as a script to pull all holds for a project;
-- Report(s) using this query:
-- ProjectDetails.rpt
-- =============================================

CREATE PROCEDURE [dbo].[rpt_ProjectDetails-Holds]
AS
BEGIN
	SET NOCOUNT ON;
-- Holds Info
SELECT PRProjectHold.PRProjectID, PRProjectHold.PRProjectHoldID, HoldType.HoldTypeName, Origin, OriginNumber, CreatedDate, Comments, HoldTypeSetups.Active, FName, LName 
FROM PRProjectHold 
	LEFT OUTER JOIN HoldTypeSetups ON PRProjectHold.HoldSetupID = HoldTypeSetups.HoldSetupID 
	LEFT OUTER JOIN HoldType ON HoldTypeSetups.HoldTypeID = HoldType.HoldTypeID 
	LEFT OUTER JOIN Users ON PRProjectHold.sUserGUID = Users.sUserGUID 
END

