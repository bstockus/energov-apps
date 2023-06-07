
-- =============================================
-- Author:		<Kyong Hwangbo, EnerGov Solutions>	
-- Create date: <10/1/2010>
-- Description:	<Created as a script to pull all permit limits for a project;
-- Report(s) using this query:
-- ProjectDetails.rpt
-- =============================================

CREATE PROCEDURE [dbo].[rpt_ProjectDetails-PermitLimit]
AS
BEGIN
	SET NOCOUNT ON;
-- Permit Limit Info
SELECT PRProjectPermitLimit.PRProjectID, PRProjectPermitLimit.PRProjectPermitLimitID, PRProjectPermitLimit.PermitLimit, PMPermitType.Name AS PermitType, PMPermitWorkClass.Name AS WorkClass
FROM PRProjectPermitLimit 
	LEFT OUTER JOIN PMPermitType ON PRProjectPermitLimit.PMPermitTypeID = PMPermitType.PMPermitTypeID 
	LEFT OUTER JOIN PMPermitWorkClass ON PRProjectPermitLimit.PMPermitWorkClassID = PMPermitWorkClass.PMPermitWorkClassID 
END

