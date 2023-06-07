
CREATE PROCEDURE [dbo].[ADDCOLLABORATION]
-- Add the parameters for the stored procedure here
@CollaborationID char(36),
@ItemReviewID char(36),
@ERProjectID char(36),
@Subject nvarchar(255),
@Message nvarchar(max),
@PostByUser char(36),
@PostDate datetime,
@ApplicationID int		
AS
BEGIN		
	INSERT INTO COLLABORATION 
	VALUES(
	@CollaborationID,
	@ItemReviewID,
	@ERProjectID,
	@Subject,
	@Message,
	@PostByUser,
	@PostDate,
	@ApplicationID,
	0	
	)
END
