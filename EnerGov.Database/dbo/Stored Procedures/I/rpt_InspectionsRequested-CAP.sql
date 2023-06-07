



-- =============================================
-- Author:		<Kyong Hwangbo, EnerGov Solutions>	
-- Create date: <9/28/2010>
-- Description:	<Created as a script to pull all requested inspections from Citizen Access ONLY;
-- Report(s) using this query:
-- Requested Inspections.rpt
-- =============================================

CREATE PROCEDURE [dbo].[rpt_InspectionsRequested-CAP]

AS
BEGIN
	SET NOCOUNT ON;

SELECT IMInspection.IMInspectionID, InspectionNumber, IMInspectionType.Name AS InspectionType, IMInspectionStatus.StatusName
	, ScheduledStartDate, RequestedDate, ActualStartDate 

FROM IMInspection 
	INNER JOIN IMInspectionType ON IMInspection.IMInspectionTypeID = IMInspectionType.IMInspectionTypeID
	INNER JOIN IMInspectionStatus ON IMInspection.IMInspectionStatusID = IMInspectionStatus.IMInspectionStatusID
	INNER JOIN IMInspectionRequestedSource ON IMInspection.IMInspectionRequestedSourceID = IMInspectionRequestedSource.IMInspectionRequestedSourceID
	
WHERE IMInspection.IMInspectionRequestedSourceID = '2'

END


