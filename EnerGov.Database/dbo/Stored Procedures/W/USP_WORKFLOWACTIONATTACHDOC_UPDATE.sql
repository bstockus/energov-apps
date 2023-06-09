﻿CREATE PROCEDURE [dbo].[USP_WORKFLOWACTIONATTACHDOC_UPDATE]
(
	@WORKFLOWACTIONATTACHDOCID CHAR(36),
	@WORKFLOWACTIONID CHAR(36),
	@ATTACHMENTGROUPID CHAR(36) = NULL,
	@NOTES NVARCHAR(MAX),
	@RPTREPORTID CHAR(36)
)
AS

UPDATE [dbo].[WORKFLOWACTIONATTACHDOC] SET
	[WORKFLOWACTIONID] = @WORKFLOWACTIONID,
	[ATTACHMENTGROUPID] = @ATTACHMENTGROUPID,
	[NOTES] = @NOTES,
	[RPTREPORTID] = @RPTREPORTID

WHERE
	[WORKFLOWACTIONATTACHDOCID] = @WORKFLOWACTIONATTACHDOCID