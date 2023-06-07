
CREATE PROCEDURE [dbo].[UPDATEFILEVERSION]
-- Add the parameters for the stored procedure here
@FileVersionID char(36),
@LastChangedOn datetime,
@LastChangedBy char(36),
@LastModified datetime = null
AS
BEGIN			
	DECLARE @RowVersion int
	SELECT @RowVersion = ROWVERSION FROM ERPROJECTFILEVERSION WHERE ERPROJECTFILEVERSIONID = @FileVersionID
	SET @RowVersion = @RowVersion + 1
		
	UPDATE ERPROJECTFILEVERSION 
	SET LASTCHANGEDON = @LastChangedOn, LASTCHANGEDBY = @LastChangedBy, ROWVERSION = @RowVersion, LASTMODIFIED = @LastModified
	WHERE ERPROJECTFILEVERSIONID = @FileVersionID
			
	SELECT @RowVersion AS ROWVERSION
END	
