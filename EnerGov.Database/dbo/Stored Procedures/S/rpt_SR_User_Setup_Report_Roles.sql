﻿
CREATE PROCEDURE [dbo].[rpt_SR_User_Setup_Report_Roles]
AS
SELECT     ROLES.ID AS RolesID, ROLES.SDESCRIPTION AS RolesDescription, MENUS.SDESCRIPTION AS Menu, ROLEMENUXREF.BVISIBLE AS MenuVisible, 
                      SUBMENUS.SDESCRIPTION AS SubMenu, ROLESUBMENUXREF.BVISIBLE AS SubMenuVisible, FORMS.SCOMMONNAME AS Form, 
                      ROLEFORMSXREF.BVISIBLE AS FormVisible, SUBMENUS.IORDER AS SubMenuIOrder, FORMS.IORDER AS FormIOrder, ROLEFORMSXREF.BALLOWADD AS FormAdd, 
                      ROLEFORMSXREF.BALLOWUPDATE AS FormUpdate, ROLEFORMSXREF.BALLOWDELETE AS FormDelete, ROLES.SROLEGUID
FROM         ROLES INNER JOIN
                      ROLEMENUXREF ON ROLES.SROLEGUID = ROLEMENUXREF.FKROLEID INNER JOIN
                      MENUS ON ROLEMENUXREF.FKMENUID = MENUS.SMENUGUID INNER JOIN
                      SUBMENUS ON MENUS.SMENUGUID = SUBMENUS.FKMENUGUID INNER JOIN
                      ROLESUBMENUXREF ON SUBMENUS.SSUBMENUGUID = ROLESUBMENUXREF.FKSUBMENUID AND 
                      ROLES.SROLEGUID = ROLESUBMENUXREF.FKROLEID LEFT OUTER JOIN
                      FORMS INNER JOIN
                      ROLEFORMSXREF ON FORMS.SFORMSGUID = ROLEFORMSXREF.FKFORMSID ON SUBMENUS.SSUBMENUGUID = FORMS.FKSUBMENUGUID AND 
                      ROLES.SROLEGUID = ROLEFORMSXREF.FKROLEID
