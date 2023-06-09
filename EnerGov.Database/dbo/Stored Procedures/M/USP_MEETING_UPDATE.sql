﻿CREATE PROCEDURE [dbo].[USP_MEETING_UPDATE]
(
	@MEETINGID CHAR(36),
	@LOCATION NVARCHAR(4000),
	@SUBJECT NVARCHAR(4000),
	@COMMENTS NVARCHAR(MAX),
	@STARTDATE DATETIME,
	@ENDDATE DATETIME,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
UPDATE [dbo].[MEETING] SET
	[LOCATION] = @LOCATION,
	[SUBJECT] = @SUBJECT,
	[COMMENTS] = @COMMENTS,
	[STARTDATE] = @STARTDATE,
	[ENDDATE] = @ENDDATE,
	[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[LASTCHANGEDON] = @LASTCHANGEDON,
	[ROWVERSION] = @ROWVERSION + 1
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
WHERE
	[MEETINGID] = @MEETINGID AND 
	[ROWVERSION]= @ROWVERSION

SELECT * FROM @OUTPUTTABLE