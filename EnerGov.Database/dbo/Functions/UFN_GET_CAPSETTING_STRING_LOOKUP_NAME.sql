CREATE FUNCTION [dbo].[UFN_GET_CAPSETTING_STRING_LOOKUP_NAME]
(
	@CAPSETTINGNAME NVARCHAR(50),
	@STRINGVALUE NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN		
	DECLARE @LookupValue NVARCHAR(MAX);

	-- "CAP Business License Waiting For Review Status" OR "CAP Business License Waiting For Payment Status" OR "CAP Business License Issued Online Status"
	IF(@CAPSETTINGNAME = 'CAPBLLicenseStatusWatingForReview' OR @CAPSETTINGNAME = 'CAPBLLicenseStatusWaitingForPayment' OR @CAPSETTINGNAME = 'CAPBLLicenseStatusIssuedOnline')
	BEGIN
		SELECT @LookupValue = NAME FROM BLLICENSESTATUS WHERE BLLICENSESTATUSID = @STRINGVALUE
	END

	-- "Default District for Online Applications" OR "CAP Permit Online District" OR "CAP Plan Online District"
	ELSE IF(@CAPSETTINGNAME = 'DefaultDistrictForProLicOnlineApplications' OR @CAPSETTINGNAME = 'DefaultDistrictForOnlineBusinessApplications'
			OR @CAPSETTINGNAME = 'CAPPermitDistrictOnlineDefault' OR  @CAPSETTINGNAME = 'CAPPlanDistrictOnlineDefault')
	BEGIN
		SELECT @LookupValue = NAME FROM DISTRICT WHERE DISTRICTID = @STRINGVALUE
	END

	-- "Default Attachment Group"
	ELSE IF(@CAPSETTINGNAME = 'InspectionAttachmentDefaultGroup')
	BEGIN
		SELECT @LookupValue = NAME FROM ATTACHMENTGROUP WHERE ATTACHMENTGROUPID = @STRINGVALUE
	END

	-- "CAP Permit Waiting For Review Status" OR "CAP Permit Waiting For Payment Status" OR "CAP Permit Issued Online Status"
	ELSE IF(@CAPSETTINGNAME = 'CAPPermitStatusWaitingForReview' OR @CAPSETTINGNAME = 'CAPPermitStatusWaitingForPayment' OR @CAPSETTINGNAME = 'CAPPermitStatusIssuedOnline')
	BEGIN
		SELECT @LookupValue = NAME FROM PMPERMITSTATUS WHERE PMPERMITSTATUSID = @STRINGVALUE
	END

	-- "CAP Plan Waiting For Review Status" OR "CAP Plan Waiting For Payment Status" OR "CAP Plan Issued Online Status"
	ELSE IF(@CAPSETTINGNAME = 'CAPPlanStatusWaitingForReview' OR @CAPSETTINGNAME = 'CAPPlanStatusWaitingForPayment' OR @CAPSETTINGNAME = 'CAPPlanStatusIssuedOnline')
	BEGIN
		SELECT @LookupValue = NAME FROM PLPLANSTATUS WHERE PLPLANSTATUSID = @STRINGVALUE
	END

	-- "CAP Professional License Waiting For Review Status" OR "CAP Professional License Waiting For Payment Status" OR "CAP Professional License Issued Online Status"
	ELSE IF(@CAPSETTINGNAME = 'CAPILLicenseStatusWaitingForReview' OR @CAPSETTINGNAME = 'CAPILLicenseStatusWaitingForPayment' OR @CAPSETTINGNAME = 'CAPILLicenseStatusIssuedOnline')
	BEGIN
		SELECT @LookupValue = NAME FROM ILLICENSESTATUS WHERE ILLICENSESTATUSID = @STRINGVALUE
	END

	RETURN ISNULL(@LookupValue, '[none]')
END