


-- =============================================
-- Author:		<Kyong Hwangbo, EnerGov Solutions>	
-- Create date: <9/28/2010>
-- Description:	<Created as a script to pull all activities for a Code Case;
-- Report(s) using this query:
-- Notice of Violation.rpt
-- =============================================

CREATE PROCEDURE [dbo].[rpt_Activities-Code]

AS
BEGIN
	SET NOCOUNT ON;
SELECT CMCodeActivity.CMCodeCaseID, CMCodeActivity.CMCodeActivityID
	,CMCodeActivityType.Name AS CodeActivityType, CMCodeActivity.CodeActivityName, CMCodeActivity.CodeActivityNumber, CMCodeActivity.CodeActivityComments
	, CMCodeActivity.CreatedOn, FName, LName 


FROM CMCodeActivity 
	LEFT OUTER JOIN CMCodeActivityType ON CMCodeActivity.CMCodeActivityTypeID = CMCodeActivityType.CMCodeActivityTypeID 
	INNER JOIN Users ON CMCodeActivity.sUserGUID = Users.sUserGUID
	
END


