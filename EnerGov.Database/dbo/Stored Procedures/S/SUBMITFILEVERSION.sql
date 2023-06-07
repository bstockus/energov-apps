CREATE PROCEDURE [dbo].[SUBMITFILEVERSION]
-- Add the parameters for the stored procedure here
@FileVersionID char(36),
@ERProjectFileStatusID char(36),	
@Submitted bit,
@Latest bit,
@Locked bit
AS
BEGIN			
	DECLARE @RowVersion int
	SELECT @RowVersion = ROWVERSION FROM ERPROJECTFILEVERSION WHERE ERPROJECTFILEVERSIONID = @FileVersionID
	SET @RowVersion = @RowVersion + 1
		
	UPDATE ERPROJECTFILEVERSION 
	SET SUBMITTED = @Submitted, ROWVERSION = @RowVersion, LATEST = @Latest, LOCKED = @Locked, ERPROJECTFILESTATUSID = @ERProjectFileStatusID
	WHERE ERPROJECTFILEVERSIONID = @FileVersionID					
END