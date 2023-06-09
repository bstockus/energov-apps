﻿CREATE PROCEDURE [businessmanagementsetup].[USP_TXRMTCONTACTTYPEREF_GETBYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[TXRMTCONTACTTYPEREF].[CONTACTTYPEEXTID],
	[dbo].[TXRMTCONTACTTYPEREF].[TXREMITTANCETYPEID],
	[dbo].[TXRMTCONTACTTYPEREF].[BLCONTACTTYPEID],
	[dbo].[TXRMTCONTACTTYPEREF].[CONTACTTYPEGROUPID],
	[dbo].[TXRMTCONTACTTYPEREF].[ISREQUIRED],
	[dbo].[BLCONTACTTYPE].[NAME],
	[dbo].[BLCONTACTTYPE].[DESCRIPTION]
FROM [dbo].[TXRMTCONTACTTYPEREF]
JOIN [dbo].[BLCONTACTTYPE] WITH (NOLOCK) ON [BLCONTACTTYPE].[BLCONTACTTYPEID] = [TXRMTCONTACTTYPEREF].[BLCONTACTTYPEID]
WHERE [dbo].[TXRMTCONTACTTYPEREF].[TXREMITTANCETYPEID] = @PARENTID
ORDER BY [dbo].[BLCONTACTTYPE].[NAME]
END