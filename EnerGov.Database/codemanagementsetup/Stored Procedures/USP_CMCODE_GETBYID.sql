﻿CREATE PROCEDURE [codemanagementsetup].[USP_CMCODE_GETBYID] (@CMCODEID char(36))
AS
BEGIN
  SELECT
    [dbo].[CMCODE].[CMCODEID],
    [dbo].[CMCODE].[DESCRIPTION],
    [dbo].[CMCODE].[CODENUMBER],
    [dbo].[CMCODE].[CMCODECATEGORYID],
    [dbo].[CMCODE].[CORRECTIVEACTION],
    [dbo].[CMCODE].[WFACTIONGROUPID],
    [dbo].[CMCODE].[CUSTOMFIELDLAYOUTID],
    [dbo].[CMCODE].[COMPLIANCEDAYSUNTILDUEHIGH],
    [dbo].[CMCODE].[CAFEETEMPLATEID],
    [dbo].[CMCODE].[COMPLIANCEDAYSUNTILDUEMED],
    [dbo].[CMCODE].[COMPLIANCEDAYSUNTILDUELOW],
    [dbo].[CMCODE].[DEFAULTVIOLATIONPRIORITYID],
	[dbo].[CMCODE].[DEFAULTCMCOURTSTATUSID],
    [dbo].[CMCODE].[LASTCHANGEDBY],
    [dbo].[CMCODE].[LASTCHANGEDON],
    [dbo].[CMCODE].[ROWVERSION],
    CASE
      WHEN EXISTS (SELECT
          [dbo].[CMVIOLATION].[CMVIOLATIONID]
        FROM [dbo].[CMVIOLATION]
        WHERE [dbo].[CMVIOLATION].[CMCODEID] = [dbo].[CMCODE].[CMCODEID]
        UNION ALL
        SELECT
          [dbo].[IMVIOLATION].[IMVIOLATIONID]
        FROM [dbo].[IMVIOLATION]
        WHERE [dbo].[IMVIOLATION].[CMCODEID] = [dbo].[CMCODE].[CMCODEID]) THEN CAST(1 AS BIT)
      ELSE CAST(0 AS BIT)
    END AS [CODEISINUSE]
  FROM [dbo].[CMCODE]
  WHERE [dbo].[CMCODE].[CMCODEID] = @CMCODEID

  EXEC [codemanagementsetup].[USP_CMCODEREVISION_GETBYPARENTID] @CMCODEID

END