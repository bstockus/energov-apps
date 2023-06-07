

CREATE PROCEDURE [dbo].[rpt_Contact_Detail_Report_Holds]
@GLOBALENTITYID as varchar(36)
AS
SELECT     GlobalEntityHold.Comments, Users.FName, Users.LName, GlobalEntityHold.CreatedDate, GlobalEntityHold.Active, GlobalEntityHold.HoldSetupID, 
                      HoldTypeSetups.Name AS HoldTypeName
FROM         GlobalEntityHold INNER JOIN
                      HoldTypeSetups ON GlobalEntityHold.HoldSetupID = HoldTypeSetups.HoldSetupID INNER JOIN
                      Users ON GlobalEntityHold.sUserGUID = Users.sUserGUID
WHERE GlobalEntityHold.GlobalEntityID = @GLOBALENTITYID

