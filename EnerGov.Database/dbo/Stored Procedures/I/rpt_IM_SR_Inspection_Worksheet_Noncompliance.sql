﻿
CREATE PROCEDURE [dbo].[rpt_IM_SR_Inspection_Worksheet_Noncompliance]
@IMINSPECTIONID AS VARCHAR(36)
AS
BEGIN

SELECT IMIC.IMINSPECTIONID,
	IMIC.CODENUMBER,
	IMIC.DEADLINEDATE DEADLINE,
	IMIC.RESOLVEDDATE RESOLVED_DATE,
	IMIC.COMMENTS, 
	IMNCC.NAME CODE_NAME, 
	IMNCC.[DESCRIPTION] CODE_DESCRIPTION,
	IMNCP.NAME RESPONSIBLE_PARTY,
	IMNCR.NAME RISK
FROM IMINSPECTIONNONCOMPLYCODE IMIC
INNER JOIN IMNONCOMPLIANCECODE IMNCC ON IMNCC.IMNONCOMPLIANCECODEID = IMIC.IMNONCOMPLIANCECODEID
INNER JOIN IMNONCOMPLIANCERESPPARTY IMNCP ON IMIC.IMNONCOMPLIANCERESPPARTYID = IMNCP.IMNONCOMPLIANCERESPPARTYID
INNER JOIN IMNONCOMPLIANCERISK IMNCR ON IMNCR.IMNONCOMPLIANCERISKID = IMIC.IMNONCOMPLIANCERISKID
WHERE IMIC.IMINSPECTIONID = @IMINSPECTIONID

END
