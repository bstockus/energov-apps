﻿CREATE PROCEDURE [common].[USP_BULKREQUEST_GETBYID]
	@BULKREQUESTID CHAR(36)
AS	
	SELECT BULKREQUESTID,
		BULKOBJECT,
		REQUESTDATE
	FROM dbo.[BULKREQUEST]
	WHERE BULKREQUESTID=@BULKREQUESTID