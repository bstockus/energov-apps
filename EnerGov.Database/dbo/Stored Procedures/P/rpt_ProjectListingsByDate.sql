

create PROCEDURE [dbo].[rpt_ProjectListingsByDate]
--=============================================================
-- [rpt_ProjectListingsByDate]
--=============================================================
-- Shows all Project Listings
-- 10/14/2010 - Kyong Hwangbo
-- Report(s) using this stored proc:
-- Project Listings by Application Date.rpt

AS
BEGIN
	SET NOCOUNT ON;
	
SELECT PRProject.PRProjectID, PRProject.Name AS ProjectName, PRProject.ProjectNumber
	, PRProjectType.Name AS ProjectType, PRProjectStatus.Name AS ProjectStatus, PRProject.Description, District.Name AS District
	, PRProject.StartDate, PRProject.ExpectedEndDate, PRProject.CompleteDate
	, PRProjectParent.PRProjectID AS ParentPRProjectID, PRProjectParent.Name AS ParentProjectName, PRProjectParent.ProjectNumber AS ParentProjectNumber
	 
FROM PRProject
	INNER JOIN PRProjectType ON PRProject.PRProjectTypeID = PRProjectType.PRProjectTypeID 
	INNER JOIN PRProjectStatus ON PRProject.PRProjectStatusID = PRProjectStatus.PRProjectStatusID 
	INNER JOIN District ON PRProject.DistrictID = District.DistrictID 
	LEFT OUTER JOIN PRProject AS PRProjectParent ON PRProject.PRProjectParentID = PRProjectParent.PRProjectID 
	
END


