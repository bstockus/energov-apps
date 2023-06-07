CREATE FUNCTION [events].[ISFREEFORMENABLED_FOR_COMPANYNAME]()
RETURNS BIT
AS
BEGIN
DECLARE 
@UseFreeFormText BIT = 0, 
@IsCAPOnlineEnabled BIT = 0

SELECT @IsCAPOnlineEnabled = [BITVALUE] FROM [dbo].[CAPSETTING] WHERE [NAME] = 'CAPOnlineEnable'
SELECT @UseFreeFormText = [BITVALUE] FROM [dbo].[SETTINGS] WHERE [NAME] = 'UseFreeformTextForCompanyName'

IF(@IsCAPOnlineEnabled = 0 AND @UseFreeFormText = 1)
	RETURN 1

	RETURN 0
END