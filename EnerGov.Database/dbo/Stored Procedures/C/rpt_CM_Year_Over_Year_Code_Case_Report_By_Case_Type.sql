﻿



CREATE PROCEDURE [dbo].[rpt_CM_Year_Over_Year_Code_Case_Report_By_Case_Type]
@YEAR AS INT
AS
SELECT CMCODECASE.CASENUMBER AS CodeCaseNumber, CMCASETYPE.NAME AS CodeCaseType, CMCODECASE.OPENEDDATE AS OpenedDate, 
       CMCODECASE.CLOSEDDATE AS ClosedDate
FROM CMCODECASE 
INNER JOIN CMCASETYPE ON CMCODECASE.CMCASETYPEID = CMCASETYPE.CMCASETYPEID


