CREATE PROCEDURE [dbo].[rpt_License_AllLicenseCertificates_LicenseTypes] AS
	SELECT 
		bllt.[NAME] AS LicenseTypeName,
		bllt.[BLLICENSETYPEID] AS LicenseTypeId
    FROM [$(EnerGovDatabase)].[dbo].[BLLICENSETYPE] bllt
	WHERE bllt.[ACTIVE] = 1
	ORDER BY bllt.[NAME]