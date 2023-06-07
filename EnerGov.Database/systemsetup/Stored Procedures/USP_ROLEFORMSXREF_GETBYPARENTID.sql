﻿CREATE PROCEDURE [systemsetup].[USP_ROLEFORMSXREF_GETBYPARENTID]
(
	@ROLEID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON; 
SELECT		[dbo].[ROLEFORMSXREF].[FKFORMSID],
			[dbo].[ROLEFORMSXREF].[FKROLEID],
			[dbo].[FORMS].[FKSUBMENUGUID],
			[dbo].[FORMS].[SCOMMONNAME],
			[dbo].[ROLEFORMSXREF].[BVISIBLE],			
			[dbo].[ROLEFORMSXREF].[BALLOWADD],
			[dbo].[ROLEFORMSXREF].[BALLOWUPDATE],
			[dbo].[ROLEFORMSXREF].[BALLOWDELETE]
FROM		[dbo].[ROLEFORMSXREF]
INNER JOIN	[dbo].[FORMS] ON [dbo].[FORMS].[SFORMSGUID] = [dbo].[ROLEFORMSXREF].[FKFORMSID]
WHERE		[dbo].[ROLEFORMSXREF].[FKROLEID] = @ROLEID
ORDER BY	[dbo].[FORMS].[IORDER]
END