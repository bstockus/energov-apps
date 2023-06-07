﻿CREATE PROCEDURE [dbo].[USP_QUERYACTIONHOLDTYPE_INSERT]
(
	@QUERYACTIONHOLDTYPEID CHAR(36),
	@QUERYACTIONID CHAR(36),
	@HOLDSETUPID CHAR(36),
	@COMMENTS NVARCHAR(MAX)
)
AS
DECLARE @OUTPUTTABLE as TABLE([QUERYACTIONHOLDTYPEID]  char(36))
INSERT INTO [dbo].[QUERYACTIONHOLDTYPE](
	[QUERYACTIONHOLDTYPEID],
	[QUERYACTIONID],
	[HOLDSETUPID],
	[COMMENTS]
)
OUTPUT inserted.[QUERYACTIONHOLDTYPEID] INTO @OUTPUTTABLE
VALUES
(
	@QUERYACTIONHOLDTYPEID,
	@QUERYACTIONID,
	@HOLDSETUPID,
	@COMMENTS
)
SELECT * FROM @OUTPUTTABLE