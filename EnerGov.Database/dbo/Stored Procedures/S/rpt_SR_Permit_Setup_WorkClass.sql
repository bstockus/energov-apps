﻿
CREATE PROCEDURE [dbo].[rpt_SR_Permit_Setup_WorkClass]
@PMPERMITTYPE AS VARCHAR(36)
AS
SELECT     PMPERMITWORKCLASS.NAME AS WorkClass, WFTEMPLATE.NAME AS WorkflowTemplate, CUSTOMFIELDLAYOUT_1.SNAME AS CustomFieldLayout, 
                      CUSTOMFIELDLAYOUT.SNAME AS OnlineCustomFieldLayout, CAFEETEMPLATE.CAFEETEMPLATENAME AS FeeTemplate, 
                      PMPERMITTYPEWORKCLASS.INTERNETFLAG
FROM         PMPERMITTYPEWORKCLASS INNER JOIN
                      PMPERMITWORKCLASS ON PMPERMITTYPEWORKCLASS.PMPERMITWORKCLASSID = PMPERMITWORKCLASS.PMPERMITWORKCLASSID LEFT OUTER JOIN
                      CAFEETEMPLATE ON PMPERMITTYPEWORKCLASS.CAFEETEMPLATEID = CAFEETEMPLATE.CAFEETEMPLATEID LEFT OUTER JOIN
                      CUSTOMFIELDLAYOUT ON PMPERMITTYPEWORKCLASS.ONLINECUSTOMFIELDLAYOUTID = CUSTOMFIELDLAYOUT.GCUSTOMFIELDLAYOUTS LEFT OUTER JOIN
                      CUSTOMFIELDLAYOUT AS CUSTOMFIELDLAYOUT_1 ON 
                      PMPERMITTYPEWORKCLASS.CUSTOMFIELDLAYOUTID = CUSTOMFIELDLAYOUT_1.GCUSTOMFIELDLAYOUTS LEFT OUTER JOIN
                      WFTEMPLATE ON PMPERMITTYPEWORKCLASS.WFTEMPLATEID = WFTEMPLATE.WFTEMPLATEID
WHERE PMPERMITTYPEWORKCLASS.PMPERMITTYPEID = @PMPERMITTYPE
