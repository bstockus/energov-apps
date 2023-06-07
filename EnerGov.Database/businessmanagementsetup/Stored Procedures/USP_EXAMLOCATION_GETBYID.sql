﻿CREATE PROCEDURE [businessmanagementsetup].[USP_EXAMLOCATION_GETBYID]
(
	@EXAMLOCATIONID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	[dbo].[EXAMLOCATION].[EXAMLOCATIONID],
	[dbo].[EXAMLOCATION].[NAME],
	[dbo].[EXAMLOCATION].[DESCRIPTION],
	[dbo].[EXAMLOCATION].[PAPERBASEDSEATS],
	[dbo].[EXAMLOCATION].[PCBASEDSEATS],
	[dbo].[EXAMLOCATION].[SITTINGDATEAVAILABILITYID],
	[dbo].[EXAMLOCATION].[ACTIVE],
	[dbo].[EXAMLOCATION].[PROMPTLOCATIONDETAILS],
	[dbo].[EXAMLOCATION].[RECURRENCEID],
	[dbo].[EXAMLOCATION].[LASTCHANGEDBY],
	[dbo].[EXAMLOCATION].[LASTCHANGEDON],
	[dbo].[EXAMLOCATION].[ROWVERSION],
	[dbo].[RECURRENCE].[NAME] AS [RECURRENCENAME]
FROM 
	[dbo].[EXAMLOCATION]
LEFT JOIN 
	[dbo].[RECURRENCE] ON [dbo].[EXAMLOCATION].[RECURRENCEID] = [dbo].[RECURRENCE].[RECURRENCEID]
WHERE
	[EXAMLOCATIONID] = @EXAMLOCATIONID  

	EXEC [businessmanagementsetup].[USP_EXAMLOCTIMESLOT_GETBYPARENTID] @EXAMLOCATIONID
	EXEC [businessmanagementsetup].[USP_EXAMSITTINGDATE_GETBYPARENTID] @EXAMLOCATIONID

END