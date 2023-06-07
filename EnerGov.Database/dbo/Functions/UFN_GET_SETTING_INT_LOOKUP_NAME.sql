CREATE FUNCTION [dbo].[UFN_GET_SETTING_INT_LOOKUP_NAME]
(
	@SETTINGNAME NVARCHAR (50),
	@INTVALUE int
)
RETURNS nvarchar(50)
AS
BEGIN		
	DECLARE @LookupValue nvarchar(50)

	--Appraisal & Tax Search Parameter(s)
	IF(@SETTINGNAME = 'AppraisalTaxIntegrationSearchField')
	BEGIN
		
		SET @LookupValue = CASE @INTVALUE 
			WHEN 1 THEN  'Parcel'
			ELSE '[none]'
			END	
	END
	--Appraisal & Tax Integration Type
	ELSE IF(@SETTINGNAME = 'AppraisalTaxIntegrationType')
	BEGIN

		SET @LookupValue = CASE @INTVALUE 
			WHEN 1 THEN  'iasWorld'						
			ELSE '[none]'
			END
	END
	--Land Records Search Parameter(s)
	ELSE IF(@SETTINGNAME = 'LandRecordsIntegrationSearchField')
	BEGIN
	
		SET @LookupValue = CASE @INTVALUE 
			WHEN 1 THEN  'Parcel'
			WHEN 2 THEN 'Subdivision, Block, Lot'
			ELSE '[none]'
			END
	END
	--Enable Land Records Integration
	ELSE IF(@SETTINGNAME = 'LandRecordsIntegrationType')
	BEGIN		

		SET @LookupValue = CASE @INTVALUE 
			WHEN 1 THEN  'Eagle Recorder'						
			ELSE '[none]'
			END

	END
	--Transport
	ELSE IF(@SETTINGNAME = 'ServiceBusTransport')
	BEGIN
		
		SET @LookupValue = CASE @INTVALUE 
			WHEN 0 THEN  'Azure'						
			ELSE '[none]'
			END
	END
	-- Fail Submittal when
	ELSE IF(@SETTINGNAME = 'SubmittalItemReviewCompletionType')
	BEGIN
		
		SET @LookupValue = CASE @INTVALUE 
			WHEN 1 THEN  'One Item Review Failed'
			WHEN 2 THEN 'All Item Reviews Completed'
			WHEN 3 THEN 'All Item Reviews Completed by Priority'
			ELSE '[none]'
			END
	END
	--Unlock Next Item Review When
	ELSE IF(@SETTINGNAME = 'SubmittalItemReviewNextIRCondition')
	BEGIN
		
		SET @LookupValue = CASE @INTVALUE 
			WHEN 1 THEN  'All Item Reviews Passed'
			WHEN 2 THEN 'All Item Reviews Completed'
			WHEN 3 THEN 'All Item Reviews Failed'
			ELSE '[none]'
			END
	END	
	-- GIS SETTINGS 
	-- Attribute Name Case
	ELSE IF(@SETTINGNAME = 'GISHistoryLayerAttributeNameCase')
	BEGIN
		
		SET @LookupValue = CASE @INTVALUE 
			WHEN 0 THEN 'Both'
			WHEN 1 THEN 'Upper'
			WHEN 2 THEN 'Pascal'
			ELSE '[none]'
			END
	END	
	-- Time Format
	ELSE IF(@SETTINGNAME = 'GISHistoryLayerTimeFormat')
	BEGIN
		
		SET @LookupValue = CASE @INTVALUE 
			WHEN 0 THEN 'Epoch'
			WHEN 1 THEN 'Regular'
			ELSE '[none]'
			END
	END	
	-- Esri Server Type
	ELSE IF(@SETTINGNAME = 'Esri_Server_Type')
	BEGIN
		
		SET @LookupValue = CASE @INTVALUE 
			WHEN 0 THEN 'GIS Server'
			WHEN 1 THEN 'Enterprise Portal'
			WHEN 2 THEN 'Online Portal'
			ELSE '[none]'
			END
	END	

	-- Logging Verbosity
	ELSE IF(@SETTINGNAME = 'LogLevel')
	BEGIN
		
		SET @LookupValue = CASE @INTVALUE 
			WHEN 0 THEN 'Verbose'
			WHEN 1 THEN 'Debug'
			WHEN 2 THEN 'Information'
			WHEN 3 THEN 'Warning'
			WHEN 4 THEN 'Error'
			WHEN 5 THEN 'Fatal'
			ELSE '[none]'
			END
	END	

	RETURN @LookupValue						
END