CREATE PROCEDURE [dbo].[ADDCASECORRECTION]
-- Add the parameters for the stored procedure here
@CorrectionID char(36),
@CaseID char(36),
@ModuleID int,
@CorrectionTypeID char(36),
@ItemReviewID char(36),
@Comments nvarchar(max),
@CorrectiveAction nvarchar(max),
@IsEReview bit,
@CreateDate datetime,
@ResolvedDate datetime,
@AddedByUserID char(36),
@ResolvedByUserID char(36),
@Resolved bit,
@FileVersionID char(36)
AS
BEGIN
	IF @ModuleID = 1
	BEGIN		
		INSERT INTO PLPLANCORRECTION 	
		(
		PLPLANCORRECTIONID,
		PLPLANID,
		PLPLANCORRECTIONTYPEID,
		PLITEMREVIEWID,
		COMMENTS,
		ISEREVIEW,
		CREATEDATE,
		RESOLVEDATE,
		ADDEDBYUSERID,
		RESOLVEDBYUSERID,
		RESOLVED,
		ERPROJECTFILEVERSIONID,
		REPLIED,
		CORRECTIVEACTION
		)
		VALUES(
		@CorrectionID,
		@CaseID,
		@CorrectionTypeID,
		@ItemReviewID,
		@Comments,
		@IsEReview,
		@CreateDate,
		@ResolvedDate,
		@AddedByUserID,
		@ResolvedByUserID,
		@Resolved,
		@FileVersionID,
		0,
		@CorrectiveAction)		
	END
	ELSE IF @ModuleID = 2
	BEGIN
		INSERT INTO PLPLANCORRECTION 	
		(
		PLPLANCORRECTIONID,
		PMPERMITID,
		PLPLANCORRECTIONTYPEID,
		PLITEMREVIEWID,
		COMMENTS,
		ISEREVIEW,
		CREATEDATE,
		RESOLVEDATE,
		ADDEDBYUSERID,
		RESOLVEDBYUSERID,
		RESOLVED,
		ERPROJECTFILEVERSIONID,
		REPLIED,
		CORRECTIVEACTION
		)
		VALUES(
		@CorrectionID,
		@CaseID,
		@CorrectionTypeID,
		@ItemReviewID,
		@Comments,
		@IsEReview,
		@CreateDate,
		@ResolvedDate,
		@AddedByUserID,
		@ResolvedByUserID,
		@Resolved,
		@FileVersionID,
		0,
		@CorrectiveAction)		
	END
END