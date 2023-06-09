﻿


-- [dbo].[RPT_PL_Plan_Monthly_Applied_Chart] '20110101','20121201'

CREATE PROCEDURE [dbo].[RPT_PL_Plan_Monthly_Expired_Chart]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME
AS
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE))


 SELECT PLPlan.APPLICATIONDATE, PLPlanType.PLANNAME, PLPlan.PLPLANID
 FROM   PLPLAN 
 INNER JOIN PLPLANTYPE ON PLPlan.PLPLANTYPEID = PLPlanType.PLPLANTYPEID
 WHERE  PLPlan.EXPIREDATE BETWEEN @STARTDATE AND @ENDDATE
  AND PLPlan.EXPIREDATE IS NOT NULL
