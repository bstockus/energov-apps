﻿CREATE PROCEDURE [systemsetup].[USP_COHIDDENCONTACTTYPE_GETBYPARENTID]
(
	@ROLEID CHAR(36)
)
AS
BEGIN
	SELECT		[dbo].[COHIDDENCONTACTTYPE].[COHIDDENCONTACTTYPEID],
				[dbo].[COHIDDENCONTACTTYPE].[SYSTEMMODULEID],
				[dbo].[COHIDDENCONTACTTYPE].[SROLEGUID],
				[dbo].[COHIDDENCONTACTTYPE].[CONTACTTYPEID],
				[dbo].[CMCODECASECONTACTTYPE].[NAME]
	FROM		[dbo].[COHIDDENCONTACTTYPE]
	INNER JOIN	[dbo].[CMCODECASECONTACTTYPE]
	ON			[dbo].[CMCODECASECONTACTTYPE].[CMCODECASECONTACTTYPEID] = [dbo].[COHIDDENCONTACTTYPE].[CONTACTTYPEID]
	WHERE		[dbo].[COHIDDENCONTACTTYPE].[SROLEGUID] = @ROLEID
	ORDER BY	[dbo].[CMCODECASECONTACTTYPE].[NAME] ASC
END