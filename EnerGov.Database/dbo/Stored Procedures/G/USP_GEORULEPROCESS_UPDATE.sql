﻿CREATE PROCEDURE [dbo].[USP_GEORULEPROCESS_UPDATE]
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

UPDATE [dbo].[GEORULEPROCESS] SET
	[GEORULEID] = @GEORULEID,
	[GEORULEPROCESSTYPEID] = @GEORULEPROCESSTYPEID,
	[GEORULECOMPARERID] = @GEORULECOMPARERID,
	[PROCESSNAME] = @PROCESSNAME,
	[MESSAGETEXT] = @MESSAGETEXT,
	[WORKFLOWSTEPID] = @WORKFLOWSTEPID,
	[WORKFLOWACTIONSTEPID] = @WORKFLOWACTIONSTEPID,
	[COMPARER] = @COMPARER,
	[PRIORITY] = @PRIORITY,
	[PLSUBMITTALTYPEID] = @PLSUBMITTALTYPEID,
	[PLITEMREVIEWTYPEID] = @PLITEMREVIEWTYPEID,
	[GEORULEMULTIRETURNID] = @GEORULEMULTIRETURNID,
	[MULTIRETURNVALUE] = @MULTIRETURNVALUE,
	[GISATTRIBUTENAME] = @GISATTRIBUTENAME

WHERE
	[GEORULEPROCESSID] = @GEORULEPROCESSID