﻿
CREATE PROCEDURE [dbo].[rpt_SR_SR_Code_Setup_Fee_Template]

@CMCASETYPEID AS VARCHAR(36)

AS

SELECT	CMCASETYPE.CMCASETYPEID,
		CAFEETEMPLATE.CAFEETEMPLATENAME AS FeeTemplate, 
		CAFEETEMPLATEFEE.FEEORDER AS FeeOrder, CAFEETEMPLATEFEE.FEEPRIORITY AS FeePriority, CAFEETEMPLATEFEE.FEENAME AS FeeName, 
		CAFEETEMPLATEFEE.ISMANUAL AS ManuallyAdded, CAFEETEMPLATEFEE.ISHIDDEN AS IsHidden, CAFEETEMPLATEFEE.ISONLINE AS IsOnline

FROM	CAFEETEMPLATE 
		INNER JOIN CAFEETEMPLATEFEE ON CAFEETEMPLATE.CAFEETEMPLATEID = CAFEETEMPLATEFEE.CAFEETEMPLATEID 
		INNER JOIN CMCASETYPE ON CAFEETEMPLATE.CAFEETEMPLATEID = CMCASETYPE.CAFEETEMPLATEID

WHERE	CMCASETYPE.CMCASETYPEID = @CMCASETYPEID
