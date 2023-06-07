CREATE PROCEDURE [dbo].[UPDATECASECORRECTION]
-- Add the parameters for the stored procedure here
@CorrectionID char(36),		
@Comments nvarchar(max),
@CorrectiveAction nvarchar(max),
@IsEReview bit,	
@ResolvedDate datetime,	
@ResolvedByUserID char(36),
@Resolved bit,
@FileVersionID char(36)	
AS
BEGIN		
	UPDATE PLPLANCORRECTION 
	SET COMMENTS = @Comments,		
		ISEREVIEW = @IsEReview,
		RESOLVEDATE = @ResolvedDate,
		RESOLVEDBYUSERID = @ResolvedByUserID,
		RESOLVED = @Resolved,
		ERPROJECTFILEVERSIONID = @FileVersionID,
		CORRECTIVEACTION = @CorrectiveAction
	WHERE PLPLANCORRECTIONID = @CorrectionID
END