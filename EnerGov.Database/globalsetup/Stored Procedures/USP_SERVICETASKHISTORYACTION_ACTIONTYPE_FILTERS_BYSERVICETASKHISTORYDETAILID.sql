﻿CREATE PROCEDURE [globalsetup].[USP_SERVICETASKHISTORYACTION_ACTIONTYPE_FILTERS_BYSERVICETASKHISTORYDETAILID]
(
	@SERVICETASKHISTORYDETAILID	CHAR(36)
)
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT	[dbo].[SERVICETASKHISTORYACTION].[ACTIONTYPE]
	FROM 
		[dbo].[SERVICETASKHISTORYACTION]
	WHERE
		[dbo].[SERVICETASKHISTORYACTION].[SERVICETASKHISTORYDETAILID] = @SERVICETASKHISTORYDETAILID

END