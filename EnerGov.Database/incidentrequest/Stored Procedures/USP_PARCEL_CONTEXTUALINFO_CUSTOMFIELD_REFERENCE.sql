﻿/*
  Get Custom Fields reference data for Parcel
*/
CREATE PROCEDURE [incidentrequest].[USP_PARCEL_CONTEXTUALINFO_CUSTOMFIELD_REFERENCE]
AS
BEGIN

	SET NOCOUNT ON;
  
	DECLARE @LayoutId AS CHAR(36) = (SELECT TOP 1 [STRINGVALUE] FROM [dbo].[SETTINGS] WHERE [NAME] = 'ParcelCustomFieldLayoutID');
	DECLARE @CustomSaverTableName AS VARCHAR(100) = 'CUSTOMSAVERSYSTEMSETUP';

	SELECT @LayoutId AS LayoutId; 

	EXEC [incidentrequest].[USP_CUSTOMFIELD_REFERENCE_CUSTOMFIELD] @LayoutId;

	EXEC [incidentrequest].[USP_CUSTOMFIELD_REFERENCE_PICKLISTITEM] @LayoutId;

	EXEC [incidentrequest].[USP_CUSTOMFIELD_REFERENCE_SAVERTABLE] @CustomSaverTableName;

END