﻿CREATE PROCEDURE [dbo].[USP_WORKFLOWACTIONHOLDTYPE_UPDATE]
(
	@WORKFLOWACTIONHOLDTYPEID CHAR(36),
	@WORKFLOWACTIONID CHAR(36),
	@HOLDSETUPID CHAR(36),
	@COMMENTS NVARCHAR(MAX)
)
AS
DECLARE @OUTPUTTABLE as TABLE([WORKFLOWACTIONHOLDTYPEID]  char(36))
UPDATE [dbo].[WORKFLOWACTIONHOLDTYPE] SET
	[WORKFLOWACTIONID] = @WORKFLOWACTIONID,
	[HOLDSETUPID] = @HOLDSETUPID,
	[COMMENTS] = @COMMENTS
OUTPUT inserted.[WORKFLOWACTIONHOLDTYPEID] INTO @OUTPUTTABLE
WHERE
	[WORKFLOWACTIONHOLDTYPEID] = @WORKFLOWACTIONHOLDTYPEID AND 
	[WORKFLOWACTIONID]= @WORKFLOWACTIONID

SELECT * FROM @OUTPUTTABLE