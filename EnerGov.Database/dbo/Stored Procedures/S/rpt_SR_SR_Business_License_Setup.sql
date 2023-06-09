﻿
CREATE PROCEDURE [dbo].[rpt_SR_SR_Business_License_Setup]
AS
SELECT BLLICENSETYPE.NAME AS LicenseType, BLLICENSETYPE.DESCRIPTION AS Description, BLLICENSETYPE.ACTIVE AS Active, BLLICENSETYPE.PREFIX AS Prefix, 
       BLLICENSETYPE.ISRECEIPTSTYPE AS IsReceiptsType, BLLICENSETYPE.ISRENEWABLE AS IsRenewable, BLLICENSETYPE.ALLOWINTERNETSUBMISSION AS AllowInternetSubmission, 
       BLLICENSESTATUS_1.NAME AS DefaultStatus, BLLICENSESTATUS.NAME AS DefaultInternetStatus, BLLICENSETYPE.BLLICENSETYPEID
FROM BLLICENSETYPE 
LEFT OUTER JOIN BLLICENSESTATUS ON BLLICENSETYPE.DEFAULTINTERNETBLLICSTATUSID = BLLICENSESTATUS.BLLICENSESTATUSID 
LEFT OUTER JOIN BLLICENSESTATUS AS BLLICENSESTATUS_1 ON BLLICENSETYPE.DEFAULTSTATUSID = BLLICENSESTATUS_1.BLLICENSESTATUSID

