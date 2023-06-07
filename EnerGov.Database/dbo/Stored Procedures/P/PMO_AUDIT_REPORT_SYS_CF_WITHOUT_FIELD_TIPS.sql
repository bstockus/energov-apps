﻿


CREATE PROCEDURE [dbo].[PMO_AUDIT_REPORT_SYS_CF_WITHOUT_FIELD_TIPS]
AS

SELECT     CUSTOMFIELDOBJECT.SLABEL AS CF_NAME, CUSTOMFIELDLAYOUT.SNAME AS CF_LAYOUT, CUSTOMFIELDLAYOUTCONTROLTYPE.SNAME AS CF_CONTROL
FROM         CUSTOMFIELDLAYOUT INNER JOIN
                      CUSTOMFIELDOBJECT ON CUSTOMFIELDLAYOUT.GCUSTOMFIELDLAYOUTS = CUSTOMFIELDOBJECT.FKGCUSTOMFIELDLAYOUT INNER JOIN
                      CUSTOMFIELDLAYOUTCONTROLTYPE ON CUSTOMFIELDOBJECT.FKCUSTOMFIELDLAYOUTCONTROLTYPE = CUSTOMFIELDLAYOUTCONTROLTYPE.ICUSTOMFIELDLAYOUTCONTROLTYPE
WHERE     (CUSTOMFIELDOBJECT.SFIELDTIP IS NULL) OR
                      (CUSTOMFIELDOBJECT.SFIELDTIP = '') AND CUSTOMFIELDLAYOUTCONTROLTYPE.SNAME NOT IN ('GroupBox','TabControl','TabItem','Label','Image','Hyperlink')
