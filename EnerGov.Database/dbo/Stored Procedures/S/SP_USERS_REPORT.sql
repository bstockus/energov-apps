﻿/* 
Created By: Wes McGrail
Created On: 12/20/16
Report: Active_User_List.rpt
Description: 

select * from users where bactive is null
exec SP_USERS_REPORT 1
exec SP_USERS_REPORT 0
*/


CREATE PROCEDURE [dbo].[SP_USERS_REPORT]
	@paraActive int
AS

/*GET HISTORY UNTIL FUTURE RELEASE*/

SELECT MAX(H.CHANGEDON) LASTDATE, H.CHANGEDBY
INTO #TEMPHISTORY
FROM HISTORYPERMITMANAGEMENT H
GROUP BY H.CHANGEDBY

INSERT INTO #TEMPHISTORY
SELECT MAX(H.CHANGEDON) LASTDATE, H.CHANGEDBY
FROM HISTORYPLANMANAGEMENT H
GROUP BY H.CHANGEDBY

INSERT INTO #TEMPHISTORY
SELECT MAX(H.CHANGEDON) LASTDATE, H.CHANGEDBY
FROM HISTORYCODEMANAGEMENT H
GROUP BY H.CHANGEDBY

INSERT INTO #TEMPHISTORY
SELECT MAX(H.CHANGEDON) LASTDATE, H.CHANGEDBY
FROM HISTORYCRMMANAGEMENT H
GROUP BY H.CHANGEDBY

INSERT INTO #TEMPHISTORY
SELECT MAX(H.CHANGEDON) LASTDATE, H.CHANGEDBY
FROM HISTORYINSPECTIONS H
GROUP BY H.CHANGEDBY

INSERT INTO #TEMPHISTORY
SELECT MAX(H.CHANGEDON) LASTDATE, H.CHANGEDBY
FROM HISTORYINDLICENSE H
GROUP BY H.CHANGEDBY

INSERT INTO #TEMPHISTORY
SELECT MAX(H.CHANGEDON) LASTDATE, H.CHANGEDBY
FROM HISTORYSYSTEMSETUP H
GROUP BY H.CHANGEDBY

INSERT INTO #TEMPHISTORY
SELECT MAX(H.CHANGEDON) LASTDATE, H.CHANGEDBY
FROM HISTORYASSETMANAGEMENT H
GROUP BY H.CHANGEDBY

INSERT INTO #TEMPHISTORY
SELECT MAX(H.CHANGEDON) LASTDATE, H.CHANGEDBY
FROM HISTORYLICENSEMANAGEMENT H
GROUP BY H.CHANGEDBY

INSERT INTO #TEMPHISTORY
SELECT MAX(H.CHANGEDON) LASTDATE, H.CHANGEDBY
FROM HISTORYPROJMANAGEMENT H
GROUP BY H.CHANGEDBY

INSERT INTO #TEMPHISTORY
SELECT MAX(H.CHANGEDON) LASTDATE, H.CHANGEDBY
FROM HISTORYPROPMANAGEMENT H
GROUP BY H.CHANGEDBY

INSERT INTO #TEMPHISTORY
SELECT MAX(H.CHANGEDON) LASTDATE, H.CHANGEDBY
FROM HISTORYPURMANAGEMENT H
GROUP BY H.CHANGEDBY

SELECT MAX(T.LASTDATE) LASTDATE, U.SUSERGUID
INTO #LASTDATELIST
FROM #TEMPHISTORY T
INNER JOIN USERS U ON U.SUSERGUID = T.CHANGEDBY
GROUP BY U.SUSERGUID
;

WITH DEPT_CTE AS
(SELECT DISTINCT U1.SUSERGUID,
	STUFF((SELECT ', ' + D.NAME
		FROM USERDEPARTMENT U
		INNER JOIN DEPARTMENT D ON D.DEPARTMENTID = U.DEPARTMENTID
		WHERE U.SUSERGUID = U1.SUSERGUID
		ORDER BY D.NAME
		FOR XML PATH(''), root('MyString'), type
		).value('/MyString[1]','varchar(max)') 
		,1,2,'') AS 'DEPARTMENTS'
	FROM USERDEPARTMENT U1)


SELECT 
	CASE WHEN R.SDESCRIPTION IS NULL THEN '' ELSE U.ID END AS USERID,
	U.FNAME FIRST_NAME,
	U.LNAME LAST_NAME,
	U.TITLE,
	U.SUSERGUID,
	U.LICENSE_SUITE,
	CASE U.BACTIVE WHEN 1 THEN 'Active' ELSE 'Inactive' END AS ACTIVE,
	R.SDESCRIPTION 'ROLE',
	U.BACTIVE,
	O.NAME OFFICE,
	D.DEPARTMENTS,
	L.LASTDATE LAST_LOGIN_DATE /*TO BE MODIFIED IN THE FUTURE*/	
FROM USERS U
LEFT JOIN ROLES R ON R.SROLEGUID = U.SROLEID
LEFT JOIN OFFICE O ON O.OFFICEID = U.OFFICEID
LEFT JOIN DEPT_CTE D ON U.SUSERGUID = D.SUSERGUID
LEFT JOIN #LASTDATELIST L ON U.SUSERGUID = L.SUSERGUID
WHERE R.SDESCRIPTION IS NOT NULL
  AND U.SUSERGUID <> '2FB39FA9-DF43-41D7-BB8B-C91836D30987'
  AND U.SUSERGUID <> 'a24df514-c3c1-49c7-8784-0b2bf58c79fa'
  AND U.SUSERGUID <> '2b8fe22b-d980-441d-9887-62afbcd9c5bf'
  AND U.SUSERGUID <> 'ff9cc595-2cb9-48d0-94ac-f2e122033bf3'
--AND U.LICENSE_SUITE IS NOT NULL
AND U.BACTIVE = @paraActive

ORDER BY U.ID

DROP TABLE #TEMPHISTORY;
DROP TABLE #LASTDATELIST