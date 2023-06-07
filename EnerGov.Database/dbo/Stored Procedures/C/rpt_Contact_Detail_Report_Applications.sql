

CREATE PROCEDURE [dbo].[rpt_Contact_Detail_Report_Applications]
@GLOBALENTITYID as varchar(36)
AS
SELECT     PLApplicationContact.PLApplicationID, PLApplication.APPNumber AS ApplicationNumber, PLApplicationType.ApplicationTypeName AS ApplicationType, 
                      PLApplicationStatus.Status AS ApplicationStatus, PLApplication.ApplicationDate
FROM         PLApplicationContact INNER JOIN
                      PLApplication ON PLApplicationContact.PLApplicationID = PLApplication.PLApplicationID INNER JOIN
                      PLApplicationType ON PLApplication.PLApplicationTypeID = PLApplicationType.PLApplicationTypeID INNER JOIN
                      PLApplicationStatus ON PLApplication.PLApplicationStatusID = PLApplicationStatus.PLApplicationStatusID
WHERE PLApplicationContact.GlobalEntityID = @GLOBALENTITYID

