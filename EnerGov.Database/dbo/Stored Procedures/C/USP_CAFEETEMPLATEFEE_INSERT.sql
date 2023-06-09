﻿CREATE PROCEDURE [dbo].[USP_CAFEETEMPLATEFEE_INSERT]
(
	@CAFEETEMPLATEFEEID CHAR(36),
	@CAFEETEMPLATEID CHAR(36),
	@CAFEEID CHAR(36),
	@ISMANUAL BIT,
	@FEEDESCRIPTION NVARCHAR(MAX),
	@FEEORDER INT,
	@FEEPRIORITY INT,
	@FEENAME NVARCHAR(50),
	@CACONDITIONGROUPID CHAR(36),
	@CAEXPRESSIONID CHAR(36),
	@ISHIDDEN BIT,
	@ROUNDINGTYPEID INT,
	@ROUNDINGVALUE DECIMAL(20,4),
	@DISPLAYDEFAULTINPUT BIT,
	@DISPLAYSINGLEINPUT BIT,
	@INPUTHIDDEN BIT,
	@ISONLINE BIT,
	@ISDISABLE BIT
)
AS

INSERT INTO [dbo].[CAFEETEMPLATEFEE](
	[CAFEETEMPLATEFEEID],
	[CAFEETEMPLATEID],
	[CAFEEID],
	[ISMANUAL],
	[FEEDESCRIPTION],
	[FEEORDER],
	[FEEPRIORITY],
	[FEENAME],
	[CACONDITIONGROUPID],
	[CAEXPRESSIONID],
	[ISHIDDEN],
	[ROUNDINGTYPEID],
	[ROUNDINGVALUE],
	[DISPLAYDEFAULTINPUT],
	[DISPLAYSINGLEINPUT],
	[INPUTHIDDEN],
	[ISONLINE],
	[ISDISABLE]
)

VALUES
(
	@CAFEETEMPLATEFEEID,
	@CAFEETEMPLATEID,
	@CAFEEID,
	@ISMANUAL,
	@FEEDESCRIPTION,
	@FEEORDER,
	@FEEPRIORITY,
	@FEENAME,
	@CACONDITIONGROUPID,
	@CAEXPRESSIONID,
	@ISHIDDEN,
	@ROUNDINGTYPEID,
	@ROUNDINGVALUE,
	@DISPLAYDEFAULTINPUT,
	@DISPLAYSINGLEINPUT,
	@INPUTHIDDEN,
	@ISONLINE,
	@ISDISABLE
)