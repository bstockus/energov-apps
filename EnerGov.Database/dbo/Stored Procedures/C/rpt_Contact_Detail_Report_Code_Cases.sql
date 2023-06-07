

CREATE PROCEDURE [dbo].[rpt_Contact_Detail_Report_Code_Cases]
@GLOBALENTITYID as varchar(36)
AS
SELECT     CMCodeCaseContact.CMCodeCaseID, CMCodeCase.CaseNumber, CMCaseType.Name AS CaseType, CMCodeCaseStatus.Name AS CaseStatus, Users.FName, 
                      Users.LName, CMCodeCase.OpenedDate, CMCodeCase.ClosedDate
FROM         CMCodeCase INNER JOIN
                      CMCaseType ON CMCodeCase.CMCaseTypeID = CMCaseType.CMCaseTypeID INNER JOIN
                      CMCodeCaseStatus ON CMCodeCase.CMCodeCaseStatusID = CMCodeCaseStatus.CMCodeCaseStatusID INNER JOIN
                      Users ON CMCodeCase.AssignedTo = Users.sUserGUID INNER JOIN
                      CMCodeCaseContact ON CMCodeCase.CMCodeCaseID = CMCodeCaseContact.CMCodeCaseID
WHERE CMCodeCaseContact.GlobalEntityID = @GLOBALENTITYID

