﻿CREATE PROCEDURE [reviewcoordinator].[USP_SYSTEMTASK_UPDATE]
	@SYSTEMTASKID CHAR (36),	
	@SNOOZETYPEID INT,
	@SNOOZEUNTILDATE DATETIME,
	@PERMITID CHAR(36),
	@PLANID CHAR(36),
	@USERID CHAR(36),
	@CURRENTDATETIME DATETIME AS
BEGIN

	UPDATE dbo.SYSTEMTASK
	SET SNOOZETYPEID = @SNOOZETYPEID,
		SNOOZEUNTILDATE = @SNOOZEUNTILDATE
	WHERE SYSTEMTASKID = @SYSTEMTASKID
	
	IF @PERMITID IS NOT NULL
	BEGIN
		UPDATE		PMPERMIT
		SET			ROWVERSION = ROWVERSION + 1,
					LASTCHANGEDBY = @USERID,
					LASTCHANGEDON = @CURRENTDATETIME
		WHERE PMPERMITID = @PERMITID
	END

	IF @PLANID IS NOT NULL
	BEGIN
		UPDATE		PLPLAN
		SET			ROWVERSION = ROWVERSION + 1,
					LASTCHANGEDBY = @USERID,
					LASTCHANGEDON = @CURRENTDATETIME
		WHERE PLPLANID = @PLANID
	END

END