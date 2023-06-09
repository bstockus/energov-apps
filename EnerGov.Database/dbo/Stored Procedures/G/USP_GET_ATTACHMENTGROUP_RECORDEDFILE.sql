﻿CREATE PROCEDURE [dbo].[USP_GET_ATTACHMENTGROUP_RECORDEDFILE]
	@ATTACHMENTID as varchar(36)
AS
BEGIN
	SELECT TOP 1 CASE WHEN [ATTACHMENTGROUP].[RECORDEDFILE] = 1 THEN 'True' ELSE 'False' END AS [RECORDEDFILE]
	FROM [ATTACHMENT]
	LEFT JOIN [ATTACHMENTGROUP] ON [ATTACHMENT].[ATTACHMENTGROUPID] = [ATTACHMENTGROUP].[ATTACHMENTGROUPID]
	WHERE [ATTACHMENT].[ATTACHMENTID] = @ATTACHMENTID
	   OR [ATTACHMENT].[TCMDOCID] = @ATTACHMENTID
END