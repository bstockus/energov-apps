﻿
CREATE PROCEDURE [dbo].[rpt_SR_User_Setup_Report_Department]
@USERGUID AS VARCHAR(36)
AS
SELECT     DEPARTMENT.NAME AS Department
FROM         DEPARTMENT INNER JOIN
                      USERDEPARTMENT ON DEPARTMENT.DEPARTMENTID = USERDEPARTMENT.DEPARTMENTID
WHERE USERDEPARTMENT.SUSERGUID = @USERGUID


