﻿CREATE PROCEDURE [inspectiondashboard].[USP_ADDRESS_ID_FOR_CASE]
	@ID CHAR(36)
AS

SET NOCOUNT ON;

SELECT TOP 1
	[dbo].[PARCELADDRESS].[ADDRESSID]
FROM [dbo].[PLAPPLICATIONADDRESS]
INNER JOIN [dbo].[MAILINGADDRESS] ON [dbo].[MAILINGADDRESS].[MAILINGADDRESSID] = [dbo].[PLAPPLICATIONADDRESS].[MAILINGADDRESSID]
INNER JOIN [dbo].[PARCELADDRESS] ON [dbo].[PARCELADDRESS].[ADDRESSID] = [dbo].[MAILINGADDRESS].[ADDRESSID]
WHERE [dbo].[PLAPPLICATIONADDRESS].[PLAPPLICATIONID] = @ID AND [dbo].[PLAPPLICATIONADDRESS].[MAIN] = 1

UNION ALL

SELECT TOP 1
	[dbo].[PARCELADDRESS].[ADDRESSID]
FROM [dbo].[BLGLOBALENTITYEXTENSIONADDRESS]
INNER JOIN [dbo].[MAILINGADDRESS] ON [dbo].[MAILINGADDRESS].[MAILINGADDRESSID] = [dbo].[BLGLOBALENTITYEXTENSIONADDRESS].[MAILINGADDRESSID]
INNER JOIN [dbo].[PARCELADDRESS] ON [dbo].[PARCELADDRESS].[ADDRESSID] = [dbo].[MAILINGADDRESS].[ADDRESSID]
WHERE [dbo].[BLGLOBALENTITYEXTENSIONADDRESS].[BLGLOBALENTITYEXTENSIONID] = @ID AND [dbo].[BLGLOBALENTITYEXTENSIONADDRESS].[MAIN] = 1

UNION ALL

SELECT TOP 1
	[dbo].[PARCELADDRESS].[ADDRESSID]
FROM [dbo].[BLLICENSEADDRESS]
INNER JOIN [dbo].[MAILINGADDRESS] ON [dbo].[MAILINGADDRESS].[MAILINGADDRESSID] = [dbo].[BLLICENSEADDRESS].[MAILINGADDRESSID]
INNER JOIN [dbo].[PARCELADDRESS] ON [dbo].[PARCELADDRESS].[ADDRESSID] = [dbo].[MAILINGADDRESS].[ADDRESSID]
WHERE [dbo].[BLLICENSEADDRESS].[BLLICENSEID] = @ID AND [dbo].[BLLICENSEADDRESS].[MAIN] = 1

UNION ALL

SELECT TOP 1
	[dbo].[PARCELADDRESS].[ADDRESSID]
FROM [dbo].[CMCODECASEADDRESS]
INNER JOIN [dbo].[MAILINGADDRESS] ON [dbo].[MAILINGADDRESS].[MAILINGADDRESSID] = [dbo].[CMCODECASEADDRESS].[MAILINGADDRESSID]
INNER JOIN [dbo].[PARCELADDRESS] ON [dbo].[PARCELADDRESS].[ADDRESSID] = [dbo].[MAILINGADDRESS].[ADDRESSID]
WHERE [dbo].[CMCODECASEADDRESS].[CMCODECASEID] = @ID AND [dbo].[CMCODECASEADDRESS].[MAIN] = 1

UNION ALL

SELECT TOP 1
	[dbo].[PARCELADDRESS].[ADDRESSID]
FROM [dbo].[ILLICENSEADDRESS]
INNER JOIN [dbo].[MAILINGADDRESS] ON [dbo].[MAILINGADDRESS].[MAILINGADDRESSID] = [dbo].[ILLICENSEADDRESS].[MAILINGADDRESSID]
INNER JOIN [dbo].[PARCELADDRESS] ON [dbo].[PARCELADDRESS].[ADDRESSID] = [dbo].[MAILINGADDRESS].[ADDRESSID]
WHERE [dbo].[ILLICENSEADDRESS].[ILLICENSEID] = @ID AND [dbo].[ILLICENSEADDRESS].[MAIN] = 1

UNION ALL

SELECT TOP 1
	[dbo].[PARCELADDRESS].[ADDRESSID]
FROM [dbo].[IMINSPECTIONADDRESS]
INNER JOIN [dbo].[MAILINGADDRESS] ON [dbo].[MAILINGADDRESS].[MAILINGADDRESSID] = [dbo].[IMINSPECTIONADDRESS].[MAILINGADDRESSID]
INNER JOIN [dbo].[PARCELADDRESS] ON [dbo].[PARCELADDRESS].[ADDRESSID] = [dbo].[MAILINGADDRESS].[ADDRESSID]
WHERE [dbo].[IMINSPECTIONADDRESS].[IMINSPECTIONID] = @ID AND [dbo].[IMINSPECTIONADDRESS].[MAIN] = 1

UNION ALL

SELECT TOP 1
	[dbo].[PARCELADDRESS].[ADDRESSID]
FROM [dbo].[OMOBJECTADDRESS]
INNER JOIN [dbo].[MAILINGADDRESS] ON [dbo].[MAILINGADDRESS].[MAILINGADDRESSID] = [dbo].[OMOBJECTADDRESS].[MAILINGADDRESSID]
INNER JOIN [dbo].[PARCELADDRESS] ON [dbo].[PARCELADDRESS].[ADDRESSID] = [dbo].[MAILINGADDRESS].[ADDRESSID]
WHERE [dbo].[OMOBJECTADDRESS].[OMOBJECTID] = @ID AND [dbo].[OMOBJECTADDRESS].[MAIN] = 1

UNION ALL

SELECT TOP 1
	[dbo].[PARCELADDRESS].[ADDRESSID]
FROM [dbo].[PMPERMITADDRESS]
INNER JOIN [dbo].[MAILINGADDRESS] ON [dbo].[MAILINGADDRESS].[MAILINGADDRESSID] = [dbo].[PMPERMITADDRESS].[MAILINGADDRESSID]
INNER JOIN [dbo].[PARCELADDRESS] ON [dbo].[PARCELADDRESS].[ADDRESSID] = [dbo].[MAILINGADDRESS].[ADDRESSID]
WHERE [dbo].[PMPERMITADDRESS].[PMPERMITID] = @ID AND [dbo].[PMPERMITADDRESS].[MAIN] = 1

UNION ALL

SELECT TOP 1
	[dbo].[PARCELADDRESS].[ADDRESSID]
FROM [dbo].[PLPLANADDRESS]
INNER JOIN [dbo].[MAILINGADDRESS] ON [dbo].[MAILINGADDRESS].[MAILINGADDRESSID] = [dbo].[PLPLANADDRESS].[MAILINGADDRESSID]
INNER JOIN [dbo].[PARCELADDRESS] ON [dbo].[PARCELADDRESS].[ADDRESSID] = [dbo].[MAILINGADDRESS].[ADDRESSID]
WHERE [dbo].[PLPLANADDRESS].[PLPLANID] = @ID AND [dbo].[PLPLANADDRESS].[MAIN] = 1

UNION ALL

SELECT TOP 1
	[dbo].[PARCELADDRESS].[ADDRESSID]
FROM [dbo].[PRPROJECTADDRESS]
INNER JOIN [dbo].[MAILINGADDRESS] ON [dbo].[MAILINGADDRESS].[MAILINGADDRESSID] = [dbo].[PRPROJECTADDRESS].[MAILINGADDRESSID]
INNER JOIN [dbo].[PARCELADDRESS] ON [dbo].[PARCELADDRESS].[ADDRESSID] = [dbo].[MAILINGADDRESS].[ADDRESSID]
WHERE [dbo].[PRPROJECTADDRESS].[PRPROJECTID] = @ID AND [dbo].[PRPROJECTADDRESS].[MAIN] = 1

UNION ALL

SELECT TOP 1
	[dbo].[PARCELADDRESS].[ADDRESSID]
FROM [dbo].[RPPROPERTYADDRESS]
INNER JOIN [dbo].[MAILINGADDRESS] ON [dbo].[MAILINGADDRESS].[MAILINGADDRESSID] = [dbo].[RPPROPERTYADDRESS].[MAILINGADDRESSID]
INNER JOIN [dbo].[PARCELADDRESS] ON [dbo].[PARCELADDRESS].[ADDRESSID] = [dbo].[MAILINGADDRESS].[ADDRESSID]
WHERE [dbo].[RPPROPERTYADDRESS].[RPPROPERTYID] = @ID AND [dbo].[RPPROPERTYADDRESS].[MAIN] = 1

UNION ALL

SELECT TOP 1
	[dbo].[PARCELADDRESS].[ADDRESSID]
FROM [dbo].[CITIZENREQUESTADDRESS]
INNER JOIN [dbo].[MAILINGADDRESS] ON [dbo].[MAILINGADDRESS].[MAILINGADDRESSID] = [dbo].[CITIZENREQUESTADDRESS].[MAILINGADDRESSID]
INNER JOIN [dbo].[PARCELADDRESS] ON [dbo].[PARCELADDRESS].[ADDRESSID] = [dbo].[MAILINGADDRESS].[ADDRESSID]
WHERE [dbo].[CITIZENREQUESTADDRESS].[CITIZENREQUESTID] = @ID AND [dbo].[CITIZENREQUESTADDRESS].[MAIN] = 1

UNION ALL

SELECT TOP 1
	[dbo].[PARCELADDRESS].[ADDRESSID]
FROM [dbo].[TXREMITTANCEACCOUNTADDRESS]
INNER JOIN [dbo].[MAILINGADDRESS] ON [dbo].[MAILINGADDRESS].[MAILINGADDRESSID] = [dbo].[TXREMITTANCEACCOUNTADDRESS].[MAILINGADDRESSID]
INNER JOIN [dbo].[PARCELADDRESS] ON [dbo].[PARCELADDRESS].[ADDRESSID] = [dbo].[MAILINGADDRESS].[ADDRESSID]
WHERE [dbo].[TXREMITTANCEACCOUNTADDRESS].[TXREMITTANCEACCOUNTID] = @ID AND [dbo].[TXREMITTANCEACCOUNTADDRESS].[MAIN] = 1