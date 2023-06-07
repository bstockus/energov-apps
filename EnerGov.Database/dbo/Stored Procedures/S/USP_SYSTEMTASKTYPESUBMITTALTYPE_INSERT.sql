﻿CREATE PROCEDURE [dbo].[USP_SYSTEMTASKTYPESUBMITTALTYPE_INSERT]
(
	@SYSTEMTASKTYPESUBMITTALTYPEID CHAR(36),
	@SYSTEMTASKTYPEID INT,
	@PLSUBMITTALTYPEID CHAR(36),
	@ACTIVE BIT,
	@PROCESSTYPE INT,
	@ASSIGNTOOBJECT INT,
	@TEAMASSIGNEDTOID CHAR(36),
	@DEFAULTASSIGNEDTOID CHAR(36),
	@DAYSUNTILDUE INT,
	@UPDATEDBYID CHAR(36),
	@UPDATEDON DATETIME,
	@AUTOCLOSESESSION BIT
)
AS

INSERT INTO [dbo].[SYSTEMTASKTYPESUBMITTALTYPE](
	[SYSTEMTASKTYPESUBMITTALTYPEID],
	[SYSTEMTASKTYPEID],
	[PLSUBMITTALTYPEID],
	[ACTIVE],
	[PROCESSTYPE],
	[ASSIGNTOOBJECT],
	[TEAMASSIGNEDTOID],
	[DEFAULTASSIGNEDTOID],
	[DAYSUNTILDUE],
	[UPDATEDBYID],
	[UPDATEDON],
	[AUTOCLOSESESSION]
)

VALUES
(
	@SYSTEMTASKTYPESUBMITTALTYPEID,
	@SYSTEMTASKTYPEID,
	@PLSUBMITTALTYPEID,
	@ACTIVE,
	@PROCESSTYPE,
	@ASSIGNTOOBJECT,
	@TEAMASSIGNEDTOID,
	@DEFAULTASSIGNEDTOID,
	@DAYSUNTILDUE,
	@UPDATEDBYID,
	@UPDATEDON,
	@AUTOCLOSESESSION
)