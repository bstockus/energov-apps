﻿CREATE PROCEDURE [common].[USP_USERNOTIFICATION_SEARCH]
(
	@USER_ID			AS CHAR(36),
	@UNREAD				AS BIT				= 1,
	@PAGE_NUMBER		AS INT				= 1,
	@PAGE_SIZE			AS INT				= 10,
	@IS_ASCENDING		AS BIT				= 0
)
AS
BEGIN
SET NOCOUNT ON;
WITH RAW_DATA AS (
	SELECT [dbo].[NOTIFICATIONS].[NOTIFICATIONSID],
		   [dbo].[NOTIFICATIONS].[SUBJECT],
		   [dbo].[NOTIFICATIONS].[BODY],
		   [dbo].[NOTIFICATIONS].[UNIQUERECORDID],
		   [dbo].[NOTIFICATIONS].[FORMID],
		   [dbo].[USERNOTIFICATION].[DATECREATED],
		   [dbo].[USERNOTIFICATION].[DATEREAD], 
		   CASE @IS_ASCENDING WHEN 1 THEN
				ROW_NUMBER() OVER(ORDER BY [dbo].[USERNOTIFICATION].[DATECREATED])
		   ELSE
				ROW_NUMBER() OVER(ORDER BY [dbo].[USERNOTIFICATION].[DATECREATED] DESC)
		   END AS RowNumber,
		   COUNT(1) OVER() AS TotalRows
	FROM   [dbo].[NOTIFICATIONS] JOIN
		   [dbo].[USERNOTIFICATION]	
		   ON [dbo].[NOTIFICATIONS].[NOTIFICATIONSID] = 
		   [dbo].[USERNOTIFICATION].[NOTIFICATIONSID]
	WHERE  [dbo].[USERNOTIFICATION].[USERID] = @USER_ID 
		   AND 
		  (@UNREAD = 0 OR [dbo].[USERNOTIFICATION].DATEREAD IS NULL)
)

SELECT * FROM RAW_DATA
WHERE
	RowNumber > @PAGE_SIZE * (@PAGE_NUMBER - 1) AND 
	RowNumber <= @PAGE_SIZE * @PAGE_NUMBER
ORDER BY 
	RowNumber
END