
CREATE PROCEDURE [dbo].[ADDPLANCORRECTION]
-- Add the parameters for the stored procedure here
@CorrectionID char(36),
@PlanID char(36),
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
	@PlanID,
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
