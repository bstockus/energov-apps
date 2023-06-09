﻿CREATE PROCEDURE [businessmanagementsetup].[USP_BLTYPECLASSILCLASS_GETBYPARENTID] (@BLLICENSETYPEID char(36))
AS
BEGIN
  SET NOCOUNT ON;
  SELECT
     [dbo].[BLTYPECLASSILCLASS].[BLTYPECLASSILCLASSID],
     [dbo].[BLTYPECLASSILCLASS].[BLTYPECLASSILTYPEID],
     [dbo].[BLTYPECLASSILCLASS].[ILLICENSECLASSIFICATIONID],
     [dbo].[ILLICENSECLASSIFICATION].[NAME]
   FROM [dbo].[BLTYPECLASSILCLASS]
    INNER JOIN [dbo].[BLTYPECLASSILTYPE]
        ON [dbo].[BLTYPECLASSILTYPE].[BLTYPECLASSILTYPEID] = [dbo].[BLTYPECLASSILCLASS].[BLTYPECLASSILTYPEID]
    INNER JOIN [BLLICENSETYPECLASS]
        ON [dbo].[BLLICENSETYPECLASS].[BLLICENSETYPECLASSID] = [dbo].[BLTYPECLASSILTYPE].[BLLICENSETYPECLASSID]
    INNER JOIN [dbo].[BLLICENSETYPE]
        ON [dbo].[BLLICENSETYPE].[BLLICENSETYPEID] = [dbo].[BLLICENSETYPECLASS].[BLLICENSETYPEID]
    INNER JOIN [dbo].[ILLICENSECLASSIFICATION]
        ON [dbo].[ILLICENSECLASSIFICATION].[ILLICENSECLASSIFICATIONID] = [dbo].[BLTYPECLASSILCLASS].[ILLICENSECLASSIFICATIONID]
   WHERE [dbo].[BLLICENSETYPE].[BLLICENSETYPEID] = @BLLICENSETYPEID
   ORDER BY [dbo].[ILLICENSECLASSIFICATION].[NAME]
END