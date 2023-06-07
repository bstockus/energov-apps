CREATE FUNCTION [dbo].[GETFORMATTEDFORMNAME]
(
	@MENUSDESCRIPTION NVARCHAR(MAX),
	@SUBMENUSDESCRIPTION NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN	
     DECLARE @SFORMATTEDFORMNAME NVARCHAR(MAX) 
	 SET @SFORMATTEDFORMNAME = CASE REPLACE(REPLACE(@MENUSDESCRIPTION, ' ', ''), '.', '')
									WHEN 'ApplicationManagement' THEN REPLACE(REPLACE(REPLACE(@MENUSDESCRIPTION, ' ', ''), '.', ''), 'ApplicationManagement', 'ApplicationMgmt')
									WHEN 'ProfessionalLicense' THEN REPLACE(REPLACE(REPLACE(@MENUSDESCRIPTION, ' ', ''), '.', ''), 'ProfessionalLicense', 'ProfLicense')
									WHEN 'CodeManagement' THEN REPLACE(REPLACE(REPLACE(@MENUSDESCRIPTION, ' ', ''), '.', ''), 'CodeManagement', 'CodeMgmt')
									WHEN 'ContactManagement' THEN REPLACE(REPLACE(REPLACE(@MENUSDESCRIPTION, ' ', ''), '.', ''), 'ContactManagement', 'ContactMgmt')
									WHEN 'ImpactManagement' THEN REPLACE(REPLACE(REPLACE(@MENUSDESCRIPTION, ' ', ''), '.', ''), 'ImpactManagement', 'ImpactMgmt')
									WHEN 'InspectionManagement' THEN REPLACE(REPLACE(REPLACE(@MENUSDESCRIPTION, ' ', ''), '.', ''), 'InspectionManagement', 'InspectionMgmt')
									WHEN 'InspectionManagement' THEN REPLACE(REPLACE(REPLACE(@MENUSDESCRIPTION, ' ', ''), '.', ''), 'InspectionManagement', 'InspectionMgmt')
									WHEN 'ObjectManagement' THEN REPLACE(REPLACE(REPLACE(@MENUSDESCRIPTION, ' ', ''), '.', ''), 'ObjectManagement', 'ObjectMgmt')
									WHEN 'PermitManagement' THEN REPLACE(REPLACE(REPLACE(@MENUSDESCRIPTION, ' ', ''), '.', ''), 'PermitManagement', 'PermitMgmt')
									WHEN 'PlanManagement' THEN REPLACE(REPLACE(REPLACE(@MENUSDESCRIPTION, ' ', ''), '.', ''), 'PlanManagement', 'PlanMgmt')
									WHEN 'ProjectManagement' THEN REPLACE(REPLACE(REPLACE(@MENUSDESCRIPTION, ' ', ''), '.', ''), 'ProjectManagement', 'ProjectMgmt')
									WHEN 'RentalPropertyManagement' THEN REPLACE(REPLACE(REPLACE(@MENUSDESCRIPTION, ' ', ''), '.', ''), 'RentalPropertyManagement', 'RentalPropMgmt')
									WHEN 'TaxRemittanceManagement' THEN REPLACE(REPLACE(REPLACE(@MENUSDESCRIPTION, ' ', ''), '.', ''), 'TaxRemittanceManagement', 'TaxRemittanceMgmt')
									WHEN 'RequestManagement' THEN REPLACE(REPLACE(REPLACE(@MENUSDESCRIPTION, ' ', ''), '.', ''), 'RequestManagement', 'RequestMgmt')
			ELSE   REPLACE(REPLACE(@MENUSDESCRIPTION, ' ', ''), '.', '') END
		+ '_' + 
							CASE REPLACE(REPLACE(REPLACE(@SUBMENUSDESCRIPTION, ' ', ''), '.', ''), '/', '') 
									WHEN 'ProfessionalLicenseReports' THEN REPLACE(REPLACE(REPLACE(@SUBMENUSDESCRIPTION, ' ', ''), '.', ''), 'ProfessionalLicenseReports', 'ProfLicenseReports')
							ELSE REPLACE(REPLACE(REPLACE(@SUBMENUSDESCRIPTION, ' ', ''), '.', ''), '/', '') END

	RETURN @SFORMATTEDFORMNAME
END