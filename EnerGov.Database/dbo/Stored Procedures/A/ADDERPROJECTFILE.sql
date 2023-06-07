
CREATE PROCEDURE [dbo].[ADDERPROJECTFILE]
-- Add the parameters for the stored procedure here
@ERProjectFileID char(36),
@ERProjectID char(36),
@FileName nvarchar(200),
@RowVersion int,
@CreateDate datetime,
@AllowRevisionFileUpload bit,
@Pending bit,
@LastChangedBy char(36),
@LastChangedOn datetime	
AS
BEGIN		
	INSERT INTO ERPROJECTFILE 	
	(
	ERPROJECTFILEID,
	ERPROJECTID,
	FILENAME,
	ROWVERSION,
	CREATEDATE,
	ALLOWREVISIONFILEUPLOAD,
	PENDING,
	LASTCHANGEDBY,
	LASTCHANGEDON,
	MARKDELETE		
	)
	VALUES(
	@ERProjectFileID,
	@ERProjectID,
	@FileName,
	@RowVersion,
	@CreateDate,
	@AllowRevisionFileUpload,
	@Pending,
	@LastChangedBy,
	@LastChangedOn,
	0
	)		
END
