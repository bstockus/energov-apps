﻿CREATE PROCEDURE [dbo].[USP_GET_ATTACHMENT_NOTES]
	@ATTACHMENTID as varchar(36)
AS
BEGIN
	SELECT TOP 1 [ATTACHMENT].[NOTES]
	FROM [ATTACHMENT]
	WHERE [ATTACHMENT].[ATTACHMENTID] = @ATTACHMENTID
	   OR [ATTACHMENT].[TCMDOCID] = @ATTACHMENTID
END