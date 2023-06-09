﻿CREATE PROCEDURE [dbo].[LINKED_RECORDS_COUNT]
	@ENTITY_ID as CHAR(36),
	@MODULE_TYPE as CHAR(36),
	@USER_ID as CHAR(36)
AS
Declare @Total_Linked_Permits int,
		@Total_Linked_Prof_Licenses int,		
		@Total_Linked_Business_Licenses int,
		@TOTAL_APPLICATION_COUNT int,
		@TOTAL_RENEWAL_CASES_COUNT int,
		@TOTAL_INSPECTION_COUNT int,
		@TOTAL_INSPECTIONCASE_COUNT int,
		@Total_Linked_Plans int,
		@Total_Linked_Code_Cases int,
		@Total_Impact_Cases int,
		@TOTAL_PROJECT_COUNT int,
		@TOTAL_REQUEST_COUNT int,
		@TOTAL_RENTAL_PROPERTIES_COUNT int,
		@TOTAL_TAX_REMITTANCE_COUNT int,
		@TOTAL_BUSINESSES_COUNT int,
		@TOTAL_LAND_LORD_LICENSES_COUNT int,
		@TOTAL_VIOLATIONS_COUNT int,	
	    @BLLICENSETYPEMODULEID_BUSINESS_LICENSE int = 1, /* Business License */
		@BLLICENSETYPEMODULEID_RENTAL_PROPERTY int = 2, /* Rental Property */
		@BLEXTCOMPANYTYPEMODULEID_BUSINESS int=1, /* Business */
		@BLEXTCOMPANYTYPEMODULEID_LANDLORD int=2 /* Landlord */

	IF (@MODULE_TYPE = 'PermitManagement')
	BEGIN
		SELECT @Total_Linked_Permits = Count(*) FROM DBO.LINKEDPERMITFROMPERMIT(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Prof_Licenses = Count(*) FROM DBO.LINKEDPROFLICENSEFROMPERMIT(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Business_Licenses = Count(*) FROM DBO.LINKEDBUSINESSLICENSEFROMPERMIT(@ENTITY_ID, @USER_ID, @BLLICENSETYPEMODULEID_BUSINESS_LICENSE)
		SELECT @TOTAL_RENTAL_PROPERTIES_COUNT = Count(*) FROM DBO.LINKEDBUSINESSLICENSEFROMPERMIT(@ENTITY_ID, @USER_ID, @BLLICENSETYPEMODULEID_RENTAL_PROPERTY)
		SELECT @Total_Linked_Plans = Count(*) FROM DBO.LINKEDPLANFROMPERMIT(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Code_Cases = Count(*) FROM DBO.LINKEDCODECASEFROMPERMIT(@ENTITY_ID, @USER_ID)
		SELECT @Total_Impact_Cases = Count(*) FROM DBO.LINKEDIMPACTCASESFROMPERMIT(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_RENEWAL_CASES_COUNT = Count(*) FROM DBO.LINKEDRENEWALCASEFROMPERMIT(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_APPLICATION_COUNT = Count(*) FROM DBO.LINKEDAPPLICATIONFROMPERMITPLAN(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_INSPECTION_COUNT = Count(*) FROM DBO.LINKEDINSPECTIONFROMPARENTRECORD(@ENTITY_ID, @USER_ID)
		EXEC LINKED_INSPECTIONCASES_COUNT @ENTITY_ID, @USER_ID, @TOTAL_INSPECTIONCASE_COUNT = @TOTAL_INSPECTIONCASE_COUNT OUTPUT
	END
	IF (@MODULE_TYPE = 'PlanManagement')
	BEGIN
		SELECT @Total_Linked_Permits = Count(*) FROM DBO.LINKEDPERMITFROMPLAN(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Prof_Licenses = Count(*) FROM DBO.LINKEDPROFLICENSEFROMPLAN(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Plans = Count(*) FROM DBO.LINKEDPLANFROMPLAN(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Business_Licenses = Count(*) FROM DBO.LINKEDBUSINESSLICENSEFROMPLAN(@ENTITY_ID, @USER_ID, @BLLICENSETYPEMODULEID_BUSINESS_LICENSE)
		SELECT @TOTAL_RENTAL_PROPERTIES_COUNT = Count(*) FROM DBO.LINKEDBUSINESSLICENSEFROMPLAN(@ENTITY_ID, @USER_ID, @BLLICENSETYPEMODULEID_RENTAL_PROPERTY)
		SELECT @Total_Linked_Code_Cases = Count(*) FROM DBO.LINKEDCODECASEFROMPLAN(@ENTITY_ID, @USER_ID)
		SELECT @Total_Impact_Cases = Count(*) FROM DBO.LINKEDIMPACTCASESFROMPLAN(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_APPLICATION_COUNT = Count(*) FROM DBO.LINKEDAPPLICATIONFROMPERMITPLAN(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_INSPECTION_COUNT = Count(*) FROM DBO.LINKEDINSPECTIONFROMPARENTRECORD(@ENTITY_ID, @USER_ID)
		EXEC LINKED_INSPECTIONCASES_COUNT @ENTITY_ID, @USER_ID, @TOTAL_INSPECTIONCASE_COUNT = @TOTAL_INSPECTIONCASE_COUNT OUTPUT
	END
	IF (@MODULE_TYPE = 'CodeManagement')
	BEGIN
		SELECT @Total_Linked_Permits = Count(*) FROM DBO.LINKEDPERMITFROMCODECASE(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Prof_Licenses = Count(*) FROM DBO.LINKEDPROFLICENSEFROMCODECASE(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Plans = Count(*) FROM DBO.LINKEDPLANFROMCODECASE(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Business_Licenses = Count(*) FROM DBO.LINKEDBUSINESSLICENSEFROMCODECASE(@ENTITY_ID, @USER_ID, @BLLICENSETYPEMODULEID_BUSINESS_LICENSE)
		SELECT @TOTAL_RENTAL_PROPERTIES_COUNT = Count(*) FROM DBO.LINKEDBUSINESSLICENSEFROMCODECASE(@ENTITY_ID, @USER_ID, @BLLICENSETYPEMODULEID_RENTAL_PROPERTY)
		SELECT @TOTAL_BUSINESSES_COUNT = Count(*) FROM DBO.LINKEDBUSINESSFROMCODECASE(@ENTITY_ID, @BLEXTCOMPANYTYPEMODULEID_BUSINESS)
		SELECT @Total_Linked_Code_Cases = Count(*) FROM DBO.LINKEDCODECASEFROMCODECASE(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_INSPECTION_COUNT = Count(*) FROM DBO.LINKEDINSPECTIONFROMPARENTRECORD(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_REQUEST_COUNT = Count(*) FROM DBO.LINKEDREQUESTFROMCODECASE(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_VIOLATIONS_COUNT =  Count(*) FROM DBO.LINKEDVIOLATIONFROMCODECASE(@ENTITY_ID)	
		SELECT @TOTAL_LAND_LORD_LICENSES_COUNT =  Count(*) FROM DBO.LINKEDBUSINESSFROMCODECASE(@ENTITY_ID, @BLEXTCOMPANYTYPEMODULEID_LANDLORD)	
		EXEC LINKED_INSPECTIONCASES_COUNT @ENTITY_ID, @USER_ID, @TOTAL_INSPECTIONCASE_COUNT = @TOTAL_INSPECTIONCASE_COUNT OUTPUT
	END
	IF (@MODULE_TYPE = 'ContactManagement')
	BEGIN
		SELECT @Total_Linked_Permits = Count(*) FROM DBO.LINKEDPERMITFROMCONTACT(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Prof_Licenses = Count(*) FROM DBO.LINKEDPROFLICENSEFROMCONTACT(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Business_Licenses = Count(*) FROM DBO.LINKEDBUSINESSLICENSEFROMCONTACT(@ENTITY_ID, @USER_ID, @BLLICENSETYPEMODULEID_BUSINESS_LICENSE)
		SELECT @Total_Linked_Plans = Count(*) FROM DBO.LINKEDPLANFROMCONTACT(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Code_Cases = Count(*) FROM DBO.LINKEDCODECASEFROMCONTACT(@ENTITY_ID, @USER_ID)
		SELECT @Total_Impact_Cases = Count(*) FROM DBO.LINKEDIMPACTCASESFROMCONTACT(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_APPLICATION_COUNT = Count(*) FROM DBO.LINKEDAPPLICATIONFROMCONTACT(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_RENEWAL_CASES_COUNT = Count(*) FROM DBO.LINKEDRENEWALCASEFROMCONTACT(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_INSPECTION_COUNT = Count(*) FROM DBO.LINKEDINSPECTIONFROMCONTACT(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_PROJECT_COUNT = Count(*) FROM DBO.LINKEDPROJECTFROMCONTACT(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_REQUEST_COUNT = Count(*) FROM DBO.LINKEDREQUESTFROMCONTACT(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_RENTAL_PROPERTIES_COUNT = Count(*) FROM DBO.LINKEDBUSINESSLICENSEFROMCONTACT(@ENTITY_ID, @USER_ID, @BLLICENSETYPEMODULEID_RENTAL_PROPERTY)
		SELECT @TOTAL_TAX_REMITTANCE_COUNT = Count(*) FROM DBO.LINKEDTAXREMITTANCEFROMCONTACT(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_BUSINESSES_COUNT = Count(*) FROM DBO.LINKEDBUSSINESSFROMCONTACT(@ENTITY_ID, @BLEXTCOMPANYTYPEMODULEID_BUSINESS) 
		SELECT @TOTAL_LAND_LORD_LICENSES_COUNT =  Count(*) FROM DBO.LINKEDBUSSINESSFROMCONTACT(@ENTITY_ID, @BLEXTCOMPANYTYPEMODULEID_LANDLORD)
	END
	IF (@MODULE_TYPE = 'ProjectManagement')
	BEGIN
		SELECT @Total_Linked_Permits = Count(*) FROM DBO.LINKEDPERMITFROMPROJECT(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Plans = Count(*) FROM DBO.LINKEDPLANFROMPROJECT(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Code_Cases = Count(*) FROM DBO.LINKEDCODECASEFROMPROJECT(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_INSPECTION_COUNT = Count(*) FROM DBO.LINKEDINSPECTIONFROMPROJECT(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_APPLICATION_COUNT = Count(*) FROM DBO.LINKEDAPPLICATIONFROMPROJECT(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_REQUEST_COUNT = Count(*) FROM DBO.LINKEDREQUESTFROMPROJECT(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'BusinessLicenseManagement')
	BEGIN
		SELECT @Total_Linked_Permits = Count(*) FROM DBO.LINKEDPERMITFROMBUSINESSLICENSE(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Business_Licenses = Count(*) FROM DBO.LINKEDBUSINESSLICENSEFROMBUSINESSLICENSE(@ENTITY_ID, @USER_ID, @BLLICENSETYPEMODULEID_BUSINESS_LICENSE)
		SELECT @TOTAL_RENTAL_PROPERTIES_COUNT = Count(*) FROM DBO.LINKEDBUSINESSLICENSEFROMBUSINESSLICENSE(@ENTITY_ID, @USER_ID, @BLLICENSETYPEMODULEID_RENTAL_PROPERTY)
		SELECT @Total_Linked_Plans = Count(*) FROM DBO.LINKEDPLANFROMBUSINESSLICENSE(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Code_Cases = Count(*) FROM DBO.LINKEDCODECASEFROMBUSINESSLICENSE(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_INSPECTION_COUNT = Count(*) FROM DBO.LINKEDINSPECTIONFROMPARENTRECORD(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_LAND_LORD_LICENSES_COUNT = Count(*) FROM DBO.LINKEDBUSINESSFROMBUSINESSLICENSE(@ENTITY_ID, @BLEXTCOMPANYTYPEMODULEID_LANDLORD)
		EXEC LINKED_INSPECTIONCASES_COUNT @ENTITY_ID, @USER_ID, @TOTAL_INSPECTIONCASE_COUNT = @TOTAL_INSPECTIONCASE_COUNT OUTPUT
	END
	IF (@MODULE_TYPE = 'BusinessLicenseEntity')
	BEGIN
		SELECT @Total_Linked_Business_Licenses = Count(*) FROM DBO.LINKEDBUSINESSLICENSEFROMBUSINESS(@ENTITY_ID, @USER_ID, @BLLICENSETYPEMODULEID_BUSINESS_LICENSE)
		SELECT @TOTAL_BUSINESSES_COUNT = Count(*) FROM DBO.LINKEDBUSINESSFROMBUSINESS(@ENTITY_ID,@BLEXTCOMPANYTYPEMODULEID_BUSINESS)
		SELECT @TOTAL_TAX_REMITTANCE_COUNT = Count(*) FROM DBO.LINKEDTAXREMITTANCEFROMBUSINESS(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_INSPECTION_COUNT = Count(*) FROM DBO.LINKEDINSPECTIONFROMPARENTRECORD(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Code_Cases = Count(*) FROM DBO.LINKEDCODECASEFROMBUSINESS(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_LAND_LORD_LICENSES_COUNT =  Count(*) FROM DBO.LINKEDBUSINESSFROMBUSINESS(@ENTITY_ID, @BLEXTCOMPANYTYPEMODULEID_LANDLORD)
		SELECT @TOTAL_RENTAL_PROPERTIES_COUNT = Count(*) FROM DBO.LINKEDBUSINESSLICENSEFROMBUSINESS(@ENTITY_ID, @USER_ID, @BLLICENSETYPEMODULEID_RENTAL_PROPERTY)
		EXEC LINKED_INSPECTIONCASES_COUNT @ENTITY_ID, @USER_ID, @TOTAL_INSPECTIONCASE_COUNT = @TOTAL_INSPECTIONCASE_COUNT OUTPUT
	END
	IF (@MODULE_TYPE = 'PropertyManagement')
	BEGIN
		SELECT @Total_Linked_Permits = Count(*) FROM DBO.LINKEDPERMITFROMPROPERTYMANAGEMENT(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Code_Cases = Count(*) FROM DBO.LINKEDCODECASEFROMPROPERTYMANAGEMENT(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_PROJECT_COUNT = Count(*) FROM DBO.LINKEDPROJECTFROMPROPERTYMANAGEMENT(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Plans = Count(*) FROM DBO.LINKEDPLANFROMPROPERTYMANAGEMENT(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_REQUEST_COUNT = Count(*) FROM DBO.LINKEDREQUESTFROMPROPERTYMANAGEMENT(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Prof_Licenses = Count(*) FROM DBO.LINKEDPROFLICENSEFROMPROPERTYMANAGEMENT(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_INSPECTION_COUNT = Count(*) FROM DBO.LINKEDINSPECTIONFROMPROPERTYMANAGEMENT(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_BUSINESSES_COUNT = Count(*) FROM DBO.LINKEDBUSINESSFROMPROPERTYMANAGEMENT(@ENTITY_ID, @BLEXTCOMPANYTYPEMODULEID_BUSINESS)
		SELECT @TOTAL_LAND_LORD_LICENSES_COUNT = Count(*) FROM DBO.LINKEDBUSINESSFROMPROPERTYMANAGEMENT(@ENTITY_ID, @BLEXTCOMPANYTYPEMODULEID_LANDLORD)
		SELECT @TOTAL_RENTAL_PROPERTIES_COUNT = Count(*) FROM DBO.LINKEDBUSINESSLICENSEFROMPROPERTYMANAGEMENT(@ENTITY_ID, @USER_ID, @BLLICENSETYPEMODULEID_RENTAL_PROPERTY)
		SELECT @TOTAL_APPLICATION_COUNT = Count(*) FROM DBO.LINKEDAPPLICATIONFROMPROPERTYMANAGEMENT(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Business_Licenses = Count(*) FROM DBO.LINKEDBUSINESSLICENSEFROMPROPERTYMANAGEMENT(@ENTITY_ID, @USER_ID, @BLLICENSETYPEMODULEID_BUSINESS_LICENSE)
	END
	IF (@MODULE_TYPE = 'IndividualLicense')
	BEGIN
		SELECT @Total_Linked_Permits = Count(*) FROM DBO.LINKEDPERMITFROMPROFESSIONALLICENSE(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Plans = Count(*) FROM DBO.LINKEDPLANFROMPROFESSIONALLICENSE(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Code_Cases = Count(*) FROM DBO.LINKEDCODECASEFROMPROFESSIONALLICENSE(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_INSPECTION_COUNT = Count(*) FROM DBO.LINKEDINSPECTIONFROMPARENTRECORD(@ENTITY_ID, @USER_ID)
		EXEC LINKED_INSPECTIONCASES_COUNT @ENTITY_ID, @USER_ID, @TOTAL_INSPECTIONCASE_COUNT = @TOTAL_INSPECTIONCASE_COUNT OUTPUT
	END
	IF (@MODULE_TYPE = 'ApplicationManagement')
	BEGIN
		SELECT @Total_Linked_Permits = Count(*) FROM DBO.LINKEDPERMITFROMAPPLICATION(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Plans = Count(*) FROM DBO.LINKEDPLANFROMAPPLICATION(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'ImpactManagement')
	BEGIN
		SELECT @Total_Linked_Permits = Count(*) FROM DBO.LINKEDPERMITFROMIMPACTCASE(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Plans = Count(*) FROM DBO.LINKEDPLANFROMIMPACTCASE(@ENTITY_ID, @USER_ID)
	END
	IF (@MODULE_TYPE = 'ObjectManagement')
	BEGIN
		SELECT @Total_Linked_Permits = Count(*) FROM DBO.LINKEDPERMITFROMOBJECTCASE(@ENTITY_ID, @USER_ID)
		SELECT @Total_Linked_Plans = Count(*) FROM DBO.LINKEDPLANFROMOBJECTCASE(@ENTITY_ID, @USER_ID)
		SELECT @TOTAL_INSPECTION_COUNT = Count(*) FROM DBO.LINKEDINSPECTIONFROMOBJECTCASE(@ENTITY_ID, @USER_ID)
	END
SELECT @Total_Linked_Permits as TOTAL_PERMIT_ROWS, @Total_Linked_Prof_Licenses as TOTAL_PROF_LICENSES_ROWS, 
 @Total_Linked_Business_Licenses as TOTAL_BUSINESS_LICENSES_ROWS, 
@TOTAL_APPLICATION_COUNT as TOTAL_APPLICATIONS_ROWS, @TOTAL_RENEWAL_CASES_COUNT as TOTAL_RENEWAL_CASES_ROWS,
@TOTAL_INSPECTIONCASE_COUNT as TOTAL_INSPECTIONCASE_ROWS, @TOTAL_INSPECTION_COUNT as TOTAL_INSPECTION_ROWS,
@Total_Linked_Plans as TOTAL_PLAN_ROWS,@Total_Linked_Code_Cases as TOTAL_CODE_CASE_ROWS,
@Total_Impact_Cases as TOTAL_IMPACT_CASES_ROWS, @TOTAL_PROJECT_COUNT as TOTAL_PROJECT_ROWS, @TOTAL_REQUEST_COUNT as TOTAL_REQUEST_ROWS,@TOTAL_RENTAL_PROPERTIES_COUNT as TOTAL_RENTAL_PROPERTIES_ROW, @TOTAL_TAX_REMITTANCE_COUNT as TAX_REMITTANCE_ROWS,
@TOTAL_BUSINESSES_COUNT as TOTAL_BUSINESSES_ROWS,@TOTAL_LAND_LORD_LICENSES_COUNT as TOTAL_LAND_LORD_LICENSES_ROW,
@TOTAL_VIOLATIONS_COUNT as TOTAL_VIOLATIONS_ROW