﻿CREATE PROCEDURE [managebusinesslicense].[USP_BLLICENSEACTIVITY_GETBYBLLICENSEID]
(
	@ID CHAR(36)
)
AS
BEGIN
	SELECT DISTINCT TOP 15 
		[BLLICENSEACTIVITY].[CREATEDON] ,
		[BLLICENSEACTIVITY].[BLLICENSEACTIVITYID] ,
		[BLLICENSEACTIVITY].[LICENSEACTIVITYNUMBER] ,
		[BLLICENSEACTIVITY].[LICENSEACTIVITYNAME],
		[BLLICENSEACTIVITYTYPE].[NAME]
	FROM 
		[dbo].[BLLICENSEACTIVITY] INNER JOIN [dbo].[BLLICENSEACTIVITYTYPE] 
				ON [BLLICENSEACTIVITY].[BLLICENSEACTIVITYTYPEID] = [BLLICENSEACTIVITYTYPE].[BLLICENSEACTIVITYTYPEID]
	WHERE
			[BLLICENSEACTIVITY].[BLLICENSEID] = @ID 
		AND [BLLICENSEACTIVITY].[BLLICENSEWFACTIONSTEPID] IS NULL
	ORDER BY [BLLICENSEACTIVITY].[CREATEDON] DESC
END