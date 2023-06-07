﻿


CREATE PROCEDURE [dbo].[PMO_AUDIT_REPORT_SYS_IOS_GEORULE_USINGOR]
AS
SELECT     WORKFLOW.WORKFLOWNAME, WORKFLOWCONDITIONGROUP.ISORBASED, WORKFLOWPROPERTYCONDITIONTYPE.PROPERTYCONDITIONTYPENAME, WORKFLOWCONDITION.CLASSNAME, 
                      WORKFLOWCONDITION.FRIENDLYCLASSNAME, WORKFLOWCONDITION.PROPERTYNAME, WORKFLOWCONDITION.FRIENDLYPROPERTYNAME
FROM         WORKFLOW INNER JOIN
                      WORKFLOWCONDITIONGROUP ON WORKFLOW.WORKFLOWID = WORKFLOWCONDITIONGROUP.WORKFLOWID INNER JOIN
                      WORKFLOWCONDITION ON WORKFLOWCONDITIONGROUP.WORKFLOWCONDITIONGROUPID = WORKFLOWCONDITION.WORKFLOWCONDITIONGROUPID INNER JOIN
                      WORKFLOWPROPERTYCONDITIONTYPE ON 
                      WORKFLOWCONDITION.WORKFLOWPROPERTYCONDTYPEID = WORKFLOWPROPERTYCONDITIONTYPE.WORKFLOWPROPERTYCONDTYPEID
WHERE PROPERTYNAME='GeoRulesCallerType' and ISORBASED=0

