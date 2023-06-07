﻿CREATE PROCEDURE [dbo].[USP_HUB_PROJECTDATA_BY_STARTDATE]
@PROJECTSTARTDATE DATETIME
AS
BEGIN
       -- SET NOCOUNT ON added to prevent extra result sets from
       -- interfering with SELECT statements.
       SET NOCOUNT ON;

      SELECT project.PRPROJECTID PROJECTID, project.PROJECTNUMBER,project.DESCRIPTION PROJECTDESCRIPTION, project.STARTDATE PROJECTSTARTDATE, project.COMPLETEDATE PROJECTCOMPLETEDATE,
       (SELECT TOP 1 
	   ( CASE WHEN MA.ADDRESSLINE1 is null OR MA.ADDRESSLINE1 = '' THEN '' ELSE (MA.ADDRESSLINE1 + ' ') END + 
		 CASE WHEN MA.PREDIRECTION is null OR MA.PREDIRECTION = '' THEN '' ELSE (MA.PREDIRECTION + ' ') END + 
		 CASE WHEN MA.ADDRESSLINE2 is null OR MA.ADDRESSLINE2 = '' THEN '' ELSE (MA.ADDRESSLINE2 + ' ') END + 
		 CASE WHEN MA.STREETTYPE is null OR MA.STREETTYPE = '' THEN '' ELSE (MA.STREETTYPE + ' ') END + 
		 CASE WHEN MA.POSTDIRECTION is null OR MA.POSTDIRECTION = '' THEN '' ELSE (MA.POSTDIRECTION + ' ') END + 
		 CASE WHEN MA.ADDRESSLINE3 is null OR MA.ADDRESSLINE3 = '' THEN '' ELSE (MA.ADDRESSLINE3 + ' ') END + 
		 CASE WHEN MA.UNITORSUITE is null OR MA.UNITORSUITE = '' THEN '' ELSE ('Unit:' + MA.UNITORSUITE + ' ') END + 
		 CASE WHEN MA.CITY is null OR MA.CITY = '' THEN '' ELSE (', ' + MA.CITY + ', ') END + 
		 CASE WHEN MA.STATE is null OR MA.STATE = '' THEN '' ELSE (MA.STATE + ' ') END + 
		 CASE WHEN MA.POSTALCODE is null OR MA.POSTALCODE = '' THEN '' ELSE (MA.POSTALCODE + ' ') END)
	    FROM PRPROJECTADDRESS PRA INNER JOIN MAILINGADDRESS MA ON PRA.MAILINGADDRESSID = MA.MAILINGADDRESSID WHERE PRA.PRPROJECTID = project.PRPROJECTID ORDER BY PRA.MAIN DESC) PROJECTMAINADDRESS,
       (SELECT TOP 1 CASE GE.ISCOMPANY WHEN 0 THEN GE.FIRSTNAME + ' ' + GE.LASTNAME ELSE GE.GLOBALENTITYNAME END FROM PRPROJECTCONTACT PC INNER JOIN GLOBALENTITY GE ON PC.GLOBALENTITYID = GE.GLOBALENTITYID WHERE PC.PRPROJECTID = project.PRPROJECTID ORDER BY PC.ISBILLING DESC ) PROJECTMAINCONTACT,
       (SELECT SUM(DUE) FROM 
       (
              SELECT PRPROJECTID, SUM(ABS(COMPUTEDAMOUNT - AMOUNTPAIDTODATE)) AS 'DUE' FROM PRPROJECTFEE JOIN CACOMPUTEDFEE ON PRPROJECTFEE.CACOMPUTEDFEEID = CACOMPUTEDFEE.CACOMPUTEDFEEID
              WHERE CASTATUSID NOT IN (4,9,10) AND PRPROJECTID = project.PRPROJECTID
              GROUP BY PRPROJECTID
              UNION ALL
              SELECT PMPERMITID, SUM(ABS(COMPUTEDAMOUNT - AMOUNTPAIDTODATE)) AS 'DUE' FROM PMPERMITFEE JOIN CACOMPUTEDFEE ON PMPERMITFEE.CACOMPUTEDFEEID = CACOMPUTEDFEE.CACOMPUTEDFEEID
              WHERE CASTATUSID NOT IN (4,9,10) AND PMPERMITFEE.PMPERMITID IN (SELECT PMPERMITID FROM PRPROJECTPERMIT WHERE PRPROJECTID = project.PRPROJECTID)
              GROUP BY PMPERMITID
              UNION ALL
              SELECT CMCODECASEID, SUM(ABS(COMPUTEDAMOUNT - AMOUNTPAIDTODATE)) AS 'DUE' FROM CMCODECASEFEE JOIN CACOMPUTEDFEE ON CMCODECASEFEE.CACOMPUTEDFEEID = CACOMPUTEDFEE.CACOMPUTEDFEEID
              WHERE CASTATUSID NOT IN (4,9,10) AND CMCODECASEFEE.CMCODECASEID IN (SELECT CMCODECASEID FROM PRPROJECTCODECASE WHERE PRPROJECTID = project.PRPROJECTID)
              GROUP BY CMCODECASEID
              UNION ALL
              SELECT PLPLANID, SUM(ABS(COMPUTEDAMOUNT - AMOUNTPAIDTODATE)) AS 'DUE' FROM PLPLANFEE JOIN CACOMPUTEDFEE ON PLPLANFEE.CACOMPUTEDFEEID = CACOMPUTEDFEE.CACOMPUTEDFEEID
              WHERE CASTATUSID NOT IN (4,9,10) AND PLPLANFEE.PLPLANID IN (SELECT PLPLANID FROM PRPROJECTPLAN WHERE PRPROJECTID = project.PRPROJECTID)
              GROUP BY PLPLANID
              UNION ALL
              SELECT PLAPPLICATIONID, SUM(ABS(COMPUTEDAMOUNT - AMOUNTPAIDTODATE)) AS 'DUE' FROM PLAPPLICATIONFEE JOIN CACOMPUTEDFEE ON PLAPPLICATIONFEE.CACOMPUTEDFEEID = CACOMPUTEDFEE.CACOMPUTEDFEEID
              WHERE CASTATUSID NOT IN (4,9,10) AND PLAPPLICATIONFEE.PLAPPLICATIONID IN (SELECT PLAPPLICATIONID FROM PRPROJECTAPPLICATION WHERE PRPROJECTID = project.PRPROJECTID)
              GROUP BY PLAPPLICATIONID
       ) TOTALS ) TOTALDUE
	   FROM PRPROJECT project WHERE project.STARTDATE >= @PROJECTSTARTDATE

END




