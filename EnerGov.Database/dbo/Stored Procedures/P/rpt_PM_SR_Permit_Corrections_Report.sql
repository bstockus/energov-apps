﻿
/*
exec [rpt_PM_SR_Permit_Corrections_Report] ''
select top(20) * from plitemreview where PMPERMITID is not null order by lastchangedon desc
*/


CREATE PROCEDURE [dbo].[rpt_PM_SR_Permit_Corrections_Report]
@PMPERMITID AS VARCHAR(36)
AS
BEGIN

SELECT PMPERMIT.PMPERMITID, PMPERMIT.PERMITNUMBER, PMPERMIT.APPLYDATE, PMPERMIT.[EXPIREDATE], PMPERMIT.[DESCRIPTION], PMPERMIT.SQUAREFEET, PMPERMIT.VALUE, 
       PLITEMREVIEWTYPE.NAME AS REVIEWITEM, USERS.FNAME, USERS.LNAME, USERS.PHONE, USERS.EMAIL, USERS.TITLE, USERS.[CREDENTIALS], 
       PLPLANCORRECTIONTYPE.NAME AS CORRECTIONTYPE, PLPLANCORRECTION.COMMENTS AS [CORRECTIVEACTIONS COMMENTS]
	    , PLPLANCORRECTION.CREATEDATE AS CORRECTION_DATE, U2.FNAME + ' ' + U2.LNAME AS CORRECTION_USER, PLPLANCORRECTION.CORRECTIVEACTION,
       PLPLANCORRECTION.PLPLANCORRECTIONID, PLITEMREVIEWTYPE.[DESCRIPTION] AS ITEMREVIEWDESC, PLPLANCORRECTION.RESOLVED,
	   PLITEMREVIEWSTATUS.NAME AS STATUSNAME,
	   PARCEL.PARCELNUMBER, PLITEMREVIEW.PLITEMREVIEWID,
	   PLSUBMITTAL.PLSUBMITTALID,
	   PLSUBMITTALTYPE.TYPENAME SUBMITTALTYPE,
	   PMPERMITWFACTIONSTEP.VERSIONNUMBER,
	   MA.ADDRESSLINE1, MA.ADDRESSLINE2, MA.ADDRESSLINE3, MA.CITY, MA.[STATE], MA.POSTALCODE, 
       MA.POSTDIRECTION, MA.PREDIRECTION, MA.STREETTYPE, MA.UNITORSUITE
		,(SELECT R.[IMAGE] FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo') LOGO
	    ,(SELECT CASE WHEN R.[IMAGE] IS NULL THEN 'N' ELSE 'Y' END FROM RPTIMAGELIB R WHERE R.IMAGENAME = 'Municipality_Logo') SHOWLOGO
	    ,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R	WHERE R.TEXTNAME = 'Municipality_Name') Municipality_Name
	    ,(SELECT R.REPORTTEXT FROM RPTTEXTLIB R WHERE R.TEXTNAME = 'Municipality_Page_Footer') Municipality_Page_Footer
FROM PMPERMIT 
LEFT OUTER JOIN PLITEMREVIEW ON PMPERMIT.PMPERMITID = PLITEMREVIEW.PMPERMITID 
LEFT OUTER JOIN PLITEMREVIEWSTATUS ON PLITEMREVIEW.PLITEMREVIEWSTATUSID = PLITEMREVIEWSTATUS.PLITEMREVIEWSTATUSID
LEFT OUTER JOIN PLITEMREVIEWTYPE ON PLITEMREVIEW.PLITEMREVIEWTYPEID = PLITEMREVIEWTYPE.PLITEMREVIEWTYPEID
LEFT OUTER JOIN USERS ON PLITEMREVIEW.ASSIGNEDUSERID = USERS.SUSERGUID  
LEFT OUTER JOIN PLPLANCORRECTION ON PLITEMREVIEW.PLITEMREVIEWID = PLPLANCORRECTION.PLITEMREVIEWID 
LEFT OUTER JOIN PLPLANCORRECTIONTYPE ON PLPLANCORRECTION.PLPLANCORRECTIONTYPEID = PLPLANCORRECTIONTYPE.PLPLANCORRECTIONTYPEID 
LEFT OUTER JOIN USERS U2 ON PLPLANCORRECTION.ADDEDBYUSERID = U2.SUSERGUID 
LEFT OUTER JOIN PLSUBMITTAL ON PLITEMREVIEW.PLSUBMITTALID = PLSUBMITTAL.PLSUBMITTALID
LEFT OUTER JOIN PLSUBMITTALTYPE ON PLSUBMITTAL.PLSUBMITTALTYPEID = PLSUBMITTALTYPE.PLSUBMITTALTYPEID
LEFT OUTER JOIN PMPERMITWFACTIONSTEP ON PLSUBMITTAL.PMPERMITWFACTIONSTEPID = PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID
LEFT OUTER JOIN PMPERMITPARCEL ON PMPERMIT.PMPERMITID = PMPERMITPARCEL.PMPERMITID AND PMPERMITPARCEL.MAIN = 1
LEFT OUTER JOIN PARCEL ON PMPERMITPARCEL.PARCELID = PARCEL.PARCELID
LEFT OUTER JOIN (SELECT	PMPERMITADDRESS.PMPERMITID, MAILINGADDRESS.ADDRESSLINE1, MAILINGADDRESS.ADDRESSLINE2, MAILINGADDRESS.ADDRESSLINE3, 
					MAILINGADDRESS.CITY, MAILINGADDRESS.[STATE], MAILINGADDRESS.POSTALCODE, 
					MAILINGADDRESS.POSTDIRECTION, MAILINGADDRESS.PREDIRECTION, MAILINGADDRESS.STREETTYPE, MAILINGADDRESS.UNITORSUITE
			FROM PMPERMITADDRESS 
			INNER JOIN MAILINGADDRESS ON PMPERMITADDRESS.MAILINGADDRESSID = MAILINGADDRESS.MAILINGADDRESSID
			WHERE PMPERMITADDRESS.PMPERMITID = @PMPERMITID 
			AND PMPERMITADDRESS.MAIN = 1) AS MA ON PMPERMIT.PMPERMITID = MA.PMPERMITID
WHERE PMPERMIT.PMPERMITID = @PMPERMITID
END
