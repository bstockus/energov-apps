﻿CREATE PROCEDURE [globalsetup].[USP_IMINSPECTIONTYPECHKLSTXREF_GETBYPARENTID]
(
@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[IMINSPECTIONTYPECHKLSTXREF].[IMINSPECTIONTYPECHKLSTXREFID],
	[dbo].[IMINSPECTIONTYPECHKLSTXREF].[IMCHECKLISTID],
	[dbo].[IMINSPECTIONTYPECHKLSTXREF].[IMINSPECTIONTYPEID],
	[dbo].[IMINSPECTIONTYPECHKLSTXREF].[SORTORDER],
	[dbo].[IMINSPECTIONTYPECHKLSTXREF].[AUTOADD],
	[dbo].[IMCHECKLIST].[NAME],
	[dbo].[IMCHECKLIST].[DESCRIPTION],	
	ISNULL([dbo].[IMCHECKLISTCATEGORY].[NAME], '') AS [CHECKLISTCATEGORYNAME]
FROM [dbo].[IMINSPECTIONTYPECHKLSTXREF]
INNER JOIN [dbo].[IMCHECKLIST] 
	ON [dbo].[IMCHECKLIST].[IMCHECKLISTID] = [dbo].[IMINSPECTIONTYPECHKLSTXREF].[IMCHECKLISTID]
LEFT JOIN [dbo].[IMCHECKLISTCATEGORY]
	ON [dbo].[IMCHECKLISTCATEGORY].[IMCHECKLISTCATEGORYID] = [dbo].[IMCHECKLIST].[IMCHECKLISTCATEGORYID]
WHERE
	[dbo].[IMINSPECTIONTYPECHKLSTXREF].[IMINSPECTIONTYPEID] = @PARENTID
ORDER BY [dbo].[IMINSPECTIONTYPECHKLSTXREF].[SORTORDER], [dbo].[IMCHECKLIST].[NAME]
END