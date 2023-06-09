﻿

/****** OBJECT:  StoredProcedure [dbo].[rpt_IP_SR_Impact_Case_Attached_Records_Report_Plan]    Script Date: 01/08/2014 15:58:52 ******/
CREATE PROCEDURE [dbo].[rpt_IP_SR_Impact_Case_Attached_Records_Report_Plan]
@IPCASEID AS VARCHAR(36)
AS

SELECT	IPCASEPLANXREF.IPCASEID, 
		PLPLAN.PLPLANID, PLPLAN.PLANNUMBER, 
		PLPLANTYPE.PLANNAME PLANTYPE, 
		PLPLANWORKCLASS.NAME PLANCLASS,
		PLPLANSTATUS.NAME PLPLANSTATUS,
		PLAN_CONTACTS.ISBILLING, PLAN_CONTACTS.CONTACTTYPE, PLAN_CONTACTS.GLOBALENTITYNAME, PLAN_CONTACTS.FIRSTNAME, PLAN_CONTACTS.LASTNAME

FROM	IPCASEPLANXREF 
		INNER JOIN PLPLAN ON IPCASEPLANXREF.PLPLANID = PLPLAN.PLPLANID
		INNER JOIN PLPLANTYPE ON PLPLAN.PLPLANTYPEID = PLPLANTYPE.PLPLANTYPEID
		INNER JOIN PLPLANWORKCLASS ON PLPLAN.PLPLANWORKCLASSID = PLPLANWORKCLASS.PLPLANWORKCLASSID
		INNER JOIN PLPLANSTATUS ON PLPLAN.PLPLANSTATUSID = PLPLANSTATUS.PLPLANSTATUSID
		
		LEFT OUTER JOIN (SELECT PLPLANCONTACT.PLPLANID, PLPLANCONTACT.ISBILLING,
								GLOBALENTITY.GLOBALENTITYNAME, GLOBALENTITY.FIRSTNAME, GLOBALENTITY.LASTNAME,
								LANDMANAGEMENTCONTACTTYPE.NAME CONTACTTYPE
						 FROM	PLPLANCONTACT 
								INNER JOIN LANDMANAGEMENTCONTACTTYPE ON PLPLANCONTACT.LANDMANAGEMENTCONTACTTYPEID = LANDMANAGEMENTCONTACTTYPE.LANDMANAGEMENTCONTACTTYPEID
								INNER JOIN GLOBALENTITY ON PLPLANCONTACT.GLOBALENTITYID = GLOBALENTITY.GLOBALENTITYID
						) AS PLAN_CONTACTS ON PLPLAN.PLPLANID = PLAN_CONTACTS.PLPLANID

WHERE	IPCASEPLANXREF.IPCASEID = @IPCASEID

