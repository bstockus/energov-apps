



-- =============================================
-- Author:		<Kyong Hwangbo, EnerGov Solutions>	
-- Create date: <9/28/2010>
-- Description:	<Created as a script to pull all login requests from Citizen Access;
-- Currently the logins are stored in ERProjectInvitee table (which is used for eReviews)
-- Report(s) using this query:
-- Citizen Access Login Administrative Report
-- =============================================

CREATE PROCEDURE [dbo].[rpt_CitizenAccessLoginInfo]

AS
BEGIN
	SET NOCOUNT ON;
	
SELECT ERProjectInvitee.ERProjectInviteeID, ERProjectInvitee.InviteDate, Users.CreatedOn
	, ERProjectInviteStatus.Name as InviteStatus
	, Users.ID AS LoginID, FName, MiddleName, LName, Company, email  


FROM ERProjectInvitee
	INNER JOIN ERProjectInviteStatus ON ERProjectInvitee.ERProjectInviteStatus = ERProjectInviteStatus.ERProjectInviteStatusID
	LEFT OUTER JOIN Users ON ERProjectInvitee.ExternalLoginID = Users.sUserGUID 
	--LEFT OUTER JOIN GlobalEntity ON Users.GlobalEntityID = GlobalEntity.GlobalEntityID 
	
END


