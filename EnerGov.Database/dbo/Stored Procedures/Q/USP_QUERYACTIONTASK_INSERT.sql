﻿CREATE PROCEDURE [dbo].[USP_QUERYACTIONTASK_INSERT]
(
	@QUERYACTIONTASKID CHAR(36),
	@QUERYACTIONID CHAR(36),
	@TASKSUBJECT NVARCHAR(MAX),
	@TASKTEXT NVARCHAR(MAX),
	@STARTDATE NVARCHAR(MAX),
	@DUEDATE NVARCHAR(MAX),
	@STARTTIME NVARCHAR(MAX),
	@DUETIME NVARCHAR(MAX),
	@STARTDATEOFFSETDAYS INT,
	@DUEDATEOFFSETDAYS INT,
	@TASKPRIORITYID INT,
	@SHOWONCALENDAR BIT,
	@ASSIGNEDTO NVARCHAR(MAX)
)
AS
DECLARE @OUTPUTTABLE as TABLE([QUERYACTIONTASKID]  char(36))
INSERT INTO [dbo].[QUERYACTIONTASK](
	[QUERYACTIONTASKID],
	[QUERYACTIONID],
	[TASKSUBJECT],
	[TASKTEXT],
	[STARTDATE],
	[DUEDATE],
	[STARTTIME],
	[DUETIME],
	[STARTDATEOFFSETDAYS],
	[DUEDATEOFFSETDAYS],
	[TASKPRIORITYID],
	[SHOWONCALENDAR],
	[ASSIGNEDTO]
)
OUTPUT inserted.[QUERYACTIONTASKID] INTO @OUTPUTTABLE
VALUES
(
	@QUERYACTIONTASKID,
	@QUERYACTIONID,
	@TASKSUBJECT,
	@TASKTEXT,
	@STARTDATE,
	@DUEDATE,
	@STARTTIME,
	@DUETIME,
	@STARTDATEOFFSETDAYS,
	@DUEDATEOFFSETDAYS,
	@TASKPRIORITYID,
	@SHOWONCALENDAR,
	@ASSIGNEDTO
)
SELECT * FROM @OUTPUTTABLE