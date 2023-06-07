﻿CREATE PROCEDURE [globalsearch].[USP_RPLANDLORDLICENSE_GETBYIDS_LOOKUP]
(
	@IDS RecordIDs READONLY -- RPLANDLORDLICENSEIDS
)
AS
BEGIN
SET NOCOUNT ON;

SELECT 
	[RPLANDLORDLICENSEID],
	[LANDLORDNUMBER]
FROM [dbo].[RPLANDLORDLICENSE]
WHERE
	 [RPLANDLORDLICENSE].[RPLANDLORDLICENSEID] IN (SELECT [RECORDID] FROM @IDS)

END