﻿CREATE PROCEDURE [dbo].[USP_QUERYACTION_UPDATE]
(
	@QUERYACTIONID CHAR(36),
	@ACTIONNAME NVARCHAR(50),
	@CUSTOMMESSAGE NVARCHAR(MAX),
	@ACTIONCLASSNAME NVARCHAR(MAX),
	@PRIORITY INT
)
AS
UPDATE [dbo].[QUERYACTION] SET
	[ACTIONNAME] = @ACTIONNAME,
	[CUSTOMMESSAGE] = @CUSTOMMESSAGE,
	[ACTIONCLASSNAME] = @ACTIONCLASSNAME,
	[PRIORITY] = @PRIORITY
WHERE [QUERYACTIONID] = @QUERYACTIONID