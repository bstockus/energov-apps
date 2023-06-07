﻿CREATE PROCEDURE [inspectiondashboard].[USP_RESOURCE_DELETE_BY_DATE_USER]
(
	@USERID CHAR(36),
	@UNAVAILABLESTARTDATE DATETIME
)
AS

DELETE FROM [dbo].[RESOURCE]
WHERE
	[USERID] = @USERID AND   
	[UNAVAILABLESTARTDATE] <= @UNAVAILABLESTARTDATE AND 
	[UNAVAILABLEENDDATE] >= @UNAVAILABLESTARTDATE

-- BECAUSE WE MAY NOT FIND DATA TO DELETE, MANUALLY SET ROWS UPDATED TO 1
SELECT @@ROWCOUNT AS ROWCOUNTER
SELECT 0 AS ROWSAFFECTED
SELECT @@ROWCOUNT AS ROWCOUNTER