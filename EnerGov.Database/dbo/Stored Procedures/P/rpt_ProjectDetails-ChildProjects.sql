
-- =============================================
-- Author:		<Kyong Hwangbo, EnerGov Solutions>	
-- Create date: <10/1/2010>
-- Description:	<Created as a script to pull all parcels for a project;
-- Report(s) using this query:
-- ProjectDetails.rpt
-- =============================================

CREATE PROCEDURE [dbo].[rpt_ProjectDetails-ChildProjects]
AS
BEGIN
	SET NOCOUNT ON;
--Child Project Info
SELECT PRProject.PRProjectParentID, PRProject.PRProjectID, ProjectNumber, PRProjectType.Name AS ProjectType, PRProjectStatus.Name AS ProjectStatus, StartDate, ExpectedEndDate, CompleteDate 
FROM PRProject 
	INNER JOIN PRProjectType ON PRProject.PRProjectTypeID = PRProjectType.PRProjectTypeID 
	INNER JOIN PRProjectStatus ON PRProject.PRProjectStatusID = PRProjectStatus.PRProjectStatusID 
END

