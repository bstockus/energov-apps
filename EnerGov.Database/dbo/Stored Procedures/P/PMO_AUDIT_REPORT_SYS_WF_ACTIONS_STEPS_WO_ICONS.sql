﻿


CREATE PROCEDURE [dbo].[PMO_AUDIT_REPORT_SYS_WF_ACTIONS_STEPS_WO_ICONS]
AS

SELECT     NAME AS WF_ENTITY, 'ACTION' AS WF_TYPE
FROM         WFACTION
WHERE ICON IS NULL or ICON =''

UNION ALL

SELECT     NAME AS WF_ENTITY, 'STEP' AS WF_TYPE
FROM         WFSTEP
WHERE ICON IS NULL or ICON =''


