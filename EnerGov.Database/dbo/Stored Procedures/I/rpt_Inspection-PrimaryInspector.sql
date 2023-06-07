





-- =============================================
-- Author:		<Kyong Hwangbo, EnerGov Solutions>	
-- Create date: <9/23/2010>
-- Description:	<Created as a script to pull all PrimaryInspector for an inspection;
-- Report(s) using this query:
-- PermitCard.rpt
-- =============================================

CREATE PROCEDURE [dbo].[rpt_Inspection-PrimaryInspector]

AS
BEGIN
	SET NOCOUNT ON;

SELECT InspectionID, bPrimary, Users.FName, Users.LName 

FROM IMInspectorRef 
	INNER JOIN Users ON IMInspectorRef.UserID = Users.sUserGUID

WHERE bPrimary = 'TRUE'	
order by InspectionID 
	

END




