﻿




CREATE PROCEDURE [dbo].[RPT_PM_PERMITS_EXPIRED_BY_STATUS]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME
AS
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE))

-- PM Permits Issued by Status
SELECT PMPERMITSTATUS.NAME AS PermitStatus, PMPERMITTYPE.NAME AS PermitType, PMPERMITWORKCLASS.NAME AS PermitClass, 
       PMPERMIT.PERMITNUMBER, PMPERMIT.EXPIREDATE, PMPERMIT.VALUE, PMPERMIT.DESCRIPTION AS PermitDesc,
       PRPROJECT.NAME AS ProjectName, PMPERMIT.SQUAREFEET, DISTRICT.NAME AS District, PARCEL.PARCELNUMBER, 
       TB_ADDR.ADDRESSLINE1, TB_ADDR.ADDRESSLINE2, TB_ADDR.ADDRESSLINE3, TB_ADDR.CITY, TB_ADDR.STATE, 
       TB_ADDR.POSTALCODE, TB_ADDR.POSTDIRECTION, TB_ADDR.PREDIRECTION, TB_ADDR.STREETTYPE, TB_ADDR.UNITORSUITE,
       PMPERMIT.PMPERMITID
FROM PMPERMIT
INNER JOIN PMPERMITSTATUS ON PMPERMIT.PMPERMITSTATUSID = PMPERMITSTATUS.PMPERMITSTATUSID
INNER JOIN PMPERMITTYPE ON PMPERMIT.PMPERMITTYPEID = PMPERMITTYPE.PMPERMITTYPEID
INNER JOIN PMPERMITWORKCLASS ON PMPERMIT.PMPERMITWORKCLASSID = PMPERMITWORKCLASS.PMPERMITWORKCLASSID
LEFT OUTER JOIN DISTRICT ON PMPERMIT.DISTRICTID = DISTRICT.DISTRICTID
LEFT OUTER JOIN PRPROJECTPERMIT ON PMPERMIT.PMPERMITID = PRPROJECTPERMIT.PMPERMITID
LEFT OUTER JOIN PRPROJECT ON PRPROJECTPERMIT.PRPROJECTID = PRPROJECT.PRPROJECTID
LEFT OUTER JOIN ( SELECT * FROM PMPERMITPARCEL WHERE PMPERMITPARCEL.MAIN = 1 ) AS PMPERMITPARCEL ON PMPERMIT.PMPERMITID = PMPERMITPARCEL.PMPERMITID
LEFT OUTER JOIN PARCEL ON PMPERMITPARCEL.PARCELID = PARCEL.PARCELID
LEFT OUTER JOIN ( SELECT PMPERMITADDRESS.PMPERMITID, MAILINGADDRESS.MAILINGADDRESSID, MAILINGADDRESS.ADDRESSTYPE, MAILINGADDRESS.PARCELNUMBER, 
                         MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, MAILINGADDRESS.CITY, MAILINGADDRESS.STATE, 
                         MAILINGADDRESS.POSTALCODE, MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.STREETTYPE, MAILINGADDRESS.UNITORSUITE
                  FROM PMPERMITADDRESS 
                  INNER JOIN MAILINGADDRESS ON PMPERMITADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
                  WHERE PMPERMITADDRESS.MAIN = 1
                ) AS TB_ADDR ON PMPERMIT.PMPERMITID = TB_ADDR.PMPERMITID
WHERE PMPERMIT.EXPIREDATE BETWEEN @STARTDATE AND @ENDDATE


