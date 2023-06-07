﻿CREATE PROCEDURE [dbo].[USP_GET_QUERYACTIONFTP_FOR_ATTACHMENT]
(
@ATTACHMENTGROUPID CHAR(36),
@QUERYACTIONID CHAR(36)
)
AS
BEGIN	
	SELECT QUERYACTIONFTP.QUERYACTIONFTPID ACTIONFTPID, QUERYACTIONFTP.FTPFILENAMEOPTIONID
		FROM QUERYACTIONFTP 
		WHERE QUERYACTIONFTP.ATTACHMENTGROUPID = @ATTACHMENTGROUPID
		AND QUERYACTIONFTP.QUERYACTIONID = @QUERYACTIONID
END