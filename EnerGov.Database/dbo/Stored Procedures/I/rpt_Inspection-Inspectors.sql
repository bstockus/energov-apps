






-- =============================================
-- Author:		<Kyong Hwangbo, EnerGov Solutions>	
-- Create date: <9/28/2010>
-- Description:	<Created as a script to pull all Inspectors for an inspection;
-- Report(s) using this query:
-- Inspection Report.rpt
-- =============================================

CREATE PROCEDURE [dbo].[rpt_Inspection-Inspectors]

AS
BEGIN
	SET NOCOUNT ON;

SELECT InspectionID, bPrimary, Users.FName, Users.LName 

FROM IMInspectorRef 
	INNER JOIN Users ON IMInspectorRef.UserID = Users.sUserGUID

--WHERE bPrimary = 'TRUE'	
--order by InspectionID 
	

END





