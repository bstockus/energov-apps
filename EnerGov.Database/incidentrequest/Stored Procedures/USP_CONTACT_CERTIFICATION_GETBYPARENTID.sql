﻿CREATE PROCEDURE [incidentrequest].[USP_CONTACT_CERTIFICATION_GETBYPARENTID]
(
	@PARENTID CHAR(36)
)
AS
BEGIN
SET NOCOUNT ON;
SELECT 
	DISTINCT [COLICENSECERTIFICATION].[COSIMPLELICCERTID],
	[COLICENSECERTIFICATION].[LICENSENUMBER],
	[COLICENSECERTIFICATIONTYPE].[NAME] CERTIFICATIONTYPE,
	[COLICENSECERTIFICATION].[ISSUEDATE],
	[COLICENSECERTIFICATION].[EXPIREDATE],
	[COLICENSECERTIFICATION].[COMMENTS],
	[ILLICENSEGROUP].[NAME] CERTIFICATIONGROUP
FROM [COLICENSECERTIFICATION]
INNER JOIN [COLICENSECERTIFICATIONTYPE]
ON [COLICENSECERTIFICATIONTYPE].[COSIMPLELICCERTTYPEID] = [COLICENSECERTIFICATION].[COSIMPLELICCERTTYPEID]
LEFT JOIN [ILLICENSEGROUP]
ON [ILLICENSEGROUP].ILLICENSEGROUPID = [COLICENSECERTIFICATION].CERTGROUPID
LEFT JOIN [COLICCLASSREF]
ON [COLICENSECERTIFICATION].COSIMPLELICCERTID = [COLICCLASSREF].CERTID
LEFT JOIN [ILLICENSECLASSIFICATION]
ON [COLICCLASSREF].CLASSFICATIONID = [ILLICENSECLASSIFICATION].ILLICENSECLASSIFICATIONID
WHERE
	[COLICENSECERTIFICATION].[GLOBALENTITYID] = @PARENTID
END