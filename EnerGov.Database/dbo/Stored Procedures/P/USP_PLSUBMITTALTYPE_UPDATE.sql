﻿CREATE PROCEDURE [dbo].[USP_PLSUBMITTALTYPE_UPDATE]
(
 @PLSUBMITTALTYPEID CHAR(36),
 @TYPENAME NVARCHAR(50),
 @DESCRIPTION NVARCHAR(MAX),
 @DAYSUNTILDUE INT,
 @PLSUBMITTALSTATUSID CHAR(36),
 @RESUBMITALDAYSUNTILDUE INT,
 @COPYFAILEDITEMREVIEW BIT,
 @DESCRIPTION_SPANISH NVARCHAR(MAX) = NULL,
 @LASTCHANGEDBY CHAR(36),
 @LASTCHANGEDON DATETIME,
 @ROWVERSION INT	
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)

UPDATE [dbo].[PLSUBMITTALTYPE] 
SET [dbo].[PLSUBMITTALTYPE].[TYPENAME] = @TYPENAME,
    [dbo].[PLSUBMITTALTYPE].[DESCRIPTION] = @DESCRIPTION,
	[dbo].[PLSUBMITTALTYPE].[DAYSUNTILDUE] = @DAYSUNTILDUE,
	[dbo].[PLSUBMITTALTYPE].[PLSUBMITTALSTATUSID] = @PLSUBMITTALSTATUSID,
	[dbo].[PLSUBMITTALTYPE].[RESUMITALDAYSUNTILDUE] = @RESUBMITALDAYSUNTILDUE,
	[dbo].[PLSUBMITTALTYPE].[COPYFAILEDITEMREVIEW] = @COPYFAILEDITEMREVIEW,
	[dbo].[PLSUBMITTALTYPE].[DESCRIPTION_SPANISH] = @DESCRIPTION_SPANISH,
	[dbo].[PLSUBMITTALTYPE].[LASTCHANGEDBY] = @LASTCHANGEDBY,
	[dbo].[PLSUBMITTALTYPE].[LASTCHANGEDON] = @LASTCHANGEDON,
	[dbo].[PLSUBMITTALTYPE].[ROWVERSION] = @ROWVERSION + 1
OUTPUT [inserted].[ROWVERSION] INTO @OUTPUTTABLE

WHERE [dbo].[PLSUBMITTALTYPE].[PLSUBMITTALTYPEID] = @PLSUBMITTALTYPEID
AND	[dbo].[PLSUBMITTALTYPE].[ROWVERSION] = @ROWVERSION

SELECT * FROM @OUTPUTTABLE