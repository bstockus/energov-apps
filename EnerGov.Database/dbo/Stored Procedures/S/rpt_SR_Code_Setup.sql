﻿
CREATE PROCEDURE [dbo].[rpt_SR_Code_Setup]
AS
SELECT     CMCASETYPE.CMCASETYPEID, CMCASETYPE.NAME AS CASETYPE, CMCODECASESTATUS.NAME AS STATUS, CMCASETYPE.DESCRIPTION, 
                      CUSTOMFIELDLAYOUT.SNAME AS CUSTOMFIELD, CMCASETYPE.PREFIX, WFTEMPLATE.NAME AS WFTEMPLATE, USERS.ID AS USERID, USERS.FNAME, 
                      USERS.LNAME, CAFEETEMPLATE.CAFEETEMPLATENAME, CMCASETYPE.ACTIVE
FROM         CMCASETYPE LEFT OUTER JOIN
                      CUSTOMFIELDLAYOUT ON CMCASETYPE.CUSTOMFIELDID = CUSTOMFIELDLAYOUT.GCUSTOMFIELDLAYOUTS LEFT OUTER JOIN
                      WFTEMPLATE ON CMCASETYPE.WFTEMPLATEID = WFTEMPLATE.WFTEMPLATEID LEFT OUTER JOIN
                      CMCODECASESTATUS ON CMCASETYPE.DEFAULTSTATUS = CMCODECASESTATUS.CMCODECASESTATUSID LEFT OUTER JOIN
                      USERS ON CMCASETYPE.DEFAULTUSER = USERS.SUSERGUID LEFT OUTER JOIN
                      CAFEETEMPLATE ON CMCASETYPE.CAFEETEMPLATEID = CAFEETEMPLATE.CAFEETEMPLATEID
