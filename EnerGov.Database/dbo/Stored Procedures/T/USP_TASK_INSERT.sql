﻿CREATE PROCEDURE [dbo].[USP_TASK_INSERT]
(
	@TASKID CHAR(36),
	@SUBJECT NVARCHAR(200),
	@TASKTEXT NVARCHAR(MAX),
	@STARTDATE DATETIME,
	@DUEDATE DATETIME,
	@TASKSTATUSID INT,
	@TASKPRIORITYID INT,
	@PERCENTCOMPLETE INT,
	@CREATEDBYID CHAR(36),
	@CREATEDON DATETIME,
	@FORMID CHAR(36),
	@UNIQUERECORDID CHAR(36),
	@SHOWONCALENDAR BIT,
	@TASKTYPEID CHAR(36),
	@COMPLETEDDATE DATETIME,
	@LASTCHANGEDBY CHAR(36),
	@LASTCHANGEDON DATETIME,
	@ROWVERSION INT
)
AS
DECLARE @OUTPUTTABLE as TABLE([ROWVERSION]  int)
INSERT INTO [dbo].[TASK](
	[TASKID],
	[SUBJECT],
	[TASKTEXT],
	[STARTDATE],
	[DUEDATE],
	[TASKSTATUSID],
	[TASKPRIORITYID],
	[PERCENTCOMPLETE],
	[CREATEDBYID],
	[CREATEDON],
	[FORMID],
	[UNIQUERECORDID],
	[SHOWONCALENDAR],
	[TASKTYPEID],
	[COMPLETEDDATE],
	[LASTCHANGEDBY],
	[LASTCHANGEDON],
	[ROWVERSION]
)
OUTPUT inserted.[ROWVERSION] INTO @OUTPUTTABLE
VALUES
(
	@TASKID,
	@SUBJECT,
	@TASKTEXT,
	@STARTDATE,
	@DUEDATE,
	@TASKSTATUSID,
	@TASKPRIORITYID,
	@PERCENTCOMPLETE,
	@CREATEDBYID,
	@CREATEDON,
	@FORMID,
	@UNIQUERECORDID,
	@SHOWONCALENDAR,
	@TASKTYPEID,
	@COMPLETEDDATE,
	@LASTCHANGEDBY,
	@LASTCHANGEDON,
	@ROWVERSION
)
SELECT * FROM @OUTPUTTABLE