﻿

CREATE PROCEDURE [dbo].[rpt_CR_Citizen_Request_History_Report]
@REQUESTID AS VARCHAR(36)
AS
SELECT HISTORYCRMMANAGEMENT.CHANGEDON, HISTORYCRMMANAGEMENT.FIELDNAME, HISTORYCRMMANAGEMENT.OLDVALUE, 
       HISTORYCRMMANAGEMENT.NEWVALUE, HISTORYCRMMANAGEMENT.ADDITIONALINFO, USERS.FNAME + ' ' + USERS.LNAME AS USERNAME,
       CITIZENREQUEST.REQUESTNUMBER, HISTORYCRMMANAGEMENT.ROWVERSION, CONVERT(DATEtime,HISTORYCRMMANAGEMENT.CHANGEDON) AS ChangedDate
FROM HISTORYCRMMANAGEMENT 
INNER JOIN CITIZENREQUEST ON HISTORYCRMMANAGEMENT.ID = CITIZENREQUEST.CITIZENREQUESTID 
INNER JOIN USERS ON HISTORYCRMMANAGEMENT.CHANGEDBY = USERS.SUSERGUID
WHERE CITIZENREQUEST.CITIZENREQUESTID = @REQUESTID


