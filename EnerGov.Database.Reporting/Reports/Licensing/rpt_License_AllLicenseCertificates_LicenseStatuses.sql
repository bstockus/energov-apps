CREATE PROCEDURE [dbo].[rpt_License_AllLicenseCertificates_LicenseStatuses] AS
	SELECT 
		blls.[NAME] AS LicenseStatusName,
		blls.[BLLICENSESTATUSID] AS LicenseStatusId
	FROM [$(EnerGovDatabase)].[dbo].[BLLICENSESTATUS] blls
	ORDER BY blls.[NAME]
