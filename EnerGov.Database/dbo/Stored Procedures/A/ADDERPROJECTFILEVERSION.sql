
CREATE PROCEDURE [dbo].[ADDERPROJECTFILEVERSION]
-- Add the parameters for the stored procedure here
@ERProjectFileVersionID char(36),
@ERProjectFileID char(36),
@ERProjectFileStatusID char(36),
@SaveFileName nvarchar(200),	
@Locked bit,	
@FileVersion int,
@Latest bit,	
@CreateDate datetime,
@RowVersion int,		
@LastChangedOn datetime,
@LastChangedBy char(36),		
@Submitted bit
AS
BEGIN		
	INSERT INTO ERPROJECTFILEVERSION 	
	(
	ERPROJECTFILEVERSIONID,
	ERPROJECTFILEID,
	ERPROJECTFILESTATUSID,
	SAVEFILENAME,
	LOCKED,
	FILEVERSION,
	LATEST,
	CREATEDATE,
	ROWVERSION,
	ALLOWVIEWCORRECTION,
	LASTCHANGEDON,
	LASTCHANGEDBY,
	MARKDELETE,	
	SUBMITTED	
	)
	VALUES(
	@ERProjectFileVersionID,
	@ERProjectFileID,
	@ERProjectFileStatusID,
	@SaveFileName,
	@Locked,
	@FileVersion,
	@Latest,
	@CreateDate,
	@RowVersion,
	0,
	@LastChangedOn,
	@LastChangedBy,
	0,
	@Submitted
	)		
END
