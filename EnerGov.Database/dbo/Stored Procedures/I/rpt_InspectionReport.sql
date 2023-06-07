

-- =============================================
-- Author:		<Kyong Hwangbo, EnerGov Solutions>	
-- Create date: <9/24/2010>
-- Description:	<Created as a script to pull inspection information;
-- There must be a Main Parcel & Main Address associated with the inspection;
-- Report(s) using this query:
-- InspectionReport.rpt
-- =============================================

CREATE PROCEDURE [dbo].[rpt_InspectionReport]

AS
BEGIN
	SET NOCOUNT ON;

SELECT IMInspection.IMInspectionID, IMInspection.InspectionNumber, IMInspectionType.Name AS InspectionType, IMInspectionStatus.StatusName
	, IMInspection.CreateDate, ScheduledStartDate, ActualStartDate
	, Reinspected, IsReinspection
	, IMInspectionNote.CreatedDate AS NoteCreatedDate, Users.FName AS NoteCreatedByFName, Users.LName AS NoteCreatedByLName, IMInspectionNote.Text AS NoteText
	, IMInspectionLink.Name AS Module, LinkNumber
	, Parcel.ParcelNumber 
	, MailingAddress.AddressLine1, MailingAddress.PreDirection, MailingAddress.AddressLine2, MailingAddress.StreetType, MailingAddress.PostDirection
	, MailingAddress.AddressLine3, MailingAddress.City, MailingAddress.State, MailingAddress.PostalCode

FROM IMInspection 
	INNER JOIN IMInspectionType ON IMInspection.IMInspectionTypeID = IMInspectionType.IMInspectionTypeID
	INNER JOIN IMInspectionStatus ON IMInspection.IMInspectionStatusID = IMInspectionStatus.IMInspectionStatusID
	INNER JOIN IMInspectionLink ON IMInspection.IMInspectionLinkID = IMInspectionLink.IMInspectionLinkID
	
	LEFT OUTER JOIN IMInspectionNote ON IMInspection.IMInspectionID = IMInspectionNote.IMInspectionID 
	LEFT OUTER JOIN Users ON IMInspectionNote.CreatedBy = Users.sUserGUID 
	
	LEFT OUTER JOIN IMInspectionParcel ON IMInspection.IMInspectionID = IMInspectionParcel.IMInspectionID 
	LEFT OUTER JOIN Parcel ON IMInspectionParcel.ParcelID = Parcel.ParcelID 
	LEFT OUTER JOIN IMInspectionAddress ON IMInspection.IMInspectionID = IMInspectionAddress.IMInspectionID
	LEFT OUTER JOIN MailingAddress ON IMInspectionAddress.MailingAddressID = MailingAddress.MailingAddressID 

--WHERE IMInspectionParcel.Main = 'TRUE'
order by InspectionNumber 

END


