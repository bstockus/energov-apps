﻿CREATE PROCEDURE [inspection].[USP_INSPECTION_GETBYIDS]
(
	@INSPECTIONLIST RecordIDs READONLY,
	@USERID AS CHAR(36) = NULL
)
AS
BEGIN

	SELECT 
		[INSPECTIONSUMMARYINFO].[InspectionId], 
		[INSPECTIONSUMMARYINFO].[InspectionNumber], 
		[INSPECTIONSUMMARYINFO].[RequestedDate], 
		[INSPECTIONSUMMARYINFO].[ScheduleDate], 
		[INSPECTIONSUMMARYINFO].[Status], 
		[INSPECTIONSUMMARYINFO].[Type], 
		[INSPECTIONSUMMARYINFO].[AssignedInspectorFirstName], 
		[INSPECTIONSUMMARYINFO].[AssignedInspectorLastName], 
		[INSPECTIONSUMMARYINFO].[ParentCaseNumber], 
		[INSPECTIONSUMMARYINFO].[LastInspectionDate], 
		[INSPECTIONSUMMARYINFO].[ParentProject], 
		[INSPECTIONSUMMARYINFO].[ParentStatus], 
		[INSPECTIONSUMMARYINFO].[ParentInspectionNumber], 
		[INSPECTIONSUMMARYINFO].[ParentDescription], 
		[INSPECTIONSUMMARYINFO].[ContactFirstName], 
		[INSPECTIONSUMMARYINFO].[ContactLastName], 
		[INSPECTIONSUMMARYINFO].[ContactMiddleName], 
		[INSPECTIONSUMMARYINFO].[MainParcelNumber], 
		[INSPECTIONSUMMARYINFO].[LinkTypeName], 
		[INSPECTIONSUMMARYINFO].[AddressLine1], 
		[INSPECTIONSUMMARYINFO].[AddressLine2], 
		[INSPECTIONSUMMARYINFO].[AddressLine3], 
		[INSPECTIONSUMMARYINFO].[City], 
		[INSPECTIONSUMMARYINFO].[State], 
		[INSPECTIONSUMMARYINFO].[County], 
		[INSPECTIONSUMMARYINFO].[Country], 
		[INSPECTIONSUMMARYINFO].[CountryTypeId], 
		[INSPECTIONSUMMARYINFO].[PreDirection], 
		[INSPECTIONSUMMARYINFO].[PostDirection], 
		[INSPECTIONSUMMARYINFO].[UnitOrSuite], 
		[INSPECTIONSUMMARYINFO].[StreetType], 
		[INSPECTIONSUMMARYINFO].[PostalCode], 
		[INSPECTIONSUMMARYINFO].[CompSite], 
		[INSPECTIONSUMMARYINFO].[PoBox], 
		[INSPECTIONSUMMARYINFO].[RuralRoute], 
		[INSPECTIONSUMMARYINFO].[Station], 
		[INSPECTIONSUMMARYINFO].[Province], 
		[INSPECTIONSUMMARYINFO].[ParentSpatialCollection], 
		[INSPECTIONSUMMARYINFO].[ContactBusinesPhone], 
		[INSPECTIONSUMMARYINFO].[ContactPhoneHome], 
		[INSPECTIONSUMMARYINFO].[ContactMobilePhone], 
		[INSPECTIONSUMMARYINFO].[ContactOtherPhone], 
		[INSPECTIONSUMMARYINFO].[PreferredCommunicationId],
		[INSPECTIONSUMMARYINFO].[LinkType]
	FROM [inspection].[INSPECTIONSUMMARYINFO]
	INNER JOIN @INSPECTIONLIST INSPECTIONLIST ON [INSPECTIONSUMMARYINFO].[InspectionId] = INSPECTIONLIST.RECORDID
	LEFT OUTER JOIN RECENTHISTORYINSPECTION ON RECENTHISTORYINSPECTION.INSPECTIONID = [INSPECTIONSUMMARYINFO].[InspectionId] AND RECENTHISTORYINSPECTION.USERID = @USERID
	ORDER BY RECENTHISTORYINSPECTION.LOGGEDDATETIME DESC


END