

-- =============================================
-- Author:		<Kyong Hwangbo, EnerGov Solutions>	
-- Create date: <9/30/2010>
-- Description:	<Created as a script to pull all permits that are submitted via CAP;
-- The only way to know that a permit has been submitted via web is by the Permit Status, where current permit status = default internet submission status;
-- Once a user (from EnerGov) changes the permit status, it will not be shown in the query;
-- Report(s) using this query:
-- CitizenAccessPermitSubmission.rpt
-- =============================================

CREATE PROCEDURE [dbo].[rpt_CitizenAccessPermitSubmission]

AS
BEGIN
	SET NOCOUNT ON;

SELECT PMPermit.PMPermitID, PermitNumber, PMPermitType.Name AS PermitType, PMPermitWorkClass.Name AS Workclass, PMPermitStatus.Name AS PermitStatus
	, ApplyDate, ExpireDate, IssueDate

FROM PMPermit 
	INNER JOIN PMPermitType ON PMPermit.PMPermitTypeID = PMPermitType.PMPermitTypeID 
	INNER JOIN PMPermitWorkClass ON PMPermit.PMPermitWorkClassID = PMPermitWorkClass.PMPermitWorkClassID 
	INNER JOIN PMPermitStatus ON PMPermit.PMPermitStatusID = PMPermitStatus.PMPermitStatusID 
	
WHERE PMPermitType.AllowInternetSubmission = 'TRUE'
AND PMPermit.PMPermitStatusID = PMPermitType.DEFAULTWEBPMPERMITSTATUSID

END


