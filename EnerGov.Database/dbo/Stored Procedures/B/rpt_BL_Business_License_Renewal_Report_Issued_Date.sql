﻿



CREATE PROCEDURE [dbo].[rpt_BL_Business_License_Renewal_Report_Issued_Date]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME
AS
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE))
SELECT BLLICENSETYPE.NAME AS LicenseType, BLLICENSE.LICENSENUMBER AS LicenseNumber, BLLICENSESTATUS.NAME AS LicenseStatus, BLLICENSECLASS.NAME AS Classification, 
       BLLICENSE.ISSUEDDATE AS IssueDate, BLLICENSE.EXPIRATIONDATE AS ExpirationDate, BLLICENSE.APPLIEDDATE AS AppliedDate, BLLICENSE.TAXYEAR AS TaxYear, 
       GLOBALENTITY.GLOBALENTITYNAME AS CompanyName, BLLICENSE.LASTRENEWALDATE AS LastRenewalDate, DISTRICT.NAME AS District
FROM BLLICENSE INNER JOIN
BLGLOBALENTITYEXTENSION ON BLLICENSE.BLGLOBALENTITYEXTENSIONID = BLGLOBALENTITYEXTENSION.BLGLOBALENTITYEXTENSIONID 
INNER JOIN GLOBALENTITY ON BLGLOBALENTITYEXTENSION.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID 
INNER JOIN BLLICENSETYPE ON BLLICENSE.BLLICENSETYPEID = BLLICENSETYPE.BLLICENSETYPEID 
INNER JOIN BLLICENSESTATUS ON BLLICENSE.BLLICENSESTATUSID = BLLICENSESTATUS.BLLICENSESTATUSID 
INNER JOIN BLLICENSECLASS ON BLLICENSE.BLLICENSECLASSID = BLLICENSECLASS.BLLICENSECLASSID 
INNER JOIN DISTRICT ON BLLICENSE.DISTRICTID = DISTRICT.DISTRICTID
WHERE BLLICENSE.ISSUEDDATE BETWEEN @STARTDATE AND @ENDDATE 
AND BLLICENSE.LASTRENEWALDATE IS NULL



