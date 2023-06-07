

CREATE PROCEDURE [dbo].[rpt_Contact_Detail_Report_Permits]
@GLOBALENTITYID as varchar(36)
AS
SELECT     PMPermitContact.PMPermitID, PMPermit.PermitNumber, PMPermitType.Name AS PermitType, PMPermitWorkClass.Name AS PermitWorkClass, 
                      PMPermitStatus.Name AS PermitStatus, PMPermit.ApplyDate, PMPermit.ExpireDate, PMPermit.IssueDate, PMPermit.FinalizeDate
FROM         PMPermit INNER JOIN
                      PMPermitContact ON PMPermit.PMPermitID = PMPermitContact.PMPermitID INNER JOIN
                      PMPermitType ON PMPermit.PMPermitTypeID = PMPermitType.PMPermitTypeID INNER JOIN
                      PMPermitWorkClass ON PMPermit.PMPermitWorkClassID = PMPermitWorkClass.PMPermitWorkClassID INNER JOIN
                      PMPermitStatus ON PMPermit.PMPermitStatusID = PMPermitStatus.PMPermitStatusID
WHERE PMPermitContact.GlobalEntityID = @GLOBALENTITYID

