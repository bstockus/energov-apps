﻿

CREATE PROCEDURE [dbo].[rpt_IM_Inspection_Listing_Report_By_Create_Date]
@STARTDATE AS DATETIME,
@ENDDATE AS DATETIME
AS
SET @ENDDATE = DATEADD(S,-1,DATEADD(D,1,@ENDDATE))
SELECT     COALESCE (BLLICENSE.LICENSENUMBER, CMCODECASE.CASENUMBER, PLPLAN.PLANNUMBER, PMPERMIT.PERMITNUMBER) AS CaseNumber, 
                      COALESCE (BLLICENSETYPE.NAME, CMCASETYPE.NAME, PLPLANTYPE.PLANNAME, PMPERMITTYPE.NAME) AS CaseType, 
                      IMINSPECTION.INSPECTIONNUMBER AS InspectionNumber, IMINSPECTIONTYPE.NAME AS InspectionType, USERS.FNAME AS InspectorFName, 
                      USERS.LNAME AS InspectorLName, IMINSPECTIONSTATUS.STATUSNAME AS InspectionStatus, IMINSPECTION.COMPLETE AS Complete, 
                      IMINSPECTION.IMINSPECTIONID, IMINSPECTION.CREATEDATE
FROM         CMCODEWFACTIONSTEP INNER JOIN
                      CMCASETYPE INNER JOIN
                      CMCODEWFSTEP INNER JOIN
                      CMCODECASE ON CMCODEWFSTEP.CMCODECASEID = CMCODECASE.CMCODECASEID ON CMCASETYPE.CMCASETYPEID = CMCODECASE.CMCASETYPEID ON 
                      CMCODEWFACTIONSTEP.CMCODEWFSTEPID = CMCODEWFSTEP.CMCODEWFSTEPID RIGHT OUTER JOIN
                      PLPLANTYPE INNER JOIN
                      PLPLANWFSTEP INNER JOIN
                      PLPLAN ON PLPLANWFSTEP.PLPLANID = PLPLAN.PLPLANID ON PLPLANTYPE.PLPLANTYPEID = PLPLAN.PLPLANTYPEID INNER JOIN
                      PLPLANWFACTIONSTEP ON PLPLANWFSTEP.PLPLANWFSTEPID = PLPLANWFACTIONSTEP.PLPLANWFSTEPID RIGHT OUTER JOIN
                      IMINSPECTION INNER JOIN
                      IMINSPECTIONTYPE ON IMINSPECTION.IMINSPECTIONTYPEID = IMINSPECTIONTYPE.IMINSPECTIONTYPEID INNER JOIN
                      IMINSPECTORREF ON IMINSPECTION.IMINSPECTIONID = IMINSPECTORREF.INSPECTIONID INNER JOIN
                      USERS ON IMINSPECTORREF.USERID = USERS.SUSERGUID INNER JOIN
                      IMINSPECTIONSTATUS ON IMINSPECTION.IMINSPECTIONSTATUSID = IMINSPECTIONSTATUS.IMINSPECTIONSTATUSID INNER JOIN
                      IMINSPECTIONACTREF ON IMINSPECTION.IMINSPECTIONID = IMINSPECTIONACTREF.IMINSPECTIONID LEFT OUTER JOIN
                      BLLICENSEWFSTEP INNER JOIN
                      BLLICENSE ON BLLICENSEWFSTEP.BLLICENSEID = BLLICENSE.BLLICENSEID INNER JOIN
                      BLLICENSETYPE ON BLLICENSE.BLLICENSETYPEID = BLLICENSETYPE.BLLICENSETYPEID INNER JOIN
                      BLLICENSEWFACTIONSTEP ON BLLICENSEWFSTEP.BLLICENSEWFSTEPID = BLLICENSEWFACTIONSTEP.BLLICENSEWFSTEPID ON 
                      IMINSPECTIONACTREF.OBJECTID = BLLICENSEWFACTIONSTEP.BLLICENSEWFACTIONSTEPID LEFT OUTER JOIN
                      PMPERMITWFACTIONSTEP INNER JOIN
                      PMPERMITTYPE INNER JOIN
                      PMPERMIT INNER JOIN
                      PMPERMITWFSTEP ON PMPERMIT.PMPERMITID = PMPERMITWFSTEP.PMPERMITID ON PMPERMITTYPE.PMPERMITTYPEID = PMPERMIT.PMPERMITTYPEID ON 
                      PMPERMITWFACTIONSTEP.PMPERMITWFSTEPID = PMPERMITWFSTEP.PMPERMITWFSTEPID ON 
                      IMINSPECTIONACTREF.OBJECTID = PMPERMITWFACTIONSTEP.PMPERMITWFACTIONSTEPID ON 
                      PLPLANWFACTIONSTEP.PLPLANWFACTIONSTEPID = IMINSPECTIONACTREF.OBJECTID ON 
                      CMCODEWFACTIONSTEP.CMCODEWFACTIONSTEPID = IMINSPECTIONACTREF.OBJECTID
WHERE IMINSPECTION.CREATEDATE BETWEEN @STARTDATE AND @ENDDATE
