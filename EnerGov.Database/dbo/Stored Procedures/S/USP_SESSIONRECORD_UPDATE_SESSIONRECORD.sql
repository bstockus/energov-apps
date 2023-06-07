
CREATE PROCEDURE [dbo].[USP_SESSIONRECORD_UPDATE_SESSIONRECORD]
  @SessionId CHAR(36),
  @FormId CHAR(36),
  @RecordId CHAR(36),
  @RowVersion INT,
  @IsEdit BIT,
  @UserId CHAR(36),
  @ActiveTime DATETIME
AS
BEGIN

DECLARE @Result int
DECLARE @MaxRowVersion int	
DECLARE @RecordInEdit int
DECLARE @EditByUser char(36)
DECLARE @EditByUserName nvarchar(100)
DECLARE @EditTime datetime
DECLARE @EditFormID char(36)
DECLARE @UpdatedFormID char(36)
SET @RecordInEdit = 0
SET @MaxRowVersion = NULL
SELECT @MaxRowVersion = MAX(ROWVERSION) FROM SESSIONRECORD WHERE RECORDID = @RecordId		
IF @MaxRowVersion IS NULL OR @MaxRowVersion <= @RowVersion
BEGIN		
	SELECT @RecordInEdit = COUNT(*) FROM SESSIONRECORD WHERE RECORDID = @RecordId AND ROWVERSION = @RowVersion AND ISEDIT = 1				
	IF @RecordInEdit = 0
	BEGIN
		SET @Result = 1 /* Record can edit */						
	END
	ELSE
	BEGIN
		SELECT @EditFormID = FORMID, @EditByUser = USERID, @EditTime = ACTIVETIME FROM SESSIONRECORD WHERE RECORDID = @RecordId AND ROWVERSION = @RowVersion AND ISEDIT = 1			
		IF @EditFormID = @FormId
		BEGIN		
			SET @Result = 1	/* Record can edit */			
		END
		ELSE
		BEGIN
			SET @Result = 2 /* Record has been opened for edit by another form or user */			
		END			
	END
END
ELSE
BEGIN
	SELECT @EditByUser = USERID, @EditTime = ACTIVETIME, @UpdatedFormID = FormID FROM SESSIONRECORD WHERE RECORDID = @RecordId AND RowVersion = @MaxRowVersion
    IF @UpdatedFormID = @FormId
    BEGIN
        SET @Result = 1 /* Record can edit */
    END
    ELSE
    BEGIN
        SET @Result = 3 /* Record has been changed and saved by another form or user */			
    END		
END
IF @IsEdit = 1 AND @Result = 1
BEGIN
	IF EXISTS (SELECT * FROM SESSIONRECORD WHERE RECORDID = @RecordId AND FORMID = @FormId) 
	BEGIN
	    UPDATE SESSIONRECORD SET ISEDIT = @IsEdit, ACTIVETIME = @ActiveTime WHERE RECORDID = @RecordId AND SESSIONID = @SessionId AND FORMID = @FormId AND ROWVERSION = @RowVersion
    END
	ELSE
	BEGIN
		INSERT INTO SESSIONRECORD VALUES (@SessionId,@FormId,@RecordId,@RowVersion,@IsEdit,@ActiveTime,@UserId)	
	END
END
ELSE 
BEGIN
	IF EXISTS (SELECT * FROM SESSIONRECORD WHERE RECORDID = @RecordId AND FORMID = @FormId) 
	BEGIN
		UPDATE SESSIONRECORD SET ROWVERSION = @RowVersion, ISEDIT = 0, ACTIVETIME = @ActiveTime WHERE RECORDID = @RecordId AND FORMID = @FormId	
	END
	ELSE
	BEGIN
		INSERT INTO SESSIONRECORD VALUES (@SessionId,@FormId,@RecordId,@RowVersion,@IsEdit,@ActiveTime,@UserId)	
	END
END
IF @Result = 2 OR @Result = 3
BEGIN
	SELECT @EditByUserName = (USERS.FNAME + ' ' + USERS.LNAME) FROM USERS WHERE USERS.SUSERGUID = @EditByUser	
	SELECT @Result AS RecordStatus, @EditByUserName AS UserName, @EditTime AS ActiveTime, @MaxRowVersion AS MaxRowVersion
END
ELSE
BEGIN
	SELECT @Result AS RecordStatus, @MaxRowVersion AS MaxRowVersion
END

END