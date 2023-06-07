﻿

CREATE PROCEDURE [dbo].[GETCORRECTIONTYPELIST]
-- Add the parameters for the stored procedure here
@CorrectionTypeName nvarchar(max),
@CorrectionTypeDesc nvarchar(max),
@CorrectionTypeCategoryID char(36)
AS
BEGIN	
	IF (@CorrectionTypeName IS NOT NULL)
	BEGIN
		SET @CorrectionTypeName = '%' + @CorrectionTypeName + '%'
	END
	IF (@CorrectionTypeDesc IS NOT NULL)
	BEGIN
		SET @CorrectionTypeDesc = '%' + @CorrectionTypeDesc + '%'
	END
		
	SELECT	DISTINCT PLPLANCORRECTIONTYPE.PLPLANCORRECTIONTYPEID,
			PLPLANCORRECTIONTYPE.NAME,
			PLPLANCORRECTIONTYPE.DESCRIPTION,	
			PLPLANCORRECTIONTYPE.CORRECTIVEACTION,		
			PLCORRECTIONTYPECATEGORY.NAME AS CATEGORYNAME
	FROM PLPLANCORRECTIONTYPE	
	INNER JOIN PLCORRECTIONTYPECATEGORY ON PLCORRECTIONTYPECATEGORY.PLCORRECTIONTYPECATEGORYID = PLPLANCORRECTIONTYPE.PLCORRECTIONTYPECATEGORYID		
	WHERE	(@CorrectionTypeName IS NULL OR PLPLANCORRECTIONTYPE.NAME LIKE @CorrectionTypeName) AND
			(@CorrectionTypeDesc IS NULL OR PLPLANCORRECTIONTYPE.DESCRIPTION LIKE @CorrectionTypeDesc) AND
			(@CorrectionTypeCategoryID IS NULL OR PLPLANCORRECTIONTYPE.PLCORRECTIONTYPECATEGORYID = @CorrectionTypeCategoryID)	
END
