﻿CREATE PROCEDURE [dbo].[USP_CMCODE_UPDATE]
(
	@CMCODEID CHAR(36),
	@DESCRIPTION NVARCHAR(MAX),
	@CODENUMBER NVARCHAR(50),
	@CMCODECATEGORYID CHAR(36),
	@CORRECTIVEACTION NVARCHAR(MAX),
	@WFACTIONGROUPID CHAR(36),
	@CUSTOMFIELDLAYOUTID CHAR(36),
	@COMPLIANCEDAYSUNTILDUEHIGH INT,
	@CAFEETEMPLATEID CHAR(36),
	@COMPLIANCEDAYSUNTILDUEMED INT,
	@COMPLIANCEDAYSUNTILDUELOW INT,
	@DEFAULTVIOLATIONPRIORITYID CHAR(36),
	@DEFAULTCMCOURTSTATUSID CHAR(36),
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[CMCODE] SET
	[DESCRIPTION] = @DESCRIPTION,
	[CODENUMBER] = @CODENUMBER,
	[CMCODECATEGORYID] = @CMCODECATEGORYID,
	[CORRECTIVEACTION] = @CORRECTIVEACTION,
	[WFACTIONGROUPID] = @WFACTIONGROUPID,
	[CUSTOMFIELDLAYOUTID] = @CUSTOMFIELDLAYOUTID,
	[COMPLIANCEDAYSUNTILDUEHIGH] = @COMPLIANCEDAYSUNTILDUEHIGH,
	[CAFEETEMPLATEID] = @CAFEETEMPLATEID,
	[COMPLIANCEDAYSUNTILDUEMED] = @COMPLIANCEDAYSUNTILDUEMED,
	[COMPLIANCEDAYSUNTILDUELOW] = @COMPLIANCEDAYSUNTILDUELOW,
	[DEFAULTVIOLATIONPRIORITYID] = @DEFAULTVIOLATIONPRIORITYID,
	[DEFAULTCMCOURTSTATUSID] = @DEFAULTCMCOURTSTATUSID,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[CMCODEID] = @CMCODEID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE