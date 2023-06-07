CREATE FUNCTION [dbo].[UFN_SETTINGS_GET_FORMNAME_BASED_ON_SETTING_NAME]
(
	@SETTINGNAME NVARCHAR(50),
	@FORMID CHAR(36)
)
RETURNS CHAR(36)
AS
BEGIN
	/* If Setting belongs to Integration Settings screen which is a separate screen now in HTML5 System Setup application, return Integration Settings FormId else return same @FORMID */
	IF (@SETTINGNAME IN ('EnableAddressValidationIntegration', 'AddressValidationUrl', 'AddressValidationUserId', 
						'AnywhereCashierHostingUrl', 'AnywhereCashierInvoiceReferenceId', 'AnywhereCashierDepositReferenceId',
						'IsContractorBusinessLicenseIntegrated', 'BusinessLicenseVerificationURL',
						'TIDUseForLogin', 'TIDNonADUserManagementUrl', 'TIDNonADUserNameOrClientIdForAdminAccount', 'TIDNonADPasswordOrClientSecretForAdminAccount',
						'TylerContactSyncEnabled', 'TylerContactURL', 'TylerContactToken', 'EnergovSourceId', 'TylerContactEnabled',
						'IsLicenseIntegrated','StateLicenseServiceURL','StateTemplate','UseLicenseDetailPopup','CopyMappedLicense',
						'AutoUpdateCertificationFromStateLicense','IsNewPermit','IsIssuedPermit','IsNewCertification',						
						/*Appraisal & Tax Integration*/
						'AppraisalTaxIntegrationEnable','AppraisalTaxIntegrationType','AppraisalTaxIntegrationAuthUrl', 'AppraisalTaxIntegrationUserName',
						'AppraisalTaxIntegrationPassword','AppraisalTaxIntegrationUrl', 'AppraisalTaxIntegrationSearchField',
						'AppraisalTaxIntegrationSearchTestValueJurisdiction', 'AppraisalTaxIntegrationSearchTestValueParcelNumber',
						/*EAM Tab*/
						'EnablePMMIntegration','PMMWKOBaseUrl','PMMLoginUrl','PMMWKOCreateUrl','PMMWKOUpdateUrl','PMMWKOTypesUrl','PMMWKOClassesUrl',
						'PMMUserName','PMMPassword','PMMAgencySourceKey','PMMWKOCreateAttempt',
						/*Land Records Tab*/
						'LandRecordsIntegrationEnable', 'LandRecordsIntegrationType', 'LandRecordsIntegrationUrl', 'LandRecordsIntegrationUserName', 'LandRecordsIntegrationPassword',
						'LandRecordsIntegrationSearchField', 'LandRecordsIntegrationSearchFieldMappedTo', 'LandRecordsIntegrationSearchTestValue', 'LandRecordsIntegrationEnableBL',
						'LandRecordsIntegrationEnableCM', 'LandRecordsIntegrationEnablePM', 'LandRecordsIntegrationEnablePL', 'LandRecordsIntegrationEnablePR',
						/*Exchange Server Integration*/
						'ExchangeServerServiceAddress', 'ExchangeServerUserLogin', 'ExchangeServerUserPassword', 
						'ExchangeServerUserDomain', 'ExchangeServerVersion', 'ExchangeServerEnabledProperty', 
						'ExchangeServerSynchMeetings', 'ExchangeServerSynchHearings', 'ExchangeServerSynchInspections', 
						'ExchangeServerSynchTasks', 'ExchangeServerConflictCheckMeetings', 
						'ExchangeServerConflictCheckHearings', 'ExchangeServerConflictCheckInspections', 'ExchangeServerConflictCheckTasks',
						/*Tyler Financial Integration*/
						'EnableTCIntegration','EnableMultiJurisdictionForFinance',
						/*Events*/
						'EventQueueCleanupJobCron', 'EventQueueCleanupJobEnabled', 'EventQueueCleanupProcessDaysLimit', 'EventQueueModuleJobCron', 'EventQueueModuleJobEnabled',
						'EventQueueModulePreProcessorJobCron', 'EventQueueModulePreProcessorJobEnabled', 'PermitExpiredEventPreProcessorBatchSize', 'PermitExpiredEventPreProcessorEnabled',
						/*Content Management*/
						'EnableTCMIntegration', 'TCMServiceUrl', 'TCMDLL', 'TCMUserPassword', 'TCMMasterPassword', 'TCMUserId', 'EnableTcmAttachmentGroupInfoUpdate', 'EnableSendDocumentsByAttachmentGroup',
						/*MobileEyes Integration*/
						'EnableMobileEyesIntegration'
						))
	BEGIN
		SET @FORMID = '6115EBA3-71FF-4CEA-AB43-759135A83E0F' /*Integration Settings FormId*/
	END

	RETURN @FORMID
END