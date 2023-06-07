
CREATE PROCEDURE [dbo].[ADDMARKUPELEMENT]
-- Add the parameters for the stored procedure here
@FileVersionID char(36),
@UniqueID char(36),
@ElementID nvarchar(50),
@CorrectionID char(36),
@PageNumber int,	
@Comments nvarchar(max)	
AS
BEGIN		
	DECLARE @ElementNumber int
	DECLARE @RecommendElementNumber int
	DECLARE @CorrectionElementNumber int
		
	SELECT @RecommendElementNumber = MAX(ERRECOMMENDATIONELEMENT.ELEMENTNUMBER)
	FROM ERRECOMMENDATIONELEMENT		
	INNER JOIN PLPLANRECOMMENDATION ON PLPLANRECOMMENDATION.PLPLANRECOMENDATIONID = ERRECOMMENDATIONELEMENT.PLPLANRECOMMENDATIONID
	WHERE PLPLANRECOMMENDATION.ERPROJECTFILEVERSIONID = @FileVersionID
		
	SELECT @CorrectionElementNumber = MAX(ERMARKUPELEMENT.ELEMENTNUMBER)
	FROM ERMARKUPELEMENT		
	INNER JOIN PLPLANCORRECTION ON PLPLANCORRECTION.PLPLANCORRECTIONID = ERMARKUPELEMENT.PLPLANCORRECTIONID
	WHERE PLPLANCORRECTION.ERPROJECTFILEVERSIONID = @FileVersionID		
		
	IF @RecommendElementNumber IS NOT NULL AND @CorrectionElementNumber IS NOT NULL
	BEGIN
		IF @CorrectionElementNumber > @RecommendElementNumber
		BEGIN
			SET @ElementNumber = @CorrectionElementNumber + 1
		END
		ELSE
		BEGIN
			SET @ElementNumber = @RecommendElementNumber + 1			
		END
	END
	ELSE IF @RecommendElementNumber IS NOT NULL AND @CorrectionElementNumber IS NULL
	BEGIN
		SET @ElementNumber = @RecommendElementNumber + 1
	END
	ELSE IF @RecommendElementNumber IS NULL AND @CorrectionElementNumber IS NOT NULL
	BEGIN
		SET @ElementNumber = @CorrectionElementNumber + 1
	END
	ELSE IF @RecommendElementNumber IS NULL AND @CorrectionElementNumber IS NULL
	BEGIN
		SET @ElementNumber = 1
	END	
		
	INSERT INTO ERMARKUPELEMENT 
	(
	ERMARKUPELEMENTID,
	PLPLANCORRECTIONID,
	PAGENUMBER,
	ELEMENTNUMBER,
	COMMENTS,
	ELEMENTID
	)
	VALUES(
	@UniqueID,
	@CorrectionID,
	@PageNumber,		
	@ElementNumber,
	@Comments,
	@ElementID		
	)	
		
	SELECT @ElementNumber					
END
