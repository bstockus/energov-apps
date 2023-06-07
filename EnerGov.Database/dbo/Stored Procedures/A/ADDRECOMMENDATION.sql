

CREATE PROCEDURE [dbo].[ADDRECOMMENDATION]
-- Add the parameters for the stored procedure here
@RecommendationID char(36),	
@ItemReviewID char(36),
@Comments nvarchar(max),	
@CreateDate datetime,	
@AddedByUserID char(36),	
@FileVersionID char(36),
@LastChangedOn datetime,
@LastChangedBy char(36)
AS
BEGIN
	DECLARE @AutoNumber char(20)
	SET @AutoNumber = dbo.GETRECOMMENDAUTONUMBER()
	UPDATE AUTONUMBERSETTINGS SET NEXTVALUE = NEXTVALUE + 1 WHERE CLASSNAME = 'EnerGovBusiness.PlanManagement.MyPlanRecommendation'
	INSERT INTO PLPLANRECOMMENDATION 
	(
	PLPLANRECOMENDATIONID,
	RECOMMENDATION,
	AUTONUMBER,
	PLITEMREVIEWID,
	ERPROJECTFILEVERSIONID,
	CREATEDATE,
	ADDEDBYUSERID,
	LASTCHANGEDON,
	LASTCHANGEDBY
	)
	VALUES(
	@RecommendationID,
	@Comments,
	@AutoNumber,
	@ItemReviewID,
	@FileVersionID,
	@CreateDate,
	@AddedByUserID,
	@LastChangedOn,
	@LastChangedBy)		
END
