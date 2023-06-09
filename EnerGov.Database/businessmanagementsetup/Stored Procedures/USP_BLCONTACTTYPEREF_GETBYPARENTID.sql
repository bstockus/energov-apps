﻿CREATE PROCEDURE [businessmanagementsetup].[USP_BLCONTACTTYPEREF_GETBYPARENTID]
(
@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[BLCONTACTTYPEREF].[CONTACTTYPEEXTID],
	[dbo].[BLCONTACTTYPEREF].[BLCONTACTTYPEID],
	[dbo].[BLCONTACTTYPEREF].[CONTACTTYPEGROUP],
	[dbo].[BLCONTACTTYPEREF].[ISREQUIRED],
	[dbo].[BLCONTACTTYPEREF].[OBJCLASSID],
	[dbo].[BLCONTACTTYPEREF].[OBJTYPEID],
	[dbo].[BLCONTACTTYPEREF].[OBJMODULEID],
	[dbo].[BLCONTACTTYPEREF].[ISDEFAULTONLINECONTACTTYPE],
	[dbo].[BLCONTACTTYPE].[NAME],
	[dbo].[BLCONTACTTYPE].[DESCRIPTION]

FROM [dbo].[BLCONTACTTYPEREF]
JOIN [dbo].[BLCONTACTTYPE] WITH (NOLOCK) ON [BLCONTACTTYPE].[BLCONTACTTYPEID] = [BLCONTACTTYPEREF].[BLCONTACTTYPEID]
WHERE [dbo].[BLCONTACTTYPEREF].[OBJTYPEID] = @PARENTID
END