﻿CREATE PROCEDURE [inspectiondashboard].[USP_PARCEL_SELECT_FOR_PARCEL_ID]
(
	@ID CHAR(36),
	@NUMBER NVARCHAR(50)
)
AS

SET NOCOUNT ON;

SELECT TOP 1
	[dbo].[PARCEL].[PARCELID], 
	[dbo].[PARCEL].[PARCELNUMBER], 
	[dbo].[PARCEL].[ADDITION], 
	[dbo].[PARCEL].[BLOCK], 
	[dbo].[PARCEL].[LOT], 
	[dbo].[PARCEL].[SECTION], 
	[dbo].[PARCEL].[TOWNSHIP], 
	[dbo].[PARCEL].[RANGE], 
	[dbo].[PARCEL].[LEGALDESCRIPTION], 
	[dbo].[PARCEL].[DIRECTIONS], 
	[dbo].[PARCEL].[GISX], 
	[dbo].[PARCEL].[GISY], 
	[dbo].[PARCEL].[TAXNUMBER], 
	[dbo].[PARCEL].[IMPNAMEKEY], 
	[dbo].[PARCEL].[IMPADDKEY], 
	[dbo].[PARCEL].[NAME1], 
	[dbo].[PARCEL].[NAME2], 
	[dbo].[PARCEL].[ADDRESSLINE1], 
	[dbo].[PARCEL].[ADDRESSLINE2], 
	[dbo].[PARCEL].[CITY], 
	[dbo].[PARCEL].[STATE], 
	[dbo].[PARCEL].[POSTALCODE], 
	[dbo].[PARCEL].[TRACT], 
	[dbo].[PARCEL].[SUBDIVISION], 
	[dbo].[PARCEL].[JURISDICTION], 
	[dbo].[PARCEL].[INSPECTIONZONEID], 
	[dbo].[PARCEL].[STATUSID], 
	[dbo].[PARCEL].[ACTIVE], 
	[dbo].[PARCEL].[ADDRESSLINE3], 
	[dbo].[PARCEL].[GCUSTOMFIELDLAYOUTS], 
	[dbo].[PARCEL].[PROVINCE], 
	[dbo].[PARCEL].[RURALROUTE], 
	[dbo].[PARCEL].[STATION], 
	[dbo].[PARCEL].[COMPSITE], 
	[dbo].[PARCEL].[POBOX], 
	[dbo].[PARCEL].[ATTN], 
	[dbo].[PARCEL].[GENERALDELIVERY], 
	[dbo].[PARCEL].[LASTCHANGEDON], 
	[dbo].[PARCEL].[LASTCHANGEDBY], 
	[dbo].[PARCEL].[ROWVERSION]
FROM [dbo].[PARCEL]
WHERE [dbo].[PARCEL].[PARCELID] = @ID OR [dbo].[PARCEL].[PARCELNUMBER] = @NUMBER