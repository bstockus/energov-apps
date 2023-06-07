﻿CREATE PROCEDURE [dbo].[USP_GEORULEPROCESS_INSERT]
(
	@GEORULEPROCESSID CHAR(36),
	@GEORULEID CHAR(36),
	@GEORULEPROCESSTYPEID CHAR(36),
	@GEORULECOMPARERID INT,
	@PROCESSNAME NVARCHAR(30),
	@MESSAGETEXT NVARCHAR(MAX),
	@WORKFLOWSTEPID CHAR(36),
	@WORKFLOWACTIONSTEPID CHAR(36),
	@COMPARER NVARCHAR(150),
	@PRIORITY INT,
	@PLSUBMITTALTYPEID CHAR(36),
	@PLITEMREVIEWTYPEID CHAR(36),
	@GEORULEMULTIRETURNID INT,
	@MULTIRETURNVALUE NVARCHAR(150),
	@GISATTRIBUTENAME NVARCHAR(250)
)
AS

INSERT INTO [dbo].[GEORULEPROCESS](
	[GEORULEPROCESSID],
	[GEORULEID],
	[GEORULEPROCESSTYPEID],
	[GEORULECOMPARERID],
	[PROCESSNAME],
	[MESSAGETEXT],
	[WORKFLOWSTEPID],
	[WORKFLOWACTIONSTEPID],
	[COMPARER],
	[PRIORITY],
	[PLSUBMITTALTYPEID],
	[PLITEMREVIEWTYPEID],
	[GEORULEMULTIRETURNID],
	[MULTIRETURNVALUE],
	[GISATTRIBUTENAME]
)

VALUES
(
	@GEORULEPROCESSID,
	@GEORULEID,
	@GEORULEPROCESSTYPEID,
	@GEORULECOMPARERID,
	@PROCESSNAME,
	@MESSAGETEXT,
	@WORKFLOWSTEPID,
	@WORKFLOWACTIONSTEPID,
	@COMPARER,
	@PRIORITY,
	@PLSUBMITTALTYPEID,
	@PLITEMREVIEWTYPEID,
	@GEORULEMULTIRETURNID,
	@MULTIRETURNVALUE,
	@GISATTRIBUTENAME
)