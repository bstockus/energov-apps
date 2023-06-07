CREATE FUNCTION [dbo].[UFN_GET_SETTING_STRING_LOOKUP_NAME]
(
	@SETTINGNAME NVARCHAR (50),
	@STRINGVALUE nvarchar(MAX)
)
RETURNS nvarchar(MAX)
AS
BEGIN		
	DECLARE @LookupValue nvarchar(MAX);

	--Crystal Reports Provider
	IF(@SETTINGNAME = 'CrystalReportsProvider')
	BEGIN
		
		SET @LookupValue = CASE @STRINGVALUE 
			WHEN 'SQLNCLI11' THEN  'SQL Native Client'
			WHEN 'SQLOLEDB' THEN  'SQL OLE DB'
			ELSE 'Default'
			END	
	END
	--Default Address Type For Copy Permit When Using Unique Address Option. OR Define Main Address Type
	ELSE IF(@SETTINGNAME = 'DefaultAddressTypeWhenCopyPermit' OR @SETTINGNAME = 'DefineMainAddressOnContactSearch')
	BEGIN

		SET @LookupValue = '[none]'
		IF(@STRINGVALUE <> '' AND @STRINGVALUE IS NOT NULL)
		BEGIN
			SET @LookupValue =@STRINGVALUE;			
		END

	END
	--Default contact type for contacts previously associated to company name:
	ELSE IF(@SETTINGNAME = 'DefaultContactTypeForBusiness')
	BEGIN

		SELECT @LookupValue = NAME FROM BLCONTACTTYPE WHERE BLCONTACTTYPEID = @STRINGVALUE

	END
	--Default Invoice ReportId OR Default Payment ReportId
	ELSE IF(@SETTINGNAME = 'DefaultInvoiceReportId' OR @SETTINGNAME = 'DefaultPaymentReportId')
	BEGIN

		select @LookupValue = FRIENDLYNAME from RPTREPORT where RPTREPORTID = @STRINGVALUE

	END
	--Manage My Review Default Status
	ELSE IF(@SETTINGNAME = 'DefaultItemReviewStatusIDForSearch')
	BEGIN

		select @LookupValue = NAME from PLITEMREVIEWSTATUS where PLITEMREVIEWSTATUSID = @STRINGVALUE

	END
	-- Default Correction Type
	ELSE IF(@SETTINGNAME = 'ERDefaultCorrectionTypeID')
	BEGIN

		select @LookupValue = NAME from PLPLANCORRECTIONTYPE where PLPLANCORRECTIONTYPEID = @STRINGVALUE

	END
	-- Global Entity Custom Field Layout OR Parcel Custom Field Layout
	ELSE IF(@SETTINGNAME = 'GlobalEntityCustomFieldLayoutID' OR @SETTINGNAME = 'ParcelCustomFieldLayoutID')
	BEGIN

		select @LookupValue = SNAME from CUSTOMFIELDLAYOUT where GCUSTOMFIELDLAYOUTS = @STRINGVALUE

	END
	-- Refund Payment Method
	ELSE IF(@SETTINGNAME = 'LicenseReconcileRefundPaymentMethodID')
	BEGIN

		select @LookupValue = NAME from CAPAYMENTMETHOD WHERE CAPAYMENTMETHODID = @STRINGVALUE

	END
	
	RETURN ISNULL(@LookupValue,'[none]')
END