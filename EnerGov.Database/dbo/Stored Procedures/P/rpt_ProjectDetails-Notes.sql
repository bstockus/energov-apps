
-- =============================================
-- Author:		<Kyong Hwangbo, EnerGov Solutions>	
-- Create date: <10/1/2010>
-- Description:	<Created as a script to pull all notes for a project;
-- Report(s) using this query:
-- ProjectDetails.rpt
-- =============================================

CREATE PROCEDURE [dbo].[rpt_ProjectDetails-Notes]
AS
BEGIN
	SET NOCOUNT ON;
-- Notes Info
SELECT PRProjectNote.PRProjectID, PRProjectNote.Text AS NoteText, PRProjectNote.CreatedDate AS NoteCreatedDate, Users.FName, Users.LName
FROM PRProjectNote 
	LEFT OUTER JOIN Users ON PRProjectNote.CreatedBy = Users.sUserGUID 
END

