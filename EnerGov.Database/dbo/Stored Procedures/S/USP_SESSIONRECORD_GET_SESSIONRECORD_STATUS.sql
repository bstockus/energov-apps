CREATE PROCEDURE [dbo].[USP_SESSIONRECORD_GET_SESSIONRECORD_STATUS]
  @FormId CHAR(36),
  @RecordId CHAR(36),
  @RowVersion INT
AS
BEGIN

DECLARE @Result int
DECLARE @MaxRowVersion int	
DECLARE @RecordInEdit int
DECLARE @EditFormID char(36)
DECLARE @UpdatedFormID char(36)
DECLARE @EditByUser char(36)
DECLARE @EditByUserName nvarchar(100)
DECLARE @EditTime datetime
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
		SELECT @EditFormID = FORMID,@EditByUser = USERID,@EditTime = ACTIVETIME FROM SESSIONRECORD WHERE RECORDID = @RecordId AND ROWVERSION = @RowVersion AND ISEDIT = 1			
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
	SELECT @EditByUser = USERID, @EditTime = ACTIVETIME, @UpdatedFormID = FORMID FROM SESSIONRECORD WHERE RECORDID = @RecordId AND ROWVERSION = @MaxRowVersion    
    IF @UpdatedFormID = @FormId AND @MaxRowVersion = @RowVersion
    BEGIN
        SET @Result = 1 /* Record can edit */
    END
    ELSE
    BEGIN
        SET @Result = 3 /* Record has been changed and saved by another form or user */			
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