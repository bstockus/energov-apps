﻿

CREATE PROCEDURE [dbo].[rpt_PL_Plan_Detail_Report_Conditions]
@PLANID AS VARCHAR(36)
AS
SELECT CONDITIONCATEGORY.NAME AS CONDITIONCATEGORY, CONDITION.NAME AS CONDITION, CONDITION.COMMENTS, 
       PLPLANCONDITION.CREATEDON, PLPLANCONDITION.ISSATISFIED 
FROM PLPLANCONDITION 
INNER JOIN CONDITION ON PLPLANCONDITION.CONDITIONID = CONDITION.CONDITIONID 
INNER JOIN CONDITIONCATEGORY ON CONDITION.CONDITIONCATEGORYID = CONDITIONCATEGORY.CONDITIONCATEGORYID   
WHERE PLPLANCONDITION.PLANID = @PLANID


