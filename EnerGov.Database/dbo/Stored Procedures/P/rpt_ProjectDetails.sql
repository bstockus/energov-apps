
-- =============================================
-- Author:		<Kyong Hwangbo, EnerGov Solutions>	
-- Create date: <10/1/2010>
-- Description:	<Created as a script to pull all project information;
-- Report(s) using this query:
-- ProjectDetails.rpt
-- =============================================

CREATE PROCEDURE [dbo].[rpt_ProjectDetails]
AS
BEGIN
	SET NOCOUNT ON;
SELECT PRProject.PRProjectID, PRProject.Name AS ProjectName, PRProject.ProjectNumber, PRProject.StartDate, PRProject.ExpectedEndDate, PRProject.CompleteDate
	, District.Name AS District, PRProject.Description, PRProjectType.Name AS ProjectType, PRProjectStatus.Name AS ProjectStatus
	, ParentProject.Name AS ParentProjectName
FROM PRPROJECT
	INNER JOIN PRProjectType ON PRProject.PRProjectTypeID = PRProjectType.PRProjectTypeID
	INNER JOIN PRProjectStatus ON PRProject.PRProjectStatusID = PRProjectStatus.PRProjectStatusID 
	LEFT OUTER JOIN District ON PRProject.DistrictID = District.DistrictID 
	LEFT OUTER JOIN PRProject AS ParentProject ON PRProject.PRProjectParentID = ParentProject.PRProjectID
END

