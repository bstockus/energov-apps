






-- =============================================
-- Author:		<Kyong Hwangbo, EnerGov Solutions>	
-- Create date: <9/23/2010>
-- Description:	<Created as a script to pull all checklist items for an inspection;
-- Report(s) using this query:
-- PermitCard.rpt
-- Inspection Report.rpt
-- =============================================

CREATE PROCEDURE [dbo].[rpt_Inspection-Checklist]

AS
BEGIN
	SET NOCOUNT ON;

SELECT IMInspectionChecklistxRef.IMInspectionID, IMCheckListCategory.Name AS ChecklistCategory, IMChecklist.Name AS Checklist, OrderNum, Passed, Comments 

FROM IMInspectionChecklistxRef 
	INNER JOIN IMChecklist ON IMInspectionChecklistxRef.IMChecklistID = IMChecklist.IMChecklistID 
	INNER JOIN IMCheckListCategory ON IMChecklist.IMCheckListCategoryID = IMCheckListCategory.IMCheckListCategoryID 
	

END





