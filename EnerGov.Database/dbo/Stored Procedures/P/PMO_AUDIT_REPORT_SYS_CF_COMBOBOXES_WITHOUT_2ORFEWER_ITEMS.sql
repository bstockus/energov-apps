﻿


CREATE PROCEDURE [dbo].[PMO_AUDIT_REPORT_SYS_CF_COMBOBOXES_WITHOUT_2ORFEWER_ITEMS]
AS

SELECT     CUSTOMFIELDOBJECT.SLABEL AS CF_NAME, COUNT(CUSTOMFIELDPICKLISTITEM.FKGCUSTOMFIELDPICKLIST) AS CF_ITEM_COUNT, CUSTOMFIELDLAYOUT.SNAME AS CF_LAYOUT
FROM         CUSTOMFIELD INNER JOIN
                      CUSTOMFIELDPICKLIST ON CUSTOMFIELD.GCUSTOMFIELD = CUSTOMFIELDPICKLIST.FKGCUSTOMFIELD INNER JOIN
                      CUSTOMFIELDOBJECT ON CUSTOMFIELD.GCUSTOMFIELD = CUSTOMFIELDOBJECT.FKGCUSTOMFIELD INNER JOIN
                      CUSTOMFIELDLAYOUT ON CUSTOMFIELDOBJECT.FKGCUSTOMFIELDLAYOUT = CUSTOMFIELDLAYOUT.GCUSTOMFIELDLAYOUTS INNER JOIN
                      CUSTOMFIELDPICKLISTITEM ON CUSTOMFIELDPICKLIST.GCUSTOMFIELDPICKLIST = CUSTOMFIELDPICKLISTITEM.FKGCUSTOMFIELDPICKLIST
GROUP BY CUSTOMFIELDPICKLISTITEM.FKGCUSTOMFIELDPICKLIST, CUSTOMFIELDOBJECT.SLABEL, CUSTOMFIELDLAYOUT.SNAME
HAVING COUNT(CUSTOMFIELDPICKLISTITEM.FKGCUSTOMFIELDPICKLIST) <= 2
ORDER BY CF_NAME

