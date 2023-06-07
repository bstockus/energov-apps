﻿
CREATE PROCEDURE [dbo].[GETCONDITION]
-- Add the parameters for the stored procedure here
@ConditionID char(36)	
AS
BEGIN	
	SELECT	DISTINCT CONDITION.CONDITIONID,
			CONDITION.CONDITIONCATEGORYID,
			CONDITIONCATEGORY.NAME AS CATEGORYNAME,
			CONDITION.NAME,			
			CONDITION.DESCRIPTION,
			CONDITION.COMMENTS,
			CONDITION.ISENABLE,
			CONDITION.ORIGINOBJECT,
			CONDITION.ORIGINOBJECTID,
			CONDITION.ORIGINOBJECTNAME
	FROM CONDITION		
	INNER JOIN CONDITIONCATEGORY ON CONDITIONCATEGORY.CONDITIONCATEGORYID = CONDITION.CONDITIONCATEGORYID	
	WHERE (CONDITION.CONDITIONID = @ConditionID)	       
END