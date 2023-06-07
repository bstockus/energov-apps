﻿
CREATE PROCEDURE [dbo].[rpt_SR_Permit_Setup_Fee_Template]
@PMPERMITTYPEID AS VARCHAR(36)
AS
SELECT     CAFEETEMPLATE.CAFEETEMPLATENAME AS FeeTemplate, CAFEETEMPLATEFEE.FEEORDER AS FeeOrder, CAFEETEMPLATEFEE.FEEPRIORITY AS FeePriority, 
                      CAFEETEMPLATEFEE.FEENAME AS FeeName, CAFEETEMPLATEFEE.ISMANUAL AS ManuallyAdded, CAFEETEMPLATEFEE.ISHIDDEN AS IsHidden, 
                      CAFEETEMPLATEFEE.ISONLINE AS IsOnline
FROM         CAFEETEMPLATE INNER JOIN
                      CAFEETEMPLATEFEE ON CAFEETEMPLATE.CAFEETEMPLATEID = CAFEETEMPLATEFEE.CAFEETEMPLATEID INNER JOIN
                      PMPERMITTYPEWORKCLASS ON CAFEETEMPLATE.CAFEETEMPLATEID = PMPERMITTYPEWORKCLASS.CAFEETEMPLATEID
WHERE PMPERMITTYPEWORKCLASS.PMPERMITTYPEID = @PMPERMITTYPEID
