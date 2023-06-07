

CREATE PROCEDURE [dbo].[rpt_Contact_Detail_Report_Projects]
@GLOBALENTITYID as varchar(36)
AS
SELECT     PRProject.ProjectNumber, PRProject.Name AS ProjectName, PRProjectType.Name AS ProjectType, PRProjectStatus.Name AS ProjectStatus, PRProject.StartDate, 
                      PRProject.ExpectedEndDate, PRProject.CompleteDate, PRProjectContact.PRProjectID
FROM         PRProjectContact INNER JOIN
                      PRProject ON PRProjectContact.PRProjectID = PRProject.PRProjectID INNER JOIN
                      PRProjectType ON PRProject.PRProjectTypeID = PRProjectType.PRProjectTypeID INNER JOIN
                      PRProjectStatus ON PRProject.PRProjectStatusID = PRProjectStatus.PRProjectStatusID
WHERE PRProjectContact.GlobalEntityID = @GLOBALENTITYID

