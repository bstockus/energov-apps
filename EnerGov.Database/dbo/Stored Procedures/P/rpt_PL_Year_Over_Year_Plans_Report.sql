﻿

CREATE PROCEDURE [dbo].[rpt_PL_Year_Over_Year_Plans_Report]
@YEAR AS INT
AS
SELECT PLPLAN.PLANNUMBER AS PlanNumber, PLPLANTYPE.PLANNAME AS PlanType, PLPLAN.VALUE AS Valuation, PLPLAN.APPLICATIONDATE AS ApplyDate, 
       PLPLAN.COMPLETEDATE AS CompleteDate, PLPLAN.SQUAREFEET AS SquareFeet
FROM PLPLAN 
INNER JOIN PLPLANTYPE ON PLPLAN.PLPLANTYPEID = PLPLANTYPE.PLPLANTYPEID

