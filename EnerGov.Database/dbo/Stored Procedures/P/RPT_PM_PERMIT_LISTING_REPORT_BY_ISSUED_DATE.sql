﻿


CREATE PROCEDURE [dbo].[RPT_PM_PERMIT_LISTING_REPORT_BY_ISSUED_DATE]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME
AS
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE))

SELECT PMPERMIT.PERMITNUMBER, PMPERMIT.APPLYDATE, PMPERMIT.EXPIREDATE, PMPERMIT.ISSUEDATE, PMPERMIT.FINALIZEDATE, PMPERMIT.VALUE, PMPERMIT.SQUAREFEET, 
       PMPERMITTYPE.NAME AS PERMITTYPE, PMPERMITWORKCLASS.NAME AS WORKCLASS, PMPERMITSTATUS.NAME AS STATUS, CACOMPUTEDFEE.FEENAME, 
       CACOMPUTEDFEE.COMPUTEDAMOUNT AS FEEAMOUNT, CATRANSACTIONFEE.PaidAMOUNT, CATRANSACTIONSTATUS.NAME AS TRANSACTIONSTATUS, 
       CASTATUS.NAME AS COMPUTEDFEESTATUS, PMPERMIT.PMPERMITID
FROM PMPERMIT
INNER JOIN PMPERMITTYPE ON PMPERMIT.PMPERMITTYPEID = PMPERMITTYPE.PMPERMITTYPEID 
INNER JOIN PMPERMITWORKCLASS ON PMPERMIT.PMPERMITWORKCLASSID = PMPERMITWORKCLASS.PMPERMITWORKCLASSID 
INNER JOIN PMPERMITFEE ON PMPERMIT.PMPERMITID = PMPERMITFEE.PMPERMITID 
INNER JOIN CACOMPUTEDFEE ON PMPERMITFEE.CACOMPUTEDFEEID = CACOMPUTEDFEE.CACOMPUTEDFEEID 
INNER JOIN CATRANSACTIONFEE ON CACOMPUTEDFEE.CACOMPUTEDFEEID = CATRANSACTIONFEE.CACOMPUTEDFEEID 
INNER JOIN CATRANSACTION ON CATRANSACTIONFEE.CATRANSACTIONID = CATRANSACTION.CATRANSACTIONID 
INNER JOIN PMPERMITSTATUS ON PMPERMIT.PMPERMITSTATUSID = PMPERMITSTATUS.PMPERMITSTATUSID 
INNER JOIN CATRANSACTIONSTATUS ON CATRANSACTION.CATRANSACTIONSTATUSID = CATRANSACTIONSTATUS.CATRANSACTIONSTATUSID 
INNER JOIN CASTATUS ON CACOMPUTEDFEE.CASTATUSID = CASTATUS.CASTATUSID
WHERE CATRANSACTIONSTATUS.NAME NOT IN ('NSF','VOID') 
AND PMPERMIT.ISSUEDATE BETWEEN @STARTDATE AND @ENDDATE


